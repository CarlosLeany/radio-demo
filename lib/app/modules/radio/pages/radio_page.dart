import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/radio_store.dart';
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
      appBar: AppBar(title: const Text('Rádio – 98FM')),
      body: Center(
        child: Observer(
          builder: (_) {
            final isBuffering = store.processingState == ProcessingState.loading ||
                store.processingState == ProcessingState.buffering;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isBuffering) const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
                Text(
                  store.isPlaying ? 'Ao vivo' : 'Parado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (store.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      store.errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Estado: ${store.processingState}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (store.currentUrl != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'URL: ${store.currentUrl!.substring(0, 50)}...',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
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
                const SizedBox(height: 16),
                const Text('Testar URLs alternativas:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: store.isPlaying ? null : () => store.play('https://playerservices.streamtheworld.com/api/livestream-redirect/98FM_CWBAAC.aac?dist=site'),
                      child: const Text('98FM'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
