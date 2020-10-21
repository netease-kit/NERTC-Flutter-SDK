// Copyright (c) 2014-2019 NetEase, Inc. All right reserved.

part of nertc;

class NERtcVideoRenderer {
  VideoRendererApi _api = VideoRendererApi();
  int _textureId;
  int _rotation = 0;
  int _width = 0;
  int _height = 0;
  bool _mirror = false;
  StreamSubscription<dynamic> _streamSubscription;
  NERtcVideoViewFitType _videoViewFitType = NERtcVideoViewFitType.contain;
  bool _local = false;
  int _uid = -1;

  dynamic onFrameResolutionChanged;

  Future<void> initialize() async {
    IntValue reply = await _api.createVideoRenderer();
    _textureId = reply.value;
    _streamSubscription =
        EventChannel('NERtcFlutterRenderer/Texture$_textureId')
            .receiveBroadcastStream()
            .listen(_onData);
  }

  void _onData(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onFrameResolutionChanged':
        _width = map['width'];
        _height = map['height'];
        _rotation = map['rotation'];
        print('onFrameResolutionChanged: $_width x $_height @ $_rotation');
        break;
      case 'didFirstFrameRendered':
        print('didFirstFrameRendered');
        break;
    }
    if (this.onFrameResolutionChanged != null) {
      this.onFrameResolutionChanged();
    }
  }

  int get rotation => _rotation;

  int get width => _width;

  int get height => _height;

  int get textureId => _textureId;

  double get aspectRatio => (_width * _height == 0)
      ? 1.0
      : (_rotation == 90 || _rotation == 270)
          ? _height / _width
          : _width / _height;

  NERtcVideoViewFitType get videoViewFitType => _videoViewFitType;

  set fitType(NERtcVideoViewFitType fitType) {
    _videoViewFitType = fitType;
    if (this.onFrameResolutionChanged != null) {
      this.onFrameResolutionChanged();
    }
  }

  bool get mirror => _mirror;

  set mirror(bool mirror) {
    _mirror = mirror;
    if (this.onFrameResolutionChanged != null) {
      this.onFrameResolutionChanged();
    }
  }

  Future<int> addToRemoteVideoSink(int uid) {
    _local = false;
    _uid = uid;
    return _doSetSource(_local, _uid, _textureId);
  }

  Future<int> addToLocalVideoSink() {
    _local = true;
    _uid = 0;
    return _doSetSource(_local, _uid, _textureId);
  }

  Future<int> _doSetSource(bool local, int uid, int textureId) async {
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

  Future<void> dispose() async {
    await _doSetSource(_local, _uid, null);
    await _streamSubscription?.cancel();
    await _api.disposeVideoRenderer(IntValue()..value = textureId);
  }
}

class NERtcVideoView extends StatefulWidget {
  final NERtcVideoRenderer _renderer;

  NERtcVideoView(this._renderer, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NERtcVideoViewState();
}

class _NERtcVideoViewState extends State<NERtcVideoView> {
  NERtcVideoViewFitType _fitType = NERtcVideoViewFitType.contain;
  double _aspectRatio;
  bool _mirror;

  @override
  void initState() {
    super.initState();
    _setupVideoView();
  }

  @override
  void dispose() {
    super.dispose();
    widget._renderer.onFrameResolutionChanged = null;
  }

  void _setupVideoView() {
    _fitType = widget._renderer._videoViewFitType;
    _aspectRatio = widget._renderer.aspectRatio;
    _mirror = widget._renderer.mirror;
    _bindOnFrameResolutionChanged();
  }

  void _bindOnFrameResolutionChanged() {
    widget._renderer.onFrameResolutionChanged = () {
      setState(() {
        _fitType = widget._renderer._videoViewFitType;
        _aspectRatio = widget._renderer.aspectRatio;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Center(
        child: widget._renderer?._textureId == null
            ? Container(color: Colors.black)
            : _buildVideoView(constraints),
      );
    });
  }

  Widget _buildVideoView(BoxConstraints constraints) {
    return Container(
      color: Colors.black,
      child: FittedBox(
        fit: _fitType == NERtcVideoViewFitType.contain
            ? BoxFit.contain
            : BoxFit.cover,
        child: Center(
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxHeight * _aspectRatio,
            child: Transform(
              transform: Matrix4.identity()..rotateY(_mirror ? -math.pi : 0.0),
              alignment: FractionalOffset.center,
              child: Texture(
                textureId: widget._renderer._textureId,
              ),
            ),
          ),
        ),
      ),
      width: constraints.maxWidth,
      height: constraints.maxHeight,
    );
  }
}
