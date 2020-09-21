/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcflutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.EventChannel;

public class SafeEventSink implements EventChannel.EventSink {

    final private EventChannel.EventSink unsafeEventSink;
    final private Handler handler = new Handler(Looper.getMainLooper());

    public SafeEventSink(EventChannel.EventSink unsafeEventSink) {
        this.unsafeEventSink = unsafeEventSink;
    }

    @Override
    public void success(@Nullable Object result) {
        runOnMainThread(() -> unsafeEventSink.success(result));
    }

    @Override
    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
        runOnMainThread(() -> unsafeEventSink.error(errorCode, errorMessage, errorDetails));
    }

    @Override
    public void endOfStream() {
        runOnMainThread(unsafeEventSink::endOfStream);
    }

    private void runOnMainThread(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            handler.post(runnable);
        }
    }
}
