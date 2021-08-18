// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcVideoRendererImpl extends NERtcVideoRenderer {
  _NERtcVideoRendererImpl({NERtcVideoRendererEventListener? listener})
      : super(rendererEventLister: listener);

  VideoRendererApi _api = VideoRendererApi();

  int? _textureId;
  bool _mirror = false;
  StreamSubscription<dynamic>? _rendererEventSubscription;

  bool _local = false;
  int _uid = -1;
  bool _subStream = false;

  Future<void> initialize() async {
    IntValue reply = await _api.createVideoRenderer();
    _textureId = reply.value;
    _rendererEventSubscription =
        EventChannel('NERtcFlutterRenderer/Texture$_textureId')
            .receiveBroadcastStream()
            .listen(_onRendererEvent);
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
      case 'didFirstFrameRendered':
        rendererEventLister?.onFirstFrameRendered(_uid);
        print('didFirstFrameRendered');
        break;
    }
  }

  bool get canRender =>
      value.width * value.height != 0 && (_uid != -1 || _local);

  int? get textureId => _textureId;

  @override
  Future<int> attachToRemoteVideo(int uid) {
    _local = false;
    _uid = uid;
    _subStream = false;
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
  Future<int> attachToLocalSubStreamVideo() {
    _local = true;
    _uid = 0;
    _subStream = true;
    return _setSource(_local, _subStream, _uid, _textureId);
  }

  @override
  Future<int> attachToRemoteSubStreamVideo(int uid) {
    _local = false;
    _uid = uid;
    _subStream = true;
    return _setSource(_local, _subStream, _uid, _textureId);
  }

  Future<int> _setSource(
      bool local, bool subStream, int uid, int? textureId) async {
    if (textureId == null) return -1;
    if (local) {
      IntValue reply = _subStream
          ? await _api
              .setupLocalSubStreamVideoRenderer(IntValue()..value = textureId)
          : await _api.setupLocalVideoRenderer(IntValue()..value = textureId);
      if (Platform.isAndroid) {
        if (_mirror == false) {
          await _api.setMirror(SetVideoRendererMirrorRequest()
            ..textureId = textureId
            ..mirror = _mirror);
        }
      }
      return reply.value ?? -1;
    } else {
      IntValue reply = _subStream
          ? await _api.setupRemoteSubStreamVideoRenderer(
              SetupRemoteSubStreamVideoRendererRequest()
                ..textureId = textureId
                ..uid = uid)
          : await _api
              .setupRemoteVideoRenderer(SetupRemoteVideoRendererRequest()
                ..textureId = textureId
                ..uid = uid);
      return reply.value ?? -1;
    }
  }

  @override
  Future<int> setMirror(bool mirror) async {
    if (textureId == null) return -1;
    IntValue reply = await _api.setMirror(SetVideoRendererMirrorRequest()
      ..textureId = textureId
      ..mirror = mirror);
    if (reply.value == 0) _mirror = mirror;
    return reply.value ?? -1;
  }

  @override
  bool getMirrored() {
    return _mirror;
  }

  @override
  Future<void> dispose() async {
    await _setSource(_local, _subStream, _uid, null);
    await _rendererEventSubscription?.cancel();
    await _api.disposeVideoRenderer(IntValue()..value = textureId);
    return super.dispose();
  }
}
