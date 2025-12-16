// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "nertc_wrapper.h"
#if _WIN32
#include <nertc_engine_ex.h>
#include <nertc_engine_event_handler_ex.h>
#include <nertc_engine_defines.h>
#else
#include <nertc_sdk_Mac/nertc_engine.h>
#include <nertc_sdk_Mac/nertc_engine_event_handler_ex.h>
#include <nertc_sdk_Mac/nertc_engine_defines.h>
#endif
#include <iostream>
#include "engine_wrapper.h"
#include "logic/convert.h"

using namespace nertc;
using namespace nlohmann;

extern "C" {

FFI_PLUGIN_EXPORT int64_t InvokeMethod(const char* params) {
  printf("InvokeMethod: %s\n", params);

  json parse_result = json::parse(params, nullptr, false);
  if (parse_result.is_null()) return kNERtcErrFatal;

  if (!IsContainsValue(parse_result, "isChannel") ||
      !parse_result["isChannel"].get<bool>()) {
    return NERtcDesktopWrapper::ShareInstance()->HandleMethodCall(parse_result);
  }

  std::string channel_tag = parse_result["channelTag"].get<std::string>();
  std::shared_ptr<NERtcChannelWrapper> channel_wrapper =
      NERtcDesktopWrapper::ShareInstance()->GetChannelWrapper(channel_tag);
  if (!channel_wrapper) {
    return kNERtcErrFatal;
  }

  return channel_wrapper->HandleMethodCall(parse_result);
}

FFI_PLUGIN_EXPORT const char* InvokeStrMethod(const char* params) {
  printf("InvokeMethod: %s\n", params);

  json parse_result = json::parse(params, nullptr, false);
  if (parse_result.is_null()) return nullptr;

  std::string result = std::string();
  if (!IsContainsValue(parse_result, "isChannel") ||
      !parse_result["isChannel"].get<bool>()) {
    result =
        NERtcDesktopWrapper::ShareInstance()->HandleMethodCallStr(parse_result);
  } else {
    std::string channel_tag = parse_result["channelTag"].get<std::string>();
    std::shared_ptr<NERtcChannelWrapper> channel_wrapper =
        NERtcDesktopWrapper::ShareInstance()->GetChannelWrapper(channel_tag);
    if (channel_wrapper) {
      result = channel_wrapper->HandleMethodCallStr(parse_result);
    }
  }

  if (result.empty()) {
    printf("InvokeStrMethod result is empty.\n");
    return nullptr;
  }

  // 修复：使用 malloc 代替 new[]，与 Dart 端的 malloc.free 匹配
  char* c_result = static_cast<char*>(malloc(result.size() + 1));
  if (c_result == nullptr) {
    printf("InvokeStrMethod: Memory allocation failed.\n");
    return nullptr;
  }

  std::strcpy(c_result, result.c_str());
  printf("InvokeStrMethod result: %s\n", c_result);
  return c_result;
}

FFI_PLUGIN_EXPORT void CallDartMethod(DartCallback callback) {
  printf("c CallDartMethod callback: %p\n", callback);
  NERtcDesktopWrapper::ShareInstance()->RegisterDartCallback(callback);
}

FFI_PLUGIN_EXPORT intptr_t InitDartApiDL(void* data) {
  printf("init data api dl.\n");
  return Dart_InitializeApiDL(data);
}

FFI_PLUGIN_EXPORT void RegisterNativePort(Dart_Port port) {
  printf("register native port.\n");
  NERtcDesktopWrapper::ShareInstance()->RegisterDartSendPort(port);
}

FFI_PLUGIN_EXPORT int64_t PushVideoFrame(const char* params,
                                         const uint8_t* data,
                                         const double* matrix) {
  json parse_result = json::parse(params, nullptr, false);
  if (parse_result.is_null()) {
    return kNERtcErrInvalidParam;
  }

  if (!IsContainsValue(parse_result, "isChannel") ||
      !parse_result["isChannel"].get<bool>()) {
    return NERtcDesktopWrapper::ShareInstance()->HandlePushVideoFrame(
        parse_result, data, matrix);
  }

  if (!IsContainsValue(parse_result, "channelTag")) {
    return kNERtcErrInvalidParam;
  }

  std::string channel_tag = parse_result["channelTag"].get<std::string>();
  std::shared_ptr<NERtcChannelWrapper> channel_wrapper =
      NERtcDesktopWrapper::ShareInstance()->GetChannelWrapper(channel_tag);
  if (nullptr == channel_wrapper) {
    return kNERtcErrFatal;
  }
  return channel_wrapper->HandlePushVideoFrame(parse_result, data, matrix);
}

FFI_PLUGIN_EXPORT int64_t PushDataFrame(const char* params,
                                        const uint8_t* data) {
  return NERtcDesktopWrapper::ShareInstance()->HandlePushDataFrame(params,
                                                                   data);
}

FFI_PLUGIN_EXPORT int64_t PushAudioFrame(const char* params,
                                         const uint8_t* data) {
  return NERtcDesktopWrapper::ShareInstance()->HandlePushAudioFrame(params,
                                                                    data);
}
}
