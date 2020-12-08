package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.live.NERtcLiveStreamImageInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamTaskInfo.NERtcLiveStreamMode;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamUserTranscoding.NERtcLiveStreamVideoScaleMode;

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

}
