// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

#include "dart/dart_api_dl.h"

#ifdef __cplusplus
extern "C" {
#endif
FFI_PLUGIN_EXPORT int64_t InvokeMethod(const char* params);
FFI_PLUGIN_EXPORT const char* InvokeStrMethod(const char* params);
FFI_PLUGIN_EXPORT int64_t PushVideoFrame(const char* params,
                                         const uint8_t* data,
                                         const double* matrix);

FFI_PLUGIN_EXPORT int64_t PushDataFrame(const char* params,
                                        const uint8_t* data);
FFI_PLUGIN_EXPORT int64_t PushAudioFrame(const char* params,
                                         const uint8_t* data);

// sync callback.
typedef void (*DartCallback)(const char* message);
FFI_PLUGIN_EXPORT void CallDartMethod(DartCallback callback);
// async callback.
FFI_PLUGIN_EXPORT intptr_t InitDartApiDL(void* data);
FFI_PLUGIN_EXPORT void RegisterNativePort(Dart_Port port);
#ifdef __cplusplus
}
#endif
