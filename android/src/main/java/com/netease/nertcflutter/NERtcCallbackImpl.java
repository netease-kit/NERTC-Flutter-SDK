/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.NERtcCallbackEx;
import com.netease.lava.nertc.sdk.stats.NERtcAudioVolumeInfo;
import com.netease.nertcflutter.NERtcEngine.CallbackMethod;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcCallbackImpl implements NERtcCallbackEx {

    private final CallbackMethod callback;

    private boolean audioMixingCallbackEnabled = false;
    private boolean deviceCallbackEnabled = false;
    private boolean audioEffectCallbackEnabled = false;


    NERtcCallbackImpl(CallbackMethod callback) {
        this.callback = callback;
    }

    void setAudioMixingCallbackEnabled(boolean audioMixingCallbackEnabled) {
        this.audioMixingCallbackEnabled = audioMixingCallbackEnabled;
    }

    void setDeviceCallbackEnabled(boolean deviceCallbackEnabled) {
        this.deviceCallbackEnabled = deviceCallbackEnabled;
    }

    void setAudioEffectCallbackEnabled(boolean audioEffectCallbackEnabled) {
        this.audioEffectCallbackEnabled = audioEffectCallbackEnabled;
    }

    @Override
    public void onJoinChannel(int result, long channelId, long elapsed) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("result", result);
        map.put("channelId", channelId);
        map.put("elapsed", elapsed);
        callback.invokeMethod("onJoinChannel", map);
    }

    @Override
    public void onLeaveChannel(int result) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("result", result);
        callback.invokeMethod("onLeaveChannel", map);
    }


    @Override
    public void onUserJoined(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onUserJoined", map);
    }

    @Override
    public void onUserLeave(long uid,
                            int reason) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("reason", reason);
        callback.invokeMethod("onUserLeave", map);
    }

    @Override
    public void onUserAudioStart(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onUserAudioStart", map);
    }

    @Override
    public void onUserAudioStop(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onUserAudioStop", map);
    }

    @Override
    public void onUserVideoStart(long uid,
                                 int maxProfile) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("maxProfile", maxProfile);
        callback.invokeMethod("onUserVideoStart", map);
    }

    @Override
    public void onUserVideoStop(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onUserVideoStop", map);
    }

    @Override
    public void onDisconnect(int reason) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("reason", reason);
        callback.invokeMethod("onDisconnect", map);
    }

    @Override
    public void onUserAudioMute(long uid, boolean muted) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("muted", muted);
        callback.invokeMethod("onUserAudioMute", map);
    }

    @Override
    public void onUserVideoMute(long uid, boolean muted) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("muted", muted);
        callback.invokeMethod("onUserVideoMute", map);
    }


    @Override
    public void onFirstAudioDataReceived(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onFirstAudioDataReceived", map);
    }

    @Override
    public void onFirstVideoDataReceived(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onFirstVideoDataReceived", map);
    }

    @Override
    public void onFirstAudioFrameDecoded(long uid) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        callback.invokeMethod("onFirstAudioFrameDecoded", map);
    }

    @Override
    public void onFirstVideoFrameDecoded(long uid, int width, int height) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("width", width);
        map.put("height", height);
        callback.invokeMethod("onFirstVideoFrameDecoded", map);
    }

    @Override
    public void onUserVideoProfileUpdate(long uid,
                                         int maxProfile) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("maxProfile", maxProfile);
        callback.invokeMethod("onUserVideoProfileUpdate", map);
    }

    @Override
    public void onAudioDeviceChanged(int selected) {
        if (!deviceCallbackEnabled) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("selected", selected);
        callback.invokeMethod("onAudioDeviceChanged", map);
    }

    @Override
    public void onAudioDeviceStateChange(int deviceType,
                                         int deviceState) {
        if (!deviceCallbackEnabled) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("deviceType", deviceType);
        map.put("deviceState", deviceState);
        callback.invokeMethod("onAudioDeviceStateChange", map);
    }

    @Override
    public void onVideoDeviceStageChange(int deviceState) {
        if (!deviceCallbackEnabled) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("deviceState", deviceState);
        callback.invokeMethod("onVideoDeviceStageChange", map);
    }

    @Override
    public void onConnectionTypeChanged(int newConnectionType) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("newConnectionType", newConnectionType);
        callback.invokeMethod("onConnectionTypeChanged", map);
    }

    @Override
    public void onReJoinChannel(int result,
                                long channelId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("result", result);
        //map.put("channelId", channelId);
        callback.invokeMethod("onReJoinChannel", map);
    }

    @Override
    public void onAudioMixingStateChanged(int state) {
        if (!audioMixingCallbackEnabled) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("state", state);
        callback.invokeMethod("onAudioMixingStateChanged", map);
    }

    @Override
    public void onAudioMixingTimestampUpdate(long timestampMs) {
        if (!audioMixingCallbackEnabled) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("timestampMs", timestampMs);
        callback.invokeMethod("onAudioMixingTimestampUpdate", map);
    }

    @Override
    public void onAudioEffectFinished(int effectId) {
        if (!audioEffectCallbackEnabled) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("effectId", effectId);
        callback.invokeMethod("onAudioEffectFinished", map);
    }

    @Override
    public void onLocalAudioVolumeIndication(int volume) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("volume", volume);
        callback.invokeMethod("onLocalAudioVolumeIndication", map);
    }

    @Override
    public void onRemoteAudioVolumeIndication(NERtcAudioVolumeInfo[] volumeList, int totalVolume) {
        if (volumeList != null && volumeList.length > 0) {
            List<Map<String, Object>> statList = new ArrayList<>(volumeList.length);
            for (NERtcAudioVolumeInfo stat : volumeList) {
                statList.add(toMap(stat));
            }
            HashMap<String, Object> map = new HashMap<>();
            map.put("volumeList", statList);
            map.put("totalVolume", totalVolume);
            callback.invokeMethod("onRemoteAudioVolumeIndication", map);
        }
    }

    @Override
    public void onLiveStreamState(String s, String s1, int i) {

    }

    @Override
    public void onError(int code) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("code", code);
        callback.invokeMethod("onError", map);
    }

    @Override
    public void onWarning(int code) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("code", code);
        callback.invokeMethod("onWarning", map);
    }

    private HashMap<String, Object> toMap(NERtcAudioVolumeInfo info) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("uid", info.uid);
        map.put("volume", info.volume);
        return map;
    }
}
