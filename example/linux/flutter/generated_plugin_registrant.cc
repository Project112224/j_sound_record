//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <j_sound_record/j_sound_record_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) j_sound_record_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "JSoundRecordPlugin");
  j_sound_record_plugin_register_with_registrar(j_sound_record_registrar);
}
