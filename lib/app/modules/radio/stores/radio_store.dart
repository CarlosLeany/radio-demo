
import 'package:mobx/mobx.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

part 'radio_store.g.dart';
const String defaultUrl = 'https://playerservices.streamtheworld.com/api/livestream-redirect/98FM_CWBAAC.aac?dist=site';


class RadioStore = RadioStoreBase with _$RadioStore;

abstract class RadioStoreBase with Store {
  final player = AudioPlayer();

  @observable
  bool isPlaying = false;

  @observable
  String? currentUrl;

  @observable
  ProcessingState processingState = ProcessingState.idle;

  @observable
  PlayerState? lastPlayerState;

  @observable
  String? errorMessage;

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
  Future<void> play([String url = defaultUrl]) async {
    try {
      errorMessage = null;
      
      if (currentUrl != url) {
        currentUrl = url;

        // Alguns servidores gostam de um User-Agent "real"
        final src = AudioSource.uri(
          Uri.parse(url),
          headers: const {
            'User-Agent': 'FlutterRadio/1.0 (just_audio)',
            // Solicita ICY metadata (se disponível)
            'Icy-MetaData': '1',
          },
        );

        await player.setAudioSource(src, preload: true);
      }
      
      await player.play();
    } catch (e) {
      errorMessage = 'Erro ao tocar rádio: $e';
      rethrow;
    }
  }

  @action
  Future<void> pause() => player.pause();

  @action
  Future<void> stop() async {
    await player.stop();
    isPlaying = false;
  }

  Future<void> dispose() async {
    await player.dispose();
  }
}
