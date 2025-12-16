// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import android.graphics.Rect;
import android.os.Handler;
import android.os.Looper;
import com.netease.lava.nertc.sdk.LastmileProbeResult;
import com.netease.lava.nertc.sdk.NERtcAsrCaptionResult;
import com.netease.lava.nertc.sdk.NERtcCallbackEx;
import com.netease.lava.nertc.sdk.NERtcUserJoinExtraInfo;
import com.netease.lava.nertc.sdk.NERtcUserLeaveExtraInfo;
import com.netease.lava.nertc.sdk.audio.NERtcAudioProcessObserver;
import com.netease.lava.nertc.sdk.audio.NERtcAudioStreamType;
import com.netease.lava.nertc.sdk.stats.NERtcAudioVolumeInfo;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamType;
import io.flutter.plugin.common.BinaryMessenger;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcCallbackImpl implements NERtcCallbackEx, NERtcAudioProcessObserver {

  //  private final CallbackMethod callback;
  //  private EventChannel.EventSink _eventSink;
  private Messages.NERtcChannelEventSink _eventSink;
  private Messages.NERtcDeviceEventSink _deviceEventSink;
  private Messages.NERtcAudioMixingEventSink _audioMixingEventSink;
  private Messages.NERtcAudioEffectEventSink _audioEffectEventSink;
  Handler handler = new Handler(Looper.getMainLooper());

  NERtcCallbackImpl(BinaryMessenger argBinaryMessenger) {
    _eventSink = new Messages.NERtcChannelEventSink(argBinaryMessenger);
    _deviceEventSink = new Messages.NERtcDeviceEventSink(argBinaryMessenger);
    _audioEffectEventSink = new Messages.NERtcAudioEffectEventSink(argBinaryMessenger);
    _audioMixingEventSink = new Messages.NERtcAudioMixingEventSink(argBinaryMessenger);
  }

  public void dispose() {
    _eventSink = null;
    _deviceEventSink = null;
    _audioMixingEventSink = null;
    _audioEffectEventSink = null;
  }

  @Override
  public void onJoinChannel(int result, long channelId, long elapsed, long uid) {
    Long res = (long) result;
    _eventSink.onJoinChannel(
        res,
        channelId,
        elapsed,
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onLeaveChannel(int result) {
    _eventSink.onLeaveChannel(
        (long) result,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserJoined(long uid) {
    //Deprecated
  }

  @Override
  public void onUserJoined(long uid, NERtcUserJoinExtraInfo neRtcUserJoinExtraInfo) {
    Messages.UserJoinedEvent.Builder builder = new Messages.UserJoinedEvent.Builder();
    builder.setUid(uid);
    if (neRtcUserJoinExtraInfo != null) {
      Messages.NERtcUserJoinExtraInfo.Builder info = new Messages.NERtcUserJoinExtraInfo.Builder();
      info.setCustomInfo(neRtcUserJoinExtraInfo.customInfo);
      Messages.NERtcUserJoinExtraInfo joinExtraInfo = info.build();
      builder.setJoinExtraInfo(joinExtraInfo);
    }
    Messages.UserJoinedEvent event = builder.build();
    _eventSink.onUserJoined(
        event,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserLeave(long uid, int reason) {
    //Deprecated
  }

  @Override
  public void onUserLeave(long uid, int reason, NERtcUserLeaveExtraInfo neRtcUserLeaveExtraInfo) {
    Messages.UserLeaveEvent.Builder builder = new Messages.UserLeaveEvent.Builder();
    builder.setUid(uid);
    builder.setReason((long) reason);
    if (neRtcUserLeaveExtraInfo != null) {
      Messages.NERtcUserLeaveExtraInfo.Builder info =
          new Messages.NERtcUserLeaveExtraInfo.Builder();
      info.setCustomInfo(neRtcUserLeaveExtraInfo.customInfo);
      Messages.NERtcUserLeaveExtraInfo leaveExtraInfo = info.build();
      builder.setLeaveExtraInfo(leaveExtraInfo);
    }
    Messages.UserLeaveEvent event = builder.build();
    _eventSink.onUserLeave(
        event,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserAudioStart(long uid) {
    _eventSink.onUserAudioStart(
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserAudioStop(long uid) {
    _eventSink.onUserAudioStop(
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserVideoStart(long uid, int maxProfile) {
    _eventSink.onUserVideoStart(
        uid,
        (long) maxProfile,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserVideoStop(long uid) {
    _eventSink.onUserVideoStop(
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onDisconnect(int reason) {
    _eventSink.onDisconnect(
        (long) reason,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onClientRoleChange(int oldRole, int newRole) {
    _eventSink.onClientRoleChange(
        (long) oldRole,
        (long) newRole,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserSubStreamVideoStart(long uid, int maxProfile) {
    _eventSink.onUserSubStreamVideoStart(uid, (long) maxProfile, aVoid -> {});
  }

  @Override
  public void onUserSubStreamVideoStop(long uid) {
    _eventSink.onUserSubStreamVideoStop(uid, aVoid -> {});
  }

  @Override
  public void onUserAudioMute(long uid, boolean muted) {
    _eventSink.onUserAudioMute(uid, muted, aVoid -> {});
  }

  @Override
  public void onUserVideoMute(long uid, boolean muted) {
    //    Messages.UserVideoMuteEvent.Builder builder = new Messages.UserVideoMuteEvent.Builder();
    //    builder.setMuted(muted);
    //    builder.setUid(uid);
    //    long type = NERtcVideoStreamType.kNERtcVideoStreamTypeMain.ordinal();
    //    builder.setStreamType(type);
    //    Messages.UserVideoMuteEvent event = builder.build();
    //    _eventSink.onUserVideoMute(event, aVoid -> {});
  }

  @Override
  public void onUserVideoMute(NERtcVideoStreamType neRtcVideoStreamType, long uid, boolean muted) {
    Messages.UserVideoMuteEvent.Builder builder = new Messages.UserVideoMuteEvent.Builder();
    builder.setMuted(muted);
    builder.setUid(uid);
    if (neRtcVideoStreamType != null) {
      long type = neRtcVideoStreamType.ordinal();
      builder.setStreamType(type);
    }
    Messages.UserVideoMuteEvent event = builder.build();
    _eventSink.onUserVideoMute(event, aVoid -> {});
  }

  @Override
  public void onUserVideoStart(long uid, NERtcVideoStreamType streamType, int maxProfile) {}

  @Override
  public void onUserVideoStop(long uid, NERtcVideoStreamType streamType) {}

  @Override
  public void onFirstAudioDataReceived(long uid) {
    _eventSink.onFirstAudioDataReceived(uid, aVoid -> {});
  }

  @Override
  public void onFirstVideoDataReceived(long uid) {
    //    Messages.FirstVideoDataReceivedEvent.Builder builder =
    //        new Messages.FirstVideoDataReceivedEvent.Builder();
    //    long type = NERtcVideoStreamType.kNERtcVideoStreamTypeMain.ordinal();
    //    builder.setStreamType(type);
    //    builder.setUid(uid);
    //    Messages.FirstVideoDataReceivedEvent event = builder.build();
    //    _eventSink.onFirstVideoDataReceived(event, aVoid -> {});
  }

  @Override
  public void onFirstVideoDataReceived(NERtcVideoStreamType neRtcVideoStreamType, long uid) {
    Messages.FirstVideoDataReceivedEvent.Builder builder =
        new Messages.FirstVideoDataReceivedEvent.Builder();
    if (neRtcVideoStreamType != null) {
      long type = neRtcVideoStreamType.ordinal();
      builder.setStreamType(type);
    }
    builder.setUid(uid);
    Messages.FirstVideoDataReceivedEvent event = builder.build();
    _eventSink.onFirstVideoDataReceived(event, aVoid -> {});
  }

  @Override
  public void onFirstAudioFrameDecoded(long uid) {
    _eventSink.onFirstAudioFrameDecoded(uid, aVoid -> {});
  }

  @Override
  public void onFirstVideoFrameDecoded(long uid, int width, int height) {
    //    Messages.FirstVideoFrameDecodedEvent.Builder builder =
    //        new Messages.FirstVideoFrameDecodedEvent.Builder();
    //    builder.setHeight((long) height);
    //    builder.setWidth((long) width);
    //    builder.setUid(uid);
    //    Messages.FirstVideoFrameDecodedEvent event = builder.build();
    //    _eventSink.onFirstVideoFrameDecoded(event, aVoid -> {});
  }

  @Override
  public void onFirstVideoFrameDecoded(
      NERtcVideoStreamType neRtcVideoStreamType, long uid, int width, int height) {
    Messages.FirstVideoFrameDecodedEvent.Builder builder =
        new Messages.FirstVideoFrameDecodedEvent.Builder();
    builder.setHeight((long) height);
    builder.setWidth((long) width);
    builder.setUid(uid);
    long type = neRtcVideoStreamType.ordinal();
    builder.setStreamType(type);
    Messages.FirstVideoFrameDecodedEvent event = builder.build();
    _eventSink.onFirstVideoFrameDecoded(event, aVoid -> {});
  }

  @Override
  public void onAudioDeviceStateChange(int deviceType, int deviceState) {
    _deviceEventSink.onAudioDeviceStateChange((long) deviceType, (long) deviceState, aVoid -> {});
  }

  @Override
  public void onVideoDeviceStageChange(int deviceState) {
    long deviceType = 1;
    _deviceEventSink.onVideoDeviceStateChange(deviceType, (long) deviceState, aVoid -> {});
  }

  @Override
  public void onConnectionTypeChanged(int newConnectionType) {
    _eventSink.onConnectionTypeChanged((long) newConnectionType, aVoid -> {});
  }

  @Override
  public void onReconnectingStart() {
    _eventSink.onReconnectingStart(aVoid -> {});
  }

  @Override
  public void onReJoinChannel(int result, long channelId) {
    _eventSink.onReJoinChannel((long) result, channelId, aVoid -> {});
  }

  @Override
  public void onAudioMixingStateChanged(int state) {
    _audioMixingEventSink.onAudioMixingStateChanged((long) state, aVoid -> {});
  }

  @Override
  public void onAudioMixingTimestampUpdate(long timestampMs) {
    _audioMixingEventSink.onAudioMixingTimestampUpdate(timestampMs, aVoid -> {});
  }

  @Override
  public void onAudioEffectFinished(int effectId) {
    _audioEffectEventSink.onAudioEffectFinished((long) effectId, aVoid -> {});
  }

  @Override
  public void onLocalAudioVolumeIndication(int volume) {
    boolean flag = false;
    _eventSink.onLocalAudioVolumeIndication((long) volume, flag, aVoid -> {});
  }

  @Override
  public void onLocalAudioVolumeIndication(int volume, boolean vadFlag) {
    _eventSink.onLocalAudioVolumeIndication((long) volume, vadFlag, aVoid -> {});
  }

  @Override
  public void onRemoteAudioVolumeIndication(NERtcAudioVolumeInfo[] volumeList, int totalVolume) {
    if (volumeList != null && volumeList.length > 0) {
      List<Messages.AudioVolumeInfo> statList =
          new ArrayList<Messages.AudioVolumeInfo>(volumeList.length) {};
      for (NERtcAudioVolumeInfo stat : volumeList) {
        Messages.AudioVolumeInfo.Builder info = new Messages.AudioVolumeInfo.Builder();
        info.setUid(stat.uid);
        info.setVolume((long) stat.volume);
        info.setSubStreamVolume((long) stat.subStreamVolume);
        Messages.AudioVolumeInfo audioVolumeInfo = info.build();
        statList.add(audioVolumeInfo);
      }

      Messages.RemoteAudioVolumeIndicationEvent.Builder builder =
          new Messages.RemoteAudioVolumeIndicationEvent.Builder();
      builder.setTotalVolume((long) totalVolume);
      builder.setVolumeList(statList);
      Messages.RemoteAudioVolumeIndicationEvent event = builder.build();
      _eventSink.onRemoteAudioVolumeIndication(event, aVoid -> {});
    }
  }

  @Override
  public void onLiveStreamState(String taskId, String pushUrl, int liveState) {
    _eventSink.onLiveStreamState(taskId, pushUrl, (long) liveState, aVoid -> {});
  }

  @Override
  public void onConnectionStateChanged(int state, int reason) {
    _eventSink.onConnectionStateChanged((long) state, (long) reason, aVoid -> {});
  }

  @Override
  public void onCameraFocusChanged(Rect rect) {
    if (rect == null) return;
    handler.post(
        new Runnable() {
          public void run() {
            Messages.CGPoint.Builder builder = new Messages.CGPoint.Builder();
            builder.setX((double) rect.left);
            builder.setY((double) rect.top);
            Messages.CGPoint point = builder.build();
            _deviceEventSink.onCameraFocusChanged(point, aVoid -> {});
          }
        });
  }

  @Override
  public void onCameraExposureChanged(Rect rect) {
    if (rect == null) return;
    handler.post(
        new Runnable() {
          public void run() {
            Messages.CGPoint.Builder builder = new Messages.CGPoint.Builder();
            builder.setX((double) rect.left);
            builder.setY((double) rect.top);
            Messages.CGPoint point = builder.build();
            _deviceEventSink.onCameraExposureChanged(point, aVoid -> {});
          }
        });
  }

  @Override
  public void onRecvSEIMsg(long userID, String seiMsg) {
    _eventSink.onRecvSEIMsg(userID, seiMsg, aVoid -> {});
  }

  @Override
  public void onAudioRecording(int code, String filePath) {
    _eventSink.onAudioRecording((long) code, filePath, aVoid -> {});
  }

  @Override
  public void onError(int code) {
    _eventSink.onError((long) code, aVoid -> {});
  }

  @Override
  public void onWarning(int code) {
    _eventSink.onWarning((long) code, aVoid -> {});
  }

  @Override
  public void onMediaRelayStatesChange(int state, String channelName) {
    _eventSink.onMediaRelayStatesChange((long) state, channelName, aVoid -> {});
  }

  @Override
  public void onMediaRelayReceiveEvent(int event, int code, String channelName) {
    _eventSink.onMediaRelayReceiveEvent((long) event, (long) code, channelName, aVoid -> {});
  }

  @Override
  public void onAsrCaptionStateChanged(int asrState, int code, String message) {
    _eventSink.onAsrCaptionStateChanged((long) asrState, (long) code, message, aVoid -> {});
  }

  @Override
  public void onAsrCaptionResult(NERtcAsrCaptionResult[] result, int resultCount) {
    if (result != null && resultCount > 0) {
      List<Map<Object, Object>> resultList = new ArrayList<Map<Object, Object>>(resultCount);
      for (int i = 0; i < resultCount && i < result.length; i++) {
        NERtcAsrCaptionResult captionResult = result[i];
        Map<Object, Object> resultMap = new HashMap<>();
        resultMap.put("uid", captionResult.uid);
        resultMap.put("isLocalUser", captionResult.isLocalUser);
        resultMap.put("timestamp", captionResult.timestamp);
        resultMap.put("content", captionResult.content != null ? captionResult.content : "");
        resultMap.put("language", captionResult.language != null ? captionResult.language : "");
        resultMap.put("haveTranslation", captionResult.haveTranslation);
        resultMap.put(
            "translatedText",
            captionResult.translatedText != null ? captionResult.translatedText : "");
        resultMap.put(
            "translationLanguage",
            captionResult.translationLanguage != null ? captionResult.translationLanguage : "");
        resultMap.put("isFinal", captionResult.isFinal);
        resultList.add(resultMap);
      }
      _eventSink.onAsrCaptionResult(resultList, (long) resultCount, aVoid -> {});
    }
  }

  @Override
  public void onPlayStreamingStateChange(String streamId, int state, int reason) {
    _eventSink.onPlayStreamingStateChange(streamId, (long) state, (long) reason, aVoid -> {});
  }

  @Override
  public void onPlayStreamingReceiveSeiMessage(String streamId, String message) {
    _eventSink.onPlayStreamingReceiveSeiMessage(streamId, message, aVoid -> {});
  }

  @Override
  public void onPlayStreamingFirstAudioFramePlayed(String streamId, long timeMs) {
    _eventSink.onPlayStreamingFirstAudioFramePlayed(streamId, timeMs, aVoid -> {});
  }

  @Override
  public void onPlayStreamingFirstVideoFrameRender(
      String streamId, long timeMs, int width, int height) {
    _eventSink.onPlayStreamingFirstVideoFrameRender(
        streamId, timeMs, (long) width, (long) height, aVoid -> {});
  }

  @Override
  public void onLocalAudioFirstPacketSent(NERtcAudioStreamType audioStreamType) {
    if (audioStreamType != null) {
      long type = audioStreamType.ordinal();
      _eventSink.onLocalAudioFirstPacketSent(type, aVoid -> {});
    }
  }

  @Override
  public void onFirstVideoFrameRender(
      long userID, NERtcVideoStreamType streamType, int width, int height, long elapsedTime) {
    if (streamType != null) {
      long type = streamType.ordinal();
      _eventSink.onFirstVideoFrameRender(
          userID, type, (long) width, (long) height, elapsedTime, aVoid -> {});
    }
  }

  @Override
  public void onLocalVideoRenderSizeChanged(NERtcVideoStreamType videoType, int width, int height) {
    if (videoType != null) {
      long type = videoType.ordinal();
      _eventSink.onLocalVideoRenderSizeChanged(type, (long) width, (long) height, aVoid -> {});
    }
  }

  @Override
  public void onUserVideoProfileUpdate(long uid, int maxProfile) {
    _eventSink.onUserVideoProfileUpdate(uid, (long) maxProfile, aVoid -> {});
  }

  @Override
  public void onApiCallExecuted(String apiName, int result, String message) {
    _eventSink.onApiCallExecuted(apiName, (long) result, message, aVoid -> {});
  }

  @Override
  public void onRemoteVideoSizeChanged(
      long userId, NERtcVideoStreamType videoType, int width, int height) {
    if (videoType != null) {
      long type = videoType.ordinal();
      _eventSink.onRemoteVideoSizeChanged(userId, type, (long) width, (long) height, aVoid -> {});
    }
  }

  @Override
  public void onUserDataStart(long uid) {
    _eventSink.onUserDataStart(uid, aVoid -> {});
  }

  @Override
  public void onUserDataStop(long uid) {
    _eventSink.onUserDataStop(uid, aVoid -> {});
  }

  @Override
  public void onUserDataReceiveMessage(long uid, ByteBuffer bufferData, long bufferSize) {
    if (bufferData != null && bufferSize > 0 && bufferData.remaining() >= bufferSize) {
      int savedPosition = bufferData.position();
      byte[] data = new byte[(int) bufferSize];
      bufferData.get(data);
      bufferData.position(savedPosition);
      _eventSink.onUserDataReceiveMessage(uid, data, bufferSize, aVoid -> {});
    }
  }

  @Override
  public void onUserDataStateChanged(long uid) {
    _eventSink.onUserDataStateChanged(uid, aVoid -> {});
  }

  @Override
  public void onUserDataBufferedAmountChanged(long uid, long previousAmount) {
    _eventSink.onUserDataBufferedAmountChanged(uid, previousAmount, aVoid -> {});
  }

  @Override
  public void onLabFeatureCallback(String key, Object param) {
    if (param instanceof Map) {
      @SuppressWarnings("unchecked")
      Map<Object, Object> paramMap = (Map<Object, Object>) param;
      _eventSink.onLabFeatureCallback(key, paramMap, aVoid -> {});
    } else {
      Map<Object, Object> paramMap = new HashMap<>();
      if (param != null) {
        paramMap.put("value", param);
      }
      _eventSink.onLabFeatureCallback(key, paramMap, aVoid -> {});
    }
  }

  @Override
  public void onAiData(String type, String data) {
    _eventSink.onAiData(type, data, aVoid -> {});
  }

  @Override
  public void onStartPushStreaming(int result, long channelId) {
    _eventSink.onStartPushStreaming((long) result, channelId, aVoid -> {});
  }

  @Override
  public void onStopPushStreaming(int result) {
    _eventSink.onStopPushStreaming((long) result, aVoid -> {});
  }

  @Override
  public void onPushStreamingReconnecting(int reason) {
    _eventSink.onPushStreamingReconnecting((long) reason, aVoid -> {});
  }

  @Override
  public void onPushStreamingReconnectedSuccess() {
    _eventSink.onPushStreamingReconnectedSuccess(aVoid -> {});
  }

  @Override
  public void onAudioDeviceChanged(int selected) {
    _deviceEventSink.onAudioDeviceChanged((long) selected, aVoid -> {});
  }

  @Override
  public void onLocalPublishFallbackToAudioOnly(
      boolean isFallback, NERtcVideoStreamType neRtcVideoStreamType) {
    long type = neRtcVideoStreamType.ordinal();
    _eventSink.onLocalPublishFallbackToAudioOnly(isFallback, type, aVoid -> {});
  }

  @Override
  public void onRemoteSubscribeFallbackToAudioOnly(
      long uid, boolean isFallback, NERtcVideoStreamType neRtcVideoStreamType) {
    long type = neRtcVideoStreamType.ordinal();
    _eventSink.onRemoteSubscribeFallbackToAudioOnly(uid, isFallback, type, aVoid -> {});
  }

  @Override
  public void onLastmileQuality(int quality) {
    _eventSink.onLastmileQuality((long) quality, aVoid -> {});
  }

  @Override
  public void onLastmileProbeResult(LastmileProbeResult lastmileProbeResult) {
    if (lastmileProbeResult == null) return;
    Messages.NERtcLastmileProbeResult.Builder builder =
        new Messages.NERtcLastmileProbeResult.Builder();
    builder.setRtt((long) lastmileProbeResult.rtt);
    builder.setState((long) (lastmileProbeResult.state - 1));
    Messages.NERtcLastmileProbeOneWayResult.Builder upResult =
        new Messages.NERtcLastmileProbeOneWayResult.Builder();
    upResult.setJitter((long) lastmileProbeResult.uplinkReport.jitter);
    upResult.setAvailableBandwidth((long) lastmileProbeResult.uplinkReport.availableBandwidth);
    upResult.setPacketLossRate((long) lastmileProbeResult.uplinkReport.packetLossRate);
    Messages.NERtcLastmileProbeOneWayResult upLink = upResult.build();
    builder.setUplinkReport(upLink);
    Messages.NERtcLastmileProbeOneWayResult.Builder downResult =
        new Messages.NERtcLastmileProbeOneWayResult.Builder();
    downResult.setJitter((long) lastmileProbeResult.downlinkReport.jitter);
    downResult.setAvailableBandwidth((long) lastmileProbeResult.downlinkReport.availableBandwidth);
    downResult.setPacketLossRate((long) lastmileProbeResult.downlinkReport.packetLossRate);
    Messages.NERtcLastmileProbeOneWayResult downLink = downResult.build();
    builder.setDownlinkReport(downLink);
    Messages.NERtcLastmileProbeResult result = builder.build();
    _eventSink.onLastmileProbeResult(result, aVoid -> {});
  }

  @Override
  public void onMediaRightChange(boolean isAudioBannedByServer, boolean isVideoBannedByServer) {
    _eventSink.onMediaRightChange(isAudioBannedByServer, isVideoBannedByServer, aVoid -> {});
  }

  @Override
  public void onVirtualBackgroundSourceEnabled(boolean enabled, int reason) {
    Messages.VirtualBackgroundSourceEnabledEvent.Builder builder =
        new Messages.VirtualBackgroundSourceEnabledEvent.Builder();
    builder.setEnabled(enabled);
    builder.setReason((long) reason);
    Messages.VirtualBackgroundSourceEnabledEvent event = builder.build();
    _eventSink.onVirtualBackgroundSourceEnabled(event, aVoid -> {});
  }

  @Override
  public void onAudioEffectTimestampUpdate(long id, long timestampMs) {
    _audioEffectEventSink.onAudioEffectTimestampUpdate(id, timestampMs, aVoid -> {});
  }

  @Override
  public void onUserSubStreamAudioStart(long uid) {
    _eventSink.onUserSubStreamAudioStart(uid, aVoid -> {});
  }

  @Override
  public void onUserSubStreamAudioStop(long uid) {
    _eventSink.onUserSubStreamAudioStop(uid, aVoid -> {});
  }

  @Override
  public void onUserSubStreamAudioMute(long uid, boolean muted) {
    _eventSink.onUserSubStreamAudioMute(uid, muted, aVoid -> {});
  }

  @Override
  public void onPermissionKeyWillExpire() {
    _eventSink.onPermissionKeyWillExpire(aVoid -> {});
  }

  @Override
  public void onUpdatePermissionKey(String key, int error, int timeout) {
    _eventSink.onUpdatePermissionKey(key, (long) error, (long) timeout, aVoid -> {});
  }

  @Override
  public void onLocalVideoWatermarkState(NERtcVideoStreamType neRtcVideoStreamType, int state) {
    if (neRtcVideoStreamType != null) {
      long type = neRtcVideoStreamType.ordinal();
      _eventSink.onLocalVideoWatermarkState(type, (long) state, aVoid -> {});
    }
  }

  public void onTakeSnapshotResult(int code, String path) {
    _eventSink.onTakeSnapshotResult((long) code, path, aVoid -> {});
  }

  @Override
  public void onAudioHasHowling(boolean b) {
    if (b) {
      _eventSink.onAudioHasHowling(aVoid -> {});
    }
  }
}
