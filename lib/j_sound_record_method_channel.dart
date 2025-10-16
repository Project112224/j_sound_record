import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:j_sound_record/enum/audio_encoder_type.dart';

import 'j_sound_record_platform_interface.dart';
import 'model/amplitude.dart';

/// An implementation of [JSoundRecordPlatform] that uses method channels.
class MethodChannelJSoundRecord extends JSoundRecordPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('j_sound_record');

  @override
  Future<bool> hasPermission() async {
    final bool? result = await methodChannel.invokeMethod<bool>(
      'hasPermission',
    );
    return result ?? false;
  }

  @override
  Future<void> start({
    String? path,
    AudioEncoder encoder = AudioEncoder.AAC,
    int bitRate = 128000,
    double samplingRate = 44100.0,
  }) {
    return methodChannel.invokeMethod('start', <dynamic, dynamic>{
      'path': path,
      'encoder': encoder.index,
      'bitRate': bitRate,
      'samplingRate': samplingRate,
    });
  }

  @override
  Future<String?> stop() {
    return methodChannel.invokeMethod('stop');
  }

  @override
  Future<void> dispose() async {
    await methodChannel.invokeMethod('dispose');
  }

  // Wav not work
  @override
  Future<Amplitude> getAmplitude() async =>
      await methodChannel.invokeMethod('getAmplitude');

  // Wav not work
  @override
  Future<bool> isPaused() async => await methodChannel.invokeMethod('pause');

  @override
  Future<bool> isRecording() async =>
      await methodChannel.invokeMethod('isRecording');

  // Wav not work
  @override
  Future<void> pause() async => await methodChannel.invokeMethod('isPaused');

  @override
  Future<void> resume() async => await methodChannel.invokeMethod('resume');
}
