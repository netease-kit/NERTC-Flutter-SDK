// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

abstract class IScreenCaptureList {
  NERtcSize get thumbSize;

  NERtcSize get iconSize;

  bool get includeScreen;

  String get channelTag;

  /**
   * Gets the number of shareable windows and screens.
   */
  int getCount();

  /**
   * Gets information about the specified shareable window or screen.
   */
  NERtcScreenCaptureSourceInfo getSourceInfo(int index);

  /**
   * Releases IScreenCaptureSourceList.
   */
  void release();
}

abstract class NERtcDesktopScreenCapture {
  /// 获得一个可以分享的屏幕和窗口的列表
  IScreenCaptureList? getScreenCaptureSources(
      NERtcSize thumbSize, NERtcSize iconSize, bool includeScreen);

  /// 开启屏幕共享，共享范围为指定屏幕的指定区域。
  int startScreenCaptureByScreenRect(NERtcRectangle screenRect,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams);

  /// 开启屏幕共享，共享范围为指定屏幕的指定区域。
  int startScreenCaptureByDisplayId(int displayId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams);

  /// 通过指定屏幕 ID 开启屏幕共享。
  int startScreenCaptureByWindowId(int windowId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams);

  /// 设置屏幕分享参数，该方法在屏幕分享过程中调用，用来快速切换采集源。
  int setScreenCaptureSource(NERtcScreenCaptureSourceInfo source,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams);

  /// 在共享屏幕或窗口时，更新共享的区域。
  int updateScreenCaptureRegion(NERtcRectangle regionRect);

  /// 在共享屏幕或窗口时，更新是否显示鼠标。
  int setScreenCaptureMouseCursor(bool captureCursor);

  /// 关闭屏幕共享。
  int stopScreenCapture();

  /// 暂停屏幕共享。
  int pauseScreenCapture();

  /// 恢复屏幕共享。
  int resumeScreenCapture();

  /// 设置共享整个屏幕或屏幕指定区域时，需要屏蔽的窗口列表。
  int setExcludeWindowList(List<int> windowLists, int count);

  /// 更新屏幕共享参数。
  int updateScreenCaptureParameters(NERtcScreenCaptureParameters captureParams);
}
