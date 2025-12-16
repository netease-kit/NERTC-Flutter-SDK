// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef VIDEO_VIEW_CONTROLLER_H_
#define VIDEO_VIEW_CONTROLLER_H_

#ifdef _WIN32
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <flutter/texture_registrar.h>
#include "nertc_engine_ex.h"
#else
#include <nertc_sdk_Mac/nertc_engine_ex.h>
#endif
#include "texture_render.h"

#include <map>
#include <mutex>

class VideoViewController {
 public:
  static VideoViewController* instance_;
  static std::mutex instance_mutex_;
#ifdef _WIN32
  flutter::BinaryMessenger* messenger_;
  flutter::TextureRegistrar* texture_registrar_;
#endif
  std::map<int64_t, TextureRender*> renderers_;
  std::mutex renderers_mutex_;  // Mutex for protecting renderers_ map

  // Private constructor for singleton
#ifdef _WIN32
  VideoViewController(flutter::TextureRegistrar* texture_registrar,
                      flutter::BinaryMessenger* messenger_);
#else
  VideoViewController();
#endif

#ifdef _WIN32
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
#endif

  int64_t CreatePlatformRender();

  bool DestroyPlatformRender(int64_t platformRenderId);

  int64_t CreateTextureRender(nertc::IRtcEngineEx* engine);
  void SetChannelTag(int64_t textureId, const std::string& channel_tag);

  bool DestroyTextureRender(int64_t textureId);

  void SetupCanvas(int64_t textureId, nertc::uid_t uid,
                   nertc::NERtcVideoScalingMode scaling_mode,
                   nertc::NERtcVideoMirrorMode mirror_mode,
                   uint32_t background_color,
                   nertc::NERtcVideoStreamType stream_type);

  void SetupSubChannelCanvas(int64_t textureId, nertc::uid_t uid,
                             nertc::NERtcVideoScalingMode scaling_mode,
                             nertc::NERtcVideoMirrorMode mirror_mode,
                             uint32_t background_color,
                             nertc::NERtcVideoStreamType stream_type);

  void SetupPlayStreamingCanvas(int64_t textureId, const char* stream_id,
                                nertc::NERtcVideoScalingMode scaling_mode,
                                nertc::NERtcVideoMirrorMode mirror_mode,
                                uint32_t background_color,
                                nertc::NERtcVideoStreamType stream_type);

  void Dispose();

 public:
  // Singleton access methods
#ifdef _WIN32
  static VideoViewController* GetInstance(
      flutter::TextureRegistrar* texture_registrar = nullptr,
      flutter::BinaryMessenger* messenger = nullptr);
#else
  static VideoViewController* GetInstance();
#endif

  static void DestroyInstance();

  // Delete copy constructor and assignment operator
  VideoViewController(const VideoViewController&) = delete;
  VideoViewController& operator=(const VideoViewController&) = delete;

  virtual ~VideoViewController();
};

// 在文件末尾添加外部函数声明（仅在 Apple 平台）
#ifdef __APPLE__
extern "C" {
void NotifyTextureDestroyed(int64_t textureId);
void NotifyAllTexturesDestroyed(void);
void SetVideoViewBridgeDelegate(void* plugin);
}
#endif

#endif  // VIDEO_VIEW_CONTROLLER_H_