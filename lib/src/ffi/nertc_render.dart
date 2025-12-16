// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nertc_core/nertc_core.dart';
import 'package:nertc_core/src/ffi/ffi_define.dart';

final Map<int, void Function(Map<dynamic, dynamic>)> flutter_render_sink_map_ =
    {};

abstract class FlutterRenderSink {
  bool onConsume(String method, Map<String, dynamic> values);
}

class DefaultFlutterRenderSink implements FlutterRenderSink {
  @override
  bool onConsume(String method, Map<String, dynamic> values) {
    if (method == FlutterRenderDelegate.kNERtcFlutterRenderOnFirstFrameRender ||
        method ==
            FlutterRenderDelegate.kNERtcFlutterRenderOnFrameResolutionChanged) {
      final handler = flutter_render_sink_map_[values["textureId"]];
      if (handler == null) return false;
      values["event"] = method;
      handler(values);
      return true;
    }
    return false;
  }
}

final sink = DefaultFlutterRenderSink();

int GenerateFlutterRender(Function(Map<dynamic, dynamic>) event,
    [String? channelTag]) {
  Map<String, dynamic> params = {
    "method": InvokeMethod.kNERtcEngineCreateRender,
  };
  if (channelTag != null) {
    params['channelTag'] = channelTag;
  }
  final json = jsonEncode(params);
  int textureId = InvokeMethod_(json);
  if (flutter_render_sink_map_.isEmpty) RegisterFlutterRenderSink(sink);
  flutter_render_sink_map_[textureId] = event;
  return textureId;
}

void DisposeFlutterRender(int textureId) {
  print("removeTextureKey: $textureId");
  flutter_render_sink_map_.remove(textureId);
  int reply =
      Invoke_(InvokeMethod.kNERtcEngineDisposeRender, {"textureId": textureId});
  print("DisposeFlutterRender textureId: $textureId, reply: $reply");
  if (flutter_render_sink_map_.isEmpty) {
    RegisterFlutterRenderSink(null);
  }
}

int SetFlutterRenderMirror(
    int textureId, bool mirror, int uid, int streamType, bool local) {
  int reply = Invoke_(InvokeMethod.kNERtcEngineSetRenderMirror, {
    "textureId": textureId,
    "mirror": mirror,
    "uid": uid,
    "streamType": streamType,
    "local": local
  });
  if (reply != 0) print("SetFlutterRenderMirror failed: $reply");
  return reply;
}

int SetFlutterRenderScalingMode(
    int textureId, int scalingMode, int uid, int streamType, bool local) {
  return Invoke_(InvokeMethod.kNERtcEngineSetRenderScalingMode, {
    "textureId": textureId,
    "scalingMode": scalingMode,
    "uid": uid,
    "streamType": streamType,
    "local": local
  });
}

int SetUpLocalVideoRender(int? textureId, String? channelTag) {
  Map<String, dynamic> params = {
    "method": InvokeMethod.kNERtcEngineSetUpLocalVideoRender,
    "textureId": textureId == null ? -1 : textureId,
    "streamType": NERtcVideoStreamType.main,
  };

  if (channelTag != null && channelTag.isNotEmpty) {
    params["channelTag"] = channelTag;
    params["isChannel"] = true;
  }

  final json = jsonEncode(params);
  int reply = InvokeMethod_(json);
  if (reply != 0) print("SetupLocalVideoRender failed: $reply");
  return reply;
}

int SetUpLocalSubVideoRender(int? textureId, String? channelTag) {
  Map<String, dynamic> params = {
    "method": InvokeMethod.kNERtcEngineSetUpLocalVideoRender,
    "textureId": textureId == null ? -1 : textureId,
    "streamType": NERtcVideoStreamType.sub,
  };

  if (channelTag != null && channelTag.isNotEmpty) {
    params["channelTag"] = channelTag;
    params["isChannel"] = true;
  }

  final json = jsonEncode(params);
  int reply = InvokeMethod_(json);
  if (reply != 0) print("SetupLocalSubVideoRender failed: $reply");
  return reply;
}

int SetUpRemoteVideoRender(int? textureId, int uid, String? channelTag) {
  Map<String, dynamic> params = {
    "method": InvokeMethod.kNERtcEngineSetUpRemoteVideoRender,
    "textureId": textureId == null ? -1 : textureId,
    "uid": uid,
    "streamType": NERtcVideoStreamType.main,
  };

  if (channelTag != null && channelTag.isNotEmpty) {
    params["channelTag"] = channelTag;
    params["isChannel"] = true;
  }

  final json = jsonEncode(params);
  int reply = InvokeMethod_(json);
  if (reply != 0) print("SetUpRemoteVideoRender failed: $reply");
  return reply;
}

int SetUpRemoteSubVideoRender(int? textureId, int uid, String? channelTag) {
  Map<String, dynamic> params = {
    "method": InvokeMethod.kNERtcEngineSetUpRemoteVideoRender,
    "textureId": textureId == null ? -1 : textureId,
    "uid": uid,
    "streamType": NERtcVideoStreamType.sub,
  };

  if (channelTag != null && channelTag.isNotEmpty) {
    params["channelTag"] = channelTag;
    params["isChannel"] = true;
  }

  final json = jsonEncode(params);
  int reply = InvokeMethod_(json);
  if (reply != 0) print("SetUpRemoteSubVideoRender failed: $reply");
  return reply;
}

int SetUpPlayingStreamRender(int? textureId, String streamId) {
  Map<String, dynamic> params = {
    "method": InvokeMethod.kNERtcEngineSetUpPlayingStreamRender,
    "textureId": textureId == null ? -1 : textureId,
    "streamId": streamId
  };
  final json = jsonEncode(params);
  int reply = InvokeMethod_(json);
  if (reply != 0) print("SetUpPlayingStreamRender failed: $reply");
  return reply;
}
