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
    final bool? result = await methodChannel.invokeMethod<bool>('hasPermission');
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

  @override
  Future<Amplitude> getAmplitude() {
    // TODO: implement getAmplitude
    throw UnimplementedError();
  }

  @override
  Future<bool> isPaused() {
    // TODO: implement isPaused
    throw UnimplementedError();
  }

  @override
  Future<bool> isRecording() {
    // TODO: implement isRecording
    throw UnimplementedError();
  }

  @override
  Future<void> pause() {
    // TODO: implement pause
    throw UnimplementedError();
  }

  @override
  Future<void> resume() {
    // TODO: implement resume
    throw UnimplementedError();
  }
}
