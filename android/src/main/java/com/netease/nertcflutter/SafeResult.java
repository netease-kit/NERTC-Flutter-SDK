/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcflutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;

public final class SafeResult implements MethodChannel.Result {

    final private MethodChannel.Result unsafeResult;
    final private Handler handler = new Handler(Looper.getMainLooper());

    public SafeResult(MethodChannel.Result unsafeResult) {
        this.unsafeResult = unsafeResult;
    }

    @Override
    public void success(@Nullable Object result) {
        runOnMainThread(() -> unsafeResult.success(result));
    }

    @Override
    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
        runOnMainThread(() -> unsafeResult.error(errorCode, errorMessage, errorDetails));
    }

    @Override
    public void notImplemented() {
        runOnMainThread(unsafeResult::notImplemented);
    }


    private void runOnMainThread(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            handler.post(runnable);
        }
    }
}
