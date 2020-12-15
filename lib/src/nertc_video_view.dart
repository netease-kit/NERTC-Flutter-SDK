// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

/// 视频渲染视图
class NERtcVideoView extends StatelessWidget {
  final NERtcVideoRenderer _renderer;
  final NERtcVideoViewFitType fitType;
  final Color backgroundColor;

  NERtcVideoView(this._renderer,
      {Key key,
      this.fitType = NERtcVideoViewFitType.contain,
      this.backgroundColor = const Color(0xFF292933)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Center(child: _buildVideoView(constraints));
    });
  }

  Widget _buildVideoView(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      color: backgroundColor,
      child: FittedBox(
        fit: fitType == NERtcVideoViewFitType.contain
            ? BoxFit.contain
            : BoxFit.cover,
        child: Center(
            child: ValueListenableBuilder<_NERtcVideoValue>(
          valueListenable: _renderer,
          builder:
              (BuildContext context, _NERtcVideoValue value, Widget child) {
            return SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxHeight * value.aspectRatio,
                child: _renderer != null &&
                        _renderer.canRender &&
                        _renderer.textureId != null
                    ? Texture(textureId: _renderer.textureId)
                    : Container(
                        color: backgroundColor,
                      ));
          },
        )),
      ),
    );
  }
}
