// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class DeviceCollectionImpl implements IDeviceCollection {
  @override
  final NERtcDeviceType type;

  @override
  final NERtcDeviceUsage usage;

  DeviceCollectionImpl(this.type, {this.usage = NERtcDeviceUsage.capture}) {
    if (type == NERtcDeviceType.video) {
      // video capture devices.
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEnumerateCaptureDevices,
      };
      InvokeMethod_(jsonEncode(convertJson));
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEnumerateAudioDevices,
        "usage": this.usage.index
      };
      InvokeMethod_(jsonEncode(convertJson));
    }
  }

  @override
  int getCount() {
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcGetDeviceCount,
      "type": type.index,
      "usage": this.usage.index
    };
    int reply = InvokeMethod_(jsonEncode(convertJson));
    return reply;
  }

  @override
  NERtcDesktopDevice getDevice(int index) {
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcGetDevice,
      "type": type.index,
      "usage": this.usage.index,
      "index": index
    };
    final result = InvokeMethod1_(jsonEncode(convertJson));
    return NERtcDesktopDevice.fromJson(jsonDecode(result));
  }

  @override
  NERtcDesktopDeviceInfo getDeviceInfo(int index) {
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcGetDeviceInfo,
      "type": type.index,
      "usage": this.usage.index,
      "index": index
    };
    final result = InvokeMethod1_(jsonEncode(convertJson));
    return NERtcDesktopDeviceInfo.fromJson(jsonDecode(result));
  }

  @override
  void release() {
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcReleaseDevice,
      "type": type.index,
      "usage": this.usage.index
    };
    InvokeMethod_(jsonEncode(convertJson));
  }
}
