import 'dart:isolate';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});
  // something difficult operation
  int _loadData(counter) {
    int value = 0;

    for (var i = 0; i < counter; i++)
      value++;
    debugPrint('Data Processed  $value');
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 180),
            const CircularProgressIndicator(),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                _loadData(900000000);
              },
              child: const Text('Process start without Isolate'),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                isolateFunction(800000000);
              },
              child: const Text('Process start with Isolate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> isolateFunction(final int value) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(ranTask, [receivePort.sendPort, value]);
    } catch (e) {
      debugPrint('Isolate Failed: $e');
      receivePort.close();
      return;
    }

    final res = await receivePort.first;
    debugPrint('Data Processed  $res');
  }

  // something difficult operation
  int ranTask(List<dynamic> args) {
    final resultPort = args[0];
    int value = 0;

    for (var i = 0; i < args[1]; i++)
      value++;

    Isolate.exit(resultPort, value);
  }
}



