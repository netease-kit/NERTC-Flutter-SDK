// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcScreenCaptureListImpl extends IScreenCaptureList {
  @override
  final NERtcSize thumbSize;
  @override
  final NERtcSize iconSize;
  @override
  final bool includeScreen;
  @override
  final String channelTag;

  String? _key;

  _NERtcScreenCaptureListImpl(
      this.thumbSize, this.iconSize, this.includeScreen, this.channelTag) {
    Map<String, dynamic> params = {
      "thumbSize_width": thumbSize.width,
      "thumbSize_height": thumbSize.height,
      "iconSize_width": iconSize.width,
      "iconSize_height": iconSize.height,
      "includeScreen": includeScreen
    };

    if (this.channelTag.isNotEmpty) {
      params["isChannel"] = true;
      params["channelTag"] = this.channelTag;
    }

    String jsonParams = jsonEncode({
      "method": ScreenCaptureMethod.kNERtcEngineGetScreenCaptureSources,
      ...params
    });

    print("Calling getScreenCaptureSources with: $jsonParams");

    // InvokeMethod1_ 会处理 code 和 error，如果成功会返回剩余的 JSON 数据
    String resultJson = InvokeMethod1_(jsonParams);
    print("Received result: $resultJson");

    if (resultJson.isNotEmpty) {
      try {
        // 解析返回的 JSON，应该只包含 key 字段
        Map<String, dynamic> result = jsonDecode(resultJson);
        _key = result['key'];

        if (_key == null || _key!.isEmpty) {
          throw Exception("Invalid key received from screen capture sources");
        }

        print("Successfully got screen capture key: $_key");
      } catch (e) {
        print("Error parsing result JSON: $e");
        print("Raw result: $resultJson");
        throw Exception("Failed to parse screen capture sources result: $e");
      }
    } else {
      // resultJson 为空说明 C++ 端返回了错误（code != 0）
      throw Exception("Failed to get screen capture sources");
    }
  }

  @override
  int getCount() {
    if (_key == null || _key == '') return 0;

    Map<String, dynamic> params = {"key": _key};

    if (this.channelTag.isNotEmpty) {
      params["isChannel"] = true;
      params["channelTag"] = this.channelTag;
    }

    return Invoke_(ScreenCaptureMethod.kNERtcEngineGetCaptureCount, params);
  }

  @override
  NERtcScreenCaptureSourceInfo getSourceInfo(int index) {
    if (_key == null || _key == '') {
      throw Exception("Screen capture list is not initialized.");
    }

    Map<String, dynamic> params = {"key": _key, "index": index};

    if (this.channelTag.isNotEmpty) {
      params["isChannel"] = true;
      params["channelTag"] = this.channelTag;
    }

    String sourceInfoJson = InvokeMethod1_(jsonEncode({
      "method": ScreenCaptureMethod.kNERtcEngineGetCaptureSourceInfo,
      ...params
    }));

    if (sourceInfoJson.isEmpty) {
      throw Exception("Failed to get source info for index $index");
    }

    try {
      // 解析返回的 JSON，获取 info 字段的内容
      Map<String, dynamic> responseMap = jsonDecode(sourceInfoJson);

      // 检查是否包含 info 字段
      if (!responseMap.containsKey('info') || responseMap['info'] == null) {
        throw Exception("Response does not contain valid info field");
      }

      // 提取 info 字段的内容
      Map<String, dynamic> sourceInfoMap = responseMap['info'];

      // 使用 info 字段的数据创建 NERtcScreenCaptureSourceInfo 对象
      return NERtcScreenCaptureSourceInfo.fromJson(sourceInfoMap);
    } catch (e) {
      throw Exception(
          "Failed to parse source info JSON: $e\nRaw response: $sourceInfoJson");
    }
  }

  @override
  void release() {
    if (_key == null || _key == '') return;

    Map<String, dynamic> params = {"key": _key};

    if (this.channelTag.isNotEmpty) {
      params["isChannel"] = true;
      params["channelTag"] = this.channelTag;
    }

    Invoke_(ScreenCaptureMethod.kNERtcEngineReleaseCaptureSources, params);
    _key = null;
  }
}

class _NERtcDesktopScreenCaptureImpl extends NERtcDesktopScreenCapture {
  @override
  IScreenCaptureList? getScreenCaptureSources(
      NERtcSize thumbSize, NERtcSize iconSize, bool includeScreen) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return null;
    }
    print(
        "Getting screen capture sources with thumbSize: $thumbSize, iconSize: $iconSize, includeScreen: $includeScreen");
    return _NERtcScreenCaptureListImpl(thumbSize, iconSize, includeScreen, "");
  }

  @override
  int pauseScreenCapture() {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEnginePauseScreenCapture, null);
  }

  @override
  int resumeScreenCapture() {
    return Invoke_(ScreenCaptureMethod.kNERtcEngineResumeScreenCapture, null);
  }

  @override
  int setExcludeWindowList(List<int> windowLists, int count) {
    return Invoke_(ScreenCaptureMethod.kNERtcEngineSetExcludeWindowList,
        {"windowLists": windowLists, "count": count});
  }

  @override
  int setScreenCaptureMouseCursor(bool captureCursor) {
    return Invoke_(ScreenCaptureMethod.kNERtcEngineSetScreenCaptureMouseCursor,
        {"captureCursor": captureCursor});
  }

  @override
  int setScreenCaptureSource(NERtcScreenCaptureSourceInfo source,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEngineSetScreenCaptureSource, {
      "source": source.toJson(),
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int startScreenCaptureByDisplayId(int displayId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineStartScreenCaptureByDisplayId, {
      "displayId": displayId,
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int startScreenCaptureByScreenRect(NERtcRectangle screenRect,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineStartScreenCaptureByScreenRect, {
      "screenRect": screenRect.toJson(),
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int startScreenCaptureByWindowId(int windowId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineStartScreenCaptureByWindowId, {
      "windowId": windowId,
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int stopScreenCapture() {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEngineStopScreenCapture, null);
  }

  @override
  int updateScreenCaptureParameters(
      NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineUpdateScreenCaptureParameters,
        {"captureParams": captureParams.toJson()});
  }

  @override
  int updateScreenCaptureRegion(NERtcRectangle regionRect) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEngineUpdateScreenCaptureRegion,
        {"regionRect": regionRect.toJson()});
  }
}
