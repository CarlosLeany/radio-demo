
import 'package:mobx/mobx.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/radio_station.dart';
import '../data/radio_stations.dart';

part 'radio_store.g.dart';


class RadioStore = RadioStoreBase with _$RadioStore;

abstract class RadioStoreBase with Store {
  final player = AudioPlayer();

  @observable
  bool isPlaying = false;

  @observable
  RadioStation? currentStation;

  @observable
  ProcessingState processingState = ProcessingState.idle;

  @observable
  PlayerState? lastPlayerState;

  @observable
  String? errorMessage;

  @computed
  String? get currentUrl {
    try {
      return currentStation?.url;
    } catch (e) {
      return null;
    }
  }

  RadioStoreBase() {
    // Liga reações aos streams do just_audio
    player.playingStream.listen((v) => isPlaying = v);
    player.playerStateStream.listen((s) {
      lastPlayerState = s;
      processingState = s.processingState;
    });
    
    // Escuta erros do player
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.idle && 
          state.playing == false && 
          currentUrl != null) {
        // Possível erro - vamos tentar detectar
        // Debug: Player state: $state
      }
    });
  }

  @action
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  @action
  Future<void> playStation(RadioStation station) async {
    try {
      errorMessage = null;
      
      // Sempre para a rádio atual antes de trocar
      if (isPlaying) {
        await player.stop();
      }
      
      // Sempre configura a nova fonte, mesmo se for a mesma rádio
      currentStation = station;

      // Alguns servidores gostam de um User-Agent "real"
      final src = AudioSource.uri(
        Uri.parse(station.url),
        headers: const {
          'User-Agent': 'FlutterRadio/1.0 (just_audio)',
          // Solicita ICY metadata (se disponível)
          'Icy-MetaData': '1',
        },
      );

      await player.setAudioSource(src, preload: true);
      await player.play();
    } catch (e) {
      errorMessage = 'Erro ao tocar ${station.name}: $e';
      rethrow;
    }
  }

  @action
  Future<void> play() async {
    if (currentStation == null) {
      await playStation(RadioStations.defaultStation);
    } else {
      await playStation(currentStation!);
    }
  }

  @action
  Future<void> pause() => player.pause();

  @action
  Future<void> stop() async {
    await player.stop();
    isPlaying = false;
  }

  @action
  Future<void> testStation(RadioStation station) async {
    try {
      errorMessage = null;
      
      // Para a rádio atual se estiver tocando
      if (isPlaying) {
        await player.stop();
      }
      
      // Testa a URL sem tocar
      final src = AudioSource.uri(
        Uri.parse(station.url),
        headers: const {
          'User-Agent': 'FlutterRadio/1.0 (just_audio)',
          'Icy-MetaData': '1',
        },
      );

      await player.setAudioSource(src, preload: false);
      errorMessage = 'URL da ${station.name} é válida!';
    } catch (e) {
      errorMessage = 'Erro ao testar ${station.name}: $e';
    }
  }

  @action
  Future<void> nextStation() async {
    final stations = RadioStations.stations;
    if (stations.isEmpty) return;
    
    int currentIndex = 0;
    if (currentStation != null) {
      currentIndex = stations.indexWhere((s) => s.id == currentStation!.id);
      if (currentIndex == -1) currentIndex = 0;
    }
    
    int nextIndex = (currentIndex + 1) % stations.length;
    await playStation(stations[nextIndex]);
  }

  @action
  Future<void> previousStation() async {
    final stations = RadioStations.stations;
    if (stations.isEmpty) return;
    
    int currentIndex = 0;
    if (currentStation != null) {
      currentIndex = stations.indexWhere((s) => s.id == currentStation!.id);
      if (currentIndex == -1) currentIndex = 0;
    }
    
    int previousIndex = (currentIndex - 1 + stations.length) % stations.length;
    await playStation(stations[previousIndex]);
  }

  Future<void> dispose() async {
    await player.dispose();
  }
}
