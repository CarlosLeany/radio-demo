import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/radio_store.dart';
import '../data/radio_stations.dart';
import 'package:just_audio/just_audio.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final store = RadioStore();

  @override
  void initState() {
    super.initState();
    store.init();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Melhores Rádios')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(
            builder: (_) {
              try {
                final isBuffering = store.processingState == ProcessingState.loading ||
                    store.processingState == ProcessingState.buffering;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // Botões de navegação no início
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: store.previousStationDebounced,
                      icon: const Icon(Icons.skip_previous),
                      label: const Text('Anterior'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: store.nextStationDebounced,
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Próxima'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isBuffering) const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
                Text(
                  store.isPlaying ? 'Ao vivo' : 'Parado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (store.selectedStation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    store.selectedStation!.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (store.selectedStation!.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      store.selectedStation!.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
                const SizedBox(height: 8),
                // Mostra o status da estação atual vs selecionada
                if (store.currentStation != store.selectedStation) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Carregando ${store.selectedStation!.name}...',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  'Estado: ${store.processingState}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (store.currentUrl != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      store.currentUrl!.length > 60 
                        ? '${store.currentUrl!.substring(0, 60)}...' 
                        : store.currentUrl!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: store.isPlaying ? null : () => store.play(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: store.isPlaying ? store.pause : null,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: store.stop,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Rádios Disponíveis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ...RadioStations.stations.map((station) => 
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Card(
                      child: ListTile(
                        title: Text(station.name),
                        subtitle: station.description != null 
                          ? Text(station.description!) 
                          : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => store.playStationDebounced(station),
                              tooltip: 'Tocar ${station.name}',
                            ),
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: () => store.testStation(station),
                              tooltip: 'Testar ${station.name}',
                            ),
                            // Mostra o status da estação
                            if (store.currentStation == station && store.isPlaying)
                              const Icon(Icons.volume_up, color: Colors.green)
                            else if (store.selectedStation == station && store.currentStation != station)
                              const Icon(Icons.schedule, color: Colors.orange)
                            else if (store.currentStation == station && store.processingState == ProcessingState.loading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              const Icon(Icons.radio),
                          ],
                        ),
                        selected: store.selectedStation == station,
                        onTap: () => store.playStationDebounced(station),
                      ),
                    ),
                  ),
                                ),
                const SizedBox(height: 32), // Espaço extra no final para melhor scroll
              ],
            );
              } catch (e) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erro na interface: $e'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
