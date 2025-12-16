// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "convert.h"
using namespace nertc;
using namespace nlohmann;

bool IsContainsValue(const json& jsonObj, const char* key) {
  return jsonObj.contains(key) && !jsonObj[key].is_null();
}

bool JsonConvertEngineContext(const json& body, NERtcEngineContext& context,
                              std::vector<std::string>& auto_mem) {
  if (!body.contains("appKey") || body["appKey"].is_null()) {
    return false;
  }

  auto_mem.reserve(20);
  std::string app_key = body.value("appKey", "");
  auto_mem.push_back(app_key);  // move memory management to auto_mem
  context.app_key = auto_mem.back().c_str();

  if (body.contains("options")) {
    json options = body.at("options");
    if (options.contains("logDir") && !options["logDir"].is_null()) {
      std::string log_dir_path = options.value("logDir", "");
      auto_mem.push_back(log_dir_path);  // move memory management to auto_mem
      context.log_dir_path = auto_mem.back().c_str();
    }
    if (options.contains("logLevel")) {
      context.log_level =
          options.value("logLevel", NERtcLogLevel::kNERtcLogLevelWarning);
    }

    // 私有化地址配置
    {
      if (IsContainsValue(options, "serverAddresses")) {
        json server_addresses = options.at("serverAddresses");

        // 通道信息服务器
        if (IsContainsValue(server_addresses, "channelServer")) {
          std::string channel_server =
              server_addresses.value("channelServer", "");
          auto_mem.push_back(
              channel_server);  // move memory management to auto_mem
          strncpy(context.server_config.channel_server, auto_mem.back().c_str(),
                  kNERtcMaxURILength);
          context.server_config.channel_server[kNERtcMaxURILength - 1] = '\0';
        }

        // 统计上报服务器
        if (IsContainsValue(server_addresses, "statisticsServer")) {
          std::string statistics_server =
              server_addresses.value("statisticsServer", "");
          auto_mem.push_back(
              statistics_server);  // move memory management to auto_mem
          strncpy(context.server_config.statistics_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.statistics_server[kNERtcMaxURILength - 1] =
              '\0';
        }

        // 统计调度服务器
        if (IsContainsValue(server_addresses, "statisticsDispatchServer")) {
          std::string statisticsDispatchServer =
              server_addresses.value("statisticsDispatchServer", "");
          auto_mem.push_back(
              statisticsDispatchServer);  // move memory management to auto_mem
          strncpy(context.server_config.statistics_dispatch_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config
              .statistics_dispatch_server[kNERtcMaxURILength - 1] = '\0';
        }

        // 统计备份服务器
        if (IsContainsValue(server_addresses, "statisticsBackupServer")) {
          std::string statisticsBackupServer =
              server_addresses.value("statisticsBackupServer", "");
          auto_mem.push_back(
              statisticsBackupServer);  // move memory management to auto_mem
          strncpy(context.server_config.statistics_backup_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config
              .statistics_backup_server[kNERtcMaxURILength - 1] = '\0';
        }

        if (IsContainsValue(server_addresses, "roomServer")) {
          std::string roomServer = server_addresses.value("roomServer", "");
          auto_mem.push_back(roomServer);  // move memory management to auto_mem
          strncpy(context.server_config.room_server, auto_mem.back().c_str(),
                  kNERtcMaxURILength);
          context.server_config.room_server[kNERtcMaxURILength - 1] = '\0';
        }

        if (IsContainsValue(server_addresses, "compatServer")) {
          std::string compatServer = server_addresses.value("compatServer", "");
          auto_mem.push_back(
              compatServer);  // move memory management to auto_mem
          strncpy(context.server_config.compat_server, auto_mem.back().c_str(),
                  kNERtcMaxURILength);
          context.server_config.compat_server[kNERtcMaxURILength - 1] = '\0';
        }

        if (IsContainsValue(server_addresses, "nosLbsServer")) {
          std::string nosLbsServer = server_addresses.value("nosLbsServer", "");
          auto_mem.push_back(
              nosLbsServer);  // move memory management to auto_mem
          strncpy(context.server_config.nos_lbs_server, auto_mem.back().c_str(),
                  kNERtcMaxURILength);
          context.server_config.nos_lbs_server[kNERtcMaxURILength - 1] = '\0';
        }

        if (IsContainsValue(server_addresses, "nosUploadServer")) {
          std::string nosUploadServer =
              server_addresses.value("nosUploadServer", "");
          auto_mem.push_back(
              nosUploadServer);  // move memory management to auto_mem
          strncpy(context.server_config.nos_upload_sever,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.nos_upload_sever[kNERtcMaxURILength - 1] = '\0';
        }

        if (IsContainsValue(server_addresses, "nosTokenServer")) {
          std::string nosTokenServer =
              server_addresses.value("nosTokenServer", "");
          auto_mem.push_back(
              nosTokenServer);  // move memory management to auto_mem
          strncpy(context.server_config.nos_token_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.nos_token_server[kNERtcMaxURILength - 1] = '\0';
        }

        if (IsContainsValue(server_addresses, "cloudProxyServer")) {
          std::string cloudProxyServer =
              server_addresses.value("cloudProxyServer", "");
          auto_mem.push_back(
              cloudProxyServer);  // move memory management to auto_mem
          strncpy(context.server_config.cloud_proxy_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.cloud_proxy_server[kNERtcMaxURILength - 1] =
              '\0';
        }

        if (IsContainsValue(server_addresses, "webSocketProxyServer")) {
          std::string webSocketProxyServer =
              server_addresses.value("webSocketProxyServer", "");
          auto_mem.push_back(
              webSocketProxyServer);  // move memory management to auto_mem
          strncpy(context.server_config.websocket_proxy_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.websocket_proxy_server[kNERtcMaxURILength - 1] =
              '\0';
        }

        if (IsContainsValue(server_addresses, "quicProxyServer")) {
          std::string quicProxyServer =
              server_addresses.value("quicProxyServer", "");
          auto_mem.push_back(
              quicProxyServer);  // move memory management to auto_mem
          strncpy(context.server_config.quic_proxy_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.quic_proxy_server[kNERtcMaxURILength - 1] =
              '\0';
        }

        if (IsContainsValue(server_addresses, "mediaProxyServer")) {
          std::string mediaProxyServer =
              server_addresses.value("mediaProxyServer", "");
          auto_mem.push_back(
              mediaProxyServer);  // move memory management to auto_mem
          strncpy(context.server_config.media_proxy_server,
                  auto_mem.back().c_str(), kNERtcMaxURILength);
          context.server_config.media_proxy_server[kNERtcMaxURILength - 1] =
              '\0';
        }

        // 是否使用 IPv6
        if (IsContainsValue(server_addresses, "useIPv6")) {
          context.server_config.use_ipv6 =
              server_addresses.value("useIPv6", false);
        }
      }
    }
  }

  return true;
}

json GeneratorInitialJson(const json& body) {
  // some params body.
  json params;
  if (!IsContainsValue(body, "options")) {
    return params;  // no options, return empty object
  }

  json options = body.at("options");
  // 自动订阅音频
  if (IsContainsValue(options, "audioAutoSubscribe")) {
    params[kNERtcKeyAutoSubscribeAudio] =
        options.value("audioAutoSubscribe", false);
  }
  // 自动订阅视频
  if (IsContainsValue(options, "videoAutoSubscribe")) {
    params[kNERtcKeyAutoSubscribeVideo] =
        options.value("videoAutoSubscribe", false);
  }
  // 是否禁止第一个加入房间人员创建房间？
  if (IsContainsValue(options, "disableFirstJoinUserCreateChannel")) {
    params[kNERtcKeyDisableFirstUserCreateChannel] =
        options.value("disableFirstJoinUserCreateChannel", false);
  }
  // 设置是否开启 AI 降噪
  if (IsContainsValue(options, "audioAINSEnabled")) {
    params[kNERtcKeyAudioProcessingAINSEnable] =
        options.value("audioAINSEnabled", false);
  }
  // 是否录制主讲人
  if (IsContainsValue(options, "serverRecordSpeaker")) {
    params[kNERtcKeyRecordHostEnabled] =
        body.value("serverRecordSpeaker", false);
  }
  // 是否开启服务器录制语音
  if (IsContainsValue(options, "serverRecordAudio")) {
    params[kNERtcKeyRecordAudioEnabled] =
        body.value("serverRecordAudio", false);
  }
  // 是否开启服务器录制视频
  if (IsContainsValue(options, "serverRecordVideo")) {
    params[kNERtcKeyRecordVideoEnabled] =
        body.value("serverRecordVideo", false);
  }
  // 服务器录制模式
  if (IsContainsValue(options, "serverRecordMode")) {
    params[kNERtcKeyRecordType] = body.value("serverRecordMode", 0);
  }
  // 是否允许在房间推流时推送自身的视频流
  if (IsContainsValue(options, "publishSelfStream")) {
    params[kNERtcKeyPublishSelfStreamEnabled] =
        body.value("publishSelfStream", false);
  }

  // todo 硬件编解码设置
  // todo 视频发布模式
  // todo 开启 h265?
  // todo 是否开启 1v1 模式
  return params;
}

bool JsonConvertJoinChannel(const json& body, std::string& token,
                            std::string& channel_name, nertc::uid_t& uid,
                            NERtcJoinChannelOptions& options,
                            std::vector<std::string>& auto_mem) {
  if (body.at("channelName").is_null() && body.at("uid").is_null()) {
    return false;  // channelName and uid are required
  }
  auto_mem.reserve(10);
  channel_name = body.value("channelName", "");
  if (body["uid"].is_number()) {
    uid = body["uid"].get<int64_t>();
  }
  if (body.contains("token")) {
    token = body["token"].get<std::string>();
  }
  if (!body.at("channelOptions").is_null()) {
    json channel_options = body.at("channelOptions");
    if (!channel_options.at("customInfo").is_null()) {
      std::string custom_info = channel_options.value("customInfo", "");
      if (custom_info.length() > kNERtcCustomInfoLength) {
        printf(
            "Error: customInfo length exceeds maximum allowed length of %d "
            "characters.\n",
            kNERtcCustomInfoLength);
        return false;
      }
      auto_mem.push_back(custom_info);
#if defined(_MSC_VER)
      strcpy_s(options.custom_info, kNERtcCustomInfoLength,
               auto_mem.back().c_str());
#else
      strncpy(options.custom_info, auto_mem.back().c_str(),
              kNERtcCustomInfoLength);
      options.custom_info[kNERtcCustomInfoLength - 1] = '\0';  // 确保结尾有\0
#endif
    }
    if (!channel_options.at("permissionKey").is_null()) {
      std::string permission_key = channel_options.value("permissionKey", "");
      options.permission_key = const_cast<char*>(auto_mem.back().data());
    }
  }
  return true;
}

bool JsonConvertToSetLocalVideoConfig(const json& body, int& stream_type,
                                      NERtcVideoConfig& config) {
  if (!IsContainsValue(body, "config") ||
      !IsContainsValue(body, "streamType")) {
    return false;
  }
  stream_type = body.value("streamType", 0);
  json config_json = body.at("config");
  config.max_profile = static_cast<NERtcVideoProfileType>(config_json.value(
      "videoProfile", kNERtcVideoProfileStandard));  // default standard.
  config.width = config_json.value("width", 0);
  config.height = config_json.value("height", 0);
  config.crop_mode_ = static_cast<NERtcVideoCropMode>(
      config_json.value("videoCropMode", kNERtcVideoCropModeDefault));
  config.framerate = static_cast<NERtcVideoFramerateType>(
      config_json.value("frameRate", kNERtcVideoFramerateFpsDefault));
  config.min_framerate = static_cast<NERtcVideoFramerateType>(
      config_json.value("minFrameRate", kNERtcVideoFramerateFpsDefault));
  config.bitrate = config_json.value("bitrate", 0);
  config.min_bitrate = config_json.value("minBitrate", 0);
  config.degradation_preference = static_cast<NERtcDegradationPreference>(
      config_json.value("degradationPrefer", 0));
  config.mirror_mode =
      static_cast<NERtcVideoMirrorMode>(config_json.value("mirrorMode", 0));
  config.orientation_mode =
      static_cast<NERtcVideoOutputOrientationMode>(config_json.value(
          "orientationMode", kNERtcVideoOutputOrientationModeAdaptative));
  return true;
}

bool JsonConvertToVirtualBackground(const json& body, bool& enable, bool& force,
                                    VirtualBackgroundSource& source,
                                    std::vector<std::string>& auto_mem) {
  if (!IsContainsValue(body, "enabled")) {
    return false;  // enabled, force and backgroundSource are required
  }

  enable = body.value("enabled", false);
  if (IsContainsValue(body, "force")) {
    force = body.value("force", false);
  }

  if (IsContainsValue(body, "backgroundSource")) {
    json bg_source = body.at("backgroundSource");
    if (IsContainsValue(bg_source, "backgroundSourceType")) {
      source.background_source_type = static_cast<
          nertc::VirtualBackgroundSource::NERtcBackgroundSourceType>(
          bg_source.value(
              "backgroundSourceType",
              nertc::VirtualBackgroundSource::kNERtcBackgroundColor));
    }
    if (IsContainsValue(bg_source, "color")) {
      source.color = bg_source.value("color", 0);  // default to black color
    }
    if (IsContainsValue(bg_source, "source") &&
        bg_source["source"].is_string()) {
      std::string source_path = bg_source["source"].get<std::string>();
      auto_mem.push_back(source_path);  // move memory management to auto_mem
      source.source = const_cast<char*>(auto_mem.back().c_str());
    }
  }
  return true;
}

bool JsonConvertToSetCameraCaptureConfig(const json& body,
                                         NERtcCameraCaptureConfig& config,
                                         int& stream_type) {
  if (!IsContainsValue(body, "captureConfig") ||
      !IsContainsValue(body, "streamType")) {
    return false;
  }
  stream_type = body.value("streamType", 0);
  json capture_config = body.at("captureConfig");

  if (!IsContainsValue(capture_config, "captureWidth") ||
      !IsContainsValue(capture_config, "captureHeight")) {
    return false;
  }
  config.captureWidth = capture_config.value("captureWidth", 0);
  config.captureHeight = capture_config.value("captureHeight", 0);
  return true;
}

std::string JsonConvertToLiteParameters(const json& body) {
  json result = body;
  const std::map<std::string, std::string> keyMapping = {
      {"key_auto_subscribe_video", kNERtcKeyAutoSubscribeVideo},
      {"key_auto_subscribe_audio", kNERtcKeyAutoSubscribeAudio},
      {"key_server_record_audio", kNERtcKeyRecordAudioEnabled},
      {"key_server_record_video", kNERtcKeyRecordVideoEnabled},
      {"key_server_record_mode", kNERtcKeyRecordType},
      {"key_server_record_speaker", kNERtcKeyRecordHostEnabled},
      {"key_audio_ai_ns_enable", kNERtcKeyAudioProcessingAINSEnable},
      {"key_disable_first_user_create_channel",
       kNERtcKeyDisableFirstUserCreateChannel},
  };

  for (const auto& mapping : keyMapping) {
    if (result.contains(mapping.first)) {
      auto value = result[mapping.first];
      result.erase(mapping.first);
      result[mapping.second] = value;
    }
  }
  return result.dump();
}

json GeneratorErrorJson(int code, const std::string& error) {
  json error_json;
  error_json["code"] = code;
  error_json["error"] = error;
  return error_json;  // auto move memory management to caller
}

bool JsonConvertToStartChannelMediaRelay(
    const json& body, NERtcChannelMediaRelayConfiguration& config) {
  if (!IsContainsValue(body, "config")) {
    return false;
  }

  json config_json = body.at("config");
  // invalid parameters, if not contains destMediaInfo.
  if (!IsContainsValue(config_json, "destMediaInfo")) {
    return false;
  }

  if (IsContainsValue(config_json, "sourceMediaInfo")) {
    config.src_infos = new NERtcChannelMediaRelayInfo[1];
    json source_media_info = config_json.at("sourceMediaInfo");
    std::string channel_name = source_media_info.value("channelName", "");
    strncpy(config.src_infos[0].channel_name, channel_name.c_str(),
            kNERtcMaxChannelNameLength);
    config.src_infos[0].channel_name[kNERtcMaxChannelNameLength - 1] = '\0';

    std::string channel_token = config_json.value("channelToken", "");
    strncpy(config.src_infos[0].channel_token, channel_token.c_str(),
            kNERtcMaxTokenLength);
    config.src_infos[0].channel_token[kNERtcMaxTokenLength - 1] = '\0';
    config.src_infos[0].uid = source_media_info["channelUid"].get<int64_t>();
  }

  json dest_media_info = config_json.at("destMediaInfo");
  int dest_count = (int)dest_media_info.size();
  config.dest_count = dest_count;
  config.dest_infos = new NERtcChannelMediaRelayInfo[dest_count];

  int index = 0;
  for (auto it = dest_media_info.begin(); it != dest_media_info.end(); ++it) {
    if (index >= dest_count) break;
    std::string channel_name = it->value("channelName", "");
    strncpy(config.dest_infos[index].channel_name, channel_name.c_str(),
            kNERtcMaxChannelNameLength);
    config.dest_infos[index].channel_name[kNERtcMaxChannelNameLength - 1] =
        '\0';
    std::string channel_token = it->value("channelToken", "");
    strncpy(config.dest_infos[index].channel_token, channel_token.c_str(),
            kNERtcMaxTokenLength);
    config.dest_infos[index].channel_token[kNERtcMaxTokenLength - 1] = '\0';
    config.dest_infos[index].uid = (*it)["channelUid"].get<int64_t>();
    index++;
  }
  return true;
}

bool JsonConvertToStartLastMileProbeTest(const json& body,
                                         NERtcLastmileProbeConfig& config) {
  if (!IsContainsValue(body, "config")) {
    return false;
  }
  json config_json = body.at("config");
  config.probe_uplink = config_json["probeUplink"].get<bool>();
  config.probe_downlink = config_json["probeDownlink"].get<bool>();
  config.expected_uplink_bitratebps =
      config_json["expectedUplinkBitrate"].get<int>();
  config.expected_downlink_bitratebps =
      config_json["expectedDownlinkBitrate"].get<int>();
  return true;
}

bool JsonConvertToAddLiveStreamTask(const json& body,
                                    NERtcLiveStreamTaskInfo& task) {
  if (!IsContainsValue(body, "taskInfo")) {
    return false;
  }
  json task_info = body.at("taskInfo");
  std::string task_id = task_info["taskId"].get<std::string>();
  strncpy(task.task_id, task_id.c_str(), kNERtcMaxTaskIDLength);
  task.task_id[kNERtcMaxTaskIDLength - 1] = '\0';
  std::string stream_url = task_info["url"].get<std::string>();
  strncpy(task.stream_url, stream_url.c_str(), kNERtcMaxURILength);
  task.stream_url[kNERtcMaxURILength - 1] = '\0';
  task.server_record_enabled = task_info["serverRecordEnabled"].get<bool>();
  task.ls_mode =
      static_cast<NERtcLiveStreamMode>(task_info["liveMode"].get<int>());
  if (IsContainsValue(task_info, "layout")) {
    json layout = task_info.at("layout");
    task.layout.width = layout["width"].get<int>();
    task.layout.height = layout["height"].get<int>();
    task.layout.background_color = layout["backgroundColor"].get<int>();

    // bg_image is exists?
    if (IsContainsValue(layout, "backgroundImg")) {
      json bg_image = layout.at("backgroundImg");
      task.layout.bg_image = new NERtcLiveStreamImageInfo();
      std::string bg_image_url = bg_image["url"].get<std::string>();
      strncpy(task.layout.bg_image->url, bg_image_url.c_str(),
              kNERtcMaxURILength);
      task.layout.bg_image->url[kNERtcMaxURILength - 1] = '\0';
      task.layout.bg_image->x = bg_image["x"].get<int>();
      task.layout.bg_image->y = bg_image["y"].get<int>();
      task.layout.bg_image->width = bg_image["width"].get<int>();
      task.layout.bg_image->height = bg_image["height"].get<int>();
      task.layout.bg_image_count = 1;  // only one bg_image for flutter now.
    }

    // user transcoding.
    if (IsContainsValue(layout, "userTranscodingList")) {
      json user_transcoding_list = layout.at("userTranscodingList");
      int user_count = (int)user_transcoding_list.size();
      task.layout.user_count = user_count;
      task.layout.users = new NERtcLiveStreamUserTranscoding[user_count];
      int index = 0;
      for (auto& item : user_transcoding_list.items()) {
        if (index >= user_count) break;
        auto& value = item.value();
        task.layout.users[index].uid = value["uid"].get<int64_t>();
        task.layout.users[index].video_push = value["videoPush"].get<bool>();
        task.layout.users[index].audio_push = value["audioPush"].get<bool>();
        task.layout.users[index].adaption =
            static_cast<NERtcLiveStreamVideoScaleMode>(
                value["adaption"].get<int>());
        task.layout.users[index].x = value["x"].get<int>();
        task.layout.users[index].y = value["y"].get<int>();
        task.layout.users[index].width = value["width"].get<int>();
        task.layout.users[index].height = value["height"].get<int>();
        index++;
      }
    }
  }
  return true;
}

bool JsonConvertToStartAudioMixing(const json& body,
                                   NERtcCreateAudioMixingOption& config) {
  if (!IsContainsValue(body, "options")) {
    return false;
  }

  json config_json = body.at("options");
  if (!IsContainsValue(config_json, "path")) {
    return false;
  }
  std::string path = config_json["path"].get<std::string>();
  strncpy(config.path, path.c_str(), kNERtcMaxURILength);
  config.path[kNERtcMaxURILength - 1] = '\0';
  config.loop_count = config_json["loopCount"].get<int>();
  config.send_enabled = config_json["sendEnabled"].get<bool>();
  config.send_volume = config_json["sendVolume"].get<uint32_t>();
  config.playback_enabled = config_json["playbackEnabled"].get<bool>();
  config.playback_volume = config_json["playbackVolume"].get<uint32_t>();
  config.start_timestamp = config_json["startTimeStamp"].get<uint64_t>();
  config.send_with_audio_type = static_cast<NERtcAudioStreamType>(
      config_json["sendWithAudioType"].get<int>());
  config.progress_interval = config_json["progressInterval"].get<uint32_t>();
  return true;
}

bool JsonConvertToPlayEffect(const json& body,
                             NERtcCreateAudioEffectOption& config) {
  if (!IsContainsValue(body, "options")) {
    return false;
  }
  json options_json = body.at("options");
  // dart 传下来的 options 值肯定都是存在的
  std::string path = options_json["path"].get<std::string>();
  strncpy(config.path, path.c_str(), kNERtcMaxURILength);
  config.path[kNERtcMaxURILength - 1] = '\0';
  config.loop_count = options_json["loopCount"].get<int>();
  config.send_enabled = options_json["sendEnabled"].get<bool>();
  config.send_volume = options_json["sendVolume"].get<uint32_t>();
  config.playback_enabled = options_json["playbackEnabled"].get<bool>();
  config.playback_volume = options_json["playbackVolume"].get<uint32_t>();
  config.start_timestamp = options_json["startTimestamp"].get<uint64_t>();
  config.send_with_audio_type = static_cast<NERtcAudioStreamType>(
      options_json["sendWithAudioType"].get<int>());
  config.progress_interval = options_json["progressInterval"].get<uint32_t>();
  return true;
}

bool JsonConvertToLocalVideoWatermarkConfigsForRecording(
    const json& config_json, NERtcVideoWatermarkConfig& config) {
  std::string watermark_type = config_json["WatermarkType"].get<std::string>();
  if (watermark_type == "kNERtcVideoWatermarkTypeImage") {
    config.watermark_type =
        nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeImage;
  } else if (watermark_type == "kNERtcVideoWatermarkTypeText") {
    config.watermark_type =
        nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeText;
  } else if (watermark_type == "kNERtcVideoWatermarkTypeTimeStamp") {
    config.watermark_type =
        nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeTimestamp;
  } else {
    return false;  // not support.
  }

  if (config.watermark_type ==
      nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeImage) {
    if (!IsContainsValue(config_json, "imageWatermark")) {
      return false;
    }

    // image watermark handle.
    json image_watermark_json = config_json.at("imageWatermark");
    config.image_watermarks.wm_alpha =
        image_watermark_json["wmAlpha"].get<float>();
    config.image_watermarks.wm_width =
        image_watermark_json["wmWidth"].get<int>();
    config.image_watermarks.wm_height =
        image_watermark_json["wmHeight"].get<int>();
    config.image_watermarks.offset_x =
        image_watermark_json["offsetX"].get<int>();
    config.image_watermarks.offset_y =
        image_watermark_json["offsetY"].get<int>();
    config.image_watermarks.fps = image_watermark_json["fps"].get<int>();
    config.image_watermarks.loop = image_watermark_json["loop"].get<bool>();

    if (IsContainsValue(image_watermark_json, "imagePaths")) {
      json image_watermark_paths = image_watermark_json.at("imagePaths");
      int image_watermark_count = (int)image_watermark_paths.size();
      int index = 0;
      for (auto& item : image_watermark_paths.items()) {
        if (index >= image_watermark_count) break;
        std::string image_path = item.value().get<std::string>();
        strncpy(config.image_watermarks.image_paths[index], image_path.c_str(),
                kNERtcMaxURILength);
        config.image_watermarks.image_paths[index][kNERtcMaxURILength - 1] =
            '\0';
        index++;
      }
    }
    return true;
  } else if (config.watermark_type ==
             nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeText) {
    if (!IsContainsValue(config_json, "textWatermark")) {
      return false;
    }

    // text watermark handle.
    json text_watermark_json = config_json.at("textWatermark");
    config.text_watermarks.wm_alpha =
        text_watermark_json["wmAlpha"].get<float>();
    config.text_watermarks.wm_width = text_watermark_json["wmWidth"].get<int>();
    config.text_watermarks.wm_height =
        text_watermark_json["wmHeight"].get<int>();
    config.text_watermarks.offset_x = text_watermark_json["offsetX"].get<int>();
    config.text_watermarks.offset_y = text_watermark_json["offsetY"].get<int>();
    config.text_watermarks.wm_color = text_watermark_json["wmColor"].get<int>();
    config.text_watermarks.font_size =
        text_watermark_json["fontSize"].get<int>();
    config.text_watermarks.font_color =
        text_watermark_json["fontColor"].get<int>();
    std::string font_name =
        text_watermark_json["fontNameOrPath"].get<std::string>();
    strncpy(config.text_watermarks.font_name, font_name.c_str(),
            kNERtcMaxURILength);
    config.text_watermarks.font_name[kNERtcMaxURILength - 1] = '\0';
    std::string content = text_watermark_json["content"].get<std::string>();
    strncpy(config.text_watermarks.content, content.c_str(),
            kNERtcMaxBuffLength);
    config.text_watermarks.content[kNERtcMaxBuffLength - 1] = '\0';
    return true;
  } else if (config.watermark_type ==
             nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeTimestamp) {
    if (!IsContainsValue(config_json, "timestampWatermark")) {
      return false;
    }

    // image and text watermark handle.
    json timestamp_watermark_json = config_json.at("timestampWatermark");
    config.timestamp_watermark.wm_alpha =
        timestamp_watermark_json["wmAlpha"].get<float>();
    config.timestamp_watermark.wm_width =
        timestamp_watermark_json["wmWidth"].get<int>();
    config.timestamp_watermark.wm_height =
        timestamp_watermark_json["wmHeight"].get<int>();
    config.timestamp_watermark.offset_x =
        timestamp_watermark_json["offsetX"].get<int>();
    config.timestamp_watermark.offset_y =
        timestamp_watermark_json["offsetY"].get<int>();
    config.timestamp_watermark.wm_color =
        timestamp_watermark_json["wmColor"].get<int>();
    config.timestamp_watermark.font_size =
        timestamp_watermark_json["fontSize"].get<int>();
    config.timestamp_watermark.font_color =
        timestamp_watermark_json["fontColor"].get<int>();
    std::string font_name =
        timestamp_watermark_json["fontNameOrPath"].get<std::string>();
    strncpy(config.timestamp_watermark.font_name, font_name.c_str(),
            kNERtcMaxURILength);
    config.timestamp_watermark.font_name[kNERtcMaxURILength - 1] = '\0';
    return true;
  }
  return false;
}

bool JsonConvertToLocalVideoWatermarkConfigs(
    const json& body, NERtcVideoWatermarkConfig& config) {
  json config_json = body.at("config");
  std::string watermark_type = config_json["WatermarkType"].get<std::string>();
  if (watermark_type == "kNERtcVideoWatermarkTypeImage") {
    config.watermark_type =
        nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeImage;
  } else if (watermark_type == "kNERtcVideoWatermarkTypeText") {
    config.watermark_type =
        nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeText;
  } else if (watermark_type == "kNERtcVideoWatermarkTypeTimeStamp") {
    config.watermark_type =
        nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeTimestamp;
  } else {
    return false;  // not support.
  }

  if (config.watermark_type ==
      nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeImage) {
    if (!IsContainsValue(config_json, "imageWatermark")) {
      return false;
    }

    // image watermark handle.
    json image_watermark_json = config_json.at("imageWatermark");
    config.image_watermarks.wm_alpha =
        image_watermark_json["wmAlpha"].get<float>();
    config.image_watermarks.wm_width =
        image_watermark_json["wmWidth"].get<int>();
    config.image_watermarks.wm_height =
        image_watermark_json["wmHeight"].get<int>();
    config.image_watermarks.offset_x =
        image_watermark_json["offsetX"].get<int>();
    config.image_watermarks.offset_y =
        image_watermark_json["offsetY"].get<int>();
    config.image_watermarks.fps = image_watermark_json["fps"].get<int>();
    config.image_watermarks.loop = image_watermark_json["loop"].get<bool>();

    if (IsContainsValue(image_watermark_json, "imagePaths")) {
      json image_watermark_paths = image_watermark_json.at("imagePaths");
      int image_watermark_count = (int)image_watermark_paths.size();
      int index = 0;
      for (auto& item : image_watermark_paths.items()) {
        if (index >= image_watermark_count) break;
        std::string image_path = item.value().get<std::string>();
        strncpy(config.image_watermarks.image_paths[index], image_path.c_str(),
                kNERtcMaxURILength);
        config.image_watermarks.image_paths[index][kNERtcMaxURILength - 1] =
            '\0';
        index++;
      }
    }
    return true;
  } else if (config.watermark_type ==
             nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeText) {
    if (!IsContainsValue(config_json, "textWatermark")) {
      return false;
    }

    // text watermark handle.
    json text_watermark_json = config_json.at("textWatermark");
    config.text_watermarks.wm_alpha =
        text_watermark_json["wmAlpha"].get<float>();
    config.text_watermarks.wm_width = text_watermark_json["wmWidth"].get<int>();
    config.text_watermarks.wm_height =
        text_watermark_json["wmHeight"].get<int>();
    config.text_watermarks.offset_x = text_watermark_json["offsetX"].get<int>();
    config.text_watermarks.offset_y = text_watermark_json["offsetY"].get<int>();
    config.text_watermarks.wm_color = text_watermark_json["wmColor"].get<int>();
    config.text_watermarks.font_size =
        text_watermark_json["fontSize"].get<int>();
    config.text_watermarks.font_color =
        text_watermark_json["fontColor"].get<int>();
    std::string font_name =
        text_watermark_json["fontNameOrPath"].get<std::string>();
    strncpy(config.text_watermarks.font_name, font_name.c_str(),
            kNERtcMaxURILength);
    config.text_watermarks.font_name[kNERtcMaxURILength - 1] = '\0';
    std::string content = text_watermark_json["content"].get<std::string>();
    strncpy(config.text_watermarks.content, content.c_str(),
            kNERtcMaxBuffLength);
    config.text_watermarks.content[kNERtcMaxBuffLength - 1] = '\0';
    return true;
  } else if (config.watermark_type ==
             nertc::NERtcVideoWatermarkConfig::kNERtcWatermarkTypeTimestamp) {
    if (!IsContainsValue(config_json, "timestampWatermark")) {
      return false;
    }

    // image and text watermark handle.
    json timestamp_watermark_json = config_json.at("timestampWatermark");
    config.timestamp_watermark.wm_alpha =
        timestamp_watermark_json["wmAlpha"].get<float>();
    config.timestamp_watermark.wm_width =
        timestamp_watermark_json["wmWidth"].get<int>();
    config.timestamp_watermark.wm_height =
        timestamp_watermark_json["wmHeight"].get<int>();
    config.timestamp_watermark.offset_x =
        timestamp_watermark_json["offsetX"].get<int>();
    config.timestamp_watermark.offset_y =
        timestamp_watermark_json["offsetY"].get<int>();
    config.timestamp_watermark.wm_color =
        timestamp_watermark_json["wmColor"].get<int>();
    config.timestamp_watermark.font_size =
        timestamp_watermark_json["fontSize"].get<int>();
    config.timestamp_watermark.font_color =
        timestamp_watermark_json["fontColor"].get<int>();
    std::string font_name =
        timestamp_watermark_json["fontNameOrPath"].get<std::string>();
    strncpy(config.timestamp_watermark.font_name, font_name.c_str(),
            kNERtcMaxURILength);
    config.timestamp_watermark.font_name[kNERtcMaxURILength - 1] = '\0';
    return true;
  }
  return false;
}

bool JsonConvertToLocalRecordingConfig(const json& config_json,
                                       NERtcLocalRecordingConfig& config) {
  if (IsContainsValue(config_json, "filePath")) {
    std::string file_path = config_json["filePath"].get<std::string>();
    strncpy(config.file_path, file_path.c_str(), sizeof(config.file_path) - 1);
    config.file_path[sizeof(config.file_path) - 1] = '\0';
  }

  if (IsContainsValue(config_json, "fileName")) {
    std::string file_name = config_json["fileName"].get<std::string>();
    strncpy(config.file_name, file_name.c_str(), sizeof(config.file_name) - 1);
    config.file_name[sizeof(config.file_name) - 1] = '\0';
  }

  if (IsContainsValue(config_json, "width")) {
    config.width = config_json["width"].get<int>();
  }
  if (IsContainsValue(config_json, "height")) {
    config.height = config_json["height"].get<int>();
  }

  if (IsContainsValue(config_json, "framerate")) {
    config.framerate = config_json["framerate"].get<int>();
  }

  if (IsContainsValue(config_json, "recordFileType")) {
    config.record_file_type = static_cast<NERtcLocalRecordingFileType>(
        config_json["recordFileType"].get<int>());
  }

  if (IsContainsValue(config_json, "remuxToMp4")) {
    config.remux_to_mp4 = config_json["remuxToMp4"].get<bool>();
  }

  if (IsContainsValue(config_json, "videoMerge")) {
    config.video_merge = config_json["videoMerge"].get<bool>();
  }

  if (IsContainsValue(config_json, "recordAudio")) {
    config.record_audio = config_json["recordAudio"].get<bool>();
  }

  if (IsContainsValue(config_json, "audioFormat")) {
    config.audio_format = static_cast<NERtcLocalRecordingAudioFormat>(
        config_json["audioFormat"].get<int>());
  }

  if (IsContainsValue(config_json, "recordVideo")) {
    config.record_video = config_json["recordVideo"].get<bool>();
  }

  if (IsContainsValue(config_json, "videoRecordMode")) {
    config.video_record_mode = static_cast<NERtcLocalRecordingVideoMode>(
        config_json["videoRecordMode"].get<int>());
  }

  if (IsContainsValue(config_json, "watermarkList")) {
    json watermark_list_json = config_json.at("watermarkList");
    int list_len = watermark_list_json.size();
    config.watermark_list = new NERtcVideoWatermarkConfig[list_len];
    for (int i = 0; i < list_len; i++) {
      json watermark_json = watermark_list_json[i];
      JsonConvertToLocalVideoWatermarkConfigsForRecording(
          watermark_json, config.watermark_list[i]);
    }
    config.watermark_count = list_len;
  }

  if (IsContainsValue(config_json, "watermark_count")) {
    config.watermark_count = config_json["watermark_count"].get<int>();
  }

  if (IsContainsValue(config_json, "coverFilePath")) {
    std::string cover_file_path =
        config_json["coverFilePath"].get<std::string>();
    strncpy(config.cover_file_path, cover_file_path.c_str(),
            sizeof(config.cover_file_path) - 1);
    config.cover_file_path[sizeof(config.cover_file_path) - 1] = '\0';
  }

  if (IsContainsValue(config_json, "coverWatermarkList")) {
    json cover_watermark_list_json = config_json.at("coverWatermarkList");
    int list_len = cover_watermark_list_json.size();
    config.cover_watermark_list = new NERtcVideoWatermarkConfig[list_len];
    for (int i = 0; i < list_len; i++) {
      json cover_watermark_json = cover_watermark_list_json[i];
      JsonConvertToLocalVideoWatermarkConfigsForRecording(
          cover_watermark_json, config.cover_watermark_list[i]);
    }
    config.cover_watermark_count = list_len;
  }

  if (IsContainsValue(config_json, "defaultCoverFilePath")) {
    std::string default_cover_file_path =
        config_json["defaultCoverFilePath"].get<std::string>();
    strncpy(config.default_cover_file_path, default_cover_file_path.c_str(),
            sizeof(config.default_cover_file_path) - 1);
    config.default_cover_file_path[sizeof(config.default_cover_file_path) - 1] =
        '\0';
  }
  return true;
}

bool JsonConvertToLocalRecordingLayoutConfig(
    const json& body, NERtcLocalRecordingLayoutConfig& config) {
  if (IsContainsValue(body, "offsetX")) {
    config.offset_x = body["offsetX"].get<int>();
  }
  if (IsContainsValue(body, "offsetY")) {
    config.offset_y = body["offsetY"].get<int>();
  }
  if (IsContainsValue(body, "width")) {
    config.width = body["width"].get<int>();
  }
  if (IsContainsValue(body, "height")) {
    config.height = body["height"].get<int>();
  }
  if (IsContainsValue(body, "scalingMode")) {
    config.scaling_mode =
        static_cast<NERtcVideoScalingMode>(body["scalingMode"].get<int>());
  }
  if (IsContainsValue(body, "watermarkList")) {
    json watermark_list_json = body.at("watermarkList");
    int list_len = watermark_list_json.size();
    config.watermark_list = new NERtcVideoWatermarkConfig[list_len];
    for (int i = 0; i < list_len; i++) {
      json watermark_json = watermark_list_json[i];
      JsonConvertToLocalVideoWatermarkConfigsForRecording(
          watermark_json, config.watermark_list[i]);
    }
    config.watermark_count = list_len;
  }
  if (IsContainsValue(body, "isScreenShare")) {
    config.is_screen_share = body["isScreenShare"].get<bool>();
  }
  if (IsContainsValue(body, "bgColor")) {
    config.bg_color = body["bgColor"].get<uint32_t>();
  }
  return true;
}

bool JsonConvertToLocalRecordingStreamInfo(
    const json& body, NERtcLocalRecordingStreamInfo& config) {
  if (IsContainsValue(body, "uid")) {
    config.uid = body["uid"].get<uint64_t>();
  }
  if (IsContainsValue(body, "streamType")) {
    config.stream_type =
        static_cast<NERtcVideoStreamType>(body["streamType"].get<int>());
  }
  if (IsContainsValue(body, "streamLayer")) {
    config.stream_layer = body["streamLayer"].get<int>();
  }
  if (IsContainsValue(body, "layoutConfig")) {
    json layout_config_json = body.at("layoutConfig");
    JsonConvertToLocalRecordingLayoutConfig(layout_config_json,
                                            config.layout_config);
  }
  return true;
}
