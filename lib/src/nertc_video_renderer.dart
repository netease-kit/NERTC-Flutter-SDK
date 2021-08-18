// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 视频画布创建工厂
class VideoRendererFactory {
  /// 创建 [NERtcVideoRenderer], 同时进行初始化
  static Future<NERtcVideoRenderer> createVideoRenderer(
      {NERtcVideoRendererEventListener? listener}) async {
    NERtcVideoRenderer renderer = _NERtcVideoRendererImpl(listener: listener);
    await renderer.initialize();
    return renderer;
  }
}

/// 视频渲染事件监听器
abstract class NERtcVideoRendererEventListener {
  void onFrameResolutionChanged(int uid, int width, int height, int rotation);

  void onFirstFrameRendered(int uid);
}

/// 视频渲染画布
abstract class NERtcVideoRenderer extends ValueNotifier<_NERtcVideoValue> {
  NERtcVideoRenderer({this.rendererEventLister})
      : super(_NERtcVideoValue.uninitialized());

  NERtcVideoRendererEventListener? rendererEventLister;

  int? get textureId;

  bool get canRender;

  Future<void> initialize();

  /// 添加为远端用户视频画布
  Future<int> attachToRemoteVideo(int uid);

  /// 添加为远端用户辅流视频画布
  Future<int> attachToRemoteSubStreamVideo(int uid);

  /// 添加为本地用户视频画布
  Future<int> attachToLocalVideo();

  /// 添加为本地用户辅流视频画布
  Future<int> attachToLocalSubStreamVideo();

  /// 设置画面是否镜像
  Future<int> setMirror(bool mirror);

  /// 获取画面是否镜像
  bool getMirrored();

  @override
  @mustCallSuper
  Future<void> dispose() async {
    super.dispose();
    return Future.value();
  }
}
