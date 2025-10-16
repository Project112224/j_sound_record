import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/amplitude.dart';
import 'enum/audio_encoder_type.dart';
import 'j_sound_record_method_channel.dart';

abstract class JSoundRecordPlatform extends PlatformInterface {
  /// Constructs a JSoundRecordPlatform.
  JSoundRecordPlatform() : super(token: _token);

  static final Object _token = Object();

  static JSoundRecordPlatform _instance = MethodChannelJSoundRecord();

  /// The default instance of [JSoundRecordPlatform] to use.
  ///
  /// Defaults to [MethodChannelJSoundRecord].
  static JSoundRecordPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JSoundRecordPlatform] when
  /// they register themselves.
  static set instance(JSoundRecordPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> start({
    String? path,
    AudioEncoder encoder = AudioEncoder.AAC,
    int bitRate = 128000,
    double samplingRate = 44100.0,
  });


  /// Stops recording session and release internal recorder resource.
  /// Returns the output path.
  Future<String?> stop();

  /// Pauses recording session.
  ///
  /// Note: Usable on Android API >= 24(Nougat). Does nothing otherwise.
  Future<void> pause();

  /// Resumes recording session after [pause].
  ///
  /// Note: Usable on Android API >= 24(Nougat). Does nothing otherwise.
  Future<void> resume();

  /// Checks if there's valid recording session.
  /// So if session is paused, this method will still return [bool.true].
  Future<bool> isRecording();

  /// Checks if recording session is paused.
  Future<bool> isPaused();

  /// Checks and requests for audio record permission.
  Future<bool> hasPermission();

  /// Dispose the recorder
  Future<void> dispose();

  /// Gets current average & max amplitudes
  /// Always returns zeros on web platform
  Future<Amplitude> getAmplitude();
}
