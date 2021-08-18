/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be 
 * found in the LICENSE file.
 */

package com.netease.nertcflutter;

import com.netease.lava.nertc.sdk.audio.NERtcAudioProcessObserver;
import com.netease.nertcflutter.NERtcEngine.CallbackMethod;

public class NERtcAudioProcessObserverImpl implements NERtcAudioProcessObserver {

    private final CallbackMethod callback;

    public NERtcAudioProcessObserverImpl(CallbackMethod callback) {
        this.callback = callback;
    }

    @Override
    public void onAudioHasHowling(boolean flag) {
        if(flag) {
            callback.invokeMethod("onAudioHasHowling", null);
        }
    }
}
