#include "include/j_sound_record/j_sound_record_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "j_sound_record_plugin.h"

void JSoundRecordPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  j_sound_record::JSoundRecordPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
