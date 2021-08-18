/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be 
 * found in the LICENSE file.
 */

package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.stats.NERtcAudioRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcAudioSendStats;
import com.netease.lava.nertc.sdk.stats.NERtcNetworkQualityInfo;
import com.netease.lava.nertc.sdk.stats.NERtcStats;
import com.netease.lava.nertc.sdk.stats.NERtcStatsObserver;
import com.netease.lava.nertc.sdk.stats.NERtcVideoLayerRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcVideoLayerSendStats;
import com.netease.lava.nertc.sdk.stats.NERtcVideoRecvStats;
import com.netease.lava.nertc.sdk.stats.NERtcVideoSendStats;
import com.netease.nertcflutter.NERtcEngine.CallbackMethod;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcStatsObserverImpl implements NERtcStatsObserver {

    private final CallbackMethod callback;


    NERtcStatsObserverImpl(CallbackMethod callback) {
        this.callback = callback;
    }

    @Override
    public void onRtcStats(NERtcStats stat) {
        if (stat == null) return;
        callback.invokeMethod("onRtcStats", toMap(stat));
    }

    @Override
    public void onLocalAudioStats(NERtcAudioSendStats stat) {
        if (stat == null) return;
        callback.invokeMethod("onLocalAudioStats", toMap(stat));
    }

    @Override
    public void onRemoteAudioStats(NERtcAudioRecvStats[] stats) {
        if (stats != null && stats.length > 0) {
            List<Map<String, Object>> statList = new ArrayList<>(stats.length);
            for (NERtcAudioRecvStats stat : stats) {
                statList.add(toMap(stat));
            }
            HashMap<String, Object> map = new HashMap<>();
            map.put("list", statList);
            callback.invokeMethod("onRemoteAudioStats", map);
        }
    }

    @Override
    public void onLocalVideoStats(NERtcVideoSendStats stat) {
        if (stat == null) return;
        callback.invokeMethod("onLocalVideoStats", toMap(stat));
    }

    @Override
    public void onRemoteVideoStats(NERtcVideoRecvStats[] stats) {
        if (stats != null && stats.length > 0) {
            List<Map<String, Object>> statList = new ArrayList<>(stats.length);
            for (NERtcVideoRecvStats stat : stats) {
                statList.add(toMap(stat));
            }
            HashMap<String, Object> map = new HashMap<>();
            map.put("list", statList);
            callback.invokeMethod("onRemoteVideoStats", map);
        }
    }

    @Override
    public void onNetworkQuality(NERtcNetworkQualityInfo[] stats) {
        if (stats != null && stats.length > 0) {
            List<Map<String, Object>> statList = new ArrayList<>(stats.length);
            for (NERtcNetworkQualityInfo stat : stats) {
                statList.add(toMap(stat));
            }
            HashMap<String, Object> map = new HashMap<>();
            map.put("list", statList);
            callback.invokeMethod("onNetworkQuality", map);
        }
    }

    private HashMap<String, Object> toMap(NERtcNetworkQualityInfo info) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", info.userId);
        map.put("txQuality", info.upStatus);
        map.put("rxQuality", info.downStatus);
        return map;
    }

    private HashMap<String, Object> toMap(NERtcStats stats) {
        HashMap<String, Object> map = new HashMap<>();
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

    private HashMap<String, Object> toMap(NERtcAudioSendStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("kbps", stats.kbps);
        map.put("lossRate", stats.lossRate);
        map.put("rtt", stats.rtt);
        map.put("volume", stats.volume);
        map.put("numChannels", stats.numChannels);
        map.put("sentSampleRate", stats.sentSampleRate);
        return map;
    }


    private HashMap<String, Object> toMap(NERtcAudioRecvStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", stats.uid);
        map.put("kbps", stats.kbps);
        map.put("lossRate", stats.lossRate);
        map.put("volume", stats.volume);
        map.put("totalFrozenTime", stats.totalFrozenTime);
        map.put("frozenRate", stats.frozenRate);
        return map;
    }

    private HashMap<String, Object> toMap(NERtcVideoSendStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        ArrayList<HashMap<String, Object>> layers = new ArrayList<>();
        if(stats.videoLayers != null) {
            for(NERtcVideoLayerSendStats stat : stats.videoLayers) {
                HashMap<String, Object> mapLayer = new HashMap<>();
                mapLayer.put("layerType", stat.layerType);
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
        if(stats.layers != null) {
            for(NERtcVideoLayerRecvStats stat : stats.layers) {
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
