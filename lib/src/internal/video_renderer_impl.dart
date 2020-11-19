// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

class _NERtcVideoRendererImpl extends NERtcVideoRenderer {
  _NERtcVideoRendererImpl({NERtcVideoRendererEventListener listener})
      : super(rendererEventLister: listener);

  VideoRendererApi _api = VideoRendererApi();

  int _textureId;
  StreamSubscription<dynamic> _rendererEventSubscription;

  bool _local = false;
  int _uid = -1;

  Future<void> initialize() async {
    IntValue reply = await _api.createVideoRenderer();
    _textureId = reply.value;
    _rendererEventSubscription =
        EventChannel('NERtcFlutterRenderer/Texture$_textureId')
            .receiveBroadcastStream()
            .listen(_onRenererEvent);
  }

  void _onRenererEvent(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onFrameResolutionChanged':
        value = value.copyWith(
            width: map['width'],
            height: map['height'],
            rotation: map['rotation']);
        rendererEventLister?.onFrameResolutionChanged(
            value.width, value.height, value.rotation);
        print('onFrameResolutionChanged: ${value.toString()}');
        break;
      case 'didFirstFrameRendered':
        rendererEventLister?.onFirstFrameRendered();
        print('didFirstFrameRendered');
        break;
    }
  }

  bool get canRender =>
      value.width * value.height != 0 && (_uid != -1 || _local);

  int get textureId => _textureId;

  Future<int> addToRemoteVideoSink(int uid) {
    _local = false;
    _uid = uid;
    return _setSource(_local, _uid, _textureId);
  }

  Future<int> addToLocalVideoSink() {
    _local = true;
    _uid = 0;
    return _setSource(_local, _uid, _textureId);
  }

  Future<int> _setSource(bool local, int uid, int textureId) async {
    if (textureId == null) return -1;
    if (local) {
      IntValue reply =
          await _api.setupLocalVideoRenderer(IntValue()..value = textureId);
      return reply.value;
    } else {
      IntValue reply =
          await _api.setupRemoteVideoRenderer(SetupRemoteVideoRendererRequest()
            ..textureId = textureId
            ..uid = uid);
      return reply.value;
    }
  }

  @override
  Future<void> dispose() async {
    await _setSource(_local, _uid, null);
    await _rendererEventSubscription?.cancel();
    await _api.disposeVideoRenderer(IntValue()..value = textureId);
    return super.dispose();
  }
}
