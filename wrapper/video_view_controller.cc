// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "video_view_controller.h"

// Static member definitions
VideoViewController* VideoViewController::instance_ = nullptr;
std::mutex VideoViewController::instance_mutex_;

#ifdef _WIN32
VideoViewController::VideoViewController(
    flutter::TextureRegistrar* texture_registrar,
    flutter::BinaryMessenger* messenger_) {
  texture_registrar_ = texture_registrar;
  messenger_ = messenger_;
}
#else
VideoViewController::VideoViewController() {}
#endif

#ifdef _WIN32
VideoViewController* VideoViewController::GetInstance(
    flutter::TextureRegistrar* texture_registrar,
    flutter::BinaryMessenger* messenger) {
  std::lock_guard<std::mutex> lock(instance_mutex_);
  if (instance_ == nullptr) {
    if (texture_registrar == nullptr || messenger == nullptr) {
      // Cannot create instance without required parameters
      return nullptr;
    }
    instance_ = new VideoViewController(texture_registrar, messenger);
  }
  return instance_;
}
#else
VideoViewController* VideoViewController::GetInstance() {
  std::lock_guard<std::mutex> lock(instance_mutex_);
  if (instance_ == nullptr) {
    instance_ = new VideoViewController();
  }
  return instance_;
}
#endif

void VideoViewController::DestroyInstance() {
  std::lock_guard<std::mutex> lock(instance_mutex_);
  if (instance_ != nullptr) {
    delete instance_;
    instance_ = nullptr;
  }
}

VideoViewController::~VideoViewController() {
  Dispose();
  // Clear the singleton instance if this is the singleton being destroyed
  std::lock_guard<std::mutex> lock(instance_mutex_);
  if (instance_ == this) {
    instance_ = nullptr;
  }
}

#ifdef _WIN32
void VideoViewController::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {}
#endif

int64_t VideoViewController::CreatePlatformRender() { return 0; }

bool VideoViewController::DestroyPlatformRender(int64_t platformRenderId) {
  return false;
}

int64_t VideoViewController::CreateTextureRender(nertc::IRtcEngineEx* engine) {
#ifdef _WIN32
  auto textureRender =
      new TextureRender(messenger_, texture_registrar_, engine);
#else
  auto textureRender = new TextureRender(engine);
#endif

  int64_t texture_id = textureRender->texture_id();

  // Lock access to renderers_ map
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  renderers_[texture_id] = textureRender;

  return texture_id;
}

void VideoViewController::SetChannelTag(int64_t textureId,
                                        const std::string& channel_tag) {
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  auto it = renderers_.find(textureId);
  if (it != renderers_.end()) {
    it->second->SetChannelTag(channel_tag);
  } else {
    printf("setChannelTag failed: textureId not found\n");
    return;
  }
}

bool VideoViewController::DestroyTextureRender(int64_t textureId) {
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  auto it = renderers_.find(textureId);
  if (it != renderers_.end()) {
    it->second->Dispose();

    // 添加平台特定的清理逻辑
#ifdef __APPLE__
    // 调用 macOS/iOS 的 Objective-C 清理接口
    NotifyTextureDestroyed(textureId);
#endif

    renderers_.erase(it);
    return true;
  }
  return false;
}

void VideoViewController::SetupCanvas(int64_t textureId, nertc::uid_t uid,
                                      nertc::NERtcVideoScalingMode scaling_mode,
                                      nertc::NERtcVideoMirrorMode mirror_mode,
                                      uint32_t background_color,
                                      nertc::NERtcVideoStreamType stream_type) {
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  auto it = renderers_.find(textureId);
  if (it != renderers_.end()) {
    it->second->SetupCanvas(uid, scaling_mode, mirror_mode, background_color,
                            stream_type);
  }
}

void VideoViewController::SetupSubChannelCanvas(
    int64_t textureId, nertc::uid_t uid,
    nertc::NERtcVideoScalingMode scaling_mode,
    nertc::NERtcVideoMirrorMode mirror_mode, uint32_t background_color,
    nertc::NERtcVideoStreamType stream_type) {
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  auto it = renderers_.find(textureId);
  if (it != renderers_.end()) {
    it->second->SetupSubChannelCavans(uid, scaling_mode, mirror_mode,
                                      background_color, stream_type);
  } else {
    printf("SetupSubChannelCanvas failed: textureId not found\n");
    return;
  }
}

void VideoViewController::SetupPlayStreamingCanvas(
    int64_t textureId, const char* stream_id,
    nertc::NERtcVideoScalingMode scaling_mode,
    nertc::NERtcVideoMirrorMode mirror_mode, uint32_t background_color,
    nertc::NERtcVideoStreamType stream_type) {
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  auto it = renderers_.find(textureId);
  if (it != renderers_.end()) {
    it->second->SetupPlayStreamingCanvas(stream_id, scaling_mode, mirror_mode,
                                         background_color, stream_type);
  }
}

void VideoViewController::Dispose() {
  std::lock_guard<std::mutex> lock(renderers_mutex_);
  for (const auto& entry : renderers_) {
    entry.second->Dispose();

    // 添加平台特定的清理逻辑
#ifdef __APPLE__
    NotifyTextureDestroyed(entry.first);
#endif
  }
  renderers_.clear();

#ifdef __APPLE__
  // 清理所有平台资源
  NotifyAllTexturesDestroyed();
#endif
}