// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.audio.NERtcAudioStreamType;
import com.netease.lava.nertc.sdk.stats.NERtcAudioLayerRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcAudioLayerSendStats;
import com.netease.lava.nertc.sdk.stats.NERtcAudioRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcAudioSendStats;
import com.netease.lava.nertc.sdk.stats.NERtcNetworkQualityInfo;
import com.netease.lava.nertc.sdk.stats.NERtcStats;
import com.netease.lava.nertc.sdk.stats.NERtcStatsObserver;
import com.netease.lava.nertc.sdk.stats.NERtcVideoLayerRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcVideoLayerSendStats;
import com.netease.lava.nertc.sdk.stats.NERtcVideoRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcVideoSendStats;
import io.flutter.plugin.common.BinaryMessenger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcStatsObserverImpl implements NERtcStatsObserver {

  private final Messages.NERtcStatsEventSink _eventSink;
  private final String channelTag;

  NERtcStatsObserverImpl(BinaryMessenger argBinaryMessenger, String channelTag) {
    _eventSink = new Messages.NERtcStatsEventSink(argBinaryMessenger);
    this.channelTag = channelTag;
  }

  @Override
  public void onRtcStats(NERtcStats stat) {
    if (stat == null) return;
    HashMap<Object, Object> stats = toMap(stat);
    _eventSink.onRtcStats(
        stats,
        channelTag,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onLocalAudioStats(NERtcAudioSendStats stat) {
    if (stat == null) return;
    Map<Object, Object> statMap = toMap(stat);
    if (statMap != null) {
      _eventSink.onLocalAudioStats(
          statMap,
          channelTag,
          aVoid -> {
            // 实现reply方法
          });
    }
  }

  @Override
  public void onRemoteAudioStats(NERtcAudioRecvStats[] stats) {
    if (stats != null && stats.length > 0) {
      List<Map<Object, Object>> statList = new ArrayList<>(stats.length);
      for (NERtcAudioRecvStats stat : stats) {
        Map<Object, Object> statMap = toMap(stat);
        if (statMap != null) {
          statList.add(statMap);
        }
      }
      HashMap<Object, Object> map = new HashMap<>();
      map.put("list", statList);
      _eventSink.onRemoteAudioStats(
          map,
          channelTag,
          aVoid -> {
            // 实现reply方法
          });
    }
  }

  @Override
  public void onLocalVideoStats(NERtcVideoSendStats stat) {
    if (stat == null) return;
    HashMap<Object, Object> map = toMap(stat);
    _eventSink.onLocalVideoStats(
        map,
        channelTag,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onRemoteVideoStats(NERtcVideoRecvStats[] stats) {
    if (stats != null && stats.length > 0) {
      List<Map<String, Object>> statList = new ArrayList<>(stats.length);
      for (NERtcVideoRecvStats stat : stats) {
        statList.add(toMap(stat));
      }
      HashMap<Object, Object> map = new HashMap<>();
      map.put("list", statList);
      _eventSink.onRemoteVideoStats(
          map,
          channelTag,
          aVoid -> {
            // 实现reply方法
          });
    }
  }

  @Override
  public void onNetworkQuality(NERtcNetworkQualityInfo[] stats) {
    if (stats != null && stats.length > 0) {
      List<Map<String, Object>> statList = new ArrayList<>(stats.length);
      for (NERtcNetworkQualityInfo stat : stats) {
        statList.add(toMap(stat));
      }
      HashMap<Object, Object> map = new HashMap<>();
      map.put("list", statList);
      _eventSink.onNetworkQuality(
          map,
          channelTag,
          aVoid -> {
            // 实现reply方法
          });
    }
  }

  private HashMap<String, Object> toMap(NERtcNetworkQualityInfo info) {
    HashMap<String, Object> map = new HashMap<>();
    map.put("uid", info.userId);
    map.put("txQuality", info.upStatus);
    map.put("rxQuality", info.downStatus);
    return map;
  }

  private HashMap<Object, Object> toMap(NERtcStats stats) {
    HashMap<Object, Object> map = new HashMap<>();
    map.put("txBytes", stats.txBytes);
    map.put("rxBytes", stats.rxBytes);
    map.put("cpuAppUsage", stats.cpuAppUsage);
    map.put("cpuTotalUsage", stats.cpuTotalUsage);
    map.put("memoryAppUsageRatio", stats.memoryAppUsageRatio);
    map.put("memoryTotalUsageRatio", stats.memoryTotalUsageRatio);
    map.put("memoryAppUsageInKBytes", stats.memoryAppUsageInKBytes);
    map.put("totalDuration", stats.totalDuration);
    map.put("txAudioBytes", stats.txAudioBytes);
    map.put("txVideoBytes", stats.txVideoBytes);
    map.put("rxAudioBytes", stats.rxAudioBytes);
    map.put("rxVideoBytes", stats.rxVideoBytes);
    map.put("rxAudioKBitRate", stats.rxAudioKBitRate);
    map.put("rxVideoKBitRate", stats.rxVideoKBitRate);
    map.put("txAudioKBitRate", stats.txAudioKBitRate);
    map.put("txVideoKBitRate", stats.txVideoKBitRate);
    map.put("upRtt", stats.upRtt);
    map.put("downRtt", stats.downRtt);
    map.put("txAudioPacketLossRate", stats.txAudioPacketLossRate);
    map.put("txVideoPacketLossRate", stats.txVideoPacketLossRate);
    map.put("txAudioPacketLossSum", stats.txAudioPacketLossSum);
    map.put("txVideoPacketLossSum", stats.txVideoPacketLossSum);
    map.put("txAudioJitter", stats.txAudioJitter);
    map.put("txVideoJitter", stats.txVideoJitter);
    map.put("rxAudioPacketLossRate", stats.rxAudioPacketLossRate);
    map.put("rxVideoPacketLossRate", stats.rxVideoPacketLossRate);
    map.put("rxAudioPacketLossSum", stats.rxAudioPacketLossSum);
    map.put("rxVideoPacketLossSum", stats.rxVideoPacketLossSum);
    map.put("rxAudioJitter", stats.rxAudioJitter);
    map.put("rxVideoJitter", stats.rxVideoJitter);
    return map;
  }

  private HashMap<Object, Object> toMap(NERtcAudioSendStats stats) {
    HashMap<Object, Object> statsMap = new HashMap<>();
    ArrayList<HashMap<Object, Object>> layers = new ArrayList<>();
    for (NERtcAudioLayerSendStats layer : stats.audioLayers) {
      HashMap<Object, Object> map = new HashMap<>();
      map.put("streamType", layer.streamType.ordinal());
      map.put("kbps", layer.kbps);
      map.put("lossRate", layer.lossRate);
      map.put("rtt", layer.rtt);
      map.put("volume", layer.volume);
      map.put("numChannels", layer.numChannels);
      map.put("sentSampleRate", layer.sentSampleRate);
      map.put("capVolume", layer.capVolume);
      layers.add(map);
    }
    statsMap.put("layers", layers);
    return statsMap;
  }

  private HashMap<Object, Object> toMap(NERtcAudioRecvStats stats) {
    HashMap<Object, Object> map = new HashMap<>();
    map.put("uid", stats.uid);
    ArrayList<HashMap<String, Object>> layers = new ArrayList<>();
    if (stats.layers != null) {
      for (NERtcAudioLayerRecvStats stat : stats.layers) {
        HashMap<String, Object> mapLayer = new HashMap<>();
        int type = (stat.streamType == NERtcAudioStreamType.kNERtcAudioStreamTypeMain) ? 0 : 1;
        mapLayer.put("kbps", stat.kbps);
        mapLayer.put("lossRate", stat.lossRate);
        mapLayer.put("volume", stat.volume);
        mapLayer.put("totalFrozenTime", stat.totalFrozenTime);
        mapLayer.put("frozenRate", stat.frozenRate);
        mapLayer.put("streamType", type);
        layers.add(mapLayer);
      }
    }
    map.put("list", layers);
    return map;
  }

  private HashMap<Object, Object> toMap(NERtcVideoSendStats stats) {
    HashMap<Object, Object> map = new HashMap<>();
    ArrayList<HashMap<String, Object>> layers = new ArrayList<>();
    if (stats.videoLayers != null) {
      for (NERtcVideoLayerSendStats stat : stats.videoLayers) {
        HashMap<String, Object> mapLayer = new HashMap<>();
        mapLayer.put("layerType", stat.layerType);
        mapLayer.put("captureWidth", stat.capWidth);
        mapLayer.put("captureHeight", stat.capHeight);
        mapLayer.put("width", stat.width);
        mapLayer.put("height", stat.height);
        mapLayer.put("sendBitrate", stat.sendBitrate);
        mapLayer.put("encoderOutputFrameRate", stat.encoderOutputFrameRate);
        mapLayer.put("captureFrameRate", stat.captureFrameRate);
        mapLayer.put("targetBitrate", stat.targetBitrate);
        mapLayer.put("encoderBitrate", stat.encoderBitrate);
        mapLayer.put("sentFrameRate", stat.sentFrameRate);
        mapLayer.put("renderFrameRate", stat.renderFrameRate);
        mapLayer.put("encoderName", stat.encoderName);
        mapLayer.put("dropBwStrategyEnabled", stat.dropBwStrategyEnabled);
        layers.add(mapLayer);
      }
    }
    map.put("layers", layers);
    return map;
  }

  private HashMap<String, Object> toMap(NERtcVideoRecvStats stats) {
    HashMap<String, Object> map = new HashMap<>();
    map.put("uid", stats.uid);
    ArrayList<HashMap<String, Object>> layers = new ArrayList<>();
    if (stats.layers != null) {
      for (NERtcVideoLayerRecvStats stat : stats.layers) {
        HashMap<String, Object> mapLayer = new HashMap<>();
        mapLayer.put("layerType", stat.layerType);
        mapLayer.put("width", stat.width);
        mapLayer.put("height", stat.height);
        mapLayer.put("receivedBitrate", stat.receivedBitrate);
        mapLayer.put("fps", stat.fps);
        mapLayer.put("packetLossRate", stat.packetLossRate);
        mapLayer.put("decoderOutputFrameRate", stat.decoderOutputFrameRate);
        mapLayer.put("rendererOutputFrameRate", stat.rendererOutputFrameRate);
        mapLayer.put("totalFrozenTime", stat.totalFrozenTime);
        mapLayer.put("frozenRate", stat.frozenRate);
        mapLayer.put("decoderName", stat.decoderName);
        layers.add(mapLayer);
      }
    }
    map.put("layers", layers);
    return map;
  }
}
