// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcVideoValue {
  const _NERtcVideoValue({
    this.width = 0,
    this.height = 0,
    this.rotation = 0,
  });

  final int width;
  final int height;
  final int rotation;

  const _NERtcVideoValue.uninitialized()
      : this(
          width: 0,
          height: 0,
          rotation: 0,
        );

  _NERtcVideoValue copyWith({
    int? width,
    int? height,
    int? rotation,
  }) {
    return _NERtcVideoValue(
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
    );
  }

  double get aspectRatio {
    return width * height == 0
        ? 1.0
        : (rotation == 90 || rotation == 270)
            ? height / width
            : width / height;
  }

  @override
  String toString() {
    return 'NERtcVideoValue{width: $width, height: $height, rotation: $rotation}';
  }
}

class _NERtcVideoRendererImpl extends NERtcVideoRenderer with _SDKLoggerMixin {
  _NERtcVideoRendererImpl(
      {NERtcVideoRendererEventListener? listener, String? channelTag})
      : super(rendererEventLister: listener, channelTag: channelTag);

  // VideoRendererApi _api = VideoRendererApi();
  final _platform = NERtcVideoRenderPlatform.instance;

  int _textureId = -1;
  bool _mirror = false;
  StreamSubscription<dynamic>? _rendererEventSubscription;

  bool _local = false;
  int _uid = -1;
  bool _subStream = false;
  bool _disposed = false;
  String _streamId = "";

  // bool get canRender => (_uid != -1 || _local);
  bool get canRender =>
      value.width * value.height != 0 && (_uid != -1 || _local);

  int? get textureId => _textureId;

  Future<void> initialize() async {
    print("_NERtcVideoRendererImpl initialize, channelTag: ${channelTag}");
    if (channelTag == null) channelTag = "";
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await _platform.createVideoRenderer();
      _textureId = reply;
      _rendererEventSubscription =
          EventChannel('NERtcFlutterRenderer/Texture$_textureId')
              .receiveBroadcastStream()
              .listen(_onRendererEvent);
    } else {
      _textureId = GenerateFlutterRender(_onRendererEvent, this.channelTag);
      print('GenerateFlutterRender return: $_textureId');
    }
  }

  void _onRendererEvent(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onFrameResolutionChanged':
        value = value.copyWith(
            width: map['width'],
            height: map['height'],
            rotation: map['rotation']);
        rendererEventLister?.onFrameResolutionChanged(
            _uid, value.width, value.height, value.rotation);
        print('onFrameResolutionChanged: ${value.toString()}');
        break;
      case 'onFirstFrameRendered':
        rendererEventLister?.onFirstFrameRendered(_uid);
        print('onFirstFrameRendered');
        break;
    }
  }

  @override
  Future<int> attachToLocalSubStreamVideo() {
    _local = true;
    _uid = 0;
    _subStream = true;
    return _setSource(_local, _subStream, _uid, _textureId);
  }

  @override
  Future<int> attachToLocalVideo() {
    _local = true;
    _uid = 0;
    _subStream = false;
    return _setSource(_local, _subStream, _uid, _textureId);
  }

  @override
  Future<int> attachToPlayingStreamVideo(String streamId) {
    _local = true;
    _streamId = streamId;
    _subStream = false;
    _uid = 0;
    return _setPlayingCanvasSource(streamId, _textureId);
  }

  @override
  Future<int> attachToRemoteSubStreamVideo(int uid) {
    _local = false;
    _uid = uid;
    _subStream = true;
    return _setSource(_local, _subStream, _uid, _textureId);
  }

  @override
  Future<int> attachToRemoteVideo(int uid) {
    _local = false;
    _uid = uid;
    _subStream = false;
    return _setSource(_local, _subStream, _uid, _textureId);
  }

  @override
  bool getMirrored() {
    return _mirror;
  }

  @override
  Future<int> setMirror(bool mirror) async {
    if (textureId == null) return -1;
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await _platform.setMirror(_textureId, mirror);
      if (reply == 0) _mirror = mirror;
      return reply;
    } else {
      int reply = SetFlutterRenderMirror(
          _textureId,
          mirror,
          _uid,
          _subStream ? NERtcVideoStreamType.sub : NERtcVideoStreamType.main,
          _local);
      if (reply == 0) _mirror = mirror;
      return reply;
    }
  }

  @override
  Future<int> setScalingMode(int scalingMode) async {
    if (textureId == null) return -1;
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004; //暂不支持
    } else {
      return SetFlutterRenderScalingMode(
          _textureId,
          scalingMode,
          _uid,
          _subStream ? NERtcVideoStreamType.sub : NERtcVideoStreamType.main,
          _local);
    }
  }

  Future<int> _setPlayingCanvasSource(String streamId, int textureId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await _platform.setupPlayStreamingCanvas(streamId, textureId);
      return reply;
    } else {
      return SetUpPlayingStreamRender(textureId, streamId);
    }
  }

  Future<int> _setSource(
      bool local, bool subStream, int uid, int? textureId) async {
    if (textureId == null) return -1;
    if (Platform.isAndroid || Platform.isIOS) {
      if (local) {
        int reply = _subStream
            ? await _platform.setupLocalSubStreamVideoRenderer(textureId,
                channelTag: this.channelTag!)
            : await _platform.setupLocalVideoRenderer(textureId,
                channelTag: this.channelTag!);
        if (Platform.isAndroid) {
          if (_mirror == false) {
            await _platform.setMirror(textureId, _mirror);
          }
        }
        return reply;
      } else {
        int reply = _subStream
            ? await _platform.setupRemoteSubStreamVideoRenderer(uid, textureId,
                channelTag: this.channelTag!)
            : await _platform.setupRemoteVideoRenderer(uid, textureId,
                channelTag: this.channelTag!);
        return reply;
      }
    } else {
      if (local) {
        int reply = _subStream
            ? SetUpLocalSubVideoRender(textureId, this.channelTag)
            : SetUpLocalVideoRender(textureId, this.channelTag);
        return reply;
      } else {
        int reply = _subStream
            ? SetUpRemoteSubVideoRender(textureId, uid, this.channelTag)
            : SetUpRemoteVideoRender(textureId, uid, this.channelTag);
        return reply;
      }
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _setSource(_local, _subStream, _uid, null);
    await _rendererEventSubscription?.cancel();
    if (Platform.isAndroid || Platform.isIOS) {
      await _platform.disposeVideoRenderer(_textureId);
    } else {
      DisposeFlutterRender(_textureId);
    }
    _textureId = -1;
    return super.dispose();
  }
}
