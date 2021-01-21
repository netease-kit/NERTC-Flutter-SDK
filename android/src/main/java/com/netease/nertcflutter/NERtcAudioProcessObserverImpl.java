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
