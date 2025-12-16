// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

///
/// 用户视频渲染组件。
///
class NERtcVideoView extends StatefulWidget {
  /// 视频渲染画布对象。如果为 null，则组件内部会自动创建和管理画布，并在组件销毁时自动释放画布。
  /// 开发者也可以通过 [NERtcVideoRendererFactory.createVideoRenderer] 手动创建一个画布，然后传入该参数，这样可以在多个组件中共享一个画布。
  /// 需要注意的是，如果使用了外部画布，开发者需要自己管理画布的生命周期，并在合适的时机 [NERtcVideoRenderer.dispose] 方法画布，否则会造成内存泄漏。
  final NERtcVideoRenderer? renderer;

  /// 视频渲染事件监听器。
  final NERtcVideoRendererEventListener? rendererEventLister;

  /// 指定需要渲染视频的目标用户。如果为 null，则渲染本地视频，否则渲染对应远端用户的视频。
  /// 如果渲染的是远端用户视频，需要业务层保证已经通过 [NERtcEngine.subscribeRemoteVideoStream] 订阅了该用户的视频流，否则会展示黑屏。
  final int? uid;

  final String? channelTag;

  /// 指定渲染视频主流还是辅流。
  final bool subStream;

  final String? streamId;

  /// 是否自动绑定画布。如果为 true，则在组件渲染时自动调用 [NERtcVideoRenderer.attachToRemoteVideo] 或 [NERtcVideoRenderer.attachToLocalVideo] 绑定画布到指定用户 [uid]。
  final bool autoAttach;

  /// 视频镜像开关。组件会自动监听其修改，并在渲染时打开/关闭镜像。
  final ValueListenable<bool>? mirrorListenable;

  /// 视频画布缩放方式。
  final NERtcVideoViewFitType fitType;

  /// 视频组件背景色。如果用户视频不能填充整个组件的大小，则上下或左右会有留白，留白部分的颜色由该属性指定。
  final Color backgroundColor;

  /// 用户视频渲染可用之前的占位组件。
  final WidgetBuilder? placeholderBuilder;

  ///
  /// 创建用户视频渲染组件。
  ///
  /// [renderer] 为视频渲染所需的画布对象，可空。
  /// - 如果不为空，组件不会自动销毁 [renderer]，需要开发者在合适的时机调用 [renderer.dispose()] 销毁，否则可能会造成内存泄漏。
  /// - 如果为空，组件内部会自动创建并销毁 [renderer]，不会造成内存泄漏。推荐使用该模式创建视频渲染组件。
  ///
  @Deprecated('use NERtcVideoView.withInternalRenderer instead')
  const NERtcVideoView({
    Key? key,
    this.channelTag,
    this.uid,
    this.subStream = false,
    this.autoAttach = true,
    this.mirrorListenable,
    this.renderer,
    this.rendererEventLister,
    this.fitType = NERtcVideoViewFitType.cover,
    this.placeholderBuilder,
    this.backgroundColor = const Color(0xFF292933),
    this.streamId,
  })  : assert(renderer != null || autoAttach),
        super(key: key);

  ///
  /// 创建用户视频渲染组件。
  ///
  /// 在该模式下渲染所需的画布对象不需要外部传入，组件内部在使用时会自动创建，不再使用时会自动销毁，不会造成内存泄漏。
  /// 推荐使用该模式创建视频渲染组件。
  ///
  const NERtcVideoView.withInternalRenderer({
    Key? key,
    this.channelTag,
    this.uid,
    this.subStream = false,
    this.mirrorListenable,
    this.rendererEventLister,
    this.fitType = NERtcVideoViewFitType.cover,
    this.placeholderBuilder,
    this.backgroundColor = const Color(0xFF292933),
    this.streamId,
  })  : renderer = null,
        autoAttach = true,
        super(key: key);

  ///
  /// 创建用户视频渲染组件。
  ///
  /// 该模式需要开发者手动创建并传入画布对象 [renderer]，并手动管理 [renderer] 的生命周期以避免内存泄漏。
  ///
  const NERtcVideoView.withExternalRenderer({
    Key? key,
    this.channelTag,
    this.uid,
    this.subStream = false,
    this.autoAttach = true,
    this.mirrorListenable,
    required NERtcVideoRenderer renderer,
    this.rendererEventLister,
    this.fitType = NERtcVideoViewFitType.cover,
    this.placeholderBuilder,
    this.backgroundColor = const Color(0xFF292933),
    this.streamId,
  })  : this.renderer = renderer,
        super(key: key);

  @override
  State<NERtcVideoView> createState() => NERtcVideoViewState();
}

/// @nodoc
class NERtcVideoViewState extends State<NERtcVideoView>
    with NERtcVideoRendererEventListener {
  NERtcVideoRenderer? _internalRenderer;
  var _creating = false;

  NERtcVideoRenderer get renderer => widget.renderer ?? _internalRenderer!;

  bool get hasRenderer => widget.renderer != null || _internalRenderer != null;

  void _initRenderer() async {
    if (hasRenderer || _creating) {
      return;
    }
    _creating = true;
    if (widget.renderer == null) {
      _internalRenderer = await NERtcVideoRendererFactory.createVideoRenderer(
          channelTag: widget.channelTag);
      _internalRenderer!.rendererEventLister = widget.rendererEventLister;
    }
    if (mounted) {
      setState(() {
        _attachRender();
      });
    } else {
      _disposeRenderer();
    }
    _creating = false;
  }

  void _disposeRenderer() {
    _internalRenderer?.rendererEventLister = null;
    _internalRenderer?.dispose();
    _internalRenderer = null;
  }

  void _attachRender() async {
    if (widget.autoAttach) {
      if (widget.streamId != null && widget.streamId!.isNotEmpty) {
        int result =
            await renderer.attachToPlayingStreamVideo(widget.streamId!);
        debugPrint('attach render to ${widget.streamId} result: $result');
      } else {
        final uid = widget.uid;
        final subStream = widget.subStream;
        int result = -1;
        if (uid == null) {
          result = await (!subStream
              ? renderer.attachToLocalVideo()
              : renderer.attachToLocalSubStreamVideo());
        } else {
          result = await (!subStream
              ? renderer.attachToRemoteVideo(uid)
              : renderer.attachToRemoteSubStreamVideo(uid));
        }
        debugPrint('attach render to $uid#$subStream result: $result');
      }
    }
    _updateMirror();
  }

  void _updateMirror() {
    if (hasRenderer && widget.mirrorListenable != null) {
      renderer.setMirror(widget.mirrorListenable!.value);
      if (Platform.isMacOS || Platform.isWindows) {
        renderer.setScalingMode(widget.fitType.index);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initRenderer();
    widget.mirrorListenable?.addListener(_updateMirror);
  }

  @override
  void dispose() {
    _disposeRenderer();
    super.dispose();
  }

  @override
  void didUpdateWidget(NERtcVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uid != oldWidget.uid ||
        widget.subStream != oldWidget.subStream ||
        widget.streamId != oldWidget.streamId ||
        widget.renderer != oldWidget.renderer) {
      _disposeRenderer();
      _initRenderer();
    } else {
      if (mounted) {
        setState(() {
          _attachRender();
        });
      } else {
        _disposeRenderer();
      }
    }
    if (widget.mirrorListenable != oldWidget.mirrorListenable) {
      oldWidget.mirrorListenable?.removeListener(_updateMirror);
      widget.mirrorListenable?.addListener(_updateMirror);
    }
    _updateMirror();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print(
          'build video view: ${constraints.maxWidth}x${constraints.maxHeight}');
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: widget.backgroundColor,
        // alignment: Alignment.center,
        child: hasRenderer
            ? ValueListenableBuilder<_NERtcVideoValue>(
                valueListenable: renderer,
                builder: (BuildContext context, _NERtcVideoValue value,
                    Widget? child) {
                  return renderer.canRender && renderer.textureId != null
                      ? _buildVideoView(
                          renderer.textureId!,
                          constraints.maxHeight * value.aspectRatio,
                          constraints.maxHeight,
                        )
                      : _buildPlaceHolder();
                },
              )
            : _buildPlaceHolder(),
      );
    });
  }

  Widget _buildPlaceHolder() {
    return widget.placeholderBuilder?.call(context) ??
        Container(
          color: widget.backgroundColor,
        );
  }

  Widget _buildVideoView(int textureId, double width, double height) {
    return FittedBox(
      fit: widget.fitType == NERtcVideoViewFitType.contain
          ? BoxFit.contain
          : BoxFit.cover,
      child: Center(
        child: SizedBox(
            height: height, width: width, child: Texture(textureId: textureId)),
      ),
    );
  }

  @override
  void onFirstFrameRendered(int uid) {
    Alog.i(
      tag: 'RoomUserVideoViewState',
      content: 'onFirstFrameRendered for $uid  ${widget.subStream}',
    );
    widget.rendererEventLister?.onFirstFrameRendered(uid);
  }

  @override
  void onFrameResolutionChanged(int uid, int width, int height, int rotation) {
    Alog.i(
      tag: 'RoomUserVideoViewState',
      content: 'onFrameResolutionChanged for $uid ${widget.subStream}',
    );
    widget.rendererEventLister
        ?.onFrameResolutionChanged(uid, width, height, rotation);
  }
}
