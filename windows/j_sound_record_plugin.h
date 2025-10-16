#ifndef FLUTTER_PLUGIN_J_SOUND_RECORD_PLUGIN_H_
#define FLUTTER_PLUGIN_J_SOUND_RECORD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace j_sound_record {

class JSoundRecordPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  JSoundRecordPlugin();

  virtual ~JSoundRecordPlugin();

  // Disallow copy and assign.
  JSoundRecordPlugin(const JSoundRecordPlugin&) = delete;
  JSoundRecordPlugin& operator=(const JSoundRecordPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace j_sound_record

#endif  // FLUTTER_PLUGIN_J_SOUND_RECORD_PLUGIN_H_
