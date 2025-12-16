// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import android.graphics.SurfaceTexture;
import com.netease.lava.webrtc.EglBase;
import com.netease.lava.webrtc.EglRenderer;
import com.netease.lava.webrtc.GlRectDrawer;
import com.netease.lava.webrtc.ThreadUtils;
import com.netease.lava.webrtc.VideoFrame;
import com.netease.nertcflutter.FlutterVideoRenderer.RendererEvents;
import java.util.concurrent.CountDownLatch;

public class SurfaceTextureRenderer extends EglRenderer {

  private final Object layoutLock = new Object();
  private boolean isFirstFrameRendered;
  private int rotatedFrameWidth;
  private int rotatedFrameHeight;
  private int frameRotation;

  private RendererEvents rendererEvents;

  private SurfaceTexture texture;

  public SurfaceTextureRenderer(String name) {
    super(name);
  }

  public void init(final EglBase.Context sharedContext, RendererEvents rendererEvents) {
    ThreadUtils.checkIsOnMainThread();
    this.rendererEvents = rendererEvents;
    synchronized (layoutLock) {
      isFirstFrameRendered = false;
      rotatedFrameWidth = 0;
      rotatedFrameHeight = 0;
      frameRotation = 0;
    }
    super.init(sharedContext, EglBase.CONFIG_PLAIN, new GlRectDrawer());
  }

  public void onFrame(VideoFrame frame) {
    updateFrameDimensionsAndReportEvents(frame);
    super.onFrame(frame);
  }

  public void surfaceCreated(final SurfaceTexture texture) {
    ThreadUtils.checkIsOnMainThread();
    this.texture = texture;
    createEglSurface(texture);
  }

  public void surfaceDestroyed() {
    ThreadUtils.checkIsOnMainThread();
    final CountDownLatch completionLatch = new CountDownLatch(1);
    releaseEglSurface(completionLatch::countDown);
    ThreadUtils.awaitUninterruptibly(completionLatch);
  }

  private void updateFrameDimensionsAndReportEvents(VideoFrame frame) {
    synchronized (layoutLock) {
      if (!isFirstFrameRendered) {
        isFirstFrameRendered = true;
        if (rendererEvents != null) {
          rendererEvents.onFirstFrameRendered();
        }
      }
      if (rotatedFrameWidth != frame.getRotatedWidth()
          || rotatedFrameHeight != frame.getRotatedHeight()
          || frameRotation != frame.getRotation()) {
        if (rendererEvents != null) {
          rendererEvents.onFrameResolutionChanged(
              frame.getBuffer().getWidth(), frame.getBuffer().getHeight(), frame.getRotation());
        }
        rotatedFrameWidth = frame.getRotatedWidth();
        rotatedFrameHeight = frame.getRotatedHeight();
        texture.setDefaultBufferSize(rotatedFrameWidth, rotatedFrameHeight);
        frameRotation = frame.getRotation();
      }
    }
  }
}
