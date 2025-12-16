// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLUTTER_PLUGIN_NERTC_CORE_PLUGIN_H_
#define FLUTTER_PLUGIN_NERTC_CORE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace nertc_core {

class NertcCorePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  NertcCorePlugin(flutter::PluginRegistrarWindows* registrar);

  virtual ~NertcCorePlugin();

  // Disallow copy and assign.
  NertcCorePlugin(const NertcCorePlugin&) = delete;
  NertcCorePlugin& operator=(const NertcCorePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace nertc_core

#endif  // FLUTTER_PLUGIN_NERTC_CORE_PLUGIN_H_
