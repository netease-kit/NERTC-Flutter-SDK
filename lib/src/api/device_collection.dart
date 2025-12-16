// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

enum NERtcDeviceType {
  audio,
  video,
}

enum NERtcDeviceUsage { capture, playout }

abstract class IDeviceCollection {
  NERtcDeviceType get type;

  NERtcDeviceUsage get usage;

  /// 设备数量
  int getCount();

  /// 获取设备 id 和 name
  NERtcDesktopDevice getDevice(int index);

  /// 获取设备信息
  NERtcDesktopDeviceInfo getDeviceInfo(int index);

  /// 释放资源
  void release();
}
