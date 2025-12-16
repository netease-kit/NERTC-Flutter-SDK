// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression", "serial"})
public class Messages {

  /** Error class for passing custom error details to Flutter via a thrown PlatformException. */
  public static class FlutterError extends RuntimeException {

    /** The error code. */
    public final String code;

    /** The error details. Must be a datatype supported by the api codec. */
    public final Object details;

    public FlutterError(@NonNull String code, @Nullable String message, @Nullable Object details) {
      super(message);
      this.code = code;
      this.details = details;
    }
  }

  @NonNull
  protected static ArrayList<Object> wrapError(@NonNull Throwable exception) {
    ArrayList<Object> errorList = new ArrayList<Object>(3);
    if (exception instanceof FlutterError) {
      FlutterError error = (FlutterError) exception;
      errorList.add(error.code);
      errorList.add(error.getMessage());
      errorList.add(error.details);
    } else {
      errorList.add(exception.toString());
      errorList.add(exception.getClass().getSimpleName());
      errorList.add(
          "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    }
    return errorList;
  }

  /** 视频水印类型 */
  public enum NERtcVideoWatermarkType {
    /** 图片 */
    K_NERTC_VIDEO_WATERMARK_TYPE_IMAGE(0),
    /** 文字 */
    K_NERTC_VIDEO_WATERMARK_TYPE_TEXT(1),
    /** 时间戳 */
    K_NERTC_VIDEO_WATERMARK_TYPE_TIME_STAMP(2);

    final int index;

    private NERtcVideoWatermarkType(final int index) {
      this.index = index;
    }
  }

  /** 摄像头额外旋转信息 */
  public enum NERtcCaptureExtraRotation {
    /** （默认）没有额外的旋转信息，直接使用系统旋转参数处理 */
    K_NERTC_CAPTURE_EXTRA_ROTATION_DEFAULT(0),
    /** 在系统旋转信息的基础上，额外顺时针旋转90度 */
    K_NERTC_CAPTURE_EXTRA_ROTATION_CLOCK_WISE90(1),
    /** 在系统旋转信息的基础上，额外旋转180度 */
    K_NERTC_CAPTURE_EXTRA_ROTATION180(2),
    /** 在系统旋转信息的基础上，额外逆时针旋转90度 */
    K_NERTC_CAPTURE_EXTRA_ROTATION_ANTI_CLOCK_WISE90(3);

    final int index;

    private NERtcCaptureExtraRotation(final int index) {
      this.index = index;
    }
  }

  /**
   * onUserJoined 回调的一些可选信息
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class NERtcUserJoinExtraInfo {
    /** 自定义信息， 来源于远端用户joinChannel时填的 [NERtcJoinChannelOptions.customInfo]参数，默认为空字符串。 */
    private @NonNull String customInfo;

    public @NonNull String getCustomInfo() {
      return customInfo;
    }

    public void setCustomInfo(@NonNull String setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"customInfo\" is null.");
      }
      this.customInfo = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    NERtcUserJoinExtraInfo() {}

    public static final class Builder {

      private @Nullable String customInfo;

      public @NonNull Builder setCustomInfo(@NonNull String setterArg) {
        this.customInfo = setterArg;
        return this;
      }

      public @NonNull NERtcUserJoinExtraInfo build() {
        NERtcUserJoinExtraInfo pigeonReturn = new NERtcUserJoinExtraInfo();
        pigeonReturn.setCustomInfo(customInfo);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(1);
      toListResult.add(customInfo);
      return toListResult;
    }

    static @NonNull NERtcUserJoinExtraInfo fromList(@NonNull ArrayList<Object> list) {
      NERtcUserJoinExtraInfo pigeonResult = new NERtcUserJoinExtraInfo();
      Object customInfo = list.get(0);
      pigeonResult.setCustomInfo((String) customInfo);
      return pigeonResult;
    }
  }

  /**
   * onUserLeave 回调的一些可选信息
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class NERtcUserLeaveExtraInfo {
    /** 自定义信息, 来源于远端用户joinChannel时填的 [NERtcJoinChannelOptions.customInfo]参数，默认为空字符串。 */
    private @NonNull String customInfo;

    public @NonNull String getCustomInfo() {
      return customInfo;
    }

    public void setCustomInfo(@NonNull String setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"customInfo\" is null.");
      }
      this.customInfo = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    NERtcUserLeaveExtraInfo() {}

    public static final class Builder {

      private @Nullable String customInfo;

      public @NonNull Builder setCustomInfo(@NonNull String setterArg) {
        this.customInfo = setterArg;
        return this;
      }

      public @NonNull NERtcUserLeaveExtraInfo build() {
        NERtcUserLeaveExtraInfo pigeonReturn = new NERtcUserLeaveExtraInfo();
        pigeonReturn.setCustomInfo(customInfo);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(1);
      toListResult.add(customInfo);
      return toListResult;
    }

    static @NonNull NERtcUserLeaveExtraInfo fromList(@NonNull ArrayList<Object> list) {
      NERtcUserLeaveExtraInfo pigeonResult = new NERtcUserLeaveExtraInfo();
      Object customInfo = list.get(0);
      pigeonResult.setCustomInfo((String) customInfo);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class UserJoinedEvent {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @Nullable NERtcUserJoinExtraInfo joinExtraInfo;

    public @Nullable NERtcUserJoinExtraInfo getJoinExtraInfo() {
      return joinExtraInfo;
    }

    public void setJoinExtraInfo(@Nullable NERtcUserJoinExtraInfo setterArg) {
      this.joinExtraInfo = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    UserJoinedEvent() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable NERtcUserJoinExtraInfo joinExtraInfo;

      public @NonNull Builder setJoinExtraInfo(@Nullable NERtcUserJoinExtraInfo setterArg) {
        this.joinExtraInfo = setterArg;
        return this;
      }

      public @NonNull UserJoinedEvent build() {
        UserJoinedEvent pigeonReturn = new UserJoinedEvent();
        pigeonReturn.setUid(uid);
        pigeonReturn.setJoinExtraInfo(joinExtraInfo);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(uid);
      toListResult.add((joinExtraInfo == null) ? null : joinExtraInfo.toList());
      return toListResult;
    }

    static @NonNull UserJoinedEvent fromList(@NonNull ArrayList<Object> list) {
      UserJoinedEvent pigeonResult = new UserJoinedEvent();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object joinExtraInfo = list.get(1);
      pigeonResult.setJoinExtraInfo(
          (joinExtraInfo == null)
              ? null
              : NERtcUserJoinExtraInfo.fromList((ArrayList<Object>) joinExtraInfo));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class UserLeaveEvent {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @NonNull Long reason;

    public @NonNull Long getReason() {
      return reason;
    }

    public void setReason(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"reason\" is null.");
      }
      this.reason = setterArg;
    }

    private @Nullable NERtcUserLeaveExtraInfo leaveExtraInfo;

    public @Nullable NERtcUserLeaveExtraInfo getLeaveExtraInfo() {
      return leaveExtraInfo;
    }

    public void setLeaveExtraInfo(@Nullable NERtcUserLeaveExtraInfo setterArg) {
      this.leaveExtraInfo = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    UserLeaveEvent() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long reason;

      public @NonNull Builder setReason(@NonNull Long setterArg) {
        this.reason = setterArg;
        return this;
      }

      private @Nullable NERtcUserLeaveExtraInfo leaveExtraInfo;

      public @NonNull Builder setLeaveExtraInfo(@Nullable NERtcUserLeaveExtraInfo setterArg) {
        this.leaveExtraInfo = setterArg;
        return this;
      }

      public @NonNull UserLeaveEvent build() {
        UserLeaveEvent pigeonReturn = new UserLeaveEvent();
        pigeonReturn.setUid(uid);
        pigeonReturn.setReason(reason);
        pigeonReturn.setLeaveExtraInfo(leaveExtraInfo);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(uid);
      toListResult.add(reason);
      toListResult.add((leaveExtraInfo == null) ? null : leaveExtraInfo.toList());
      return toListResult;
    }

    static @NonNull UserLeaveEvent fromList(@NonNull ArrayList<Object> list) {
      UserLeaveEvent pigeonResult = new UserLeaveEvent();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object reason = list.get(1);
      pigeonResult.setReason(
          (reason == null)
              ? null
              : ((reason instanceof Integer) ? (Integer) reason : (Long) reason));
      Object leaveExtraInfo = list.get(2);
      pigeonResult.setLeaveExtraInfo(
          (leaveExtraInfo == null)
              ? null
              : NERtcUserLeaveExtraInfo.fromList((ArrayList<Object>) leaveExtraInfo));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class UserVideoMuteEvent {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @NonNull Boolean muted;

    public @NonNull Boolean getMuted() {
      return muted;
    }

    public void setMuted(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"muted\" is null.");
      }
      this.muted = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    UserVideoMuteEvent() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Boolean muted;

      public @NonNull Builder setMuted(@NonNull Boolean setterArg) {
        this.muted = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull UserVideoMuteEvent build() {
        UserVideoMuteEvent pigeonReturn = new UserVideoMuteEvent();
        pigeonReturn.setUid(uid);
        pigeonReturn.setMuted(muted);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(uid);
      toListResult.add(muted);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull UserVideoMuteEvent fromList(@NonNull ArrayList<Object> list) {
      UserVideoMuteEvent pigeonResult = new UserVideoMuteEvent();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object muted = list.get(1);
      pigeonResult.setMuted((Boolean) muted);
      Object streamType = list.get(2);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class FirstVideoDataReceivedEvent {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    FirstVideoDataReceivedEvent() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull FirstVideoDataReceivedEvent build() {
        FirstVideoDataReceivedEvent pigeonReturn = new FirstVideoDataReceivedEvent();
        pigeonReturn.setUid(uid);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(uid);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull FirstVideoDataReceivedEvent fromList(@NonNull ArrayList<Object> list) {
      FirstVideoDataReceivedEvent pigeonResult = new FirstVideoDataReceivedEvent();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object streamType = list.get(1);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class FirstVideoFrameDecodedEvent {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @NonNull Long width;

    public @NonNull Long getWidth() {
      return width;
    }

    public void setWidth(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"width\" is null.");
      }
      this.width = setterArg;
    }

    private @NonNull Long height;

    public @NonNull Long getHeight() {
      return height;
    }

    public void setHeight(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"height\" is null.");
      }
      this.height = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    FirstVideoFrameDecodedEvent() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long width;

      public @NonNull Builder setWidth(@NonNull Long setterArg) {
        this.width = setterArg;
        return this;
      }

      private @Nullable Long height;

      public @NonNull Builder setHeight(@NonNull Long setterArg) {
        this.height = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull FirstVideoFrameDecodedEvent build() {
        FirstVideoFrameDecodedEvent pigeonReturn = new FirstVideoFrameDecodedEvent();
        pigeonReturn.setUid(uid);
        pigeonReturn.setWidth(width);
        pigeonReturn.setHeight(height);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(uid);
      toListResult.add(width);
      toListResult.add(height);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull FirstVideoFrameDecodedEvent fromList(@NonNull ArrayList<Object> list) {
      FirstVideoFrameDecodedEvent pigeonResult = new FirstVideoFrameDecodedEvent();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object width = list.get(1);
      pigeonResult.setWidth(
          (width == null) ? null : ((width instanceof Integer) ? (Integer) width : (Long) width));
      Object height = list.get(2);
      pigeonResult.setHeight(
          (height == null)
              ? null
              : ((height instanceof Integer) ? (Integer) height : (Long) height));
      Object streamType = list.get(3);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class VirtualBackgroundSourceEnabledEvent {
    private @NonNull Boolean enabled;

    public @NonNull Boolean getEnabled() {
      return enabled;
    }

    public void setEnabled(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"enabled\" is null.");
      }
      this.enabled = setterArg;
    }

    private @NonNull Long reason;

    public @NonNull Long getReason() {
      return reason;
    }

    public void setReason(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"reason\" is null.");
      }
      this.reason = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    VirtualBackgroundSourceEnabledEvent() {}

    public static final class Builder {

      private @Nullable Boolean enabled;

      public @NonNull Builder setEnabled(@NonNull Boolean setterArg) {
        this.enabled = setterArg;
        return this;
      }

      private @Nullable Long reason;

      public @NonNull Builder setReason(@NonNull Long setterArg) {
        this.reason = setterArg;
        return this;
      }

      public @NonNull VirtualBackgroundSourceEnabledEvent build() {
        VirtualBackgroundSourceEnabledEvent pigeonReturn =
            new VirtualBackgroundSourceEnabledEvent();
        pigeonReturn.setEnabled(enabled);
        pigeonReturn.setReason(reason);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(enabled);
      toListResult.add(reason);
      return toListResult;
    }

    static @NonNull VirtualBackgroundSourceEnabledEvent fromList(@NonNull ArrayList<Object> list) {
      VirtualBackgroundSourceEnabledEvent pigeonResult = new VirtualBackgroundSourceEnabledEvent();
      Object enabled = list.get(0);
      pigeonResult.setEnabled((Boolean) enabled);
      Object reason = list.get(1);
      pigeonResult.setReason(
          (reason == null)
              ? null
              : ((reason instanceof Integer) ? (Integer) reason : (Long) reason));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class AudioVolumeInfo {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @NonNull Long volume;

    public @NonNull Long getVolume() {
      return volume;
    }

    public void setVolume(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"volume\" is null.");
      }
      this.volume = setterArg;
    }

    private @NonNull Long subStreamVolume;

    public @NonNull Long getSubStreamVolume() {
      return subStreamVolume;
    }

    public void setSubStreamVolume(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"subStreamVolume\" is null.");
      }
      this.subStreamVolume = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    AudioVolumeInfo() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long volume;

      public @NonNull Builder setVolume(@NonNull Long setterArg) {
        this.volume = setterArg;
        return this;
      }

      private @Nullable Long subStreamVolume;

      public @NonNull Builder setSubStreamVolume(@NonNull Long setterArg) {
        this.subStreamVolume = setterArg;
        return this;
      }

      public @NonNull AudioVolumeInfo build() {
        AudioVolumeInfo pigeonReturn = new AudioVolumeInfo();
        pigeonReturn.setUid(uid);
        pigeonReturn.setVolume(volume);
        pigeonReturn.setSubStreamVolume(subStreamVolume);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(uid);
      toListResult.add(volume);
      toListResult.add(subStreamVolume);
      return toListResult;
    }

    static @NonNull AudioVolumeInfo fromList(@NonNull ArrayList<Object> list) {
      AudioVolumeInfo pigeonResult = new AudioVolumeInfo();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object volume = list.get(1);
      pigeonResult.setVolume(
          (volume == null)
              ? null
              : ((volume instanceof Integer) ? (Integer) volume : (Long) volume));
      Object subStreamVolume = list.get(2);
      pigeonResult.setSubStreamVolume(
          (subStreamVolume == null)
              ? null
              : ((subStreamVolume instanceof Integer)
                  ? (Integer) subStreamVolume
                  : (Long) subStreamVolume));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class RemoteAudioVolumeIndicationEvent {
    private @Nullable List<AudioVolumeInfo> volumeList;

    public @Nullable List<AudioVolumeInfo> getVolumeList() {
      return volumeList;
    }

    public void setVolumeList(@Nullable List<AudioVolumeInfo> setterArg) {
      this.volumeList = setterArg;
    }

    private @NonNull Long totalVolume;

    public @NonNull Long getTotalVolume() {
      return totalVolume;
    }

    public void setTotalVolume(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"totalVolume\" is null.");
      }
      this.totalVolume = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    RemoteAudioVolumeIndicationEvent() {}

    public static final class Builder {

      private @Nullable List<AudioVolumeInfo> volumeList;

      public @NonNull Builder setVolumeList(@Nullable List<AudioVolumeInfo> setterArg) {
        this.volumeList = setterArg;
        return this;
      }

      private @Nullable Long totalVolume;

      public @NonNull Builder setTotalVolume(@NonNull Long setterArg) {
        this.totalVolume = setterArg;
        return this;
      }

      public @NonNull RemoteAudioVolumeIndicationEvent build() {
        RemoteAudioVolumeIndicationEvent pigeonReturn = new RemoteAudioVolumeIndicationEvent();
        pigeonReturn.setVolumeList(volumeList);
        pigeonReturn.setTotalVolume(totalVolume);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(volumeList);
      toListResult.add(totalVolume);
      return toListResult;
    }

    static @NonNull RemoteAudioVolumeIndicationEvent fromList(@NonNull ArrayList<Object> list) {
      RemoteAudioVolumeIndicationEvent pigeonResult = new RemoteAudioVolumeIndicationEvent();
      Object volumeList = list.get(0);
      pigeonResult.setVolumeList((List<AudioVolumeInfo>) volumeList);
      Object totalVolume = list.get(1);
      pigeonResult.setTotalVolume(
          (totalVolume == null)
              ? null
              : ((totalVolume instanceof Integer) ? (Integer) totalVolume : (Long) totalVolume));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class Rectangle {
    private @NonNull Long x;

    public @NonNull Long getX() {
      return x;
    }

    public void setX(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"x\" is null.");
      }
      this.x = setterArg;
    }

    private @NonNull Long y;

    public @NonNull Long getY() {
      return y;
    }

    public void setY(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"y\" is null.");
      }
      this.y = setterArg;
    }

    private @NonNull Long width;

    public @NonNull Long getWidth() {
      return width;
    }

    public void setWidth(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"width\" is null.");
      }
      this.width = setterArg;
    }

    private @NonNull Long height;

    public @NonNull Long getHeight() {
      return height;
    }

    public void setHeight(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"height\" is null.");
      }
      this.height = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    Rectangle() {}

    public static final class Builder {

      private @Nullable Long x;

      public @NonNull Builder setX(@NonNull Long setterArg) {
        this.x = setterArg;
        return this;
      }

      private @Nullable Long y;

      public @NonNull Builder setY(@NonNull Long setterArg) {
        this.y = setterArg;
        return this;
      }

      private @Nullable Long width;

      public @NonNull Builder setWidth(@NonNull Long setterArg) {
        this.width = setterArg;
        return this;
      }

      private @Nullable Long height;

      public @NonNull Builder setHeight(@NonNull Long setterArg) {
        this.height = setterArg;
        return this;
      }

      public @NonNull Rectangle build() {
        Rectangle pigeonReturn = new Rectangle();
        pigeonReturn.setX(x);
        pigeonReturn.setY(y);
        pigeonReturn.setWidth(width);
        pigeonReturn.setHeight(height);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(x);
      toListResult.add(y);
      toListResult.add(width);
      toListResult.add(height);
      return toListResult;
    }

    static @NonNull Rectangle fromList(@NonNull ArrayList<Object> list) {
      Rectangle pigeonResult = new Rectangle();
      Object x = list.get(0);
      pigeonResult.setX((x == null) ? null : ((x instanceof Integer) ? (Integer) x : (Long) x));
      Object y = list.get(1);
      pigeonResult.setY((y == null) ? null : ((y instanceof Integer) ? (Integer) y : (Long) y));
      Object width = list.get(2);
      pigeonResult.setWidth(
          (width == null) ? null : ((width instanceof Integer) ? (Integer) width : (Long) width));
      Object height = list.get(3);
      pigeonResult.setHeight(
          (height == null)
              ? null
              : ((height instanceof Integer) ? (Integer) height : (Long) height));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class ScreenCaptureSourceData {
    private @NonNull Long type;

    public @NonNull Long getType() {
      return type;
    }

    public void setType(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"type\" is null.");
      }
      this.type = setterArg;
    }

    private @NonNull Long sourceId;

    public @NonNull Long getSourceId() {
      return sourceId;
    }

    public void setSourceId(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"sourceId\" is null.");
      }
      this.sourceId = setterArg;
    }

    private @NonNull Long status;

    public @NonNull Long getStatus() {
      return status;
    }

    public void setStatus(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"status\" is null.");
      }
      this.status = setterArg;
    }

    private @NonNull Long action;

    public @NonNull Long getAction() {
      return action;
    }

    public void setAction(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"action\" is null.");
      }
      this.action = setterArg;
    }

    private @NonNull Rectangle captureRect;

    public @NonNull Rectangle getCaptureRect() {
      return captureRect;
    }

    public void setCaptureRect(@NonNull Rectangle setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"captureRect\" is null.");
      }
      this.captureRect = setterArg;
    }

    private @NonNull Long level;

    public @NonNull Long getLevel() {
      return level;
    }

    public void setLevel(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"level\" is null.");
      }
      this.level = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    ScreenCaptureSourceData() {}

    public static final class Builder {

      private @Nullable Long type;

      public @NonNull Builder setType(@NonNull Long setterArg) {
        this.type = setterArg;
        return this;
      }

      private @Nullable Long sourceId;

      public @NonNull Builder setSourceId(@NonNull Long setterArg) {
        this.sourceId = setterArg;
        return this;
      }

      private @Nullable Long status;

      public @NonNull Builder setStatus(@NonNull Long setterArg) {
        this.status = setterArg;
        return this;
      }

      private @Nullable Long action;

      public @NonNull Builder setAction(@NonNull Long setterArg) {
        this.action = setterArg;
        return this;
      }

      private @Nullable Rectangle captureRect;

      public @NonNull Builder setCaptureRect(@NonNull Rectangle setterArg) {
        this.captureRect = setterArg;
        return this;
      }

      private @Nullable Long level;

      public @NonNull Builder setLevel(@NonNull Long setterArg) {
        this.level = setterArg;
        return this;
      }

      public @NonNull ScreenCaptureSourceData build() {
        ScreenCaptureSourceData pigeonReturn = new ScreenCaptureSourceData();
        pigeonReturn.setType(type);
        pigeonReturn.setSourceId(sourceId);
        pigeonReturn.setStatus(status);
        pigeonReturn.setAction(action);
        pigeonReturn.setCaptureRect(captureRect);
        pigeonReturn.setLevel(level);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(6);
      toListResult.add(type);
      toListResult.add(sourceId);
      toListResult.add(status);
      toListResult.add(action);
      toListResult.add((captureRect == null) ? null : captureRect.toList());
      toListResult.add(level);
      return toListResult;
    }

    static @NonNull ScreenCaptureSourceData fromList(@NonNull ArrayList<Object> list) {
      ScreenCaptureSourceData pigeonResult = new ScreenCaptureSourceData();
      Object type = list.get(0);
      pigeonResult.setType(
          (type == null) ? null : ((type instanceof Integer) ? (Integer) type : (Long) type));
      Object sourceId = list.get(1);
      pigeonResult.setSourceId(
          (sourceId == null)
              ? null
              : ((sourceId instanceof Integer) ? (Integer) sourceId : (Long) sourceId));
      Object status = list.get(2);
      pigeonResult.setStatus(
          (status == null)
              ? null
              : ((status instanceof Integer) ? (Integer) status : (Long) status));
      Object action = list.get(3);
      pigeonResult.setAction(
          (action == null)
              ? null
              : ((action instanceof Integer) ? (Integer) action : (Long) action));
      Object captureRect = list.get(4);
      pigeonResult.setCaptureRect(
          (captureRect == null) ? null : Rectangle.fromList((ArrayList<Object>) captureRect));
      Object level = list.get(5);
      pigeonResult.setLevel(
          (level == null) ? null : ((level instanceof Integer) ? (Integer) level : (Long) level));
      return pigeonResult;
    }
  }

  /**
   * 上下行 Last mile 网络质量探测结果
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class NERtcLastmileProbeResult {
    /** Last mile 质量探测结果的状态, 详细参数见 [NERtcLastmileProbeResultState] */
    private @NonNull Long state;

    public @NonNull Long getState() {
      return state;
    }

    public void setState(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"state\" is null.");
      }
      this.state = setterArg;
    }

    /** 往返时延，单位为毫秒(ms) */
    private @NonNull Long rtt;

    public @NonNull Long getRtt() {
      return rtt;
    }

    public void setRtt(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"rtt\" is null.");
      }
      this.rtt = setterArg;
    }

    /** 上行网络质量报告 */
    private @NonNull NERtcLastmileProbeOneWayResult uplinkReport;

    public @NonNull NERtcLastmileProbeOneWayResult getUplinkReport() {
      return uplinkReport;
    }

    public void setUplinkReport(@NonNull NERtcLastmileProbeOneWayResult setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uplinkReport\" is null.");
      }
      this.uplinkReport = setterArg;
    }

    /** 下行网络质量报告 */
    private @NonNull NERtcLastmileProbeOneWayResult downlinkReport;

    public @NonNull NERtcLastmileProbeOneWayResult getDownlinkReport() {
      return downlinkReport;
    }

    public void setDownlinkReport(@NonNull NERtcLastmileProbeOneWayResult setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"downlinkReport\" is null.");
      }
      this.downlinkReport = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    NERtcLastmileProbeResult() {}

    public static final class Builder {

      private @Nullable Long state;

      public @NonNull Builder setState(@NonNull Long setterArg) {
        this.state = setterArg;
        return this;
      }

      private @Nullable Long rtt;

      public @NonNull Builder setRtt(@NonNull Long setterArg) {
        this.rtt = setterArg;
        return this;
      }

      private @Nullable NERtcLastmileProbeOneWayResult uplinkReport;

      public @NonNull Builder setUplinkReport(@NonNull NERtcLastmileProbeOneWayResult setterArg) {
        this.uplinkReport = setterArg;
        return this;
      }

      private @Nullable NERtcLastmileProbeOneWayResult downlinkReport;

      public @NonNull Builder setDownlinkReport(@NonNull NERtcLastmileProbeOneWayResult setterArg) {
        this.downlinkReport = setterArg;
        return this;
      }

      public @NonNull NERtcLastmileProbeResult build() {
        NERtcLastmileProbeResult pigeonReturn = new NERtcLastmileProbeResult();
        pigeonReturn.setState(state);
        pigeonReturn.setRtt(rtt);
        pigeonReturn.setUplinkReport(uplinkReport);
        pigeonReturn.setDownlinkReport(downlinkReport);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(state);
      toListResult.add(rtt);
      toListResult.add((uplinkReport == null) ? null : uplinkReport.toList());
      toListResult.add((downlinkReport == null) ? null : downlinkReport.toList());
      return toListResult;
    }

    static @NonNull NERtcLastmileProbeResult fromList(@NonNull ArrayList<Object> list) {
      NERtcLastmileProbeResult pigeonResult = new NERtcLastmileProbeResult();
      Object state = list.get(0);
      pigeonResult.setState(
          (state == null) ? null : ((state instanceof Integer) ? (Integer) state : (Long) state));
      Object rtt = list.get(1);
      pigeonResult.setRtt(
          (rtt == null) ? null : ((rtt instanceof Integer) ? (Integer) rtt : (Long) rtt));
      Object uplinkReport = list.get(2);
      pigeonResult.setUplinkReport(
          (uplinkReport == null)
              ? null
              : NERtcLastmileProbeOneWayResult.fromList((ArrayList<Object>) uplinkReport));
      Object downlinkReport = list.get(3);
      pigeonResult.setDownlinkReport(
          (downlinkReport == null)
              ? null
              : NERtcLastmileProbeOneWayResult.fromList((ArrayList<Object>) downlinkReport));
      return pigeonResult;
    }
  }

  /**
   * 单向 Last mile 网络质量探测结果报告
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class NERtcLastmileProbeOneWayResult {
    /** 丢包率 */
    private @NonNull Long packetLossRate;

    public @NonNull Long getPacketLossRate() {
      return packetLossRate;
    }

    public void setPacketLossRate(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"packetLossRate\" is null.");
      }
      this.packetLossRate = setterArg;
    }

    /** 网络抖动，单位为毫秒 (ms) */
    private @NonNull Long jitter;

    public @NonNull Long getJitter() {
      return jitter;
    }

    public void setJitter(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"jitter\" is null.");
      }
      this.jitter = setterArg;
    }

    /** 可用网络带宽预估，单位为 bps */
    private @NonNull Long availableBandwidth;

    public @NonNull Long getAvailableBandwidth() {
      return availableBandwidth;
    }

    public void setAvailableBandwidth(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"availableBandwidth\" is null.");
      }
      this.availableBandwidth = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    NERtcLastmileProbeOneWayResult() {}

    public static final class Builder {

      private @Nullable Long packetLossRate;

      public @NonNull Builder setPacketLossRate(@NonNull Long setterArg) {
        this.packetLossRate = setterArg;
        return this;
      }

      private @Nullable Long jitter;

      public @NonNull Builder setJitter(@NonNull Long setterArg) {
        this.jitter = setterArg;
        return this;
      }

      private @Nullable Long availableBandwidth;

      public @NonNull Builder setAvailableBandwidth(@NonNull Long setterArg) {
        this.availableBandwidth = setterArg;
        return this;
      }

      public @NonNull NERtcLastmileProbeOneWayResult build() {
        NERtcLastmileProbeOneWayResult pigeonReturn = new NERtcLastmileProbeOneWayResult();
        pigeonReturn.setPacketLossRate(packetLossRate);
        pigeonReturn.setJitter(jitter);
        pigeonReturn.setAvailableBandwidth(availableBandwidth);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(packetLossRate);
      toListResult.add(jitter);
      toListResult.add(availableBandwidth);
      return toListResult;
    }

    static @NonNull NERtcLastmileProbeOneWayResult fromList(@NonNull ArrayList<Object> list) {
      NERtcLastmileProbeOneWayResult pigeonResult = new NERtcLastmileProbeOneWayResult();
      Object packetLossRate = list.get(0);
      pigeonResult.setPacketLossRate(
          (packetLossRate == null)
              ? null
              : ((packetLossRate instanceof Integer)
                  ? (Integer) packetLossRate
                  : (Long) packetLossRate));
      Object jitter = list.get(1);
      pigeonResult.setJitter(
          (jitter == null)
              ? null
              : ((jitter instanceof Integer) ? (Integer) jitter : (Long) jitter));
      Object availableBandwidth = list.get(2);
      pigeonResult.setAvailableBandwidth(
          (availableBandwidth == null)
              ? null
              : ((availableBandwidth instanceof Integer)
                  ? (Integer) availableBandwidth
                  : (Long) availableBandwidth));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class RtcServerAddresses {
    private @Nullable Boolean valid;

    public @Nullable Boolean getValid() {
      return valid;
    }

    public void setValid(@Nullable Boolean setterArg) {
      this.valid = setterArg;
    }

    private @Nullable String channelServer;

    public @Nullable String getChannelServer() {
      return channelServer;
    }

    public void setChannelServer(@Nullable String setterArg) {
      this.channelServer = setterArg;
    }

    private @Nullable String statisticsServer;

    public @Nullable String getStatisticsServer() {
      return statisticsServer;
    }

    public void setStatisticsServer(@Nullable String setterArg) {
      this.statisticsServer = setterArg;
    }

    private @Nullable String roomServer;

    public @Nullable String getRoomServer() {
      return roomServer;
    }

    public void setRoomServer(@Nullable String setterArg) {
      this.roomServer = setterArg;
    }

    private @Nullable String compatServer;

    public @Nullable String getCompatServer() {
      return compatServer;
    }

    public void setCompatServer(@Nullable String setterArg) {
      this.compatServer = setterArg;
    }

    private @Nullable String nosLbsServer;

    public @Nullable String getNosLbsServer() {
      return nosLbsServer;
    }

    public void setNosLbsServer(@Nullable String setterArg) {
      this.nosLbsServer = setterArg;
    }

    private @Nullable String nosUploadSever;

    public @Nullable String getNosUploadSever() {
      return nosUploadSever;
    }

    public void setNosUploadSever(@Nullable String setterArg) {
      this.nosUploadSever = setterArg;
    }

    private @Nullable String nosTokenServer;

    public @Nullable String getNosTokenServer() {
      return nosTokenServer;
    }

    public void setNosTokenServer(@Nullable String setterArg) {
      this.nosTokenServer = setterArg;
    }

    private @Nullable String sdkConfigServer;

    public @Nullable String getSdkConfigServer() {
      return sdkConfigServer;
    }

    public void setSdkConfigServer(@Nullable String setterArg) {
      this.sdkConfigServer = setterArg;
    }

    private @Nullable String cloudProxyServer;

    public @Nullable String getCloudProxyServer() {
      return cloudProxyServer;
    }

    public void setCloudProxyServer(@Nullable String setterArg) {
      this.cloudProxyServer = setterArg;
    }

    private @Nullable String webSocketProxyServer;

    public @Nullable String getWebSocketProxyServer() {
      return webSocketProxyServer;
    }

    public void setWebSocketProxyServer(@Nullable String setterArg) {
      this.webSocketProxyServer = setterArg;
    }

    private @Nullable String quicProxyServer;

    public @Nullable String getQuicProxyServer() {
      return quicProxyServer;
    }

    public void setQuicProxyServer(@Nullable String setterArg) {
      this.quicProxyServer = setterArg;
    }

    private @Nullable String mediaProxyServer;

    public @Nullable String getMediaProxyServer() {
      return mediaProxyServer;
    }

    public void setMediaProxyServer(@Nullable String setterArg) {
      this.mediaProxyServer = setterArg;
    }

    private @Nullable String statisticsDispatchServer;

    public @Nullable String getStatisticsDispatchServer() {
      return statisticsDispatchServer;
    }

    public void setStatisticsDispatchServer(@Nullable String setterArg) {
      this.statisticsDispatchServer = setterArg;
    }

    private @Nullable String statisticsBackupServer;

    public @Nullable String getStatisticsBackupServer() {
      return statisticsBackupServer;
    }

    public void setStatisticsBackupServer(@Nullable String setterArg) {
      this.statisticsBackupServer = setterArg;
    }

    private @Nullable Boolean useIPv6;

    public @Nullable Boolean getUseIPv6() {
      return useIPv6;
    }

    public void setUseIPv6(@Nullable Boolean setterArg) {
      this.useIPv6 = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean valid;

      public @NonNull Builder setValid(@Nullable Boolean setterArg) {
        this.valid = setterArg;
        return this;
      }

      private @Nullable String channelServer;

      public @NonNull Builder setChannelServer(@Nullable String setterArg) {
        this.channelServer = setterArg;
        return this;
      }

      private @Nullable String statisticsServer;

      public @NonNull Builder setStatisticsServer(@Nullable String setterArg) {
        this.statisticsServer = setterArg;
        return this;
      }

      private @Nullable String roomServer;

      public @NonNull Builder setRoomServer(@Nullable String setterArg) {
        this.roomServer = setterArg;
        return this;
      }

      private @Nullable String compatServer;

      public @NonNull Builder setCompatServer(@Nullable String setterArg) {
        this.compatServer = setterArg;
        return this;
      }

      private @Nullable String nosLbsServer;

      public @NonNull Builder setNosLbsServer(@Nullable String setterArg) {
        this.nosLbsServer = setterArg;
        return this;
      }

      private @Nullable String nosUploadSever;

      public @NonNull Builder setNosUploadSever(@Nullable String setterArg) {
        this.nosUploadSever = setterArg;
        return this;
      }

      private @Nullable String nosTokenServer;

      public @NonNull Builder setNosTokenServer(@Nullable String setterArg) {
        this.nosTokenServer = setterArg;
        return this;
      }

      private @Nullable String sdkConfigServer;

      public @NonNull Builder setSdkConfigServer(@Nullable String setterArg) {
        this.sdkConfigServer = setterArg;
        return this;
      }

      private @Nullable String cloudProxyServer;

      public @NonNull Builder setCloudProxyServer(@Nullable String setterArg) {
        this.cloudProxyServer = setterArg;
        return this;
      }

      private @Nullable String webSocketProxyServer;

      public @NonNull Builder setWebSocketProxyServer(@Nullable String setterArg) {
        this.webSocketProxyServer = setterArg;
        return this;
      }

      private @Nullable String quicProxyServer;

      public @NonNull Builder setQuicProxyServer(@Nullable String setterArg) {
        this.quicProxyServer = setterArg;
        return this;
      }

      private @Nullable String mediaProxyServer;

      public @NonNull Builder setMediaProxyServer(@Nullable String setterArg) {
        this.mediaProxyServer = setterArg;
        return this;
      }

      private @Nullable String statisticsDispatchServer;

      public @NonNull Builder setStatisticsDispatchServer(@Nullable String setterArg) {
        this.statisticsDispatchServer = setterArg;
        return this;
      }

      private @Nullable String statisticsBackupServer;

      public @NonNull Builder setStatisticsBackupServer(@Nullable String setterArg) {
        this.statisticsBackupServer = setterArg;
        return this;
      }

      private @Nullable Boolean useIPv6;

      public @NonNull Builder setUseIPv6(@Nullable Boolean setterArg) {
        this.useIPv6 = setterArg;
        return this;
      }

      public @NonNull RtcServerAddresses build() {
        RtcServerAddresses pigeonReturn = new RtcServerAddresses();
        pigeonReturn.setValid(valid);
        pigeonReturn.setChannelServer(channelServer);
        pigeonReturn.setStatisticsServer(statisticsServer);
        pigeonReturn.setRoomServer(roomServer);
        pigeonReturn.setCompatServer(compatServer);
        pigeonReturn.setNosLbsServer(nosLbsServer);
        pigeonReturn.setNosUploadSever(nosUploadSever);
        pigeonReturn.setNosTokenServer(nosTokenServer);
        pigeonReturn.setSdkConfigServer(sdkConfigServer);
        pigeonReturn.setCloudProxyServer(cloudProxyServer);
        pigeonReturn.setWebSocketProxyServer(webSocketProxyServer);
        pigeonReturn.setQuicProxyServer(quicProxyServer);
        pigeonReturn.setMediaProxyServer(mediaProxyServer);
        pigeonReturn.setStatisticsDispatchServer(statisticsDispatchServer);
        pigeonReturn.setStatisticsBackupServer(statisticsBackupServer);
        pigeonReturn.setUseIPv6(useIPv6);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(16);
      toListResult.add(valid);
      toListResult.add(channelServer);
      toListResult.add(statisticsServer);
      toListResult.add(roomServer);
      toListResult.add(compatServer);
      toListResult.add(nosLbsServer);
      toListResult.add(nosUploadSever);
      toListResult.add(nosTokenServer);
      toListResult.add(sdkConfigServer);
      toListResult.add(cloudProxyServer);
      toListResult.add(webSocketProxyServer);
      toListResult.add(quicProxyServer);
      toListResult.add(mediaProxyServer);
      toListResult.add(statisticsDispatchServer);
      toListResult.add(statisticsBackupServer);
      toListResult.add(useIPv6);
      return toListResult;
    }

    static @NonNull RtcServerAddresses fromList(@NonNull ArrayList<Object> list) {
      RtcServerAddresses pigeonResult = new RtcServerAddresses();
      Object valid = list.get(0);
      pigeonResult.setValid((Boolean) valid);
      Object channelServer = list.get(1);
      pigeonResult.setChannelServer((String) channelServer);
      Object statisticsServer = list.get(2);
      pigeonResult.setStatisticsServer((String) statisticsServer);
      Object roomServer = list.get(3);
      pigeonResult.setRoomServer((String) roomServer);
      Object compatServer = list.get(4);
      pigeonResult.setCompatServer((String) compatServer);
      Object nosLbsServer = list.get(5);
      pigeonResult.setNosLbsServer((String) nosLbsServer);
      Object nosUploadSever = list.get(6);
      pigeonResult.setNosUploadSever((String) nosUploadSever);
      Object nosTokenServer = list.get(7);
      pigeonResult.setNosTokenServer((String) nosTokenServer);
      Object sdkConfigServer = list.get(8);
      pigeonResult.setSdkConfigServer((String) sdkConfigServer);
      Object cloudProxyServer = list.get(9);
      pigeonResult.setCloudProxyServer((String) cloudProxyServer);
      Object webSocketProxyServer = list.get(10);
      pigeonResult.setWebSocketProxyServer((String) webSocketProxyServer);
      Object quicProxyServer = list.get(11);
      pigeonResult.setQuicProxyServer((String) quicProxyServer);
      Object mediaProxyServer = list.get(12);
      pigeonResult.setMediaProxyServer((String) mediaProxyServer);
      Object statisticsDispatchServer = list.get(13);
      pigeonResult.setStatisticsDispatchServer((String) statisticsDispatchServer);
      Object statisticsBackupServer = list.get(14);
      pigeonResult.setStatisticsBackupServer((String) statisticsBackupServer);
      Object useIPv6 = list.get(15);
      pigeonResult.setUseIPv6((Boolean) useIPv6);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class CreateEngineRequest {
    private @Nullable String appKey;

    public @Nullable String getAppKey() {
      return appKey;
    }

    public void setAppKey(@Nullable String setterArg) {
      this.appKey = setterArg;
    }

    private @Nullable String logDir;

    public @Nullable String getLogDir() {
      return logDir;
    }

    public void setLogDir(@Nullable String setterArg) {
      this.logDir = setterArg;
    }

    private @Nullable RtcServerAddresses serverAddresses;

    public @Nullable RtcServerAddresses getServerAddresses() {
      return serverAddresses;
    }

    public void setServerAddresses(@Nullable RtcServerAddresses setterArg) {
      this.serverAddresses = setterArg;
    }

    private @Nullable Long logLevel;

    public @Nullable Long getLogLevel() {
      return logLevel;
    }

    public void setLogLevel(@Nullable Long setterArg) {
      this.logLevel = setterArg;
    }

    private @Nullable Boolean audioAutoSubscribe;

    public @Nullable Boolean getAudioAutoSubscribe() {
      return audioAutoSubscribe;
    }

    public void setAudioAutoSubscribe(@Nullable Boolean setterArg) {
      this.audioAutoSubscribe = setterArg;
    }

    private @Nullable Boolean videoAutoSubscribe;

    public @Nullable Boolean getVideoAutoSubscribe() {
      return videoAutoSubscribe;
    }

    public void setVideoAutoSubscribe(@Nullable Boolean setterArg) {
      this.videoAutoSubscribe = setterArg;
    }

    private @Nullable Boolean disableFirstJoinUserCreateChannel;

    public @Nullable Boolean getDisableFirstJoinUserCreateChannel() {
      return disableFirstJoinUserCreateChannel;
    }

    public void setDisableFirstJoinUserCreateChannel(@Nullable Boolean setterArg) {
      this.disableFirstJoinUserCreateChannel = setterArg;
    }

    private @Nullable Boolean audioDisableOverrideSpeakerOnReceiver;

    public @Nullable Boolean getAudioDisableOverrideSpeakerOnReceiver() {
      return audioDisableOverrideSpeakerOnReceiver;
    }

    public void setAudioDisableOverrideSpeakerOnReceiver(@Nullable Boolean setterArg) {
      this.audioDisableOverrideSpeakerOnReceiver = setterArg;
    }

    private @Nullable Boolean audioDisableSWAECOnHeadset;

    public @Nullable Boolean getAudioDisableSWAECOnHeadset() {
      return audioDisableSWAECOnHeadset;
    }

    public void setAudioDisableSWAECOnHeadset(@Nullable Boolean setterArg) {
      this.audioDisableSWAECOnHeadset = setterArg;
    }

    private @Nullable Boolean audioAINSEnabled;

    public @Nullable Boolean getAudioAINSEnabled() {
      return audioAINSEnabled;
    }

    public void setAudioAINSEnabled(@Nullable Boolean setterArg) {
      this.audioAINSEnabled = setterArg;
    }

    private @Nullable Boolean serverRecordAudio;

    public @Nullable Boolean getServerRecordAudio() {
      return serverRecordAudio;
    }

    public void setServerRecordAudio(@Nullable Boolean setterArg) {
      this.serverRecordAudio = setterArg;
    }

    private @Nullable Boolean serverRecordVideo;

    public @Nullable Boolean getServerRecordVideo() {
      return serverRecordVideo;
    }

    public void setServerRecordVideo(@Nullable Boolean setterArg) {
      this.serverRecordVideo = setterArg;
    }

    private @Nullable Long serverRecordMode;

    public @Nullable Long getServerRecordMode() {
      return serverRecordMode;
    }

    public void setServerRecordMode(@Nullable Long setterArg) {
      this.serverRecordMode = setterArg;
    }

    private @Nullable Boolean serverRecordSpeaker;

    public @Nullable Boolean getServerRecordSpeaker() {
      return serverRecordSpeaker;
    }

    public void setServerRecordSpeaker(@Nullable Boolean setterArg) {
      this.serverRecordSpeaker = setterArg;
    }

    private @Nullable Boolean publishSelfStream;

    public @Nullable Boolean getPublishSelfStream() {
      return publishSelfStream;
    }

    public void setPublishSelfStream(@Nullable Boolean setterArg) {
      this.publishSelfStream = setterArg;
    }

    private @Nullable Boolean videoCaptureObserverEnabled;

    public @Nullable Boolean getVideoCaptureObserverEnabled() {
      return videoCaptureObserverEnabled;
    }

    public void setVideoCaptureObserverEnabled(@Nullable Boolean setterArg) {
      this.videoCaptureObserverEnabled = setterArg;
    }

    private @Nullable Long videoEncodeMode;

    public @Nullable Long getVideoEncodeMode() {
      return videoEncodeMode;
    }

    public void setVideoEncodeMode(@Nullable Long setterArg) {
      this.videoEncodeMode = setterArg;
    }

    private @Nullable Long videoDecodeMode;

    public @Nullable Long getVideoDecodeMode() {
      return videoDecodeMode;
    }

    public void setVideoDecodeMode(@Nullable Long setterArg) {
      this.videoDecodeMode = setterArg;
    }

    private @Nullable Long videoSendMode;

    public @Nullable Long getVideoSendMode() {
      return videoSendMode;
    }

    public void setVideoSendMode(@Nullable Long setterArg) {
      this.videoSendMode = setterArg;
    }

    private @Nullable Boolean videoH265Enabled;

    public @Nullable Boolean getVideoH265Enabled() {
      return videoH265Enabled;
    }

    public void setVideoH265Enabled(@Nullable Boolean setterArg) {
      this.videoH265Enabled = setterArg;
    }

    private @Nullable Boolean mode1v1Enabled;

    public @Nullable Boolean getMode1v1Enabled() {
      return mode1v1Enabled;
    }

    public void setMode1v1Enabled(@Nullable Boolean setterArg) {
      this.mode1v1Enabled = setterArg;
    }

    private @Nullable String appGroup;

    public @Nullable String getAppGroup() {
      return appGroup;
    }

    public void setAppGroup(@Nullable String setterArg) {
      this.appGroup = setterArg;
    }

    public static final class Builder {

      private @Nullable String appKey;

      public @NonNull Builder setAppKey(@Nullable String setterArg) {
        this.appKey = setterArg;
        return this;
      }

      private @Nullable String logDir;

      public @NonNull Builder setLogDir(@Nullable String setterArg) {
        this.logDir = setterArg;
        return this;
      }

      private @Nullable RtcServerAddresses serverAddresses;

      public @NonNull Builder setServerAddresses(@Nullable RtcServerAddresses setterArg) {
        this.serverAddresses = setterArg;
        return this;
      }

      private @Nullable Long logLevel;

      public @NonNull Builder setLogLevel(@Nullable Long setterArg) {
        this.logLevel = setterArg;
        return this;
      }

      private @Nullable Boolean audioAutoSubscribe;

      public @NonNull Builder setAudioAutoSubscribe(@Nullable Boolean setterArg) {
        this.audioAutoSubscribe = setterArg;
        return this;
      }

      private @Nullable Boolean videoAutoSubscribe;

      public @NonNull Builder setVideoAutoSubscribe(@Nullable Boolean setterArg) {
        this.videoAutoSubscribe = setterArg;
        return this;
      }

      private @Nullable Boolean disableFirstJoinUserCreateChannel;

      public @NonNull Builder setDisableFirstJoinUserCreateChannel(@Nullable Boolean setterArg) {
        this.disableFirstJoinUserCreateChannel = setterArg;
        return this;
      }

      private @Nullable Boolean audioDisableOverrideSpeakerOnReceiver;

      public @NonNull Builder setAudioDisableOverrideSpeakerOnReceiver(
          @Nullable Boolean setterArg) {
        this.audioDisableOverrideSpeakerOnReceiver = setterArg;
        return this;
      }

      private @Nullable Boolean audioDisableSWAECOnHeadset;

      public @NonNull Builder setAudioDisableSWAECOnHeadset(@Nullable Boolean setterArg) {
        this.audioDisableSWAECOnHeadset = setterArg;
        return this;
      }

      private @Nullable Boolean audioAINSEnabled;

      public @NonNull Builder setAudioAINSEnabled(@Nullable Boolean setterArg) {
        this.audioAINSEnabled = setterArg;
        return this;
      }

      private @Nullable Boolean serverRecordAudio;

      public @NonNull Builder setServerRecordAudio(@Nullable Boolean setterArg) {
        this.serverRecordAudio = setterArg;
        return this;
      }

      private @Nullable Boolean serverRecordVideo;

      public @NonNull Builder setServerRecordVideo(@Nullable Boolean setterArg) {
        this.serverRecordVideo = setterArg;
        return this;
      }

      private @Nullable Long serverRecordMode;

      public @NonNull Builder setServerRecordMode(@Nullable Long setterArg) {
        this.serverRecordMode = setterArg;
        return this;
      }

      private @Nullable Boolean serverRecordSpeaker;

      public @NonNull Builder setServerRecordSpeaker(@Nullable Boolean setterArg) {
        this.serverRecordSpeaker = setterArg;
        return this;
      }

      private @Nullable Boolean publishSelfStream;

      public @NonNull Builder setPublishSelfStream(@Nullable Boolean setterArg) {
        this.publishSelfStream = setterArg;
        return this;
      }

      private @Nullable Boolean videoCaptureObserverEnabled;

      public @NonNull Builder setVideoCaptureObserverEnabled(@Nullable Boolean setterArg) {
        this.videoCaptureObserverEnabled = setterArg;
        return this;
      }

      private @Nullable Long videoEncodeMode;

      public @NonNull Builder setVideoEncodeMode(@Nullable Long setterArg) {
        this.videoEncodeMode = setterArg;
        return this;
      }

      private @Nullable Long videoDecodeMode;

      public @NonNull Builder setVideoDecodeMode(@Nullable Long setterArg) {
        this.videoDecodeMode = setterArg;
        return this;
      }

      private @Nullable Long videoSendMode;

      public @NonNull Builder setVideoSendMode(@Nullable Long setterArg) {
        this.videoSendMode = setterArg;
        return this;
      }

      private @Nullable Boolean videoH265Enabled;

      public @NonNull Builder setVideoH265Enabled(@Nullable Boolean setterArg) {
        this.videoH265Enabled = setterArg;
        return this;
      }

      private @Nullable Boolean mode1v1Enabled;

      public @NonNull Builder setMode1v1Enabled(@Nullable Boolean setterArg) {
        this.mode1v1Enabled = setterArg;
        return this;
      }

      private @Nullable String appGroup;

      public @NonNull Builder setAppGroup(@Nullable String setterArg) {
        this.appGroup = setterArg;
        return this;
      }

      public @NonNull CreateEngineRequest build() {
        CreateEngineRequest pigeonReturn = new CreateEngineRequest();
        pigeonReturn.setAppKey(appKey);
        pigeonReturn.setLogDir(logDir);
        pigeonReturn.setServerAddresses(serverAddresses);
        pigeonReturn.setLogLevel(logLevel);
        pigeonReturn.setAudioAutoSubscribe(audioAutoSubscribe);
        pigeonReturn.setVideoAutoSubscribe(videoAutoSubscribe);
        pigeonReturn.setDisableFirstJoinUserCreateChannel(disableFirstJoinUserCreateChannel);
        pigeonReturn.setAudioDisableOverrideSpeakerOnReceiver(
            audioDisableOverrideSpeakerOnReceiver);
        pigeonReturn.setAudioDisableSWAECOnHeadset(audioDisableSWAECOnHeadset);
        pigeonReturn.setAudioAINSEnabled(audioAINSEnabled);
        pigeonReturn.setServerRecordAudio(serverRecordAudio);
        pigeonReturn.setServerRecordVideo(serverRecordVideo);
        pigeonReturn.setServerRecordMode(serverRecordMode);
        pigeonReturn.setServerRecordSpeaker(serverRecordSpeaker);
        pigeonReturn.setPublishSelfStream(publishSelfStream);
        pigeonReturn.setVideoCaptureObserverEnabled(videoCaptureObserverEnabled);
        pigeonReturn.setVideoEncodeMode(videoEncodeMode);
        pigeonReturn.setVideoDecodeMode(videoDecodeMode);
        pigeonReturn.setVideoSendMode(videoSendMode);
        pigeonReturn.setVideoH265Enabled(videoH265Enabled);
        pigeonReturn.setMode1v1Enabled(mode1v1Enabled);
        pigeonReturn.setAppGroup(appGroup);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(22);
      toListResult.add(appKey);
      toListResult.add(logDir);
      toListResult.add((serverAddresses == null) ? null : serverAddresses.toList());
      toListResult.add(logLevel);
      toListResult.add(audioAutoSubscribe);
      toListResult.add(videoAutoSubscribe);
      toListResult.add(disableFirstJoinUserCreateChannel);
      toListResult.add(audioDisableOverrideSpeakerOnReceiver);
      toListResult.add(audioDisableSWAECOnHeadset);
      toListResult.add(audioAINSEnabled);
      toListResult.add(serverRecordAudio);
      toListResult.add(serverRecordVideo);
      toListResult.add(serverRecordMode);
      toListResult.add(serverRecordSpeaker);
      toListResult.add(publishSelfStream);
      toListResult.add(videoCaptureObserverEnabled);
      toListResult.add(videoEncodeMode);
      toListResult.add(videoDecodeMode);
      toListResult.add(videoSendMode);
      toListResult.add(videoH265Enabled);
      toListResult.add(mode1v1Enabled);
      toListResult.add(appGroup);
      return toListResult;
    }

    static @NonNull CreateEngineRequest fromList(@NonNull ArrayList<Object> list) {
      CreateEngineRequest pigeonResult = new CreateEngineRequest();
      Object appKey = list.get(0);
      pigeonResult.setAppKey((String) appKey);
      Object logDir = list.get(1);
      pigeonResult.setLogDir((String) logDir);
      Object serverAddresses = list.get(2);
      pigeonResult.setServerAddresses(
          (serverAddresses == null)
              ? null
              : RtcServerAddresses.fromList((ArrayList<Object>) serverAddresses));
      Object logLevel = list.get(3);
      pigeonResult.setLogLevel(
          (logLevel == null)
              ? null
              : ((logLevel instanceof Integer) ? (Integer) logLevel : (Long) logLevel));
      Object audioAutoSubscribe = list.get(4);
      pigeonResult.setAudioAutoSubscribe((Boolean) audioAutoSubscribe);
      Object videoAutoSubscribe = list.get(5);
      pigeonResult.setVideoAutoSubscribe((Boolean) videoAutoSubscribe);
      Object disableFirstJoinUserCreateChannel = list.get(6);
      pigeonResult.setDisableFirstJoinUserCreateChannel(
          (Boolean) disableFirstJoinUserCreateChannel);
      Object audioDisableOverrideSpeakerOnReceiver = list.get(7);
      pigeonResult.setAudioDisableOverrideSpeakerOnReceiver(
          (Boolean) audioDisableOverrideSpeakerOnReceiver);
      Object audioDisableSWAECOnHeadset = list.get(8);
      pigeonResult.setAudioDisableSWAECOnHeadset((Boolean) audioDisableSWAECOnHeadset);
      Object audioAINSEnabled = list.get(9);
      pigeonResult.setAudioAINSEnabled((Boolean) audioAINSEnabled);
      Object serverRecordAudio = list.get(10);
      pigeonResult.setServerRecordAudio((Boolean) serverRecordAudio);
      Object serverRecordVideo = list.get(11);
      pigeonResult.setServerRecordVideo((Boolean) serverRecordVideo);
      Object serverRecordMode = list.get(12);
      pigeonResult.setServerRecordMode(
          (serverRecordMode == null)
              ? null
              : ((serverRecordMode instanceof Integer)
                  ? (Integer) serverRecordMode
                  : (Long) serverRecordMode));
      Object serverRecordSpeaker = list.get(13);
      pigeonResult.setServerRecordSpeaker((Boolean) serverRecordSpeaker);
      Object publishSelfStream = list.get(14);
      pigeonResult.setPublishSelfStream((Boolean) publishSelfStream);
      Object videoCaptureObserverEnabled = list.get(15);
      pigeonResult.setVideoCaptureObserverEnabled((Boolean) videoCaptureObserverEnabled);
      Object videoEncodeMode = list.get(16);
      pigeonResult.setVideoEncodeMode(
          (videoEncodeMode == null)
              ? null
              : ((videoEncodeMode instanceof Integer)
                  ? (Integer) videoEncodeMode
                  : (Long) videoEncodeMode));
      Object videoDecodeMode = list.get(17);
      pigeonResult.setVideoDecodeMode(
          (videoDecodeMode == null)
              ? null
              : ((videoDecodeMode instanceof Integer)
                  ? (Integer) videoDecodeMode
                  : (Long) videoDecodeMode));
      Object videoSendMode = list.get(18);
      pigeonResult.setVideoSendMode(
          (videoSendMode == null)
              ? null
              : ((videoSendMode instanceof Integer)
                  ? (Integer) videoSendMode
                  : (Long) videoSendMode));
      Object videoH265Enabled = list.get(19);
      pigeonResult.setVideoH265Enabled((Boolean) videoH265Enabled);
      Object mode1v1Enabled = list.get(20);
      pigeonResult.setMode1v1Enabled((Boolean) mode1v1Enabled);
      Object appGroup = list.get(21);
      pigeonResult.setAppGroup((String) appGroup);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class JoinChannelOptions {
    private @Nullable String customInfo;

    public @Nullable String getCustomInfo() {
      return customInfo;
    }

    public void setCustomInfo(@Nullable String setterArg) {
      this.customInfo = setterArg;
    }

    private @Nullable String permissionKey;

    public @Nullable String getPermissionKey() {
      return permissionKey;
    }

    public void setPermissionKey(@Nullable String setterArg) {
      this.permissionKey = setterArg;
    }

    public static final class Builder {

      private @Nullable String customInfo;

      public @NonNull Builder setCustomInfo(@Nullable String setterArg) {
        this.customInfo = setterArg;
        return this;
      }

      private @Nullable String permissionKey;

      public @NonNull Builder setPermissionKey(@Nullable String setterArg) {
        this.permissionKey = setterArg;
        return this;
      }

      public @NonNull JoinChannelOptions build() {
        JoinChannelOptions pigeonReturn = new JoinChannelOptions();
        pigeonReturn.setCustomInfo(customInfo);
        pigeonReturn.setPermissionKey(permissionKey);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(customInfo);
      toListResult.add(permissionKey);
      return toListResult;
    }

    static @NonNull JoinChannelOptions fromList(@NonNull ArrayList<Object> list) {
      JoinChannelOptions pigeonResult = new JoinChannelOptions();
      Object customInfo = list.get(0);
      pigeonResult.setCustomInfo((String) customInfo);
      Object permissionKey = list.get(1);
      pigeonResult.setPermissionKey((String) permissionKey);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class JoinChannelRequest {
    private @Nullable String token;

    public @Nullable String getToken() {
      return token;
    }

    public void setToken(@Nullable String setterArg) {
      this.token = setterArg;
    }

    private @NonNull String channelName;

    public @NonNull String getChannelName() {
      return channelName;
    }

    public void setChannelName(@NonNull String setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"channelName\" is null.");
      }
      this.channelName = setterArg;
    }

    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @Nullable JoinChannelOptions channelOptions;

    public @Nullable JoinChannelOptions getChannelOptions() {
      return channelOptions;
    }

    public void setChannelOptions(@Nullable JoinChannelOptions setterArg) {
      this.channelOptions = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    JoinChannelRequest() {}

    public static final class Builder {

      private @Nullable String token;

      public @NonNull Builder setToken(@Nullable String setterArg) {
        this.token = setterArg;
        return this;
      }

      private @Nullable String channelName;

      public @NonNull Builder setChannelName(@NonNull String setterArg) {
        this.channelName = setterArg;
        return this;
      }

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable JoinChannelOptions channelOptions;

      public @NonNull Builder setChannelOptions(@Nullable JoinChannelOptions setterArg) {
        this.channelOptions = setterArg;
        return this;
      }

      public @NonNull JoinChannelRequest build() {
        JoinChannelRequest pigeonReturn = new JoinChannelRequest();
        pigeonReturn.setToken(token);
        pigeonReturn.setChannelName(channelName);
        pigeonReturn.setUid(uid);
        pigeonReturn.setChannelOptions(channelOptions);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(token);
      toListResult.add(channelName);
      toListResult.add(uid);
      toListResult.add((channelOptions == null) ? null : channelOptions.toList());
      return toListResult;
    }

    static @NonNull JoinChannelRequest fromList(@NonNull ArrayList<Object> list) {
      JoinChannelRequest pigeonResult = new JoinChannelRequest();
      Object token = list.get(0);
      pigeonResult.setToken((String) token);
      Object channelName = list.get(1);
      pigeonResult.setChannelName((String) channelName);
      Object uid = list.get(2);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object channelOptions = list.get(3);
      pigeonResult.setChannelOptions(
          (channelOptions == null)
              ? null
              : JoinChannelOptions.fromList((ArrayList<Object>) channelOptions));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SubscribeRemoteAudioRequest {
    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    private @Nullable Boolean subscribe;

    public @Nullable Boolean getSubscribe() {
      return subscribe;
    }

    public void setSubscribe(@Nullable Boolean setterArg) {
      this.subscribe = setterArg;
    }

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Boolean subscribe;

      public @NonNull Builder setSubscribe(@Nullable Boolean setterArg) {
        this.subscribe = setterArg;
        return this;
      }

      public @NonNull SubscribeRemoteAudioRequest build() {
        SubscribeRemoteAudioRequest pigeonReturn = new SubscribeRemoteAudioRequest();
        pigeonReturn.setUid(uid);
        pigeonReturn.setSubscribe(subscribe);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(uid);
      toListResult.add(subscribe);
      return toListResult;
    }

    static @NonNull SubscribeRemoteAudioRequest fromList(@NonNull ArrayList<Object> list) {
      SubscribeRemoteAudioRequest pigeonResult = new SubscribeRemoteAudioRequest();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object subscribe = list.get(1);
      pigeonResult.setSubscribe((Boolean) subscribe);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class EnableLocalVideoRequest {
    private @Nullable Boolean enable;

    public @Nullable Boolean getEnable() {
      return enable;
    }

    public void setEnable(@Nullable Boolean setterArg) {
      this.enable = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean enable;

      public @NonNull Builder setEnable(@Nullable Boolean setterArg) {
        this.enable = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull EnableLocalVideoRequest build() {
        EnableLocalVideoRequest pigeonReturn = new EnableLocalVideoRequest();
        pigeonReturn.setEnable(enable);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(enable);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull EnableLocalVideoRequest fromList(@NonNull ArrayList<Object> list) {
      EnableLocalVideoRequest pigeonResult = new EnableLocalVideoRequest();
      Object enable = list.get(0);
      pigeonResult.setEnable((Boolean) enable);
      Object streamType = list.get(1);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetAudioProfileRequest {
    private @Nullable Long profile;

    public @Nullable Long getProfile() {
      return profile;
    }

    public void setProfile(@Nullable Long setterArg) {
      this.profile = setterArg;
    }

    private @Nullable Long scenario;

    public @Nullable Long getScenario() {
      return scenario;
    }

    public void setScenario(@Nullable Long setterArg) {
      this.scenario = setterArg;
    }

    public static final class Builder {

      private @Nullable Long profile;

      public @NonNull Builder setProfile(@Nullable Long setterArg) {
        this.profile = setterArg;
        return this;
      }

      private @Nullable Long scenario;

      public @NonNull Builder setScenario(@Nullable Long setterArg) {
        this.scenario = setterArg;
        return this;
      }

      public @NonNull SetAudioProfileRequest build() {
        SetAudioProfileRequest pigeonReturn = new SetAudioProfileRequest();
        pigeonReturn.setProfile(profile);
        pigeonReturn.setScenario(scenario);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(profile);
      toListResult.add(scenario);
      return toListResult;
    }

    static @NonNull SetAudioProfileRequest fromList(@NonNull ArrayList<Object> list) {
      SetAudioProfileRequest pigeonResult = new SetAudioProfileRequest();
      Object profile = list.get(0);
      pigeonResult.setProfile(
          (profile == null)
              ? null
              : ((profile instanceof Integer) ? (Integer) profile : (Long) profile));
      Object scenario = list.get(1);
      pigeonResult.setScenario(
          (scenario == null)
              ? null
              : ((scenario instanceof Integer) ? (Integer) scenario : (Long) scenario));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetLocalVideoConfigRequest {
    private @Nullable Long videoProfile;

    public @Nullable Long getVideoProfile() {
      return videoProfile;
    }

    public void setVideoProfile(@Nullable Long setterArg) {
      this.videoProfile = setterArg;
    }

    private @Nullable Long videoCropMode;

    public @Nullable Long getVideoCropMode() {
      return videoCropMode;
    }

    public void setVideoCropMode(@Nullable Long setterArg) {
      this.videoCropMode = setterArg;
    }

    private @Nullable Boolean frontCamera;

    public @Nullable Boolean getFrontCamera() {
      return frontCamera;
    }

    public void setFrontCamera(@Nullable Boolean setterArg) {
      this.frontCamera = setterArg;
    }

    private @Nullable Long frameRate;

    public @Nullable Long getFrameRate() {
      return frameRate;
    }

    public void setFrameRate(@Nullable Long setterArg) {
      this.frameRate = setterArg;
    }

    private @Nullable Long minFrameRate;

    public @Nullable Long getMinFrameRate() {
      return minFrameRate;
    }

    public void setMinFrameRate(@Nullable Long setterArg) {
      this.minFrameRate = setterArg;
    }

    private @Nullable Long bitrate;

    public @Nullable Long getBitrate() {
      return bitrate;
    }

    public void setBitrate(@Nullable Long setterArg) {
      this.bitrate = setterArg;
    }

    private @Nullable Long minBitrate;

    public @Nullable Long getMinBitrate() {
      return minBitrate;
    }

    public void setMinBitrate(@Nullable Long setterArg) {
      this.minBitrate = setterArg;
    }

    private @Nullable Long degradationPrefer;

    public @Nullable Long getDegradationPrefer() {
      return degradationPrefer;
    }

    public void setDegradationPrefer(@Nullable Long setterArg) {
      this.degradationPrefer = setterArg;
    }

    private @Nullable Long width;

    public @Nullable Long getWidth() {
      return width;
    }

    public void setWidth(@Nullable Long setterArg) {
      this.width = setterArg;
    }

    private @Nullable Long height;

    public @Nullable Long getHeight() {
      return height;
    }

    public void setHeight(@Nullable Long setterArg) {
      this.height = setterArg;
    }

    private @Nullable Long cameraType;

    public @Nullable Long getCameraType() {
      return cameraType;
    }

    public void setCameraType(@Nullable Long setterArg) {
      this.cameraType = setterArg;
    }

    private @Nullable Long mirrorMode;

    public @Nullable Long getMirrorMode() {
      return mirrorMode;
    }

    public void setMirrorMode(@Nullable Long setterArg) {
      this.mirrorMode = setterArg;
    }

    private @Nullable Long orientationMode;

    public @Nullable Long getOrientationMode() {
      return orientationMode;
    }

    public void setOrientationMode(@Nullable Long setterArg) {
      this.orientationMode = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    public static final class Builder {

      private @Nullable Long videoProfile;

      public @NonNull Builder setVideoProfile(@Nullable Long setterArg) {
        this.videoProfile = setterArg;
        return this;
      }

      private @Nullable Long videoCropMode;

      public @NonNull Builder setVideoCropMode(@Nullable Long setterArg) {
        this.videoCropMode = setterArg;
        return this;
      }

      private @Nullable Boolean frontCamera;

      public @NonNull Builder setFrontCamera(@Nullable Boolean setterArg) {
        this.frontCamera = setterArg;
        return this;
      }

      private @Nullable Long frameRate;

      public @NonNull Builder setFrameRate(@Nullable Long setterArg) {
        this.frameRate = setterArg;
        return this;
      }

      private @Nullable Long minFrameRate;

      public @NonNull Builder setMinFrameRate(@Nullable Long setterArg) {
        this.minFrameRate = setterArg;
        return this;
      }

      private @Nullable Long bitrate;

      public @NonNull Builder setBitrate(@Nullable Long setterArg) {
        this.bitrate = setterArg;
        return this;
      }

      private @Nullable Long minBitrate;

      public @NonNull Builder setMinBitrate(@Nullable Long setterArg) {
        this.minBitrate = setterArg;
        return this;
      }

      private @Nullable Long degradationPrefer;

      public @NonNull Builder setDegradationPrefer(@Nullable Long setterArg) {
        this.degradationPrefer = setterArg;
        return this;
      }

      private @Nullable Long width;

      public @NonNull Builder setWidth(@Nullable Long setterArg) {
        this.width = setterArg;
        return this;
      }

      private @Nullable Long height;

      public @NonNull Builder setHeight(@Nullable Long setterArg) {
        this.height = setterArg;
        return this;
      }

      private @Nullable Long cameraType;

      public @NonNull Builder setCameraType(@Nullable Long setterArg) {
        this.cameraType = setterArg;
        return this;
      }

      private @Nullable Long mirrorMode;

      public @NonNull Builder setMirrorMode(@Nullable Long setterArg) {
        this.mirrorMode = setterArg;
        return this;
      }

      private @Nullable Long orientationMode;

      public @NonNull Builder setOrientationMode(@Nullable Long setterArg) {
        this.orientationMode = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull SetLocalVideoConfigRequest build() {
        SetLocalVideoConfigRequest pigeonReturn = new SetLocalVideoConfigRequest();
        pigeonReturn.setVideoProfile(videoProfile);
        pigeonReturn.setVideoCropMode(videoCropMode);
        pigeonReturn.setFrontCamera(frontCamera);
        pigeonReturn.setFrameRate(frameRate);
        pigeonReturn.setMinFrameRate(minFrameRate);
        pigeonReturn.setBitrate(bitrate);
        pigeonReturn.setMinBitrate(minBitrate);
        pigeonReturn.setDegradationPrefer(degradationPrefer);
        pigeonReturn.setWidth(width);
        pigeonReturn.setHeight(height);
        pigeonReturn.setCameraType(cameraType);
        pigeonReturn.setMirrorMode(mirrorMode);
        pigeonReturn.setOrientationMode(orientationMode);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(14);
      toListResult.add(videoProfile);
      toListResult.add(videoCropMode);
      toListResult.add(frontCamera);
      toListResult.add(frameRate);
      toListResult.add(minFrameRate);
      toListResult.add(bitrate);
      toListResult.add(minBitrate);
      toListResult.add(degradationPrefer);
      toListResult.add(width);
      toListResult.add(height);
      toListResult.add(cameraType);
      toListResult.add(mirrorMode);
      toListResult.add(orientationMode);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull SetLocalVideoConfigRequest fromList(@NonNull ArrayList<Object> list) {
      SetLocalVideoConfigRequest pigeonResult = new SetLocalVideoConfigRequest();
      Object videoProfile = list.get(0);
      pigeonResult.setVideoProfile(
          (videoProfile == null)
              ? null
              : ((videoProfile instanceof Integer) ? (Integer) videoProfile : (Long) videoProfile));
      Object videoCropMode = list.get(1);
      pigeonResult.setVideoCropMode(
          (videoCropMode == null)
              ? null
              : ((videoCropMode instanceof Integer)
                  ? (Integer) videoCropMode
                  : (Long) videoCropMode));
      Object frontCamera = list.get(2);
      pigeonResult.setFrontCamera((Boolean) frontCamera);
      Object frameRate = list.get(3);
      pigeonResult.setFrameRate(
          (frameRate == null)
              ? null
              : ((frameRate instanceof Integer) ? (Integer) frameRate : (Long) frameRate));
      Object minFrameRate = list.get(4);
      pigeonResult.setMinFrameRate(
          (minFrameRate == null)
              ? null
              : ((minFrameRate instanceof Integer) ? (Integer) minFrameRate : (Long) minFrameRate));
      Object bitrate = list.get(5);
      pigeonResult.setBitrate(
          (bitrate == null)
              ? null
              : ((bitrate instanceof Integer) ? (Integer) bitrate : (Long) bitrate));
      Object minBitrate = list.get(6);
      pigeonResult.setMinBitrate(
          (minBitrate == null)
              ? null
              : ((minBitrate instanceof Integer) ? (Integer) minBitrate : (Long) minBitrate));
      Object degradationPrefer = list.get(7);
      pigeonResult.setDegradationPrefer(
          (degradationPrefer == null)
              ? null
              : ((degradationPrefer instanceof Integer)
                  ? (Integer) degradationPrefer
                  : (Long) degradationPrefer));
      Object width = list.get(8);
      pigeonResult.setWidth(
          (width == null) ? null : ((width instanceof Integer) ? (Integer) width : (Long) width));
      Object height = list.get(9);
      pigeonResult.setHeight(
          (height == null)
              ? null
              : ((height instanceof Integer) ? (Integer) height : (Long) height));
      Object cameraType = list.get(10);
      pigeonResult.setCameraType(
          (cameraType == null)
              ? null
              : ((cameraType instanceof Integer) ? (Integer) cameraType : (Long) cameraType));
      Object mirrorMode = list.get(11);
      pigeonResult.setMirrorMode(
          (mirrorMode == null)
              ? null
              : ((mirrorMode instanceof Integer) ? (Integer) mirrorMode : (Long) mirrorMode));
      Object orientationMode = list.get(12);
      pigeonResult.setOrientationMode(
          (orientationMode == null)
              ? null
              : ((orientationMode instanceof Integer)
                  ? (Integer) orientationMode
                  : (Long) orientationMode));
      Object streamType = list.get(13);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /**
   * 摄像头采集配置
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class SetCameraCaptureConfigRequest {
    /** 设置摄像头的额外旋转信息 */
    private @Nullable NERtcCaptureExtraRotation extraRotation;

    public @Nullable NERtcCaptureExtraRotation getExtraRotation() {
      return extraRotation;
    }

    public void setExtraRotation(@Nullable NERtcCaptureExtraRotation setterArg) {
      this.extraRotation = setterArg;
    }

    /**
     * 本地采集的视频宽度，单位为 px。
     *
     * <p>视频编码分辨率以宽 x 高表示，用于设置视频编码分辨率，以衡量编码质量。
     *
     * <p>captureWidth 表示视频帧在横轴上的像素，即自定义宽。
     */
    private @Nullable Long captureWidth;

    public @Nullable Long getCaptureWidth() {
      return captureWidth;
    }

    public void setCaptureWidth(@Nullable Long setterArg) {
      this.captureWidth = setterArg;
    }

    /**
     * 本地采集的视频宽度，单位为 px。
     *
     * <p>视频编码分辨率以宽 x 高表示，用于设置视频编码分辨率，以衡量编码质量。
     *
     * <p>captureHeight 表示视频帧在横轴上的像素，即自定义高。
     */
    private @Nullable Long captureHeight;

    public @Nullable Long getCaptureHeight() {
      return captureHeight;
    }

    public void setCaptureHeight(@Nullable Long setterArg) {
      this.captureHeight = setterArg;
    }

    /** 视频流类型 */
    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    public static final class Builder {

      private @Nullable NERtcCaptureExtraRotation extraRotation;

      public @NonNull Builder setExtraRotation(@Nullable NERtcCaptureExtraRotation setterArg) {
        this.extraRotation = setterArg;
        return this;
      }

      private @Nullable Long captureWidth;

      public @NonNull Builder setCaptureWidth(@Nullable Long setterArg) {
        this.captureWidth = setterArg;
        return this;
      }

      private @Nullable Long captureHeight;

      public @NonNull Builder setCaptureHeight(@Nullable Long setterArg) {
        this.captureHeight = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull SetCameraCaptureConfigRequest build() {
        SetCameraCaptureConfigRequest pigeonReturn = new SetCameraCaptureConfigRequest();
        pigeonReturn.setExtraRotation(extraRotation);
        pigeonReturn.setCaptureWidth(captureWidth);
        pigeonReturn.setCaptureHeight(captureHeight);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(extraRotation == null ? null : extraRotation.index);
      toListResult.add(captureWidth);
      toListResult.add(captureHeight);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull SetCameraCaptureConfigRequest fromList(@NonNull ArrayList<Object> list) {
      SetCameraCaptureConfigRequest pigeonResult = new SetCameraCaptureConfigRequest();
      Object extraRotation = list.get(0);
      pigeonResult.setExtraRotation(
          extraRotation == null ? null : NERtcCaptureExtraRotation.values()[(int) extraRotation]);
      Object captureWidth = list.get(1);
      pigeonResult.setCaptureWidth(
          (captureWidth == null)
              ? null
              : ((captureWidth instanceof Integer) ? (Integer) captureWidth : (Long) captureWidth));
      Object captureHeight = list.get(2);
      pigeonResult.setCaptureHeight(
          (captureHeight == null)
              ? null
              : ((captureHeight instanceof Integer)
                  ? (Integer) captureHeight
                  : (Long) captureHeight));
      Object streamType = list.get(3);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartorStopVideoPreviewRequest {
    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    public static final class Builder {

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull StartorStopVideoPreviewRequest build() {
        StartorStopVideoPreviewRequest pigeonReturn = new StartorStopVideoPreviewRequest();
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(1);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull StartorStopVideoPreviewRequest fromList(@NonNull ArrayList<Object> list) {
      StartorStopVideoPreviewRequest pigeonResult = new StartorStopVideoPreviewRequest();
      Object streamType = list.get(0);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartScreenCaptureRequest {
    private @Nullable Long contentPrefer;

    public @Nullable Long getContentPrefer() {
      return contentPrefer;
    }

    public void setContentPrefer(@Nullable Long setterArg) {
      this.contentPrefer = setterArg;
    }

    private @Nullable Long videoProfile;

    public @Nullable Long getVideoProfile() {
      return videoProfile;
    }

    public void setVideoProfile(@Nullable Long setterArg) {
      this.videoProfile = setterArg;
    }

    private @Nullable Long frameRate;

    public @Nullable Long getFrameRate() {
      return frameRate;
    }

    public void setFrameRate(@Nullable Long setterArg) {
      this.frameRate = setterArg;
    }

    private @Nullable Long minFrameRate;

    public @Nullable Long getMinFrameRate() {
      return minFrameRate;
    }

    public void setMinFrameRate(@Nullable Long setterArg) {
      this.minFrameRate = setterArg;
    }

    private @Nullable Long bitrate;

    public @Nullable Long getBitrate() {
      return bitrate;
    }

    public void setBitrate(@Nullable Long setterArg) {
      this.bitrate = setterArg;
    }

    private @Nullable Long minBitrate;

    public @Nullable Long getMinBitrate() {
      return minBitrate;
    }

    public void setMinBitrate(@Nullable Long setterArg) {
      this.minBitrate = setterArg;
    }

    private @Nullable Map<String, Object> dict;

    public @Nullable Map<String, Object> getDict() {
      return dict;
    }

    public void setDict(@Nullable Map<String, Object> setterArg) {
      this.dict = setterArg;
    }

    public static final class Builder {

      private @Nullable Long contentPrefer;

      public @NonNull Builder setContentPrefer(@Nullable Long setterArg) {
        this.contentPrefer = setterArg;
        return this;
      }

      private @Nullable Long videoProfile;

      public @NonNull Builder setVideoProfile(@Nullable Long setterArg) {
        this.videoProfile = setterArg;
        return this;
      }

      private @Nullable Long frameRate;

      public @NonNull Builder setFrameRate(@Nullable Long setterArg) {
        this.frameRate = setterArg;
        return this;
      }

      private @Nullable Long minFrameRate;

      public @NonNull Builder setMinFrameRate(@Nullable Long setterArg) {
        this.minFrameRate = setterArg;
        return this;
      }

      private @Nullable Long bitrate;

      public @NonNull Builder setBitrate(@Nullable Long setterArg) {
        this.bitrate = setterArg;
        return this;
      }

      private @Nullable Long minBitrate;

      public @NonNull Builder setMinBitrate(@Nullable Long setterArg) {
        this.minBitrate = setterArg;
        return this;
      }

      private @Nullable Map<String, Object> dict;

      public @NonNull Builder setDict(@Nullable Map<String, Object> setterArg) {
        this.dict = setterArg;
        return this;
      }

      public @NonNull StartScreenCaptureRequest build() {
        StartScreenCaptureRequest pigeonReturn = new StartScreenCaptureRequest();
        pigeonReturn.setContentPrefer(contentPrefer);
        pigeonReturn.setVideoProfile(videoProfile);
        pigeonReturn.setFrameRate(frameRate);
        pigeonReturn.setMinFrameRate(minFrameRate);
        pigeonReturn.setBitrate(bitrate);
        pigeonReturn.setMinBitrate(minBitrate);
        pigeonReturn.setDict(dict);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(7);
      toListResult.add(contentPrefer);
      toListResult.add(videoProfile);
      toListResult.add(frameRate);
      toListResult.add(minFrameRate);
      toListResult.add(bitrate);
      toListResult.add(minBitrate);
      toListResult.add(dict);
      return toListResult;
    }

    static @NonNull StartScreenCaptureRequest fromList(@NonNull ArrayList<Object> list) {
      StartScreenCaptureRequest pigeonResult = new StartScreenCaptureRequest();
      Object contentPrefer = list.get(0);
      pigeonResult.setContentPrefer(
          (contentPrefer == null)
              ? null
              : ((contentPrefer instanceof Integer)
                  ? (Integer) contentPrefer
                  : (Long) contentPrefer));
      Object videoProfile = list.get(1);
      pigeonResult.setVideoProfile(
          (videoProfile == null)
              ? null
              : ((videoProfile instanceof Integer) ? (Integer) videoProfile : (Long) videoProfile));
      Object frameRate = list.get(2);
      pigeonResult.setFrameRate(
          (frameRate == null)
              ? null
              : ((frameRate instanceof Integer) ? (Integer) frameRate : (Long) frameRate));
      Object minFrameRate = list.get(3);
      pigeonResult.setMinFrameRate(
          (minFrameRate == null)
              ? null
              : ((minFrameRate instanceof Integer) ? (Integer) minFrameRate : (Long) minFrameRate));
      Object bitrate = list.get(4);
      pigeonResult.setBitrate(
          (bitrate == null)
              ? null
              : ((bitrate instanceof Integer) ? (Integer) bitrate : (Long) bitrate));
      Object minBitrate = list.get(5);
      pigeonResult.setMinBitrate(
          (minBitrate == null)
              ? null
              : ((minBitrate instanceof Integer) ? (Integer) minBitrate : (Long) minBitrate));
      Object dict = list.get(6);
      pigeonResult.setDict((Map<String, Object>) dict);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SubscribeRemoteVideoStreamRequest {
    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    private @Nullable Boolean subscribe;

    public @Nullable Boolean getSubscribe() {
      return subscribe;
    }

    public void setSubscribe(@Nullable Boolean setterArg) {
      this.subscribe = setterArg;
    }

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      private @Nullable Boolean subscribe;

      public @NonNull Builder setSubscribe(@Nullable Boolean setterArg) {
        this.subscribe = setterArg;
        return this;
      }

      public @NonNull SubscribeRemoteVideoStreamRequest build() {
        SubscribeRemoteVideoStreamRequest pigeonReturn = new SubscribeRemoteVideoStreamRequest();
        pigeonReturn.setUid(uid);
        pigeonReturn.setStreamType(streamType);
        pigeonReturn.setSubscribe(subscribe);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(uid);
      toListResult.add(streamType);
      toListResult.add(subscribe);
      return toListResult;
    }

    static @NonNull SubscribeRemoteVideoStreamRequest fromList(@NonNull ArrayList<Object> list) {
      SubscribeRemoteVideoStreamRequest pigeonResult = new SubscribeRemoteVideoStreamRequest();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object streamType = list.get(1);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      Object subscribe = list.get(2);
      pigeonResult.setSubscribe((Boolean) subscribe);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SubscribeRemoteSubStreamVideoRequest {
    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    private @Nullable Boolean subscribe;

    public @Nullable Boolean getSubscribe() {
      return subscribe;
    }

    public void setSubscribe(@Nullable Boolean setterArg) {
      this.subscribe = setterArg;
    }

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Boolean subscribe;

      public @NonNull Builder setSubscribe(@Nullable Boolean setterArg) {
        this.subscribe = setterArg;
        return this;
      }

      public @NonNull SubscribeRemoteSubStreamVideoRequest build() {
        SubscribeRemoteSubStreamVideoRequest pigeonReturn =
            new SubscribeRemoteSubStreamVideoRequest();
        pigeonReturn.setUid(uid);
        pigeonReturn.setSubscribe(subscribe);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(uid);
      toListResult.add(subscribe);
      return toListResult;
    }

    static @NonNull SubscribeRemoteSubStreamVideoRequest fromList(@NonNull ArrayList<Object> list) {
      SubscribeRemoteSubStreamVideoRequest pigeonResult =
          new SubscribeRemoteSubStreamVideoRequest();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object subscribe = list.get(1);
      pigeonResult.setSubscribe((Boolean) subscribe);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class EnableAudioVolumeIndicationRequest {
    private @Nullable Boolean enable;

    public @Nullable Boolean getEnable() {
      return enable;
    }

    public void setEnable(@Nullable Boolean setterArg) {
      this.enable = setterArg;
    }

    private @Nullable Long interval;

    public @Nullable Long getInterval() {
      return interval;
    }

    public void setInterval(@Nullable Long setterArg) {
      this.interval = setterArg;
    }

    private @Nullable Boolean vad;

    public @Nullable Boolean getVad() {
      return vad;
    }

    public void setVad(@Nullable Boolean setterArg) {
      this.vad = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean enable;

      public @NonNull Builder setEnable(@Nullable Boolean setterArg) {
        this.enable = setterArg;
        return this;
      }

      private @Nullable Long interval;

      public @NonNull Builder setInterval(@Nullable Long setterArg) {
        this.interval = setterArg;
        return this;
      }

      private @Nullable Boolean vad;

      public @NonNull Builder setVad(@Nullable Boolean setterArg) {
        this.vad = setterArg;
        return this;
      }

      public @NonNull EnableAudioVolumeIndicationRequest build() {
        EnableAudioVolumeIndicationRequest pigeonReturn = new EnableAudioVolumeIndicationRequest();
        pigeonReturn.setEnable(enable);
        pigeonReturn.setInterval(interval);
        pigeonReturn.setVad(vad);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(enable);
      toListResult.add(interval);
      toListResult.add(vad);
      return toListResult;
    }

    static @NonNull EnableAudioVolumeIndicationRequest fromList(@NonNull ArrayList<Object> list) {
      EnableAudioVolumeIndicationRequest pigeonResult = new EnableAudioVolumeIndicationRequest();
      Object enable = list.get(0);
      pigeonResult.setEnable((Boolean) enable);
      Object interval = list.get(1);
      pigeonResult.setInterval(
          (interval == null)
              ? null
              : ((interval instanceof Integer) ? (Integer) interval : (Long) interval));
      Object vad = list.get(2);
      pigeonResult.setVad((Boolean) vad);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SubscribeRemoteSubStreamAudioRequest {
    private @Nullable Boolean subscribe;

    public @Nullable Boolean getSubscribe() {
      return subscribe;
    }

    public void setSubscribe(@Nullable Boolean setterArg) {
      this.subscribe = setterArg;
    }

    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean subscribe;

      public @NonNull Builder setSubscribe(@Nullable Boolean setterArg) {
        this.subscribe = setterArg;
        return this;
      }

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      public @NonNull SubscribeRemoteSubStreamAudioRequest build() {
        SubscribeRemoteSubStreamAudioRequest pigeonReturn =
            new SubscribeRemoteSubStreamAudioRequest();
        pigeonReturn.setSubscribe(subscribe);
        pigeonReturn.setUid(uid);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(subscribe);
      toListResult.add(uid);
      return toListResult;
    }

    static @NonNull SubscribeRemoteSubStreamAudioRequest fromList(@NonNull ArrayList<Object> list) {
      SubscribeRemoteSubStreamAudioRequest pigeonResult =
          new SubscribeRemoteSubStreamAudioRequest();
      Object subscribe = list.get(0);
      pigeonResult.setSubscribe((Boolean) subscribe);
      Object uid = list.get(1);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetAudioSubscribeOnlyByRequest {
    private @Nullable List<Long> uidArray;

    public @Nullable List<Long> getUidArray() {
      return uidArray;
    }

    public void setUidArray(@Nullable List<Long> setterArg) {
      this.uidArray = setterArg;
    }

    public static final class Builder {

      private @Nullable List<Long> uidArray;

      public @NonNull Builder setUidArray(@Nullable List<Long> setterArg) {
        this.uidArray = setterArg;
        return this;
      }

      public @NonNull SetAudioSubscribeOnlyByRequest build() {
        SetAudioSubscribeOnlyByRequest pigeonReturn = new SetAudioSubscribeOnlyByRequest();
        pigeonReturn.setUidArray(uidArray);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(1);
      toListResult.add(uidArray);
      return toListResult;
    }

    static @NonNull SetAudioSubscribeOnlyByRequest fromList(@NonNull ArrayList<Object> list) {
      SetAudioSubscribeOnlyByRequest pigeonResult = new SetAudioSubscribeOnlyByRequest();
      Object uidArray = list.get(0);
      pigeonResult.setUidArray((List<Long>) uidArray);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartAudioMixingRequest {
    private @Nullable String path;

    public @Nullable String getPath() {
      return path;
    }

    public void setPath(@Nullable String setterArg) {
      this.path = setterArg;
    }

    private @Nullable Long loopCount;

    public @Nullable Long getLoopCount() {
      return loopCount;
    }

    public void setLoopCount(@Nullable Long setterArg) {
      this.loopCount = setterArg;
    }

    private @Nullable Boolean sendEnabled;

    public @Nullable Boolean getSendEnabled() {
      return sendEnabled;
    }

    public void setSendEnabled(@Nullable Boolean setterArg) {
      this.sendEnabled = setterArg;
    }

    private @Nullable Long sendVolume;

    public @Nullable Long getSendVolume() {
      return sendVolume;
    }

    public void setSendVolume(@Nullable Long setterArg) {
      this.sendVolume = setterArg;
    }

    private @Nullable Boolean playbackEnabled;

    public @Nullable Boolean getPlaybackEnabled() {
      return playbackEnabled;
    }

    public void setPlaybackEnabled(@Nullable Boolean setterArg) {
      this.playbackEnabled = setterArg;
    }

    private @Nullable Long playbackVolume;

    public @Nullable Long getPlaybackVolume() {
      return playbackVolume;
    }

    public void setPlaybackVolume(@Nullable Long setterArg) {
      this.playbackVolume = setterArg;
    }

    private @Nullable Long startTimeStamp;

    public @Nullable Long getStartTimeStamp() {
      return startTimeStamp;
    }

    public void setStartTimeStamp(@Nullable Long setterArg) {
      this.startTimeStamp = setterArg;
    }

    private @Nullable Long sendWithAudioType;

    public @Nullable Long getSendWithAudioType() {
      return sendWithAudioType;
    }

    public void setSendWithAudioType(@Nullable Long setterArg) {
      this.sendWithAudioType = setterArg;
    }

    private @Nullable Long progressInterval;

    public @Nullable Long getProgressInterval() {
      return progressInterval;
    }

    public void setProgressInterval(@Nullable Long setterArg) {
      this.progressInterval = setterArg;
    }

    public static final class Builder {

      private @Nullable String path;

      public @NonNull Builder setPath(@Nullable String setterArg) {
        this.path = setterArg;
        return this;
      }

      private @Nullable Long loopCount;

      public @NonNull Builder setLoopCount(@Nullable Long setterArg) {
        this.loopCount = setterArg;
        return this;
      }

      private @Nullable Boolean sendEnabled;

      public @NonNull Builder setSendEnabled(@Nullable Boolean setterArg) {
        this.sendEnabled = setterArg;
        return this;
      }

      private @Nullable Long sendVolume;

      public @NonNull Builder setSendVolume(@Nullable Long setterArg) {
        this.sendVolume = setterArg;
        return this;
      }

      private @Nullable Boolean playbackEnabled;

      public @NonNull Builder setPlaybackEnabled(@Nullable Boolean setterArg) {
        this.playbackEnabled = setterArg;
        return this;
      }

      private @Nullable Long playbackVolume;

      public @NonNull Builder setPlaybackVolume(@Nullable Long setterArg) {
        this.playbackVolume = setterArg;
        return this;
      }

      private @Nullable Long startTimeStamp;

      public @NonNull Builder setStartTimeStamp(@Nullable Long setterArg) {
        this.startTimeStamp = setterArg;
        return this;
      }

      private @Nullable Long sendWithAudioType;

      public @NonNull Builder setSendWithAudioType(@Nullable Long setterArg) {
        this.sendWithAudioType = setterArg;
        return this;
      }

      private @Nullable Long progressInterval;

      public @NonNull Builder setProgressInterval(@Nullable Long setterArg) {
        this.progressInterval = setterArg;
        return this;
      }

      public @NonNull StartAudioMixingRequest build() {
        StartAudioMixingRequest pigeonReturn = new StartAudioMixingRequest();
        pigeonReturn.setPath(path);
        pigeonReturn.setLoopCount(loopCount);
        pigeonReturn.setSendEnabled(sendEnabled);
        pigeonReturn.setSendVolume(sendVolume);
        pigeonReturn.setPlaybackEnabled(playbackEnabled);
        pigeonReturn.setPlaybackVolume(playbackVolume);
        pigeonReturn.setStartTimeStamp(startTimeStamp);
        pigeonReturn.setSendWithAudioType(sendWithAudioType);
        pigeonReturn.setProgressInterval(progressInterval);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(9);
      toListResult.add(path);
      toListResult.add(loopCount);
      toListResult.add(sendEnabled);
      toListResult.add(sendVolume);
      toListResult.add(playbackEnabled);
      toListResult.add(playbackVolume);
      toListResult.add(startTimeStamp);
      toListResult.add(sendWithAudioType);
      toListResult.add(progressInterval);
      return toListResult;
    }

    static @NonNull StartAudioMixingRequest fromList(@NonNull ArrayList<Object> list) {
      StartAudioMixingRequest pigeonResult = new StartAudioMixingRequest();
      Object path = list.get(0);
      pigeonResult.setPath((String) path);
      Object loopCount = list.get(1);
      pigeonResult.setLoopCount(
          (loopCount == null)
              ? null
              : ((loopCount instanceof Integer) ? (Integer) loopCount : (Long) loopCount));
      Object sendEnabled = list.get(2);
      pigeonResult.setSendEnabled((Boolean) sendEnabled);
      Object sendVolume = list.get(3);
      pigeonResult.setSendVolume(
          (sendVolume == null)
              ? null
              : ((sendVolume instanceof Integer) ? (Integer) sendVolume : (Long) sendVolume));
      Object playbackEnabled = list.get(4);
      pigeonResult.setPlaybackEnabled((Boolean) playbackEnabled);
      Object playbackVolume = list.get(5);
      pigeonResult.setPlaybackVolume(
          (playbackVolume == null)
              ? null
              : ((playbackVolume instanceof Integer)
                  ? (Integer) playbackVolume
                  : (Long) playbackVolume));
      Object startTimeStamp = list.get(6);
      pigeonResult.setStartTimeStamp(
          (startTimeStamp == null)
              ? null
              : ((startTimeStamp instanceof Integer)
                  ? (Integer) startTimeStamp
                  : (Long) startTimeStamp));
      Object sendWithAudioType = list.get(7);
      pigeonResult.setSendWithAudioType(
          (sendWithAudioType == null)
              ? null
              : ((sendWithAudioType instanceof Integer)
                  ? (Integer) sendWithAudioType
                  : (Long) sendWithAudioType));
      Object progressInterval = list.get(8);
      pigeonResult.setProgressInterval(
          (progressInterval == null)
              ? null
              : ((progressInterval instanceof Integer)
                  ? (Integer) progressInterval
                  : (Long) progressInterval));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class PlayEffectRequest {
    private @Nullable Long effectId;

    public @Nullable Long getEffectId() {
      return effectId;
    }

    public void setEffectId(@Nullable Long setterArg) {
      this.effectId = setterArg;
    }

    private @Nullable String path;

    public @Nullable String getPath() {
      return path;
    }

    public void setPath(@Nullable String setterArg) {
      this.path = setterArg;
    }

    private @Nullable Long loopCount;

    public @Nullable Long getLoopCount() {
      return loopCount;
    }

    public void setLoopCount(@Nullable Long setterArg) {
      this.loopCount = setterArg;
    }

    private @Nullable Boolean sendEnabled;

    public @Nullable Boolean getSendEnabled() {
      return sendEnabled;
    }

    public void setSendEnabled(@Nullable Boolean setterArg) {
      this.sendEnabled = setterArg;
    }

    private @Nullable Long sendVolume;

    public @Nullable Long getSendVolume() {
      return sendVolume;
    }

    public void setSendVolume(@Nullable Long setterArg) {
      this.sendVolume = setterArg;
    }

    private @Nullable Boolean playbackEnabled;

    public @Nullable Boolean getPlaybackEnabled() {
      return playbackEnabled;
    }

    public void setPlaybackEnabled(@Nullable Boolean setterArg) {
      this.playbackEnabled = setterArg;
    }

    private @Nullable Long playbackVolume;

    public @Nullable Long getPlaybackVolume() {
      return playbackVolume;
    }

    public void setPlaybackVolume(@Nullable Long setterArg) {
      this.playbackVolume = setterArg;
    }

    private @Nullable Long startTimestamp;

    public @Nullable Long getStartTimestamp() {
      return startTimestamp;
    }

    public void setStartTimestamp(@Nullable Long setterArg) {
      this.startTimestamp = setterArg;
    }

    private @Nullable Long sendWithAudioType;

    public @Nullable Long getSendWithAudioType() {
      return sendWithAudioType;
    }

    public void setSendWithAudioType(@Nullable Long setterArg) {
      this.sendWithAudioType = setterArg;
    }

    private @Nullable Long progressInterval;

    public @Nullable Long getProgressInterval() {
      return progressInterval;
    }

    public void setProgressInterval(@Nullable Long setterArg) {
      this.progressInterval = setterArg;
    }

    public static final class Builder {

      private @Nullable Long effectId;

      public @NonNull Builder setEffectId(@Nullable Long setterArg) {
        this.effectId = setterArg;
        return this;
      }

      private @Nullable String path;

      public @NonNull Builder setPath(@Nullable String setterArg) {
        this.path = setterArg;
        return this;
      }

      private @Nullable Long loopCount;

      public @NonNull Builder setLoopCount(@Nullable Long setterArg) {
        this.loopCount = setterArg;
        return this;
      }

      private @Nullable Boolean sendEnabled;

      public @NonNull Builder setSendEnabled(@Nullable Boolean setterArg) {
        this.sendEnabled = setterArg;
        return this;
      }

      private @Nullable Long sendVolume;

      public @NonNull Builder setSendVolume(@Nullable Long setterArg) {
        this.sendVolume = setterArg;
        return this;
      }

      private @Nullable Boolean playbackEnabled;

      public @NonNull Builder setPlaybackEnabled(@Nullable Boolean setterArg) {
        this.playbackEnabled = setterArg;
        return this;
      }

      private @Nullable Long playbackVolume;

      public @NonNull Builder setPlaybackVolume(@Nullable Long setterArg) {
        this.playbackVolume = setterArg;
        return this;
      }

      private @Nullable Long startTimestamp;

      public @NonNull Builder setStartTimestamp(@Nullable Long setterArg) {
        this.startTimestamp = setterArg;
        return this;
      }

      private @Nullable Long sendWithAudioType;

      public @NonNull Builder setSendWithAudioType(@Nullable Long setterArg) {
        this.sendWithAudioType = setterArg;
        return this;
      }

      private @Nullable Long progressInterval;

      public @NonNull Builder setProgressInterval(@Nullable Long setterArg) {
        this.progressInterval = setterArg;
        return this;
      }

      public @NonNull PlayEffectRequest build() {
        PlayEffectRequest pigeonReturn = new PlayEffectRequest();
        pigeonReturn.setEffectId(effectId);
        pigeonReturn.setPath(path);
        pigeonReturn.setLoopCount(loopCount);
        pigeonReturn.setSendEnabled(sendEnabled);
        pigeonReturn.setSendVolume(sendVolume);
        pigeonReturn.setPlaybackEnabled(playbackEnabled);
        pigeonReturn.setPlaybackVolume(playbackVolume);
        pigeonReturn.setStartTimestamp(startTimestamp);
        pigeonReturn.setSendWithAudioType(sendWithAudioType);
        pigeonReturn.setProgressInterval(progressInterval);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(10);
      toListResult.add(effectId);
      toListResult.add(path);
      toListResult.add(loopCount);
      toListResult.add(sendEnabled);
      toListResult.add(sendVolume);
      toListResult.add(playbackEnabled);
      toListResult.add(playbackVolume);
      toListResult.add(startTimestamp);
      toListResult.add(sendWithAudioType);
      toListResult.add(progressInterval);
      return toListResult;
    }

    static @NonNull PlayEffectRequest fromList(@NonNull ArrayList<Object> list) {
      PlayEffectRequest pigeonResult = new PlayEffectRequest();
      Object effectId = list.get(0);
      pigeonResult.setEffectId(
          (effectId == null)
              ? null
              : ((effectId instanceof Integer) ? (Integer) effectId : (Long) effectId));
      Object path = list.get(1);
      pigeonResult.setPath((String) path);
      Object loopCount = list.get(2);
      pigeonResult.setLoopCount(
          (loopCount == null)
              ? null
              : ((loopCount instanceof Integer) ? (Integer) loopCount : (Long) loopCount));
      Object sendEnabled = list.get(3);
      pigeonResult.setSendEnabled((Boolean) sendEnabled);
      Object sendVolume = list.get(4);
      pigeonResult.setSendVolume(
          (sendVolume == null)
              ? null
              : ((sendVolume instanceof Integer) ? (Integer) sendVolume : (Long) sendVolume));
      Object playbackEnabled = list.get(5);
      pigeonResult.setPlaybackEnabled((Boolean) playbackEnabled);
      Object playbackVolume = list.get(6);
      pigeonResult.setPlaybackVolume(
          (playbackVolume == null)
              ? null
              : ((playbackVolume instanceof Integer)
                  ? (Integer) playbackVolume
                  : (Long) playbackVolume));
      Object startTimestamp = list.get(7);
      pigeonResult.setStartTimestamp(
          (startTimestamp == null)
              ? null
              : ((startTimestamp instanceof Integer)
                  ? (Integer) startTimestamp
                  : (Long) startTimestamp));
      Object sendWithAudioType = list.get(8);
      pigeonResult.setSendWithAudioType(
          (sendWithAudioType == null)
              ? null
              : ((sendWithAudioType instanceof Integer)
                  ? (Integer) sendWithAudioType
                  : (Long) sendWithAudioType));
      Object progressInterval = list.get(9);
      pigeonResult.setProgressInterval(
          (progressInterval == null)
              ? null
              : ((progressInterval instanceof Integer)
                  ? (Integer) progressInterval
                  : (Long) progressInterval));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetCameraPositionRequest {
    private @Nullable Double x;

    public @Nullable Double getX() {
      return x;
    }

    public void setX(@Nullable Double setterArg) {
      this.x = setterArg;
    }

    private @Nullable Double y;

    public @Nullable Double getY() {
      return y;
    }

    public void setY(@Nullable Double setterArg) {
      this.y = setterArg;
    }

    public static final class Builder {

      private @Nullable Double x;

      public @NonNull Builder setX(@Nullable Double setterArg) {
        this.x = setterArg;
        return this;
      }

      private @Nullable Double y;

      public @NonNull Builder setY(@Nullable Double setterArg) {
        this.y = setterArg;
        return this;
      }

      public @NonNull SetCameraPositionRequest build() {
        SetCameraPositionRequest pigeonReturn = new SetCameraPositionRequest();
        pigeonReturn.setX(x);
        pigeonReturn.setY(y);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(x);
      toListResult.add(y);
      return toListResult;
    }

    static @NonNull SetCameraPositionRequest fromList(@NonNull ArrayList<Object> list) {
      SetCameraPositionRequest pigeonResult = new SetCameraPositionRequest();
      Object x = list.get(0);
      pigeonResult.setX((Double) x);
      Object y = list.get(1);
      pigeonResult.setY((Double) y);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class AddOrUpdateLiveStreamTaskRequest {
    private @Nullable Long serial;

    public @Nullable Long getSerial() {
      return serial;
    }

    public void setSerial(@Nullable Long setterArg) {
      this.serial = setterArg;
    }

    private @Nullable String taskId;

    public @Nullable String getTaskId() {
      return taskId;
    }

    public void setTaskId(@Nullable String setterArg) {
      this.taskId = setterArg;
    }

    private @Nullable String url;

    public @Nullable String getUrl() {
      return url;
    }

    public void setUrl(@Nullable String setterArg) {
      this.url = setterArg;
    }

    private @Nullable Boolean serverRecordEnabled;

    public @Nullable Boolean getServerRecordEnabled() {
      return serverRecordEnabled;
    }

    public void setServerRecordEnabled(@Nullable Boolean setterArg) {
      this.serverRecordEnabled = setterArg;
    }

    private @Nullable Long liveMode;

    public @Nullable Long getLiveMode() {
      return liveMode;
    }

    public void setLiveMode(@Nullable Long setterArg) {
      this.liveMode = setterArg;
    }

    private @Nullable Long layoutWidth;

    public @Nullable Long getLayoutWidth() {
      return layoutWidth;
    }

    public void setLayoutWidth(@Nullable Long setterArg) {
      this.layoutWidth = setterArg;
    }

    private @Nullable Long layoutHeight;

    public @Nullable Long getLayoutHeight() {
      return layoutHeight;
    }

    public void setLayoutHeight(@Nullable Long setterArg) {
      this.layoutHeight = setterArg;
    }

    private @Nullable Long layoutBackgroundColor;

    public @Nullable Long getLayoutBackgroundColor() {
      return layoutBackgroundColor;
    }

    public void setLayoutBackgroundColor(@Nullable Long setterArg) {
      this.layoutBackgroundColor = setterArg;
    }

    private @Nullable String layoutImageUrl;

    public @Nullable String getLayoutImageUrl() {
      return layoutImageUrl;
    }

    public void setLayoutImageUrl(@Nullable String setterArg) {
      this.layoutImageUrl = setterArg;
    }

    private @Nullable Long layoutImageX;

    public @Nullable Long getLayoutImageX() {
      return layoutImageX;
    }

    public void setLayoutImageX(@Nullable Long setterArg) {
      this.layoutImageX = setterArg;
    }

    private @Nullable Long layoutImageY;

    public @Nullable Long getLayoutImageY() {
      return layoutImageY;
    }

    public void setLayoutImageY(@Nullable Long setterArg) {
      this.layoutImageY = setterArg;
    }

    private @Nullable Long layoutImageWidth;

    public @Nullable Long getLayoutImageWidth() {
      return layoutImageWidth;
    }

    public void setLayoutImageWidth(@Nullable Long setterArg) {
      this.layoutImageWidth = setterArg;
    }

    private @Nullable Long layoutImageHeight;

    public @Nullable Long getLayoutImageHeight() {
      return layoutImageHeight;
    }

    public void setLayoutImageHeight(@Nullable Long setterArg) {
      this.layoutImageHeight = setterArg;
    }

    private @Nullable List<Object> layoutUserTranscodingList;

    public @Nullable List<Object> getLayoutUserTranscodingList() {
      return layoutUserTranscodingList;
    }

    public void setLayoutUserTranscodingList(@Nullable List<Object> setterArg) {
      this.layoutUserTranscodingList = setterArg;
    }

    public static final class Builder {

      private @Nullable Long serial;

      public @NonNull Builder setSerial(@Nullable Long setterArg) {
        this.serial = setterArg;
        return this;
      }

      private @Nullable String taskId;

      public @NonNull Builder setTaskId(@Nullable String setterArg) {
        this.taskId = setterArg;
        return this;
      }

      private @Nullable String url;

      public @NonNull Builder setUrl(@Nullable String setterArg) {
        this.url = setterArg;
        return this;
      }

      private @Nullable Boolean serverRecordEnabled;

      public @NonNull Builder setServerRecordEnabled(@Nullable Boolean setterArg) {
        this.serverRecordEnabled = setterArg;
        return this;
      }

      private @Nullable Long liveMode;

      public @NonNull Builder setLiveMode(@Nullable Long setterArg) {
        this.liveMode = setterArg;
        return this;
      }

      private @Nullable Long layoutWidth;

      public @NonNull Builder setLayoutWidth(@Nullable Long setterArg) {
        this.layoutWidth = setterArg;
        return this;
      }

      private @Nullable Long layoutHeight;

      public @NonNull Builder setLayoutHeight(@Nullable Long setterArg) {
        this.layoutHeight = setterArg;
        return this;
      }

      private @Nullable Long layoutBackgroundColor;

      public @NonNull Builder setLayoutBackgroundColor(@Nullable Long setterArg) {
        this.layoutBackgroundColor = setterArg;
        return this;
      }

      private @Nullable String layoutImageUrl;

      public @NonNull Builder setLayoutImageUrl(@Nullable String setterArg) {
        this.layoutImageUrl = setterArg;
        return this;
      }

      private @Nullable Long layoutImageX;

      public @NonNull Builder setLayoutImageX(@Nullable Long setterArg) {
        this.layoutImageX = setterArg;
        return this;
      }

      private @Nullable Long layoutImageY;

      public @NonNull Builder setLayoutImageY(@Nullable Long setterArg) {
        this.layoutImageY = setterArg;
        return this;
      }

      private @Nullable Long layoutImageWidth;

      public @NonNull Builder setLayoutImageWidth(@Nullable Long setterArg) {
        this.layoutImageWidth = setterArg;
        return this;
      }

      private @Nullable Long layoutImageHeight;

      public @NonNull Builder setLayoutImageHeight(@Nullable Long setterArg) {
        this.layoutImageHeight = setterArg;
        return this;
      }

      private @Nullable List<Object> layoutUserTranscodingList;

      public @NonNull Builder setLayoutUserTranscodingList(@Nullable List<Object> setterArg) {
        this.layoutUserTranscodingList = setterArg;
        return this;
      }

      public @NonNull AddOrUpdateLiveStreamTaskRequest build() {
        AddOrUpdateLiveStreamTaskRequest pigeonReturn = new AddOrUpdateLiveStreamTaskRequest();
        pigeonReturn.setSerial(serial);
        pigeonReturn.setTaskId(taskId);
        pigeonReturn.setUrl(url);
        pigeonReturn.setServerRecordEnabled(serverRecordEnabled);
        pigeonReturn.setLiveMode(liveMode);
        pigeonReturn.setLayoutWidth(layoutWidth);
        pigeonReturn.setLayoutHeight(layoutHeight);
        pigeonReturn.setLayoutBackgroundColor(layoutBackgroundColor);
        pigeonReturn.setLayoutImageUrl(layoutImageUrl);
        pigeonReturn.setLayoutImageX(layoutImageX);
        pigeonReturn.setLayoutImageY(layoutImageY);
        pigeonReturn.setLayoutImageWidth(layoutImageWidth);
        pigeonReturn.setLayoutImageHeight(layoutImageHeight);
        pigeonReturn.setLayoutUserTranscodingList(layoutUserTranscodingList);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(14);
      toListResult.add(serial);
      toListResult.add(taskId);
      toListResult.add(url);
      toListResult.add(serverRecordEnabled);
      toListResult.add(liveMode);
      toListResult.add(layoutWidth);
      toListResult.add(layoutHeight);
      toListResult.add(layoutBackgroundColor);
      toListResult.add(layoutImageUrl);
      toListResult.add(layoutImageX);
      toListResult.add(layoutImageY);
      toListResult.add(layoutImageWidth);
      toListResult.add(layoutImageHeight);
      toListResult.add(layoutUserTranscodingList);
      return toListResult;
    }

    static @NonNull AddOrUpdateLiveStreamTaskRequest fromList(@NonNull ArrayList<Object> list) {
      AddOrUpdateLiveStreamTaskRequest pigeonResult = new AddOrUpdateLiveStreamTaskRequest();
      Object serial = list.get(0);
      pigeonResult.setSerial(
          (serial == null)
              ? null
              : ((serial instanceof Integer) ? (Integer) serial : (Long) serial));
      Object taskId = list.get(1);
      pigeonResult.setTaskId((String) taskId);
      Object url = list.get(2);
      pigeonResult.setUrl((String) url);
      Object serverRecordEnabled = list.get(3);
      pigeonResult.setServerRecordEnabled((Boolean) serverRecordEnabled);
      Object liveMode = list.get(4);
      pigeonResult.setLiveMode(
          (liveMode == null)
              ? null
              : ((liveMode instanceof Integer) ? (Integer) liveMode : (Long) liveMode));
      Object layoutWidth = list.get(5);
      pigeonResult.setLayoutWidth(
          (layoutWidth == null)
              ? null
              : ((layoutWidth instanceof Integer) ? (Integer) layoutWidth : (Long) layoutWidth));
      Object layoutHeight = list.get(6);
      pigeonResult.setLayoutHeight(
          (layoutHeight == null)
              ? null
              : ((layoutHeight instanceof Integer) ? (Integer) layoutHeight : (Long) layoutHeight));
      Object layoutBackgroundColor = list.get(7);
      pigeonResult.setLayoutBackgroundColor(
          (layoutBackgroundColor == null)
              ? null
              : ((layoutBackgroundColor instanceof Integer)
                  ? (Integer) layoutBackgroundColor
                  : (Long) layoutBackgroundColor));
      Object layoutImageUrl = list.get(8);
      pigeonResult.setLayoutImageUrl((String) layoutImageUrl);
      Object layoutImageX = list.get(9);
      pigeonResult.setLayoutImageX(
          (layoutImageX == null)
              ? null
              : ((layoutImageX instanceof Integer) ? (Integer) layoutImageX : (Long) layoutImageX));
      Object layoutImageY = list.get(10);
      pigeonResult.setLayoutImageY(
          (layoutImageY == null)
              ? null
              : ((layoutImageY instanceof Integer) ? (Integer) layoutImageY : (Long) layoutImageY));
      Object layoutImageWidth = list.get(11);
      pigeonResult.setLayoutImageWidth(
          (layoutImageWidth == null)
              ? null
              : ((layoutImageWidth instanceof Integer)
                  ? (Integer) layoutImageWidth
                  : (Long) layoutImageWidth));
      Object layoutImageHeight = list.get(12);
      pigeonResult.setLayoutImageHeight(
          (layoutImageHeight == null)
              ? null
              : ((layoutImageHeight instanceof Integer)
                  ? (Integer) layoutImageHeight
                  : (Long) layoutImageHeight));
      Object layoutUserTranscodingList = list.get(13);
      pigeonResult.setLayoutUserTranscodingList((List<Object>) layoutUserTranscodingList);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class DeleteLiveStreamTaskRequest {
    private @Nullable Long serial;

    public @Nullable Long getSerial() {
      return serial;
    }

    public void setSerial(@Nullable Long setterArg) {
      this.serial = setterArg;
    }

    private @Nullable String taskId;

    public @Nullable String getTaskId() {
      return taskId;
    }

    public void setTaskId(@Nullable String setterArg) {
      this.taskId = setterArg;
    }

    public static final class Builder {

      private @Nullable Long serial;

      public @NonNull Builder setSerial(@Nullable Long setterArg) {
        this.serial = setterArg;
        return this;
      }

      private @Nullable String taskId;

      public @NonNull Builder setTaskId(@Nullable String setterArg) {
        this.taskId = setterArg;
        return this;
      }

      public @NonNull DeleteLiveStreamTaskRequest build() {
        DeleteLiveStreamTaskRequest pigeonReturn = new DeleteLiveStreamTaskRequest();
        pigeonReturn.setSerial(serial);
        pigeonReturn.setTaskId(taskId);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(serial);
      toListResult.add(taskId);
      return toListResult;
    }

    static @NonNull DeleteLiveStreamTaskRequest fromList(@NonNull ArrayList<Object> list) {
      DeleteLiveStreamTaskRequest pigeonResult = new DeleteLiveStreamTaskRequest();
      Object serial = list.get(0);
      pigeonResult.setSerial(
          (serial == null)
              ? null
              : ((serial instanceof Integer) ? (Integer) serial : (Long) serial));
      Object taskId = list.get(1);
      pigeonResult.setTaskId((String) taskId);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SendSEIMsgRequest {
    private @Nullable String seiMsg;

    public @Nullable String getSeiMsg() {
      return seiMsg;
    }

    public void setSeiMsg(@Nullable String setterArg) {
      this.seiMsg = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    public static final class Builder {

      private @Nullable String seiMsg;

      public @NonNull Builder setSeiMsg(@Nullable String setterArg) {
        this.seiMsg = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull SendSEIMsgRequest build() {
        SendSEIMsgRequest pigeonReturn = new SendSEIMsgRequest();
        pigeonReturn.setSeiMsg(seiMsg);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(seiMsg);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull SendSEIMsgRequest fromList(@NonNull ArrayList<Object> list) {
      SendSEIMsgRequest pigeonResult = new SendSEIMsgRequest();
      Object seiMsg = list.get(0);
      pigeonResult.setSeiMsg((String) seiMsg);
      Object streamType = list.get(1);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetLocalVoiceEqualizationRequest {
    private @Nullable Long bandFrequency;

    public @Nullable Long getBandFrequency() {
      return bandFrequency;
    }

    public void setBandFrequency(@Nullable Long setterArg) {
      this.bandFrequency = setterArg;
    }

    private @Nullable Long bandGain;

    public @Nullable Long getBandGain() {
      return bandGain;
    }

    public void setBandGain(@Nullable Long setterArg) {
      this.bandGain = setterArg;
    }

    public static final class Builder {

      private @Nullable Long bandFrequency;

      public @NonNull Builder setBandFrequency(@Nullable Long setterArg) {
        this.bandFrequency = setterArg;
        return this;
      }

      private @Nullable Long bandGain;

      public @NonNull Builder setBandGain(@Nullable Long setterArg) {
        this.bandGain = setterArg;
        return this;
      }

      public @NonNull SetLocalVoiceEqualizationRequest build() {
        SetLocalVoiceEqualizationRequest pigeonReturn = new SetLocalVoiceEqualizationRequest();
        pigeonReturn.setBandFrequency(bandFrequency);
        pigeonReturn.setBandGain(bandGain);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(bandFrequency);
      toListResult.add(bandGain);
      return toListResult;
    }

    static @NonNull SetLocalVoiceEqualizationRequest fromList(@NonNull ArrayList<Object> list) {
      SetLocalVoiceEqualizationRequest pigeonResult = new SetLocalVoiceEqualizationRequest();
      Object bandFrequency = list.get(0);
      pigeonResult.setBandFrequency(
          (bandFrequency == null)
              ? null
              : ((bandFrequency instanceof Integer)
                  ? (Integer) bandFrequency
                  : (Long) bandFrequency));
      Object bandGain = list.get(1);
      pigeonResult.setBandGain(
          (bandGain == null)
              ? null
              : ((bandGain instanceof Integer) ? (Integer) bandGain : (Long) bandGain));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SwitchChannelRequest {
    private @Nullable String token;

    public @Nullable String getToken() {
      return token;
    }

    public void setToken(@Nullable String setterArg) {
      this.token = setterArg;
    }

    private @Nullable String channelName;

    public @Nullable String getChannelName() {
      return channelName;
    }

    public void setChannelName(@Nullable String setterArg) {
      this.channelName = setterArg;
    }

    private @Nullable JoinChannelOptions channelOptions;

    public @Nullable JoinChannelOptions getChannelOptions() {
      return channelOptions;
    }

    public void setChannelOptions(@Nullable JoinChannelOptions setterArg) {
      this.channelOptions = setterArg;
    }

    public static final class Builder {

      private @Nullable String token;

      public @NonNull Builder setToken(@Nullable String setterArg) {
        this.token = setterArg;
        return this;
      }

      private @Nullable String channelName;

      public @NonNull Builder setChannelName(@Nullable String setterArg) {
        this.channelName = setterArg;
        return this;
      }

      private @Nullable JoinChannelOptions channelOptions;

      public @NonNull Builder setChannelOptions(@Nullable JoinChannelOptions setterArg) {
        this.channelOptions = setterArg;
        return this;
      }

      public @NonNull SwitchChannelRequest build() {
        SwitchChannelRequest pigeonReturn = new SwitchChannelRequest();
        pigeonReturn.setToken(token);
        pigeonReturn.setChannelName(channelName);
        pigeonReturn.setChannelOptions(channelOptions);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(token);
      toListResult.add(channelName);
      toListResult.add((channelOptions == null) ? null : channelOptions.toList());
      return toListResult;
    }

    static @NonNull SwitchChannelRequest fromList(@NonNull ArrayList<Object> list) {
      SwitchChannelRequest pigeonResult = new SwitchChannelRequest();
      Object token = list.get(0);
      pigeonResult.setToken((String) token);
      Object channelName = list.get(1);
      pigeonResult.setChannelName((String) channelName);
      Object channelOptions = list.get(2);
      pigeonResult.setChannelOptions(
          (channelOptions == null)
              ? null
              : JoinChannelOptions.fromList((ArrayList<Object>) channelOptions));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartAudioRecordingRequest {
    private @Nullable String filePath;

    public @Nullable String getFilePath() {
      return filePath;
    }

    public void setFilePath(@Nullable String setterArg) {
      this.filePath = setterArg;
    }

    private @Nullable Long sampleRate;

    public @Nullable Long getSampleRate() {
      return sampleRate;
    }

    public void setSampleRate(@Nullable Long setterArg) {
      this.sampleRate = setterArg;
    }

    private @Nullable Long quality;

    public @Nullable Long getQuality() {
      return quality;
    }

    public void setQuality(@Nullable Long setterArg) {
      this.quality = setterArg;
    }

    public static final class Builder {

      private @Nullable String filePath;

      public @NonNull Builder setFilePath(@Nullable String setterArg) {
        this.filePath = setterArg;
        return this;
      }

      private @Nullable Long sampleRate;

      public @NonNull Builder setSampleRate(@Nullable Long setterArg) {
        this.sampleRate = setterArg;
        return this;
      }

      private @Nullable Long quality;

      public @NonNull Builder setQuality(@Nullable Long setterArg) {
        this.quality = setterArg;
        return this;
      }

      public @NonNull StartAudioRecordingRequest build() {
        StartAudioRecordingRequest pigeonReturn = new StartAudioRecordingRequest();
        pigeonReturn.setFilePath(filePath);
        pigeonReturn.setSampleRate(sampleRate);
        pigeonReturn.setQuality(quality);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(filePath);
      toListResult.add(sampleRate);
      toListResult.add(quality);
      return toListResult;
    }

    static @NonNull StartAudioRecordingRequest fromList(@NonNull ArrayList<Object> list) {
      StartAudioRecordingRequest pigeonResult = new StartAudioRecordingRequest();
      Object filePath = list.get(0);
      pigeonResult.setFilePath((String) filePath);
      Object sampleRate = list.get(1);
      pigeonResult.setSampleRate(
          (sampleRate == null)
              ? null
              : ((sampleRate instanceof Integer) ? (Integer) sampleRate : (Long) sampleRate));
      Object quality = list.get(2);
      pigeonResult.setQuality(
          (quality == null)
              ? null
              : ((quality instanceof Integer) ? (Integer) quality : (Long) quality));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class AudioRecordingConfigurationRequest {
    private @Nullable String filePath;

    public @Nullable String getFilePath() {
      return filePath;
    }

    public void setFilePath(@Nullable String setterArg) {
      this.filePath = setterArg;
    }

    private @Nullable Long sampleRate;

    public @Nullable Long getSampleRate() {
      return sampleRate;
    }

    public void setSampleRate(@Nullable Long setterArg) {
      this.sampleRate = setterArg;
    }

    private @Nullable Long quality;

    public @Nullable Long getQuality() {
      return quality;
    }

    public void setQuality(@Nullable Long setterArg) {
      this.quality = setterArg;
    }

    private @Nullable Long position;

    public @Nullable Long getPosition() {
      return position;
    }

    public void setPosition(@Nullable Long setterArg) {
      this.position = setterArg;
    }

    private @Nullable Long cycleTime;

    public @Nullable Long getCycleTime() {
      return cycleTime;
    }

    public void setCycleTime(@Nullable Long setterArg) {
      this.cycleTime = setterArg;
    }

    public static final class Builder {

      private @Nullable String filePath;

      public @NonNull Builder setFilePath(@Nullable String setterArg) {
        this.filePath = setterArg;
        return this;
      }

      private @Nullable Long sampleRate;

      public @NonNull Builder setSampleRate(@Nullable Long setterArg) {
        this.sampleRate = setterArg;
        return this;
      }

      private @Nullable Long quality;

      public @NonNull Builder setQuality(@Nullable Long setterArg) {
        this.quality = setterArg;
        return this;
      }

      private @Nullable Long position;

      public @NonNull Builder setPosition(@Nullable Long setterArg) {
        this.position = setterArg;
        return this;
      }

      private @Nullable Long cycleTime;

      public @NonNull Builder setCycleTime(@Nullable Long setterArg) {
        this.cycleTime = setterArg;
        return this;
      }

      public @NonNull AudioRecordingConfigurationRequest build() {
        AudioRecordingConfigurationRequest pigeonReturn = new AudioRecordingConfigurationRequest();
        pigeonReturn.setFilePath(filePath);
        pigeonReturn.setSampleRate(sampleRate);
        pigeonReturn.setQuality(quality);
        pigeonReturn.setPosition(position);
        pigeonReturn.setCycleTime(cycleTime);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(5);
      toListResult.add(filePath);
      toListResult.add(sampleRate);
      toListResult.add(quality);
      toListResult.add(position);
      toListResult.add(cycleTime);
      return toListResult;
    }

    static @NonNull AudioRecordingConfigurationRequest fromList(@NonNull ArrayList<Object> list) {
      AudioRecordingConfigurationRequest pigeonResult = new AudioRecordingConfigurationRequest();
      Object filePath = list.get(0);
      pigeonResult.setFilePath((String) filePath);
      Object sampleRate = list.get(1);
      pigeonResult.setSampleRate(
          (sampleRate == null)
              ? null
              : ((sampleRate instanceof Integer) ? (Integer) sampleRate : (Long) sampleRate));
      Object quality = list.get(2);
      pigeonResult.setQuality(
          (quality == null)
              ? null
              : ((quality instanceof Integer) ? (Integer) quality : (Long) quality));
      Object position = list.get(3);
      pigeonResult.setPosition(
          (position == null)
              ? null
              : ((position instanceof Integer) ? (Integer) position : (Long) position));
      Object cycleTime = list.get(4);
      pigeonResult.setCycleTime(
          (cycleTime == null)
              ? null
              : ((cycleTime instanceof Integer) ? (Integer) cycleTime : (Long) cycleTime));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetLocalMediaPriorityRequest {
    private @Nullable Long priority;

    public @Nullable Long getPriority() {
      return priority;
    }

    public void setPriority(@Nullable Long setterArg) {
      this.priority = setterArg;
    }

    private @Nullable Boolean isPreemptive;

    public @Nullable Boolean getIsPreemptive() {
      return isPreemptive;
    }

    public void setIsPreemptive(@Nullable Boolean setterArg) {
      this.isPreemptive = setterArg;
    }

    public static final class Builder {

      private @Nullable Long priority;

      public @NonNull Builder setPriority(@Nullable Long setterArg) {
        this.priority = setterArg;
        return this;
      }

      private @Nullable Boolean isPreemptive;

      public @NonNull Builder setIsPreemptive(@Nullable Boolean setterArg) {
        this.isPreemptive = setterArg;
        return this;
      }

      public @NonNull SetLocalMediaPriorityRequest build() {
        SetLocalMediaPriorityRequest pigeonReturn = new SetLocalMediaPriorityRequest();
        pigeonReturn.setPriority(priority);
        pigeonReturn.setIsPreemptive(isPreemptive);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(priority);
      toListResult.add(isPreemptive);
      return toListResult;
    }

    static @NonNull SetLocalMediaPriorityRequest fromList(@NonNull ArrayList<Object> list) {
      SetLocalMediaPriorityRequest pigeonResult = new SetLocalMediaPriorityRequest();
      Object priority = list.get(0);
      pigeonResult.setPriority(
          (priority == null)
              ? null
              : ((priority instanceof Integer) ? (Integer) priority : (Long) priority));
      Object isPreemptive = list.get(1);
      pigeonResult.setIsPreemptive((Boolean) isPreemptive);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartOrUpdateChannelMediaRelayRequest {
    private @Nullable Map<Object, Object> sourceMediaInfo;

    public @Nullable Map<Object, Object> getSourceMediaInfo() {
      return sourceMediaInfo;
    }

    public void setSourceMediaInfo(@Nullable Map<Object, Object> setterArg) {
      this.sourceMediaInfo = setterArg;
    }

    private @Nullable Map<Object, Map<Object, Object>> destMediaInfo;

    public @Nullable Map<Object, Map<Object, Object>> getDestMediaInfo() {
      return destMediaInfo;
    }

    public void setDestMediaInfo(@Nullable Map<Object, Map<Object, Object>> setterArg) {
      this.destMediaInfo = setterArg;
    }

    public static final class Builder {

      private @Nullable Map<Object, Object> sourceMediaInfo;

      public @NonNull Builder setSourceMediaInfo(@Nullable Map<Object, Object> setterArg) {
        this.sourceMediaInfo = setterArg;
        return this;
      }

      private @Nullable Map<Object, Map<Object, Object>> destMediaInfo;

      public @NonNull Builder setDestMediaInfo(
          @Nullable Map<Object, Map<Object, Object>> setterArg) {
        this.destMediaInfo = setterArg;
        return this;
      }

      public @NonNull StartOrUpdateChannelMediaRelayRequest build() {
        StartOrUpdateChannelMediaRelayRequest pigeonReturn =
            new StartOrUpdateChannelMediaRelayRequest();
        pigeonReturn.setSourceMediaInfo(sourceMediaInfo);
        pigeonReturn.setDestMediaInfo(destMediaInfo);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(sourceMediaInfo);
      toListResult.add(destMediaInfo);
      return toListResult;
    }

    static @NonNull StartOrUpdateChannelMediaRelayRequest fromList(
        @NonNull ArrayList<Object> list) {
      StartOrUpdateChannelMediaRelayRequest pigeonResult =
          new StartOrUpdateChannelMediaRelayRequest();
      Object sourceMediaInfo = list.get(0);
      pigeonResult.setSourceMediaInfo((Map<Object, Object>) sourceMediaInfo);
      Object destMediaInfo = list.get(1);
      pigeonResult.setDestMediaInfo((Map<Object, Map<Object, Object>>) destMediaInfo);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class AdjustUserPlaybackSignalVolumeRequest {
    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    private @Nullable Long volume;

    public @Nullable Long getVolume() {
      return volume;
    }

    public void setVolume(@Nullable Long setterArg) {
      this.volume = setterArg;
    }

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long volume;

      public @NonNull Builder setVolume(@Nullable Long setterArg) {
        this.volume = setterArg;
        return this;
      }

      public @NonNull AdjustUserPlaybackSignalVolumeRequest build() {
        AdjustUserPlaybackSignalVolumeRequest pigeonReturn =
            new AdjustUserPlaybackSignalVolumeRequest();
        pigeonReturn.setUid(uid);
        pigeonReturn.setVolume(volume);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(uid);
      toListResult.add(volume);
      return toListResult;
    }

    static @NonNull AdjustUserPlaybackSignalVolumeRequest fromList(
        @NonNull ArrayList<Object> list) {
      AdjustUserPlaybackSignalVolumeRequest pigeonResult =
          new AdjustUserPlaybackSignalVolumeRequest();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object volume = list.get(1);
      pigeonResult.setVolume(
          (volume == null)
              ? null
              : ((volume instanceof Integer) ? (Integer) volume : (Long) volume));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class EnableEncryptionRequest {
    private @Nullable String key;

    public @Nullable String getKey() {
      return key;
    }

    public void setKey(@Nullable String setterArg) {
      this.key = setterArg;
    }

    private @Nullable Long mode;

    public @Nullable Long getMode() {
      return mode;
    }

    public void setMode(@Nullable Long setterArg) {
      this.mode = setterArg;
    }

    private @Nullable Boolean enable;

    public @Nullable Boolean getEnable() {
      return enable;
    }

    public void setEnable(@Nullable Boolean setterArg) {
      this.enable = setterArg;
    }

    public static final class Builder {

      private @Nullable String key;

      public @NonNull Builder setKey(@Nullable String setterArg) {
        this.key = setterArg;
        return this;
      }

      private @Nullable Long mode;

      public @NonNull Builder setMode(@Nullable Long setterArg) {
        this.mode = setterArg;
        return this;
      }

      private @Nullable Boolean enable;

      public @NonNull Builder setEnable(@Nullable Boolean setterArg) {
        this.enable = setterArg;
        return this;
      }

      public @NonNull EnableEncryptionRequest build() {
        EnableEncryptionRequest pigeonReturn = new EnableEncryptionRequest();
        pigeonReturn.setKey(key);
        pigeonReturn.setMode(mode);
        pigeonReturn.setEnable(enable);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(key);
      toListResult.add(mode);
      toListResult.add(enable);
      return toListResult;
    }

    static @NonNull EnableEncryptionRequest fromList(@NonNull ArrayList<Object> list) {
      EnableEncryptionRequest pigeonResult = new EnableEncryptionRequest();
      Object key = list.get(0);
      pigeonResult.setKey((String) key);
      Object mode = list.get(1);
      pigeonResult.setMode(
          (mode == null) ? null : ((mode instanceof Integer) ? (Integer) mode : (Long) mode));
      Object enable = list.get(2);
      pigeonResult.setEnable((Boolean) enable);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetLocalVoiceReverbParamRequest {
    private @Nullable Double wetGain;

    public @Nullable Double getWetGain() {
      return wetGain;
    }

    public void setWetGain(@Nullable Double setterArg) {
      this.wetGain = setterArg;
    }

    private @Nullable Double dryGain;

    public @Nullable Double getDryGain() {
      return dryGain;
    }

    public void setDryGain(@Nullable Double setterArg) {
      this.dryGain = setterArg;
    }

    private @Nullable Double damping;

    public @Nullable Double getDamping() {
      return damping;
    }

    public void setDamping(@Nullable Double setterArg) {
      this.damping = setterArg;
    }

    private @Nullable Double roomSize;

    public @Nullable Double getRoomSize() {
      return roomSize;
    }

    public void setRoomSize(@Nullable Double setterArg) {
      this.roomSize = setterArg;
    }

    private @Nullable Double decayTime;

    public @Nullable Double getDecayTime() {
      return decayTime;
    }

    public void setDecayTime(@Nullable Double setterArg) {
      this.decayTime = setterArg;
    }

    private @Nullable Double preDelay;

    public @Nullable Double getPreDelay() {
      return preDelay;
    }

    public void setPreDelay(@Nullable Double setterArg) {
      this.preDelay = setterArg;
    }

    public static final class Builder {

      private @Nullable Double wetGain;

      public @NonNull Builder setWetGain(@Nullable Double setterArg) {
        this.wetGain = setterArg;
        return this;
      }

      private @Nullable Double dryGain;

      public @NonNull Builder setDryGain(@Nullable Double setterArg) {
        this.dryGain = setterArg;
        return this;
      }

      private @Nullable Double damping;

      public @NonNull Builder setDamping(@Nullable Double setterArg) {
        this.damping = setterArg;
        return this;
      }

      private @Nullable Double roomSize;

      public @NonNull Builder setRoomSize(@Nullable Double setterArg) {
        this.roomSize = setterArg;
        return this;
      }

      private @Nullable Double decayTime;

      public @NonNull Builder setDecayTime(@Nullable Double setterArg) {
        this.decayTime = setterArg;
        return this;
      }

      private @Nullable Double preDelay;

      public @NonNull Builder setPreDelay(@Nullable Double setterArg) {
        this.preDelay = setterArg;
        return this;
      }

      public @NonNull SetLocalVoiceReverbParamRequest build() {
        SetLocalVoiceReverbParamRequest pigeonReturn = new SetLocalVoiceReverbParamRequest();
        pigeonReturn.setWetGain(wetGain);
        pigeonReturn.setDryGain(dryGain);
        pigeonReturn.setDamping(damping);
        pigeonReturn.setRoomSize(roomSize);
        pigeonReturn.setDecayTime(decayTime);
        pigeonReturn.setPreDelay(preDelay);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(6);
      toListResult.add(wetGain);
      toListResult.add(dryGain);
      toListResult.add(damping);
      toListResult.add(roomSize);
      toListResult.add(decayTime);
      toListResult.add(preDelay);
      return toListResult;
    }

    static @NonNull SetLocalVoiceReverbParamRequest fromList(@NonNull ArrayList<Object> list) {
      SetLocalVoiceReverbParamRequest pigeonResult = new SetLocalVoiceReverbParamRequest();
      Object wetGain = list.get(0);
      pigeonResult.setWetGain((Double) wetGain);
      Object dryGain = list.get(1);
      pigeonResult.setDryGain((Double) dryGain);
      Object damping = list.get(2);
      pigeonResult.setDamping((Double) damping);
      Object roomSize = list.get(3);
      pigeonResult.setRoomSize((Double) roomSize);
      Object decayTime = list.get(4);
      pigeonResult.setDecayTime((Double) decayTime);
      Object preDelay = list.get(5);
      pigeonResult.setPreDelay((Double) preDelay);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class ReportCustomEventRequest {
    private @Nullable String eventName;

    public @Nullable String getEventName() {
      return eventName;
    }

    public void setEventName(@Nullable String setterArg) {
      this.eventName = setterArg;
    }

    private @Nullable String customIdentify;

    public @Nullable String getCustomIdentify() {
      return customIdentify;
    }

    public void setCustomIdentify(@Nullable String setterArg) {
      this.customIdentify = setterArg;
    }

    private @Nullable Map<String, Object> param;

    public @Nullable Map<String, Object> getParam() {
      return param;
    }

    public void setParam(@Nullable Map<String, Object> setterArg) {
      this.param = setterArg;
    }

    public static final class Builder {

      private @Nullable String eventName;

      public @NonNull Builder setEventName(@Nullable String setterArg) {
        this.eventName = setterArg;
        return this;
      }

      private @Nullable String customIdentify;

      public @NonNull Builder setCustomIdentify(@Nullable String setterArg) {
        this.customIdentify = setterArg;
        return this;
      }

      private @Nullable Map<String, Object> param;

      public @NonNull Builder setParam(@Nullable Map<String, Object> setterArg) {
        this.param = setterArg;
        return this;
      }

      public @NonNull ReportCustomEventRequest build() {
        ReportCustomEventRequest pigeonReturn = new ReportCustomEventRequest();
        pigeonReturn.setEventName(eventName);
        pigeonReturn.setCustomIdentify(customIdentify);
        pigeonReturn.setParam(param);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(eventName);
      toListResult.add(customIdentify);
      toListResult.add(param);
      return toListResult;
    }

    static @NonNull ReportCustomEventRequest fromList(@NonNull ArrayList<Object> list) {
      ReportCustomEventRequest pigeonResult = new ReportCustomEventRequest();
      Object eventName = list.get(0);
      pigeonResult.setEventName((String) eventName);
      Object customIdentify = list.get(1);
      pigeonResult.setCustomIdentify((String) customIdentify);
      Object param = list.get(2);
      pigeonResult.setParam((Map<String, Object>) param);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartLastmileProbeTestRequest {
    private @Nullable Boolean probeUplink;

    public @Nullable Boolean getProbeUplink() {
      return probeUplink;
    }

    public void setProbeUplink(@Nullable Boolean setterArg) {
      this.probeUplink = setterArg;
    }

    private @Nullable Boolean probeDownlink;

    public @Nullable Boolean getProbeDownlink() {
      return probeDownlink;
    }

    public void setProbeDownlink(@Nullable Boolean setterArg) {
      this.probeDownlink = setterArg;
    }

    private @Nullable Long expectedUplinkBitrate;

    public @Nullable Long getExpectedUplinkBitrate() {
      return expectedUplinkBitrate;
    }

    public void setExpectedUplinkBitrate(@Nullable Long setterArg) {
      this.expectedUplinkBitrate = setterArg;
    }

    private @Nullable Long expectedDownlinkBitrate;

    public @Nullable Long getExpectedDownlinkBitrate() {
      return expectedDownlinkBitrate;
    }

    public void setExpectedDownlinkBitrate(@Nullable Long setterArg) {
      this.expectedDownlinkBitrate = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean probeUplink;

      public @NonNull Builder setProbeUplink(@Nullable Boolean setterArg) {
        this.probeUplink = setterArg;
        return this;
      }

      private @Nullable Boolean probeDownlink;

      public @NonNull Builder setProbeDownlink(@Nullable Boolean setterArg) {
        this.probeDownlink = setterArg;
        return this;
      }

      private @Nullable Long expectedUplinkBitrate;

      public @NonNull Builder setExpectedUplinkBitrate(@Nullable Long setterArg) {
        this.expectedUplinkBitrate = setterArg;
        return this;
      }

      private @Nullable Long expectedDownlinkBitrate;

      public @NonNull Builder setExpectedDownlinkBitrate(@Nullable Long setterArg) {
        this.expectedDownlinkBitrate = setterArg;
        return this;
      }

      public @NonNull StartLastmileProbeTestRequest build() {
        StartLastmileProbeTestRequest pigeonReturn = new StartLastmileProbeTestRequest();
        pigeonReturn.setProbeUplink(probeUplink);
        pigeonReturn.setProbeDownlink(probeDownlink);
        pigeonReturn.setExpectedUplinkBitrate(expectedUplinkBitrate);
        pigeonReturn.setExpectedDownlinkBitrate(expectedDownlinkBitrate);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(probeUplink);
      toListResult.add(probeDownlink);
      toListResult.add(expectedUplinkBitrate);
      toListResult.add(expectedDownlinkBitrate);
      return toListResult;
    }

    static @NonNull StartLastmileProbeTestRequest fromList(@NonNull ArrayList<Object> list) {
      StartLastmileProbeTestRequest pigeonResult = new StartLastmileProbeTestRequest();
      Object probeUplink = list.get(0);
      pigeonResult.setProbeUplink((Boolean) probeUplink);
      Object probeDownlink = list.get(1);
      pigeonResult.setProbeDownlink((Boolean) probeDownlink);
      Object expectedUplinkBitrate = list.get(2);
      pigeonResult.setExpectedUplinkBitrate(
          (expectedUplinkBitrate == null)
              ? null
              : ((expectedUplinkBitrate instanceof Integer)
                  ? (Integer) expectedUplinkBitrate
                  : (Long) expectedUplinkBitrate));
      Object expectedDownlinkBitrate = list.get(3);
      pigeonResult.setExpectedDownlinkBitrate(
          (expectedDownlinkBitrate == null)
              ? null
              : ((expectedDownlinkBitrate instanceof Integer)
                  ? (Integer) expectedDownlinkBitrate
                  : (Long) expectedDownlinkBitrate));
      return pigeonResult;
    }
  }

  /**
   * 顶点坐标
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class CGPoint {
    /** x 的 取值范围是 &#91; 0-1 &#93; */
    private @NonNull Double x;

    public @NonNull Double getX() {
      return x;
    }

    public void setX(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"x\" is null.");
      }
      this.x = setterArg;
    }

    /** y 的 取值范围是 &#91; 0-1 &#93; */
    private @NonNull Double y;

    public @NonNull Double getY() {
      return y;
    }

    public void setY(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"y\" is null.");
      }
      this.y = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    CGPoint() {}

    public static final class Builder {

      private @Nullable Double x;

      public @NonNull Builder setX(@NonNull Double setterArg) {
        this.x = setterArg;
        return this;
      }

      private @Nullable Double y;

      public @NonNull Builder setY(@NonNull Double setterArg) {
        this.y = setterArg;
        return this;
      }

      public @NonNull CGPoint build() {
        CGPoint pigeonReturn = new CGPoint();
        pigeonReturn.setX(x);
        pigeonReturn.setY(y);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(x);
      toListResult.add(y);
      return toListResult;
    }

    static @NonNull CGPoint fromList(@NonNull ArrayList<Object> list) {
      CGPoint pigeonResult = new CGPoint();
      Object x = list.get(0);
      pigeonResult.setX((Double) x);
      Object y = list.get(1);
      pigeonResult.setY((Double) y);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetVideoCorrectionConfigRequest {
    private @Nullable CGPoint topLeft;

    public @Nullable CGPoint getTopLeft() {
      return topLeft;
    }

    public void setTopLeft(@Nullable CGPoint setterArg) {
      this.topLeft = setterArg;
    }

    private @Nullable CGPoint topRight;

    public @Nullable CGPoint getTopRight() {
      return topRight;
    }

    public void setTopRight(@Nullable CGPoint setterArg) {
      this.topRight = setterArg;
    }

    private @Nullable CGPoint bottomLeft;

    public @Nullable CGPoint getBottomLeft() {
      return bottomLeft;
    }

    public void setBottomLeft(@Nullable CGPoint setterArg) {
      this.bottomLeft = setterArg;
    }

    private @Nullable CGPoint bottomRight;

    public @Nullable CGPoint getBottomRight() {
      return bottomRight;
    }

    public void setBottomRight(@Nullable CGPoint setterArg) {
      this.bottomRight = setterArg;
    }

    private @Nullable Double canvasWidth;

    public @Nullable Double getCanvasWidth() {
      return canvasWidth;
    }

    public void setCanvasWidth(@Nullable Double setterArg) {
      this.canvasWidth = setterArg;
    }

    private @Nullable Double canvasHeight;

    public @Nullable Double getCanvasHeight() {
      return canvasHeight;
    }

    public void setCanvasHeight(@Nullable Double setterArg) {
      this.canvasHeight = setterArg;
    }

    private @Nullable Boolean enableMirror;

    public @Nullable Boolean getEnableMirror() {
      return enableMirror;
    }

    public void setEnableMirror(@Nullable Boolean setterArg) {
      this.enableMirror = setterArg;
    }

    public static final class Builder {

      private @Nullable CGPoint topLeft;

      public @NonNull Builder setTopLeft(@Nullable CGPoint setterArg) {
        this.topLeft = setterArg;
        return this;
      }

      private @Nullable CGPoint topRight;

      public @NonNull Builder setTopRight(@Nullable CGPoint setterArg) {
        this.topRight = setterArg;
        return this;
      }

      private @Nullable CGPoint bottomLeft;

      public @NonNull Builder setBottomLeft(@Nullable CGPoint setterArg) {
        this.bottomLeft = setterArg;
        return this;
      }

      private @Nullable CGPoint bottomRight;

      public @NonNull Builder setBottomRight(@Nullable CGPoint setterArg) {
        this.bottomRight = setterArg;
        return this;
      }

      private @Nullable Double canvasWidth;

      public @NonNull Builder setCanvasWidth(@Nullable Double setterArg) {
        this.canvasWidth = setterArg;
        return this;
      }

      private @Nullable Double canvasHeight;

      public @NonNull Builder setCanvasHeight(@Nullable Double setterArg) {
        this.canvasHeight = setterArg;
        return this;
      }

      private @Nullable Boolean enableMirror;

      public @NonNull Builder setEnableMirror(@Nullable Boolean setterArg) {
        this.enableMirror = setterArg;
        return this;
      }

      public @NonNull SetVideoCorrectionConfigRequest build() {
        SetVideoCorrectionConfigRequest pigeonReturn = new SetVideoCorrectionConfigRequest();
        pigeonReturn.setTopLeft(topLeft);
        pigeonReturn.setTopRight(topRight);
        pigeonReturn.setBottomLeft(bottomLeft);
        pigeonReturn.setBottomRight(bottomRight);
        pigeonReturn.setCanvasWidth(canvasWidth);
        pigeonReturn.setCanvasHeight(canvasHeight);
        pigeonReturn.setEnableMirror(enableMirror);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(7);
      toListResult.add((topLeft == null) ? null : topLeft.toList());
      toListResult.add((topRight == null) ? null : topRight.toList());
      toListResult.add((bottomLeft == null) ? null : bottomLeft.toList());
      toListResult.add((bottomRight == null) ? null : bottomRight.toList());
      toListResult.add(canvasWidth);
      toListResult.add(canvasHeight);
      toListResult.add(enableMirror);
      return toListResult;
    }

    static @NonNull SetVideoCorrectionConfigRequest fromList(@NonNull ArrayList<Object> list) {
      SetVideoCorrectionConfigRequest pigeonResult = new SetVideoCorrectionConfigRequest();
      Object topLeft = list.get(0);
      pigeonResult.setTopLeft(
          (topLeft == null) ? null : CGPoint.fromList((ArrayList<Object>) topLeft));
      Object topRight = list.get(1);
      pigeonResult.setTopRight(
          (topRight == null) ? null : CGPoint.fromList((ArrayList<Object>) topRight));
      Object bottomLeft = list.get(2);
      pigeonResult.setBottomLeft(
          (bottomLeft == null) ? null : CGPoint.fromList((ArrayList<Object>) bottomLeft));
      Object bottomRight = list.get(3);
      pigeonResult.setBottomRight(
          (bottomRight == null) ? null : CGPoint.fromList((ArrayList<Object>) bottomRight));
      Object canvasWidth = list.get(4);
      pigeonResult.setCanvasWidth((Double) canvasWidth);
      Object canvasHeight = list.get(5);
      pigeonResult.setCanvasHeight((Double) canvasHeight);
      Object enableMirror = list.get(6);
      pigeonResult.setEnableMirror((Boolean) enableMirror);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class EnableVirtualBackgroundRequest {
    private @Nullable Boolean enabled;

    public @Nullable Boolean getEnabled() {
      return enabled;
    }

    public void setEnabled(@Nullable Boolean setterArg) {
      this.enabled = setterArg;
    }

    private @Nullable Long backgroundSourceType;

    public @Nullable Long getBackgroundSourceType() {
      return backgroundSourceType;
    }

    public void setBackgroundSourceType(@Nullable Long setterArg) {
      this.backgroundSourceType = setterArg;
    }

    private @Nullable Long color;

    public @Nullable Long getColor() {
      return color;
    }

    public void setColor(@Nullable Long setterArg) {
      this.color = setterArg;
    }

    private @Nullable String source;

    public @Nullable String getSource() {
      return source;
    }

    public void setSource(@Nullable String setterArg) {
      this.source = setterArg;
    }

    private @Nullable Long blur_degree;

    public @Nullable Long getBlur_degree() {
      return blur_degree;
    }

    public void setBlur_degree(@Nullable Long setterArg) {
      this.blur_degree = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean enabled;

      public @NonNull Builder setEnabled(@Nullable Boolean setterArg) {
        this.enabled = setterArg;
        return this;
      }

      private @Nullable Long backgroundSourceType;

      public @NonNull Builder setBackgroundSourceType(@Nullable Long setterArg) {
        this.backgroundSourceType = setterArg;
        return this;
      }

      private @Nullable Long color;

      public @NonNull Builder setColor(@Nullable Long setterArg) {
        this.color = setterArg;
        return this;
      }

      private @Nullable String source;

      public @NonNull Builder setSource(@Nullable String setterArg) {
        this.source = setterArg;
        return this;
      }

      private @Nullable Long blur_degree;

      public @NonNull Builder setBlur_degree(@Nullable Long setterArg) {
        this.blur_degree = setterArg;
        return this;
      }

      public @NonNull EnableVirtualBackgroundRequest build() {
        EnableVirtualBackgroundRequest pigeonReturn = new EnableVirtualBackgroundRequest();
        pigeonReturn.setEnabled(enabled);
        pigeonReturn.setBackgroundSourceType(backgroundSourceType);
        pigeonReturn.setColor(color);
        pigeonReturn.setSource(source);
        pigeonReturn.setBlur_degree(blur_degree);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(5);
      toListResult.add(enabled);
      toListResult.add(backgroundSourceType);
      toListResult.add(color);
      toListResult.add(source);
      toListResult.add(blur_degree);
      return toListResult;
    }

    static @NonNull EnableVirtualBackgroundRequest fromList(@NonNull ArrayList<Object> list) {
      EnableVirtualBackgroundRequest pigeonResult = new EnableVirtualBackgroundRequest();
      Object enabled = list.get(0);
      pigeonResult.setEnabled((Boolean) enabled);
      Object backgroundSourceType = list.get(1);
      pigeonResult.setBackgroundSourceType(
          (backgroundSourceType == null)
              ? null
              : ((backgroundSourceType instanceof Integer)
                  ? (Integer) backgroundSourceType
                  : (Long) backgroundSourceType));
      Object color = list.get(2);
      pigeonResult.setColor(
          (color == null) ? null : ((color instanceof Integer) ? (Integer) color : (Long) color));
      Object source = list.get(3);
      pigeonResult.setSource((String) source);
      Object blur_degree = list.get(4);
      pigeonResult.setBlur_degree(
          (blur_degree == null)
              ? null
              : ((blur_degree instanceof Integer) ? (Integer) blur_degree : (Long) blur_degree));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetRemoteHighPriorityAudioStreamRequest {
    private @Nullable Boolean enabled;

    public @Nullable Boolean getEnabled() {
      return enabled;
    }

    public void setEnabled(@Nullable Boolean setterArg) {
      this.enabled = setterArg;
    }

    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    private @Nullable Long streamType;

    public @Nullable Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@Nullable Long setterArg) {
      this.streamType = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean enabled;

      public @NonNull Builder setEnabled(@Nullable Boolean setterArg) {
        this.enabled = setterArg;
        return this;
      }

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@Nullable Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      public @NonNull SetRemoteHighPriorityAudioStreamRequest build() {
        SetRemoteHighPriorityAudioStreamRequest pigeonReturn =
            new SetRemoteHighPriorityAudioStreamRequest();
        pigeonReturn.setEnabled(enabled);
        pigeonReturn.setUid(uid);
        pigeonReturn.setStreamType(streamType);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(enabled);
      toListResult.add(uid);
      toListResult.add(streamType);
      return toListResult;
    }

    static @NonNull SetRemoteHighPriorityAudioStreamRequest fromList(
        @NonNull ArrayList<Object> list) {
      SetRemoteHighPriorityAudioStreamRequest pigeonResult =
          new SetRemoteHighPriorityAudioStreamRequest();
      Object enabled = list.get(0);
      pigeonResult.setEnabled((Boolean) enabled);
      Object uid = list.get(1);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object streamType = list.get(2);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class VideoWatermarkImageConfig {
    private @Nullable Double wmAlpha;

    public @Nullable Double getWmAlpha() {
      return wmAlpha;
    }

    public void setWmAlpha(@Nullable Double setterArg) {
      this.wmAlpha = setterArg;
    }

    private @Nullable Long wmWidth;

    public @Nullable Long getWmWidth() {
      return wmWidth;
    }

    public void setWmWidth(@Nullable Long setterArg) {
      this.wmWidth = setterArg;
    }

    private @Nullable Long wmHeight;

    public @Nullable Long getWmHeight() {
      return wmHeight;
    }

    public void setWmHeight(@Nullable Long setterArg) {
      this.wmHeight = setterArg;
    }

    private @Nullable Long offsetX;

    public @Nullable Long getOffsetX() {
      return offsetX;
    }

    public void setOffsetX(@Nullable Long setterArg) {
      this.offsetX = setterArg;
    }

    private @Nullable Long offsetY;

    public @Nullable Long getOffsetY() {
      return offsetY;
    }

    public void setOffsetY(@Nullable Long setterArg) {
      this.offsetY = setterArg;
    }

    private @Nullable List<String> imagePaths;

    public @Nullable List<String> getImagePaths() {
      return imagePaths;
    }

    public void setImagePaths(@Nullable List<String> setterArg) {
      this.imagePaths = setterArg;
    }

    private @Nullable Long fps;

    public @Nullable Long getFps() {
      return fps;
    }

    public void setFps(@Nullable Long setterArg) {
      this.fps = setterArg;
    }

    private @Nullable Boolean loop;

    public @Nullable Boolean getLoop() {
      return loop;
    }

    public void setLoop(@Nullable Boolean setterArg) {
      this.loop = setterArg;
    }

    public static final class Builder {

      private @Nullable Double wmAlpha;

      public @NonNull Builder setWmAlpha(@Nullable Double setterArg) {
        this.wmAlpha = setterArg;
        return this;
      }

      private @Nullable Long wmWidth;

      public @NonNull Builder setWmWidth(@Nullable Long setterArg) {
        this.wmWidth = setterArg;
        return this;
      }

      private @Nullable Long wmHeight;

      public @NonNull Builder setWmHeight(@Nullable Long setterArg) {
        this.wmHeight = setterArg;
        return this;
      }

      private @Nullable Long offsetX;

      public @NonNull Builder setOffsetX(@Nullable Long setterArg) {
        this.offsetX = setterArg;
        return this;
      }

      private @Nullable Long offsetY;

      public @NonNull Builder setOffsetY(@Nullable Long setterArg) {
        this.offsetY = setterArg;
        return this;
      }

      private @Nullable List<String> imagePaths;

      public @NonNull Builder setImagePaths(@Nullable List<String> setterArg) {
        this.imagePaths = setterArg;
        return this;
      }

      private @Nullable Long fps;

      public @NonNull Builder setFps(@Nullable Long setterArg) {
        this.fps = setterArg;
        return this;
      }

      private @Nullable Boolean loop;

      public @NonNull Builder setLoop(@Nullable Boolean setterArg) {
        this.loop = setterArg;
        return this;
      }

      public @NonNull VideoWatermarkImageConfig build() {
        VideoWatermarkImageConfig pigeonReturn = new VideoWatermarkImageConfig();
        pigeonReturn.setWmAlpha(wmAlpha);
        pigeonReturn.setWmWidth(wmWidth);
        pigeonReturn.setWmHeight(wmHeight);
        pigeonReturn.setOffsetX(offsetX);
        pigeonReturn.setOffsetY(offsetY);
        pigeonReturn.setImagePaths(imagePaths);
        pigeonReturn.setFps(fps);
        pigeonReturn.setLoop(loop);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(8);
      toListResult.add(wmAlpha);
      toListResult.add(wmWidth);
      toListResult.add(wmHeight);
      toListResult.add(offsetX);
      toListResult.add(offsetY);
      toListResult.add(imagePaths);
      toListResult.add(fps);
      toListResult.add(loop);
      return toListResult;
    }

    static @NonNull VideoWatermarkImageConfig fromList(@NonNull ArrayList<Object> list) {
      VideoWatermarkImageConfig pigeonResult = new VideoWatermarkImageConfig();
      Object wmAlpha = list.get(0);
      pigeonResult.setWmAlpha((Double) wmAlpha);
      Object wmWidth = list.get(1);
      pigeonResult.setWmWidth(
          (wmWidth == null)
              ? null
              : ((wmWidth instanceof Integer) ? (Integer) wmWidth : (Long) wmWidth));
      Object wmHeight = list.get(2);
      pigeonResult.setWmHeight(
          (wmHeight == null)
              ? null
              : ((wmHeight instanceof Integer) ? (Integer) wmHeight : (Long) wmHeight));
      Object offsetX = list.get(3);
      pigeonResult.setOffsetX(
          (offsetX == null)
              ? null
              : ((offsetX instanceof Integer) ? (Integer) offsetX : (Long) offsetX));
      Object offsetY = list.get(4);
      pigeonResult.setOffsetY(
          (offsetY == null)
              ? null
              : ((offsetY instanceof Integer) ? (Integer) offsetY : (Long) offsetY));
      Object imagePaths = list.get(5);
      pigeonResult.setImagePaths((List<String>) imagePaths);
      Object fps = list.get(6);
      pigeonResult.setFps(
          (fps == null) ? null : ((fps instanceof Integer) ? (Integer) fps : (Long) fps));
      Object loop = list.get(7);
      pigeonResult.setLoop((Boolean) loop);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class VideoWatermarkTextConfig {
    private @Nullable Double wmAlpha;

    public @Nullable Double getWmAlpha() {
      return wmAlpha;
    }

    public void setWmAlpha(@Nullable Double setterArg) {
      this.wmAlpha = setterArg;
    }

    private @Nullable Long wmWidth;

    public @Nullable Long getWmWidth() {
      return wmWidth;
    }

    public void setWmWidth(@Nullable Long setterArg) {
      this.wmWidth = setterArg;
    }

    private @Nullable Long wmHeight;

    public @Nullable Long getWmHeight() {
      return wmHeight;
    }

    public void setWmHeight(@Nullable Long setterArg) {
      this.wmHeight = setterArg;
    }

    private @Nullable Long offsetX;

    public @Nullable Long getOffsetX() {
      return offsetX;
    }

    public void setOffsetX(@Nullable Long setterArg) {
      this.offsetX = setterArg;
    }

    private @Nullable Long offsetY;

    public @Nullable Long getOffsetY() {
      return offsetY;
    }

    public void setOffsetY(@Nullable Long setterArg) {
      this.offsetY = setterArg;
    }

    private @Nullable Long wmColor;

    public @Nullable Long getWmColor() {
      return wmColor;
    }

    public void setWmColor(@Nullable Long setterArg) {
      this.wmColor = setterArg;
    }

    private @Nullable Long fontSize;

    public @Nullable Long getFontSize() {
      return fontSize;
    }

    public void setFontSize(@Nullable Long setterArg) {
      this.fontSize = setterArg;
    }

    private @Nullable Long fontColor;

    public @Nullable Long getFontColor() {
      return fontColor;
    }

    public void setFontColor(@Nullable Long setterArg) {
      this.fontColor = setterArg;
    }

    private @Nullable String fontNameOrPath;

    public @Nullable String getFontNameOrPath() {
      return fontNameOrPath;
    }

    public void setFontNameOrPath(@Nullable String setterArg) {
      this.fontNameOrPath = setterArg;
    }

    private @Nullable String content;

    public @Nullable String getContent() {
      return content;
    }

    public void setContent(@Nullable String setterArg) {
      this.content = setterArg;
    }

    public static final class Builder {

      private @Nullable Double wmAlpha;

      public @NonNull Builder setWmAlpha(@Nullable Double setterArg) {
        this.wmAlpha = setterArg;
        return this;
      }

      private @Nullable Long wmWidth;

      public @NonNull Builder setWmWidth(@Nullable Long setterArg) {
        this.wmWidth = setterArg;
        return this;
      }

      private @Nullable Long wmHeight;

      public @NonNull Builder setWmHeight(@Nullable Long setterArg) {
        this.wmHeight = setterArg;
        return this;
      }

      private @Nullable Long offsetX;

      public @NonNull Builder setOffsetX(@Nullable Long setterArg) {
        this.offsetX = setterArg;
        return this;
      }

      private @Nullable Long offsetY;

      public @NonNull Builder setOffsetY(@Nullable Long setterArg) {
        this.offsetY = setterArg;
        return this;
      }

      private @Nullable Long wmColor;

      public @NonNull Builder setWmColor(@Nullable Long setterArg) {
        this.wmColor = setterArg;
        return this;
      }

      private @Nullable Long fontSize;

      public @NonNull Builder setFontSize(@Nullable Long setterArg) {
        this.fontSize = setterArg;
        return this;
      }

      private @Nullable Long fontColor;

      public @NonNull Builder setFontColor(@Nullable Long setterArg) {
        this.fontColor = setterArg;
        return this;
      }

      private @Nullable String fontNameOrPath;

      public @NonNull Builder setFontNameOrPath(@Nullable String setterArg) {
        this.fontNameOrPath = setterArg;
        return this;
      }

      private @Nullable String content;

      public @NonNull Builder setContent(@Nullable String setterArg) {
        this.content = setterArg;
        return this;
      }

      public @NonNull VideoWatermarkTextConfig build() {
        VideoWatermarkTextConfig pigeonReturn = new VideoWatermarkTextConfig();
        pigeonReturn.setWmAlpha(wmAlpha);
        pigeonReturn.setWmWidth(wmWidth);
        pigeonReturn.setWmHeight(wmHeight);
        pigeonReturn.setOffsetX(offsetX);
        pigeonReturn.setOffsetY(offsetY);
        pigeonReturn.setWmColor(wmColor);
        pigeonReturn.setFontSize(fontSize);
        pigeonReturn.setFontColor(fontColor);
        pigeonReturn.setFontNameOrPath(fontNameOrPath);
        pigeonReturn.setContent(content);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(10);
      toListResult.add(wmAlpha);
      toListResult.add(wmWidth);
      toListResult.add(wmHeight);
      toListResult.add(offsetX);
      toListResult.add(offsetY);
      toListResult.add(wmColor);
      toListResult.add(fontSize);
      toListResult.add(fontColor);
      toListResult.add(fontNameOrPath);
      toListResult.add(content);
      return toListResult;
    }

    static @NonNull VideoWatermarkTextConfig fromList(@NonNull ArrayList<Object> list) {
      VideoWatermarkTextConfig pigeonResult = new VideoWatermarkTextConfig();
      Object wmAlpha = list.get(0);
      pigeonResult.setWmAlpha((Double) wmAlpha);
      Object wmWidth = list.get(1);
      pigeonResult.setWmWidth(
          (wmWidth == null)
              ? null
              : ((wmWidth instanceof Integer) ? (Integer) wmWidth : (Long) wmWidth));
      Object wmHeight = list.get(2);
      pigeonResult.setWmHeight(
          (wmHeight == null)
              ? null
              : ((wmHeight instanceof Integer) ? (Integer) wmHeight : (Long) wmHeight));
      Object offsetX = list.get(3);
      pigeonResult.setOffsetX(
          (offsetX == null)
              ? null
              : ((offsetX instanceof Integer) ? (Integer) offsetX : (Long) offsetX));
      Object offsetY = list.get(4);
      pigeonResult.setOffsetY(
          (offsetY == null)
              ? null
              : ((offsetY instanceof Integer) ? (Integer) offsetY : (Long) offsetY));
      Object wmColor = list.get(5);
      pigeonResult.setWmColor(
          (wmColor == null)
              ? null
              : ((wmColor instanceof Integer) ? (Integer) wmColor : (Long) wmColor));
      Object fontSize = list.get(6);
      pigeonResult.setFontSize(
          (fontSize == null)
              ? null
              : ((fontSize instanceof Integer) ? (Integer) fontSize : (Long) fontSize));
      Object fontColor = list.get(7);
      pigeonResult.setFontColor(
          (fontColor == null)
              ? null
              : ((fontColor instanceof Integer) ? (Integer) fontColor : (Long) fontColor));
      Object fontNameOrPath = list.get(8);
      pigeonResult.setFontNameOrPath((String) fontNameOrPath);
      Object content = list.get(9);
      pigeonResult.setContent((String) content);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class VideoWatermarkTimestampConfig {
    private @Nullable Double wmAlpha;

    public @Nullable Double getWmAlpha() {
      return wmAlpha;
    }

    public void setWmAlpha(@Nullable Double setterArg) {
      this.wmAlpha = setterArg;
    }

    private @Nullable Long wmWidth;

    public @Nullable Long getWmWidth() {
      return wmWidth;
    }

    public void setWmWidth(@Nullable Long setterArg) {
      this.wmWidth = setterArg;
    }

    private @Nullable Long wmHeight;

    public @Nullable Long getWmHeight() {
      return wmHeight;
    }

    public void setWmHeight(@Nullable Long setterArg) {
      this.wmHeight = setterArg;
    }

    private @Nullable Long offsetX;

    public @Nullable Long getOffsetX() {
      return offsetX;
    }

    public void setOffsetX(@Nullable Long setterArg) {
      this.offsetX = setterArg;
    }

    private @Nullable Long offsetY;

    public @Nullable Long getOffsetY() {
      return offsetY;
    }

    public void setOffsetY(@Nullable Long setterArg) {
      this.offsetY = setterArg;
    }

    private @Nullable Long wmColor;

    public @Nullable Long getWmColor() {
      return wmColor;
    }

    public void setWmColor(@Nullable Long setterArg) {
      this.wmColor = setterArg;
    }

    private @Nullable Long fontSize;

    public @Nullable Long getFontSize() {
      return fontSize;
    }

    public void setFontSize(@Nullable Long setterArg) {
      this.fontSize = setterArg;
    }

    private @Nullable Long fontColor;

    public @Nullable Long getFontColor() {
      return fontColor;
    }

    public void setFontColor(@Nullable Long setterArg) {
      this.fontColor = setterArg;
    }

    private @Nullable String fontNameOrPath;

    public @Nullable String getFontNameOrPath() {
      return fontNameOrPath;
    }

    public void setFontNameOrPath(@Nullable String setterArg) {
      this.fontNameOrPath = setterArg;
    }

    public static final class Builder {

      private @Nullable Double wmAlpha;

      public @NonNull Builder setWmAlpha(@Nullable Double setterArg) {
        this.wmAlpha = setterArg;
        return this;
      }

      private @Nullable Long wmWidth;

      public @NonNull Builder setWmWidth(@Nullable Long setterArg) {
        this.wmWidth = setterArg;
        return this;
      }

      private @Nullable Long wmHeight;

      public @NonNull Builder setWmHeight(@Nullable Long setterArg) {
        this.wmHeight = setterArg;
        return this;
      }

      private @Nullable Long offsetX;

      public @NonNull Builder setOffsetX(@Nullable Long setterArg) {
        this.offsetX = setterArg;
        return this;
      }

      private @Nullable Long offsetY;

      public @NonNull Builder setOffsetY(@Nullable Long setterArg) {
        this.offsetY = setterArg;
        return this;
      }

      private @Nullable Long wmColor;

      public @NonNull Builder setWmColor(@Nullable Long setterArg) {
        this.wmColor = setterArg;
        return this;
      }

      private @Nullable Long fontSize;

      public @NonNull Builder setFontSize(@Nullable Long setterArg) {
        this.fontSize = setterArg;
        return this;
      }

      private @Nullable Long fontColor;

      public @NonNull Builder setFontColor(@Nullable Long setterArg) {
        this.fontColor = setterArg;
        return this;
      }

      private @Nullable String fontNameOrPath;

      public @NonNull Builder setFontNameOrPath(@Nullable String setterArg) {
        this.fontNameOrPath = setterArg;
        return this;
      }

      public @NonNull VideoWatermarkTimestampConfig build() {
        VideoWatermarkTimestampConfig pigeonReturn = new VideoWatermarkTimestampConfig();
        pigeonReturn.setWmAlpha(wmAlpha);
        pigeonReturn.setWmWidth(wmWidth);
        pigeonReturn.setWmHeight(wmHeight);
        pigeonReturn.setOffsetX(offsetX);
        pigeonReturn.setOffsetY(offsetY);
        pigeonReturn.setWmColor(wmColor);
        pigeonReturn.setFontSize(fontSize);
        pigeonReturn.setFontColor(fontColor);
        pigeonReturn.setFontNameOrPath(fontNameOrPath);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(9);
      toListResult.add(wmAlpha);
      toListResult.add(wmWidth);
      toListResult.add(wmHeight);
      toListResult.add(offsetX);
      toListResult.add(offsetY);
      toListResult.add(wmColor);
      toListResult.add(fontSize);
      toListResult.add(fontColor);
      toListResult.add(fontNameOrPath);
      return toListResult;
    }

    static @NonNull VideoWatermarkTimestampConfig fromList(@NonNull ArrayList<Object> list) {
      VideoWatermarkTimestampConfig pigeonResult = new VideoWatermarkTimestampConfig();
      Object wmAlpha = list.get(0);
      pigeonResult.setWmAlpha((Double) wmAlpha);
      Object wmWidth = list.get(1);
      pigeonResult.setWmWidth(
          (wmWidth == null)
              ? null
              : ((wmWidth instanceof Integer) ? (Integer) wmWidth : (Long) wmWidth));
      Object wmHeight = list.get(2);
      pigeonResult.setWmHeight(
          (wmHeight == null)
              ? null
              : ((wmHeight instanceof Integer) ? (Integer) wmHeight : (Long) wmHeight));
      Object offsetX = list.get(3);
      pigeonResult.setOffsetX(
          (offsetX == null)
              ? null
              : ((offsetX instanceof Integer) ? (Integer) offsetX : (Long) offsetX));
      Object offsetY = list.get(4);
      pigeonResult.setOffsetY(
          (offsetY == null)
              ? null
              : ((offsetY instanceof Integer) ? (Integer) offsetY : (Long) offsetY));
      Object wmColor = list.get(5);
      pigeonResult.setWmColor(
          (wmColor == null)
              ? null
              : ((wmColor instanceof Integer) ? (Integer) wmColor : (Long) wmColor));
      Object fontSize = list.get(6);
      pigeonResult.setFontSize(
          (fontSize == null)
              ? null
              : ((fontSize instanceof Integer) ? (Integer) fontSize : (Long) fontSize));
      Object fontColor = list.get(7);
      pigeonResult.setFontColor(
          (fontColor == null)
              ? null
              : ((fontColor instanceof Integer) ? (Integer) fontColor : (Long) fontColor));
      Object fontNameOrPath = list.get(8);
      pigeonResult.setFontNameOrPath((String) fontNameOrPath);
      return pigeonResult;
    }
  }

  /**
   * 视频水印设置，目前支持三种类型的水印，但只能其中选择一种水印生效
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class VideoWatermarkConfig {
    private @NonNull NERtcVideoWatermarkType WatermarkType;

    public @NonNull NERtcVideoWatermarkType getWatermarkType() {
      return WatermarkType;
    }

    public void setWatermarkType(@NonNull NERtcVideoWatermarkType setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"WatermarkType\" is null.");
      }
      this.WatermarkType = setterArg;
    }

    private @Nullable VideoWatermarkImageConfig imageWatermark;

    public @Nullable VideoWatermarkImageConfig getImageWatermark() {
      return imageWatermark;
    }

    public void setImageWatermark(@Nullable VideoWatermarkImageConfig setterArg) {
      this.imageWatermark = setterArg;
    }

    private @Nullable VideoWatermarkTextConfig textWatermark;

    public @Nullable VideoWatermarkTextConfig getTextWatermark() {
      return textWatermark;
    }

    public void setTextWatermark(@Nullable VideoWatermarkTextConfig setterArg) {
      this.textWatermark = setterArg;
    }

    private @Nullable VideoWatermarkTimestampConfig timestampWatermark;

    public @Nullable VideoWatermarkTimestampConfig getTimestampWatermark() {
      return timestampWatermark;
    }

    public void setTimestampWatermark(@Nullable VideoWatermarkTimestampConfig setterArg) {
      this.timestampWatermark = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    VideoWatermarkConfig() {}

    public static final class Builder {

      private @Nullable NERtcVideoWatermarkType WatermarkType;

      public @NonNull Builder setWatermarkType(@NonNull NERtcVideoWatermarkType setterArg) {
        this.WatermarkType = setterArg;
        return this;
      }

      private @Nullable VideoWatermarkImageConfig imageWatermark;

      public @NonNull Builder setImageWatermark(@Nullable VideoWatermarkImageConfig setterArg) {
        this.imageWatermark = setterArg;
        return this;
      }

      private @Nullable VideoWatermarkTextConfig textWatermark;

      public @NonNull Builder setTextWatermark(@Nullable VideoWatermarkTextConfig setterArg) {
        this.textWatermark = setterArg;
        return this;
      }

      private @Nullable VideoWatermarkTimestampConfig timestampWatermark;

      public @NonNull Builder setTimestampWatermark(
          @Nullable VideoWatermarkTimestampConfig setterArg) {
        this.timestampWatermark = setterArg;
        return this;
      }

      public @NonNull VideoWatermarkConfig build() {
        VideoWatermarkConfig pigeonReturn = new VideoWatermarkConfig();
        pigeonReturn.setWatermarkType(WatermarkType);
        pigeonReturn.setImageWatermark(imageWatermark);
        pigeonReturn.setTextWatermark(textWatermark);
        pigeonReturn.setTimestampWatermark(timestampWatermark);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(WatermarkType == null ? null : WatermarkType.index);
      toListResult.add((imageWatermark == null) ? null : imageWatermark.toList());
      toListResult.add((textWatermark == null) ? null : textWatermark.toList());
      toListResult.add((timestampWatermark == null) ? null : timestampWatermark.toList());
      return toListResult;
    }

    static @NonNull VideoWatermarkConfig fromList(@NonNull ArrayList<Object> list) {
      VideoWatermarkConfig pigeonResult = new VideoWatermarkConfig();
      Object WatermarkType = list.get(0);
      pigeonResult.setWatermarkType(
          WatermarkType == null ? null : NERtcVideoWatermarkType.values()[(int) WatermarkType]);
      Object imageWatermark = list.get(1);
      pigeonResult.setImageWatermark(
          (imageWatermark == null)
              ? null
              : VideoWatermarkImageConfig.fromList((ArrayList<Object>) imageWatermark));
      Object textWatermark = list.get(2);
      pigeonResult.setTextWatermark(
          (textWatermark == null)
              ? null
              : VideoWatermarkTextConfig.fromList((ArrayList<Object>) textWatermark));
      Object timestampWatermark = list.get(3);
      pigeonResult.setTimestampWatermark(
          (timestampWatermark == null)
              ? null
              : VideoWatermarkTimestampConfig.fromList((ArrayList<Object>) timestampWatermark));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetLocalVideoWatermarkConfigsRequest {
    private @NonNull Long type;

    public @NonNull Long getType() {
      return type;
    }

    public void setType(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"type\" is null.");
      }
      this.type = setterArg;
    }

    private @Nullable VideoWatermarkConfig config;

    public @Nullable VideoWatermarkConfig getConfig() {
      return config;
    }

    public void setConfig(@Nullable VideoWatermarkConfig setterArg) {
      this.config = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    SetLocalVideoWatermarkConfigsRequest() {}

    public static final class Builder {

      private @Nullable Long type;

      public @NonNull Builder setType(@NonNull Long setterArg) {
        this.type = setterArg;
        return this;
      }

      private @Nullable VideoWatermarkConfig config;

      public @NonNull Builder setConfig(@Nullable VideoWatermarkConfig setterArg) {
        this.config = setterArg;
        return this;
      }

      public @NonNull SetLocalVideoWatermarkConfigsRequest build() {
        SetLocalVideoWatermarkConfigsRequest pigeonReturn =
            new SetLocalVideoWatermarkConfigsRequest();
        pigeonReturn.setType(type);
        pigeonReturn.setConfig(config);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(type);
      toListResult.add((config == null) ? null : config.toList());
      return toListResult;
    }

    static @NonNull SetLocalVideoWatermarkConfigsRequest fromList(@NonNull ArrayList<Object> list) {
      SetLocalVideoWatermarkConfigsRequest pigeonResult =
          new SetLocalVideoWatermarkConfigsRequest();
      Object type = list.get(0);
      pigeonResult.setType(
          (type == null) ? null : ((type instanceof Integer) ? (Integer) type : (Long) type));
      Object config = list.get(1);
      pigeonResult.setConfig(
          (config == null) ? null : VideoWatermarkConfig.fromList((ArrayList<Object>) config));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class PositionInfo {
    private @NonNull List<Double> mSpeakerPosition;

    public @NonNull List<Double> getMSpeakerPosition() {
      return mSpeakerPosition;
    }

    public void setMSpeakerPosition(@NonNull List<Double> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"mSpeakerPosition\" is null.");
      }
      this.mSpeakerPosition = setterArg;
    }

    private @NonNull List<Double> mSpeakerQuaternion;

    public @NonNull List<Double> getMSpeakerQuaternion() {
      return mSpeakerQuaternion;
    }

    public void setMSpeakerQuaternion(@NonNull List<Double> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"mSpeakerQuaternion\" is null.");
      }
      this.mSpeakerQuaternion = setterArg;
    }

    private @NonNull List<Double> mHeadPosition;

    public @NonNull List<Double> getMHeadPosition() {
      return mHeadPosition;
    }

    public void setMHeadPosition(@NonNull List<Double> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"mHeadPosition\" is null.");
      }
      this.mHeadPosition = setterArg;
    }

    private @NonNull List<Double> mHeadQuaternion;

    public @NonNull List<Double> getMHeadQuaternion() {
      return mHeadQuaternion;
    }

    public void setMHeadQuaternion(@NonNull List<Double> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"mHeadQuaternion\" is null.");
      }
      this.mHeadQuaternion = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    PositionInfo() {}

    public static final class Builder {

      private @Nullable List<Double> mSpeakerPosition;

      public @NonNull Builder setMSpeakerPosition(@NonNull List<Double> setterArg) {
        this.mSpeakerPosition = setterArg;
        return this;
      }

      private @Nullable List<Double> mSpeakerQuaternion;

      public @NonNull Builder setMSpeakerQuaternion(@NonNull List<Double> setterArg) {
        this.mSpeakerQuaternion = setterArg;
        return this;
      }

      private @Nullable List<Double> mHeadPosition;

      public @NonNull Builder setMHeadPosition(@NonNull List<Double> setterArg) {
        this.mHeadPosition = setterArg;
        return this;
      }

      private @Nullable List<Double> mHeadQuaternion;

      public @NonNull Builder setMHeadQuaternion(@NonNull List<Double> setterArg) {
        this.mHeadQuaternion = setterArg;
        return this;
      }

      public @NonNull PositionInfo build() {
        PositionInfo pigeonReturn = new PositionInfo();
        pigeonReturn.setMSpeakerPosition(mSpeakerPosition);
        pigeonReturn.setMSpeakerQuaternion(mSpeakerQuaternion);
        pigeonReturn.setMHeadPosition(mHeadPosition);
        pigeonReturn.setMHeadQuaternion(mHeadQuaternion);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(mSpeakerPosition);
      toListResult.add(mSpeakerQuaternion);
      toListResult.add(mHeadPosition);
      toListResult.add(mHeadQuaternion);
      return toListResult;
    }

    static @NonNull PositionInfo fromList(@NonNull ArrayList<Object> list) {
      PositionInfo pigeonResult = new PositionInfo();
      Object mSpeakerPosition = list.get(0);
      pigeonResult.setMSpeakerPosition((List<Double>) mSpeakerPosition);
      Object mSpeakerQuaternion = list.get(1);
      pigeonResult.setMSpeakerQuaternion((List<Double>) mSpeakerQuaternion);
      Object mHeadPosition = list.get(2);
      pigeonResult.setMHeadPosition((List<Double>) mHeadPosition);
      Object mHeadQuaternion = list.get(3);
      pigeonResult.setMHeadQuaternion((List<Double>) mHeadQuaternion);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SpatializerRoomProperty {
    private @NonNull Long roomCapacity;

    public @NonNull Long getRoomCapacity() {
      return roomCapacity;
    }

    public void setRoomCapacity(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"roomCapacity\" is null.");
      }
      this.roomCapacity = setterArg;
    }

    private @NonNull Long material;

    public @NonNull Long getMaterial() {
      return material;
    }

    public void setMaterial(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"material\" is null.");
      }
      this.material = setterArg;
    }

    private @NonNull Double reflectionScalar;

    public @NonNull Double getReflectionScalar() {
      return reflectionScalar;
    }

    public void setReflectionScalar(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"reflectionScalar\" is null.");
      }
      this.reflectionScalar = setterArg;
    }

    private @NonNull Double reverbGain;

    public @NonNull Double getReverbGain() {
      return reverbGain;
    }

    public void setReverbGain(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"reverbGain\" is null.");
      }
      this.reverbGain = setterArg;
    }

    private @NonNull Double reverbTime;

    public @NonNull Double getReverbTime() {
      return reverbTime;
    }

    public void setReverbTime(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"reverbTime\" is null.");
      }
      this.reverbTime = setterArg;
    }

    private @NonNull Double reverbBrightness;

    public @NonNull Double getReverbBrightness() {
      return reverbBrightness;
    }

    public void setReverbBrightness(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"reverbBrightness\" is null.");
      }
      this.reverbBrightness = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    SpatializerRoomProperty() {}

    public static final class Builder {

      private @Nullable Long roomCapacity;

      public @NonNull Builder setRoomCapacity(@NonNull Long setterArg) {
        this.roomCapacity = setterArg;
        return this;
      }

      private @Nullable Long material;

      public @NonNull Builder setMaterial(@NonNull Long setterArg) {
        this.material = setterArg;
        return this;
      }

      private @Nullable Double reflectionScalar;

      public @NonNull Builder setReflectionScalar(@NonNull Double setterArg) {
        this.reflectionScalar = setterArg;
        return this;
      }

      private @Nullable Double reverbGain;

      public @NonNull Builder setReverbGain(@NonNull Double setterArg) {
        this.reverbGain = setterArg;
        return this;
      }

      private @Nullable Double reverbTime;

      public @NonNull Builder setReverbTime(@NonNull Double setterArg) {
        this.reverbTime = setterArg;
        return this;
      }

      private @Nullable Double reverbBrightness;

      public @NonNull Builder setReverbBrightness(@NonNull Double setterArg) {
        this.reverbBrightness = setterArg;
        return this;
      }

      public @NonNull SpatializerRoomProperty build() {
        SpatializerRoomProperty pigeonReturn = new SpatializerRoomProperty();
        pigeonReturn.setRoomCapacity(roomCapacity);
        pigeonReturn.setMaterial(material);
        pigeonReturn.setReflectionScalar(reflectionScalar);
        pigeonReturn.setReverbGain(reverbGain);
        pigeonReturn.setReverbTime(reverbTime);
        pigeonReturn.setReverbBrightness(reverbBrightness);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(6);
      toListResult.add(roomCapacity);
      toListResult.add(material);
      toListResult.add(reflectionScalar);
      toListResult.add(reverbGain);
      toListResult.add(reverbTime);
      toListResult.add(reverbBrightness);
      return toListResult;
    }

    static @NonNull SpatializerRoomProperty fromList(@NonNull ArrayList<Object> list) {
      SpatializerRoomProperty pigeonResult = new SpatializerRoomProperty();
      Object roomCapacity = list.get(0);
      pigeonResult.setRoomCapacity(
          (roomCapacity == null)
              ? null
              : ((roomCapacity instanceof Integer) ? (Integer) roomCapacity : (Long) roomCapacity));
      Object material = list.get(1);
      pigeonResult.setMaterial(
          (material == null)
              ? null
              : ((material instanceof Integer) ? (Integer) material : (Long) material));
      Object reflectionScalar = list.get(2);
      pigeonResult.setReflectionScalar((Double) reflectionScalar);
      Object reverbGain = list.get(3);
      pigeonResult.setReverbGain((Double) reverbGain);
      Object reverbTime = list.get(4);
      pigeonResult.setReverbTime((Double) reverbTime);
      Object reverbBrightness = list.get(5);
      pigeonResult.setReverbBrightness((Double) reverbBrightness);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class LocalRecordingConfig {
    private @NonNull String filePath;

    public @NonNull String getFilePath() {
      return filePath;
    }

    public void setFilePath(@NonNull String setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"filePath\" is null.");
      }
      this.filePath = setterArg;
    }

    private @NonNull String fileName;

    public @NonNull String getFileName() {
      return fileName;
    }

    public void setFileName(@NonNull String setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"fileName\" is null.");
      }
      this.fileName = setterArg;
    }

    private @NonNull Long width;

    public @NonNull Long getWidth() {
      return width;
    }

    public void setWidth(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"width\" is null.");
      }
      this.width = setterArg;
    }

    private @NonNull Long height;

    public @NonNull Long getHeight() {
      return height;
    }

    public void setHeight(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"height\" is null.");
      }
      this.height = setterArg;
    }

    private @NonNull Long framerate;

    public @NonNull Long getFramerate() {
      return framerate;
    }

    public void setFramerate(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"framerate\" is null.");
      }
      this.framerate = setterArg;
    }

    private @NonNull Long recordFileType;

    public @NonNull Long getRecordFileType() {
      return recordFileType;
    }

    public void setRecordFileType(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"recordFileType\" is null.");
      }
      this.recordFileType = setterArg;
    }

    private @NonNull Boolean remuxToMp4;

    public @NonNull Boolean getRemuxToMp4() {
      return remuxToMp4;
    }

    public void setRemuxToMp4(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"remuxToMp4\" is null.");
      }
      this.remuxToMp4 = setterArg;
    }

    private @NonNull Boolean videoMerge;

    public @NonNull Boolean getVideoMerge() {
      return videoMerge;
    }

    public void setVideoMerge(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"videoMerge\" is null.");
      }
      this.videoMerge = setterArg;
    }

    private @NonNull Boolean recordAudio;

    public @NonNull Boolean getRecordAudio() {
      return recordAudio;
    }

    public void setRecordAudio(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"recordAudio\" is null.");
      }
      this.recordAudio = setterArg;
    }

    private @NonNull Long audioFormat;

    public @NonNull Long getAudioFormat() {
      return audioFormat;
    }

    public void setAudioFormat(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"audioFormat\" is null.");
      }
      this.audioFormat = setterArg;
    }

    private @NonNull Boolean recordVideo;

    public @NonNull Boolean getRecordVideo() {
      return recordVideo;
    }

    public void setRecordVideo(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"recordVideo\" is null.");
      }
      this.recordVideo = setterArg;
    }

    private @NonNull Long videoRecordMode;

    public @NonNull Long getVideoRecordMode() {
      return videoRecordMode;
    }

    public void setVideoRecordMode(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"videoRecordMode\" is null.");
      }
      this.videoRecordMode = setterArg;
    }

    private @Nullable List<VideoWatermarkConfig> watermarkList;

    public @Nullable List<VideoWatermarkConfig> getWatermarkList() {
      return watermarkList;
    }

    public void setWatermarkList(@Nullable List<VideoWatermarkConfig> setterArg) {
      this.watermarkList = setterArg;
    }

    private @Nullable String coverFilePath;

    public @Nullable String getCoverFilePath() {
      return coverFilePath;
    }

    public void setCoverFilePath(@Nullable String setterArg) {
      this.coverFilePath = setterArg;
    }

    private @Nullable List<VideoWatermarkConfig> coverWatermarkList;

    public @Nullable List<VideoWatermarkConfig> getCoverWatermarkList() {
      return coverWatermarkList;
    }

    public void setCoverWatermarkList(@Nullable List<VideoWatermarkConfig> setterArg) {
      this.coverWatermarkList = setterArg;
    }

    private @Nullable String defaultCoverFilePath;

    public @Nullable String getDefaultCoverFilePath() {
      return defaultCoverFilePath;
    }

    public void setDefaultCoverFilePath(@Nullable String setterArg) {
      this.defaultCoverFilePath = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    LocalRecordingConfig() {}

    public static final class Builder {

      private @Nullable String filePath;

      public @NonNull Builder setFilePath(@NonNull String setterArg) {
        this.filePath = setterArg;
        return this;
      }

      private @Nullable String fileName;

      public @NonNull Builder setFileName(@NonNull String setterArg) {
        this.fileName = setterArg;
        return this;
      }

      private @Nullable Long width;

      public @NonNull Builder setWidth(@NonNull Long setterArg) {
        this.width = setterArg;
        return this;
      }

      private @Nullable Long height;

      public @NonNull Builder setHeight(@NonNull Long setterArg) {
        this.height = setterArg;
        return this;
      }

      private @Nullable Long framerate;

      public @NonNull Builder setFramerate(@NonNull Long setterArg) {
        this.framerate = setterArg;
        return this;
      }

      private @Nullable Long recordFileType;

      public @NonNull Builder setRecordFileType(@NonNull Long setterArg) {
        this.recordFileType = setterArg;
        return this;
      }

      private @Nullable Boolean remuxToMp4;

      public @NonNull Builder setRemuxToMp4(@NonNull Boolean setterArg) {
        this.remuxToMp4 = setterArg;
        return this;
      }

      private @Nullable Boolean videoMerge;

      public @NonNull Builder setVideoMerge(@NonNull Boolean setterArg) {
        this.videoMerge = setterArg;
        return this;
      }

      private @Nullable Boolean recordAudio;

      public @NonNull Builder setRecordAudio(@NonNull Boolean setterArg) {
        this.recordAudio = setterArg;
        return this;
      }

      private @Nullable Long audioFormat;

      public @NonNull Builder setAudioFormat(@NonNull Long setterArg) {
        this.audioFormat = setterArg;
        return this;
      }

      private @Nullable Boolean recordVideo;

      public @NonNull Builder setRecordVideo(@NonNull Boolean setterArg) {
        this.recordVideo = setterArg;
        return this;
      }

      private @Nullable Long videoRecordMode;

      public @NonNull Builder setVideoRecordMode(@NonNull Long setterArg) {
        this.videoRecordMode = setterArg;
        return this;
      }

      private @Nullable List<VideoWatermarkConfig> watermarkList;

      public @NonNull Builder setWatermarkList(@Nullable List<VideoWatermarkConfig> setterArg) {
        this.watermarkList = setterArg;
        return this;
      }

      private @Nullable String coverFilePath;

      public @NonNull Builder setCoverFilePath(@Nullable String setterArg) {
        this.coverFilePath = setterArg;
        return this;
      }

      private @Nullable List<VideoWatermarkConfig> coverWatermarkList;

      public @NonNull Builder setCoverWatermarkList(
          @Nullable List<VideoWatermarkConfig> setterArg) {
        this.coverWatermarkList = setterArg;
        return this;
      }

      private @Nullable String defaultCoverFilePath;

      public @NonNull Builder setDefaultCoverFilePath(@Nullable String setterArg) {
        this.defaultCoverFilePath = setterArg;
        return this;
      }

      public @NonNull LocalRecordingConfig build() {
        LocalRecordingConfig pigeonReturn = new LocalRecordingConfig();
        pigeonReturn.setFilePath(filePath);
        pigeonReturn.setFileName(fileName);
        pigeonReturn.setWidth(width);
        pigeonReturn.setHeight(height);
        pigeonReturn.setFramerate(framerate);
        pigeonReturn.setRecordFileType(recordFileType);
        pigeonReturn.setRemuxToMp4(remuxToMp4);
        pigeonReturn.setVideoMerge(videoMerge);
        pigeonReturn.setRecordAudio(recordAudio);
        pigeonReturn.setAudioFormat(audioFormat);
        pigeonReturn.setRecordVideo(recordVideo);
        pigeonReturn.setVideoRecordMode(videoRecordMode);
        pigeonReturn.setWatermarkList(watermarkList);
        pigeonReturn.setCoverFilePath(coverFilePath);
        pigeonReturn.setCoverWatermarkList(coverWatermarkList);
        pigeonReturn.setDefaultCoverFilePath(defaultCoverFilePath);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(16);
      toListResult.add(filePath);
      toListResult.add(fileName);
      toListResult.add(width);
      toListResult.add(height);
      toListResult.add(framerate);
      toListResult.add(recordFileType);
      toListResult.add(remuxToMp4);
      toListResult.add(videoMerge);
      toListResult.add(recordAudio);
      toListResult.add(audioFormat);
      toListResult.add(recordVideo);
      toListResult.add(videoRecordMode);
      toListResult.add(watermarkList);
      toListResult.add(coverFilePath);
      toListResult.add(coverWatermarkList);
      toListResult.add(defaultCoverFilePath);
      return toListResult;
    }

    static @NonNull LocalRecordingConfig fromList(@NonNull ArrayList<Object> list) {
      LocalRecordingConfig pigeonResult = new LocalRecordingConfig();
      Object filePath = list.get(0);
      pigeonResult.setFilePath((String) filePath);
      Object fileName = list.get(1);
      pigeonResult.setFileName((String) fileName);
      Object width = list.get(2);
      pigeonResult.setWidth(
          (width == null) ? null : ((width instanceof Integer) ? (Integer) width : (Long) width));
      Object height = list.get(3);
      pigeonResult.setHeight(
          (height == null)
              ? null
              : ((height instanceof Integer) ? (Integer) height : (Long) height));
      Object framerate = list.get(4);
      pigeonResult.setFramerate(
          (framerate == null)
              ? null
              : ((framerate instanceof Integer) ? (Integer) framerate : (Long) framerate));
      Object recordFileType = list.get(5);
      pigeonResult.setRecordFileType(
          (recordFileType == null)
              ? null
              : ((recordFileType instanceof Integer)
                  ? (Integer) recordFileType
                  : (Long) recordFileType));
      Object remuxToMp4 = list.get(6);
      pigeonResult.setRemuxToMp4((Boolean) remuxToMp4);
      Object videoMerge = list.get(7);
      pigeonResult.setVideoMerge((Boolean) videoMerge);
      Object recordAudio = list.get(8);
      pigeonResult.setRecordAudio((Boolean) recordAudio);
      Object audioFormat = list.get(9);
      pigeonResult.setAudioFormat(
          (audioFormat == null)
              ? null
              : ((audioFormat instanceof Integer) ? (Integer) audioFormat : (Long) audioFormat));
      Object recordVideo = list.get(10);
      pigeonResult.setRecordVideo((Boolean) recordVideo);
      Object videoRecordMode = list.get(11);
      pigeonResult.setVideoRecordMode(
          (videoRecordMode == null)
              ? null
              : ((videoRecordMode instanceof Integer)
                  ? (Integer) videoRecordMode
                  : (Long) videoRecordMode));
      Object watermarkList = list.get(12);
      pigeonResult.setWatermarkList((List<VideoWatermarkConfig>) watermarkList);
      Object coverFilePath = list.get(13);
      pigeonResult.setCoverFilePath((String) coverFilePath);
      Object coverWatermarkList = list.get(14);
      pigeonResult.setCoverWatermarkList((List<VideoWatermarkConfig>) coverWatermarkList);
      Object defaultCoverFilePath = list.get(15);
      pigeonResult.setDefaultCoverFilePath((String) defaultCoverFilePath);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class LocalRecordingLayoutConfig {
    private @NonNull Long offsetX;

    public @NonNull Long getOffsetX() {
      return offsetX;
    }

    public void setOffsetX(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"offsetX\" is null.");
      }
      this.offsetX = setterArg;
    }

    private @NonNull Long offsetY;

    public @NonNull Long getOffsetY() {
      return offsetY;
    }

    public void setOffsetY(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"offsetY\" is null.");
      }
      this.offsetY = setterArg;
    }

    private @NonNull Long width;

    public @NonNull Long getWidth() {
      return width;
    }

    public void setWidth(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"width\" is null.");
      }
      this.width = setterArg;
    }

    private @NonNull Long height;

    public @NonNull Long getHeight() {
      return height;
    }

    public void setHeight(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"height\" is null.");
      }
      this.height = setterArg;
    }

    private @NonNull Long scalingMode;

    public @NonNull Long getScalingMode() {
      return scalingMode;
    }

    public void setScalingMode(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"scalingMode\" is null.");
      }
      this.scalingMode = setterArg;
    }

    private @Nullable List<VideoWatermarkConfig> watermarkList;

    public @Nullable List<VideoWatermarkConfig> getWatermarkList() {
      return watermarkList;
    }

    public void setWatermarkList(@Nullable List<VideoWatermarkConfig> setterArg) {
      this.watermarkList = setterArg;
    }

    private @NonNull Boolean isScreenShare;

    public @NonNull Boolean getIsScreenShare() {
      return isScreenShare;
    }

    public void setIsScreenShare(@NonNull Boolean setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"isScreenShare\" is null.");
      }
      this.isScreenShare = setterArg;
    }

    private @NonNull Long bgColor;

    public @NonNull Long getBgColor() {
      return bgColor;
    }

    public void setBgColor(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"bgColor\" is null.");
      }
      this.bgColor = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    LocalRecordingLayoutConfig() {}

    public static final class Builder {

      private @Nullable Long offsetX;

      public @NonNull Builder setOffsetX(@NonNull Long setterArg) {
        this.offsetX = setterArg;
        return this;
      }

      private @Nullable Long offsetY;

      public @NonNull Builder setOffsetY(@NonNull Long setterArg) {
        this.offsetY = setterArg;
        return this;
      }

      private @Nullable Long width;

      public @NonNull Builder setWidth(@NonNull Long setterArg) {
        this.width = setterArg;
        return this;
      }

      private @Nullable Long height;

      public @NonNull Builder setHeight(@NonNull Long setterArg) {
        this.height = setterArg;
        return this;
      }

      private @Nullable Long scalingMode;

      public @NonNull Builder setScalingMode(@NonNull Long setterArg) {
        this.scalingMode = setterArg;
        return this;
      }

      private @Nullable List<VideoWatermarkConfig> watermarkList;

      public @NonNull Builder setWatermarkList(@Nullable List<VideoWatermarkConfig> setterArg) {
        this.watermarkList = setterArg;
        return this;
      }

      private @Nullable Boolean isScreenShare;

      public @NonNull Builder setIsScreenShare(@NonNull Boolean setterArg) {
        this.isScreenShare = setterArg;
        return this;
      }

      private @Nullable Long bgColor;

      public @NonNull Builder setBgColor(@NonNull Long setterArg) {
        this.bgColor = setterArg;
        return this;
      }

      public @NonNull LocalRecordingLayoutConfig build() {
        LocalRecordingLayoutConfig pigeonReturn = new LocalRecordingLayoutConfig();
        pigeonReturn.setOffsetX(offsetX);
        pigeonReturn.setOffsetY(offsetY);
        pigeonReturn.setWidth(width);
        pigeonReturn.setHeight(height);
        pigeonReturn.setScalingMode(scalingMode);
        pigeonReturn.setWatermarkList(watermarkList);
        pigeonReturn.setIsScreenShare(isScreenShare);
        pigeonReturn.setBgColor(bgColor);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(8);
      toListResult.add(offsetX);
      toListResult.add(offsetY);
      toListResult.add(width);
      toListResult.add(height);
      toListResult.add(scalingMode);
      toListResult.add(watermarkList);
      toListResult.add(isScreenShare);
      toListResult.add(bgColor);
      return toListResult;
    }

    static @NonNull LocalRecordingLayoutConfig fromList(@NonNull ArrayList<Object> list) {
      LocalRecordingLayoutConfig pigeonResult = new LocalRecordingLayoutConfig();
      Object offsetX = list.get(0);
      pigeonResult.setOffsetX(
          (offsetX == null)
              ? null
              : ((offsetX instanceof Integer) ? (Integer) offsetX : (Long) offsetX));
      Object offsetY = list.get(1);
      pigeonResult.setOffsetY(
          (offsetY == null)
              ? null
              : ((offsetY instanceof Integer) ? (Integer) offsetY : (Long) offsetY));
      Object width = list.get(2);
      pigeonResult.setWidth(
          (width == null) ? null : ((width instanceof Integer) ? (Integer) width : (Long) width));
      Object height = list.get(3);
      pigeonResult.setHeight(
          (height == null)
              ? null
              : ((height instanceof Integer) ? (Integer) height : (Long) height));
      Object scalingMode = list.get(4);
      pigeonResult.setScalingMode(
          (scalingMode == null)
              ? null
              : ((scalingMode instanceof Integer) ? (Integer) scalingMode : (Long) scalingMode));
      Object watermarkList = list.get(5);
      pigeonResult.setWatermarkList((List<VideoWatermarkConfig>) watermarkList);
      Object isScreenShare = list.get(6);
      pigeonResult.setIsScreenShare((Boolean) isScreenShare);
      Object bgColor = list.get(7);
      pigeonResult.setBgColor(
          (bgColor == null)
              ? null
              : ((bgColor instanceof Integer) ? (Integer) bgColor : (Long) bgColor));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class LocalRecordingStreamInfo {
    private @NonNull Long uid;

    public @NonNull Long getUid() {
      return uid;
    }

    public void setUid(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"uid\" is null.");
      }
      this.uid = setterArg;
    }

    private @NonNull Long streamType;

    public @NonNull Long getStreamType() {
      return streamType;
    }

    public void setStreamType(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"streamType\" is null.");
      }
      this.streamType = setterArg;
    }

    private @NonNull Long streamLayer;

    public @NonNull Long getStreamLayer() {
      return streamLayer;
    }

    public void setStreamLayer(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"streamLayer\" is null.");
      }
      this.streamLayer = setterArg;
    }

    private @NonNull LocalRecordingLayoutConfig layoutConfig;

    public @NonNull LocalRecordingLayoutConfig getLayoutConfig() {
      return layoutConfig;
    }

    public void setLayoutConfig(@NonNull LocalRecordingLayoutConfig setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"layoutConfig\" is null.");
      }
      this.layoutConfig = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    LocalRecordingStreamInfo() {}

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@NonNull Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable Long streamType;

      public @NonNull Builder setStreamType(@NonNull Long setterArg) {
        this.streamType = setterArg;
        return this;
      }

      private @Nullable Long streamLayer;

      public @NonNull Builder setStreamLayer(@NonNull Long setterArg) {
        this.streamLayer = setterArg;
        return this;
      }

      private @Nullable LocalRecordingLayoutConfig layoutConfig;

      public @NonNull Builder setLayoutConfig(@NonNull LocalRecordingLayoutConfig setterArg) {
        this.layoutConfig = setterArg;
        return this;
      }

      public @NonNull LocalRecordingStreamInfo build() {
        LocalRecordingStreamInfo pigeonReturn = new LocalRecordingStreamInfo();
        pigeonReturn.setUid(uid);
        pigeonReturn.setStreamType(streamType);
        pigeonReturn.setStreamLayer(streamLayer);
        pigeonReturn.setLayoutConfig(layoutConfig);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(uid);
      toListResult.add(streamType);
      toListResult.add(streamLayer);
      toListResult.add((layoutConfig == null) ? null : layoutConfig.toList());
      return toListResult;
    }

    static @NonNull LocalRecordingStreamInfo fromList(@NonNull ArrayList<Object> list) {
      LocalRecordingStreamInfo pigeonResult = new LocalRecordingStreamInfo();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object streamType = list.get(1);
      pigeonResult.setStreamType(
          (streamType == null)
              ? null
              : ((streamType instanceof Integer) ? (Integer) streamType : (Long) streamType));
      Object streamLayer = list.get(2);
      pigeonResult.setStreamLayer(
          (streamLayer == null)
              ? null
              : ((streamLayer instanceof Integer) ? (Integer) streamLayer : (Long) streamLayer));
      Object layoutConfig = list.get(3);
      pigeonResult.setLayoutConfig(
          (layoutConfig == null)
              ? null
              : LocalRecordingLayoutConfig.fromList((ArrayList<Object>) layoutConfig));
      return pigeonResult;
    }
  }

  /**
   * NERtc 版本信息
   *
   * <p>Generated class from Pigeon that represents data sent in messages.
   */
  public static final class NERtcVersion {
    private @Nullable String versionName;

    public @Nullable String getVersionName() {
      return versionName;
    }

    public void setVersionName(@Nullable String setterArg) {
      this.versionName = setterArg;
    }

    private @Nullable Long versionCode;

    public @Nullable Long getVersionCode() {
      return versionCode;
    }

    public void setVersionCode(@Nullable Long setterArg) {
      this.versionCode = setterArg;
    }

    private @Nullable String buildType;

    public @Nullable String getBuildType() {
      return buildType;
    }

    public void setBuildType(@Nullable String setterArg) {
      this.buildType = setterArg;
    }

    private @Nullable String buildDate;

    public @Nullable String getBuildDate() {
      return buildDate;
    }

    public void setBuildDate(@Nullable String setterArg) {
      this.buildDate = setterArg;
    }

    private @Nullable String buildRevision;

    public @Nullable String getBuildRevision() {
      return buildRevision;
    }

    public void setBuildRevision(@Nullable String setterArg) {
      this.buildRevision = setterArg;
    }

    private @Nullable String buildHost;

    public @Nullable String getBuildHost() {
      return buildHost;
    }

    public void setBuildHost(@Nullable String setterArg) {
      this.buildHost = setterArg;
    }

    private @Nullable String serverEnv;

    public @Nullable String getServerEnv() {
      return serverEnv;
    }

    public void setServerEnv(@Nullable String setterArg) {
      this.serverEnv = setterArg;
    }

    private @Nullable String buildBranch;

    public @Nullable String getBuildBranch() {
      return buildBranch;
    }

    public void setBuildBranch(@Nullable String setterArg) {
      this.buildBranch = setterArg;
    }

    private @Nullable String engineRevision;

    public @Nullable String getEngineRevision() {
      return engineRevision;
    }

    public void setEngineRevision(@Nullable String setterArg) {
      this.engineRevision = setterArg;
    }

    public static final class Builder {

      private @Nullable String versionName;

      public @NonNull Builder setVersionName(@Nullable String setterArg) {
        this.versionName = setterArg;
        return this;
      }

      private @Nullable Long versionCode;

      public @NonNull Builder setVersionCode(@Nullable Long setterArg) {
        this.versionCode = setterArg;
        return this;
      }

      private @Nullable String buildType;

      public @NonNull Builder setBuildType(@Nullable String setterArg) {
        this.buildType = setterArg;
        return this;
      }

      private @Nullable String buildDate;

      public @NonNull Builder setBuildDate(@Nullable String setterArg) {
        this.buildDate = setterArg;
        return this;
      }

      private @Nullable String buildRevision;

      public @NonNull Builder setBuildRevision(@Nullable String setterArg) {
        this.buildRevision = setterArg;
        return this;
      }

      private @Nullable String buildHost;

      public @NonNull Builder setBuildHost(@Nullable String setterArg) {
        this.buildHost = setterArg;
        return this;
      }

      private @Nullable String serverEnv;

      public @NonNull Builder setServerEnv(@Nullable String setterArg) {
        this.serverEnv = setterArg;
        return this;
      }

      private @Nullable String buildBranch;

      public @NonNull Builder setBuildBranch(@Nullable String setterArg) {
        this.buildBranch = setterArg;
        return this;
      }

      private @Nullable String engineRevision;

      public @NonNull Builder setEngineRevision(@Nullable String setterArg) {
        this.engineRevision = setterArg;
        return this;
      }

      public @NonNull NERtcVersion build() {
        NERtcVersion pigeonReturn = new NERtcVersion();
        pigeonReturn.setVersionName(versionName);
        pigeonReturn.setVersionCode(versionCode);
        pigeonReturn.setBuildType(buildType);
        pigeonReturn.setBuildDate(buildDate);
        pigeonReturn.setBuildRevision(buildRevision);
        pigeonReturn.setBuildHost(buildHost);
        pigeonReturn.setServerEnv(serverEnv);
        pigeonReturn.setBuildBranch(buildBranch);
        pigeonReturn.setEngineRevision(engineRevision);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(9);
      toListResult.add(versionName);
      toListResult.add(versionCode);
      toListResult.add(buildType);
      toListResult.add(buildDate);
      toListResult.add(buildRevision);
      toListResult.add(buildHost);
      toListResult.add(serverEnv);
      toListResult.add(buildBranch);
      toListResult.add(engineRevision);
      return toListResult;
    }

    static @NonNull NERtcVersion fromList(@NonNull ArrayList<Object> list) {
      NERtcVersion pigeonResult = new NERtcVersion();
      Object versionName = list.get(0);
      pigeonResult.setVersionName((String) versionName);
      Object versionCode = list.get(1);
      pigeonResult.setVersionCode(
          (versionCode == null)
              ? null
              : ((versionCode instanceof Integer) ? (Integer) versionCode : (Long) versionCode));
      Object buildType = list.get(2);
      pigeonResult.setBuildType((String) buildType);
      Object buildDate = list.get(3);
      pigeonResult.setBuildDate((String) buildDate);
      Object buildRevision = list.get(4);
      pigeonResult.setBuildRevision((String) buildRevision);
      Object buildHost = list.get(5);
      pigeonResult.setBuildHost((String) buildHost);
      Object serverEnv = list.get(6);
      pigeonResult.setServerEnv((String) serverEnv);
      Object buildBranch = list.get(7);
      pigeonResult.setBuildBranch((String) buildBranch);
      Object engineRevision = list.get(8);
      pigeonResult.setEngineRevision((String) engineRevision);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class VideoFrame {
    private @Nullable Long width;

    public @Nullable Long getWidth() {
      return width;
    }

    public void setWidth(@Nullable Long setterArg) {
      this.width = setterArg;
    }

    private @Nullable Long height;

    public @Nullable Long getHeight() {
      return height;
    }

    public void setHeight(@Nullable Long setterArg) {
      this.height = setterArg;
    }

    private @Nullable Long rotation;

    public @Nullable Long getRotation() {
      return rotation;
    }

    public void setRotation(@Nullable Long setterArg) {
      this.rotation = setterArg;
    }

    private @Nullable Long format;

    public @Nullable Long getFormat() {
      return format;
    }

    public void setFormat(@Nullable Long setterArg) {
      this.format = setterArg;
    }

    private @Nullable Long timeStamp;

    public @Nullable Long getTimeStamp() {
      return timeStamp;
    }

    public void setTimeStamp(@Nullable Long setterArg) {
      this.timeStamp = setterArg;
    }

    private @Nullable byte[] data;

    public @Nullable byte[] getData() {
      return data;
    }

    public void setData(@Nullable byte[] setterArg) {
      this.data = setterArg;
    }

    private @Nullable Long strideY;

    public @Nullable Long getStrideY() {
      return strideY;
    }

    public void setStrideY(@Nullable Long setterArg) {
      this.strideY = setterArg;
    }

    private @Nullable Long strideU;

    public @Nullable Long getStrideU() {
      return strideU;
    }

    public void setStrideU(@Nullable Long setterArg) {
      this.strideU = setterArg;
    }

    private @Nullable Long strideV;

    public @Nullable Long getStrideV() {
      return strideV;
    }

    public void setStrideV(@Nullable Long setterArg) {
      this.strideV = setterArg;
    }

    private @Nullable Long textureId;

    public @Nullable Long getTextureId() {
      return textureId;
    }

    public void setTextureId(@Nullable Long setterArg) {
      this.textureId = setterArg;
    }

    private @Nullable List<Double> transformMatrix;

    public @Nullable List<Double> getTransformMatrix() {
      return transformMatrix;
    }

    public void setTransformMatrix(@Nullable List<Double> setterArg) {
      this.transformMatrix = setterArg;
    }

    public static final class Builder {

      private @Nullable Long width;

      public @NonNull Builder setWidth(@Nullable Long setterArg) {
        this.width = setterArg;
        return this;
      }

      private @Nullable Long height;

      public @NonNull Builder setHeight(@Nullable Long setterArg) {
        this.height = setterArg;
        return this;
      }

      private @Nullable Long rotation;

      public @NonNull Builder setRotation(@Nullable Long setterArg) {
        this.rotation = setterArg;
        return this;
      }

      private @Nullable Long format;

      public @NonNull Builder setFormat(@Nullable Long setterArg) {
        this.format = setterArg;
        return this;
      }

      private @Nullable Long timeStamp;

      public @NonNull Builder setTimeStamp(@Nullable Long setterArg) {
        this.timeStamp = setterArg;
        return this;
      }

      private @Nullable byte[] data;

      public @NonNull Builder setData(@Nullable byte[] setterArg) {
        this.data = setterArg;
        return this;
      }

      private @Nullable Long strideY;

      public @NonNull Builder setStrideY(@Nullable Long setterArg) {
        this.strideY = setterArg;
        return this;
      }

      private @Nullable Long strideU;

      public @NonNull Builder setStrideU(@Nullable Long setterArg) {
        this.strideU = setterArg;
        return this;
      }

      private @Nullable Long strideV;

      public @NonNull Builder setStrideV(@Nullable Long setterArg) {
        this.strideV = setterArg;
        return this;
      }

      private @Nullable Long textureId;

      public @NonNull Builder setTextureId(@Nullable Long setterArg) {
        this.textureId = setterArg;
        return this;
      }

      private @Nullable List<Double> transformMatrix;

      public @NonNull Builder setTransformMatrix(@Nullable List<Double> setterArg) {
        this.transformMatrix = setterArg;
        return this;
      }

      public @NonNull VideoFrame build() {
        VideoFrame pigeonReturn = new VideoFrame();
        pigeonReturn.setWidth(width);
        pigeonReturn.setHeight(height);
        pigeonReturn.setRotation(rotation);
        pigeonReturn.setFormat(format);
        pigeonReturn.setTimeStamp(timeStamp);
        pigeonReturn.setData(data);
        pigeonReturn.setStrideY(strideY);
        pigeonReturn.setStrideU(strideU);
        pigeonReturn.setStrideV(strideV);
        pigeonReturn.setTextureId(textureId);
        pigeonReturn.setTransformMatrix(transformMatrix);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(11);
      toListResult.add(width);
      toListResult.add(height);
      toListResult.add(rotation);
      toListResult.add(format);
      toListResult.add(timeStamp);
      toListResult.add(data);
      toListResult.add(strideY);
      toListResult.add(strideU);
      toListResult.add(strideV);
      toListResult.add(textureId);
      toListResult.add(transformMatrix);
      return toListResult;
    }

    static @NonNull VideoFrame fromList(@NonNull ArrayList<Object> list) {
      VideoFrame pigeonResult = new VideoFrame();
      Object width = list.get(0);
      pigeonResult.setWidth(
          (width == null) ? null : ((width instanceof Integer) ? (Integer) width : (Long) width));
      Object height = list.get(1);
      pigeonResult.setHeight(
          (height == null)
              ? null
              : ((height instanceof Integer) ? (Integer) height : (Long) height));
      Object rotation = list.get(2);
      pigeonResult.setRotation(
          (rotation == null)
              ? null
              : ((rotation instanceof Integer) ? (Integer) rotation : (Long) rotation));
      Object format = list.get(3);
      pigeonResult.setFormat(
          (format == null)
              ? null
              : ((format instanceof Integer) ? (Integer) format : (Long) format));
      Object timeStamp = list.get(4);
      pigeonResult.setTimeStamp(
          (timeStamp == null)
              ? null
              : ((timeStamp instanceof Integer) ? (Integer) timeStamp : (Long) timeStamp));
      Object data = list.get(5);
      pigeonResult.setData((byte[]) data);
      Object strideY = list.get(6);
      pigeonResult.setStrideY(
          (strideY == null)
              ? null
              : ((strideY instanceof Integer) ? (Integer) strideY : (Long) strideY));
      Object strideU = list.get(7);
      pigeonResult.setStrideU(
          (strideU == null)
              ? null
              : ((strideU instanceof Integer) ? (Integer) strideU : (Long) strideU));
      Object strideV = list.get(8);
      pigeonResult.setStrideV(
          (strideV == null)
              ? null
              : ((strideV instanceof Integer) ? (Integer) strideV : (Long) strideV));
      Object textureId = list.get(9);
      pigeonResult.setTextureId(
          (textureId == null)
              ? null
              : ((textureId instanceof Integer) ? (Integer) textureId : (Long) textureId));
      Object transformMatrix = list.get(10);
      pigeonResult.setTransformMatrix((List<Double>) transformMatrix);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class DataExternalFrame {
    private @Nullable byte[] data;

    public @Nullable byte[] getData() {
      return data;
    }

    public void setData(@Nullable byte[] setterArg) {
      this.data = setterArg;
    }

    private @Nullable Long dataSize;

    public @Nullable Long getDataSize() {
      return dataSize;
    }

    public void setDataSize(@Nullable Long setterArg) {
      this.dataSize = setterArg;
    }

    public static final class Builder {

      private @Nullable byte[] data;

      public @NonNull Builder setData(@Nullable byte[] setterArg) {
        this.data = setterArg;
        return this;
      }

      private @Nullable Long dataSize;

      public @NonNull Builder setDataSize(@Nullable Long setterArg) {
        this.dataSize = setterArg;
        return this;
      }

      public @NonNull DataExternalFrame build() {
        DataExternalFrame pigeonReturn = new DataExternalFrame();
        pigeonReturn.setData(data);
        pigeonReturn.setDataSize(dataSize);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(data);
      toListResult.add(dataSize);
      return toListResult;
    }

    static @NonNull DataExternalFrame fromList(@NonNull ArrayList<Object> list) {
      DataExternalFrame pigeonResult = new DataExternalFrame();
      Object data = list.get(0);
      pigeonResult.setData((byte[]) data);
      Object dataSize = list.get(1);
      pigeonResult.setDataSize(
          (dataSize == null)
              ? null
              : ((dataSize instanceof Integer) ? (Integer) dataSize : (Long) dataSize));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class AudioExternalFrame {
    private @Nullable byte[] data;

    public @Nullable byte[] getData() {
      return data;
    }

    public void setData(@Nullable byte[] setterArg) {
      this.data = setterArg;
    }

    private @Nullable Long sampleRate;

    public @Nullable Long getSampleRate() {
      return sampleRate;
    }

    public void setSampleRate(@Nullable Long setterArg) {
      this.sampleRate = setterArg;
    }

    private @Nullable Long numberOfChannels;

    public @Nullable Long getNumberOfChannels() {
      return numberOfChannels;
    }

    public void setNumberOfChannels(@Nullable Long setterArg) {
      this.numberOfChannels = setterArg;
    }

    private @Nullable Long samplesPerChannel;

    public @Nullable Long getSamplesPerChannel() {
      return samplesPerChannel;
    }

    public void setSamplesPerChannel(@Nullable Long setterArg) {
      this.samplesPerChannel = setterArg;
    }

    private @Nullable Long syncTimestamp;

    public @Nullable Long getSyncTimestamp() {
      return syncTimestamp;
    }

    public void setSyncTimestamp(@Nullable Long setterArg) {
      this.syncTimestamp = setterArg;
    }

    public static final class Builder {

      private @Nullable byte[] data;

      public @NonNull Builder setData(@Nullable byte[] setterArg) {
        this.data = setterArg;
        return this;
      }

      private @Nullable Long sampleRate;

      public @NonNull Builder setSampleRate(@Nullable Long setterArg) {
        this.sampleRate = setterArg;
        return this;
      }

      private @Nullable Long numberOfChannels;

      public @NonNull Builder setNumberOfChannels(@Nullable Long setterArg) {
        this.numberOfChannels = setterArg;
        return this;
      }

      private @Nullable Long samplesPerChannel;

      public @NonNull Builder setSamplesPerChannel(@Nullable Long setterArg) {
        this.samplesPerChannel = setterArg;
        return this;
      }

      private @Nullable Long syncTimestamp;

      public @NonNull Builder setSyncTimestamp(@Nullable Long setterArg) {
        this.syncTimestamp = setterArg;
        return this;
      }

      public @NonNull AudioExternalFrame build() {
        AudioExternalFrame pigeonReturn = new AudioExternalFrame();
        pigeonReturn.setData(data);
        pigeonReturn.setSampleRate(sampleRate);
        pigeonReturn.setNumberOfChannels(numberOfChannels);
        pigeonReturn.setSamplesPerChannel(samplesPerChannel);
        pigeonReturn.setSyncTimestamp(syncTimestamp);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(5);
      toListResult.add(data);
      toListResult.add(sampleRate);
      toListResult.add(numberOfChannels);
      toListResult.add(samplesPerChannel);
      toListResult.add(syncTimestamp);
      return toListResult;
    }

    static @NonNull AudioExternalFrame fromList(@NonNull ArrayList<Object> list) {
      AudioExternalFrame pigeonResult = new AudioExternalFrame();
      Object data = list.get(0);
      pigeonResult.setData((byte[]) data);
      Object sampleRate = list.get(1);
      pigeonResult.setSampleRate(
          (sampleRate == null)
              ? null
              : ((sampleRate instanceof Integer) ? (Integer) sampleRate : (Long) sampleRate));
      Object numberOfChannels = list.get(2);
      pigeonResult.setNumberOfChannels(
          (numberOfChannels == null)
              ? null
              : ((numberOfChannels instanceof Integer)
                  ? (Integer) numberOfChannels
                  : (Long) numberOfChannels));
      Object samplesPerChannel = list.get(3);
      pigeonResult.setSamplesPerChannel(
          (samplesPerChannel == null)
              ? null
              : ((samplesPerChannel instanceof Integer)
                  ? (Integer) samplesPerChannel
                  : (Long) samplesPerChannel));
      Object syncTimestamp = list.get(4);
      pigeonResult.setSyncTimestamp(
          (syncTimestamp == null)
              ? null
              : ((syncTimestamp instanceof Integer)
                  ? (Integer) syncTimestamp
                  : (Long) syncTimestamp));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StreamingRoomInfo {
    private @Nullable Long uid;

    public @Nullable Long getUid() {
      return uid;
    }

    public void setUid(@Nullable Long setterArg) {
      this.uid = setterArg;
    }

    private @Nullable String channelName;

    public @Nullable String getChannelName() {
      return channelName;
    }

    public void setChannelName(@Nullable String setterArg) {
      this.channelName = setterArg;
    }

    private @Nullable String token;

    public @Nullable String getToken() {
      return token;
    }

    public void setToken(@Nullable String setterArg) {
      this.token = setterArg;
    }

    public static final class Builder {

      private @Nullable Long uid;

      public @NonNull Builder setUid(@Nullable Long setterArg) {
        this.uid = setterArg;
        return this;
      }

      private @Nullable String channelName;

      public @NonNull Builder setChannelName(@Nullable String setterArg) {
        this.channelName = setterArg;
        return this;
      }

      private @Nullable String token;

      public @NonNull Builder setToken(@Nullable String setterArg) {
        this.token = setterArg;
        return this;
      }

      public @NonNull StreamingRoomInfo build() {
        StreamingRoomInfo pigeonReturn = new StreamingRoomInfo();
        pigeonReturn.setUid(uid);
        pigeonReturn.setChannelName(channelName);
        pigeonReturn.setToken(token);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(3);
      toListResult.add(uid);
      toListResult.add(channelName);
      toListResult.add(token);
      return toListResult;
    }

    static @NonNull StreamingRoomInfo fromList(@NonNull ArrayList<Object> list) {
      StreamingRoomInfo pigeonResult = new StreamingRoomInfo();
      Object uid = list.get(0);
      pigeonResult.setUid(
          (uid == null) ? null : ((uid instanceof Integer) ? (Integer) uid : (Long) uid));
      Object channelName = list.get(1);
      pigeonResult.setChannelName((String) channelName);
      Object token = list.get(2);
      pigeonResult.setToken((String) token);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartPushStreamingRequest {
    private @Nullable String streamingUrl;

    public @Nullable String getStreamingUrl() {
      return streamingUrl;
    }

    public void setStreamingUrl(@Nullable String setterArg) {
      this.streamingUrl = setterArg;
    }

    private @Nullable StreamingRoomInfo streamingRoomInfo;

    public @Nullable StreamingRoomInfo getStreamingRoomInfo() {
      return streamingRoomInfo;
    }

    public void setStreamingRoomInfo(@Nullable StreamingRoomInfo setterArg) {
      this.streamingRoomInfo = setterArg;
    }

    public static final class Builder {

      private @Nullable String streamingUrl;

      public @NonNull Builder setStreamingUrl(@Nullable String setterArg) {
        this.streamingUrl = setterArg;
        return this;
      }

      private @Nullable StreamingRoomInfo streamingRoomInfo;

      public @NonNull Builder setStreamingRoomInfo(@Nullable StreamingRoomInfo setterArg) {
        this.streamingRoomInfo = setterArg;
        return this;
      }

      public @NonNull StartPushStreamingRequest build() {
        StartPushStreamingRequest pigeonReturn = new StartPushStreamingRequest();
        pigeonReturn.setStreamingUrl(streamingUrl);
        pigeonReturn.setStreamingRoomInfo(streamingRoomInfo);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(streamingUrl);
      toListResult.add((streamingRoomInfo == null) ? null : streamingRoomInfo.toList());
      return toListResult;
    }

    static @NonNull StartPushStreamingRequest fromList(@NonNull ArrayList<Object> list) {
      StartPushStreamingRequest pigeonResult = new StartPushStreamingRequest();
      Object streamingUrl = list.get(0);
      pigeonResult.setStreamingUrl((String) streamingUrl);
      Object streamingRoomInfo = list.get(1);
      pigeonResult.setStreamingRoomInfo(
          (streamingRoomInfo == null)
              ? null
              : StreamingRoomInfo.fromList((ArrayList<Object>) streamingRoomInfo));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartPlayStreamingRequest {
    private @Nullable String streamId;

    public @Nullable String getStreamId() {
      return streamId;
    }

    public void setStreamId(@Nullable String setterArg) {
      this.streamId = setterArg;
    }

    private @Nullable String streamingUrl;

    public @Nullable String getStreamingUrl() {
      return streamingUrl;
    }

    public void setStreamingUrl(@Nullable String setterArg) {
      this.streamingUrl = setterArg;
    }

    private @Nullable Long playOutDelay;

    public @Nullable Long getPlayOutDelay() {
      return playOutDelay;
    }

    public void setPlayOutDelay(@Nullable Long setterArg) {
      this.playOutDelay = setterArg;
    }

    private @Nullable Long reconnectTimeout;

    public @Nullable Long getReconnectTimeout() {
      return reconnectTimeout;
    }

    public void setReconnectTimeout(@Nullable Long setterArg) {
      this.reconnectTimeout = setterArg;
    }

    private @Nullable Boolean muteAudio;

    public @Nullable Boolean getMuteAudio() {
      return muteAudio;
    }

    public void setMuteAudio(@Nullable Boolean setterArg) {
      this.muteAudio = setterArg;
    }

    private @Nullable Boolean muteVideo;

    public @Nullable Boolean getMuteVideo() {
      return muteVideo;
    }

    public void setMuteVideo(@Nullable Boolean setterArg) {
      this.muteVideo = setterArg;
    }

    private @Nullable Boolean pausePullStream;

    public @Nullable Boolean getPausePullStream() {
      return pausePullStream;
    }

    public void setPausePullStream(@Nullable Boolean setterArg) {
      this.pausePullStream = setterArg;
    }

    public static final class Builder {

      private @Nullable String streamId;

      public @NonNull Builder setStreamId(@Nullable String setterArg) {
        this.streamId = setterArg;
        return this;
      }

      private @Nullable String streamingUrl;

      public @NonNull Builder setStreamingUrl(@Nullable String setterArg) {
        this.streamingUrl = setterArg;
        return this;
      }

      private @Nullable Long playOutDelay;

      public @NonNull Builder setPlayOutDelay(@Nullable Long setterArg) {
        this.playOutDelay = setterArg;
        return this;
      }

      private @Nullable Long reconnectTimeout;

      public @NonNull Builder setReconnectTimeout(@Nullable Long setterArg) {
        this.reconnectTimeout = setterArg;
        return this;
      }

      private @Nullable Boolean muteAudio;

      public @NonNull Builder setMuteAudio(@Nullable Boolean setterArg) {
        this.muteAudio = setterArg;
        return this;
      }

      private @Nullable Boolean muteVideo;

      public @NonNull Builder setMuteVideo(@Nullable Boolean setterArg) {
        this.muteVideo = setterArg;
        return this;
      }

      private @Nullable Boolean pausePullStream;

      public @NonNull Builder setPausePullStream(@Nullable Boolean setterArg) {
        this.pausePullStream = setterArg;
        return this;
      }

      public @NonNull StartPlayStreamingRequest build() {
        StartPlayStreamingRequest pigeonReturn = new StartPlayStreamingRequest();
        pigeonReturn.setStreamId(streamId);
        pigeonReturn.setStreamingUrl(streamingUrl);
        pigeonReturn.setPlayOutDelay(playOutDelay);
        pigeonReturn.setReconnectTimeout(reconnectTimeout);
        pigeonReturn.setMuteAudio(muteAudio);
        pigeonReturn.setMuteVideo(muteVideo);
        pigeonReturn.setPausePullStream(pausePullStream);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(7);
      toListResult.add(streamId);
      toListResult.add(streamingUrl);
      toListResult.add(playOutDelay);
      toListResult.add(reconnectTimeout);
      toListResult.add(muteAudio);
      toListResult.add(muteVideo);
      toListResult.add(pausePullStream);
      return toListResult;
    }

    static @NonNull StartPlayStreamingRequest fromList(@NonNull ArrayList<Object> list) {
      StartPlayStreamingRequest pigeonResult = new StartPlayStreamingRequest();
      Object streamId = list.get(0);
      pigeonResult.setStreamId((String) streamId);
      Object streamingUrl = list.get(1);
      pigeonResult.setStreamingUrl((String) streamingUrl);
      Object playOutDelay = list.get(2);
      pigeonResult.setPlayOutDelay(
          (playOutDelay == null)
              ? null
              : ((playOutDelay instanceof Integer) ? (Integer) playOutDelay : (Long) playOutDelay));
      Object reconnectTimeout = list.get(3);
      pigeonResult.setReconnectTimeout(
          (reconnectTimeout == null)
              ? null
              : ((reconnectTimeout instanceof Integer)
                  ? (Integer) reconnectTimeout
                  : (Long) reconnectTimeout));
      Object muteAudio = list.get(4);
      pigeonResult.setMuteAudio((Boolean) muteAudio);
      Object muteVideo = list.get(5);
      pigeonResult.setMuteVideo((Boolean) muteVideo);
      Object pausePullStream = list.get(6);
      pigeonResult.setPausePullStream((Boolean) pausePullStream);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class StartASRCaptionRequest {
    private @Nullable String srcLanguage;

    public @Nullable String getSrcLanguage() {
      return srcLanguage;
    }

    public void setSrcLanguage(@Nullable String setterArg) {
      this.srcLanguage = setterArg;
    }

    private @Nullable List<String> srcLanguageArr;

    public @Nullable List<String> getSrcLanguageArr() {
      return srcLanguageArr;
    }

    public void setSrcLanguageArr(@Nullable List<String> setterArg) {
      this.srcLanguageArr = setterArg;
    }

    private @Nullable List<String> dstLanguageArr;

    public @Nullable List<String> getDstLanguageArr() {
      return dstLanguageArr;
    }

    public void setDstLanguageArr(@Nullable List<String> setterArg) {
      this.dstLanguageArr = setterArg;
    }

    private @Nullable Boolean needTranslateSameLanguage;

    public @Nullable Boolean getNeedTranslateSameLanguage() {
      return needTranslateSameLanguage;
    }

    public void setNeedTranslateSameLanguage(@Nullable Boolean setterArg) {
      this.needTranslateSameLanguage = setterArg;
    }

    public static final class Builder {

      private @Nullable String srcLanguage;

      public @NonNull Builder setSrcLanguage(@Nullable String setterArg) {
        this.srcLanguage = setterArg;
        return this;
      }

      private @Nullable List<String> srcLanguageArr;

      public @NonNull Builder setSrcLanguageArr(@Nullable List<String> setterArg) {
        this.srcLanguageArr = setterArg;
        return this;
      }

      private @Nullable List<String> dstLanguageArr;

      public @NonNull Builder setDstLanguageArr(@Nullable List<String> setterArg) {
        this.dstLanguageArr = setterArg;
        return this;
      }

      private @Nullable Boolean needTranslateSameLanguage;

      public @NonNull Builder setNeedTranslateSameLanguage(@Nullable Boolean setterArg) {
        this.needTranslateSameLanguage = setterArg;
        return this;
      }

      public @NonNull StartASRCaptionRequest build() {
        StartASRCaptionRequest pigeonReturn = new StartASRCaptionRequest();
        pigeonReturn.setSrcLanguage(srcLanguage);
        pigeonReturn.setSrcLanguageArr(srcLanguageArr);
        pigeonReturn.setDstLanguageArr(dstLanguageArr);
        pigeonReturn.setNeedTranslateSameLanguage(needTranslateSameLanguage);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(4);
      toListResult.add(srcLanguage);
      toListResult.add(srcLanguageArr);
      toListResult.add(dstLanguageArr);
      toListResult.add(needTranslateSameLanguage);
      return toListResult;
    }

    static @NonNull StartASRCaptionRequest fromList(@NonNull ArrayList<Object> list) {
      StartASRCaptionRequest pigeonResult = new StartASRCaptionRequest();
      Object srcLanguage = list.get(0);
      pigeonResult.setSrcLanguage((String) srcLanguage);
      Object srcLanguageArr = list.get(1);
      pigeonResult.setSrcLanguageArr((List<String>) srcLanguageArr);
      Object dstLanguageArr = list.get(2);
      pigeonResult.setDstLanguageArr((List<String>) dstLanguageArr);
      Object needTranslateSameLanguage = list.get(3);
      pigeonResult.setNeedTranslateSameLanguage((Boolean) needTranslateSameLanguage);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static final class SetMultiPathOptionRequest {
    private @Nullable Boolean enableMediaMultiPath;

    public @Nullable Boolean getEnableMediaMultiPath() {
      return enableMediaMultiPath;
    }

    public void setEnableMediaMultiPath(@Nullable Boolean setterArg) {
      this.enableMediaMultiPath = setterArg;
    }

    private @Nullable Long mediaMode;

    public @Nullable Long getMediaMode() {
      return mediaMode;
    }

    public void setMediaMode(@Nullable Long setterArg) {
      this.mediaMode = setterArg;
    }

    private @Nullable Long badRttThreshold;

    public @Nullable Long getBadRttThreshold() {
      return badRttThreshold;
    }

    public void setBadRttThreshold(@Nullable Long setterArg) {
      this.badRttThreshold = setterArg;
    }

    private @Nullable Boolean redAudioPacket;

    public @Nullable Boolean getRedAudioPacket() {
      return redAudioPacket;
    }

    public void setRedAudioPacket(@Nullable Boolean setterArg) {
      this.redAudioPacket = setterArg;
    }

    private @Nullable Boolean redAudioRtxPacket;

    public @Nullable Boolean getRedAudioRtxPacket() {
      return redAudioRtxPacket;
    }

    public void setRedAudioRtxPacket(@Nullable Boolean setterArg) {
      this.redAudioRtxPacket = setterArg;
    }

    private @Nullable Boolean redVideoPacket;

    public @Nullable Boolean getRedVideoPacket() {
      return redVideoPacket;
    }

    public void setRedVideoPacket(@Nullable Boolean setterArg) {
      this.redVideoPacket = setterArg;
    }

    private @Nullable Boolean redVideoRtxPacket;

    public @Nullable Boolean getRedVideoRtxPacket() {
      return redVideoRtxPacket;
    }

    public void setRedVideoRtxPacket(@Nullable Boolean setterArg) {
      this.redVideoRtxPacket = setterArg;
    }

    public static final class Builder {

      private @Nullable Boolean enableMediaMultiPath;

      public @NonNull Builder setEnableMediaMultiPath(@Nullable Boolean setterArg) {
        this.enableMediaMultiPath = setterArg;
        return this;
      }

      private @Nullable Long mediaMode;

      public @NonNull Builder setMediaMode(@Nullable Long setterArg) {
        this.mediaMode = setterArg;
        return this;
      }

      private @Nullable Long badRttThreshold;

      public @NonNull Builder setBadRttThreshold(@Nullable Long setterArg) {
        this.badRttThreshold = setterArg;
        return this;
      }

      private @Nullable Boolean redAudioPacket;

      public @NonNull Builder setRedAudioPacket(@Nullable Boolean setterArg) {
        this.redAudioPacket = setterArg;
        return this;
      }

      private @Nullable Boolean redAudioRtxPacket;

      public @NonNull Builder setRedAudioRtxPacket(@Nullable Boolean setterArg) {
        this.redAudioRtxPacket = setterArg;
        return this;
      }

      private @Nullable Boolean redVideoPacket;

      public @NonNull Builder setRedVideoPacket(@Nullable Boolean setterArg) {
        this.redVideoPacket = setterArg;
        return this;
      }

      private @Nullable Boolean redVideoRtxPacket;

      public @NonNull Builder setRedVideoRtxPacket(@Nullable Boolean setterArg) {
        this.redVideoRtxPacket = setterArg;
        return this;
      }

      public @NonNull SetMultiPathOptionRequest build() {
        SetMultiPathOptionRequest pigeonReturn = new SetMultiPathOptionRequest();
        pigeonReturn.setEnableMediaMultiPath(enableMediaMultiPath);
        pigeonReturn.setMediaMode(mediaMode);
        pigeonReturn.setBadRttThreshold(badRttThreshold);
        pigeonReturn.setRedAudioPacket(redAudioPacket);
        pigeonReturn.setRedAudioRtxPacket(redAudioRtxPacket);
        pigeonReturn.setRedVideoPacket(redVideoPacket);
        pigeonReturn.setRedVideoRtxPacket(redVideoRtxPacket);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(7);
      toListResult.add(enableMediaMultiPath);
      toListResult.add(mediaMode);
      toListResult.add(badRttThreshold);
      toListResult.add(redAudioPacket);
      toListResult.add(redAudioRtxPacket);
      toListResult.add(redVideoPacket);
      toListResult.add(redVideoRtxPacket);
      return toListResult;
    }

    static @NonNull SetMultiPathOptionRequest fromList(@NonNull ArrayList<Object> list) {
      SetMultiPathOptionRequest pigeonResult = new SetMultiPathOptionRequest();
      Object enableMediaMultiPath = list.get(0);
      pigeonResult.setEnableMediaMultiPath((Boolean) enableMediaMultiPath);
      Object mediaMode = list.get(1);
      pigeonResult.setMediaMode(
          (mediaMode == null)
              ? null
              : ((mediaMode instanceof Integer) ? (Integer) mediaMode : (Long) mediaMode));
      Object badRttThreshold = list.get(2);
      pigeonResult.setBadRttThreshold(
          (badRttThreshold == null)
              ? null
              : ((badRttThreshold instanceof Integer)
                  ? (Integer) badRttThreshold
                  : (Long) badRttThreshold));
      Object redAudioPacket = list.get(3);
      pigeonResult.setRedAudioPacket((Boolean) redAudioPacket);
      Object redAudioRtxPacket = list.get(4);
      pigeonResult.setRedAudioRtxPacket((Boolean) redAudioRtxPacket);
      Object redVideoPacket = list.get(5);
      pigeonResult.setRedVideoPacket((Boolean) redVideoPacket);
      Object redVideoRtxPacket = list.get(6);
      pigeonResult.setRedVideoRtxPacket((Boolean) redVideoRtxPacket);
      return pigeonResult;
    }
  }

  public interface Result<T> {
    @SuppressWarnings("UnknownNullness")
    void success(T result);

    void error(@NonNull Throwable error);
  }

  private static class NERtcSubChannelEventSinkCodec extends StandardMessageCodec {
    public static final NERtcSubChannelEventSinkCodec INSTANCE =
        new NERtcSubChannelEventSinkCodec();

    private NERtcSubChannelEventSinkCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return AddOrUpdateLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 129:
          return AdjustUserPlaybackSignalVolumeRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 130:
          return AudioExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 131:
          return AudioRecordingConfigurationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 132:
          return AudioVolumeInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 133:
          return CGPoint.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 134:
          return CreateEngineRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 135:
          return DataExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 136:
          return DeleteLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 137:
          return EnableAudioVolumeIndicationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 138:
          return EnableEncryptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 139:
          return EnableLocalVideoRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 140:
          return EnableVirtualBackgroundRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 141:
          return FirstVideoDataReceivedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 142:
          return FirstVideoFrameDecodedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 143:
          return JoinChannelOptions.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 144:
          return JoinChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 145:
          return LocalRecordingConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 146:
          return LocalRecordingLayoutConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 147:
          return LocalRecordingStreamInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 148:
          return NERtcLastmileProbeOneWayResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 149:
          return NERtcLastmileProbeResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 150:
          return NERtcUserJoinExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 151:
          return NERtcUserLeaveExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 152:
          return NERtcVersion.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 153:
          return PlayEffectRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 154:
          return PositionInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 155:
          return Rectangle.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 156:
          return RemoteAudioVolumeIndicationEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 157:
          return ReportCustomEventRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 158:
          return RtcServerAddresses.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 159:
          return ScreenCaptureSourceData.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 160:
          return SendSEIMsgRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 161:
          return SetAudioProfileRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 162:
          return SetAudioSubscribeOnlyByRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 163:
          return SetCameraCaptureConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 164:
          return SetCameraPositionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 165:
          return SetLocalMediaPriorityRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 166:
          return SetLocalVideoConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 167:
          return SetLocalVideoWatermarkConfigsRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 168:
          return SetLocalVoiceEqualizationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 169:
          return SetLocalVoiceReverbParamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 170:
          return SetMultiPathOptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 171:
          return SetRemoteHighPriorityAudioStreamRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 172:
          return SetVideoCorrectionConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 173:
          return SpatializerRoomProperty.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 174:
          return StartASRCaptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 175:
          return StartAudioMixingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 176:
          return StartAudioRecordingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 177:
          return StartLastmileProbeTestRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 178:
          return StartOrUpdateChannelMediaRelayRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 179:
          return StartPlayStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 180:
          return StartPushStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 181:
          return StartScreenCaptureRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 182:
          return StartorStopVideoPreviewRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 183:
          return StreamingRoomInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 184:
          return SubscribeRemoteAudioRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 185:
          return SubscribeRemoteSubStreamAudioRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 186:
          return SubscribeRemoteSubStreamVideoRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 187:
          return SubscribeRemoteVideoStreamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 188:
          return SwitchChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 189:
          return UserJoinedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 190:
          return UserLeaveEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 191:
          return UserVideoMuteEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 192:
          return VideoFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 193:
          return VideoWatermarkConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 194:
          return VideoWatermarkImageConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 195:
          return VideoWatermarkTextConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 196:
          return VideoWatermarkTimestampConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 197:
          return VirtualBackgroundSourceEnabledEvent.fromList(
              (ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof AddOrUpdateLiveStreamTaskRequest) {
        stream.write(128);
        writeValue(stream, ((AddOrUpdateLiveStreamTaskRequest) value).toList());
      } else if (value instanceof AdjustUserPlaybackSignalVolumeRequest) {
        stream.write(129);
        writeValue(stream, ((AdjustUserPlaybackSignalVolumeRequest) value).toList());
      } else if (value instanceof AudioExternalFrame) {
        stream.write(130);
        writeValue(stream, ((AudioExternalFrame) value).toList());
      } else if (value instanceof AudioRecordingConfigurationRequest) {
        stream.write(131);
        writeValue(stream, ((AudioRecordingConfigurationRequest) value).toList());
      } else if (value instanceof AudioVolumeInfo) {
        stream.write(132);
        writeValue(stream, ((AudioVolumeInfo) value).toList());
      } else if (value instanceof CGPoint) {
        stream.write(133);
        writeValue(stream, ((CGPoint) value).toList());
      } else if (value instanceof CreateEngineRequest) {
        stream.write(134);
        writeValue(stream, ((CreateEngineRequest) value).toList());
      } else if (value instanceof DataExternalFrame) {
        stream.write(135);
        writeValue(stream, ((DataExternalFrame) value).toList());
      } else if (value instanceof DeleteLiveStreamTaskRequest) {
        stream.write(136);
        writeValue(stream, ((DeleteLiveStreamTaskRequest) value).toList());
      } else if (value instanceof EnableAudioVolumeIndicationRequest) {
        stream.write(137);
        writeValue(stream, ((EnableAudioVolumeIndicationRequest) value).toList());
      } else if (value instanceof EnableEncryptionRequest) {
        stream.write(138);
        writeValue(stream, ((EnableEncryptionRequest) value).toList());
      } else if (value instanceof EnableLocalVideoRequest) {
        stream.write(139);
        writeValue(stream, ((EnableLocalVideoRequest) value).toList());
      } else if (value instanceof EnableVirtualBackgroundRequest) {
        stream.write(140);
        writeValue(stream, ((EnableVirtualBackgroundRequest) value).toList());
      } else if (value instanceof FirstVideoDataReceivedEvent) {
        stream.write(141);
        writeValue(stream, ((FirstVideoDataReceivedEvent) value).toList());
      } else if (value instanceof FirstVideoFrameDecodedEvent) {
        stream.write(142);
        writeValue(stream, ((FirstVideoFrameDecodedEvent) value).toList());
      } else if (value instanceof JoinChannelOptions) {
        stream.write(143);
        writeValue(stream, ((JoinChannelOptions) value).toList());
      } else if (value instanceof JoinChannelRequest) {
        stream.write(144);
        writeValue(stream, ((JoinChannelRequest) value).toList());
      } else if (value instanceof LocalRecordingConfig) {
        stream.write(145);
        writeValue(stream, ((LocalRecordingConfig) value).toList());
      } else if (value instanceof LocalRecordingLayoutConfig) {
        stream.write(146);
        writeValue(stream, ((LocalRecordingLayoutConfig) value).toList());
      } else if (value instanceof LocalRecordingStreamInfo) {
        stream.write(147);
        writeValue(stream, ((LocalRecordingStreamInfo) value).toList());
      } else if (value instanceof NERtcLastmileProbeOneWayResult) {
        stream.write(148);
        writeValue(stream, ((NERtcLastmileProbeOneWayResult) value).toList());
      } else if (value instanceof NERtcLastmileProbeResult) {
        stream.write(149);
        writeValue(stream, ((NERtcLastmileProbeResult) value).toList());
      } else if (value instanceof NERtcUserJoinExtraInfo) {
        stream.write(150);
        writeValue(stream, ((NERtcUserJoinExtraInfo) value).toList());
      } else if (value instanceof NERtcUserLeaveExtraInfo) {
        stream.write(151);
        writeValue(stream, ((NERtcUserLeaveExtraInfo) value).toList());
      } else if (value instanceof NERtcVersion) {
        stream.write(152);
        writeValue(stream, ((NERtcVersion) value).toList());
      } else if (value instanceof PlayEffectRequest) {
        stream.write(153);
        writeValue(stream, ((PlayEffectRequest) value).toList());
      } else if (value instanceof PositionInfo) {
        stream.write(154);
        writeValue(stream, ((PositionInfo) value).toList());
      } else if (value instanceof Rectangle) {
        stream.write(155);
        writeValue(stream, ((Rectangle) value).toList());
      } else if (value instanceof RemoteAudioVolumeIndicationEvent) {
        stream.write(156);
        writeValue(stream, ((RemoteAudioVolumeIndicationEvent) value).toList());
      } else if (value instanceof ReportCustomEventRequest) {
        stream.write(157);
        writeValue(stream, ((ReportCustomEventRequest) value).toList());
      } else if (value instanceof RtcServerAddresses) {
        stream.write(158);
        writeValue(stream, ((RtcServerAddresses) value).toList());
      } else if (value instanceof ScreenCaptureSourceData) {
        stream.write(159);
        writeValue(stream, ((ScreenCaptureSourceData) value).toList());
      } else if (value instanceof SendSEIMsgRequest) {
        stream.write(160);
        writeValue(stream, ((SendSEIMsgRequest) value).toList());
      } else if (value instanceof SetAudioProfileRequest) {
        stream.write(161);
        writeValue(stream, ((SetAudioProfileRequest) value).toList());
      } else if (value instanceof SetAudioSubscribeOnlyByRequest) {
        stream.write(162);
        writeValue(stream, ((SetAudioSubscribeOnlyByRequest) value).toList());
      } else if (value instanceof SetCameraCaptureConfigRequest) {
        stream.write(163);
        writeValue(stream, ((SetCameraCaptureConfigRequest) value).toList());
      } else if (value instanceof SetCameraPositionRequest) {
        stream.write(164);
        writeValue(stream, ((SetCameraPositionRequest) value).toList());
      } else if (value instanceof SetLocalMediaPriorityRequest) {
        stream.write(165);
        writeValue(stream, ((SetLocalMediaPriorityRequest) value).toList());
      } else if (value instanceof SetLocalVideoConfigRequest) {
        stream.write(166);
        writeValue(stream, ((SetLocalVideoConfigRequest) value).toList());
      } else if (value instanceof SetLocalVideoWatermarkConfigsRequest) {
        stream.write(167);
        writeValue(stream, ((SetLocalVideoWatermarkConfigsRequest) value).toList());
      } else if (value instanceof SetLocalVoiceEqualizationRequest) {
        stream.write(168);
        writeValue(stream, ((SetLocalVoiceEqualizationRequest) value).toList());
      } else if (value instanceof SetLocalVoiceReverbParamRequest) {
        stream.write(169);
        writeValue(stream, ((SetLocalVoiceReverbParamRequest) value).toList());
      } else if (value instanceof SetMultiPathOptionRequest) {
        stream.write(170);
        writeValue(stream, ((SetMultiPathOptionRequest) value).toList());
      } else if (value instanceof SetRemoteHighPriorityAudioStreamRequest) {
        stream.write(171);
        writeValue(stream, ((SetRemoteHighPriorityAudioStreamRequest) value).toList());
      } else if (value instanceof SetVideoCorrectionConfigRequest) {
        stream.write(172);
        writeValue(stream, ((SetVideoCorrectionConfigRequest) value).toList());
      } else if (value instanceof SpatializerRoomProperty) {
        stream.write(173);
        writeValue(stream, ((SpatializerRoomProperty) value).toList());
      } else if (value instanceof StartASRCaptionRequest) {
        stream.write(174);
        writeValue(stream, ((StartASRCaptionRequest) value).toList());
      } else if (value instanceof StartAudioMixingRequest) {
        stream.write(175);
        writeValue(stream, ((StartAudioMixingRequest) value).toList());
      } else if (value instanceof StartAudioRecordingRequest) {
        stream.write(176);
        writeValue(stream, ((StartAudioRecordingRequest) value).toList());
      } else if (value instanceof StartLastmileProbeTestRequest) {
        stream.write(177);
        writeValue(stream, ((StartLastmileProbeTestRequest) value).toList());
      } else if (value instanceof StartOrUpdateChannelMediaRelayRequest) {
        stream.write(178);
        writeValue(stream, ((StartOrUpdateChannelMediaRelayRequest) value).toList());
      } else if (value instanceof StartPlayStreamingRequest) {
        stream.write(179);
        writeValue(stream, ((StartPlayStreamingRequest) value).toList());
      } else if (value instanceof StartPushStreamingRequest) {
        stream.write(180);
        writeValue(stream, ((StartPushStreamingRequest) value).toList());
      } else if (value instanceof StartScreenCaptureRequest) {
        stream.write(181);
        writeValue(stream, ((StartScreenCaptureRequest) value).toList());
      } else if (value instanceof StartorStopVideoPreviewRequest) {
        stream.write(182);
        writeValue(stream, ((StartorStopVideoPreviewRequest) value).toList());
      } else if (value instanceof StreamingRoomInfo) {
        stream.write(183);
        writeValue(stream, ((StreamingRoomInfo) value).toList());
      } else if (value instanceof SubscribeRemoteAudioRequest) {
        stream.write(184);
        writeValue(stream, ((SubscribeRemoteAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamAudioRequest) {
        stream.write(185);
        writeValue(stream, ((SubscribeRemoteSubStreamAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamVideoRequest) {
        stream.write(186);
        writeValue(stream, ((SubscribeRemoteSubStreamVideoRequest) value).toList());
      } else if (value instanceof SubscribeRemoteVideoStreamRequest) {
        stream.write(187);
        writeValue(stream, ((SubscribeRemoteVideoStreamRequest) value).toList());
      } else if (value instanceof SwitchChannelRequest) {
        stream.write(188);
        writeValue(stream, ((SwitchChannelRequest) value).toList());
      } else if (value instanceof UserJoinedEvent) {
        stream.write(189);
        writeValue(stream, ((UserJoinedEvent) value).toList());
      } else if (value instanceof UserLeaveEvent) {
        stream.write(190);
        writeValue(stream, ((UserLeaveEvent) value).toList());
      } else if (value instanceof UserVideoMuteEvent) {
        stream.write(191);
        writeValue(stream, ((UserVideoMuteEvent) value).toList());
      } else if (value instanceof VideoFrame) {
        stream.write(192);
        writeValue(stream, ((VideoFrame) value).toList());
      } else if (value instanceof VideoWatermarkConfig) {
        stream.write(193);
        writeValue(stream, ((VideoWatermarkConfig) value).toList());
      } else if (value instanceof VideoWatermarkImageConfig) {
        stream.write(194);
        writeValue(stream, ((VideoWatermarkImageConfig) value).toList());
      } else if (value instanceof VideoWatermarkTextConfig) {
        stream.write(195);
        writeValue(stream, ((VideoWatermarkTextConfig) value).toList());
      } else if (value instanceof VideoWatermarkTimestampConfig) {
        stream.write(196);
        writeValue(stream, ((VideoWatermarkTimestampConfig) value).toList());
      } else if (value instanceof VirtualBackgroundSourceEnabledEvent) {
        stream.write(197);
        writeValue(stream, ((VirtualBackgroundSourceEnabledEvent) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcSubChannelEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcSubChannelEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcSubChannelEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return NERtcSubChannelEventSinkCodec.INSTANCE;
    }

    public void onJoinChannel(
        @NonNull String channelTagArg,
        @NonNull Long resultArg,
        @NonNull Long channelIdArg,
        @NonNull Long elapsedArg,
        @NonNull Long uidArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onJoinChannel",
              getCodec());
      channel.send(
          new ArrayList<Object>(
              Arrays.asList(channelTagArg, resultArg, channelIdArg, elapsedArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onLeaveChannel(
        @NonNull String channelTagArg, @NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLeaveChannel",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserJoined(
        @NonNull String channelTagArg,
        @NonNull UserJoinedEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserJoined",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserLeave(
        @NonNull String channelTagArg,
        @NonNull UserLeaveEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserLeave",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserAudioStart(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserAudioStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamAudioStart(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserSubStreamAudioStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserAudioStop(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserAudioStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamAudioStop(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserSubStreamAudioStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoStart(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Long maxProfileArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserVideoStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, maxProfileArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoStop(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserVideoStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onDisconnect(
        @NonNull String channelTagArg, @NonNull Long reasonArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onDisconnect",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserAudioMute(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Boolean mutedArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserAudioMute",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, mutedArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoMute(
        @NonNull String channelTagArg,
        @NonNull UserVideoMuteEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserVideoMute",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamAudioMute(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Boolean mutedArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserSubStreamAudioMute",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, mutedArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstAudioDataReceived(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onFirstAudioDataReceived",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstVideoDataReceived(
        @NonNull String channelTagArg,
        @NonNull FirstVideoDataReceivedEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onFirstVideoDataReceived",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstAudioFrameDecoded(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onFirstAudioFrameDecoded",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstVideoFrameDecoded(
        @NonNull String channelTagArg,
        @NonNull FirstVideoFrameDecodedEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onFirstVideoFrameDecoded",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onVirtualBackgroundSourceEnabled(
        @NonNull String channelTagArg,
        @NonNull VirtualBackgroundSourceEnabledEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onVirtualBackgroundSourceEnabled",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onConnectionTypeChanged(
        @NonNull String channelTagArg,
        @NonNull Long newConnectionTypeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onConnectionTypeChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, newConnectionTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onReconnectingStart(@NonNull String channelTagArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onReconnectingStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onReJoinChannel(
        @NonNull String channelTagArg,
        @NonNull Long resultArg,
        @NonNull Long channelIdArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onReJoinChannel",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg, channelIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onConnectionStateChanged(
        @NonNull String channelTagArg,
        @NonNull Long stateArg,
        @NonNull Long reasonArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onConnectionStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, stateArg, reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalAudioVolumeIndication(
        @NonNull String channelTagArg,
        @NonNull Long volumeArg,
        @NonNull Boolean vadFlagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalAudioVolumeIndication",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, volumeArg, vadFlagArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteAudioVolumeIndication(
        @NonNull String channelTagArg,
        @NonNull RemoteAudioVolumeIndicationEvent eventArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onRemoteAudioVolumeIndication",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onLiveStreamState(
        @NonNull String channelTagArg,
        @NonNull String taskIdArg,
        @NonNull String pushUrlArg,
        @NonNull Long liveStateArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLiveStreamState",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, taskIdArg, pushUrlArg, liveStateArg)),
          channelReply -> callback.reply(null));
    }

    public void onClientRoleChange(
        @NonNull String channelTagArg,
        @NonNull Long oldRoleArg,
        @NonNull Long newRoleArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onClientRoleChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, oldRoleArg, newRoleArg)),
          channelReply -> callback.reply(null));
    }

    public void onError(
        @NonNull String channelTagArg, @NonNull Long codeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onError",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, codeArg)),
          channelReply -> callback.reply(null));
    }

    public void onWarning(
        @NonNull String channelTagArg, @NonNull Long codeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onWarning",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, codeArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamVideoStart(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Long maxProfileArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserSubStreamVideoStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, maxProfileArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamVideoStop(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserSubStreamVideoStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioHasHowling(@NonNull String channelTagArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAudioHasHowling",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onRecvSEIMsg(
        @NonNull String channelTagArg,
        @NonNull Long userIDArg,
        @NonNull String seiMsgArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onRecvSEIMsg",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, userIDArg, seiMsgArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioRecording(
        @NonNull String channelTagArg,
        @NonNull Long codeArg,
        @NonNull String filePathArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAudioRecording",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, codeArg, filePathArg)),
          channelReply -> callback.reply(null));
    }

    public void onMediaRightChange(
        @NonNull String channelTagArg,
        @NonNull Boolean isAudioBannedByServerArg,
        @NonNull Boolean isVideoBannedByServerArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onMediaRightChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(
              Arrays.asList(channelTagArg, isAudioBannedByServerArg, isVideoBannedByServerArg)),
          channelReply -> callback.reply(null));
    }

    public void onMediaRelayStatesChange(
        @NonNull String channelTagArg,
        @NonNull Long stateArg,
        @NonNull String channelNameArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onMediaRelayStatesChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, stateArg, channelNameArg)),
          channelReply -> callback.reply(null));
    }

    public void onMediaRelayReceiveEvent(
        @NonNull String channelTagArg,
        @NonNull Long eventArg,
        @NonNull Long codeArg,
        @NonNull String channelNameArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onMediaRelayReceiveEvent",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, eventArg, codeArg, channelNameArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalPublishFallbackToAudioOnly(
        @NonNull String channelTagArg,
        @NonNull Boolean isFallbackArg,
        @NonNull Long streamTypeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalPublishFallbackToAudioOnly",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, isFallbackArg, streamTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteSubscribeFallbackToAudioOnly(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Boolean isFallbackArg,
        @NonNull Long streamTypeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onRemoteSubscribeFallbackToAudioOnly",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, isFallbackArg, streamTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalVideoWatermarkState(
        @NonNull String channelTagArg,
        @NonNull Long videoStreamTypeArg,
        @NonNull Long stateArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalVideoWatermarkState",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, videoStreamTypeArg, stateArg)),
          channelReply -> callback.reply(null));
    }

    public void onLastmileQuality(
        @NonNull String channelTagArg, @NonNull Long qualityArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLastmileQuality",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, qualityArg)),
          channelReply -> callback.reply(null));
    }

    public void onLastmileProbeResult(
        @NonNull String channelTagArg,
        @NonNull NERtcLastmileProbeResult resultArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLastmileProbeResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onTakeSnapshotResult(
        @NonNull String channelTagArg,
        @NonNull Long codeArg,
        @NonNull String pathArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onTakeSnapshotResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, codeArg, pathArg)),
          channelReply -> callback.reply(null));
    }

    public void onPermissionKeyWillExpire(
        @NonNull String channelTagArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPermissionKeyWillExpire",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onUpdatePermissionKey(
        @NonNull String channelTagArg,
        @NonNull String keyArg,
        @NonNull Long errorArg,
        @NonNull Long timeoutArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUpdatePermissionKey",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, keyArg, errorArg, timeoutArg)),
          channelReply -> callback.reply(null));
    }

    public void onAsrCaptionStateChanged(
        @NonNull String channelTagArg,
        @NonNull Long asrStateArg,
        @NonNull Long codeArg,
        @NonNull String messageArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAsrCaptionStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, asrStateArg, codeArg, messageArg)),
          channelReply -> callback.reply(null));
    }

    public void onAsrCaptionResult(
        @NonNull String channelTagArg,
        @NonNull List<Map<Object, Object>> resultArg,
        @NonNull Long resultCountArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAsrCaptionResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg, resultCountArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingStateChange(
        @NonNull String channelTagArg,
        @NonNull String streamIdArg,
        @NonNull Long stateArg,
        @NonNull Long reasonArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPlayStreamingStateChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, streamIdArg, stateArg, reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingReceiveSeiMessage(
        @NonNull String channelTagArg,
        @NonNull String streamIdArg,
        @NonNull String messageArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPlayStreamingReceiveSeiMessage",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, streamIdArg, messageArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingFirstAudioFramePlayed(
        @NonNull String channelTagArg,
        @NonNull String streamIdArg,
        @NonNull Long timeMsArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPlayStreamingFirstAudioFramePlayed",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, streamIdArg, timeMsArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingFirstVideoFrameRender(
        @NonNull String channelTagArg,
        @NonNull String streamIdArg,
        @NonNull Long timeMsArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPlayStreamingFirstVideoFrameRender",
              getCodec());
      channel.send(
          new ArrayList<Object>(
              Arrays.asList(channelTagArg, streamIdArg, timeMsArg, widthArg, heightArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalAudioFirstPacketSent(
        @NonNull String channelTagArg,
        @NonNull Long audioStreamTypeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalAudioFirstPacketSent",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, audioStreamTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstVideoFrameRender(
        @NonNull String channelTagArg,
        @NonNull Long userIDArg,
        @NonNull Long streamTypeArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Long elapsedTimeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onFirstVideoFrameRender",
              getCodec());
      channel.send(
          new ArrayList<Object>(
              Arrays.asList(
                  channelTagArg, userIDArg, streamTypeArg, widthArg, heightArg, elapsedTimeArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalVideoRenderSizeChanged(
        @NonNull String channelTagArg,
        @NonNull Long videoTypeArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalVideoRenderSizeChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, videoTypeArg, widthArg, heightArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoProfileUpdate(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Long maxProfileArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserVideoProfileUpdate",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, maxProfileArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioDeviceChanged(
        @NonNull String channelTagArg, @NonNull Long selectedArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAudioDeviceChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, selectedArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioDeviceStateChange(
        @NonNull String channelTagArg,
        @NonNull Long deviceTypeArg,
        @NonNull Long deviceStateArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAudioDeviceStateChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, deviceTypeArg, deviceStateArg)),
          channelReply -> callback.reply(null));
    }

    public void onApiCallExecuted(
        @NonNull String channelTagArg,
        @NonNull String apiNameArg,
        @NonNull Long resultArg,
        @NonNull String messageArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onApiCallExecuted",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, apiNameArg, resultArg, messageArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteVideoSizeChanged(
        @NonNull String channelTagArg,
        @NonNull Long userIdArg,
        @NonNull Long videoTypeArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onRemoteVideoSizeChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(
              Arrays.asList(channelTagArg, userIdArg, videoTypeArg, widthArg, heightArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataStart(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserDataStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataStop(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserDataStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataReceiveMessage(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull byte[] bufferDataArg,
        @NonNull Long bufferSizeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserDataReceiveMessage",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, bufferDataArg, bufferSizeArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataStateChanged(
        @NonNull String channelTagArg, @NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserDataStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataBufferedAmountChanged(
        @NonNull String channelTagArg,
        @NonNull Long uidArg,
        @NonNull Long previousAmountArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserDataBufferedAmountChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, uidArg, previousAmountArg)),
          channelReply -> callback.reply(null));
    }

    public void onLabFeatureCallback(
        @NonNull String channelTagArg,
        @NonNull String keyArg,
        @NonNull Map<Object, Object> paramArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLabFeatureCallback",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, keyArg, paramArg)),
          channelReply -> callback.reply(null));
    }

    public void onAiData(
        @NonNull String channelTagArg,
        @NonNull String typeArg,
        @NonNull String dataArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAiData",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, typeArg, dataArg)),
          channelReply -> callback.reply(null));
    }

    public void onStartPushStreaming(
        @NonNull String channelTagArg,
        @NonNull Long resultArg,
        @NonNull Long channelIdArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onStartPushStreaming",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg, channelIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onStopPushStreaming(
        @NonNull String channelTagArg, @NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onStopPushStreaming",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onPushStreamingReconnecting(
        @NonNull String channelTagArg, @NonNull Long reasonArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPushStreamingReconnecting",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onPushStreamingReconnectedSuccess(
        @NonNull String channelTagArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onPushStreamingReconnectedSuccess",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onReleasedHwResources(
        @NonNull String channelTagArg, @NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onReleasedHwResources",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onScreenCaptureStatus(
        @NonNull String channelTagArg, @NonNull Long statusArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onScreenCaptureStatus",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, statusArg)),
          channelReply -> callback.reply(null));
    }

    public void onScreenCaptureSourceDataUpdate(
        @NonNull String channelTagArg,
        @NonNull ScreenCaptureSourceData dataArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onScreenCaptureSourceDataUpdate",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, dataArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalRecorderStatus(
        @NonNull String channelTagArg,
        @NonNull Long statusArg,
        @NonNull String taskIdArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalRecorderStatus",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, statusArg, taskIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalRecorderError(
        @NonNull String channelTagArg,
        @NonNull Long errorArg,
        @NonNull String taskIdArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onLocalRecorderError",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, errorArg, taskIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onCheckNECastAudioDriverResult(
        @NonNull String channelTagArg, @NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onCheckNECastAudioDriverResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(channelTagArg, resultArg)),
          channelReply -> callback.reply(null));
    }
  }

  private static class NERtcChannelEventSinkCodec extends StandardMessageCodec {
    public static final NERtcChannelEventSinkCodec INSTANCE = new NERtcChannelEventSinkCodec();

    private NERtcChannelEventSinkCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return AddOrUpdateLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 129:
          return AdjustUserPlaybackSignalVolumeRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 130:
          return AudioExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 131:
          return AudioRecordingConfigurationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 132:
          return AudioVolumeInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 133:
          return CGPoint.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 134:
          return CreateEngineRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 135:
          return DataExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 136:
          return DeleteLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 137:
          return EnableAudioVolumeIndicationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 138:
          return EnableEncryptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 139:
          return EnableLocalVideoRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 140:
          return EnableVirtualBackgroundRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 141:
          return FirstVideoDataReceivedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 142:
          return FirstVideoFrameDecodedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 143:
          return JoinChannelOptions.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 144:
          return JoinChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 145:
          return LocalRecordingConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 146:
          return LocalRecordingLayoutConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 147:
          return LocalRecordingStreamInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 148:
          return NERtcLastmileProbeOneWayResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 149:
          return NERtcLastmileProbeResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 150:
          return NERtcUserJoinExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 151:
          return NERtcUserLeaveExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 152:
          return NERtcVersion.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 153:
          return PlayEffectRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 154:
          return PositionInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 155:
          return Rectangle.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 156:
          return RemoteAudioVolumeIndicationEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 157:
          return ReportCustomEventRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 158:
          return RtcServerAddresses.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 159:
          return ScreenCaptureSourceData.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 160:
          return SendSEIMsgRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 161:
          return SetAudioProfileRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 162:
          return SetAudioSubscribeOnlyByRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 163:
          return SetCameraCaptureConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 164:
          return SetCameraPositionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 165:
          return SetLocalMediaPriorityRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 166:
          return SetLocalVideoConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 167:
          return SetLocalVideoWatermarkConfigsRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 168:
          return SetLocalVoiceEqualizationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 169:
          return SetLocalVoiceReverbParamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 170:
          return SetMultiPathOptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 171:
          return SetRemoteHighPriorityAudioStreamRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 172:
          return SetVideoCorrectionConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 173:
          return SpatializerRoomProperty.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 174:
          return StartASRCaptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 175:
          return StartAudioMixingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 176:
          return StartAudioRecordingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 177:
          return StartLastmileProbeTestRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 178:
          return StartOrUpdateChannelMediaRelayRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 179:
          return StartPlayStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 180:
          return StartPushStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 181:
          return StartScreenCaptureRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 182:
          return StartorStopVideoPreviewRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 183:
          return StreamingRoomInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 184:
          return SubscribeRemoteAudioRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 185:
          return SubscribeRemoteSubStreamAudioRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 186:
          return SubscribeRemoteSubStreamVideoRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 187:
          return SubscribeRemoteVideoStreamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 188:
          return SwitchChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 189:
          return UserJoinedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 190:
          return UserLeaveEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 191:
          return UserVideoMuteEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 192:
          return VideoFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 193:
          return VideoWatermarkConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 194:
          return VideoWatermarkImageConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 195:
          return VideoWatermarkTextConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 196:
          return VideoWatermarkTimestampConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 197:
          return VirtualBackgroundSourceEnabledEvent.fromList(
              (ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof AddOrUpdateLiveStreamTaskRequest) {
        stream.write(128);
        writeValue(stream, ((AddOrUpdateLiveStreamTaskRequest) value).toList());
      } else if (value instanceof AdjustUserPlaybackSignalVolumeRequest) {
        stream.write(129);
        writeValue(stream, ((AdjustUserPlaybackSignalVolumeRequest) value).toList());
      } else if (value instanceof AudioExternalFrame) {
        stream.write(130);
        writeValue(stream, ((AudioExternalFrame) value).toList());
      } else if (value instanceof AudioRecordingConfigurationRequest) {
        stream.write(131);
        writeValue(stream, ((AudioRecordingConfigurationRequest) value).toList());
      } else if (value instanceof AudioVolumeInfo) {
        stream.write(132);
        writeValue(stream, ((AudioVolumeInfo) value).toList());
      } else if (value instanceof CGPoint) {
        stream.write(133);
        writeValue(stream, ((CGPoint) value).toList());
      } else if (value instanceof CreateEngineRequest) {
        stream.write(134);
        writeValue(stream, ((CreateEngineRequest) value).toList());
      } else if (value instanceof DataExternalFrame) {
        stream.write(135);
        writeValue(stream, ((DataExternalFrame) value).toList());
      } else if (value instanceof DeleteLiveStreamTaskRequest) {
        stream.write(136);
        writeValue(stream, ((DeleteLiveStreamTaskRequest) value).toList());
      } else if (value instanceof EnableAudioVolumeIndicationRequest) {
        stream.write(137);
        writeValue(stream, ((EnableAudioVolumeIndicationRequest) value).toList());
      } else if (value instanceof EnableEncryptionRequest) {
        stream.write(138);
        writeValue(stream, ((EnableEncryptionRequest) value).toList());
      } else if (value instanceof EnableLocalVideoRequest) {
        stream.write(139);
        writeValue(stream, ((EnableLocalVideoRequest) value).toList());
      } else if (value instanceof EnableVirtualBackgroundRequest) {
        stream.write(140);
        writeValue(stream, ((EnableVirtualBackgroundRequest) value).toList());
      } else if (value instanceof FirstVideoDataReceivedEvent) {
        stream.write(141);
        writeValue(stream, ((FirstVideoDataReceivedEvent) value).toList());
      } else if (value instanceof FirstVideoFrameDecodedEvent) {
        stream.write(142);
        writeValue(stream, ((FirstVideoFrameDecodedEvent) value).toList());
      } else if (value instanceof JoinChannelOptions) {
        stream.write(143);
        writeValue(stream, ((JoinChannelOptions) value).toList());
      } else if (value instanceof JoinChannelRequest) {
        stream.write(144);
        writeValue(stream, ((JoinChannelRequest) value).toList());
      } else if (value instanceof LocalRecordingConfig) {
        stream.write(145);
        writeValue(stream, ((LocalRecordingConfig) value).toList());
      } else if (value instanceof LocalRecordingLayoutConfig) {
        stream.write(146);
        writeValue(stream, ((LocalRecordingLayoutConfig) value).toList());
      } else if (value instanceof LocalRecordingStreamInfo) {
        stream.write(147);
        writeValue(stream, ((LocalRecordingStreamInfo) value).toList());
      } else if (value instanceof NERtcLastmileProbeOneWayResult) {
        stream.write(148);
        writeValue(stream, ((NERtcLastmileProbeOneWayResult) value).toList());
      } else if (value instanceof NERtcLastmileProbeResult) {
        stream.write(149);
        writeValue(stream, ((NERtcLastmileProbeResult) value).toList());
      } else if (value instanceof NERtcUserJoinExtraInfo) {
        stream.write(150);
        writeValue(stream, ((NERtcUserJoinExtraInfo) value).toList());
      } else if (value instanceof NERtcUserLeaveExtraInfo) {
        stream.write(151);
        writeValue(stream, ((NERtcUserLeaveExtraInfo) value).toList());
      } else if (value instanceof NERtcVersion) {
        stream.write(152);
        writeValue(stream, ((NERtcVersion) value).toList());
      } else if (value instanceof PlayEffectRequest) {
        stream.write(153);
        writeValue(stream, ((PlayEffectRequest) value).toList());
      } else if (value instanceof PositionInfo) {
        stream.write(154);
        writeValue(stream, ((PositionInfo) value).toList());
      } else if (value instanceof Rectangle) {
        stream.write(155);
        writeValue(stream, ((Rectangle) value).toList());
      } else if (value instanceof RemoteAudioVolumeIndicationEvent) {
        stream.write(156);
        writeValue(stream, ((RemoteAudioVolumeIndicationEvent) value).toList());
      } else if (value instanceof ReportCustomEventRequest) {
        stream.write(157);
        writeValue(stream, ((ReportCustomEventRequest) value).toList());
      } else if (value instanceof RtcServerAddresses) {
        stream.write(158);
        writeValue(stream, ((RtcServerAddresses) value).toList());
      } else if (value instanceof ScreenCaptureSourceData) {
        stream.write(159);
        writeValue(stream, ((ScreenCaptureSourceData) value).toList());
      } else if (value instanceof SendSEIMsgRequest) {
        stream.write(160);
        writeValue(stream, ((SendSEIMsgRequest) value).toList());
      } else if (value instanceof SetAudioProfileRequest) {
        stream.write(161);
        writeValue(stream, ((SetAudioProfileRequest) value).toList());
      } else if (value instanceof SetAudioSubscribeOnlyByRequest) {
        stream.write(162);
        writeValue(stream, ((SetAudioSubscribeOnlyByRequest) value).toList());
      } else if (value instanceof SetCameraCaptureConfigRequest) {
        stream.write(163);
        writeValue(stream, ((SetCameraCaptureConfigRequest) value).toList());
      } else if (value instanceof SetCameraPositionRequest) {
        stream.write(164);
        writeValue(stream, ((SetCameraPositionRequest) value).toList());
      } else if (value instanceof SetLocalMediaPriorityRequest) {
        stream.write(165);
        writeValue(stream, ((SetLocalMediaPriorityRequest) value).toList());
      } else if (value instanceof SetLocalVideoConfigRequest) {
        stream.write(166);
        writeValue(stream, ((SetLocalVideoConfigRequest) value).toList());
      } else if (value instanceof SetLocalVideoWatermarkConfigsRequest) {
        stream.write(167);
        writeValue(stream, ((SetLocalVideoWatermarkConfigsRequest) value).toList());
      } else if (value instanceof SetLocalVoiceEqualizationRequest) {
        stream.write(168);
        writeValue(stream, ((SetLocalVoiceEqualizationRequest) value).toList());
      } else if (value instanceof SetLocalVoiceReverbParamRequest) {
        stream.write(169);
        writeValue(stream, ((SetLocalVoiceReverbParamRequest) value).toList());
      } else if (value instanceof SetMultiPathOptionRequest) {
        stream.write(170);
        writeValue(stream, ((SetMultiPathOptionRequest) value).toList());
      } else if (value instanceof SetRemoteHighPriorityAudioStreamRequest) {
        stream.write(171);
        writeValue(stream, ((SetRemoteHighPriorityAudioStreamRequest) value).toList());
      } else if (value instanceof SetVideoCorrectionConfigRequest) {
        stream.write(172);
        writeValue(stream, ((SetVideoCorrectionConfigRequest) value).toList());
      } else if (value instanceof SpatializerRoomProperty) {
        stream.write(173);
        writeValue(stream, ((SpatializerRoomProperty) value).toList());
      } else if (value instanceof StartASRCaptionRequest) {
        stream.write(174);
        writeValue(stream, ((StartASRCaptionRequest) value).toList());
      } else if (value instanceof StartAudioMixingRequest) {
        stream.write(175);
        writeValue(stream, ((StartAudioMixingRequest) value).toList());
      } else if (value instanceof StartAudioRecordingRequest) {
        stream.write(176);
        writeValue(stream, ((StartAudioRecordingRequest) value).toList());
      } else if (value instanceof StartLastmileProbeTestRequest) {
        stream.write(177);
        writeValue(stream, ((StartLastmileProbeTestRequest) value).toList());
      } else if (value instanceof StartOrUpdateChannelMediaRelayRequest) {
        stream.write(178);
        writeValue(stream, ((StartOrUpdateChannelMediaRelayRequest) value).toList());
      } else if (value instanceof StartPlayStreamingRequest) {
        stream.write(179);
        writeValue(stream, ((StartPlayStreamingRequest) value).toList());
      } else if (value instanceof StartPushStreamingRequest) {
        stream.write(180);
        writeValue(stream, ((StartPushStreamingRequest) value).toList());
      } else if (value instanceof StartScreenCaptureRequest) {
        stream.write(181);
        writeValue(stream, ((StartScreenCaptureRequest) value).toList());
      } else if (value instanceof StartorStopVideoPreviewRequest) {
        stream.write(182);
        writeValue(stream, ((StartorStopVideoPreviewRequest) value).toList());
      } else if (value instanceof StreamingRoomInfo) {
        stream.write(183);
        writeValue(stream, ((StreamingRoomInfo) value).toList());
      } else if (value instanceof SubscribeRemoteAudioRequest) {
        stream.write(184);
        writeValue(stream, ((SubscribeRemoteAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamAudioRequest) {
        stream.write(185);
        writeValue(stream, ((SubscribeRemoteSubStreamAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamVideoRequest) {
        stream.write(186);
        writeValue(stream, ((SubscribeRemoteSubStreamVideoRequest) value).toList());
      } else if (value instanceof SubscribeRemoteVideoStreamRequest) {
        stream.write(187);
        writeValue(stream, ((SubscribeRemoteVideoStreamRequest) value).toList());
      } else if (value instanceof SwitchChannelRequest) {
        stream.write(188);
        writeValue(stream, ((SwitchChannelRequest) value).toList());
      } else if (value instanceof UserJoinedEvent) {
        stream.write(189);
        writeValue(stream, ((UserJoinedEvent) value).toList());
      } else if (value instanceof UserLeaveEvent) {
        stream.write(190);
        writeValue(stream, ((UserLeaveEvent) value).toList());
      } else if (value instanceof UserVideoMuteEvent) {
        stream.write(191);
        writeValue(stream, ((UserVideoMuteEvent) value).toList());
      } else if (value instanceof VideoFrame) {
        stream.write(192);
        writeValue(stream, ((VideoFrame) value).toList());
      } else if (value instanceof VideoWatermarkConfig) {
        stream.write(193);
        writeValue(stream, ((VideoWatermarkConfig) value).toList());
      } else if (value instanceof VideoWatermarkImageConfig) {
        stream.write(194);
        writeValue(stream, ((VideoWatermarkImageConfig) value).toList());
      } else if (value instanceof VideoWatermarkTextConfig) {
        stream.write(195);
        writeValue(stream, ((VideoWatermarkTextConfig) value).toList());
      } else if (value instanceof VideoWatermarkTimestampConfig) {
        stream.write(196);
        writeValue(stream, ((VideoWatermarkTimestampConfig) value).toList());
      } else if (value instanceof VirtualBackgroundSourceEnabledEvent) {
        stream.write(197);
        writeValue(stream, ((VirtualBackgroundSourceEnabledEvent) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcChannelEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcChannelEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcChannelEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return NERtcChannelEventSinkCodec.INSTANCE;
    }

    public void onJoinChannel(
        @NonNull Long resultArg,
        @NonNull Long channelIdArg,
        @NonNull Long elapsedArg,
        @NonNull Long uidArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onJoinChannel",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(resultArg, channelIdArg, elapsedArg, uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onLeaveChannel(@NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLeaveChannel",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserJoined(@NonNull UserJoinedEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserJoined",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserLeave(@NonNull UserLeaveEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserLeave",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserAudioStart(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserAudioStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamAudioStart(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserSubStreamAudioStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserAudioStop(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserAudioStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamAudioStop(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserSubStreamAudioStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoStart(
        @NonNull Long uidArg, @NonNull Long maxProfileArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, maxProfileArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoStop(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onDisconnect(@NonNull Long reasonArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onDisconnect",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserAudioMute(
        @NonNull Long uidArg, @NonNull Boolean mutedArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserAudioMute",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, mutedArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoMute(
        @NonNull UserVideoMuteEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoMute",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamAudioMute(
        @NonNull Long uidArg, @NonNull Boolean mutedArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserSubStreamAudioMute",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, mutedArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstAudioDataReceived(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onFirstAudioDataReceived",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstVideoDataReceived(
        @NonNull FirstVideoDataReceivedEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onFirstVideoDataReceived",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstAudioFrameDecoded(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onFirstAudioFrameDecoded",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstVideoFrameDecoded(
        @NonNull FirstVideoFrameDecodedEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onFirstVideoFrameDecoded",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onVirtualBackgroundSourceEnabled(
        @NonNull VirtualBackgroundSourceEnabledEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onVirtualBackgroundSourceEnabled",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onConnectionTypeChanged(
        @NonNull Long newConnectionTypeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onConnectionTypeChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(newConnectionTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onReconnectingStart(@NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onReconnectingStart",
              getCodec());
      channel.send(null, channelReply -> callback.reply(null));
    }

    public void onReJoinChannel(
        @NonNull Long resultArg, @NonNull Long channelIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onReJoinChannel",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(resultArg, channelIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onConnectionStateChanged(
        @NonNull Long stateArg, @NonNull Long reasonArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onConnectionStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(stateArg, reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalAudioVolumeIndication(
        @NonNull Long volumeArg, @NonNull Boolean vadFlagArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalAudioVolumeIndication",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(volumeArg, vadFlagArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteAudioVolumeIndication(
        @NonNull RemoteAudioVolumeIndicationEvent eventArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onRemoteAudioVolumeIndication",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(eventArg)),
          channelReply -> callback.reply(null));
    }

    public void onLiveStreamState(
        @NonNull String taskIdArg,
        @NonNull String pushUrlArg,
        @NonNull Long liveStateArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLiveStreamState",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(taskIdArg, pushUrlArg, liveStateArg)),
          channelReply -> callback.reply(null));
    }

    public void onClientRoleChange(
        @NonNull Long oldRoleArg, @NonNull Long newRoleArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onClientRoleChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(oldRoleArg, newRoleArg)),
          channelReply -> callback.reply(null));
    }

    public void onError(@NonNull Long codeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onError",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(codeArg)),
          channelReply -> callback.reply(null));
    }

    public void onWarning(@NonNull Long codeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onWarning",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(codeArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamVideoStart(
        @NonNull Long uidArg, @NonNull Long maxProfileArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserSubStreamVideoStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, maxProfileArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserSubStreamVideoStop(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserSubStreamVideoStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioHasHowling(@NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAudioHasHowling",
              getCodec());
      channel.send(null, channelReply -> callback.reply(null));
    }

    public void onRecvSEIMsg(
        @NonNull Long userIDArg, @NonNull String seiMsgArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onRecvSEIMsg",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(userIDArg, seiMsgArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioRecording(
        @NonNull Long codeArg, @NonNull String filePathArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAudioRecording",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(codeArg, filePathArg)),
          channelReply -> callback.reply(null));
    }

    public void onMediaRightChange(
        @NonNull Boolean isAudioBannedByServerArg,
        @NonNull Boolean isVideoBannedByServerArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onMediaRightChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(isAudioBannedByServerArg, isVideoBannedByServerArg)),
          channelReply -> callback.reply(null));
    }

    public void onMediaRelayStatesChange(
        @NonNull Long stateArg, @NonNull String channelNameArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onMediaRelayStatesChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(stateArg, channelNameArg)),
          channelReply -> callback.reply(null));
    }

    public void onMediaRelayReceiveEvent(
        @NonNull Long eventArg,
        @NonNull Long codeArg,
        @NonNull String channelNameArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onMediaRelayReceiveEvent",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(eventArg, codeArg, channelNameArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalPublishFallbackToAudioOnly(
        @NonNull Boolean isFallbackArg,
        @NonNull Long streamTypeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalPublishFallbackToAudioOnly",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(isFallbackArg, streamTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteSubscribeFallbackToAudioOnly(
        @NonNull Long uidArg,
        @NonNull Boolean isFallbackArg,
        @NonNull Long streamTypeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onRemoteSubscribeFallbackToAudioOnly",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, isFallbackArg, streamTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalVideoWatermarkState(
        @NonNull Long videoStreamTypeArg, @NonNull Long stateArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalVideoWatermarkState",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(videoStreamTypeArg, stateArg)),
          channelReply -> callback.reply(null));
    }

    public void onLastmileQuality(@NonNull Long qualityArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLastmileQuality",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(qualityArg)),
          channelReply -> callback.reply(null));
    }

    public void onLastmileProbeResult(
        @NonNull NERtcLastmileProbeResult resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLastmileProbeResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onTakeSnapshotResult(
        @NonNull Long codeArg, @NonNull String pathArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onTakeSnapshotResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(codeArg, pathArg)),
          channelReply -> callback.reply(null));
    }

    public void onPermissionKeyWillExpire(@NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPermissionKeyWillExpire",
              getCodec());
      channel.send(null, channelReply -> callback.reply(null));
    }

    public void onUpdatePermissionKey(
        @NonNull String keyArg,
        @NonNull Long errorArg,
        @NonNull Long timeoutArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUpdatePermissionKey",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(keyArg, errorArg, timeoutArg)),
          channelReply -> callback.reply(null));
    }

    public void onAsrCaptionStateChanged(
        @NonNull Long asrStateArg,
        @NonNull Long codeArg,
        @NonNull String messageArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAsrCaptionStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(asrStateArg, codeArg, messageArg)),
          channelReply -> callback.reply(null));
    }

    public void onAsrCaptionResult(
        @NonNull List<Map<Object, Object>> resultArg,
        @NonNull Long resultCountArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAsrCaptionResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(resultArg, resultCountArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingStateChange(
        @NonNull String streamIdArg,
        @NonNull Long stateArg,
        @NonNull Long reasonArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPlayStreamingStateChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(streamIdArg, stateArg, reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingReceiveSeiMessage(
        @NonNull String streamIdArg, @NonNull String messageArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPlayStreamingReceiveSeiMessage",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(streamIdArg, messageArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingFirstAudioFramePlayed(
        @NonNull String streamIdArg, @NonNull Long timeMsArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPlayStreamingFirstAudioFramePlayed",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(streamIdArg, timeMsArg)),
          channelReply -> callback.reply(null));
    }

    public void onPlayStreamingFirstVideoFrameRender(
        @NonNull String streamIdArg,
        @NonNull Long timeMsArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPlayStreamingFirstVideoFrameRender",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(streamIdArg, timeMsArg, widthArg, heightArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalAudioFirstPacketSent(
        @NonNull Long audioStreamTypeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalAudioFirstPacketSent",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(audioStreamTypeArg)),
          channelReply -> callback.reply(null));
    }

    public void onFirstVideoFrameRender(
        @NonNull Long userIDArg,
        @NonNull Long streamTypeArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Long elapsedTimeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onFirstVideoFrameRender",
              getCodec());
      channel.send(
          new ArrayList<Object>(
              Arrays.asList(userIDArg, streamTypeArg, widthArg, heightArg, elapsedTimeArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalVideoRenderSizeChanged(
        @NonNull Long videoTypeArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalVideoRenderSizeChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(videoTypeArg, widthArg, heightArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserVideoProfileUpdate(
        @NonNull Long uidArg, @NonNull Long maxProfileArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoProfileUpdate",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, maxProfileArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioDeviceChanged(@NonNull Long selectedArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAudioDeviceChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(selectedArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioDeviceStateChange(
        @NonNull Long deviceTypeArg, @NonNull Long deviceStateArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAudioDeviceStateChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(deviceTypeArg, deviceStateArg)),
          channelReply -> callback.reply(null));
    }

    public void onApiCallExecuted(
        @NonNull String apiNameArg,
        @NonNull Long resultArg,
        @NonNull String messageArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onApiCallExecuted",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(apiNameArg, resultArg, messageArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteVideoSizeChanged(
        @NonNull Long userIdArg,
        @NonNull Long videoTypeArg,
        @NonNull Long widthArg,
        @NonNull Long heightArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onRemoteVideoSizeChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(userIdArg, videoTypeArg, widthArg, heightArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataStart(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataStart",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataStop(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataStop",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataReceiveMessage(
        @NonNull Long uidArg,
        @NonNull byte[] bufferDataArg,
        @NonNull Long bufferSizeArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataReceiveMessage",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, bufferDataArg, bufferSizeArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataStateChanged(@NonNull Long uidArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(uidArg)),
          channelReply -> callback.reply(null));
    }

    public void onUserDataBufferedAmountChanged(
        @NonNull Long uidArg, @NonNull Long previousAmountArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataBufferedAmountChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(uidArg, previousAmountArg)),
          channelReply -> callback.reply(null));
    }

    public void onLabFeatureCallback(
        @NonNull String keyArg,
        @NonNull Map<Object, Object> paramArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLabFeatureCallback",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(keyArg, paramArg)),
          channelReply -> callback.reply(null));
    }

    public void onAiData(
        @NonNull String typeArg, @NonNull String dataArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAiData",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(typeArg, dataArg)),
          channelReply -> callback.reply(null));
    }

    public void onStartPushStreaming(
        @NonNull Long resultArg, @NonNull Long channelIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onStartPushStreaming",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(resultArg, channelIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onStopPushStreaming(@NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onStopPushStreaming",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onPushStreamingReconnecting(
        @NonNull Long reasonArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPushStreamingReconnecting",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onPushStreamingReconnectedSuccess(@NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onPushStreamingReconnectedSuccess",
              getCodec());
      channel.send(null, channelReply -> callback.reply(null));
    }

    public void onReleasedHwResources(@NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onReleasedHwResources",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(resultArg)),
          channelReply -> callback.reply(null));
    }

    public void onScreenCaptureStatus(@NonNull Long statusArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onScreenCaptureStatus",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(statusArg)),
          channelReply -> callback.reply(null));
    }

    public void onScreenCaptureSourceDataUpdate(
        @NonNull ScreenCaptureSourceData dataArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onScreenCaptureSourceDataUpdate",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(dataArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalRecorderStatus(
        @NonNull Long statusArg, @NonNull String taskIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalRecorderStatus",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(statusArg, taskIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalRecorderError(
        @NonNull Long errorArg, @NonNull String taskIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLocalRecorderError",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(errorArg, taskIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onCheckNECastAudioDriverResult(
        @NonNull Long resultArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onCheckNECastAudioDriverResult",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(resultArg)),
          channelReply -> callback.reply(null));
    }
  }

  private static class ChannelApiCodec extends StandardMessageCodec {
    public static final ChannelApiCodec INSTANCE = new ChannelApiCodec();

    private ChannelApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return AddOrUpdateLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 129:
          return AdjustUserPlaybackSignalVolumeRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 130:
          return DataExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 131:
          return DeleteLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 132:
          return EnableAudioVolumeIndicationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 133:
          return EnableEncryptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 134:
          return EnableLocalVideoRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 135:
          return JoinChannelOptions.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 136:
          return JoinChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 137:
          return PositionInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 138:
          return ReportCustomEventRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 139:
          return SendSEIMsgRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 140:
          return SetAudioSubscribeOnlyByRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 141:
          return SetCameraCaptureConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 142:
          return SetLocalMediaPriorityRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 143:
          return SetLocalVideoConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 144:
          return SetRemoteHighPriorityAudioStreamRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 145:
          return SpatializerRoomProperty.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 146:
          return StartOrUpdateChannelMediaRelayRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 147:
          return StartScreenCaptureRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 148:
          return SubscribeRemoteVideoStreamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 149:
          return VideoFrame.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof AddOrUpdateLiveStreamTaskRequest) {
        stream.write(128);
        writeValue(stream, ((AddOrUpdateLiveStreamTaskRequest) value).toList());
      } else if (value instanceof AdjustUserPlaybackSignalVolumeRequest) {
        stream.write(129);
        writeValue(stream, ((AdjustUserPlaybackSignalVolumeRequest) value).toList());
      } else if (value instanceof DataExternalFrame) {
        stream.write(130);
        writeValue(stream, ((DataExternalFrame) value).toList());
      } else if (value instanceof DeleteLiveStreamTaskRequest) {
        stream.write(131);
        writeValue(stream, ((DeleteLiveStreamTaskRequest) value).toList());
      } else if (value instanceof EnableAudioVolumeIndicationRequest) {
        stream.write(132);
        writeValue(stream, ((EnableAudioVolumeIndicationRequest) value).toList());
      } else if (value instanceof EnableEncryptionRequest) {
        stream.write(133);
        writeValue(stream, ((EnableEncryptionRequest) value).toList());
      } else if (value instanceof EnableLocalVideoRequest) {
        stream.write(134);
        writeValue(stream, ((EnableLocalVideoRequest) value).toList());
      } else if (value instanceof JoinChannelOptions) {
        stream.write(135);
        writeValue(stream, ((JoinChannelOptions) value).toList());
      } else if (value instanceof JoinChannelRequest) {
        stream.write(136);
        writeValue(stream, ((JoinChannelRequest) value).toList());
      } else if (value instanceof PositionInfo) {
        stream.write(137);
        writeValue(stream, ((PositionInfo) value).toList());
      } else if (value instanceof ReportCustomEventRequest) {
        stream.write(138);
        writeValue(stream, ((ReportCustomEventRequest) value).toList());
      } else if (value instanceof SendSEIMsgRequest) {
        stream.write(139);
        writeValue(stream, ((SendSEIMsgRequest) value).toList());
      } else if (value instanceof SetAudioSubscribeOnlyByRequest) {
        stream.write(140);
        writeValue(stream, ((SetAudioSubscribeOnlyByRequest) value).toList());
      } else if (value instanceof SetCameraCaptureConfigRequest) {
        stream.write(141);
        writeValue(stream, ((SetCameraCaptureConfigRequest) value).toList());
      } else if (value instanceof SetLocalMediaPriorityRequest) {
        stream.write(142);
        writeValue(stream, ((SetLocalMediaPriorityRequest) value).toList());
      } else if (value instanceof SetLocalVideoConfigRequest) {
        stream.write(143);
        writeValue(stream, ((SetLocalVideoConfigRequest) value).toList());
      } else if (value instanceof SetRemoteHighPriorityAudioStreamRequest) {
        stream.write(144);
        writeValue(stream, ((SetRemoteHighPriorityAudioStreamRequest) value).toList());
      } else if (value instanceof SpatializerRoomProperty) {
        stream.write(145);
        writeValue(stream, ((SpatializerRoomProperty) value).toList());
      } else if (value instanceof StartOrUpdateChannelMediaRelayRequest) {
        stream.write(146);
        writeValue(stream, ((StartOrUpdateChannelMediaRelayRequest) value).toList());
      } else if (value instanceof StartScreenCaptureRequest) {
        stream.write(147);
        writeValue(stream, ((StartScreenCaptureRequest) value).toList());
      } else if (value instanceof SubscribeRemoteVideoStreamRequest) {
        stream.write(148);
        writeValue(stream, ((SubscribeRemoteVideoStreamRequest) value).toList());
      } else if (value instanceof VideoFrame) {
        stream.write(149);
        writeValue(stream, ((VideoFrame) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface ChannelApi {

    @NonNull
    String getChannelName(@NonNull String channelTag);

    @NonNull
    Long setStatsEventCallback(@NonNull String channelTag);

    @NonNull
    Long clearStatsEventCallback(@NonNull String channelTag);

    @NonNull
    Long setChannelProfile(@NonNull String channelTag, @NonNull Long channelProfile);

    @NonNull
    Long enableMediaPub(
        @NonNull String channelTag, @NonNull Long mediaType, @NonNull Boolean enable);

    @NonNull
    Long joinChannel(@NonNull String channelTag, @NonNull JoinChannelRequest request);

    @NonNull
    Long leaveChannel(@NonNull String channelTag);

    @NonNull
    Long setClientRole(@NonNull String channelTag, @NonNull Long role);

    @NonNull
    Long getConnectionState(@NonNull String channelTag);

    @NonNull
    Long release(@NonNull String channelTag);

    @NonNull
    Long enableLocalAudio(@NonNull String channelTag, @NonNull Boolean enable);

    @NonNull
    Long muteLocalAudioStream(@NonNull String channelTag, @NonNull Boolean mute);

    @NonNull
    Long subscribeRemoteAudio(
        @NonNull String channelTag, @NonNull Long uid, @NonNull Boolean subscribe);

    @NonNull
    Long subscribeRemoteSubAudio(
        @NonNull String channelTag, @NonNull Long uid, @NonNull Boolean subscribe);

    @NonNull
    Long setLocalVideoConfig(
        @NonNull String channelTag, @NonNull SetLocalVideoConfigRequest request);

    @NonNull
    Long enableLocalVideo(@NonNull String channelTag, @NonNull EnableLocalVideoRequest request);

    @NonNull
    Long muteLocalVideoStream(
        @NonNull String channelTag, @NonNull Boolean mute, @NonNull Long streamType);

    @NonNull
    Long switchCamera(@NonNull String channelTag);

    @NonNull
    Long subscribeRemoteVideoStream(
        @NonNull String channelTag, @NonNull SubscribeRemoteVideoStreamRequest request);

    @NonNull
    Long subscribeRemoteSubVideoStream(
        @NonNull String channelTag, @NonNull Long uid, @NonNull Boolean subscribe);

    @NonNull
    Long enableAudioVolumeIndication(
        @NonNull String channelTag, @NonNull EnableAudioVolumeIndicationRequest request);

    @NonNull
    Long takeLocalSnapshot(
        @NonNull String channelTag, @NonNull Long streamType, @NonNull String path);

    @NonNull
    Long takeRemoteSnapshot(
        @NonNull String channelTag,
        @NonNull Long uid,
        @NonNull Long streamType,
        @NonNull String path);

    @NonNull
    Long subscribeAllRemoteAudio(@NonNull String channelTag, @NonNull Boolean subscribe);

    @NonNull
    Long setCameraCaptureConfig(
        @NonNull String channelTag, @NonNull SetCameraCaptureConfigRequest request);

    @NonNull
    Long setVideoStreamLayerCount(@NonNull String channelTag, @NonNull Long layerCount);

    @NonNull
    Long getFeatureSupportedType(@NonNull String channelTag, @NonNull Long type);

    @NonNull
    Long switchCameraWithPosition(@NonNull String channelTag, @NonNull Long position);

    void startScreenCapture(
        @NonNull String channelTag,
        @NonNull StartScreenCaptureRequest request,
        @NonNull Result<Long> result);

    @NonNull
    Long stopScreenCapture(@NonNull String channelTag);

    @NonNull
    Long enableLoopbackRecording(@NonNull String channelTag, @NonNull Boolean enable);

    @NonNull
    Long adjustLoopBackRecordingSignalVolume(@NonNull String channelTag, @NonNull Long volume);

    @NonNull
    Long setExternalVideoSource(
        @NonNull String channelTag, @NonNull Long streamType, @NonNull Boolean enable);

    @NonNull
    Long pushExternalVideoFrame(
        @NonNull String channelTag, @NonNull Long streamType, @NonNull VideoFrame frame);

    @NonNull
    Long addLiveStreamTask(
        @NonNull String channelTag, @NonNull AddOrUpdateLiveStreamTaskRequest request);

    @NonNull
    Long updateLiveStreamTask(
        @NonNull String channelTag, @NonNull AddOrUpdateLiveStreamTaskRequest request);

    @NonNull
    Long removeLiveStreamTask(
        @NonNull String channelTag, @NonNull DeleteLiveStreamTaskRequest request);

    @NonNull
    Long sendSEIMsg(@NonNull String channelTag, @NonNull SendSEIMsgRequest request);

    @NonNull
    Long setLocalMediaPriority(
        @NonNull String channelTag, @NonNull SetLocalMediaPriorityRequest request);

    @NonNull
    Long startChannelMediaRelay(
        @NonNull String channelTag, @NonNull StartOrUpdateChannelMediaRelayRequest request);

    @NonNull
    Long updateChannelMediaRelay(
        @NonNull String channelTag, @NonNull StartOrUpdateChannelMediaRelayRequest request);

    @NonNull
    Long stopChannelMediaRelay(@NonNull String channelTag);

    @NonNull
    Long adjustUserPlaybackSignalVolume(
        @NonNull String channelTag, @NonNull AdjustUserPlaybackSignalVolumeRequest request);

    @NonNull
    Long setLocalPublishFallbackOption(@NonNull String channelTag, @NonNull Long option);

    @NonNull
    Long setRemoteSubscribeFallbackOption(@NonNull String channelTag, @NonNull Long option);

    @NonNull
    Long enableEncryption(@NonNull String channelTag, @NonNull EnableEncryptionRequest request);

    @NonNull
    Long setRemoteHighPriorityAudioStream(
        @NonNull String channelTag, @NonNull SetRemoteHighPriorityAudioStreamRequest request);

    @NonNull
    Long setAudioSubscribeOnlyBy(
        @NonNull String channelTag, @NonNull SetAudioSubscribeOnlyByRequest request);

    @NonNull
    Long enableLocalSubStreamAudio(@NonNull String channelTag, @NonNull Boolean enable);

    @NonNull
    Long enableLocalData(@NonNull String channelTag, @NonNull Boolean enabled);

    @NonNull
    Long subscribeRemoteData(
        @NonNull String channelTag, @NonNull Boolean subscribe, @NonNull Long userID);

    @NonNull
    Long sendData(@NonNull String channelTag, @NonNull DataExternalFrame frame);

    @NonNull
    Long reportCustomEvent(@NonNull String channelTag, @NonNull ReportCustomEventRequest request);

    @NonNull
    Long setAudioRecvRange(
        @NonNull String channelTag,
        @NonNull Long audibleDistance,
        @NonNull Long conversationalDistance,
        @NonNull Long rollOffMode);

    @NonNull
    Long setRangeAudioMode(@NonNull String channelTag, @NonNull Long audioMode);

    @NonNull
    Long setRangeAudioTeamID(@NonNull String channelTag, @NonNull Long teamID);

    @NonNull
    Long updateSelfPosition(@NonNull String channelTag, @NonNull PositionInfo positionInfo);

    @NonNull
    Long enableSpatializerRoomEffects(@NonNull String channelTag, @NonNull Boolean enable);

    @NonNull
    Long setSpatializerRoomProperty(
        @NonNull String channelTag, @NonNull SpatializerRoomProperty property);

    @NonNull
    Long setSpatializerRenderMode(@NonNull String channelTag, @NonNull Long renderMode);

    @NonNull
    Long enableSpatializer(
        @NonNull String channelTag, @NonNull Boolean enable, @NonNull Boolean applyToTeam);

    @NonNull
    Long setUpSpatializer(@NonNull String channelTag);

    @NonNull
    Long setSubscribeAudioBlocklist(
        @NonNull String channelTag, @NonNull List<Long> uidArray, @NonNull Long streamType);

    @NonNull
    Long setSubscribeAudioAllowlist(@NonNull String channelTag, @NonNull List<Long> uidArray);

    /** The codec used by ChannelApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return ChannelApiCodec.INSTANCE;
    }
    /** Sets up an instance of `ChannelApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable ChannelApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.getChannelName",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  String output = api.getChannelName(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setStatsEventCallback",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.setStatsEventCallback(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.clearStatsEventCallback",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.clearStatsEventCallback(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setChannelProfile",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number channelProfileArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setChannelProfile(
                          channelTagArg,
                          (channelProfileArg == null) ? null : channelProfileArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableMediaPub",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number mediaTypeArg = (Number) args.get(1);
                Boolean enableArg = (Boolean) args.get(2);
                try {
                  Long output =
                      api.enableMediaPub(
                          channelTagArg,
                          (mediaTypeArg == null) ? null : mediaTypeArg.longValue(),
                          enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.joinChannel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                JoinChannelRequest requestArg = (JoinChannelRequest) args.get(1);
                try {
                  Long output = api.joinChannel(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.leaveChannel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.leaveChannel(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setClientRole",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number roleArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setClientRole(
                          channelTagArg, (roleArg == null) ? null : roleArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.getConnectionState",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.getConnectionState(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.release",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.release(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                try {
                  Long output = api.enableLocalAudio(channelTagArg, enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.muteLocalAudioStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean muteArg = (Boolean) args.get(1);
                try {
                  Long output = api.muteLocalAudioStream(channelTagArg, muteArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number uidArg = (Number) args.get(1);
                Boolean subscribeArg = (Boolean) args.get(2);
                try {
                  Long output =
                      api.subscribeRemoteAudio(
                          channelTagArg,
                          (uidArg == null) ? null : uidArg.longValue(),
                          subscribeArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteSubAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number uidArg = (Number) args.get(1);
                Boolean subscribeArg = (Boolean) args.get(2);
                try {
                  Long output =
                      api.subscribeRemoteSubAudio(
                          channelTagArg,
                          (uidArg == null) ? null : uidArg.longValue(),
                          subscribeArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setLocalVideoConfig",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SetLocalVideoConfigRequest requestArg = (SetLocalVideoConfigRequest) args.get(1);
                try {
                  Long output = api.setLocalVideoConfig(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalVideo",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                EnableLocalVideoRequest requestArg = (EnableLocalVideoRequest) args.get(1);
                try {
                  Long output = api.enableLocalVideo(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.muteLocalVideoStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean muteArg = (Boolean) args.get(1);
                Number streamTypeArg = (Number) args.get(2);
                try {
                  Long output =
                      api.muteLocalVideoStream(
                          channelTagArg,
                          muteArg,
                          (streamTypeArg == null) ? null : streamTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.switchCamera",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.switchCamera(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteVideoStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SubscribeRemoteVideoStreamRequest requestArg =
                    (SubscribeRemoteVideoStreamRequest) args.get(1);
                try {
                  Long output = api.subscribeRemoteVideoStream(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteSubVideoStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number uidArg = (Number) args.get(1);
                Boolean subscribeArg = (Boolean) args.get(2);
                try {
                  Long output =
                      api.subscribeRemoteSubVideoStream(
                          channelTagArg,
                          (uidArg == null) ? null : uidArg.longValue(),
                          subscribeArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableAudioVolumeIndication",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                EnableAudioVolumeIndicationRequest requestArg =
                    (EnableAudioVolumeIndicationRequest) args.get(1);
                try {
                  Long output = api.enableAudioVolumeIndication(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.takeLocalSnapshot",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                String pathArg = (String) args.get(2);
                try {
                  Long output =
                      api.takeLocalSnapshot(
                          channelTagArg,
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          pathArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.takeRemoteSnapshot",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number uidArg = (Number) args.get(1);
                Number streamTypeArg = (Number) args.get(2);
                String pathArg = (String) args.get(3);
                try {
                  Long output =
                      api.takeRemoteSnapshot(
                          channelTagArg,
                          (uidArg == null) ? null : uidArg.longValue(),
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          pathArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeAllRemoteAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean subscribeArg = (Boolean) args.get(1);
                try {
                  Long output = api.subscribeAllRemoteAudio(channelTagArg, subscribeArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setCameraCaptureConfig",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SetCameraCaptureConfigRequest requestArg =
                    (SetCameraCaptureConfigRequest) args.get(1);
                try {
                  Long output = api.setCameraCaptureConfig(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setVideoStreamLayerCount",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number layerCountArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setVideoStreamLayerCount(
                          channelTagArg,
                          (layerCountArg == null) ? null : layerCountArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.getFeatureSupportedType",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number typeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.getFeatureSupportedType(
                          channelTagArg, (typeArg == null) ? null : typeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.switchCameraWithPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number positionArg = (Number) args.get(1);
                try {
                  Long output =
                      api.switchCameraWithPosition(
                          channelTagArg, (positionArg == null) ? null : positionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.startScreenCapture",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                StartScreenCaptureRequest requestArg = (StartScreenCaptureRequest) args.get(1);
                Result<Long> resultCallback =
                    new Result<Long>() {
                      public void success(Long result) {
                        wrapped.add(0, result);
                        reply.reply(wrapped);
                      }

                      public void error(Throwable error) {
                        ArrayList<Object> wrappedError = wrapError(error);
                        reply.reply(wrappedError);
                      }
                    };

                api.startScreenCapture(channelTagArg, requestArg, resultCallback);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.stopScreenCapture",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.stopScreenCapture(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLoopbackRecording",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                try {
                  Long output = api.enableLoopbackRecording(channelTagArg, enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.adjustLoopBackRecordingSignalVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number volumeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.adjustLoopBackRecordingSignalVolume(
                          channelTagArg, (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setExternalVideoSource",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                Boolean enableArg = (Boolean) args.get(2);
                try {
                  Long output =
                      api.setExternalVideoSource(
                          channelTagArg,
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.pushExternalVideoFrame",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                VideoFrame frameArg = (VideoFrame) args.get(2);
                try {
                  Long output =
                      api.pushExternalVideoFrame(
                          channelTagArg,
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.addLiveStreamTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                AddOrUpdateLiveStreamTaskRequest requestArg =
                    (AddOrUpdateLiveStreamTaskRequest) args.get(1);
                try {
                  Long output = api.addLiveStreamTask(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.updateLiveStreamTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                AddOrUpdateLiveStreamTaskRequest requestArg =
                    (AddOrUpdateLiveStreamTaskRequest) args.get(1);
                try {
                  Long output = api.updateLiveStreamTask(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.removeLiveStreamTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                DeleteLiveStreamTaskRequest requestArg = (DeleteLiveStreamTaskRequest) args.get(1);
                try {
                  Long output = api.removeLiveStreamTask(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.sendSEIMsg",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SendSEIMsgRequest requestArg = (SendSEIMsgRequest) args.get(1);
                try {
                  Long output = api.sendSEIMsg(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setLocalMediaPriority",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SetLocalMediaPriorityRequest requestArg =
                    (SetLocalMediaPriorityRequest) args.get(1);
                try {
                  Long output = api.setLocalMediaPriority(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.startChannelMediaRelay",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                StartOrUpdateChannelMediaRelayRequest requestArg =
                    (StartOrUpdateChannelMediaRelayRequest) args.get(1);
                try {
                  Long output = api.startChannelMediaRelay(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.updateChannelMediaRelay",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                StartOrUpdateChannelMediaRelayRequest requestArg =
                    (StartOrUpdateChannelMediaRelayRequest) args.get(1);
                try {
                  Long output = api.updateChannelMediaRelay(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.stopChannelMediaRelay",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.stopChannelMediaRelay(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.adjustUserPlaybackSignalVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                AdjustUserPlaybackSignalVolumeRequest requestArg =
                    (AdjustUserPlaybackSignalVolumeRequest) args.get(1);
                try {
                  Long output = api.adjustUserPlaybackSignalVolume(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setLocalPublishFallbackOption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number optionArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setLocalPublishFallbackOption(
                          channelTagArg, (optionArg == null) ? null : optionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setRemoteSubscribeFallbackOption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number optionArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setRemoteSubscribeFallbackOption(
                          channelTagArg, (optionArg == null) ? null : optionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableEncryption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                EnableEncryptionRequest requestArg = (EnableEncryptionRequest) args.get(1);
                try {
                  Long output = api.enableEncryption(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setRemoteHighPriorityAudioStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SetRemoteHighPriorityAudioStreamRequest requestArg =
                    (SetRemoteHighPriorityAudioStreamRequest) args.get(1);
                try {
                  Long output = api.setRemoteHighPriorityAudioStream(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setAudioSubscribeOnlyBy",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SetAudioSubscribeOnlyByRequest requestArg =
                    (SetAudioSubscribeOnlyByRequest) args.get(1);
                try {
                  Long output = api.setAudioSubscribeOnlyBy(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalSubStreamAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                try {
                  Long output = api.enableLocalSubStreamAudio(channelTagArg, enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalData",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean enabledArg = (Boolean) args.get(1);
                try {
                  Long output = api.enableLocalData(channelTagArg, enabledArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteData",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean subscribeArg = (Boolean) args.get(1);
                Number userIDArg = (Number) args.get(2);
                try {
                  Long output =
                      api.subscribeRemoteData(
                          channelTagArg,
                          subscribeArg,
                          (userIDArg == null) ? null : userIDArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.sendData",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                DataExternalFrame frameArg = (DataExternalFrame) args.get(1);
                try {
                  Long output = api.sendData(channelTagArg, frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.reportCustomEvent",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                ReportCustomEventRequest requestArg = (ReportCustomEventRequest) args.get(1);
                try {
                  Long output = api.reportCustomEvent(channelTagArg, requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setAudioRecvRange",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number audibleDistanceArg = (Number) args.get(1);
                Number conversationalDistanceArg = (Number) args.get(2);
                Number rollOffModeArg = (Number) args.get(3);
                try {
                  Long output =
                      api.setAudioRecvRange(
                          channelTagArg,
                          (audibleDistanceArg == null) ? null : audibleDistanceArg.longValue(),
                          (conversationalDistanceArg == null)
                              ? null
                              : conversationalDistanceArg.longValue(),
                          (rollOffModeArg == null) ? null : rollOffModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setRangeAudioMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number audioModeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setRangeAudioMode(
                          channelTagArg, (audioModeArg == null) ? null : audioModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setRangeAudioTeamID",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number teamIDArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setRangeAudioTeamID(
                          channelTagArg, (teamIDArg == null) ? null : teamIDArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.updateSelfPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                PositionInfo positionInfoArg = (PositionInfo) args.get(1);
                try {
                  Long output = api.updateSelfPosition(channelTagArg, positionInfoArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableSpatializerRoomEffects",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                try {
                  Long output = api.enableSpatializerRoomEffects(channelTagArg, enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setSpatializerRoomProperty",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                SpatializerRoomProperty propertyArg = (SpatializerRoomProperty) args.get(1);
                try {
                  Long output = api.setSpatializerRoomProperty(channelTagArg, propertyArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setSpatializerRenderMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Number renderModeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setSpatializerRenderMode(
                          channelTagArg,
                          (renderModeArg == null) ? null : renderModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableSpatializer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                Boolean applyToTeamArg = (Boolean) args.get(2);
                try {
                  Long output = api.enableSpatializer(channelTagArg, enableArg, applyToTeamArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setUpSpatializer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.setUpSpatializer(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setSubscribeAudioBlocklist",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                List<Long> uidArrayArg = (List<Long>) args.get(1);
                Number streamTypeArg = (Number) args.get(2);
                try {
                  Long output =
                      api.setSubscribeAudioBlocklist(
                          channelTagArg,
                          uidArrayArg,
                          (streamTypeArg == null) ? null : streamTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setSubscribeAudioAllowlist",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                List<Long> uidArrayArg = (List<Long>) args.get(1);
                try {
                  Long output = api.setSubscribeAudioAllowlist(channelTagArg, uidArrayArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }

  private static class EngineApiCodec extends StandardMessageCodec {
    public static final EngineApiCodec INSTANCE = new EngineApiCodec();

    private EngineApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return AddOrUpdateLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 129:
          return AdjustUserPlaybackSignalVolumeRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 130:
          return AudioExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 131:
          return AudioRecordingConfigurationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 132:
          return AudioVolumeInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 133:
          return CGPoint.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 134:
          return CreateEngineRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 135:
          return DataExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 136:
          return DeleteLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 137:
          return EnableAudioVolumeIndicationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 138:
          return EnableEncryptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 139:
          return EnableLocalVideoRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 140:
          return EnableVirtualBackgroundRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 141:
          return FirstVideoDataReceivedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 142:
          return FirstVideoFrameDecodedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 143:
          return JoinChannelOptions.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 144:
          return JoinChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 145:
          return LocalRecordingConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 146:
          return LocalRecordingLayoutConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 147:
          return LocalRecordingStreamInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 148:
          return NERtcLastmileProbeOneWayResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 149:
          return NERtcLastmileProbeResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 150:
          return NERtcUserJoinExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 151:
          return NERtcUserLeaveExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 152:
          return NERtcVersion.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 153:
          return PlayEffectRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 154:
          return PositionInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 155:
          return Rectangle.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 156:
          return RemoteAudioVolumeIndicationEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 157:
          return ReportCustomEventRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 158:
          return RtcServerAddresses.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 159:
          return ScreenCaptureSourceData.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 160:
          return SendSEIMsgRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 161:
          return SetAudioProfileRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 162:
          return SetAudioSubscribeOnlyByRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 163:
          return SetCameraCaptureConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 164:
          return SetCameraPositionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 165:
          return SetLocalMediaPriorityRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 166:
          return SetLocalVideoConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 167:
          return SetLocalVideoWatermarkConfigsRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 168:
          return SetLocalVoiceEqualizationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 169:
          return SetLocalVoiceReverbParamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 170:
          return SetMultiPathOptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 171:
          return SetRemoteHighPriorityAudioStreamRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 172:
          return SetVideoCorrectionConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 173:
          return SpatializerRoomProperty.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 174:
          return StartASRCaptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 175:
          return StartAudioMixingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 176:
          return StartAudioRecordingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 177:
          return StartLastmileProbeTestRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 178:
          return StartOrUpdateChannelMediaRelayRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 179:
          return StartPlayStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 180:
          return StartPushStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 181:
          return StartScreenCaptureRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 182:
          return StartorStopVideoPreviewRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 183:
          return StreamingRoomInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 184:
          return SubscribeRemoteAudioRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 185:
          return SubscribeRemoteSubStreamAudioRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 186:
          return SubscribeRemoteSubStreamVideoRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 187:
          return SubscribeRemoteVideoStreamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 188:
          return SwitchChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 189:
          return UserJoinedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 190:
          return UserLeaveEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 191:
          return UserVideoMuteEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 192:
          return VideoFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 193:
          return VideoWatermarkConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 194:
          return VideoWatermarkImageConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 195:
          return VideoWatermarkTextConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 196:
          return VideoWatermarkTimestampConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 197:
          return VirtualBackgroundSourceEnabledEvent.fromList(
              (ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof AddOrUpdateLiveStreamTaskRequest) {
        stream.write(128);
        writeValue(stream, ((AddOrUpdateLiveStreamTaskRequest) value).toList());
      } else if (value instanceof AdjustUserPlaybackSignalVolumeRequest) {
        stream.write(129);
        writeValue(stream, ((AdjustUserPlaybackSignalVolumeRequest) value).toList());
      } else if (value instanceof AudioExternalFrame) {
        stream.write(130);
        writeValue(stream, ((AudioExternalFrame) value).toList());
      } else if (value instanceof AudioRecordingConfigurationRequest) {
        stream.write(131);
        writeValue(stream, ((AudioRecordingConfigurationRequest) value).toList());
      } else if (value instanceof AudioVolumeInfo) {
        stream.write(132);
        writeValue(stream, ((AudioVolumeInfo) value).toList());
      } else if (value instanceof CGPoint) {
        stream.write(133);
        writeValue(stream, ((CGPoint) value).toList());
      } else if (value instanceof CreateEngineRequest) {
        stream.write(134);
        writeValue(stream, ((CreateEngineRequest) value).toList());
      } else if (value instanceof DataExternalFrame) {
        stream.write(135);
        writeValue(stream, ((DataExternalFrame) value).toList());
      } else if (value instanceof DeleteLiveStreamTaskRequest) {
        stream.write(136);
        writeValue(stream, ((DeleteLiveStreamTaskRequest) value).toList());
      } else if (value instanceof EnableAudioVolumeIndicationRequest) {
        stream.write(137);
        writeValue(stream, ((EnableAudioVolumeIndicationRequest) value).toList());
      } else if (value instanceof EnableEncryptionRequest) {
        stream.write(138);
        writeValue(stream, ((EnableEncryptionRequest) value).toList());
      } else if (value instanceof EnableLocalVideoRequest) {
        stream.write(139);
        writeValue(stream, ((EnableLocalVideoRequest) value).toList());
      } else if (value instanceof EnableVirtualBackgroundRequest) {
        stream.write(140);
        writeValue(stream, ((EnableVirtualBackgroundRequest) value).toList());
      } else if (value instanceof FirstVideoDataReceivedEvent) {
        stream.write(141);
        writeValue(stream, ((FirstVideoDataReceivedEvent) value).toList());
      } else if (value instanceof FirstVideoFrameDecodedEvent) {
        stream.write(142);
        writeValue(stream, ((FirstVideoFrameDecodedEvent) value).toList());
      } else if (value instanceof JoinChannelOptions) {
        stream.write(143);
        writeValue(stream, ((JoinChannelOptions) value).toList());
      } else if (value instanceof JoinChannelRequest) {
        stream.write(144);
        writeValue(stream, ((JoinChannelRequest) value).toList());
      } else if (value instanceof LocalRecordingConfig) {
        stream.write(145);
        writeValue(stream, ((LocalRecordingConfig) value).toList());
      } else if (value instanceof LocalRecordingLayoutConfig) {
        stream.write(146);
        writeValue(stream, ((LocalRecordingLayoutConfig) value).toList());
      } else if (value instanceof LocalRecordingStreamInfo) {
        stream.write(147);
        writeValue(stream, ((LocalRecordingStreamInfo) value).toList());
      } else if (value instanceof NERtcLastmileProbeOneWayResult) {
        stream.write(148);
        writeValue(stream, ((NERtcLastmileProbeOneWayResult) value).toList());
      } else if (value instanceof NERtcLastmileProbeResult) {
        stream.write(149);
        writeValue(stream, ((NERtcLastmileProbeResult) value).toList());
      } else if (value instanceof NERtcUserJoinExtraInfo) {
        stream.write(150);
        writeValue(stream, ((NERtcUserJoinExtraInfo) value).toList());
      } else if (value instanceof NERtcUserLeaveExtraInfo) {
        stream.write(151);
        writeValue(stream, ((NERtcUserLeaveExtraInfo) value).toList());
      } else if (value instanceof NERtcVersion) {
        stream.write(152);
        writeValue(stream, ((NERtcVersion) value).toList());
      } else if (value instanceof PlayEffectRequest) {
        stream.write(153);
        writeValue(stream, ((PlayEffectRequest) value).toList());
      } else if (value instanceof PositionInfo) {
        stream.write(154);
        writeValue(stream, ((PositionInfo) value).toList());
      } else if (value instanceof Rectangle) {
        stream.write(155);
        writeValue(stream, ((Rectangle) value).toList());
      } else if (value instanceof RemoteAudioVolumeIndicationEvent) {
        stream.write(156);
        writeValue(stream, ((RemoteAudioVolumeIndicationEvent) value).toList());
      } else if (value instanceof ReportCustomEventRequest) {
        stream.write(157);
        writeValue(stream, ((ReportCustomEventRequest) value).toList());
      } else if (value instanceof RtcServerAddresses) {
        stream.write(158);
        writeValue(stream, ((RtcServerAddresses) value).toList());
      } else if (value instanceof ScreenCaptureSourceData) {
        stream.write(159);
        writeValue(stream, ((ScreenCaptureSourceData) value).toList());
      } else if (value instanceof SendSEIMsgRequest) {
        stream.write(160);
        writeValue(stream, ((SendSEIMsgRequest) value).toList());
      } else if (value instanceof SetAudioProfileRequest) {
        stream.write(161);
        writeValue(stream, ((SetAudioProfileRequest) value).toList());
      } else if (value instanceof SetAudioSubscribeOnlyByRequest) {
        stream.write(162);
        writeValue(stream, ((SetAudioSubscribeOnlyByRequest) value).toList());
      } else if (value instanceof SetCameraCaptureConfigRequest) {
        stream.write(163);
        writeValue(stream, ((SetCameraCaptureConfigRequest) value).toList());
      } else if (value instanceof SetCameraPositionRequest) {
        stream.write(164);
        writeValue(stream, ((SetCameraPositionRequest) value).toList());
      } else if (value instanceof SetLocalMediaPriorityRequest) {
        stream.write(165);
        writeValue(stream, ((SetLocalMediaPriorityRequest) value).toList());
      } else if (value instanceof SetLocalVideoConfigRequest) {
        stream.write(166);
        writeValue(stream, ((SetLocalVideoConfigRequest) value).toList());
      } else if (value instanceof SetLocalVideoWatermarkConfigsRequest) {
        stream.write(167);
        writeValue(stream, ((SetLocalVideoWatermarkConfigsRequest) value).toList());
      } else if (value instanceof SetLocalVoiceEqualizationRequest) {
        stream.write(168);
        writeValue(stream, ((SetLocalVoiceEqualizationRequest) value).toList());
      } else if (value instanceof SetLocalVoiceReverbParamRequest) {
        stream.write(169);
        writeValue(stream, ((SetLocalVoiceReverbParamRequest) value).toList());
      } else if (value instanceof SetMultiPathOptionRequest) {
        stream.write(170);
        writeValue(stream, ((SetMultiPathOptionRequest) value).toList());
      } else if (value instanceof SetRemoteHighPriorityAudioStreamRequest) {
        stream.write(171);
        writeValue(stream, ((SetRemoteHighPriorityAudioStreamRequest) value).toList());
      } else if (value instanceof SetVideoCorrectionConfigRequest) {
        stream.write(172);
        writeValue(stream, ((SetVideoCorrectionConfigRequest) value).toList());
      } else if (value instanceof SpatializerRoomProperty) {
        stream.write(173);
        writeValue(stream, ((SpatializerRoomProperty) value).toList());
      } else if (value instanceof StartASRCaptionRequest) {
        stream.write(174);
        writeValue(stream, ((StartASRCaptionRequest) value).toList());
      } else if (value instanceof StartAudioMixingRequest) {
        stream.write(175);
        writeValue(stream, ((StartAudioMixingRequest) value).toList());
      } else if (value instanceof StartAudioRecordingRequest) {
        stream.write(176);
        writeValue(stream, ((StartAudioRecordingRequest) value).toList());
      } else if (value instanceof StartLastmileProbeTestRequest) {
        stream.write(177);
        writeValue(stream, ((StartLastmileProbeTestRequest) value).toList());
      } else if (value instanceof StartOrUpdateChannelMediaRelayRequest) {
        stream.write(178);
        writeValue(stream, ((StartOrUpdateChannelMediaRelayRequest) value).toList());
      } else if (value instanceof StartPlayStreamingRequest) {
        stream.write(179);
        writeValue(stream, ((StartPlayStreamingRequest) value).toList());
      } else if (value instanceof StartPushStreamingRequest) {
        stream.write(180);
        writeValue(stream, ((StartPushStreamingRequest) value).toList());
      } else if (value instanceof StartScreenCaptureRequest) {
        stream.write(181);
        writeValue(stream, ((StartScreenCaptureRequest) value).toList());
      } else if (value instanceof StartorStopVideoPreviewRequest) {
        stream.write(182);
        writeValue(stream, ((StartorStopVideoPreviewRequest) value).toList());
      } else if (value instanceof StreamingRoomInfo) {
        stream.write(183);
        writeValue(stream, ((StreamingRoomInfo) value).toList());
      } else if (value instanceof SubscribeRemoteAudioRequest) {
        stream.write(184);
        writeValue(stream, ((SubscribeRemoteAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamAudioRequest) {
        stream.write(185);
        writeValue(stream, ((SubscribeRemoteSubStreamAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamVideoRequest) {
        stream.write(186);
        writeValue(stream, ((SubscribeRemoteSubStreamVideoRequest) value).toList());
      } else if (value instanceof SubscribeRemoteVideoStreamRequest) {
        stream.write(187);
        writeValue(stream, ((SubscribeRemoteVideoStreamRequest) value).toList());
      } else if (value instanceof SwitchChannelRequest) {
        stream.write(188);
        writeValue(stream, ((SwitchChannelRequest) value).toList());
      } else if (value instanceof UserJoinedEvent) {
        stream.write(189);
        writeValue(stream, ((UserJoinedEvent) value).toList());
      } else if (value instanceof UserLeaveEvent) {
        stream.write(190);
        writeValue(stream, ((UserLeaveEvent) value).toList());
      } else if (value instanceof UserVideoMuteEvent) {
        stream.write(191);
        writeValue(stream, ((UserVideoMuteEvent) value).toList());
      } else if (value instanceof VideoFrame) {
        stream.write(192);
        writeValue(stream, ((VideoFrame) value).toList());
      } else if (value instanceof VideoWatermarkConfig) {
        stream.write(193);
        writeValue(stream, ((VideoWatermarkConfig) value).toList());
      } else if (value instanceof VideoWatermarkImageConfig) {
        stream.write(194);
        writeValue(stream, ((VideoWatermarkImageConfig) value).toList());
      } else if (value instanceof VideoWatermarkTextConfig) {
        stream.write(195);
        writeValue(stream, ((VideoWatermarkTextConfig) value).toList());
      } else if (value instanceof VideoWatermarkTimestampConfig) {
        stream.write(196);
        writeValue(stream, ((VideoWatermarkTimestampConfig) value).toList());
      } else if (value instanceof VirtualBackgroundSourceEnabledEvent) {
        stream.write(197);
        writeValue(stream, ((VirtualBackgroundSourceEnabledEvent) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface EngineApi {

    @NonNull
    Long create(@NonNull CreateEngineRequest request);

    @NonNull
    Long createChannel(@NonNull String channelTag);

    @NonNull
    NERtcVersion version();

    @Nullable
    List<String> checkPermission();

    @NonNull
    Long setParameters(@NonNull Map<String, Object> params);

    void release(@NonNull Result<Long> result);

    @NonNull
    Long setStatsEventCallback();

    @NonNull
    Long clearStatsEventCallback();

    @NonNull
    Long setChannelProfile(@NonNull Long channelProfile);

    @NonNull
    Long joinChannel(@NonNull JoinChannelRequest request);

    @NonNull
    Long leaveChannel();

    @NonNull
    Long updatePermissionKey(@NonNull String key);

    @NonNull
    Long enableLocalAudio(@NonNull Boolean enable);

    @NonNull
    Long subscribeRemoteAudio(@NonNull SubscribeRemoteAudioRequest request);

    @NonNull
    Long subscribeAllRemoteAudio(@NonNull Boolean subscribe);

    @NonNull
    Long setAudioProfile(@NonNull SetAudioProfileRequest request);

    @NonNull
    Long enableDualStreamMode(@NonNull Boolean enable);

    @NonNull
    Long setLocalVideoConfig(@NonNull SetLocalVideoConfigRequest request);

    @NonNull
    Long setCameraCaptureConfig(@NonNull SetCameraCaptureConfigRequest request);

    @NonNull
    Long setVideoRotationMode(@NonNull Long rotationMode);

    @NonNull
    Long startVideoPreview(@NonNull StartorStopVideoPreviewRequest request);

    @NonNull
    Long stopVideoPreview(@NonNull StartorStopVideoPreviewRequest request);

    @NonNull
    Long enableLocalVideo(@NonNull EnableLocalVideoRequest request);

    @NonNull
    Long enableLocalSubStreamAudio(@NonNull Boolean enable);

    @NonNull
    Long subscribeRemoteSubStreamAudio(@NonNull SubscribeRemoteSubStreamAudioRequest request);

    @NonNull
    Long muteLocalSubStreamAudio(@NonNull Boolean muted);

    @NonNull
    Long setAudioSubscribeOnlyBy(@NonNull SetAudioSubscribeOnlyByRequest request);

    void startScreenCapture(
        @NonNull StartScreenCaptureRequest request, @NonNull Result<Long> result);

    @NonNull
    Long stopScreenCapture();

    @NonNull
    Long enableLoopbackRecording(@NonNull Boolean enable);

    @NonNull
    Long subscribeRemoteVideoStream(@NonNull SubscribeRemoteVideoStreamRequest request);

    @NonNull
    Long subscribeRemoteSubStreamVideo(@NonNull SubscribeRemoteSubStreamVideoRequest request);

    @NonNull
    Long muteLocalAudioStream(@NonNull Boolean mute);

    @NonNull
    Long muteLocalVideoStream(@NonNull Boolean mute, @NonNull Long streamType);

    @NonNull
    Long startAudioDump();

    @NonNull
    Long startAudioDumpWithType(@NonNull Long dumpType);

    @NonNull
    Long stopAudioDump();

    @NonNull
    Long enableAudioVolumeIndication(@NonNull EnableAudioVolumeIndicationRequest request);

    @NonNull
    Long adjustRecordingSignalVolume(@NonNull Long volume);

    @NonNull
    Long adjustPlaybackSignalVolume(@NonNull Long volume);

    @NonNull
    Long adjustLoopBackRecordingSignalVolume(@NonNull Long volume);

    @NonNull
    Long addLiveStreamTask(@NonNull AddOrUpdateLiveStreamTaskRequest request);

    @NonNull
    Long updateLiveStreamTask(@NonNull AddOrUpdateLiveStreamTaskRequest request);

    @NonNull
    Long removeLiveStreamTask(@NonNull DeleteLiveStreamTaskRequest request);

    @NonNull
    Long setClientRole(@NonNull Long role);

    @NonNull
    Long getConnectionState();

    @NonNull
    Long uploadSdkInfo();

    @NonNull
    Long sendSEIMsg(@NonNull SendSEIMsgRequest request);

    @NonNull
    Long setLocalVoiceReverbParam(@NonNull SetLocalVoiceReverbParamRequest request);

    @NonNull
    Long setAudioEffectPreset(@NonNull Long preset);

    @NonNull
    Long setVoiceBeautifierPreset(@NonNull Long preset);

    @NonNull
    Long setLocalVoicePitch(@NonNull Double pitch);

    @NonNull
    Long setLocalVoiceEqualization(@NonNull SetLocalVoiceEqualizationRequest request);

    @NonNull
    Long switchChannel(@NonNull SwitchChannelRequest request);

    @NonNull
    Long startAudioRecording(@NonNull StartAudioRecordingRequest request);

    @NonNull
    Long startAudioRecordingWithConfig(@NonNull AudioRecordingConfigurationRequest request);

    @NonNull
    Long stopAudioRecording();

    @NonNull
    Long setLocalMediaPriority(@NonNull SetLocalMediaPriorityRequest request);

    @NonNull
    Long enableMediaPub(@NonNull Long mediaType, @NonNull Boolean enable);

    @NonNull
    Long startChannelMediaRelay(@NonNull StartOrUpdateChannelMediaRelayRequest request);

    @NonNull
    Long updateChannelMediaRelay(@NonNull StartOrUpdateChannelMediaRelayRequest request);

    @NonNull
    Long stopChannelMediaRelay();

    @NonNull
    Long adjustUserPlaybackSignalVolume(@NonNull AdjustUserPlaybackSignalVolumeRequest request);

    @NonNull
    Long setLocalPublishFallbackOption(@NonNull Long option);

    @NonNull
    Long setRemoteSubscribeFallbackOption(@NonNull Long option);

    @NonNull
    Long enableSuperResolution(@NonNull Boolean enable);

    @NonNull
    Long enableEncryption(@NonNull EnableEncryptionRequest request);

    @NonNull
    Long setAudioSessionOperationRestriction(@NonNull Long option);

    @NonNull
    Long enableVideoCorrection(@NonNull Boolean enable);

    @NonNull
    Long reportCustomEvent(@NonNull ReportCustomEventRequest request);

    @NonNull
    Long getEffectDuration(@NonNull Long effectId);

    @NonNull
    Long startLastmileProbeTest(@NonNull StartLastmileProbeTestRequest request);

    @NonNull
    Long stopLastmileProbeTest();

    @NonNull
    Long setVideoCorrectionConfig(@NonNull SetVideoCorrectionConfigRequest request);

    @NonNull
    Long enableVirtualBackground(@NonNull EnableVirtualBackgroundRequest request);

    @NonNull
    Long setRemoteHighPriorityAudioStream(@NonNull SetRemoteHighPriorityAudioStreamRequest request);

    @NonNull
    Long setCloudProxy(@NonNull Long proxyType);

    @NonNull
    Long startBeauty();

    void stopBeauty();

    @NonNull
    Long enableBeauty(@NonNull Boolean enabled);

    @NonNull
    Long setBeautyEffect(@NonNull Double level, @NonNull Long beautyType);

    @NonNull
    Long addBeautyFilter(@NonNull String path, @NonNull String name);

    void removeBeautyFilter();

    @NonNull
    Long setBeautyFilterLevel(@NonNull Double level);

    @NonNull
    Long setLocalVideoWatermarkConfigs(@NonNull SetLocalVideoWatermarkConfigsRequest request);

    @NonNull
    Long setStreamAlignmentProperty(@NonNull Boolean enable);

    @NonNull
    Long getNtpTimeOffset();

    @NonNull
    Long takeLocalSnapshot(@NonNull Long streamType, @NonNull String path);

    @NonNull
    Long takeRemoteSnapshot(@NonNull Long uid, @NonNull Long streamType, @NonNull String path);

    @NonNull
    Long setExternalVideoSource(@NonNull Long streamType, @NonNull Boolean enable);

    @NonNull
    Long pushExternalVideoFrame(@NonNull Long streamType, @NonNull VideoFrame frame);

    @NonNull
    Long setVideoDump(@NonNull Long dumpType);

    @NonNull
    String getParameter(@NonNull String key, @NonNull String extraInfo);

    @NonNull
    Long setVideoStreamLayerCount(@NonNull Long layerCount);

    @NonNull
    Long enableLocalData(@NonNull Boolean enabled);

    @NonNull
    Long subscribeRemoteData(@NonNull Boolean subscribe, @NonNull Long userID);

    @NonNull
    Long getFeatureSupportedType(@NonNull Long type);

    @NonNull
    Boolean isFeatureSupported(@NonNull Long type);

    @NonNull
    Long setSubscribeAudioBlocklist(@NonNull List<Long> uidArray, @NonNull Long streamType);

    @NonNull
    Long setSubscribeAudioAllowlist(@NonNull List<Long> uidArray);

    @NonNull
    Long getNetworkType();

    @NonNull
    Long startPushStreaming(@NonNull StartPushStreamingRequest request);

    @NonNull
    Long startPlayStreaming(@NonNull StartPlayStreamingRequest request);

    @NonNull
    Long stopPushStreaming();

    @NonNull
    Long stopPlayStreaming(@NonNull String streamId);

    @NonNull
    Long pausePlayStreaming(@NonNull String streamId);

    @NonNull
    Long resumePlayStreaming(@NonNull String streamId);

    @NonNull
    Long muteVideoForPlayStreaming(@NonNull String streamId, @NonNull Boolean mute);

    @NonNull
    Long muteAudioForPlayStreaming(@NonNull String streamId, @NonNull Boolean mute);

    @NonNull
    Long startASRCaption(@NonNull StartASRCaptionRequest request);

    @NonNull
    Long stopASRCaption();

    @NonNull
    Long setMultiPathOption(@NonNull SetMultiPathOptionRequest request);

    @NonNull
    Long aiManualInterrupt(@NonNull Long dstUid);

    @NonNull
    Long AINSMode(@NonNull Long mode);

    @NonNull
    Long setAudioScenario(@NonNull Long scenario);

    @NonNull
    Long setExternalAudioSource(
        @NonNull Boolean enabled, @NonNull Long sampleRate, @NonNull Long channels);

    @NonNull
    Long setExternalSubStreamAudioSource(
        @NonNull Boolean enabled, @NonNull Long sampleRate, @NonNull Long channels);

    @NonNull
    Long setAudioRecvRange(
        @NonNull Long audibleDistance,
        @NonNull Long conversationalDistance,
        @NonNull Long rollOffMode);

    @NonNull
    Long setRangeAudioMode(@NonNull Long audioMode);

    @NonNull
    Long setRangeAudioTeamID(@NonNull Long teamID);

    @NonNull
    Long updateSelfPosition(@NonNull PositionInfo positionInfo);

    @NonNull
    Long enableSpatializerRoomEffects(@NonNull Boolean enable);

    @NonNull
    Long setSpatializerRoomProperty(@NonNull SpatializerRoomProperty property);

    @NonNull
    Long setSpatializerRenderMode(@NonNull Long renderMode);

    @NonNull
    Long enableSpatializer(@NonNull Boolean enable, @NonNull Boolean applyToTeam);

    @NonNull
    Long setUpSpatializer();

    @NonNull
    Long addLocalRecordStreamForTask(@NonNull LocalRecordingConfig config, @NonNull String taskId);

    @NonNull
    Long removeLocalRecorderStreamForTask(@NonNull String taskId);

    @NonNull
    Long addLocalRecorderStreamLayoutForTask(
        @NonNull LocalRecordingLayoutConfig config,
        @NonNull Long uid,
        @NonNull Long streamType,
        @NonNull Long streamLayer,
        @NonNull Long taskId);

    @NonNull
    Long removeLocalRecorderStreamLayoutForTask(
        @NonNull Long uid,
        @NonNull Long streamType,
        @NonNull Long streamLayer,
        @NonNull String taskId);

    @NonNull
    Long updateLocalRecorderStreamLayoutForTask(
        @NonNull List<LocalRecordingStreamInfo> infos, @NonNull String taskId);

    @NonNull
    Long replaceLocalRecorderStreamLayoutForTask(
        @NonNull List<LocalRecordingStreamInfo> infos, @NonNull String taskId);

    @NonNull
    Long updateLocalRecorderWaterMarksForTask(
        @NonNull List<VideoWatermarkConfig> watermarks, @NonNull String taskId);

    @NonNull
    Long pushLocalRecorderVideoFrameForTask(
        @NonNull Long uid,
        @NonNull Long streamType,
        @NonNull Long streamLayer,
        @NonNull String taskId,
        @NonNull VideoFrame frame);

    @NonNull
    Long showLocalRecorderStreamDefaultCoverForTask(
        @NonNull Boolean showEnabled,
        @NonNull Long uid,
        @NonNull Long streamType,
        @NonNull Long streamLayer,
        @NonNull String taskId);

    @NonNull
    Long stopLocalRecorderRemuxMp4(@NonNull String taskId);

    @NonNull
    Long remuxFlvToMp4(@NonNull String flvPath, @NonNull String mp4Path, @NonNull Boolean saveOri);

    @NonNull
    Long stopRemuxFlvToMp4();

    @NonNull
    Long sendData(@NonNull DataExternalFrame frame);

    @NonNull
    Long pushExternalAudioFrame(@NonNull AudioExternalFrame frame);

    @NonNull
    Long pushExternalSubAudioFrame(@NonNull AudioExternalFrame frame);

    /** The codec used by EngineApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return EngineApiCodec.INSTANCE;
    }
    /** Sets up an instance of `EngineApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable EngineApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.create",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                CreateEngineRequest requestArg = (CreateEngineRequest) args.get(0);
                try {
                  Long output = api.create(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.createChannel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String channelTagArg = (String) args.get(0);
                try {
                  Long output = api.createChannel(channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.version",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  NERtcVersion output = api.version();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.checkPermission",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  List<String> output = api.checkPermission();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setParameters",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Map<String, Object> paramsArg = (Map<String, Object>) args.get(0);
                try {
                  Long output = api.setParameters(paramsArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.release",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                Result<Long> resultCallback =
                    new Result<Long>() {
                      public void success(Long result) {
                        wrapped.add(0, result);
                        reply.reply(wrapped);
                      }

                      public void error(Throwable error) {
                        ArrayList<Object> wrappedError = wrapError(error);
                        reply.reply(wrappedError);
                      }
                    };

                api.release(resultCallback);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setStatsEventCallback",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.setStatsEventCallback();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.clearStatsEventCallback",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.clearStatsEventCallback();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setChannelProfile",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number channelProfileArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setChannelProfile(
                          (channelProfileArg == null) ? null : channelProfileArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.joinChannel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                JoinChannelRequest requestArg = (JoinChannelRequest) args.get(0);
                try {
                  Long output = api.joinChannel(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.leaveChannel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.leaveChannel();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updatePermissionKey",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String keyArg = (String) args.get(0);
                try {
                  Long output = api.updatePermissionKey(keyArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableLocalAudio(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SubscribeRemoteAudioRequest requestArg = (SubscribeRemoteAudioRequest) args.get(0);
                try {
                  Long output = api.subscribeRemoteAudio(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeAllRemoteAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean subscribeArg = (Boolean) args.get(0);
                try {
                  Long output = api.subscribeAllRemoteAudio(subscribeArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioProfile",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetAudioProfileRequest requestArg = (SetAudioProfileRequest) args.get(0);
                try {
                  Long output = api.setAudioProfile(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableDualStreamMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableDualStreamMode(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVideoConfig",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetLocalVideoConfigRequest requestArg = (SetLocalVideoConfigRequest) args.get(0);
                try {
                  Long output = api.setLocalVideoConfig(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setCameraCaptureConfig",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetCameraCaptureConfigRequest requestArg =
                    (SetCameraCaptureConfigRequest) args.get(0);
                try {
                  Long output = api.setCameraCaptureConfig(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVideoRotationMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number rotationModeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setVideoRotationMode(
                          (rotationModeArg == null) ? null : rotationModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startVideoPreview",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartorStopVideoPreviewRequest requestArg =
                    (StartorStopVideoPreviewRequest) args.get(0);
                try {
                  Long output = api.startVideoPreview(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopVideoPreview",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartorStopVideoPreviewRequest requestArg =
                    (StartorStopVideoPreviewRequest) args.get(0);
                try {
                  Long output = api.stopVideoPreview(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalVideo",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                EnableLocalVideoRequest requestArg = (EnableLocalVideoRequest) args.get(0);
                try {
                  Long output = api.enableLocalVideo(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalSubStreamAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableLocalSubStreamAudio(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteSubStreamAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SubscribeRemoteSubStreamAudioRequest requestArg =
                    (SubscribeRemoteSubStreamAudioRequest) args.get(0);
                try {
                  Long output = api.subscribeRemoteSubStreamAudio(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteLocalSubStreamAudio",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean mutedArg = (Boolean) args.get(0);
                try {
                  Long output = api.muteLocalSubStreamAudio(mutedArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioSubscribeOnlyBy",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetAudioSubscribeOnlyByRequest requestArg =
                    (SetAudioSubscribeOnlyByRequest) args.get(0);
                try {
                  Long output = api.setAudioSubscribeOnlyBy(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startScreenCapture",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartScreenCaptureRequest requestArg = (StartScreenCaptureRequest) args.get(0);
                Result<Long> resultCallback =
                    new Result<Long>() {
                      public void success(Long result) {
                        wrapped.add(0, result);
                        reply.reply(wrapped);
                      }

                      public void error(Throwable error) {
                        ArrayList<Object> wrappedError = wrapError(error);
                        reply.reply(wrappedError);
                      }
                    };

                api.startScreenCapture(requestArg, resultCallback);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopScreenCapture",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopScreenCapture();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLoopbackRecording",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableLoopbackRecording(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteVideoStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SubscribeRemoteVideoStreamRequest requestArg =
                    (SubscribeRemoteVideoStreamRequest) args.get(0);
                try {
                  Long output = api.subscribeRemoteVideoStream(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteSubStreamVideo",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SubscribeRemoteSubStreamVideoRequest requestArg =
                    (SubscribeRemoteSubStreamVideoRequest) args.get(0);
                try {
                  Long output = api.subscribeRemoteSubStreamVideo(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteLocalAudioStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean muteArg = (Boolean) args.get(0);
                try {
                  Long output = api.muteLocalAudioStream(muteArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteLocalVideoStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean muteArg = (Boolean) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.muteLocalVideoStream(
                          muteArg, (streamTypeArg == null) ? null : streamTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioDump",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.startAudioDump();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioDumpWithType",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number dumpTypeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.startAudioDumpWithType(
                          (dumpTypeArg == null) ? null : dumpTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopAudioDump",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopAudioDump();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableAudioVolumeIndication",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                EnableAudioVolumeIndicationRequest requestArg =
                    (EnableAudioVolumeIndicationRequest) args.get(0);
                try {
                  Long output = api.enableAudioVolumeIndication(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.adjustRecordingSignalVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number volumeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.adjustRecordingSignalVolume(
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.adjustPlaybackSignalVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number volumeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.adjustPlaybackSignalVolume(
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.adjustLoopBackRecordingSignalVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number volumeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.adjustLoopBackRecordingSignalVolume(
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.addLiveStreamTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                AddOrUpdateLiveStreamTaskRequest requestArg =
                    (AddOrUpdateLiveStreamTaskRequest) args.get(0);
                try {
                  Long output = api.addLiveStreamTask(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateLiveStreamTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                AddOrUpdateLiveStreamTaskRequest requestArg =
                    (AddOrUpdateLiveStreamTaskRequest) args.get(0);
                try {
                  Long output = api.updateLiveStreamTask(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.removeLiveStreamTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                DeleteLiveStreamTaskRequest requestArg = (DeleteLiveStreamTaskRequest) args.get(0);
                try {
                  Long output = api.removeLiveStreamTask(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setClientRole",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number roleArg = (Number) args.get(0);
                try {
                  Long output = api.setClientRole((roleArg == null) ? null : roleArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getConnectionState",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getConnectionState();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.uploadSdkInfo",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.uploadSdkInfo();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.sendSEIMsg",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SendSEIMsgRequest requestArg = (SendSEIMsgRequest) args.get(0);
                try {
                  Long output = api.sendSEIMsg(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVoiceReverbParam",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetLocalVoiceReverbParamRequest requestArg =
                    (SetLocalVoiceReverbParamRequest) args.get(0);
                try {
                  Long output = api.setLocalVoiceReverbParam(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioEffectPreset",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number presetArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioEffectPreset((presetArg == null) ? null : presetArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVoiceBeautifierPreset",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number presetArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setVoiceBeautifierPreset(
                          (presetArg == null) ? null : presetArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVoicePitch",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Double pitchArg = (Double) args.get(0);
                try {
                  Long output = api.setLocalVoicePitch(pitchArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVoiceEqualization",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetLocalVoiceEqualizationRequest requestArg =
                    (SetLocalVoiceEqualizationRequest) args.get(0);
                try {
                  Long output = api.setLocalVoiceEqualization(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.switchChannel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SwitchChannelRequest requestArg = (SwitchChannelRequest) args.get(0);
                try {
                  Long output = api.switchChannel(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioRecording",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartAudioRecordingRequest requestArg = (StartAudioRecordingRequest) args.get(0);
                try {
                  Long output = api.startAudioRecording(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioRecordingWithConfig",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                AudioRecordingConfigurationRequest requestArg =
                    (AudioRecordingConfigurationRequest) args.get(0);
                try {
                  Long output = api.startAudioRecordingWithConfig(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopAudioRecording",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopAudioRecording();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalMediaPriority",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetLocalMediaPriorityRequest requestArg =
                    (SetLocalMediaPriorityRequest) args.get(0);
                try {
                  Long output = api.setLocalMediaPriority(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableMediaPub",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number mediaTypeArg = (Number) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                try {
                  Long output =
                      api.enableMediaPub(
                          (mediaTypeArg == null) ? null : mediaTypeArg.longValue(), enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startChannelMediaRelay",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartOrUpdateChannelMediaRelayRequest requestArg =
                    (StartOrUpdateChannelMediaRelayRequest) args.get(0);
                try {
                  Long output = api.startChannelMediaRelay(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateChannelMediaRelay",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartOrUpdateChannelMediaRelayRequest requestArg =
                    (StartOrUpdateChannelMediaRelayRequest) args.get(0);
                try {
                  Long output = api.updateChannelMediaRelay(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopChannelMediaRelay",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopChannelMediaRelay();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.adjustUserPlaybackSignalVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                AdjustUserPlaybackSignalVolumeRequest requestArg =
                    (AdjustUserPlaybackSignalVolumeRequest) args.get(0);
                try {
                  Long output = api.adjustUserPlaybackSignalVolume(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalPublishFallbackOption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number optionArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setLocalPublishFallbackOption(
                          (optionArg == null) ? null : optionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setRemoteSubscribeFallbackOption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number optionArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setRemoteSubscribeFallbackOption(
                          (optionArg == null) ? null : optionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableSuperResolution",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableSuperResolution(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableEncryption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                EnableEncryptionRequest requestArg = (EnableEncryptionRequest) args.get(0);
                try {
                  Long output = api.enableEncryption(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioSessionOperationRestriction",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number optionArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioSessionOperationRestriction(
                          (optionArg == null) ? null : optionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableVideoCorrection",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableVideoCorrection(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.reportCustomEvent",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                ReportCustomEventRequest requestArg = (ReportCustomEventRequest) args.get(0);
                try {
                  Long output = api.reportCustomEvent(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getEffectDuration",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getEffectDuration((effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startLastmileProbeTest",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartLastmileProbeTestRequest requestArg =
                    (StartLastmileProbeTestRequest) args.get(0);
                try {
                  Long output = api.startLastmileProbeTest(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopLastmileProbeTest",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopLastmileProbeTest();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVideoCorrectionConfig",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetVideoCorrectionConfigRequest requestArg =
                    (SetVideoCorrectionConfigRequest) args.get(0);
                try {
                  Long output = api.setVideoCorrectionConfig(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableVirtualBackground",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                EnableVirtualBackgroundRequest requestArg =
                    (EnableVirtualBackgroundRequest) args.get(0);
                try {
                  Long output = api.enableVirtualBackground(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setRemoteHighPriorityAudioStream",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetRemoteHighPriorityAudioStreamRequest requestArg =
                    (SetRemoteHighPriorityAudioStreamRequest) args.get(0);
                try {
                  Long output = api.setRemoteHighPriorityAudioStream(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setCloudProxy",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number proxyTypeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setCloudProxy((proxyTypeArg == null) ? null : proxyTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startBeauty",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.startBeauty();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopBeauty",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  api.stopBeauty();
                  wrapped.add(0, null);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableBeauty",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enabledArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableBeauty(enabledArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setBeautyEffect",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Double levelArg = (Double) args.get(0);
                Number beautyTypeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setBeautyEffect(
                          levelArg, (beautyTypeArg == null) ? null : beautyTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.addBeautyFilter",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String pathArg = (String) args.get(0);
                String nameArg = (String) args.get(1);
                try {
                  Long output = api.addBeautyFilter(pathArg, nameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.removeBeautyFilter",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  api.removeBeautyFilter();
                  wrapped.add(0, null);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setBeautyFilterLevel",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Double levelArg = (Double) args.get(0);
                try {
                  Long output = api.setBeautyFilterLevel(levelArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVideoWatermarkConfigs",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetLocalVideoWatermarkConfigsRequest requestArg =
                    (SetLocalVideoWatermarkConfigsRequest) args.get(0);
                try {
                  Long output = api.setLocalVideoWatermarkConfigs(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setStreamAlignmentProperty",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.setStreamAlignmentProperty(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getNtpTimeOffset",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getNtpTimeOffset();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.takeLocalSnapshot",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number streamTypeArg = (Number) args.get(0);
                String pathArg = (String) args.get(1);
                try {
                  Long output =
                      api.takeLocalSnapshot(
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(), pathArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.takeRemoteSnapshot",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number uidArg = (Number) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                String pathArg = (String) args.get(2);
                try {
                  Long output =
                      api.takeRemoteSnapshot(
                          (uidArg == null) ? null : uidArg.longValue(),
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          pathArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setExternalVideoSource",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number streamTypeArg = (Number) args.get(0);
                Boolean enableArg = (Boolean) args.get(1);
                try {
                  Long output =
                      api.setExternalVideoSource(
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(), enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pushExternalVideoFrame",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number streamTypeArg = (Number) args.get(0);
                VideoFrame frameArg = (VideoFrame) args.get(1);
                try {
                  Long output =
                      api.pushExternalVideoFrame(
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(), frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVideoDump",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number dumpTypeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setVideoDump((dumpTypeArg == null) ? null : dumpTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getParameter",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String keyArg = (String) args.get(0);
                String extraInfoArg = (String) args.get(1);
                try {
                  String output = api.getParameter(keyArg, extraInfoArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVideoStreamLayerCount",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number layerCountArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setVideoStreamLayerCount(
                          (layerCountArg == null) ? null : layerCountArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalData",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enabledArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableLocalData(enabledArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteData",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean subscribeArg = (Boolean) args.get(0);
                Number userIDArg = (Number) args.get(1);
                try {
                  Long output =
                      api.subscribeRemoteData(
                          subscribeArg, (userIDArg == null) ? null : userIDArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getFeatureSupportedType",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number typeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getFeatureSupportedType((typeArg == null) ? null : typeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.isFeatureSupported",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number typeArg = (Number) args.get(0);
                try {
                  Boolean output =
                      api.isFeatureSupported((typeArg == null) ? null : typeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setSubscribeAudioBlocklist",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                List<Long> uidArrayArg = (List<Long>) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setSubscribeAudioBlocklist(
                          uidArrayArg, (streamTypeArg == null) ? null : streamTypeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setSubscribeAudioAllowlist",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                List<Long> uidArrayArg = (List<Long>) args.get(0);
                try {
                  Long output = api.setSubscribeAudioAllowlist(uidArrayArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getNetworkType",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getNetworkType();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startPushStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartPushStreamingRequest requestArg = (StartPushStreamingRequest) args.get(0);
                try {
                  Long output = api.startPushStreaming(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startPlayStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartPlayStreamingRequest requestArg = (StartPlayStreamingRequest) args.get(0);
                try {
                  Long output = api.startPlayStreaming(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopPushStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopPushStreaming();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopPlayStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String streamIdArg = (String) args.get(0);
                try {
                  Long output = api.stopPlayStreaming(streamIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pausePlayStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String streamIdArg = (String) args.get(0);
                try {
                  Long output = api.pausePlayStreaming(streamIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.resumePlayStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String streamIdArg = (String) args.get(0);
                try {
                  Long output = api.resumePlayStreaming(streamIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteVideoForPlayStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String streamIdArg = (String) args.get(0);
                Boolean muteArg = (Boolean) args.get(1);
                try {
                  Long output = api.muteVideoForPlayStreaming(streamIdArg, muteArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteAudioForPlayStreaming",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String streamIdArg = (String) args.get(0);
                Boolean muteArg = (Boolean) args.get(1);
                try {
                  Long output = api.muteAudioForPlayStreaming(streamIdArg, muteArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startASRCaption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartASRCaptionRequest requestArg = (StartASRCaptionRequest) args.get(0);
                try {
                  Long output = api.startASRCaption(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopASRCaption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopASRCaption();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setMultiPathOption",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetMultiPathOptionRequest requestArg = (SetMultiPathOptionRequest) args.get(0);
                try {
                  Long output = api.setMultiPathOption(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.aiManualInterrupt",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number dstUidArg = (Number) args.get(0);
                try {
                  Long output =
                      api.aiManualInterrupt((dstUidArg == null) ? null : dstUidArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.AINSMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number modeArg = (Number) args.get(0);
                try {
                  Long output = api.AINSMode((modeArg == null) ? null : modeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioScenario",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number scenarioArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioScenario((scenarioArg == null) ? null : scenarioArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setExternalAudioSource",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enabledArg = (Boolean) args.get(0);
                Number sampleRateArg = (Number) args.get(1);
                Number channelsArg = (Number) args.get(2);
                try {
                  Long output =
                      api.setExternalAudioSource(
                          enabledArg,
                          (sampleRateArg == null) ? null : sampleRateArg.longValue(),
                          (channelsArg == null) ? null : channelsArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setExternalSubStreamAudioSource",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enabledArg = (Boolean) args.get(0);
                Number sampleRateArg = (Number) args.get(1);
                Number channelsArg = (Number) args.get(2);
                try {
                  Long output =
                      api.setExternalSubStreamAudioSource(
                          enabledArg,
                          (sampleRateArg == null) ? null : sampleRateArg.longValue(),
                          (channelsArg == null) ? null : channelsArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioRecvRange",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number audibleDistanceArg = (Number) args.get(0);
                Number conversationalDistanceArg = (Number) args.get(1);
                Number rollOffModeArg = (Number) args.get(2);
                try {
                  Long output =
                      api.setAudioRecvRange(
                          (audibleDistanceArg == null) ? null : audibleDistanceArg.longValue(),
                          (conversationalDistanceArg == null)
                              ? null
                              : conversationalDistanceArg.longValue(),
                          (rollOffModeArg == null) ? null : rollOffModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setRangeAudioMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number audioModeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setRangeAudioMode(
                          (audioModeArg == null) ? null : audioModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setRangeAudioTeamID",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number teamIDArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setRangeAudioTeamID((teamIDArg == null) ? null : teamIDArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateSelfPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                PositionInfo positionInfoArg = (PositionInfo) args.get(0);
                try {
                  Long output = api.updateSelfPosition(positionInfoArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableSpatializerRoomEffects",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.enableSpatializerRoomEffects(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setSpatializerRoomProperty",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SpatializerRoomProperty propertyArg = (SpatializerRoomProperty) args.get(0);
                try {
                  Long output = api.setSpatializerRoomProperty(propertyArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setSpatializerRenderMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number renderModeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setSpatializerRenderMode(
                          (renderModeArg == null) ? null : renderModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableSpatializer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                Boolean applyToTeamArg = (Boolean) args.get(1);
                try {
                  Long output = api.enableSpatializer(enableArg, applyToTeamArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setUpSpatializer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.setUpSpatializer();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.addLocalRecordStreamForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                LocalRecordingConfig configArg = (LocalRecordingConfig) args.get(0);
                String taskIdArg = (String) args.get(1);
                try {
                  Long output = api.addLocalRecordStreamForTask(configArg, taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.removeLocalRecorderStreamForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String taskIdArg = (String) args.get(0);
                try {
                  Long output = api.removeLocalRecorderStreamForTask(taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.addLocalRecorderStreamLayoutForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                LocalRecordingLayoutConfig configArg = (LocalRecordingLayoutConfig) args.get(0);
                Number uidArg = (Number) args.get(1);
                Number streamTypeArg = (Number) args.get(2);
                Number streamLayerArg = (Number) args.get(3);
                Number taskIdArg = (Number) args.get(4);
                try {
                  Long output =
                      api.addLocalRecorderStreamLayoutForTask(
                          configArg,
                          (uidArg == null) ? null : uidArg.longValue(),
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          (streamLayerArg == null) ? null : streamLayerArg.longValue(),
                          (taskIdArg == null) ? null : taskIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.removeLocalRecorderStreamLayoutForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number uidArg = (Number) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                Number streamLayerArg = (Number) args.get(2);
                String taskIdArg = (String) args.get(3);
                try {
                  Long output =
                      api.removeLocalRecorderStreamLayoutForTask(
                          (uidArg == null) ? null : uidArg.longValue(),
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          (streamLayerArg == null) ? null : streamLayerArg.longValue(),
                          taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateLocalRecorderStreamLayoutForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                List<LocalRecordingStreamInfo> infosArg =
                    (List<LocalRecordingStreamInfo>) args.get(0);
                String taskIdArg = (String) args.get(1);
                try {
                  Long output = api.updateLocalRecorderStreamLayoutForTask(infosArg, taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.replaceLocalRecorderStreamLayoutForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                List<LocalRecordingStreamInfo> infosArg =
                    (List<LocalRecordingStreamInfo>) args.get(0);
                String taskIdArg = (String) args.get(1);
                try {
                  Long output = api.replaceLocalRecorderStreamLayoutForTask(infosArg, taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateLocalRecorderWaterMarksForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                List<VideoWatermarkConfig> watermarksArg = (List<VideoWatermarkConfig>) args.get(0);
                String taskIdArg = (String) args.get(1);
                try {
                  Long output = api.updateLocalRecorderWaterMarksForTask(watermarksArg, taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pushLocalRecorderVideoFrameForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number uidArg = (Number) args.get(0);
                Number streamTypeArg = (Number) args.get(1);
                Number streamLayerArg = (Number) args.get(2);
                String taskIdArg = (String) args.get(3);
                VideoFrame frameArg = (VideoFrame) args.get(4);
                try {
                  Long output =
                      api.pushLocalRecorderVideoFrameForTask(
                          (uidArg == null) ? null : uidArg.longValue(),
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          (streamLayerArg == null) ? null : streamLayerArg.longValue(),
                          taskIdArg,
                          frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.showLocalRecorderStreamDefaultCoverForTask",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean showEnabledArg = (Boolean) args.get(0);
                Number uidArg = (Number) args.get(1);
                Number streamTypeArg = (Number) args.get(2);
                Number streamLayerArg = (Number) args.get(3);
                String taskIdArg = (String) args.get(4);
                try {
                  Long output =
                      api.showLocalRecorderStreamDefaultCoverForTask(
                          showEnabledArg,
                          (uidArg == null) ? null : uidArg.longValue(),
                          (streamTypeArg == null) ? null : streamTypeArg.longValue(),
                          (streamLayerArg == null) ? null : streamLayerArg.longValue(),
                          taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopLocalRecorderRemuxMp4",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String taskIdArg = (String) args.get(0);
                try {
                  Long output = api.stopLocalRecorderRemuxMp4(taskIdArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.remuxFlvToMp4",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String flvPathArg = (String) args.get(0);
                String mp4PathArg = (String) args.get(1);
                Boolean saveOriArg = (Boolean) args.get(2);
                try {
                  Long output = api.remuxFlvToMp4(flvPathArg, mp4PathArg, saveOriArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopRemuxFlvToMp4",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopRemuxFlvToMp4();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.sendData",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                DataExternalFrame frameArg = (DataExternalFrame) args.get(0);
                try {
                  Long output = api.sendData(frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pushExternalAudioFrame",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                AudioExternalFrame frameArg = (AudioExternalFrame) args.get(0);
                try {
                  Long output = api.pushExternalAudioFrame(frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pushExternalSubAudioFrame",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                AudioExternalFrame frameArg = (AudioExternalFrame) args.get(0);
                try {
                  Long output = api.pushExternalSubAudioFrame(frameArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface VideoRendererApi {

    @NonNull
    Long createVideoRenderer();

    @NonNull
    Long setMirror(@NonNull Long textureId, @NonNull Boolean mirror);

    @NonNull
    Long setupLocalVideoRenderer(@NonNull Long textureId, @NonNull String channelTag);

    @NonNull
    Long setupRemoteVideoRenderer(
        @NonNull Long uid, @NonNull Long textureId, @NonNull String channelTag);

    @NonNull
    Long setupLocalSubStreamVideoRenderer(@NonNull Long textureId, @NonNull String channelTag);

    @NonNull
    Long setupRemoteSubStreamVideoRenderer(
        @NonNull Long uid, @NonNull Long textureId, @NonNull String channelTag);

    @NonNull
    Long setupPlayStreamingCanvas(@NonNull String streamId, @NonNull Long textureId);

    void disposeVideoRenderer(@NonNull Long textureId);

    /** The codec used by VideoRendererApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /**
     * Sets up an instance of `VideoRendererApi` to handle messages through the `binaryMessenger`.
     */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable VideoRendererApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.createVideoRenderer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.createVideoRenderer();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setMirror",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number textureIdArg = (Number) args.get(0);
                Boolean mirrorArg = (Boolean) args.get(1);
                try {
                  Long output =
                      api.setMirror(
                          (textureIdArg == null) ? null : textureIdArg.longValue(), mirrorArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setupLocalVideoRenderer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number textureIdArg = (Number) args.get(0);
                String channelTagArg = (String) args.get(1);
                try {
                  Long output =
                      api.setupLocalVideoRenderer(
                          (textureIdArg == null) ? null : textureIdArg.longValue(), channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setupRemoteVideoRenderer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number uidArg = (Number) args.get(0);
                Number textureIdArg = (Number) args.get(1);
                String channelTagArg = (String) args.get(2);
                try {
                  Long output =
                      api.setupRemoteVideoRenderer(
                          (uidArg == null) ? null : uidArg.longValue(),
                          (textureIdArg == null) ? null : textureIdArg.longValue(),
                          channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setupLocalSubStreamVideoRenderer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number textureIdArg = (Number) args.get(0);
                String channelTagArg = (String) args.get(1);
                try {
                  Long output =
                      api.setupLocalSubStreamVideoRenderer(
                          (textureIdArg == null) ? null : textureIdArg.longValue(), channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setupRemoteSubStreamVideoRenderer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number uidArg = (Number) args.get(0);
                Number textureIdArg = (Number) args.get(1);
                String channelTagArg = (String) args.get(2);
                try {
                  Long output =
                      api.setupRemoteSubStreamVideoRenderer(
                          (uidArg == null) ? null : uidArg.longValue(),
                          (textureIdArg == null) ? null : textureIdArg.longValue(),
                          channelTagArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setupPlayStreamingCanvas",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String streamIdArg = (String) args.get(0);
                Number textureIdArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setupPlayStreamingCanvas(
                          streamIdArg, (textureIdArg == null) ? null : textureIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.disposeVideoRenderer",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number textureIdArg = (Number) args.get(0);
                try {
                  api.disposeVideoRenderer(
                      (textureIdArg == null) ? null : textureIdArg.longValue());
                  wrapped.add(0, null);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }

  private static class NERtcDeviceEventSinkCodec extends StandardMessageCodec {
    public static final NERtcDeviceEventSinkCodec INSTANCE = new NERtcDeviceEventSinkCodec();

    private NERtcDeviceEventSinkCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return CGPoint.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof CGPoint) {
        stream.write(128);
        writeValue(stream, ((CGPoint) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcDeviceEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcDeviceEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcDeviceEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return NERtcDeviceEventSinkCodec.INSTANCE;
    }

    public void onAudioDeviceChanged(@NonNull Long selectedArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcDeviceEventSink.onAudioDeviceChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(selectedArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioDeviceStateChange(
        @NonNull Long deviceTypeArg, @NonNull Long deviceStateArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcDeviceEventSink.onAudioDeviceStateChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(deviceTypeArg, deviceStateArg)),
          channelReply -> callback.reply(null));
    }

    public void onVideoDeviceStateChange(
        @NonNull Long deviceTypeArg, @NonNull Long deviceStateArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcDeviceEventSink.onVideoDeviceStateChange",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(deviceTypeArg, deviceStateArg)),
          channelReply -> callback.reply(null));
    }

    public void onCameraFocusChanged(
        @NonNull CGPoint focusPointArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcDeviceEventSink.onCameraFocusChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(focusPointArg)),
          channelReply -> callback.reply(null));
    }

    public void onCameraExposureChanged(
        @NonNull CGPoint exposurePointArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcDeviceEventSink.onCameraExposureChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(exposurePointArg)),
          channelReply -> callback.reply(null));
    }
  }

  private static class DeviceManagerApiCodec extends StandardMessageCodec {
    public static final DeviceManagerApiCodec INSTANCE = new DeviceManagerApiCodec();

    private DeviceManagerApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return SetCameraPositionRequest.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof SetCameraPositionRequest) {
        stream.write(128);
        writeValue(stream, ((SetCameraPositionRequest) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface DeviceManagerApi {

    @NonNull
    Boolean isSpeakerphoneOn();

    @NonNull
    Boolean isCameraZoomSupported();

    @NonNull
    Boolean isCameraTorchSupported();

    @NonNull
    Boolean isCameraFocusSupported();

    @NonNull
    Boolean isCameraExposurePositionSupported();

    @NonNull
    Long setSpeakerphoneOn(@NonNull Boolean enable);

    @NonNull
    Long switchCamera();

    @NonNull
    Long setCameraZoomFactor(@NonNull Double factor);

    @NonNull
    Double getCameraMaxZoom();

    @NonNull
    Long setCameraTorchOn(@NonNull Boolean on);

    @NonNull
    Long setCameraFocusPosition(@NonNull SetCameraPositionRequest request);

    @NonNull
    Long setCameraExposurePosition(@NonNull SetCameraPositionRequest request);

    @NonNull
    Long setPlayoutDeviceMute(@NonNull Boolean mute);

    @NonNull
    Boolean isPlayoutDeviceMute();

    @NonNull
    Long setRecordDeviceMute(@NonNull Boolean mute);

    @NonNull
    Boolean isRecordDeviceMute();

    @NonNull
    Long enableEarback(@NonNull Boolean enabled, @NonNull Long volume);

    @NonNull
    Long setEarbackVolume(@NonNull Long volume);

    @NonNull
    Long setAudioFocusMode(@NonNull Long focusMode);

    @NonNull
    Long getCurrentCamera();

    @NonNull
    Long switchCameraWithPosition(@NonNull Long position);

    @NonNull
    Long getCameraCurrentZoom();

    /** The codec used by DeviceManagerApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return DeviceManagerApiCodec.INSTANCE;
    }
    /**
     * Sets up an instance of `DeviceManagerApi` to handle messages through the `binaryMessenger`.
     */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable DeviceManagerApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isSpeakerphoneOn",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isSpeakerphoneOn();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isCameraZoomSupported",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isCameraZoomSupported();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isCameraTorchSupported",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isCameraTorchSupported();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isCameraFocusSupported",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isCameraFocusSupported();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isCameraExposurePositionSupported",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isCameraExposurePositionSupported();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setSpeakerphoneOn",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enableArg = (Boolean) args.get(0);
                try {
                  Long output = api.setSpeakerphoneOn(enableArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.switchCamera",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.switchCamera();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setCameraZoomFactor",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Double factorArg = (Double) args.get(0);
                try {
                  Long output = api.setCameraZoomFactor(factorArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.getCameraMaxZoom",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Double output = api.getCameraMaxZoom();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setCameraTorchOn",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean onArg = (Boolean) args.get(0);
                try {
                  Long output = api.setCameraTorchOn(onArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setCameraFocusPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetCameraPositionRequest requestArg = (SetCameraPositionRequest) args.get(0);
                try {
                  Long output = api.setCameraFocusPosition(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setCameraExposurePosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                SetCameraPositionRequest requestArg = (SetCameraPositionRequest) args.get(0);
                try {
                  Long output = api.setCameraExposurePosition(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setPlayoutDeviceMute",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean muteArg = (Boolean) args.get(0);
                try {
                  Long output = api.setPlayoutDeviceMute(muteArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isPlayoutDeviceMute",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isPlayoutDeviceMute();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setRecordDeviceMute",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean muteArg = (Boolean) args.get(0);
                try {
                  Long output = api.setRecordDeviceMute(muteArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isRecordDeviceMute",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.isRecordDeviceMute();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.enableEarback",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Boolean enabledArg = (Boolean) args.get(0);
                Number volumeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.enableEarback(
                          enabledArg, (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setEarbackVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number volumeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setEarbackVolume((volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setAudioFocusMode",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number focusModeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioFocusMode(
                          (focusModeArg == null) ? null : focusModeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.getCurrentCamera",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getCurrentCamera();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.switchCameraWithPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number positionArg = (Number) args.get(0);
                try {
                  Long output =
                      api.switchCameraWithPosition(
                          (positionArg == null) ? null : positionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.getCameraCurrentZoom",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getCameraCurrentZoom();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }

  private static class AudioMixingApiCodec extends StandardMessageCodec {
    public static final AudioMixingApiCodec INSTANCE = new AudioMixingApiCodec();

    private AudioMixingApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return StartAudioMixingRequest.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof StartAudioMixingRequest) {
        stream.write(128);
        writeValue(stream, ((StartAudioMixingRequest) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface AudioMixingApi {

    @NonNull
    Long startAudioMixing(@NonNull StartAudioMixingRequest request);

    @NonNull
    Long stopAudioMixing();

    @NonNull
    Long pauseAudioMixing();

    @NonNull
    Long resumeAudioMixing();

    @NonNull
    Long setAudioMixingSendVolume(@NonNull Long volume);

    @NonNull
    Long getAudioMixingSendVolume();

    @NonNull
    Long setAudioMixingPlaybackVolume(@NonNull Long volume);

    @NonNull
    Long getAudioMixingPlaybackVolume();

    @NonNull
    Long getAudioMixingDuration();

    @NonNull
    Long getAudioMixingCurrentPosition();

    @NonNull
    Long setAudioMixingPosition(@NonNull Long position);

    @NonNull
    Long setAudioMixingPitch(@NonNull Long pitch);

    @NonNull
    Long getAudioMixingPitch();

    /** The codec used by AudioMixingApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return AudioMixingApiCodec.INSTANCE;
    }
    /** Sets up an instance of `AudioMixingApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable AudioMixingApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.startAudioMixing",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                StartAudioMixingRequest requestArg = (StartAudioMixingRequest) args.get(0);
                try {
                  Long output = api.startAudioMixing(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.stopAudioMixing",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopAudioMixing();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.pauseAudioMixing",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.pauseAudioMixing();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.resumeAudioMixing",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.resumeAudioMixing();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.setAudioMixingSendVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number volumeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioMixingSendVolume(
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.getAudioMixingSendVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getAudioMixingSendVolume();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.setAudioMixingPlaybackVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number volumeArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioMixingPlaybackVolume(
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.getAudioMixingPlaybackVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getAudioMixingPlaybackVolume();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.getAudioMixingDuration",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getAudioMixingDuration();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.getAudioMixingCurrentPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getAudioMixingCurrentPosition();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.setAudioMixingPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number positionArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioMixingPosition(
                          (positionArg == null) ? null : positionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.setAudioMixingPitch",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number pitchArg = (Number) args.get(0);
                try {
                  Long output =
                      api.setAudioMixingPitch((pitchArg == null) ? null : pitchArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.getAudioMixingPitch",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.getAudioMixingPitch();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcAudioMixingEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcAudioMixingEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcAudioMixingEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }

    public void onAudioMixingStateChanged(@NonNull Long reasonArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcAudioMixingEventSink.onAudioMixingStateChanged",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(reasonArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioMixingTimestampUpdate(
        @NonNull Long timestampMsArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcAudioMixingEventSink.onAudioMixingTimestampUpdate",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(timestampMsArg)),
          channelReply -> callback.reply(null));
    }
  }

  private static class AudioEffectApiCodec extends StandardMessageCodec {
    public static final AudioEffectApiCodec INSTANCE = new AudioEffectApiCodec();

    private AudioEffectApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return PlayEffectRequest.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof PlayEffectRequest) {
        stream.write(128);
        writeValue(stream, ((PlayEffectRequest) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface AudioEffectApi {

    @NonNull
    Long playEffect(@NonNull PlayEffectRequest request);

    @NonNull
    Long stopEffect(@NonNull Long effectId);

    @NonNull
    Long stopAllEffects();

    @NonNull
    Long pauseEffect(@NonNull Long effectId);

    @NonNull
    Long resumeEffect(@NonNull Long effectId);

    @NonNull
    Long pauseAllEffects();

    @NonNull
    Long resumeAllEffects();

    @NonNull
    Long setEffectSendVolume(@NonNull Long effectId, @NonNull Long volume);

    @NonNull
    Long getEffectSendVolume(@NonNull Long effectId);

    @NonNull
    Long setEffectPlaybackVolume(@NonNull Long effectId, @NonNull Long volume);

    @NonNull
    Long getEffectPlaybackVolume(@NonNull Long effectId);

    @NonNull
    Long getEffectDuration(@NonNull Long effectId);

    @NonNull
    Long getEffectCurrentPosition(@NonNull Long effectId);

    @NonNull
    Long setEffectPitch(@NonNull Long effectId, @NonNull Long pitch);

    @NonNull
    Long getEffectPitch(@NonNull Long effectId);

    @NonNull
    Long setEffectPosition(@NonNull Long effectId, @NonNull Long position);

    /** The codec used by AudioEffectApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return AudioEffectApiCodec.INSTANCE;
    }
    /** Sets up an instance of `AudioEffectApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable AudioEffectApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.playEffect",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                PlayEffectRequest requestArg = (PlayEffectRequest) args.get(0);
                try {
                  Long output = api.playEffect(requestArg);
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.stopEffect",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.stopEffect((effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.stopAllEffects",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.stopAllEffects();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.pauseEffect",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.pauseEffect((effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.resumeEffect",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.resumeEffect((effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.pauseAllEffects",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.pauseAllEffects();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.resumeAllEffects",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.resumeAllEffects();
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.setEffectSendVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                Number volumeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setEffectSendVolume(
                          (effectIdArg == null) ? null : effectIdArg.longValue(),
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectSendVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getEffectSendVolume(
                          (effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.setEffectPlaybackVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                Number volumeArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setEffectPlaybackVolume(
                          (effectIdArg == null) ? null : effectIdArg.longValue(),
                          (volumeArg == null) ? null : volumeArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectPlaybackVolume",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getEffectPlaybackVolume(
                          (effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectDuration",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getEffectDuration((effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectCurrentPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getEffectCurrentPosition(
                          (effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.setEffectPitch",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                Number pitchArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setEffectPitch(
                          (effectIdArg == null) ? null : effectIdArg.longValue(),
                          (pitchArg == null) ? null : pitchArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectPitch",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                try {
                  Long output =
                      api.getEffectPitch((effectIdArg == null) ? null : effectIdArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.setEffectPosition",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number effectIdArg = (Number) args.get(0);
                Number positionArg = (Number) args.get(1);
                try {
                  Long output =
                      api.setEffectPosition(
                          (effectIdArg == null) ? null : effectIdArg.longValue(),
                          (positionArg == null) ? null : positionArg.longValue());
                  wrapped.add(0, output);
                } catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcAudioEffectEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcAudioEffectEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcAudioEffectEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }

    public void onAudioEffectFinished(@NonNull Long effectIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcAudioEffectEventSink.onAudioEffectFinished",
              getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(effectIdArg)),
          channelReply -> callback.reply(null));
    }

    public void onAudioEffectTimestampUpdate(
        @NonNull Long idArg, @NonNull Long timestampMsArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcAudioEffectEventSink.onAudioEffectTimestampUpdate",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(idArg, timestampMsArg)),
          channelReply -> callback.reply(null));
    }
  }

  private static class NERtcStatsEventSinkCodec extends StandardMessageCodec {
    public static final NERtcStatsEventSinkCodec INSTANCE = new NERtcStatsEventSinkCodec();

    private NERtcStatsEventSinkCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return AddOrUpdateLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 129:
          return AdjustUserPlaybackSignalVolumeRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 130:
          return AudioExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 131:
          return AudioRecordingConfigurationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 132:
          return AudioVolumeInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 133:
          return CGPoint.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 134:
          return CreateEngineRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 135:
          return DataExternalFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 136:
          return DeleteLiveStreamTaskRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 137:
          return EnableAudioVolumeIndicationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 138:
          return EnableEncryptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 139:
          return EnableLocalVideoRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 140:
          return EnableVirtualBackgroundRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 141:
          return FirstVideoDataReceivedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 142:
          return FirstVideoFrameDecodedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 143:
          return JoinChannelOptions.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 144:
          return JoinChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 145:
          return LocalRecordingConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 146:
          return LocalRecordingLayoutConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 147:
          return LocalRecordingStreamInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 148:
          return NERtcLastmileProbeOneWayResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 149:
          return NERtcLastmileProbeResult.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 150:
          return NERtcUserJoinExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 151:
          return NERtcUserLeaveExtraInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 152:
          return NERtcVersion.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 153:
          return PlayEffectRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 154:
          return PositionInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 155:
          return Rectangle.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 156:
          return RemoteAudioVolumeIndicationEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 157:
          return ReportCustomEventRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 158:
          return RtcServerAddresses.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 159:
          return ScreenCaptureSourceData.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 160:
          return SendSEIMsgRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 161:
          return SetAudioProfileRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 162:
          return SetAudioSubscribeOnlyByRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 163:
          return SetCameraCaptureConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 164:
          return SetCameraPositionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 165:
          return SetLocalMediaPriorityRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 166:
          return SetLocalVideoConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 167:
          return SetLocalVideoWatermarkConfigsRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 168:
          return SetLocalVoiceEqualizationRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 169:
          return SetLocalVoiceReverbParamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 170:
          return SetMultiPathOptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 171:
          return SetRemoteHighPriorityAudioStreamRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 172:
          return SetVideoCorrectionConfigRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 173:
          return SpatializerRoomProperty.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 174:
          return StartASRCaptionRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 175:
          return StartAudioMixingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 176:
          return StartAudioRecordingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 177:
          return StartLastmileProbeTestRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 178:
          return StartOrUpdateChannelMediaRelayRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 179:
          return StartPlayStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 180:
          return StartPushStreamingRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 181:
          return StartScreenCaptureRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 182:
          return StartorStopVideoPreviewRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 183:
          return StreamingRoomInfo.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 184:
          return SubscribeRemoteAudioRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 185:
          return SubscribeRemoteSubStreamAudioRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 186:
          return SubscribeRemoteSubStreamVideoRequest.fromList(
              (ArrayList<Object>) readValue(buffer));
        case (byte) 187:
          return SubscribeRemoteVideoStreamRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 188:
          return SwitchChannelRequest.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 189:
          return UserJoinedEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 190:
          return UserLeaveEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 191:
          return UserVideoMuteEvent.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 192:
          return VideoFrame.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 193:
          return VideoWatermarkConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 194:
          return VideoWatermarkImageConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 195:
          return VideoWatermarkTextConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 196:
          return VideoWatermarkTimestampConfig.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 197:
          return VirtualBackgroundSourceEnabledEvent.fromList(
              (ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof AddOrUpdateLiveStreamTaskRequest) {
        stream.write(128);
        writeValue(stream, ((AddOrUpdateLiveStreamTaskRequest) value).toList());
      } else if (value instanceof AdjustUserPlaybackSignalVolumeRequest) {
        stream.write(129);
        writeValue(stream, ((AdjustUserPlaybackSignalVolumeRequest) value).toList());
      } else if (value instanceof AudioExternalFrame) {
        stream.write(130);
        writeValue(stream, ((AudioExternalFrame) value).toList());
      } else if (value instanceof AudioRecordingConfigurationRequest) {
        stream.write(131);
        writeValue(stream, ((AudioRecordingConfigurationRequest) value).toList());
      } else if (value instanceof AudioVolumeInfo) {
        stream.write(132);
        writeValue(stream, ((AudioVolumeInfo) value).toList());
      } else if (value instanceof CGPoint) {
        stream.write(133);
        writeValue(stream, ((CGPoint) value).toList());
      } else if (value instanceof CreateEngineRequest) {
        stream.write(134);
        writeValue(stream, ((CreateEngineRequest) value).toList());
      } else if (value instanceof DataExternalFrame) {
        stream.write(135);
        writeValue(stream, ((DataExternalFrame) value).toList());
      } else if (value instanceof DeleteLiveStreamTaskRequest) {
        stream.write(136);
        writeValue(stream, ((DeleteLiveStreamTaskRequest) value).toList());
      } else if (value instanceof EnableAudioVolumeIndicationRequest) {
        stream.write(137);
        writeValue(stream, ((EnableAudioVolumeIndicationRequest) value).toList());
      } else if (value instanceof EnableEncryptionRequest) {
        stream.write(138);
        writeValue(stream, ((EnableEncryptionRequest) value).toList());
      } else if (value instanceof EnableLocalVideoRequest) {
        stream.write(139);
        writeValue(stream, ((EnableLocalVideoRequest) value).toList());
      } else if (value instanceof EnableVirtualBackgroundRequest) {
        stream.write(140);
        writeValue(stream, ((EnableVirtualBackgroundRequest) value).toList());
      } else if (value instanceof FirstVideoDataReceivedEvent) {
        stream.write(141);
        writeValue(stream, ((FirstVideoDataReceivedEvent) value).toList());
      } else if (value instanceof FirstVideoFrameDecodedEvent) {
        stream.write(142);
        writeValue(stream, ((FirstVideoFrameDecodedEvent) value).toList());
      } else if (value instanceof JoinChannelOptions) {
        stream.write(143);
        writeValue(stream, ((JoinChannelOptions) value).toList());
      } else if (value instanceof JoinChannelRequest) {
        stream.write(144);
        writeValue(stream, ((JoinChannelRequest) value).toList());
      } else if (value instanceof LocalRecordingConfig) {
        stream.write(145);
        writeValue(stream, ((LocalRecordingConfig) value).toList());
      } else if (value instanceof LocalRecordingLayoutConfig) {
        stream.write(146);
        writeValue(stream, ((LocalRecordingLayoutConfig) value).toList());
      } else if (value instanceof LocalRecordingStreamInfo) {
        stream.write(147);
        writeValue(stream, ((LocalRecordingStreamInfo) value).toList());
      } else if (value instanceof NERtcLastmileProbeOneWayResult) {
        stream.write(148);
        writeValue(stream, ((NERtcLastmileProbeOneWayResult) value).toList());
      } else if (value instanceof NERtcLastmileProbeResult) {
        stream.write(149);
        writeValue(stream, ((NERtcLastmileProbeResult) value).toList());
      } else if (value instanceof NERtcUserJoinExtraInfo) {
        stream.write(150);
        writeValue(stream, ((NERtcUserJoinExtraInfo) value).toList());
      } else if (value instanceof NERtcUserLeaveExtraInfo) {
        stream.write(151);
        writeValue(stream, ((NERtcUserLeaveExtraInfo) value).toList());
      } else if (value instanceof NERtcVersion) {
        stream.write(152);
        writeValue(stream, ((NERtcVersion) value).toList());
      } else if (value instanceof PlayEffectRequest) {
        stream.write(153);
        writeValue(stream, ((PlayEffectRequest) value).toList());
      } else if (value instanceof PositionInfo) {
        stream.write(154);
        writeValue(stream, ((PositionInfo) value).toList());
      } else if (value instanceof Rectangle) {
        stream.write(155);
        writeValue(stream, ((Rectangle) value).toList());
      } else if (value instanceof RemoteAudioVolumeIndicationEvent) {
        stream.write(156);
        writeValue(stream, ((RemoteAudioVolumeIndicationEvent) value).toList());
      } else if (value instanceof ReportCustomEventRequest) {
        stream.write(157);
        writeValue(stream, ((ReportCustomEventRequest) value).toList());
      } else if (value instanceof RtcServerAddresses) {
        stream.write(158);
        writeValue(stream, ((RtcServerAddresses) value).toList());
      } else if (value instanceof ScreenCaptureSourceData) {
        stream.write(159);
        writeValue(stream, ((ScreenCaptureSourceData) value).toList());
      } else if (value instanceof SendSEIMsgRequest) {
        stream.write(160);
        writeValue(stream, ((SendSEIMsgRequest) value).toList());
      } else if (value instanceof SetAudioProfileRequest) {
        stream.write(161);
        writeValue(stream, ((SetAudioProfileRequest) value).toList());
      } else if (value instanceof SetAudioSubscribeOnlyByRequest) {
        stream.write(162);
        writeValue(stream, ((SetAudioSubscribeOnlyByRequest) value).toList());
      } else if (value instanceof SetCameraCaptureConfigRequest) {
        stream.write(163);
        writeValue(stream, ((SetCameraCaptureConfigRequest) value).toList());
      } else if (value instanceof SetCameraPositionRequest) {
        stream.write(164);
        writeValue(stream, ((SetCameraPositionRequest) value).toList());
      } else if (value instanceof SetLocalMediaPriorityRequest) {
        stream.write(165);
        writeValue(stream, ((SetLocalMediaPriorityRequest) value).toList());
      } else if (value instanceof SetLocalVideoConfigRequest) {
        stream.write(166);
        writeValue(stream, ((SetLocalVideoConfigRequest) value).toList());
      } else if (value instanceof SetLocalVideoWatermarkConfigsRequest) {
        stream.write(167);
        writeValue(stream, ((SetLocalVideoWatermarkConfigsRequest) value).toList());
      } else if (value instanceof SetLocalVoiceEqualizationRequest) {
        stream.write(168);
        writeValue(stream, ((SetLocalVoiceEqualizationRequest) value).toList());
      } else if (value instanceof SetLocalVoiceReverbParamRequest) {
        stream.write(169);
        writeValue(stream, ((SetLocalVoiceReverbParamRequest) value).toList());
      } else if (value instanceof SetMultiPathOptionRequest) {
        stream.write(170);
        writeValue(stream, ((SetMultiPathOptionRequest) value).toList());
      } else if (value instanceof SetRemoteHighPriorityAudioStreamRequest) {
        stream.write(171);
        writeValue(stream, ((SetRemoteHighPriorityAudioStreamRequest) value).toList());
      } else if (value instanceof SetVideoCorrectionConfigRequest) {
        stream.write(172);
        writeValue(stream, ((SetVideoCorrectionConfigRequest) value).toList());
      } else if (value instanceof SpatializerRoomProperty) {
        stream.write(173);
        writeValue(stream, ((SpatializerRoomProperty) value).toList());
      } else if (value instanceof StartASRCaptionRequest) {
        stream.write(174);
        writeValue(stream, ((StartASRCaptionRequest) value).toList());
      } else if (value instanceof StartAudioMixingRequest) {
        stream.write(175);
        writeValue(stream, ((StartAudioMixingRequest) value).toList());
      } else if (value instanceof StartAudioRecordingRequest) {
        stream.write(176);
        writeValue(stream, ((StartAudioRecordingRequest) value).toList());
      } else if (value instanceof StartLastmileProbeTestRequest) {
        stream.write(177);
        writeValue(stream, ((StartLastmileProbeTestRequest) value).toList());
      } else if (value instanceof StartOrUpdateChannelMediaRelayRequest) {
        stream.write(178);
        writeValue(stream, ((StartOrUpdateChannelMediaRelayRequest) value).toList());
      } else if (value instanceof StartPlayStreamingRequest) {
        stream.write(179);
        writeValue(stream, ((StartPlayStreamingRequest) value).toList());
      } else if (value instanceof StartPushStreamingRequest) {
        stream.write(180);
        writeValue(stream, ((StartPushStreamingRequest) value).toList());
      } else if (value instanceof StartScreenCaptureRequest) {
        stream.write(181);
        writeValue(stream, ((StartScreenCaptureRequest) value).toList());
      } else if (value instanceof StartorStopVideoPreviewRequest) {
        stream.write(182);
        writeValue(stream, ((StartorStopVideoPreviewRequest) value).toList());
      } else if (value instanceof StreamingRoomInfo) {
        stream.write(183);
        writeValue(stream, ((StreamingRoomInfo) value).toList());
      } else if (value instanceof SubscribeRemoteAudioRequest) {
        stream.write(184);
        writeValue(stream, ((SubscribeRemoteAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamAudioRequest) {
        stream.write(185);
        writeValue(stream, ((SubscribeRemoteSubStreamAudioRequest) value).toList());
      } else if (value instanceof SubscribeRemoteSubStreamVideoRequest) {
        stream.write(186);
        writeValue(stream, ((SubscribeRemoteSubStreamVideoRequest) value).toList());
      } else if (value instanceof SubscribeRemoteVideoStreamRequest) {
        stream.write(187);
        writeValue(stream, ((SubscribeRemoteVideoStreamRequest) value).toList());
      } else if (value instanceof SwitchChannelRequest) {
        stream.write(188);
        writeValue(stream, ((SwitchChannelRequest) value).toList());
      } else if (value instanceof UserJoinedEvent) {
        stream.write(189);
        writeValue(stream, ((UserJoinedEvent) value).toList());
      } else if (value instanceof UserLeaveEvent) {
        stream.write(190);
        writeValue(stream, ((UserLeaveEvent) value).toList());
      } else if (value instanceof UserVideoMuteEvent) {
        stream.write(191);
        writeValue(stream, ((UserVideoMuteEvent) value).toList());
      } else if (value instanceof VideoFrame) {
        stream.write(192);
        writeValue(stream, ((VideoFrame) value).toList());
      } else if (value instanceof VideoWatermarkConfig) {
        stream.write(193);
        writeValue(stream, ((VideoWatermarkConfig) value).toList());
      } else if (value instanceof VideoWatermarkImageConfig) {
        stream.write(194);
        writeValue(stream, ((VideoWatermarkImageConfig) value).toList());
      } else if (value instanceof VideoWatermarkTextConfig) {
        stream.write(195);
        writeValue(stream, ((VideoWatermarkTextConfig) value).toList());
      } else if (value instanceof VideoWatermarkTimestampConfig) {
        stream.write(196);
        writeValue(stream, ((VideoWatermarkTimestampConfig) value).toList());
      } else if (value instanceof VirtualBackgroundSourceEnabledEvent) {
        stream.write(197);
        writeValue(stream, ((VirtualBackgroundSourceEnabledEvent) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcStatsEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcStatsEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcStatsEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return NERtcStatsEventSinkCodec.INSTANCE;
    }

    public void onRtcStats(
        @NonNull Map<Object, Object> argumentsArg,
        @NonNull String channelTagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onRtcStats",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(argumentsArg, channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalAudioStats(
        @NonNull Map<Object, Object> argumentsArg,
        @NonNull String channelTagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onLocalAudioStats",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(argumentsArg, channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteAudioStats(
        @NonNull Map<Object, Object> argumentsArg,
        @NonNull String channelTagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onRemoteAudioStats",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(argumentsArg, channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onLocalVideoStats(
        @NonNull Map<Object, Object> argumentsArg,
        @NonNull String channelTagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onLocalVideoStats",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(argumentsArg, channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onRemoteVideoStats(
        @NonNull Map<Object, Object> argumentsArg,
        @NonNull String channelTagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onRemoteVideoStats",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(argumentsArg, channelTagArg)),
          channelReply -> callback.reply(null));
    }

    public void onNetworkQuality(
        @NonNull Map<Object, Object> argumentsArg,
        @NonNull String channelTagArg,
        @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onNetworkQuality",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(argumentsArg, channelTagArg)),
          channelReply -> callback.reply(null));
    }
  }
  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class NERtcLiveStreamEventSink {
    private final @NonNull BinaryMessenger binaryMessenger;

    public NERtcLiveStreamEventSink(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by NERtcLiveStreamEventSink. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }

    public void onUpdateLiveStreamTask(
        @NonNull String taskIdArg, @NonNull Long errCodeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcLiveStreamEventSink.onUpdateLiveStreamTask",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(taskIdArg, errCodeArg)),
          channelReply -> callback.reply(null));
    }

    public void onAddLiveStreamTask(
        @NonNull String taskIdArg, @NonNull Long errCodeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcLiveStreamEventSink.onAddLiveStreamTask",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(taskIdArg, errCodeArg)),
          channelReply -> callback.reply(null));
    }

    public void onDeleteLiveStreamTask(
        @NonNull String taskIdArg, @NonNull Long errCodeArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.nertc_core_platform_interface.NERtcLiveStreamEventSink.onDeleteLiveStreamTask",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(taskIdArg, errCodeArg)),
          channelReply -> callback.reply(null));
    }
  }
}
