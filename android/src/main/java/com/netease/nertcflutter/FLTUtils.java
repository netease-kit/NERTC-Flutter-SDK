// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import static com.netease.lava.nertc.sdk.NERtcConstants.MediaCodecMode.MEDIA_CODEC_HARDWARE;
import static com.netease.lava.nertc.sdk.NERtcConstants.MediaCodecMode.MEDIA_CODEC_SOFTWARE;

import com.netease.lava.nertc.sdk.NERtcConstants;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamTaskInfo.NERtcLiveStreamMode;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamUserTranscoding.NERtcLiveStreamVideoScaleMode;
import com.netease.lava.nertc.sdk.video.NERtcEncodeConfig;
import com.netease.lava.nertc.sdk.video.NERtcEncodeConfig.NERtcVideoFrameRate;
import com.netease.lava.nertc.sdk.video.NERtcRemoteVideoStreamType;
import com.netease.lava.nertc.sdk.video.NERtcScreenConfig.NERtcSubStreamContentPrefer;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamType;
import java.util.List;
import java.util.Map;

public class FLTUtils {

  static NERtcLiveStreamMode int2LiveStreamMode(int intValue) {
    for (NERtcLiveStreamMode value : NERtcLiveStreamMode.values()) {
      if (intValue == value.ordinal()) {
        return value;
      }
    }
    throw new RuntimeException("int2LiveStreamMode error: $intValue");
  }

  static NERtcLiveStreamVideoScaleMode int2LiveStreamVideoScaleMode(int intValue) {
    for (NERtcLiveStreamVideoScaleMode value : NERtcLiveStreamVideoScaleMode.values()) {
      if (intValue == value.ordinal()) {
        return value;
      }
    }
    throw new RuntimeException("int2LiveStreamVideoScaleMode error: $intValue");
  }

  static String int2VideoEncodeDecodeMode(int intValue) {
    return intValue == 0 ? MEDIA_CODEC_HARDWARE : MEDIA_CODEC_SOFTWARE;
  }

  static NERtcEncodeConfig.NERtcDegradationPreference int2DegradationPreference(int intValue) {
    for (NERtcEncodeConfig.NERtcDegradationPreference value :
        NERtcEncodeConfig.NERtcDegradationPreference.values()) {
      if (intValue == value.ordinal()) {
        return value;
      }
    }
    throw new RuntimeException("int2DegradationPreference error: $intValue");
  }

  static NERtcVideoFrameRate int2VideoFrameRate(int intValue) {
    switch (intValue) {
      case 7:
        return NERtcVideoFrameRate.FRAME_RATE_FPS_7;
      case 10:
        return NERtcVideoFrameRate.FRAME_RATE_FPS_10;
      case 15:
        return NERtcVideoFrameRate.FRAME_RATE_FPS_15;
      case 24:
        return NERtcVideoFrameRate.FRAME_RATE_FPS_24;
      default:
        return NERtcVideoFrameRate.FRAME_RATE_FPS_30;
    }
  }

  static NERtcRemoteVideoStreamType int2RemoteVideoStreamType(int intValue) {
    for (NERtcRemoteVideoStreamType value : NERtcRemoteVideoStreamType.values()) {
      if (intValue == value.ordinal()) {
        return value;
      }
    }
    throw new RuntimeException("int2RemoteVideoStreamType error: $intValue");
  }

  static int int2UserRole(int intValue) {
    switch (intValue) {
      case 1:
        return NERtcConstants.UserRole.CLIENT_ROLE_AUDIENCE;
      case 0:
      default:
        return NERtcConstants.UserRole.CLIENT_ROLE_BROADCASTER;
    }
  }

  static NERtcSubStreamContentPrefer int2SubStreamContentPrefer(int intValue) {
    switch (intValue) {
      case 1:
        return NERtcSubStreamContentPrefer.CONTENT_PREFER_DETAILS;
      case 0:
      default:
        return NERtcSubStreamContentPrefer.CONTENT_PREFER_MOTION;
    }
  }

  static NERtcVideoStreamType int2VideoStreamType(int intValue) {
    switch (intValue) {
      case 1:
        return NERtcVideoStreamType.kNERtcVideoStreamTypeSub;
      case 0:
      default:
        return NERtcVideoStreamType.kNERtcVideoStreamTypeMain;
    }
  }

  static NERtcMediaRelayParam.ChannelMediaRelayInfo fromMap(Map<Object, Object> map) {
    if (map == null || map.isEmpty()) return null;
    String channelName = null;
    if (map.containsKey("channelName")) {
      channelName = (String) map.get("channelName");
    }
    long channelUid = 0;
    if (map.containsKey("channelUid")) {
      channelUid = ((Number) map.get("channelUid")).longValue();
    }
    String channelToken = null;
    if (map.containsKey("channelToken")) {
      channelToken = (String) map.get("channelToken");
    }
    return new NERtcMediaRelayParam()
    .new ChannelMediaRelayInfo(channelToken, channelName, channelUid);
  }

  static NERtcVideoConfig.NERtcVideoOutputOrientationMode int2VideoOutputOrientationMode(
      int intValue) {
    switch (intValue) {
      case 1:
        return NERtcVideoConfig.NERtcVideoOutputOrientationMode
            .VIDEO_OUTPUT_ORIENTATION_MODE_FIXED_LANDSCAPE;
      case 2:
        return NERtcVideoConfig.NERtcVideoOutputOrientationMode
            .VIDEO_OUTPUT_ORIENTATION_MODE_FIXED_PORTRAIT;
      case 0:
      default:
        return NERtcVideoConfig.NERtcVideoOutputOrientationMode
            .VIDEO_OUTPUT_ORIENTATION_MODE_ADAPTATIVE;
    }
  }

  static NERtcVideoConfig.NERtcVideoMirrorMode int2VideoMirrorMode(int intValue) {
    switch (intValue) {
      case 1:
        return NERtcVideoConfig.NERtcVideoMirrorMode.VIDEO_MIRROR_MODE_ENABLED;
      case 2:
        return NERtcVideoConfig.NERtcVideoMirrorMode.VIDEO_MIRROR_MODE_DISABLED;
      case 0:
      default:
        return NERtcVideoConfig.NERtcVideoMirrorMode.VIDEO_MIRROR_MODE_AUTO;
    }
  }

  static float[] toGetTransformMatrix(List<Double> transformMatrix) {
    if (transformMatrix == null) {
      return null;
    }
    float[] result = new float[transformMatrix.size()];
    for (int i = 0; i < transformMatrix.size(); i++) {
      result[i] = transformMatrix.get(i).floatValue();
    }
    return result;
  }

  // static NERtcEncryptionConfig.EncryptionMode int2EncryptionMode(int intValue) {
  //     switch (intValue) {
  //         case 0:
  //         default:
  //             return NERtcEncryptionConfig.EncryptionMode.GMCryptoSM4ECB;
  //     }
  // }

}
