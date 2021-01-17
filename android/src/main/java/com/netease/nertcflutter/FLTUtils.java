package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.NERtcConstants;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamTaskInfo.NERtcLiveStreamMode;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamUserTranscoding.NERtcLiveStreamVideoScaleMode;
import com.netease.lava.nertc.sdk.video.NERtcEncodeConfig.NERtcVideoFrameRate;
import com.netease.lava.nertc.sdk.video.NERtcRemoteVideoStreamType;
import com.netease.lava.nertc.sdk.video.NERtcScreenConfig;
import com.netease.lava.nertc.sdk.video.NERtcScreenConfig.NERtcSubStreamContentPrefer;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig.NERtcDegradationPreference;

import static com.netease.lava.nertc.sdk.NERtcConstants.MediaCodecMode.MEDIA_CODEC_HARDWARE;
import static com.netease.lava.nertc.sdk.NERtcConstants.MediaCodecMode.MEDIA_CODEC_SOFTWARE;

public class FLTUtils {

    static NERtcLiveStreamMode int2LiveStreamMode(int intValue) {
        for (NERtcLiveStreamMode value : NERtcLiveStreamMode.values()) {
            if(intValue == value.ordinal()) {
                return value;
            }
        }
        throw new RuntimeException("int2LiveStreamMode error: $intValue");
    }


    static NERtcLiveStreamVideoScaleMode int2LiveStreamVideoScaleMode(int intValue) {
        for (NERtcLiveStreamVideoScaleMode value : NERtcLiveStreamVideoScaleMode.values()) {
            if(intValue == value.ordinal()) {
                return value;
            }
        }
        throw new RuntimeException("int2LiveStreamVideoScaleMode error: $intValue");
    }

    static String int2VideoEncodeDecodeMode(int intValue) {
        return intValue == 0 ? MEDIA_CODEC_HARDWARE : MEDIA_CODEC_SOFTWARE;
    }

    static NERtcDegradationPreference int2DegradationPreference(int intValue) {
        for (NERtcDegradationPreference value : NERtcDegradationPreference.values()) {
            if(intValue == value.ordinal()) {
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
            if(intValue == value.ordinal()) {
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

}
