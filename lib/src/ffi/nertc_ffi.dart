// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

const String _libName = 'nertc_core';

final DynamicLibrary _dylib = () {
  print("$_libName.framework/$_libName");
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('${_libName}_plugin.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final NERtcBinding _bindings = NERtcBinding(_dylib);
NERtcChannelEventSink? sink_;
FlutterRenderSink? render_sink_;
NERtcStatsEventSink? stats_sink_;
NERtcAudioMixingEventSink? audio_mixing_sink_;
NERtcAudioEffectEventSink? audio_effect_sink_;
Map<String, NERtcSubChannelEventSink> sub_channel_sinks =
    Map<String, NERtcSubChannelEventSink>();
Map<String, NERtcStatsEventSink> _sub_channel_stats_sinks =
    Map<String, NERtcStatsEventSink>();

void RegisterNERtcSubChannelEventSink(
    String channelTag, NERtcSubChannelEventSink subEventSink) {
  if (sub_channel_sinks.containsKey(channelTag)) {
    print("channel $channelTag sink is exist.");
    return;
  }
  sub_channel_sinks[channelTag] = subEventSink;
}

void RegisterNERtcSubChannelStatsSink(
    String channelTag, NERtcStatsEventSink sink) {
  if (_sub_channel_stats_sinks.containsKey(channelTag)) {
    print('channel $channelTag sink is exist.');
    return;
  }
  _sub_channel_stats_sinks[channelTag] = sink;
}

void RemoveNERtcSubChannelStatsSink(String channelTag) {
  _sub_channel_stats_sinks.remove(channelTag);
}

void ClearChannelEventSinkMaps() {
  sub_channel_sinks.clear();
}

void RegisterNERtcEventSink(NERtcChannelEventSink? sink) {
  print("RegisterNertcEventSink: $sink");
  sink_ = sink;
}

void RegisterAudioEffectSink(NERtcAudioEffectEventSink? sink) {
  audio_effect_sink_ = sink;
  print("RegisterAudioEffectSink: ${sink}");
}

void RegisterAudioMixingSink(NERtcAudioMixingEventSink? sink) {
  audio_mixing_sink_ = sink;
  print("RegisterAudioMixingSink: ${sink}");
}

void RegisterMediaStatsSink(NERtcStatsEventSink? sink) {
  stats_sink_ = sink;
  print("RegisterMediaStatsSink: ${sink}");
}

void RegisterFlutterRenderSink(FlutterRenderSink? sink) {
  render_sink_ = sink;
  print("RegisterFlutterRenderSink: $sink");
}

int Invoke_(String method, Map<String, dynamic>? params) {
  return InvokeMethod_(jsonEncode({
    "method": method,
    ...?params,
  }));
}

int PushVideoFrame(
    String params, Uint8List data, List<double>? transformMatrix) {
  final Pointer<Uint8> dataPtr = calloc<Uint8>(data.length);
  dataPtr.asTypedList(data.length).setAll(0, data);

  Pointer<Double>? matrixPtr;
  if (transformMatrix != null) {
    matrixPtr = calloc<Double>(transformMatrix.length);
    for (var i = 0; i < transformMatrix.length; i++) {
      matrixPtr[i] = transformMatrix[i];
    }
  }

  try {
    if (matrixPtr != null) {
      return _bindings.PushVideoFrame(
          params.toNativeUtf8().cast(), dataPtr, matrixPtr);
    } else {
      return _bindings.PushVideoFrame(
          params.toNativeUtf8().cast(), dataPtr, nullptr);
    }
  } finally {
    calloc.free(dataPtr);
    if (matrixPtr != null) {
      calloc.free(matrixPtr);
    }
  }
}

int PushDataFrame(String params, Uint8List data) {
  final Pointer<Uint8> dataPtr = calloc<Uint8>(data.length);
  dataPtr.asTypedList(data.length).setAll(0, data);

  try {
    return _bindings.PushDataFrame(params.toNativeUtf8().cast(), dataPtr);
  } finally {
    calloc.free(dataPtr);
  }
}

int PushAudioFrame(String params, Uint8List data) {
  final Pointer<Uint8> dataPtr = calloc<Uint8>(data.length);
  dataPtr.asTypedList(data.length).setAll(0, data);

  try {
    return _bindings.PushAudioFrame(params.toNativeUtf8().cast(), dataPtr);
  } finally {
    calloc.free(dataPtr);
  }
}

int InvokeMethod_(String params) {
  var result = _bindings.InvokeMethod(params.toNativeUtf8().cast());
  return result;
}

String InvokeMethod1_(String params) {
  Pointer<Char> result =
      _bindings.InvokeStrMethod(params.toNativeUtf8().cast());
  if (result == nullptr) {
    return "";
  }
  final str = result.cast<Utf8>().toDartString();
  malloc.free(result);
  try {
    final Map<String, dynamic> jsonMap = jsonDecode(str);
    final code = jsonMap['code'];
    if (code != 0) {
      final message = jsonMap['error'] ?? 'Unknown error';
      print('InvokeMethod1_ failed: $message (code: $code)');
      return "";
    }
    jsonMap.remove('code');
    jsonMap.remove('error');
    return jsonEncode(jsonMap);
  } catch (e) {
    return str;
  }
}

ReceivePort _receivePort = ReceivePort();
bool initialized = false;
void InitializedDartApiDL_() {
  if (initialized) {
    print("DartApiDL_ has been initialized.");
    return;
  }
  var nativeInited = _bindings.InitDartApiDL(NativeApi.initializeApiDLData);
  assert(nativeInited == 0, 'DART_API_DL_MAJOR_VERSION != 2');
  _receivePort.listen((message) {
    Map<String, dynamic> parse;
    if (message is String) {
      parse = json.decode(message);
    } else if (message is Map) {
      parse = Map<String, dynamic>.from(message);
    } else {
      if (message is List<dynamic>) {
        dispatchDynamicListMethod(message);
      }
      return;
    }

    String? channel;
    if (parse.containsKey('channel_tag')) {
      channel = parse['channel_tag'] as String;
    }

    final String? method = parse['method'] as String;

    if (method == null) {
      print("Method is missing in the parse data.");
      return;
    }

    if (parse.remove('method') == null) {
      print("parse remove method failed.");
    }

    if (!(render_sink_?.onConsume(method, parse) ?? false))
      handleMethod(channel, method, parse);
  });
  _bindings.RegisterNativePort(_receivePort.sendPort.nativePort);
  initialized = true;
}

void dispatchDynamicListMethod(List<dynamic> message) {
  Map<String, dynamic> parse = json.decode(message.elementAt(0) as String);
  final String? method = parse['method'] as String;

  if (method == null) {
    print("Method is missing in the parse data.");
    return;
  }

  if (parse.remove('method') == null) {
    print("parse remove method failed.");
  }

  if (method == DelegateMethod.kNERtcOnUserDataReceiveMessage) {
    Uint8List data = message.elementAt(1) as Uint8List;
    sink_?.onUserDataReceiveMessage(parse['uid'], data, parse['size']);
  }
}

typedef MethodTransFormer = void Function(Map<String, dynamic>);
typedef ChannelTransFormer = void Function(
    NERtcSubChannelEventSink, Map<String, dynamic>);

final Map<String, MethodTransFormer> transformMap = {
  DelegateMethod.kNERtcOnJoinChannel: (Map<String, dynamic> values) {
    sink_?.onJoinChannel(values['result'], values['cid'].toInt(),
        values['elapsed'], values['uid'].toInt());
  },
  DelegateMethod.kNERtcOnLeaveChannel: (Map<String, dynamic> values) {
    sink_?.onLeaveChannel(values['result']);
  },
  DelegateMethod.kNERtcOnUserJoined: (Map<String, dynamic> values) {
    UserJoinedEvent event = UserJoinedEvent(uid: values['uid']);
    if (values.containsKey('join_extra_info')) {
      final joinExtraInfo = values['join_extra_info'] as String;
      if (joinExtraInfo.isNotEmpty) {
        event.joinExtraInfo = NERtcUserJoinExtraInfo(customInfo: joinExtraInfo);
      }
    }
    sink_?.onUserJoined(event);
  },
  DelegateMethod.kNERtcOnUserLeave: (Map<String, dynamic> values) {
    UserLeaveEvent event =
        UserLeaveEvent(uid: values['uid'], reason: values['reason']);
    if (values.containsKey('leave_extra_info')) {
      final leaveExtraInfo = values['leave_extra_info'] as String;
      if (leaveExtraInfo.isNotEmpty) {
        event.leaveExtraInfo =
            NERtcUserLeaveExtraInfo(customInfo: leaveExtraInfo);
      }
    }
    sink_?.onUserLeave(event);
  },
  DelegateMethod.kNERtcOnUserAudioStart: (Map<String, dynamic> values) {
    sink_?.onUserAudioStart(values['uid']);
  },
  DelegateMethod.kNERtcOnUserAudioStop: (Map<String, dynamic> values) {
    sink_?.onUserAudioStop(values['uid']);
  },
  DelegateMethod.kNERtcOnUserVideoStart: (Map<String, dynamic> values) {
    sink_?.onUserVideoStart(values['uid'], values['max_profile']);
  },
  DelegateMethod.kNERtcOnUserVideoStop: (Map<String, dynamic> values) {
    sink_?.onUserVideoStop(values['uid']);
  },
  DelegateMethod.kNERtcOnError: (Map<String, dynamic> values) {
    sink_?.onError(values['error_code']);
  },
  DelegateMethod.kNERtcOnWarning: (Map<String, dynamic> values) {
    sink_?.onWarning(values['warn_code']);
  },
  DelegateMethod.kNERtcOnReconnectingStart: (Map<String, dynamic> values) {
    sink_?.onReconnectingStart();
  },
  DelegateMethod.kNERtcOnConnectionStateChange: (Map<String, dynamic> values) {
    sink_?.onConnectionStateChanged(values['state'], values['reason']);
  },
  DelegateMethod.kNERtcOnRejoinChannel: (Map<String, dynamic> values) {
    sink_?.onReJoinChannel(values['result'], values['cid']);
  },
  DelegateMethod.kNERtcOnDisconnect: (Map<String, dynamic> values) {
    sink_?.onDisconnect(values['reason']);
  },
  DelegateMethod.kNERtcOnClientRoleChanged: (Map<String, dynamic> values) {
    sink_?.onClientRoleChange(values['oldRole'], values['newRole']);
  },
  DelegateMethod.kNERtcOnUserSubStreamAudioStart:
      (Map<String, dynamic> values) {
    sink_?.onUserSubStreamAudioStart(values['uid']);
  },
  DelegateMethod.kNERtcOnUserSubStreamAudioStop: (Map<String, dynamic> values) {
    sink_?.onUserSubStreamAudioStop(values['uid']);
  },
  DelegateMethod.kNERtcOnUserAudioMute: (Map<String, dynamic> values) {
    sink_?.onUserAudioMute(values['uid'], values['mute']);
  },
  DelegateMethod.kNERtcOnUserVideoMute: (Map<String, dynamic> values) {
    UserVideoMuteEvent event =
        UserVideoMuteEvent(uid: values['uid'], muted: values['mute']);
    event.streamType = values['streamType'];
    sink_?.onUserVideoMute(event);
  },
  DelegateMethod.kNERtcOnUserSubStreamAudioMute: (Map<String, dynamic> values) {
    sink_?.onUserSubStreamAudioMute(values['uid'], values['mute']);
  },
  DelegateMethod.kNERtcOnFirstAudioDataReceived: (Map<String, dynamic> values) {
    sink_?.onFirstAudioDataReceived(values['uid']);
  },
  DelegateMethod.kNERtcOnFirstVideoDataReceived: (Map<String, dynamic> values) {
    FirstVideoDataReceivedEvent event =
        FirstVideoDataReceivedEvent(uid: values['uid']);
    event.streamType = values['type'];
    sink_?.onFirstVideoDataReceived(event);
  },
  DelegateMethod.kNERtcOnFirstAudioFrameDecoded: (Map<String, dynamic> values) {
    sink_?.onFirstAudioFrameDecoded(values['uid']);
  },
  DelegateMethod.kNERtcOnFirstVideoFrameDecoded: (Map<String, dynamic> values) {
    FirstVideoFrameDecodedEvent event = FirstVideoFrameDecodedEvent(
        uid: values['uid'], width: values['width'], height: values['height']);
    event.streamType = values['streamType'];
    sink_?.onFirstVideoFrameDecoded(event);
  },
  DelegateMethod.kNERtcOnVirtualBackgroundSourceEnabled:
      (Map<String, dynamic> values) {
    VirtualBackgroundSourceEnabledEvent event =
        VirtualBackgroundSourceEnabledEvent(
            enabled: values['enabled'], reason: values['reason']);
    sink_?.onVirtualBackgroundSourceEnabled(event);
  },
  DelegateMethod.kNERtcOnNetworkConnectionTypeChanged:
      (Map<String, dynamic> values) {
    sink_?.onConnectionTypeChanged(values['newConnectionType']);
  },
  DelegateMethod.kNERtcOnLocalAudioVolumeIndication:
      (Map<String, dynamic> values) {
    sink_?.onLocalAudioVolumeIndication(values['volume'], values['enable_vad']);
  },
  DelegateMethod.kNERtcOnRemoteAudioVolumeIndication:
      (Map<String, dynamic> values) {
    if (values['volume_info'] == null) return;
    final List<dynamic> volumeInfos = values['volume_info'];

    RemoteAudioVolumeIndicationEvent event =
        RemoteAudioVolumeIndicationEvent(totalVolume: values['total_volume']);
    List<AudioVolumeInfo> infos = volumeInfos.map((item) {
      final map = item as Map<String, dynamic>;
      return AudioVolumeInfo(
          uid: map['uid'] as int,
          volume: map['volume'] as int,
          subStreamVolume: map['sub_stream_volume'] as int);
    }).toList();
    event.volumeList = infos;
    event.totalVolume = values['total_volume'];
    sink_?.onRemoteAudioVolumeIndication(event);
  },
  DelegateMethod.kNERtcOnAudioHowling: (Map<String, dynamic> values) {
    bool howling = values['howling'];
    if (howling) {
      sink_?.onAudioHasHowling();
    }
  },
  DelegateMethod.kNERtcOnLastMileQuality: (Map<String, dynamic> values) {
    sink_?.onLastmileQuality(values['quality']);
  },
  DelegateMethod.kNERtcOnLastMileProbeResult: (Map<String, dynamic> values) {
    NERtcLastmileProbeOneWayResult uplinkResult =
        NERtcLastmileProbeOneWayResult(
            packetLossRate: values['uplink_report']['packet_loss_rate'],
            jitter: values['uplink_report']['jitter'],
            availableBandwidth: values['uplink_report']
                ['available_band_width']);
    NERtcLastmileProbeOneWayResult downlinkResult =
        NERtcLastmileProbeOneWayResult(
            packetLossRate: values['downlink_report']['packet_loss_rate'],
            jitter: values['downlink_report']['jitter'],
            availableBandwidth: values['downlink_report']
                ['available_band_width']);
    NERtcLastmileProbeResult result = NERtcLastmileProbeResult(
        state: values['state'],
        rtt: values['rtt'],
        uplinkReport: uplinkResult,
        downlinkReport: downlinkResult);
    sink_?.onLastmileProbeResult(result);
  },
  DelegateMethod.kNERtcOnAddLiveStreamTask: (Map<String, dynamic> values) {
    print(
        "onAddLiveStreamTask, task_id: ${values['task_id']}, url: ${values['url']}, error_code: ${values['error_code']}");
  },
  DelegateMethod.kNERtcOnUpdateLiveStreamTask: (Map<String, dynamic> values) {
    print(
        "onUpdateLiveStreamTask, task_id: ${values['task_id']}, url: ${values['url']}, error_code: ${values['error_code']}");
  },
  DelegateMethod.kNERtcOnRemoveLiveStreamTask: (Map<String, dynamic> values) {
    print(
        "onRemoveLiveStreamTask, task_id: ${values['task_id']}, error_code: ${values['error_code']}");
  },
  DelegateMethod.kNERtcOnLiveStreamStateChanged: (Map<String, dynamic> values) {
    sink_?.onLiveStreamState(values['task_id'], values['url'], values['state']);
  },
  DelegateMethod.kNERtcOnRecvSEIMsg: (Map<String, dynamic> values) {
    sink_?.onRecvSEIMsg(values['uid'], values['data']);
  },
  DelegateMethod.kNERtcOnAudioRecording: (Map<String, dynamic> values) {
    sink_?.onAudioRecording(values['code'], values['file_path']);
  },
  DelegateMethod.kNERtcOnMediaRightChange: (Map<String, dynamic> values) {
    sink_?.onMediaRightChange(
        values['is_audio_banned'], values['is_video_banned']);
  },
  DelegateMethod.kNERtcOnMediaRelayStateChanged: (Map<String, dynamic> values) {
    sink_?.onMediaRelayStatesChange(values['state'], values['channel_name']);
  },
  DelegateMethod.kNERtcOnMediaRelayEvent: (Map<String, dynamic> values) {
    sink_?.onMediaRelayReceiveEvent(
        values['event'], values['error'], values['channel_name']);
  },
  DelegateMethod.kNERtcOnLocalPublishFallbackToAudioOnly:
      (Map<String, dynamic> values) {
    sink_?.onLocalPublishFallbackToAudioOnly(
        values['is_fallback'], values['stream_type']);
  },
  DelegateMethod.kNERtcOnRemoteSubscribeFallbackAudioOnly:
      (Map<String, dynamic> values) {
    sink_?.onRemoteSubscribeFallbackToAudioOnly(
        values['uid'], values['is_fallback'], values['stream_type']);
  },
  DelegateMethod.kNERtcOnTakeSnapshotResult: (Map<String, dynamic> values) {
    sink_?.onTakeSnapshotResult(values['code'], values['path']);
  },
  DelegateMethod.kNERtcOnUserSubVideoStreamStart:
      (Map<String, dynamic> values) {
    sink_?.onUserSubStreamVideoStart(values['uid'], values['max_profile']);
  },
  DelegateMethod.kNERtcOnUserSubVideoStreamStop: (Map<String, dynamic> values) {
    sink_?.onUserSubStreamVideoStop(values['uid']);
  },
  DelegateMethod.kNERtcOnAudioMixingStateChanged:
      (Map<String, dynamic> values) {
    audio_mixing_sink_?.onAudioMixingStateChanged(values['state']);
  },
  DelegateMethod.kNERtcOnAudioMixingTimestampUpdate:
      (Map<String, dynamic> values) {
    audio_mixing_sink_?.onAudioMixingTimestampUpdate(values['timestamp_ms']);
  },
  DelegateMethod.kNERtcOnAudioEffectFinished: (Map<String, dynamic> values) {
    audio_effect_sink_?.onAudioEffectFinished(values['effect_id']);
  },
  DelegateMethod.kNERtcOnAudioEffectTimestampUpdate:
      (Map<String, dynamic> values) {
    audio_effect_sink_?.onAudioEffectTimestampUpdate(
        values['effect_id'], values['timestamp_ms']);
  },
  DelegateMethod.kNERtcOnLocalVideoWatermarkState:
      (Map<String, dynamic> values) {
    sink_?.onLocalVideoWatermarkState(
        values['videoStreamType'], values['state']);
  },
  MediaStatsDelegate.kNERtcOnStats: (Map<String, dynamic> values) {
    stats_sink_?.onRtcStats(values, "");
  },
  MediaStatsDelegate.kNERtcOnNetworkQuality: (Map<String, dynamic> values) {
    stats_sink_?.onNetworkQuality(values, "");
  },
  MediaStatsDelegate.kNERtcOnLocalAudioStats: (Map<String, dynamic> values) {
    stats_sink_?.onLocalAudioStats(values, "");
  },
  MediaStatsDelegate.kNERtcOnRemoteAudioStats: (Map<String, dynamic> values) {
    stats_sink_?.onRemoteAudioStats(values, "");
  },
  MediaStatsDelegate.kNERtcOnLocalVideoStats: (Map<String, dynamic> values) {
    stats_sink_?.onLocalVideoStats(values, "");
  },
  MediaStatsDelegate.kNERtcOnRemoteVideoStats: (Map<String, dynamic> values) {
    stats_sink_?.onRemoteVideoStats(values, "");
  },
  DelegateMethod.kNERtcOnAsrCaptionStateChanged: (Map<String, dynamic> values) {
    sink_?.onAsrCaptionStateChanged(values['asrState'] as int,
        values['code'] as int, values['message'] as String);
  },
  DelegateMethod.kNERtcOnAsrCaptionResult: (Map<String, dynamic> values) {
    final List<dynamic> resultList = values['result'] as List<dynamic>;
    final List<Map<Object?, Object?>> result = resultList
        .map((item) => Map<Object?, Object?>.from(item as Map))
        .toList();
    sink_?.onAsrCaptionResult(result, values['resultCount'] as int);
  },
  DelegateMethod.kNERtcOnPlayStreamingStateChange:
      (Map<String, dynamic> values) {
    sink_?.onPlayStreamingStateChange(values['streamId'] as String,
        values['state'] as int, values['reason'] as int);
  },
  DelegateMethod.kNERtcOnPlayStreamingReceiveSeiMessage:
      (Map<String, dynamic> values) {
    sink_?.onPlayStreamingReceiveSeiMessage(
        values['streamId'] as String, values['message'] as String);
  },
  DelegateMethod.kNERtcOnPlayStreamingFirstAudioFramePlayed:
      (Map<String, dynamic> values) {
    sink_?.onPlayStreamingFirstAudioFramePlayed(
        values['streamId'] as String, values['timeMs'] as int);
  },
  DelegateMethod.kNERtcOnPlayStreamingFirstVideoFrameRender:
      (Map<String, dynamic> values) {
    sink_?.onPlayStreamingFirstVideoFrameRender(
        values['streamId'] as String,
        values['timeMs'] as int,
        values['width'] as int,
        values['height'] as int);
  },
  DelegateMethod.kNERtcOnFirstVideoFrameRender: (Map<String, dynamic> values) {
    sink_?.onFirstVideoFrameRender(
        values['userID'] as int,
        values['streamType'] as int,
        values['width'] as int,
        values['height'] as int,
        values['elapsedTime'] as int);
  },
  DelegateMethod.kNERtcOnLocalVideoRenderSizeChanged:
      (Map<String, dynamic> values) {
    sink_?.onLocalVideoRenderSizeChanged(values['videoType'] as int,
        values['width'] as int, values['height'] as int);
  },
  DelegateMethod.kNERtcOnUserVideoProfileUpdate: (Map<String, dynamic> values) {
    sink_?.onUserVideoProfileUpdate(
        values['uid'] as int, values['maxProfile'] as int);
  },
  DelegateMethod.kNERtcOnAudioDeviceStateChange: (Map<String, dynamic> values) {
    sink_?.onAudioDeviceStateChange(
        values['deviceType'] as int, values['deviceState'] as int);
  },
  DelegateMethod.kNERtcOnRemoteVideoSizeChanged: (Map<String, dynamic> values) {
    sink_?.onRemoteVideoSizeChanged(
        values['uid'] as int,
        values['streamType'] as int,
        values['width'] as int,
        values['height'] as int);
  },
  DelegateMethod.kNERtcOnUserDataStart: (Map<String, dynamic> values) {
    sink_?.onUserDataStart(values['uid'] as int);
  },
  DelegateMethod.kNERtcOnUserDataStop: (Map<String, dynamic> values) {
    sink_?.onUserDataStop(values['uid'] as int);
  },
  DelegateMethod.kNERtcOnUserDataStateChanged: (Map<String, dynamic> values) {
    sink_?.onUserDataStateChanged(values['uid'] as int);
  },
  DelegateMethod.kNERtcOnUserDataBufferedAmountChanged:
      (Map<String, dynamic> values) {
    sink_?.onUserDataBufferedAmountChanged(
        values['uid'] as int, values['previousAmount'] as int);
  },
  DelegateMethod.kNERtcOnLabFeatureCallback: (Map<String, dynamic> values) {
    final param = values['param'];
    Map<Object?, Object?> paramMap;
    if (param is Map) {
      paramMap = Map<Object?, Object?>.from(param);
    } else {
      paramMap = {};
    }
    sink_?.onLabFeatureCallback(values['key'] as String, paramMap);
  },
  DelegateMethod.kNERtcOnAiData: (Map<String, dynamic> values) {
    sink_?.onAiData(values['type'] as String, values['data'] as String);
  },
  DelegateMethod.kNERtcOnStartPushStreaming: (Map<String, dynamic> values) {
    sink_?.onStartPushStreaming(
        values['result'] as int, values['channelId'] as int);
  },
  DelegateMethod.kNERtcOnStopPushStreaming: (Map<String, dynamic> values) {
    sink_?.onStopPushStreaming(values['result'] as int);
  },
  DelegateMethod.kNERtcOnPushStreamingReconnecting:
      (Map<String, dynamic> values) {
    sink_?.onPushStreamingReconnecting(values['reason'] as int);
  },
  DelegateMethod.kNERtcOnPushStreamingReconnectedSuccess:
      (Map<String, dynamic> values) {
    sink_?.onPushStreamingReconnectedSuccess();
  },
  DelegateMethod.kNERtcOnScreenCaptureStatus: (Map<String, dynamic> values) {
    sink_?.onScreenCaptureStatus(values['status'] as int);
  },
  DelegateMethod.kNERtcOnScreenCaptureSourceDataUpdate:
      (Map<String, dynamic> values) {
    final captureRectMap = values['capture_rect'] as Map<String, dynamic>;
    final captureRect = Rectangle(
        x: captureRectMap['x'] as int,
        y: captureRectMap['y'] as int,
        width: captureRectMap['width'] as int,
        height: captureRectMap['height'] as int);
    final data = ScreenCaptureSourceData(
        type: values['type'] as int,
        sourceId: 0,
        status: values['status'] as int,
        action: values['action'] as int,
        captureRect: captureRect,
        level: values['level'] as int);
    sink_?.onScreenCaptureSourceDataUpdate(data);
  },
  DelegateMethod.kNERtcOnLocalRecorderStatus: (Map<String, dynamic> values) {
    sink_?.onLocalRecorderStatus(
        values['status'] as int, values['task_id'] as String);
  },
  DelegateMethod.kNERtcOnLocalRecorderError: (Map<String, dynamic> values) {
    sink_?.onLocalRecorderError(
        values['error'] as int, values['task_id'] as String);
  },
  DelegateMethod.kNERtcOnCheckNECastAudioDriverResult:
      (Map<String, dynamic> values) {
    sink_?.onCheckNECastAudioDriverResult(values['result'] as int);
  },
  DelegateMethod.kNERtcOnLocalAudioFirstPacketSent:
      (Map<String, dynamic> values) {
    sink_?.onLocalAudioFirstPacketSent(values['audioStreamType'] as int);
  },
  DelegateMethod.kNERtcOnReleasedHwResources: (Map<String, dynamic> values) {
    sink_?.onReleasedHwResources(values['result']);
  },
  DelegateMethod.kNERtcOnApiCallExecuted: (Map<String, dynamic> values) {
    sink_?.onApiCallExecuted(
        values['api_name'], values['error'], values['message']);
  }
};

final Map<String, ChannelTransFormer> channelTransFormMap = {
  DelegateMethod.kNERtcOnError:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onError(values['channel_tag'], values['error_code']);
  },
  DelegateMethod.kNERtcOnWarning:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onWarning(values['channel_tag'], values['warn_code']);
  },
  DelegateMethod.kNERtcOnApiCallExecuted:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onApiCallExecuted(values['channel_tag'], values['api_name'] ?? '',
        values['error'] ?? 0, values['message'] ?? '');
  },
  DelegateMethod.kNERtcOnJoinChannel:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onJoinChannel(
        values['channel_tag'],
        values['result'],
        values['cid']?.toInt() ?? 0,
        values['elapsed'] ?? 0,
        values['uid']?.toInt() ?? 0);
  },
  DelegateMethod.kNERtcOnReconnectingStart:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onReconnectingStart(values['channel_tag']);
  },
  DelegateMethod.kNERtcOnConnectionStateChange:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onConnectionStateChanged(
        values['channel_tag'], values['state'], values['reason']);
  },
  DelegateMethod.kNERtcOnRejoinChannel:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onReJoinChannel(
        values['channel_tag'], values['result'], values['cid']?.toInt() ?? 0);
  },
  DelegateMethod.kNERtcOnLeaveChannel:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onLeaveChannel(values['channel_tag'], values['result']);
  },
  DelegateMethod.kNERtcOnDisconnect:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onDisconnect(values['channel_tag'], values['reason']);
  },
  DelegateMethod.kNERtcOnClientRoleChanged:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onClientRoleChange(
        values['channel_tag'], values['oldRole'], values['newRole']);
  },
  DelegateMethod.kNERtcOnUserJoined:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    UserJoinedEvent event = UserJoinedEvent(uid: values['uid']);
    if (values.containsKey('join_extra_info')) {
      final joinExtraInfo = values['join_extra_info'] as String;
      if (joinExtraInfo.isNotEmpty) {
        event.joinExtraInfo = NERtcUserJoinExtraInfo(customInfo: joinExtraInfo);
      }
    }
    sink_.onUserJoined(values['channel_tag'], event);
  },
  DelegateMethod.kNERtcOnUserLeave:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    UserLeaveEvent event =
        UserLeaveEvent(uid: values['uid'], reason: values['reason']);
    if (values.containsKey('leave_extra_info')) {
      final leaveExtraInfo = values['leave_extra_info'] as String;
      if (leaveExtraInfo.isNotEmpty) {
        event.leaveExtraInfo =
            NERtcUserLeaveExtraInfo(customInfo: leaveExtraInfo);
      }
    }
    sink_.onUserLeave(values['channel_tag'], event);
  },
  DelegateMethod.kNERtcOnUserAudioStart:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserAudioStart(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnUserAudioStop:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserAudioStop(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnUserAudioMute:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserAudioMute(values['channel_tag'], values['uid'], values['mute']);
  },
  DelegateMethod.kNERtcOnUserSubStreamAudioStart:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserSubStreamAudioStart(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnUserSubStreamAudioStop:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserSubStreamAudioStop(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnUserSubStreamAudioMute:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserSubStreamAudioMute(
        values['channel_tag'], values['uid'], values['mute']);
  },
  DelegateMethod.kNERtcOnUserVideoStart:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserVideoStart(
        values['channel_tag'], values['uid'], values['max_profile']);
  },
  DelegateMethod.kNERtcOnUserVideoStop:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserVideoStop(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnUserVideoMute:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    UserVideoMuteEvent event =
        UserVideoMuteEvent(uid: values['uid'], muted: values['mute']);
    event.streamType = values['videoStreamType'];
    sink_.onUserVideoMute(values['channel_tag'], event);
  },
  DelegateMethod.kNERtcOnUserSubVideoStreamStart:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserSubStreamVideoStart(
        values['channel_tag'], values['uid'], values['max_profile']);
  },
  DelegateMethod.kNERtcOnUserSubVideoStreamStop:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onUserSubStreamVideoStop(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnScreenCaptureStatus:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onScreenCaptureStatus(values['channel_tag'], values['status']);
  },
  DelegateMethod.kNERtcOnScreenCaptureSourceDataUpdate:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    final captureRectMap = values['capture_rect'] as Map<String, dynamic>;
    final captureRect = Rectangle(
        x: captureRectMap['x'] as int,
        y: captureRectMap['y'] as int,
        width: captureRectMap['width'] as int,
        height: captureRectMap['height'] as int);
    final data = ScreenCaptureSourceData(
        type: values['type'] as int,
        sourceId: 0,
        status: values['status'] as int,
        action: values['action'] as int,
        captureRect: captureRect,
        level: values['level'] as int);
    sink_.onScreenCaptureSourceDataUpdate(values['channel_tag'], data);
  },
  DelegateMethod.kNERtcOnFirstAudioDataReceived:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onFirstAudioDataReceived(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnFirstVideoDataReceived:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    FirstVideoDataReceivedEvent event =
        FirstVideoDataReceivedEvent(uid: values['uid']);
    event.streamType = values['stream_type'];
    sink_.onFirstVideoDataReceived(values['channel_tag'], event);
  },
  DelegateMethod.kNERtcOnRemoteVideoSizeChanged:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onRemoteVideoSizeChanged(
        values['channel_tag'],
        values['uid'] ?? values['userId'],
        values['type'] ?? values['videoType'],
        values['width'],
        values['height']);
  },
  DelegateMethod.kNERtcOnLocalVideoRenderSizeChanged:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onLocalVideoRenderSizeChanged(values['channel_tag'],
        values['videoType'], values['width'], values['height']);
  },
  DelegateMethod.kNERtcOnFirstAudioFrameDecoded:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onFirstAudioFrameDecoded(values['channel_tag'], values['uid']);
  },
  DelegateMethod.kNERtcOnFirstVideoFrameDecoded:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    FirstVideoFrameDecodedEvent event = FirstVideoFrameDecodedEvent(
        uid: values['uid'], width: values['width'], height: values['height']);
    event.streamType = values['streamType'];
    sink_.onFirstVideoFrameDecoded(values['channel_tag'], event);
  },
  DelegateMethod.kNERtcOnFirstVideoFrameRender:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onFirstVideoFrameRender(
        values['channel_tag'],
        values['uid'] ?? values['userID'],
        values['streamType'],
        values['width'],
        values['height'],
        values['elapsedTime']);
  },
  DelegateMethod.kNERtcOnLocalAudioVolumeIndication:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onLocalAudioVolumeIndication(
        values['channel_tag'], values['volume'], values['enable_vad']);
  },
  DelegateMethod.kNERtcOnRemoteAudioVolumeIndication:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    if (values['volume_info'] == null) return;
    final List<dynamic> volumeInfos = values['volume_info'];
    RemoteAudioVolumeIndicationEvent event =
        RemoteAudioVolumeIndicationEvent(totalVolume: values['total_volume']);
    List<AudioVolumeInfo> infos = volumeInfos.map((item) {
      final map = item as Map<String, dynamic>;
      return AudioVolumeInfo(
          uid: map['uid'] as int,
          volume: map['volume'] as int,
          subStreamVolume: map['sub_stream_volume'] as int);
    }).toList();
    event.volumeList = infos;
    event.totalVolume = values['total_volume'];
    sink_.onRemoteAudioVolumeIndication(values['channel_tag'], event);
  },
  DelegateMethod.kNERtcOnAddLiveStreamTask:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    print(
        "onAddLiveStreamTask, task_id: ${values['task_id']}, url: ${values['url']}, error_code: ${values['error_code']}");
  },
  DelegateMethod.kNERtcOnUpdateLiveStreamTask:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    print(
        "onUpdateLiveStreamTask, task_id: ${values['task_id']}, url: ${values['url']}, error_code: ${values['error_code']}");
  },
  DelegateMethod.kNERtcOnRemoveLiveStreamTask:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    print(
        "onRemoveLiveStreamTask, task_id: ${values['task_id']}, error_code: ${values['error_code']}");
  },
  DelegateMethod.kNERtcOnLiveStreamStateChanged:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onLiveStreamState(values['channel_tag'], values['task_id'] ?? '',
        values['url'] ?? '', values['state']);
  },
  DelegateMethod.kNERtcOnRecvSEIMsg:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onRecvSEIMsg(
        values['channel_tag'], values['uid'], values['data'] ?? '');
  },
  DelegateMethod.kNERtcOnMediaRelayStateChanged:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onMediaRelayStatesChange(
        values['channel_tag'], values['state'], values['channel_name'] ?? '');
  },
  DelegateMethod.kNERtcOnMediaRelayEvent:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onMediaRelayReceiveEvent(values['channel_tag'], values['event'],
        values['error'], values['channel_name'] ?? '');
  },
  DelegateMethod.kNERtcOnLocalPublishFallbackToAudioOnly:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onLocalPublishFallbackToAudioOnly(
        values['channel_tag'], values['is_fallback'], values['stream_type']);
  },
  DelegateMethod.kNERtcOnRemoteSubscribeFallbackAudioOnly:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onRemoteSubscribeFallbackToAudioOnly(values['channel_tag'],
        values['uid'], values['is_fallback'], values['stream_type']);
  },
  DelegateMethod.kNERtcOnMediaRightChange:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    sink_.onMediaRightChange(values['channel_tag'], values['is_audio_banned'],
        values['is_video_banned']);
  },
  DelegateMethod.kNERtcOnLabFeatureCallback:
      (NERtcSubChannelEventSink sink_, Map<String, dynamic> values) {
    final param = values['param'];
    Map<Object?, Object?> paramMap;
    if (param is Map) {
      paramMap = Map<Object?, Object?>.from(param);
    } else if (param is String && param.isNotEmpty) {
      try {
        paramMap = Map<Object?, Object?>.from(jsonDecode(param));
      } catch (e) {
        paramMap = {};
      }
    } else {
      paramMap = {};
    }
    sink_.onLabFeatureCallback(
        values['channel_tag'], values['key'] ?? '', paramMap);
  },
};

void handleMethod(
    String? channelTag, String method, Map<String, dynamic> values) {
  if (channelTag == null) {
    final transformer = transformMap[method];
    if (transformer == null) {
      print("Transformer not found for: $method");
      return;
    }
    return transformer(values);
  } else {
    if (_handleSubChannelStatsCallback(method, channelTag, values)) {
      return;
    }

    final sink_ = sub_channel_sinks[channelTag];
    if (sink_ == null) {
      print("Channel sink not found for: $channelTag");
      return;
    }
    final transformer = channelTransFormMap[method];
    if (transformer == null) {
      print("Channel transformer not found for: $method");
      return;
    }
    return transformer(sink_, values);
  }
}

bool _handleSubChannelStatsCallback(
    String method, String channelTag, Map<String, dynamic> values) {
  if (method == MediaStatsDelegate.kNERtcOnStats ||
      method == MediaStatsDelegate.kNERtcOnNetworkQuality ||
      method == MediaStatsDelegate.kNERtcOnLocalAudioStats ||
      method == MediaStatsDelegate.kNERtcOnRemoteAudioStats ||
      method == MediaStatsDelegate.kNERtcOnLocalVideoStats ||
      method == MediaStatsDelegate.kNERtcOnRemoteVideoStats) {
    final sink_ = _sub_channel_stats_sinks[channelTag];
    if (sink_ != null) {
      if (method == MediaStatsDelegate.kNERtcOnStats) {
        sink_.onRtcStats(values, channelTag);
      } else if (method == MediaStatsDelegate.kNERtcOnNetworkQuality) {
        sink_.onNetworkQuality(values, channelTag);
      } else if (method == MediaStatsDelegate.kNERtcOnLocalAudioStats) {
        sink_.onLocalAudioStats(values, channelTag);
      } else if (method == MediaStatsDelegate.kNERtcOnRemoteAudioStats) {
        sink_.onRemoteAudioStats(values, channelTag);
      } else if (method == MediaStatsDelegate.kNERtcOnLocalVideoStats) {
        sink_.onLocalVideoStats(values, channelTag);
      } else if (method == MediaStatsDelegate.kNERtcOnRemoteVideoStats) {
        sink_.onRemoteVideoStats(values, channelTag);
      }
    }
    return true;
  }
  return false;
}

// === 预留代码 ===
void DartCallback(Pointer<Char> message) {
  //_mainSendPort.send(message.cast<Utf8>().toDartString());
  print("DartCallback message: $message");
}

void SetupDartCallback() {
  final Pointer<NativeFunction<Void Function(Pointer<Char>)>> callbackPtr =
      Pointer.fromFunction<Void Function(Pointer<Char>)>(DartCallback);
  _bindings.CallDartMethod(callbackPtr);
}
