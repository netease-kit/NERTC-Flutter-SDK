// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "engine_wrapper.h"

IDeviceCollection* NERtcDesktopWrapper::video_device_collection_ = nullptr;
IDeviceCollection* NERtcDesktopWrapper::audio_cap_device_collection_ = nullptr;
IDeviceCollection* NERtcDesktopWrapper::audio_play_device_collection_ = nullptr;

// 获取视频采集设备 controller.
int64_t NERtcDesktopWrapper::HandleEnumerateCaptureDevices(IRtcEngineEx* handle,
                                                           const json& params) {
  if (video_device_collection_) {
    video_device_collection_->destroy();
    video_device_collection_ = nullptr;
  }

  nertc::IVideoDeviceManager* manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDVideoDeviceManager, (void**)&manager);
  if (manager) {
    video_device_collection_ = manager->enumerateCaptureDevices();
    printf("enumerateCaptureDevices");
  } else {
    return kNERtcErrFatal;
  }

  return kNERtcNoError;
}

int64_t NERtcDesktopWrapper::HandleEnumerateAudioDevices(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!params.contains("usage")) {
    return kNERtcErrInvalidParam;
  }
  int usage = params.value("usage", 0);
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (usage == 0) {
    // record.
    if (audio_cap_device_collection_) {
      audio_cap_device_collection_->destroy();
      audio_cap_device_collection_ = nullptr;
    }

    if (!audio_cap_device_collection_) {
      audio_cap_device_collection_ = audio_manager->enumerateRecordDevices();
      printf("enumerateRecordingDevices");
    } else {
      return kNERtcErrInvalidState;
    }
  } else if (usage == 1) {
    // play.
    if (audio_play_device_collection_) {
      audio_play_device_collection_->destroy();
      audio_play_device_collection_ = nullptr;
    }

    if (!audio_play_device_collection_) {
      audio_play_device_collection_ = audio_manager->enumeratePlayoutDevices();
      printf("enumeratePlaybackDevices");
    } else {
      return kNERtcErrInvalidState;
    }
  }
  return kNERtcNoError;
}

int64_t NERtcDesktopWrapper::HandleGetDeviceCount(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!params.contains("type") || !params.contains("usage")) {
    return kNERtcErrInvalidParam;
  }
  int type = params.value("type", 0);
  int usage = params.value("usage", 0);
  if (type == 1) {
    if (!video_device_collection_) return kNERtcErrInvalidParam;
    int count = video_device_collection_->getCount();
    return count;
  } else {
    if (usage == 0) {
      // record.
      if (!audio_cap_device_collection_) return kNERtcErrInvalidParam;
      int count = audio_cap_device_collection_->getCount();
      return count;
    } else if (usage == 1) {
      // play.
      if (!audio_play_device_collection_) return kNERtcErrInvalidParam;
      int count = audio_play_device_collection_->getCount();
      return count;
    }
    return kNERtcErrFatal;  // Unsupported device type.
  }
}

int64_t NERtcDesktopWrapper::HandleReleaseDevice(IRtcEngineEx* handle,
                                                 const json& params) {
  if (!params.contains("type") || !params.contains("usage")) {
    return kNERtcErrInvalidParam;
  }
  int type = params.value("type", 0);
  int usage = params.value("usage", 0);
  if (type == 1) {
    if (!video_device_collection_) return kNERtcErrInvalidState;
    video_device_collection_->destroy();
    video_device_collection_ = nullptr;
  } else {
    if (usage == 0) {
      // record.
      if (!audio_cap_device_collection_) return kNERtcErrInvalidState;
      audio_cap_device_collection_->destroy();
      audio_cap_device_collection_ = nullptr;
    } else if (usage == 1) {
      // play.
      if (!audio_play_device_collection_) return kNERtcErrInvalidState;
      audio_play_device_collection_->destroy();
      audio_play_device_collection_ = nullptr;
    }
  }
  return 0;
}

int64_t NERtcDesktopWrapper::HandleSetDevice(IRtcEngineEx* handle,
                                             const json& params) {
  if (!params.contains("type") || !params.contains("deviceId") ||
      !params.contains("usage") || !params.contains("streamType")) {
    return kNERtcErrInvalidParam;
  }
  int type = params.value("type", 0);
  int usage = params.value("usage", 0);
  std::string device_id = params.value("deviceId", "");
  int streamType = params.value("streamType", 0);
  if (type == 1) {
    nertc::IVideoDeviceManager* manager = nullptr;
    handle->queryInterface(nertc::kNERtcIIDVideoDeviceManager,
                           (void**)&manager);
    if (manager) {
      return manager->setDevice(device_id.c_str(),
                                static_cast<NERtcVideoStreamType>(streamType));
    }
    return kNERtcErrInvalidState;
  } else {
    if (usage == 0) {
      // record.
      nertc::IAudioDeviceManager* audio_manager = nullptr;
      handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                             (void**)&audio_manager);
      if (audio_manager) {
        return audio_manager->setRecordDevice(device_id.c_str());
      }
    } else if (usage == 1) {
      // play.
      nertc::IAudioDeviceManager* audio_manager = nullptr;
      handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                             (void**)&audio_manager);
      if (audio_manager) {
        return audio_manager->setPlayoutDevice(device_id.c_str());
      }
    }
  }
  return kNERtcErrFatal;  // Unsupported device type.
}

std::string NERtcDesktopWrapper::HandleQueryDevice(IRtcEngineEx* handle,
                                                   const json& params) {
  if (!params.contains("streamType") || !params.contains("type") ||
      !params.contains("usage")) {
    return GeneratorErrorJson(kNERtcErrInvalidParam, "params is invalid.")
        .dump();
  }
  int streamType = params.value("streamType", 0);
  int type = params.value("type", 0);
  int usage = params.value("usage", 0);
  if (type == 1) {
    nertc::IVideoDeviceManager* manager = nullptr;
    handle->queryInterface(nertc::kNERtcIIDVideoDeviceManager,
                           (void**)&manager);
    if (manager) {
      char device_id[kNERtcMaxDeviceIDLength] = {0};
      int ret = manager->getDevice(
          device_id, static_cast<NERtcVideoStreamType>(streamType));
      if (ret != 0) {
        return GeneratorErrorJson(ret, "Failed to query device information.")
            .dump();
      }
      json result = GeneratorErrorJson(kNERtcNoError, "success");
      result["deviceId"] = device_id;
      return result.dump();
    }
  } else {
    nertc::IAudioDeviceManager* audio_manager = nullptr;
    handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                           (void**)&audio_manager);
    if (audio_manager) {
      char device_id[kNERtcMaxDeviceIDLength] = {0};
      if (usage == 0) {
        // record.
        int ret = audio_manager->getRecordDevice(device_id);
        if (ret != 0) {
          return GeneratorErrorJson(
                     ret, "Failed to query audio capture device information.")
              .dump();
        }
      } else if (usage == 1) {
        // play.
        int ret = audio_manager->getPlayoutDevice(device_id);
        if (ret != 0) {
          return GeneratorErrorJson(
                     ret, "Failed to query audio playback device information.")
              .dump();
        }
      }
      json result = GeneratorErrorJson(kNERtcNoError, "success");
      result["deviceId"] = device_id;
      return result.dump();
    }
  }
  return GeneratorErrorJson(kNERtcErrInvalidParam, "Unsupported device type.")
      .dump();
}

std::string NERtcDesktopWrapper::HandleGetDevice(IRtcEngineEx* handle,
                                                 const json& params) {
  if (!params.contains("type") || !params.contains("index") ||
      !params.contains("usage")) {
    return GeneratorErrorJson(kNERtcErrInvalidParam, "params is invalid.")
        .dump();
  }
  int type = params.value("type", 0);
  int index = params.value("index", 0);
  int usage = params.value("usage", 0);
  if (type == 1) {
    if (!video_device_collection_) {
      return GeneratorErrorJson(kNERtcErrInvalidState,
                                "Video device collection is not initialized.")
          .dump();
    }
    char device_name[kNERtcMaxDeviceNameLength] = {0};
    char device_id[kNERtcMaxDeviceIDLength] = {0};
    int get_device_ret =
        video_device_collection_->getDevice(index, device_name, device_id);
    if (get_device_ret != 0) {
      return GeneratorErrorJson(get_device_ret,
                                "Failed to get device information.")
          .dump();
    }
    json result = GeneratorErrorJson(kNERtcNoError, "success");
    result["deviceName"] = device_name;
    result["deviceId"] = device_id;
    return result.dump();
  } else {
    if (usage == 0) {
      // record.
      if (!audio_cap_device_collection_) {
        return GeneratorErrorJson(
                   kNERtcErrInvalidState,
                   "Audio capture device collection is not initialized.")
            .dump();
      }
      char device_name[kNERtcMaxDeviceNameLength] = {0};
      char device_id[kNERtcMaxDeviceIDLength] = {0};
      int get_device_ret = audio_cap_device_collection_->getDevice(
          index, device_name, device_id);
      if (get_device_ret != 0) {
        return GeneratorErrorJson(
                   get_device_ret,
                   "Failed to get audio capture device information.")
            .dump();
      }
      json result = GeneratorErrorJson(kNERtcNoError, "success");
      result["deviceName"] = device_name;
      result["deviceId"] = device_id;
      return result.dump();
    } else if (usage == 1) {
      // play.
      if (!audio_play_device_collection_) {
        return GeneratorErrorJson(
                   kNERtcErrInvalidState,
                   "Audio playback device collection is not initialized.")
            .dump();
      }
      char device_name[kNERtcMaxDeviceNameLength] = {0};
      char device_id[kNERtcMaxDeviceIDLength] = {0};
      int get_device_ret = audio_play_device_collection_->getDevice(
          index, device_name, device_id);
      if (get_device_ret != 0) {
        return GeneratorErrorJson(
                   get_device_ret,
                   "Failed to get audio playback device information.")
            .dump();
      }
      json result = GeneratorErrorJson(kNERtcNoError, "success");
      result["deviceName"] = device_name;
      result["deviceId"] = device_id;
      return result.dump();
    }
  }
  return GeneratorErrorJson(kNERtcErrInvalidParam, "Unsupported device type.")
      .dump();
}

std::string NERtcDesktopWrapper::HandleGetDeviceInfo(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!params.contains("type") || !params.contains("index") ||
      !params.contains("usage")) {
    return GeneratorErrorJson(kNERtcErrInvalidParam, "params is invalid.")
        .dump();
  }
  int type = params.value("type", 0);
  int index = params.value("index", 0);
  int usage = params.value("usage", 0);
  if (type == 1) {
    if (!video_device_collection_) {
      return GeneratorErrorJson(kNERtcErrInvalidState,
                                "Video device collection is not initialized.")
          .dump();
    }
    NERtcDeviceInfo device_info;
    int get_device_info_ret =
        video_device_collection_->getDeviceInfo(index, &device_info);
    if (get_device_info_ret != 0) {
      return GeneratorErrorJson(get_device_info_ret,
                                "Failed to get device information.")
          .dump();
    }
    json result = GeneratorErrorJson(kNERtcNoError, "success");
    result["deviceName"] = device_info.device_name;
    result["deviceId"] = device_info.device_id;
    result["transportType"] = device_info.transport_type;
    result["suspectedUnavailable"] = device_info.suspected_unavailable;
    result["systemDefaultDevice"] = device_info.system_default_device;
    result["systemPriorityDevice"] = device_info.select_priority_device;
    return result.dump();
  } else {
    if (usage == 0) {
      // record.
      if (!audio_cap_device_collection_) {
        return GeneratorErrorJson(
                   kNERtcErrInvalidState,
                   "Audio capture device collection is not initialized.")
            .dump();
      }
      NERtcDeviceInfo device_info;
      int get_device_info_ret =
          audio_cap_device_collection_->getDeviceInfo(index, &device_info);
      if (get_device_info_ret != 0) {
        return GeneratorErrorJson(
                   get_device_info_ret,
                   "Failed to get audio capture device information.")
            .dump();
      }
      json result = GeneratorErrorJson(kNERtcNoError, "success");
      result["deviceName"] = device_info.device_name;
      result["deviceId"] = device_info.device_id;
      result["transportType"] = device_info.transport_type;
      result["suspectedUnavailable"] = device_info.suspected_unavailable;
      result["systemDefaultDevice"] = device_info.system_default_device;
      result["systemPriorityDevice"] = device_info.select_priority_device;
      return result.dump();
    } else if (usage == 1) {
      // play.
      if (!audio_play_device_collection_) {
        return GeneratorErrorJson(
                   kNERtcErrInvalidState,
                   "Audio playback device collection is not initialized.")
            .dump();
      }
      NERtcDeviceInfo device_info;
      int get_device_info_ret =
          audio_play_device_collection_->getDeviceInfo(index, &device_info);
      if (get_device_info_ret != 0) {
        return GeneratorErrorJson(
                   get_device_info_ret,
                   "Failed to get audio playback device information.")
            .dump();
      }
      json result = GeneratorErrorJson(kNERtcNoError, "success");
      result["deviceName"] = device_info.device_name;
      result["deviceId"] = device_info.device_id;
      result["transportType"] = device_info.transport_type;
      result["suspectedUnavailable"] = device_info.suspected_unavailable;
      result["systemDefaultDevice"] = device_info.system_default_device;
      result["systemPriorityDevice"] = device_info.select_priority_device;
      return result.dump();
    }
  }
  return GeneratorErrorJson(kNERtcErrInvalidParam, "Unsupported device type.")
      .dump();
}
