// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "engine_wrapper.h"

void NERtcDesktopWrapper::onRtcStats(const NERtcStats& stats) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  json result;
  result["method"] = kNERtcOnStats;
  result["rxAudioBytes"] = stats.rx_audio_bytes;        // 接收音频字节数
  result["rxAudioKBitRate"] = stats.rx_audio_kbitrate;  // 接收音频码率
  result["rxAudioJitter"] = stats.rx_audio_jitter;      // 接收音频抖动
  result["rxAudioPacketLossRate"] =
      stats.rx_audio_packet_loss_rate;  // 接收音频丢包率
  result["rxAudioPacketLossSum"] =
      stats.rx_audio_packet_loss_sum;                   // 接收音频丢包总数
  result["rxVideoBytes"] = stats.rx_video_bytes;        // 接收视频字节数
  result["rxBytes"] = stats.rx_bytes;                   // 接收总字节数
  result["rxVideoJitter"] = stats.rx_video_jitter;      // 接收视频抖动
  result["rxVideoKBitRate"] = stats.rx_video_kbitrate;  // 接收视频码率
  result["rxVideoPacketLossRate"] =
      stats.rx_video_packet_loss_rate;  // 接收视频丢包率
  result["rxVideoPacketLossSum"] =
      stats.rx_video_packet_loss_sum;               // 接收视频丢包总数
  result["cpuAppUsage"] = stats.cpu_app_usage;      // 应用层CPU使用率
  result["cpuTotalUsage"] = stats.cpu_total_usage;  // 系统CPU使用率
  result["memoryAppUsageInKBytes"] = stats.memory_app_kbytes;  // 应用层内存占用
  result["memoryAppUsageRatio"] = stats.memory_app_usage;  // 应用层内存占用比
  result["memoryTotalUsageRatio"] = stats.memory_total_usage;  // 系统内存占用比
  result["totalDuration"] = stats.total_duration;              // 通话总时长
  result["txAudioBytes"] = stats.tx_audio_bytes;               // 发送音频字节数
  result["txAudioJitter"] = stats.tx_audio_jitter;             // 发送音频抖动
  result["txAudioKBitRate"] = stats.tx_audio_kbitrate;         // 发送音频码率
  result["txAudioPacketLossRate"] =
      stats.tx_audio_packet_loss_rate;  // 发送音频丢包率
  result["txAudioPacketLossSum"] =
      stats.tx_audio_packet_loss_sum;                   // 发送音频丢包总数
  result["txBytes"] = stats.tx_bytes;                   // 发送总字节数
  result["txVideoBytes"] = stats.tx_video_bytes;        // 发送视频字节数
  result["txVideoJitter"] = stats.tx_video_jitter;      // 发送视频抖动
  result["txVideoKBitRate"] = stats.tx_video_kbitrate;  // 发送视频码率
  result["txVideoPacketLossRate"] =
      stats.tx_video_packet_loss_rate;  // 发送视频丢包率
  result["txVideoPacketLossSum"] =
      stats.tx_video_packet_loss_sum;  // 发送视频丢包总数
  result["upRtt"] = stats.up_rtt;      // 上行RTT
  result["downRtt"] = stats.down_rtt;  // 下行RTT

  std::string result_str = result.dump();
  dart_object.value.as_string = const_cast<char*>(result_str.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalAudioStats(const NERtcAudioSendStats& stats) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  int stats_count = stats.audio_layers_count;
  json result;
  result["method"] = kNERtcOnLocalAudioStats;
  result["statsList"] = stats_count;
  for (int i = 0; i < stats_count; i++) {
    json audio_layer;
    audio_layer["streamType"] =
        static_cast<int>(stats.audio_layers_list[i].stream_type);
    audio_layer["kbps"] = stats.audio_layers_list[i].sent_bitrate;
    audio_layer["lossRate"] = stats.audio_layers_list[i].audio_loss_rate;
    audio_layer["rtt"] = stats.audio_layers_list[i].rtt;
    audio_layer["volume"] = stats.audio_layers_list[i].volume;
    audio_layer["numChannels"] = stats.audio_layers_list[i].num_channels;
    audio_layer["sentSampleRate"] = stats.audio_layers_list[i].sent_sample_rate;
    audio_layer["capVolume"] = stats.audio_layers_list[i].cap_volume;
    result["layers"].push_back(audio_layer);
  }

  std::string result_str = result.dump();
  dart_object.value.as_string = const_cast<char*>(result_str.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRemoteAudioStats(const NERtcAudioRecvStats* stats,
                                             unsigned int user_count) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  json result;
  result["method"] = kNERtcOnRemoteAudioStats;
  for (int i = 0; i < user_count; i++) {
    json user_layer;
    user_layer["uid"] = stats[i].uid;
    user_layer["audio_layers_count"] = stats[i].audio_layers_count;
    for (int j = 0; j < stats[i].audio_layers_count; j++) {
      json audio_layer;
      audio_layer["streamType"] = static_cast<int>(
          stats[i]
              .audio_layers_list[j]
              .stream_type);  // 0: "audio", 1: "video", 2: "displa
      audio_layer["kbps"] = stats[i].audio_layers_list[j].received_bitrate;
      audio_layer["lossRate"] = stats[i].audio_layers_list[j].audio_loss_rate;
      audio_layer["volume"] = stats[i].audio_layers_list[j].volume;
      audio_layer["totalFrozenTime"] =
          stats[i].audio_layers_list[j].total_frozen_time;  // 音频总冻结时间
      audio_layer["frozenRate"] =
          stats[i].audio_layers_list[j].frozen_rate;  // 音频冻结率
      user_layer["list"].push_back(audio_layer);
    }
    result["list"].push_back(user_layer);
  }

  std::string result_str = result.dump();
  dart_object.value.as_string = const_cast<char*>(result_str.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalVideoStats(const NERtcVideoSendStats& stats) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  int stats_count = stats.video_layers_count;
  json result;
  result["method"] = kNERtcOnLocalVideoStats;
  result["statsList"] = stats_count;
  for (int i = 0; i < stats_count; i++) {
    json video_layer;
    video_layer["layerType"] =
        stats.video_layers_list[i]
            .layer_type;  // 0: "audio", 1: "video", 2: "displa
    video_layer["width"] = stats.video_layers_list[i].width;
    video_layer["height"] = stats.video_layers_list[i].height;
    video_layer["captureHeight"] = stats.video_layers_list[i].capture_height;
    video_layer["captureWidth"] = stats.video_layers_list[i].capture_width;
    video_layer["sendBitrate"] = stats.video_layers_list[i].sent_bitrate;
    video_layer["encoderOutputFrameRate"] =
        stats.video_layers_list[i].encoder_frame_rate;
    video_layer["captureFrameRate"] =
        stats.video_layers_list[i].capture_frame_rate;
    video_layer["targetBitrate"] = stats.video_layers_list[i].target_bitrate;
    video_layer["encoderBitrate"] = stats.video_layers_list[i].encoder_bitrate;
    video_layer["sentFrameRate"] = stats.video_layers_list[i].sent_frame_rate;
    video_layer["renderFrameRate"] =
        stats.video_layers_list[i].render_frame_rate;
    video_layer["encoderName"] = stats.video_layers_list[i].codec_name;
    video_layer["dropBwStrategyEnabled"] =
        stats.video_layers_list[i].drop_bandwidth_strategy_enabled;
    result["layers"].push_back(video_layer);
  }

  std::string result_str = result.dump();
  dart_object.value.as_string = const_cast<char*>(result_str.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRemoteVideoStats(const NERtcVideoRecvStats* stats,
                                             unsigned int user_count) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  json result;
  result["method"] = kNERtcOnRemoteVideoStats;
  for (int i = 0; i < user_count; i++) {
    json user_layer;
    user_layer["uid"] = stats[i].uid;
    user_layer["video_layers_count"] = stats[i].video_layers_count;
    for (int j = 0; j < stats[i].video_layers_count; j++) {
      json video_layer;
      video_layer["layerType"] =
          stats[i]
              .video_layers_list[j]
              .layer_type;  // 0: "audio", 1: "video", 2: "displa
      video_layer["width"] = stats[i].video_layers_list[j].width;
      video_layer["height"] = stats[i].video_layers_list[j].height;
      video_layer["receivedBitrate"] =
          stats[i].video_layers_list[j].received_bitrate;
      video_layer["fps"] = stats[i].video_layers_list[j].received_frame_rate;
      video_layer["packetLossRate"] =
          stats[i].video_layers_list[j].packet_loss_rate;
      video_layer["decoderOutputFrameRate"] =
          stats[i].video_layers_list[j].decoder_frame_rate;
      video_layer["rendererOutputFrameRate"] =
          stats[i].video_layers_list[j].render_frame_rate;
      video_layer["totalFrozenTime"] =
          stats[i].video_layers_list[j].total_frozen_time;
      video_layer["frozenRate"] = stats[i].video_layers_list[j].frozen_rate;
      video_layer["decoderName"] = stats[i].video_layers_list[j].codec_name;
      user_layer["layers"].push_back(video_layer);
    }
    result["list"].push_back(user_layer);
  }

  std::string result_str = result.dump();

  dart_object.value.as_string = const_cast<char*>(result_str.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onNetworkQuality(const NERtcNetworkQualityInfo* infos,
                                           unsigned int user_count) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  json result;
  result["method"] = kNERtcOnNetworkQuality;
  for (int i = 0; i < user_count; i++) {
    json user_layer;
    user_layer["uid"] = infos[i].uid;
    user_layer["txQuality"] = infos[i].tx_quality;
    user_layer["rxQuality"] = infos[i].rx_quality;
    result["list"].push_back(user_layer);
  }
  std::string result_str = result.dump();
  dart_object.value.as_string = const_cast<char*>(result_str.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}
