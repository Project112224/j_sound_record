// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:j_sound_record/model/amplitude.dart';
import 'package:j_sound_record/enum/audio_encoder_type.dart';

import 'j_sound_record_platform_interface.dart';

/// A web implementation of the JSoundRecordPlatform of the JSoundRecord plugin.
class JSoundRecordWeb extends JSoundRecordPlatform {
  /// Constructs a JSoundRecordWeb
  JSoundRecordWeb();

  static void registerWith(Registrar registrar) {
    JSoundRecordPlatform.instance = JSoundRecordWeb();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<Amplitude> getAmplitude() {
    // TODO: implement getAmplitude
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPermission() {
    // TODO: implement hasPermission
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

  @override
  Future<void> start({
    String? path,
    AudioEncoder encoder = AudioEncoder.AAC,
    int bitRate = 128000,
    double samplingRate = 44100.0,
  }) {
    // TODO: implement start
    throw UnimplementedError();
  }

  @override
  Future<String?> stop() {
    // TODO: implement stop
    throw UnimplementedError();
  }
}
