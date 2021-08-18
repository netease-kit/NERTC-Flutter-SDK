/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be 
 * found in the LICENSE file.
 */

package com.netease.nertcflutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public final class SafeMethodChannel {
    final private MethodChannel methodChannel;
    final private Handler handler = new Handler(Looper.getMainLooper());

    public SafeMethodChannel(BinaryMessenger messenger, String name) {
        this.methodChannel = new MethodChannel(messenger, name);
    }

    public void invokeMethod(@NonNull String method, @Nullable Object arguments) {
        runOnMainThread(() -> methodChannel.invokeMethod(method, arguments));
    }

    public void setMethodCallHandler(final @Nullable MethodChannel.MethodCallHandler handler) {
        runOnMainThread(() -> methodChannel.setMethodCallHandler(handler));
    }

    private void runOnMainThread(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            handler.post(runnable);
        }
    }
}
