import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_sound_record/j_sound_record_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelJSoundRecord platform = MethodChannelJSoundRecord();
  const MethodChannel channel = MethodChannel('j_sound_record');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    // expect(await platform.getPlatformVersion(), '42');
  });
}
