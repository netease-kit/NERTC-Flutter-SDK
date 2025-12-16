// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef TEXTURE_RENDER_H_
#define TEXTURE_RENDER_H_

#ifdef _WIN32
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <flutter/texture_registrar.h>
#include "nertc_engine_ex.h"
#else
#include <nertc_sdk_Mac/nertc_engine_ex.h>
#endif
#include <map>
#include <mutex>

class TextureRender {
 public:
#ifdef _WIN32
  TextureRender(flutter::BinaryMessenger* messenger,
                flutter::TextureRegistrar* registrar,
                nertc::IRtcEngineEx* engine);
#else
  TextureRender(nertc::IRtcEngineEx* engine);
#endif
  virtual ~TextureRender();

  int64_t texture_id();

  void UpdateFrameData(nertc::uid_t uid, void* data, uint32_t type,
                       uint32_t width, uint32_t height, uint32_t count,
                       uint32_t offset[4], uint32_t stride[4],
                       uint32_t rotation);

  void SetupCanvas(nertc::uid_t uid, nertc::NERtcVideoScalingMode scaling_mode,
                   nertc::NERtcVideoMirrorMode mirror_mode,
                   uint32_t background_color,
                   nertc::NERtcVideoStreamType stream_type);

  void SetupPlayStreamingCanvas(const char* stream_id,
                                nertc::NERtcVideoScalingMode scaling_mode,
                                nertc::NERtcVideoMirrorMode mirror_mode,
                                uint32_t background_color,
                                nertc::NERtcVideoStreamType stream_type);

  void SetChannelTag(const std::string& channel_tag) {
    channel_tag_ = channel_tag;
  }

  void SetupSubChannelCavans(nertc::uid_t uid,
                             nertc::NERtcVideoScalingMode scaling_mode,
                             nertc::NERtcVideoMirrorMode mirror_mode,
                             uint32_t background_color,
                             nertc::NERtcVideoStreamType stream_type);

  // Checks if texture registrar, texture id and texture are available.
  bool TextureRegistered() {
#ifdef _WIN32
    return registrar_ && texture_ && texture_id_ > -1;
#endif
    return texture_id_ > -1;
  }

  void Dispose();

 private:
#ifdef _WIN32
  const FlutterDesktopPixelBuffer* CopyPixelBuffer(size_t width, size_t height);
#endif

 public:
#ifdef _WIN32
  flutter::TextureRegistrar* registrar_;
  std::unique_ptr<flutter::TextureVariant> texture_;
  std::unique_ptr<FlutterDesktopPixelBuffer> flutter_desktop_pixel_buffer_ =
      nullptr;
#endif
  nertc::IRtcEngineEx* engine_ = nullptr;
  std::string channel_tag_ = "";
  // std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
  // method_channel_;

  int64_t texture_id_ = -1;

  uint32_t frame_width_ = 0;
  uint32_t frame_height_ = 0;

  std::mutex buffer_mutex_;
  std::vector<uint8_t> buffer_;

  bool is_dirty_;
  nertc::uid_t uid_;
  bool first_render_flag_ = false;
};

#endif  // TEXTURE_RENDER_H_