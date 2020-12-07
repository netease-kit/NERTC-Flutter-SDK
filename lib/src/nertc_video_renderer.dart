// Copyright (c) 2014-2020 NetEase, Inc. All right reserved.

part of nertc;

class VideoRendererFactory {
  static Future<NERtcVideoRenderer> createVideoRenderer(
      {NERtcVideoRendererEventListener listener}) async {
    NERtcVideoRenderer renderer = _NERtcVideoRendererImpl(listener: listener);
    await renderer.initialize();
    return renderer;
  }
}

abstract class NERtcVideoRendererEventListener {
  void onFrameResolutionChanged(int uid, int width, int height, int rotation);
  void onFirstFrameRendered(int uid);
}

abstract class NERtcVideoRenderer extends ValueNotifier<_NERtcVideoValue> {
  NERtcVideoRenderer({this.rendererEventLister})
      : super(_NERtcVideoValue.uninitialized());

  NERtcVideoRendererEventListener rendererEventLister;

  int get textureId;

  bool get canRender;

  Future<void> initialize();

  Future<int> addToRemoteVideoSink(int uid);
  Future<int> addToLocalVideoSink();

  @override
  @mustCallSuper
  Future<void> dispose() async {
    super.dispose();
    return Future.value();
  }
}
