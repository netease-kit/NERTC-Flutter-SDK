// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
package com.netease.nertcflutter;

import android.os.Handler;
import android.os.Looper;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.MethodChannel;

public final class SafeResult implements MethodChannel.Result {

  private final MethodChannel.Result unsafeResult;
  private final Handler handler = new Handler(Looper.getMainLooper());

  public SafeResult(MethodChannel.Result unsafeResult) {
    this.unsafeResult = unsafeResult;
  }

  @Override
  public void success(@Nullable Object result) {
    runOnMainThread(() -> unsafeResult.success(result));
  }

  @Override
  public void error(
      String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
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
