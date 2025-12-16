// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertc_core.nertc_core_example;

import androidx.annotation.DrawableRes;

class ForegroundServiceConfig {

  public static final String DEFAULT_CONTENT_TITLE = "云信音视频通话";

  public static final String DEFAULT_CONTENT_TEXT = "音视频通话正在进行中";

  public static final String DEFAULT_CONTENT_TICKER = "云信音视频通话";

  public static final String DEFAULT_CHANNEL_ID = "NERtc_Flutter_Call";

  public static final String DEFAULT_CHANNEL_NAME = "云信音视频通话通知";

  public static final String DEFAULT_CHANNEL_DESC = "云信音视频通话通知";

  ForegroundServiceConfig() {}

  /** 前台服务通知标题 */
  public String contentTitle = DEFAULT_CONTENT_TITLE;

  /** 前台服务通知內容 */
  public String contentText = DEFAULT_CONTENT_TEXT;

  /** 前台服务通知图标，如果不设置默认显示应用图标 */
  @DrawableRes public int smallIcon;

  /** 入口页面 */
  public String launchActivityName;

  /** 前台服务通知提示 */
  public String ticker = DEFAULT_CONTENT_TICKER;

  /** 前台服务通知通道id */
  public String channelId = DEFAULT_CHANNEL_ID;

  /** 前台服务通知通道名称 */
  public String channelName = DEFAULT_CHANNEL_NAME;

  /** 前台服务通知通道描述 */
  public String channelDesc = DEFAULT_CHANNEL_DESC;
}
