// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.NERtcUserJoinExtraInfo;
import com.netease.lava.nertc.sdk.NERtcUserLeaveExtraInfo;
import com.netease.lava.nertc.sdk.audio.NERtcAudioStreamType;
import com.netease.lava.nertc.sdk.channel.NERtcChannelCallback;
import com.netease.lava.nertc.sdk.stats.NERtcAudioVolumeInfo;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamType;
import io.flutter.plugin.common.BinaryMessenger;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcSubCallbackImpl implements NERtcChannelCallback {

  private String channelName;
  private Messages.NERtcSubChannelEventSink _eventSink;

  public NERtcSubCallbackImpl(String channelName, BinaryMessenger argBinaryMessenge) {
    this.channelName = channelName;
    _eventSink = new Messages.NERtcSubChannelEventSink(argBinaryMessenge);
  }

  public void dispose() {
    _eventSink = null;
  }

  @Override
  public void onJoinChannel(int result, long channelId, long elapsed, long uid) {
    Long res = (long) result;
    _eventSink.onJoinChannel(
        channelName,
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
        channelName,
        (long) result,
        aVoid -> {
          // 实现reply方法
        });
  }

  // Deprecated
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
        channelName,
        event,
        aVoid -> {
          // 实现reply方法
        });
  }

  // Deprecated
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
        channelName,
        event,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserAudioStart(long uid) {
    _eventSink.onUserAudioStart(
        channelName,
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserAudioStop(long uid) {
    _eventSink.onUserAudioStop(
        channelName,
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserVideoStart(long uid, int maxProfile) {
    _eventSink.onUserVideoStart(
        channelName,
        uid,
        (long) maxProfile,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserVideoStart(long uid, NERtcVideoStreamType streamType, int maxProfile) {
    // 接口不支持 streamType 参数，调用不带 streamType 的版本
    _eventSink.onUserVideoStart(
        channelName,
        uid,
        (long) maxProfile,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserVideoStop(long uid) {
    _eventSink.onUserVideoStop(
        channelName,
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserVideoStop(long uid, NERtcVideoStreamType streamType) {
    // 接口不支持 streamType 参数，调用不带 streamType 的版本
    _eventSink.onUserVideoStop(
        channelName,
        uid,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onDisconnect(int reason) {
    _eventSink.onDisconnect(
        channelName,
        (long) reason,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onClientRoleChange(int oldRole, int newRole) {
    _eventSink.onClientRoleChange(
        channelName,
        (long) oldRole,
        (long) newRole,
        aVoid -> {
          // 实现reply方法
        });
  }

  @Override
  public void onUserSubStreamVideoStart(long uid, int maxProfile) {
    _eventSink.onUserSubStreamVideoStart(channelName, uid, (long) maxProfile, aVoid -> {});
  }

  @Override
  public void onUserSubStreamVideoStop(long uid) {
    _eventSink.onUserSubStreamVideoStop(channelName, uid, aVoid -> {});
  }

  @Override
  public void onLocalAudioFirstPacketSent(NERtcAudioStreamType audioStreamType) {
    if (audioStreamType != null) {
      long type = audioStreamType.ordinal();
      _eventSink.onLocalAudioFirstPacketSent(channelName, type, aVoid -> {});
    }
  }

  @Override
  public void onUserAudioMute(long uid, boolean muted) {
    _eventSink.onUserAudioMute(channelName, uid, muted, aVoid -> {});
  }

  @Override
  public void onUserVideoMute(long uid, boolean muted) {
    // 这个版本已被废弃，应该使用带 streamType 的版本
    // 为了兼容性，创建一个默认的 UserVideoMuteEvent
    Messages.UserVideoMuteEvent.Builder builder = new Messages.UserVideoMuteEvent.Builder();
    builder.setMuted(muted);
    builder.setUid(uid);
    // 默认使用主流 (main stream)
    builder.setStreamType(0L);
    Messages.UserVideoMuteEvent event = builder.build();
    _eventSink.onUserVideoMute(channelName, event, aVoid -> {});
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
    _eventSink.onUserVideoMute(channelName, event, aVoid -> {});
  }

  @Override
  public void onFirstAudioDataReceived(long uid) {
    _eventSink.onFirstAudioDataReceived(channelName, uid, aVoid -> {});
  }

  @Override
  public void onFirstVideoDataReceived(long uid) {
    // 这个版本已被废弃，应该使用带 streamType 的版本
    // 为了兼容性，创建一个默认的 FirstVideoDataReceivedEvent
    Messages.FirstVideoDataReceivedEvent.Builder builder =
        new Messages.FirstVideoDataReceivedEvent.Builder();
    builder.setUid(uid);
    // 默认使用主流 (main stream)
    builder.setStreamType(0L);
    Messages.FirstVideoDataReceivedEvent event = builder.build();
    _eventSink.onFirstVideoDataReceived(channelName, event, aVoid -> {});
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
    _eventSink.onFirstVideoDataReceived(channelName, event, aVoid -> {});
  }

  @Override
  public void onFirstAudioFrameDecoded(long userID) {
    _eventSink.onFirstAudioFrameDecoded(channelName, userID, aVoid -> {});
  }

  @Override
  public void onFirstVideoFrameDecoded(long userID, int width, int height) {
    // 这个版本已被废弃，应该使用带 streamType 的版本
    // 为了兼容性，创建一个默认的 FirstVideoFrameDecodedEvent
    Messages.FirstVideoFrameDecodedEvent.Builder builder =
        new Messages.FirstVideoFrameDecodedEvent.Builder();
    builder.setHeight((long) height);
    builder.setWidth((long) width);
    builder.setUid(userID);
    // 默认使用主流 (main stream)
    builder.setStreamType(0L);
    Messages.FirstVideoFrameDecodedEvent event = builder.build();
    _eventSink.onFirstVideoFrameDecoded(channelName, event, aVoid -> {});
  }

  @Override
  public void onFirstVideoFrameRender(
      long userID, NERtcVideoStreamType streamType, int width, int height, long elapsedTime) {
    if (streamType != null) {
      long type = streamType.ordinal();
      _eventSink.onFirstVideoFrameRender(
          channelName, userID, type, (long) width, (long) height, elapsedTime, aVoid -> {});
    }
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
    _eventSink.onFirstVideoFrameDecoded(channelName, event, aVoid -> {});
  }

  @Override
  public void onRemoteVideoSizeChanged(
      long userId, NERtcVideoStreamType videoType, int width, int height) {
    if (videoType != null) {
      long type = videoType.ordinal();
      _eventSink.onRemoteVideoSizeChanged(
          channelName, userId, type, (long) width, (long) height, aVoid -> {});
    }
  }

  @Override
  public void onLocalVideoRenderSizeChanged(NERtcVideoStreamType videoType, int width, int height) {
    if (videoType != null) {
      long type = videoType.ordinal();
      _eventSink.onLocalVideoRenderSizeChanged(
          channelName, type, (long) width, (long) height, aVoid -> {});
    }
  }

  @Override
  public void onReconnectingStart(long channelId, long uid) {
    _eventSink.onReconnectingStart(channelName, aVoid -> {});
  }

  @Override
  public void onReJoinChannel(int result, long channelId) {
    _eventSink.onReJoinChannel(channelName, (long) result, channelId, aVoid -> {});
  }

  @Override
  public void onLocalAudioVolumeIndication(int volume) {
    _eventSink.onLocalAudioVolumeIndication(channelName, (long) volume, false, aVoid -> {});
  }

  @Override
  public void onLocalAudioVolumeIndication(int volume, boolean vadFlag) {
    _eventSink.onLocalAudioVolumeIndication(channelName, (long) volume, vadFlag, aVoid -> {});
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
      _eventSink.onRemoteAudioVolumeIndication(channelName, event, aVoid -> {});
    }
  }

  @Override
  public void onLiveStreamState(String taskId, String pushUrl, int liveState) {
    _eventSink.onLiveStreamState(channelName, taskId, pushUrl, (long) liveState, aVoid -> {});
  }

  @Override
  public void onConnectionStateChanged(int state, int reason) {
    _eventSink.onConnectionStateChanged(channelName, (long) state, (long) reason, aVoid -> {});
  }

  @Override
  public void onRecvSEIMsg(long userID, String seiMsg) {
    _eventSink.onRecvSEIMsg(channelName, userID, seiMsg, aVoid -> {});
  }

  @Override
  public void onMediaRelayStatesChange(int state, String channelName) {
    _eventSink.onMediaRelayStatesChange(channelName, (long) state, channelName, aVoid -> {});
  }

  @Override
  public void onMediaRelayReceiveEvent(int event, int code, String channelName) {
    _eventSink.onMediaRelayReceiveEvent(
        channelName, (long) event, (long) code, channelName, aVoid -> {});
  }

  @Override
  public void onLocalPublishFallbackToAudioOnly(
      boolean isFallback, NERtcVideoStreamType streamType) {
    long type = streamType.ordinal();
    _eventSink.onLocalPublishFallbackToAudioOnly(channelName, isFallback, type, aVoid -> {});
  }

  @Override
  public void onRemoteSubscribeFallbackToAudioOnly(
      long uid, boolean isFallback, NERtcVideoStreamType neRtcVideoStreamType) {
    long type = neRtcVideoStreamType.ordinal();
    _eventSink.onRemoteSubscribeFallbackToAudioOnly(
        channelName, uid, isFallback, type, aVoid -> {});
  }

  @Override
  public void onMediaRightChange(boolean isAudioBannedByServer, boolean isVideoBannedByServer) {
    _eventSink.onMediaRightChange(
        channelName, isAudioBannedByServer, isVideoBannedByServer, aVoid -> {});
  }

  @Override
  public void onUserSubStreamAudioStart(long uid) {
    _eventSink.onUserSubStreamAudioStart(channelName, uid, aVoid -> {});
  }

  @Override
  public void onUserSubStreamAudioStop(long uid) {
    _eventSink.onUserSubStreamAudioStop(channelName, uid, aVoid -> {});
  }

  @Override
  public void onUserSubStreamAudioMute(long uid, boolean muted) {
    _eventSink.onUserSubStreamAudioMute(channelName, uid, muted, aVoid -> {});
  }

  @Override
  public void onUserDataStart(long uid) {
    _eventSink.onUserDataStart(channelName, uid, aVoid -> {});
  }

  @Override
  public void onUserDataStop(long uid) {
    _eventSink.onUserDataStop(channelName, uid, aVoid -> {});
  }

  @Override
  public void onUserDataReceiveMessage(long uid, ByteBuffer bufferData, long bufferSize) {
    if (bufferData != null && bufferSize > 0 && bufferData.remaining() >= bufferSize) {
      int savedPosition = bufferData.position();
      byte[] data = new byte[(int) bufferSize];
      bufferData.get(data);
      bufferData.position(savedPosition);
      _eventSink.onUserDataReceiveMessage(channelName, uid, data, bufferSize, aVoid -> {});
    }
  }

  @Override
  public void onUserDataStateChanged(long uid) {
    _eventSink.onUserDataStateChanged(channelName, uid, aVoid -> {});
  }

  @Override
  public void onUserDataBufferedAmountChanged(long uid, long previousAmount) {
    _eventSink.onUserDataBufferedAmountChanged(channelName, uid, previousAmount, aVoid -> {});
  }

  @Override
  public void onError(int code) {
    _eventSink.onError(channelName, (long) code, aVoid -> {});
  }

  @Override
  public void onWarning(int code) {
    _eventSink.onWarning(channelName, (long) code, aVoid -> {});
  }

  @Override
  public void onApiCallExecuted(String apiName, int result, String message) {
    _eventSink.onApiCallExecuted(channelName, apiName, (long) result, message, aVoid -> {});
  }

  @Override
  public void onLabFeatureCallback(String key, Object param) {
    if (key != null && param != null) {
      // 将 Object param 转换为 Map<Object, Object>
      Map<Object, Object> paramMap;
      if (param instanceof Map) {
        paramMap = (Map<Object, Object>) param;
      } else {
        // 如果不是 Map，创建一个包含该对象的 Map
        paramMap = new HashMap<>();
        paramMap.put("value", param);
      }
      _eventSink.onLabFeatureCallback(channelName, key, paramMap, aVoid -> {});
    }
  }

  public void onTakeSnapshotResult(int code, String path) {
    _eventSink.onTakeSnapshotResult(channelName, (long) code, path, aVoid -> {});
  }
}
