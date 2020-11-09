/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcflutter.bridge;

import androidx.annotation.Keep;

import com.netease.lava.nertc.sdk.NERtc;
import com.netease.lava.webrtc.EglBase;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

@Keep
public class NERtcApiBridge {

    private NERtcApiBridge() {}

    public static EglBase.Context ensureEglContext() {
        EglBase.Context localSharedEglContext = getEglSharedContext();
        if (localSharedEglContext != null) {
            localSharedEglContext = EglBase.create(localSharedEglContext, EglBase.CONFIG_PLAIN).getEglBaseContext();
        }
        return localSharedEglContext;
    }

    @SuppressWarnings("rawtypes")
    private static EglBase.Context getEglSharedContext() {
        try {
            Class clazzNERtc = NERtc.getInstance().getClass();
            Field fieldRtcEngine = clazzNERtc.getDeclaredField("mRtcEngine");
            fieldRtcEngine.setAccessible(true);
            Object rtcEngine = fieldRtcEngine.get(NERtc.getInstance());
            Class clazzRtcEngine = rtcEngine.getClass();
            Method method = clazzRtcEngine.getMethod("getEglSharedContext");
            return (EglBase.Context) method.invoke(rtcEngine);
        } catch (NoSuchFieldException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }
        return null;
    }


}
