import 'package:flutter_test/flutter_test.dart';
import 'package:j_sound_record/j_sound_record.dart';
import 'package:j_sound_record/j_sound_record_platform_interface.dart';
import 'package:j_sound_record/j_sound_record_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockJSoundRecordPlatform
//     with MockPlatformInterfaceMixin
//     implements JSoundRecordPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final JSoundRecordPlatform initialPlatform = JSoundRecordPlatform.instance;
//
//   test('$MethodChannelJSoundRecord is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelJSoundRecord>());
//   });
//
//   test('getPlatformVersion', () async {
//     JSoundRecord jSoundRecordPlugin = JSoundRecord();
//     MockJSoundRecordPlatform fakePlatform = MockJSoundRecordPlatform();
//     JSoundRecordPlatform.instance = fakePlatform;
//
//     // expect(await jSoundRecordPlugin.getPlatformVersion(), '42');
//   });
// }
