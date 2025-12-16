// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "engine_wrapper.h"

std::map<std::string, RefCountImpl<IScreenCaptureSourceList>>
    NERtcDesktopWrapper::screen_capture_source_list_map_;
std::mutex NERtcDesktopWrapper::source_list_mutex_;

std::string NERtcDesktopWrapper::HandleGetScreenCaptureSource(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "thumbSize_width") ||
      !IsContainsValue(params, "thumbSize_height") ||
      !IsContainsValue(params, "iconSize_width") ||
      !IsContainsValue(params, "iconSize_height") ||
      !IsContainsValue(params, "includeScreen")) {
    // 返回错误 JSON
    json result;
    result["code"] = -1;
    result["error"] = "Invalid parameters";
    result["key"] = "";
    return result.dump();
  }

  int thumbSize_width = params["thumbSize_width"].get<int>();
  int thumbSize_height = params["thumbSize_height"].get<int>();
  int iconSize_width = params["iconSize_width"].get<int>();
  int iconSize_height = params["iconSize_height"].get<int>();
  bool includeScreen = params["includeScreen"].get<bool>();

  std::string key = "tw" + std::to_string(thumbSize_width) + "th" +
                    std::to_string(thumbSize_height) + "iw" +
                    std::to_string(iconSize_width) + "ih" +
                    std::to_string(iconSize_height) + "is" +
                    std::to_string(includeScreen);

  // 添加线程安全保护
  std::lock_guard<std::mutex> lock(source_list_mutex_);

  auto it = screen_capture_source_list_map_.find(key);
  if (it != screen_capture_source_list_map_.end()) {
    it->second.AddRef();

    // 返回已存在的源信息 JSON
    json result;
    result["code"] = 0;
    result["error"] = "";
    result["key"] = key;
    return result.dump();
  }

  // 获取屏幕捕获源
  auto screen_ptr = handle->getScreenCaptureSources(
      NERtcSize(thumbSize_width, thumbSize_height),
      NERtcSize(iconSize_width, iconSize_height), includeScreen);

  if (!screen_ptr) {
    // 返回获取失败的 JSON
    json result;
    result["code"] = -1;
    result["error"] = "Failed to get screen capture sources";
    result["key"] = "";
    return result.dump();
  }

  try {
    // 使用引用捕获避免 key 的拷贝，但需要确保生命周期
    auto death_recipient = [key](IScreenCaptureSourceList* ptr) {
      std::lock_guard<std::mutex> lock(source_list_mutex_);
      if (ptr) {
        ptr->release();
      }
      screen_capture_source_list_map_.erase(key);
    };

    // 直接构造 RefCountImpl 并设置
    screen_capture_source_list_map_.emplace(
        key, RefCountImpl<IScreenCaptureSourceList>());
    screen_capture_source_list_map_[key].SetOnRelease(screen_ptr,
                                                      death_recipient);

    // 返回成功的 JSON 结果
    json result;
    result["code"] = 0;
    result["error"] = "";
    result["key"] = key;
    return result.dump();

  } catch (...) {
    // 异常安全：确保释放资源
    if (screen_ptr) {
      screen_ptr->release();
    }
    screen_capture_source_list_map_.erase(key);

    // 返回异常错误的 JSON
    json result;
    result["code"] = -1;
    result["error"] =
        "Exception occurred while processing screen capture sources";
    result["key"] = "";
    return result.dump();
  }
}

int64_t NERtcDesktopWrapper::HandleReleaseScreenCaptureSource(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "key")) {
    return kNERtcErrInvalidParam;
  }
  std::string key = params["key"].get<std::string>();
  if (screen_capture_source_list_map_.find(key) ==
      screen_capture_source_list_map_.end()) {
    return kNERtcErrInvalidParam;
  }
  screen_capture_source_list_map_[key].DecRef();
  return kNERtcNoError;
}

int64_t NERtcDesktopWrapper::HandleGetScreenCaptureCount(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "key")) {
    return kNERtcErrInvalidParam;
  }
  std::string key = params["key"].get<std::string>();
  if (screen_capture_source_list_map_.find(key) ==
      screen_capture_source_list_map_.end()) {
    return kNERtcErrInvalidParam;
  }

  auto it = screen_capture_source_list_map_.find(key);
  if (it != screen_capture_source_list_map_.end()) {
    // 获取实际的源列表指针来计算数量
    auto& refCount = it->second;
    if (refCount.get()) {
      return refCount.get()->getCount();
    }
  }
  return kNERtcErrInvalidParam;
}

// 添加将 NERtcThumbImageBuffer 转换为 JSON 的辅助函数
static json thumbImageBufferToJson(const NERtcThumbImageBuffer& thumb) {
  json thumbJson;

  // 转换 buffer 为数组
  if (thumb.buffer && thumb.length > 0) {
    std::vector<int> bufferArray;
    const uint8_t* bufferPtr = reinterpret_cast<const uint8_t*>(thumb.buffer);
    for (unsigned int i = 0; i < thumb.length; ++i) {
      bufferArray.push_back(static_cast<int>(bufferPtr[i]));
    }
    thumbJson["buffer"] = bufferArray;
  } else {
    thumbJson["buffer"] = json::array();
  }

  thumbJson["length"] = thumb.length;
  thumbJson["width"] = thumb.width;
  thumbJson["height"] = thumb.height;

  return thumbJson;
}

// 添加将 NERtcScreenCaptureSourceInfo 转换为 JSON 的辅助函数
json sourceInfoToJson(const NERtcScreenCaptureSourceInfo& sourceInfo) {
  json sourceJson;

  // 转换 type 枚举
  sourceJson["type"] = static_cast<int>(sourceInfo.type);

  // 转换 sourceId
  sourceJson["sourceId"] = reinterpret_cast<int64_t>(sourceInfo.source_id);

  // 转换字符串字段
  sourceJson["sourceName"] =
      sourceInfo.source_name ? std::string(sourceInfo.source_name) : "";
  sourceJson["processPath"] =
      sourceInfo.process_path ? std::string(sourceInfo.process_path) : "";
  sourceJson["sourceTitle"] =
      sourceInfo.source_title ? std::string(sourceInfo.source_title) : "";

  // 转换 thumbImage 和 iconImage
  sourceJson["thumbImage"] = thumbImageBufferToJson(sourceInfo.thumb_image);
  sourceJson["iconImage"] = thumbImageBufferToJson(sourceInfo.icon_image);

  // 转换 primaryMonitor
  sourceJson["primaryMonitor"] = sourceInfo.primaryMonitor;

  return sourceJson;
}

// 修改后的 HandleGetScreenCaptureSourceInfo 方法
std::string NERtcDesktopWrapper::HandleGetScreenCaptureSourceInfo(
    IRtcEngineEx* handle, const json& params) {
  // 参数验证
  if (!IsContainsValue(params, "key") || !IsContainsValue(params, "index")) {
    json result;
    result["code"] = -1;
    result["error"] = "Missing required parameters: key or index";
    result["info"] = nullptr;
    return result.dump();
  }

  try {
    std::string key = params["key"].get<std::string>();
    int index = params["index"].get<int>();

    // 检查 key 是否存在
    if (screen_capture_source_list_map_.find(key) ==
        screen_capture_source_list_map_.end()) {
      json result;
      result["code"] = -1;
      result["error"] = "Screen capture source list not found for key: " + key;
      result["info"] = nullptr;
      return result.dump();
    }

    auto it = screen_capture_source_list_map_.find(key);
    if (it != screen_capture_source_list_map_.end()) {
      auto& refCount = it->second;
      if (refCount.get()) {
        // 检查索引是否有效
        unsigned int count = refCount.get()->getCount();
        if (index < 0 || static_cast<unsigned int>(index) >= count) {
          json result;
          result["code"] = -1;
          result["error"] =
              "Index out of range. Index: " + std::to_string(index) +
              ", Count: " + std::to_string(count);
          result["info"] = nullptr;
          return result.dump();
        }

        // 获取指定索引的源信息
        try {
          NERtcScreenCaptureSourceInfo sourceInfo =
              refCount.get()->getSourceInfo(static_cast<unsigned int>(index));

          // 将 sourceInfo 转换为 JSON
          json sourceInfoJson = sourceInfoToJson(sourceInfo);

          // 返回成功结果
          json result;
          result["code"] = 0;
          result["error"] = "";
          result["info"] = sourceInfoJson;
          return result.dump();

        } catch (const std::exception& e) {
          json result;
          result["code"] = -1;
          result["error"] =
              "Failed to get source info: " + std::string(e.what());
          result["info"] = nullptr;
          return result.dump();
        } catch (...) {
          json result;
          result["code"] = -1;
          result["error"] = "Unknown error occurred while getting source info";
          result["info"] = nullptr;
          return result.dump();
        }
      } else {
        json result;
        result["code"] = -1;
        result["error"] = "Screen capture source list is null";
        result["info"] = nullptr;
        return result.dump();
      }
    }

    // 这个分支理论上不会执行到，但保险起见
    json result;
    result["code"] = -1;
    result["error"] =
        "Unexpected error: source list found but iteration failed";
    result["info"] = nullptr;
    return result.dump();

  } catch (const std::exception& e) {
    json result;
    result["code"] = -1;
    result["error"] = "Parameter parsing error: " + std::string(e.what());
    result["info"] = nullptr;
    return result.dump();
  } catch (...) {
    json result;
    result["code"] = -1;
    result["error"] = "Unknown parameter parsing error";
    result["info"] = nullptr;
    return result.dump();
  }
}

// 解析 NERtcRectangle
NERtcRectangle parseRectangle(const json& rectJson) {
  NERtcRectangle rect = {};
  if (rectJson.contains("x")) {
    rect.x = rectJson["x"].get<int>();
  }
  if (rectJson.contains("y")) {
    rect.y = rectJson["y"].get<int>();
  }
  if (rectJson.contains("width")) {
    rect.width = rectJson["width"].get<int>();
  }
  if (rectJson.contains("height")) {
    rect.height = rectJson["height"].get<int>();
  }
  return rect;
}

// 解析 NERtcVideoDimensions
NERtcVideoDimensions parseDimensions(const json& dimJson) {
  NERtcVideoDimensions dim = {};
  if (dimJson.contains("width")) {
    dim.width = dimJson["width"].get<int>();
  }
  if (dimJson.contains("height")) {
    dim.height = dimJson["height"].get<int>();
  }
  return dim;
}

// 解析 NERtcScreenCaptureParameters
NERtcScreenCaptureParameters parseCaptureParams(const json& paramsJson) {
  NERtcScreenCaptureParameters params = {};

  // 解析 profile 枚举
  if (paramsJson.contains("profile")) {
    params.profile =
        static_cast<NERtcScreenProfileType>(paramsJson["profile"].get<int>());
  }

  // 解析 dimensions
  if (paramsJson.contains("dimensions") &&
      !paramsJson["dimensions"].is_null()) {
    params.dimensions = parseDimensions(paramsJson["dimensions"]);
  }

  // 解析基本参数
  if (paramsJson.contains("frameRate")) {
    params.frame_rate = paramsJson["frameRate"].get<int>();
  }
  if (paramsJson.contains("minFrameRate")) {
    params.min_framerate = paramsJson["minFrameRate"].get<int>();
  }
  if (paramsJson.contains("bitRate")) {
    params.bitrate = paramsJson["bitRate"].get<int>();
  }
  if (paramsJson.contains("minBitRate")) {
    params.min_bitrate = paramsJson["minBitRate"].get<int>();
  }
  if (paramsJson.contains("captureMouseCursor")) {
    params.capture_mouse_cursor = paramsJson["captureMouseCursor"].get<bool>();
  }
  if (paramsJson.contains("windowFocus")) {
    params.window_focus = paramsJson["windowFocus"].get<bool>();
  }

  // 解析 excludeWindowList
  if (paramsJson.contains("excludeWindowList")) {
    auto excludeList = paramsJson["excludeWindowList"].get<std::vector<int>>();
    if (!excludeList.empty()) {
      // 分配内存并复制数据
      static std::vector<source_id_t> excludeWindowIds;
      excludeWindowIds.clear();
      for (int windowId : excludeList) {
        excludeWindowIds.push_back(
            reinterpret_cast<source_id_t>(static_cast<intptr_t>(windowId)));
      }
      params.excluded_window_list = excludeWindowIds.data();
      params.excluded_window_count = static_cast<int>(excludeWindowIds.size());
    } else {
      params.excluded_window_list = nullptr;
      params.excluded_window_count = 0;
    }
  }

  // 解析 contentPrefer
  if (paramsJson.contains("contentPrefer")) {
    params.prefer = static_cast<NERtcSubStreamContentPrefer>(
        paramsJson["contentPrefer"].get<int>());
  }

  // 解析 preference (degradation preference)
  if (paramsJson.contains("preference")) {
    params.degradation_preference = static_cast<NERtcDegradationPreference>(
        paramsJson["preference"].get<int>());
  }

  // 解析高性能和高亮相关参数
  if (paramsJson.contains("enableHighPerformance")) {
    params.enable_high_performance =
        paramsJson["enableHighPerformance"].get<bool>();
  }
  if (paramsJson.contains("enableHighLight")) {
    params.enable_high_light = paramsJson["enableHighLight"].get<bool>();
  }
  if (paramsJson.contains("highLightWidth")) {
    params.high_light_width = paramsJson["highLightWidth"].get<int>();
  }
  if (paramsJson.contains("highLightColor")) {
    params.high_light_color =
        static_cast<unsigned int>(paramsJson["highLightColor"].get<int>());
  }
  if (paramsJson.contains("highLightLength")) {
    params.high_light_length = paramsJson["highLightLength"].get<int>();
  }
  if (paramsJson.contains("excludeHighLightBox")) {
    params.exclude_highlight_box =
        paramsJson["excludeHighLightBox"].get<bool>();
  }
  if (paramsJson.contains("forceUpdateData")) {
    params.force_update_data = paramsJson["forceUpdateData"].get<bool>();
  }

  return params;
}

int64_t NERtcDesktopWrapper::HandleStartScreenCaptureByScreenRect(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "screenRect") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  // 解析 screenRect, regionRect, captureParams 参数
  NERtcRectangle screenRect = parseRectangle(params["screenRect"]);
  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);

  return handle->startScreenCaptureByScreenRect(screenRect, regionRect,
                                                captureParams);
}

int64_t NERtcDesktopWrapper::HandleStartScreenCaptureByDisplayId(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "displayId") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  int displayId = params["displayId"].get<int>();
  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);

  return handle->startScreenCaptureByDisplayId(
      reinterpret_cast<source_id_t>(displayId), regionRect, captureParams);
}

int64_t NERtcDesktopWrapper::HandleStartScreenCaptureByWindowId(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "windowId") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  int64_t windowId = params["windowId"].get<int64_t>();
  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);

  return handle->startScreenCaptureByWindowId(
      reinterpret_cast<source_id_t>(windowId), regionRect, captureParams);
}

// 解析 NERtcThumbImageBuffer
NERtcThumbImageBuffer parseThumbImageBuffer(const json& thumbJson) {
  NERtcThumbImageBuffer thumb = {};

  if (thumbJson.contains("buffer") && thumbJson["buffer"].is_array()) {
    auto bufferArray = thumbJson["buffer"].get<std::vector<int>>();
    if (!bufferArray.empty()) {
      // 为缓冲区分配内存（注意：这里需要管理内存生命周期）
      static std::vector<uint8_t> staticBuffer;
      staticBuffer.clear();
      staticBuffer.reserve(bufferArray.size());
      for (int val : bufferArray) {
        staticBuffer.push_back(static_cast<uint8_t>(val));
      }
      thumb.buffer = reinterpret_cast<const char*>(staticBuffer.data());
    }
  }

  if (thumbJson.contains("length")) {
    thumb.length = thumbJson["length"].get<unsigned int>();
  }

  if (thumbJson.contains("width")) {
    thumb.width = thumbJson["width"].get<unsigned int>();
  }

  if (thumbJson.contains("height")) {
    thumb.height = thumbJson["height"].get<unsigned int>();
  }

  return thumb;
}

// 解析 NERtcScreenCaptureSourceInfo
NERtcScreenCaptureSourceInfo parseScreenCaptureSourceInfo(
    const json& sourceJson) {
  NERtcScreenCaptureSourceInfo source = {};

  // 解析 type
  if (sourceJson.contains("type")) {
    int typeValue = sourceJson["type"].get<int>();
    source.type = static_cast<NERtcScreenCaptureSourceType>(typeValue);
  }

  // 解析 sourceId
  if (sourceJson.contains("sourceId")) {
    int64_t sourceId = sourceJson["sourceId"].get<int64_t>();
    source.source_id = reinterpret_cast<source_id_t>(sourceId);
  }

  // 解析 sourceName
  if (sourceJson.contains("sourceName")) {
    static std::string sourceNameStr =
        sourceJson["sourceName"].get<std::string>();
    source.source_name = sourceNameStr.c_str();
  }

  // 解析 thumbImage
  if (sourceJson.contains("thumbImage")) {
    source.thumb_image = parseThumbImageBuffer(sourceJson["thumbImage"]);
  }

  // 解析 iconImage
  if (sourceJson.contains("iconImage")) {
    source.icon_image = parseThumbImageBuffer(sourceJson["iconImage"]);
  }

  // 解析 processPath
  if (sourceJson.contains("processPath")) {
    static std::string processPathStr =
        sourceJson["processPath"].get<std::string>();
    source.process_path = processPathStr.c_str();
  }

  // 解析 sourceTitle
  if (sourceJson.contains("sourceTitle")) {
    static std::string sourceTitleStr =
        sourceJson["sourceTitle"].get<std::string>();
    source.source_title = sourceTitleStr.c_str();
  }

  // 解析 primaryMonitor
  if (sourceJson.contains("primaryMonitor")) {
    source.primaryMonitor = sourceJson["primaryMonitor"].get<bool>();
  }

  return source;
}

int64_t NERtcDesktopWrapper::HandleSetScreenCaptureSource(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "source") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  try {
    // 解析 source 参数
    NERtcScreenCaptureSourceInfo source =
        parseScreenCaptureSourceInfo(params["source"]);

    // 解析 regionRect 参数
    NERtcRectangle regionRect = parseRectangle(params["regionRect"]);

    // 解析 captureParams 参数
    NERtcScreenCaptureParameters captureParams =
        parseCaptureParams(params["captureParams"]);

    // 调用 NERTC 引擎接口
    return handle->setScreenCaptureSource(source, regionRect, captureParams);

  } catch (const std::exception& e) {
    // 处理 JSON 解析异常
    return kNERtcErrInvalidParam;
  }
}
int64_t NERtcDesktopWrapper::HandleUpdateScreenCaptureRegion(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "regionRect")) {
    return kNERtcErrInvalidParam;
  }

  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  return handle->updateScreenCaptureRegion(regionRect);
}

int64_t NERtcDesktopWrapper::HandleSetScreenCaptureMouseCursor(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "captureCursor")) {
    return kNERtcErrInvalidParam;
  }

  bool captureCursor = params["captureCursor"].get<bool>();
  return handle->setScreenCaptureMouseCursor(captureCursor);
}

int64_t NERtcDesktopWrapper::HandleStopScreenCapture(IRtcEngineEx* handle,
                                                     const json& params) {
  return handle->stopScreenCapture();
}

int64_t NERtcDesktopWrapper::HandlePauseScreenCapture(IRtcEngineEx* handle,
                                                      const json& params) {
  return handle->pauseScreenCapture();
}

int64_t NERtcDesktopWrapper::HandleResumeScreenCapture(IRtcEngineEx* handle,
                                                       const json& params) {
  return handle->resumeScreenCapture();
}

int64_t NERtcDesktopWrapper::HandleSetExcludeWindowList(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "excludeWindowList")) {
    return kNERtcErrInvalidParam;
  }

  auto excludeWindowList =
      params["excludeWindowList"].get<std::vector<int64_t>>();

  // 转换为 NERTC 需要的格式
  static std::vector<source_id_t> windowIds;
  windowIds.clear();
  for (int64_t windowId : excludeWindowList) {
    windowIds.push_back(reinterpret_cast<source_id_t>(windowId));
  }

  return handle->setExcludeWindowList(windowIds.data(),
                                      static_cast<int>(windowIds.size()));
}

int64_t NERtcDesktopWrapper::HandleUpdateScreenCaptureParameters(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);
  return handle->updateScreenCaptureParameters(captureParams);
}