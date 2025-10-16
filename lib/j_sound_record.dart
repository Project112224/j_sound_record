import 'enum/audio_encoder_type.dart';
import 'j_sound_record_platform_interface.dart';
import 'model/amplitude.dart';

class JSoundRecord {
  Future<bool> hasPermission() async =>
      await JSoundRecordPlatform.instance.hasPermission();

  Future<void> start({
    String? path,
    AudioEncoder encoder = AudioEncoder.AAC,
    // if encoder is ALAC then not work
    int bitRate = 128000,
    double samplingRate = 44100.0,
  }) async => await JSoundRecordPlatform.instance.start(
    path: path,
    encoder: encoder,
    bitRate: bitRate,
    samplingRate: samplingRate,
  );

  Future<String?> stop() async => await JSoundRecordPlatform.instance.stop();

  Future<void> dispose() async => await JSoundRecordPlatform.instance.dispose();

  Future<void> pause() async => await JSoundRecordPlatform.instance.pause();

  Future<void> resume() async => await JSoundRecordPlatform.instance.resume();

  Future<bool> isRecording() async =>
      await JSoundRecordPlatform.instance.isRecording();

  Future<bool> isPaused() async =>
      await JSoundRecordPlatform.instance.isPaused();

  Future<Amplitude> getAmplitude() async =>
      await JSoundRecordPlatform.instance.getAmplitude();
}
