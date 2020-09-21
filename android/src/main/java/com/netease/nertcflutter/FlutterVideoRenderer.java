/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcflutter;

import android.graphics.SurfaceTexture;

import androidx.annotation.NonNull;

import com.netease.lava.api.IVideoRender;
import com.netease.lava.webrtc.EglBase;
import com.netease.lava.webrtc.VideoFrame;
import com.netease.yunxin.base.thread.ThreadUtils;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.view.TextureRegistry;

public class FlutterVideoRenderer implements IVideoRender, EventChannel.StreamHandler {

    private final TextureRegistry.SurfaceTextureEntry entry;
    private long id = -1;
    private final EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private SurfaceTextureRenderer surfaceTextureRenderer;
    private final SurfaceTexture texture;
    private EglBase.Context sharedEglContext;

    private boolean isInitializeCalled = false;
    private boolean isInitialized = false;


    public interface RendererEvents {
        void onFirstFrameRendered();

        void onFrameResolutionChanged(int width, int height, int rotation);
    }

    private final RendererEvents rendererEvents
            = new RendererEvents() {

        @Override
        public void onFirstFrameRendered() {
            if (eventSink != null) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("id", id);
                map.put("event", "onFirstFrameRendered");
                eventSink.success(map);
            }
        }

        @Override
        public void onFrameResolutionChanged(
                int width, int height,
                int rotation) {

            if (eventSink != null) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("event", "onFrameResolutionChanged");
                map.put("id", id);
                map.put("width", width);
                map.put("height", height);
                map.put("rotation", rotation);
                eventSink.success(map);
            }
        }
    };


    public FlutterVideoRenderer(@NonNull BinaryMessenger messenger, @NonNull TextureRegistry.SurfaceTextureEntry entry,
                                EglBase.Context sharedEglContext) {
        this.entry = entry;
        this.id = entry.id();
        this.texture = entry.surfaceTexture();
        this.surfaceTextureRenderer = new SurfaceTextureRenderer("SurfaceTextureRenderer/" + id);
        this.eventChannel = new EventChannel(messenger, "NERtcFlutterRenderer/Texture" + entry.id());
        this.eventChannel.setStreamHandler(this);
        this.sharedEglContext = sharedEglContext;
    }

    public void dispose() {
        if (eventChannel != null) {
            eventChannel.setStreamHandler(null);
        }
        if (surfaceTextureRenderer != null) {
            surfaceTextureRenderer.release();
            surfaceTextureRenderer = null;
        }
        if (entry != null) {
            entry.release();
        }
    }

    @Override
    public void setScalingType(ScalingType scalingType) {
    }

    @Override
    public void setMirror(boolean mirror) {
    }

    @Override
    public void onFrame(VideoFrame videoFrame) {
        ensureRenderInitialized();
        if (isInitialized) {
            surfaceTextureRenderer.onFrame(videoFrame);
        }
    }

    private void ensureRenderInitialized() {
        if (!isInitializeCalled) {
            isInitializeCalled = true;
            ThreadUtils.runOnUiThread(() -> {
                surfaceTextureRenderer.init(sharedEglContext, rendererEvents);
                surfaceTextureRenderer.surfaceCreated(texture);
                isInitialized = true;
            });
        }
    }

    public long id() {
        return id;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.eventSink = new SafeEventSink(events);
    }

    @Override
    public void onCancel(Object arguments) {
        this.eventSink = null;
    }
}
