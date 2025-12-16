// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "texture_render.h"
#include "engine_wrapper.h"

#include <functional>
#include <iostream>
#include <algorithm>

#ifdef _WIN32
#include <windows.h>
#include <io.h>
#include <fcntl.h>
#include "dart/dart_native_api.h"
#include "dart/dart_api_dl.h"
#include "util/json.hpp"
using namespace flutter;
using json = nlohmann::json;
#endif

#ifdef _WIN32
// Windows控制台初始化函数（用于TextureRender）
void InitializeTextureRenderConsole() {
  static bool consoleInitialized = false;
  if (!consoleInitialized) {
    // 尝试分配控制台（如果还没有的话）
    if (!GetConsoleWindow()) {
      if (AllocConsole()) {
        // 重定向标准输出到控制台
        freopen_s((FILE**)stdout, "CONOUT$", "w", stdout);
        freopen_s((FILE**)stderr, "CONOUT$", "w", stderr);
        freopen_s((FILE**)stdin, "CONIN$", "r", stdin);

        // 设置控制台标题
        SetConsoleTitle(L"NERTC TextureRender Debug Console");

        // 同步iostream和stdio
        std::ios::sync_with_stdio(true);
        std::cout.clear();
        std::cerr.clear();
        std::cin.clear();
      }
    }
    consoleInitialized = true;
    std::cout << "=== NERTC TextureRender Console Initialized ===" << std::endl;
  }
}

// 日志辅助函数
void LogTextureInfo(const std::string& message) {
  std::cout << "[TEXTURE] " << message << std::endl;
  printf("[TEXTURE] %s\n", message.c_str());
}

void LogTextureError(const std::string& message) {
  std::cout << "[TEXTURE_ERROR] " << message << std::endl;
  printf("[TEXTURE_ERROR] %s\n", message.c_str());
}
#endif

#ifdef _WIN32
TextureRender::TextureRender(flutter::BinaryMessenger* messenger,
                             flutter::TextureRegistrar* registrar,
                             nertc::IRtcEngineEx* engine)
    : is_dirty_(false), engine_(engine) {
  InitializeTextureRenderConsole();

  registrar_ = reinterpret_cast<flutter::TextureRegistrar*>(registrar);
  // Create flutter desktop pixelbuffer texture;
  texture_ =
      std::make_unique<flutter::TextureVariant>(flutter::PixelBufferTexture(
          [this](size_t width,
                 size_t height) -> const FlutterDesktopPixelBuffer* {
            return this->CopyPixelBuffer(width, height);
          }));

  texture_id_ = registrar_->RegisterTexture(texture_.get());

#ifdef _WIN32
  LogTextureInfo("TextureRender created with texture_id: " +
                 std::to_string(texture_id_));
#endif
}
#else
// macOS/iOS 版本的外部函数声明
extern "C" int64_t CreateTextureIDFromCpp(void);
extern "C" void UpdateFrameFromCpp(int64_t textureId, const uint8_t* buffer,
                                   uint32_t width, uint32_t height);

TextureRender::TextureRender(nertc::IRtcEngineEx* engine)
    : is_dirty_(false), engine_(engine) {
  // 通过桥接函数从 Objective-C 获取 texture ID
  texture_id_ = CreateTextureIDFromCpp();
}
#endif
class NERtcDesktopWrapper;

TextureRender::~TextureRender() {}

int64_t TextureRender::texture_id() { return texture_id_; }

#ifdef _WIN32
const FlutterDesktopPixelBuffer* TextureRender::CopyPixelBuffer(size_t width,
                                                                size_t height) {
  std::unique_lock<std::mutex> buffer_lock(buffer_mutex_);

  is_dirty_ = false;

  if (!TextureRegistered()) {
#ifdef _WIN32
    static bool logged_once = false;
    if (!logged_once) {
      LogTextureError("CopyPixelBuffer: Texture not registered");
      logged_once = true;
    }
#endif
    // buffer_lock will be released automatically when going out of scope
    return nullptr;
  }

  if (frame_width_ == 0 || frame_height_ == 0) {
#ifdef _WIN32
    static bool logged_once = false;
    if (!logged_once) {
      LogTextureError("CopyPixelBuffer: Invalid frame dimensions (width: " +
                      std::to_string(frame_width_) +
                      ", height: " + std::to_string(frame_height_) + ")");
      logged_once = true;
    }
#endif
    // buffer_lock will be released automatically when going out of scope
    return nullptr;
  }

  if (!flutter_desktop_pixel_buffer_) {
#ifdef _WIN32
    LogTextureInfo(
        "CopyPixelBuffer: Creating new pixel buffer for texture_id: " +
        std::to_string(texture_id_));
#endif
    flutter_desktop_pixel_buffer_ =
        std::make_unique<FlutterDesktopPixelBuffer>();

    // Unlocks mutex after texture is processed.
    flutter_desktop_pixel_buffer_->release_callback =
        [](void* release_context) {
          auto mutex = reinterpret_cast<std::mutex*>(release_context);
          mutex->unlock();
        };
  }

  flutter_desktop_pixel_buffer_->buffer = buffer_.data();
  flutter_desktop_pixel_buffer_->width = frame_width_;
  flutter_desktop_pixel_buffer_->height = frame_height_;

  // Releases unique_lock and set mutex pointer for release context.
  flutter_desktop_pixel_buffer_->release_context = buffer_lock.release();

  return flutter_desktop_pixel_buffer_.get();
}
#endif

void TextureRender::UpdateFrameData(nertc::uid_t uid, void* data, uint32_t type,
                                    uint32_t width, uint32_t height,
                                    uint32_t count, uint32_t offset[4],
                                    uint32_t stride[4], uint32_t rotation) {
  std::lock_guard<std::mutex> lock_guard(buffer_mutex_);

  const uint32_t bytes_per_pixel = 4;
  const uint32_t pixels_total = width * height;
  const uint32_t data_size = pixels_total * bytes_per_pixel;

  if (buffer_.size() != data_size) {
    buffer_.resize(data_size);
    // 通知尺寸变化（如有需要）
  }

  // I420数据布局
  uint8_t* y_plane = static_cast<uint8_t*>(data) + offset[0];
  uint8_t* u_plane = static_cast<uint8_t*>(data) + offset[1];
  uint8_t* v_plane = static_cast<uint8_t*>(data) + offset[2];
  uint32_t y_stride = stride[0];
  uint32_t u_stride = stride[1];
  uint32_t v_stride = stride[2];

  uint8_t* dst = buffer_.data();

  for (uint32_t j = 0; j < height; ++j) {
    for (uint32_t i = 0; i < width; ++i) {
      uint8_t Y = y_plane[j * y_stride + i];
      uint8_t U = u_plane[(j / 2) * u_stride + (i / 2)];
      uint8_t V = v_plane[(j / 2) * v_stride + (i / 2)];

      // I420(YUV420p) -> RGBA
      int C = Y - 16;
      int D = U - 128;
      int E = V - 128;
      int R = (298 * C + 409 * E + 128) >> 8;
      int G = (298 * C - 100 * D - 208 * E + 128) >> 8;
      int B = (298 * C + 516 * D + 128) >> 8;

      // Clamp values to [0, 255] range
      if (R < 0)
        R = 0;
      else if (R > 255)
        R = 255;
      if (G < 0)
        G = 0;
      else if (G > 255)
        G = 255;
      if (B < 0)
        B = 0;
      else if (B > 255)
        B = 255;

      dst[0] = static_cast<uint8_t>(R);
      dst[1] = static_cast<uint8_t>(G);
      dst[2] = static_cast<uint8_t>(B);
      dst[3] = 255;  // Alpha

      dst += 4;
    }
  }

  frame_width_ = width;
  frame_height_ = height;
  is_dirty_ = true;

  if (TextureRegistered() && is_dirty_) {
#ifdef _WIN32
    registrar_->MarkTextureFrameAvailable(texture_id_);
#else
    // macOS: 调用 Objective-C 桥接函数更新纹理帧
    UpdateFrameFromCpp(texture_id_, buffer_.data(), width, height);
#endif
  }
}

static void TextureRender_onFrameDataCallback(
    nertc::uid_t uid, void* data, uint32_t type, uint32_t width,
    uint32_t height, uint32_t count, uint32_t offset[4], uint32_t stride[4],
    uint32_t rotation, void* user_data) {
  TextureRender* texture_render = static_cast<TextureRender*>(user_data);

  if (texture_render->frame_width_ != width ||
      texture_render->frame_height_ != height) {
    json dart_json;
    dart_json["method"] = kNERtcFlutterRenderOnFrameResolutionChanged;
    dart_json["uid"] = uid;
    dart_json["textureId"] = texture_render->texture_id();
    dart_json["width"] = width;
    dart_json["height"] = height;
    dart_json["rotation"] = rotation;
    std::string response = dart_json.dump();

    NERtcDesktopWrapper* wrapper = NERtcDesktopWrapper::ShareInstance();
    if (wrapper && wrapper->GetDartSendPort() != 0) {
      Dart_CObject dart_object;
      dart_object.type = Dart_CObject_kString;
      dart_object.value.as_string = const_cast<char*>(response.c_str());
      printf("flutter render onFrameResolutionChanged: %s\n", response.c_str());
      Dart_PostCObject_DL(wrapper->GetDartSendPort(), &dart_object);
    }
  }

  texture_render->UpdateFrameData(uid, data, type, width, height, count, offset,
                                  stride, rotation);
  if (!texture_render->first_render_flag_) {
    json dart_json;
    dart_json["method"] = kNERtcFlutterRenderOnFirstFrameRender;
    dart_json["uid"] = uid;
    dart_json["textureId"] = texture_render->texture_id();
    std::string response = dart_json.dump();

    NERtcDesktopWrapper* wrapper = NERtcDesktopWrapper::ShareInstance();
    if (wrapper && wrapper->GetDartSendPort() != 0) {
      Dart_CObject dart_object;
      dart_object.type = Dart_CObject_kString;
      dart_object.value.as_string = const_cast<char*>(response.c_str());
      Dart_PostCObject_DL(wrapper->GetDartSendPort(), &dart_object);
    }
    printf("flutter render onFirstFrameRender: %s\n", response.c_str());
    texture_render->first_render_flag_ = true;
  }
}

void TextureRender::SetupCanvas(nertc::uid_t uid,
                                nertc::NERtcVideoScalingMode scaling_mode,
                                nertc::NERtcVideoMirrorMode mirror_mode,
                                uint32_t background_color,
                                nertc::NERtcVideoStreamType stream_type) {
  if (engine_ == nullptr) {
#ifdef _WIN32
    LogTextureError("SetupCanvas failed: engine is null");
#endif
    return;
  }

#ifdef _WIN32
  std::string setupInfo =
      "SetupCanvas - texture_id: " + std::to_string(texture_id_) +
      ", uid: " + std::to_string(uid) +
      ", scaling_mode: " + std::to_string(scaling_mode) +
      ", mirror_mode: " + std::to_string(mirror_mode);
  LogTextureInfo(setupInfo);
#endif

  nertc::NERtcVideoCanvas canvas;
  canvas.cb = TextureRender_onFrameDataCallback;
  canvas.user_data = (void*)this;
  canvas.window = nullptr;  // Use texture instead of window
  canvas.scaling_mode = scaling_mode;
  canvas.mirror_mode = mirror_mode;
  canvas.background_color = background_color;
  if (uid == 0) {
#ifdef _WIN32
    LogTextureInfo("Setting up local video canvas");
#endif
    engine_->setupLocalVideoStreamCanvas(&canvas, stream_type);
  } else {
#ifdef _WIN32
    LogTextureInfo("Setting up remote video canvas for uid: " +
                   std::to_string(uid));
#endif
    engine_->setupRemoteVideoStreamCanvas(uid, &canvas, stream_type);
  }
  uid_ = uid;
}

void TextureRender::SetupSubChannelCavans(
    nertc::uid_t uid, nertc::NERtcVideoScalingMode scaling_mode,
    nertc::NERtcVideoMirrorMode mirror_mode, uint32_t background_color,
    nertc::NERtcVideoStreamType stream_type) {
  if (channel_tag_.empty()) {
#ifdef _WIN32
    LogTextureError("SetupSubChannelCavans failed: channel_tag is empty");
#else
    printf("SetupSubChannelCavans failed: channel_tag is empty\n");
#endif
    return;
  }

#ifdef _WIN32
  std::string setupInfo =
      "SetupSubChannelCavans - texture_id: " + std::to_string(texture_id_) +
      ", uid: " + std::to_string(uid) +
      ", scaling_mode: " + std::to_string(scaling_mode) +
      ", mirror_mode: " + std::to_string(mirror_mode);
  LogTextureInfo(setupInfo);
#endif

  auto wrapper = NERtcDesktopWrapper::ShareInstance();
  if (wrapper == nullptr) {
#ifdef _WIN32
    LogTextureError("SetupSubChannelCavans failed: wrapper is null");
#else
    printf("SetupSubChannelCavans failed: wrapper is null\n");
#endif
    return;
  }

  auto channel = wrapper->GetChannelWrapper(channel_tag_);
  if (channel == nullptr) {
#ifdef _WIN32
    LogTextureError("SetupSubChannelCavans failed: channel is null");
#else
    printf("SetupSubChannelCavans failed: channel is null\n");
#endif
    return;
  }

  nertc::NERtcVideoCanvas canvas;
  canvas.cb = TextureRender_onFrameDataCallback;
  canvas.user_data = (void*)this;
  canvas.window = nullptr;  // Use texture instead of window
  canvas.scaling_mode = scaling_mode;
  canvas.mirror_mode = mirror_mode;
  canvas.background_color = background_color;

  if (uid == 0) {
    // local.
    channel->SetupLocalCanvas(&canvas, stream_type);
  } else {
    // remote.
    channel->SetupRemoteCanvas(uid, &canvas, stream_type);
  }
  uid_ = uid;
}

void TextureRender::SetupPlayStreamingCanvas(
    const char* stream_id, nertc::NERtcVideoScalingMode scaling_mode,
    nertc::NERtcVideoMirrorMode mirror_mode, uint32_t background_color,
    nertc::NERtcVideoStreamType stream_type) {
  if (engine_ == nullptr) {
#ifdef _WIN32
    LogTextureError("SetupPlayStreamingCanvas failed: engine is null");
#endif
    return;
  }

  nertc::NERtcVideoCanvas canvas;
  canvas.cb = TextureRender_onFrameDataCallback;
  canvas.user_data = (void*)this;
  canvas.window = nullptr;
  canvas.scaling_mode = scaling_mode;
  canvas.mirror_mode = mirror_mode;
  canvas.background_color = background_color;
  engine_->setupPlayStreamingCanvas(stream_id, &canvas);
}

void TextureRender::Dispose() {
#ifdef _WIN32
  LogTextureInfo("Disposing TextureRender with texture_id: " +
                 std::to_string(texture_id_));
#endif

  if (engine_) {
    nertc::NERtcVideoCanvas canvas;
    canvas.cb = nullptr;
    if (uid_ == 0) {
#ifdef _WIN32
      LogTextureInfo("Clearing local video canvas");
#endif
      engine_->setupLocalVideoCanvas(&canvas);
    } else {
#ifdef _WIN32
      LogTextureInfo("Clearing remote video canvas for uid: " +
                     std::to_string(uid_));
#endif
      engine_->setupRemoteVideoCanvas(uid_, &canvas);
    }
  }

  const std::lock_guard<std::mutex> lock(buffer_mutex_);

#ifdef _WIN32
  if (registrar_ && texture_id_ != -1) {
    LogTextureInfo("Unregistering texture: " + std::to_string(texture_id_));
    registrar_->UnregisterTexture(texture_id_);
    registrar_ = nullptr;
  }
#endif
  texture_id_ = -1;
}