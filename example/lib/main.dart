import 'package:flutter/material.dart';
import 'package:j_sound_record/enum/audio_encoder_type.dart';
import 'package:j_sound_record/j_sound_record.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final soundRecord = JSoundRecord();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final hasPermission = await soundRecord.hasPermission();
        debugPrint('j_sound_record >> permission : $hasPermission');
      } catch (ex) {
        debugPrint('j_sound_record >> permission error : $ex');
      }
    });
  }

  @override
  void dispose() {
    soundRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => soundRecord.start(encoder: AudioEncoder.ALAC),
                child: Text('start'),
              ),
              TextButton(
                onPressed: () async {
                  final path = await soundRecord.stop();
                  print('>>> path: $path');
                },
                child: Text('stop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
