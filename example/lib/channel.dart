// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:nertc_core/nertc_core.dart';
import 'package:nertc_core_platform_interface/nertc_core_platform_interface.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScreenCaptureParametersConfig {
  static NERtcScreenCaptureParameters _parameters =
      NERtcScreenCaptureParameters();

  static NERtcScreenCaptureParameters get parameters => _parameters;

  static void updateParameters(NERtcScreenCaptureParameters newParams) {
    _parameters = newParams;
  }
}

class ChannelPage extends StatefulWidget {
  final String cname;
  final int uid;

  ChannelPage({Key? key, required this.cname, required this.uid});

  @override
  State<StatefulWidget> createState() {
    return _ChannelPageState();
  }
}

class _ChannelPageState extends State<ChannelPage>
    with
        AppLoggerMixin,
        NERtcVideoRendererEventListener,
        NERtcChannelEventCallback,
        NERtcStatsEventCallback {
  late Size screenSize;
  List<_UserSession> _remoteSessions = [];
  _UserSession? _localSession;
  _UserSession? _localSubStreamSession;
  int videoViewFitType = 0;
  NERtcEngine _engine = NERtcEngine.instance;
  late NERtcChannel channel;

  bool isFrontCamera = true;
  bool isFrontCameraMirror = true;

  bool showControlPanel = false;

  @override
  void initState() {
    super.initState();
    print('start call: uid=${widget.uid}, cname=${widget.cname}');
    _engine.createChannel(widget.cname).then((channel) {
      this.channel = channel;
      this.channel.setEventCallback(this);
      this.channel.setStatsEventCallback(this);
      _initRenderer();
      this.channel.enableLocalVideo(true);
      this
          .channel
          .joinChannel('', widget.cname, widget.uid, null)
          .then((result) {
        print("****** joinSubChannel result: $result");
      });
    });
  }

  Future<void> _initRenderer() async {
    setState(() {
      _localSession = _UserSession(widget.uid);
      updateLocalMirror();
    });
  }

  void updateLocalMirror() {
    _localSession?.mirror.value = isFrontCamera && isFrontCameraMirror;
  }

  void _leaveChannel() async {
    channel.removeEventCallback(this);
    await channel.enableLocalVideo(false);
    await channel.enableLocalAudio(false);
    _localSession = null;
    _localSubStreamSession = null;
    _remoteSessions.clear();
    await channel.leaveChannel();
  }

  Future<void> setupVideoView(int uid, int maxProfile, bool subStream) async {
    final session = _UserSession(uid, subStream);
    _remoteSessions.add(session);
    if (subStream) {
      channel.subscribeRemoteSubVideoStream(uid, true);
    } else {
      channel.subscribeRemoteVideoStream(
          uid, NERtcRemoteVideoStreamType.high, true);
    }
    setState(() {});
  }

  Future<void> releaseVideoView(int uid, bool subStream) async {
    for (_UserSession session in _remoteSessions.toList()) {
      if (session.uid == uid && subStream == session.subStream) {
        _remoteSessions.remove(session);
        if (!subStream) {
          channel.subscribeRemoteVideoStream(
              uid, NERtcRemoteVideoStreamType.high, false);
        } else {
          channel.subscribeRemoteSubVideoStream(uid, false);
        }
        setState(() {});
        break;
      }
    }
  }

  @override
  void dispose() {
    _leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showControlPanel = !showControlPanel;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(widget.cname),
          ),
          body: buildCallingWidget(context),
        ),
      ),
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
    );
  }

  Widget buildCallingWidget(BuildContext context) {
    return Stack(children: <Widget>[
      buildVideoViews(context),
      if (showControlPanel) buildControlPanel(context)
    ]);
  }

  Widget buildControlPanel(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildControlPanel1(context),
        buildControlPanel2(context),
        buildControlPanel3(context),
        if (Platform.isMacOS || Platform.isWindows) buildControlPanel6(context)
      ],
    );
  }

  Widget buildControlPanel6(BuildContext context) {
    List<Widget> children = [];

    children.add(Expanded(
      child: buildControlButton(() {
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController thumbWidthController =
                TextEditingController(text: '160');
            TextEditingController thumbHeightController =
                TextEditingController(text: '120');
            TextEditingController iconWidthController =
                TextEditingController(text: '32');
            TextEditingController iconHeightController =
                TextEditingController(text: '32');
            bool includeScreen = true;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('获取屏幕捕获源参数'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: thumbWidthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: '缩略图宽度'),
                        ),
                        TextField(
                          controller: thumbHeightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: '缩略图高度'),
                        ),
                        TextField(
                          controller: iconWidthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: '图标宽度'),
                        ),
                        TextField(
                          controller: iconHeightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: '图标高度'),
                        ),
                        CheckboxListTile(
                          title: Text('包含屏幕'),
                          value: includeScreen,
                          onChanged: (value) {
                            setState(() {
                              includeScreen = value ?? true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('取消'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          final sources = await channel.getScreenCaptureSources(
                              NERtcSize(
                                  width: int.parse(thumbWidthController.text),
                                  height:
                                      int.parse(thumbHeightController.text)),
                              NERtcSize(
                                  width: int.parse(iconWidthController.text),
                                  height: int.parse(iconHeightController.text)),
                              includeScreen);

                          Navigator.of(context).pop();

                          if (sources != null) {
                            final count = sources.getCount();
                            _showSourceListDialog(sources, count);
                          } else {
                            FlutterToastr.show('获取屏幕捕获源失败', context,
                                position: FlutterToastr.bottom);
                          }
                        } catch (e) {
                          Navigator.of(context).pop();
                          FlutterToastr.show('错误: $e', context,
                              position: FlutterToastr.bottom);
                        }
                      },
                      child: Text('获取'),
                    ),
                  ],
                );
              },
            );
          },
        );
      }, Text("桌面/窗口分享", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() {
        if (Platform.isMacOS) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('功能不支持'),
                content: Text('macOS 平台暂不支持屏幕矩形捕获功能'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('确定'),
                  ),
                ],
              );
            },
          );
          return;
        }

        showDialog(
          context: context,
          builder: (context) {
            TextEditingController screenXController =
                TextEditingController(text: '0');
            TextEditingController screenYController =
                TextEditingController(text: '0');
            TextEditingController screenWidthController =
                TextEditingController(text: '1920');
            TextEditingController screenHeightController =
                TextEditingController(text: '1080');
            TextEditingController regionXController =
                TextEditingController(text: '0');
            TextEditingController regionYController =
                TextEditingController(text: '0');
            TextEditingController regionWidthController =
                TextEditingController(text: '1920');
            TextEditingController regionHeightController =
                TextEditingController(text: '1080');

            return AlertDialog(
              title: Text('屏幕矩形捕获参数'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('屏幕矩形:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: screenXController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'X'),
                          )),
                          SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: screenYController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Y'),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: screenWidthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: '宽度'),
                          )),
                          SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: screenHeightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: '高度'),
                          )),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('捕获区域:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: regionXController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'X'),
                          )),
                          SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: regionYController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Y'),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: regionWidthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: '宽度'),
                          )),
                          SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: regionHeightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: '高度'),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _showScreenCaptureParametersDialog((params) {
                      FlutterToastr.show('参数配置已更新', context,
                          position: FlutterToastr.bottom);
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('参数配置'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        if (_localSubStreamSession == null) {
                          _localSubStreamSession =
                              _UserSession(widget.uid, true);
                        }
                      });
                      final result =
                          await channel.startScreenCaptureByScreenRect(
                              NERtcRectangle(
                                  x: int.parse(screenXController.text),
                                  y: int.parse(screenYController.text),
                                  width: int.parse(screenWidthController.text),
                                  height:
                                      int.parse(screenHeightController.text)),
                              NERtcRectangle(
                                  x: int.parse(regionXController.text),
                                  y: int.parse(regionYController.text),
                                  width: int.parse(regionWidthController.text),
                                  height:
                                      int.parse(regionHeightController.text)),
                              ScreenCaptureParametersConfig.parameters);
                      Navigator.of(context).pop();
                      FlutterToastr.show('屏幕矩形捕获结果: $result', context,
                          position: FlutterToastr.bottom);
                    } catch (e) {
                      Navigator.of(context).pop();
                      FlutterToastr.show('错误: $e', context,
                          position: FlutterToastr.bottom);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('开始捕获'),
                ),
              ],
            );
          },
        );
      }, Text("屏幕矩形捕获", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() {
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController xController =
                TextEditingController(text: '100');
            TextEditingController yController =
                TextEditingController(text: '100');
            TextEditingController widthController =
                TextEditingController(text: '800');
            TextEditingController heightController =
                TextEditingController(text: '600');

            return AlertDialog(
              title: Text('更新捕获区域参数'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: xController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'X坐标'),
                      )),
                      SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        controller: yController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Y坐标'),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: widthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: '宽度'),
                      )),
                      SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: '高度'),
                      )),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      final result = await channel.updateScreenCaptureRegion(
                          NERtcRectangle(
                              x: int.parse(xController.text),
                              y: int.parse(yController.text),
                              width: int.parse(widthController.text),
                              height: int.parse(heightController.text)));
                      Navigator.of(context).pop();
                      FlutterToastr.show('更新捕获区域结果: $result', context,
                          position: FlutterToastr.bottom);
                    } catch (e) {
                      Navigator.of(context).pop();
                      FlutterToastr.show('错误: $e', context,
                          position: FlutterToastr.bottom);
                    }
                  },
                  child: Text('更新'),
                ),
              ],
            );
          },
        );
      }, Text("更新区域", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('选择鼠标光标设置'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('显示鼠标光标'),
                    onTap: () async {
                      final result =
                          await channel.setScreenCaptureMouseCursor(true);
                      Navigator.of(context).pop();
                      FlutterToastr.show('显示光标结果: $result', context,
                          position: FlutterToastr.bottom);
                    },
                  ),
                  ListTile(
                    title: Text('隐藏鼠标光标'),
                    onTap: () async {
                      final result =
                          await channel.setScreenCaptureMouseCursor(false);
                      Navigator.of(context).pop();
                      FlutterToastr.show('隐藏光标结果: $result', context,
                          position: FlutterToastr.bottom);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
              ],
            );
          },
        );
      }, Text("光标设置", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() async {
        final result = await channel.pauseScreenCapture();
        FlutterToastr.show('暂停屏幕捕获结果: $result', context,
            position: FlutterToastr.bottom);
      }, Text("暂停", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() async {
        final result = await channel.resumeScreenCapture();
        FlutterToastr.show('恢复屏幕捕获结果: $result', context,
            position: FlutterToastr.bottom);
      }, Text("恢复", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() async {
        final result = await channel.stopScreenCapture();
        setState(() {
          _localSubStreamSession = null;
        });
        FlutterToastr.show('停止屏幕捕获结果: $result', context,
            position: FlutterToastr.bottom);
      }, Text("停止", style: TextStyle(fontSize: 10))),
    ));

    return Container(
      height: 40,
      child: Row(
        children: children,
      ),
    );
  }

  bool _shouldShowShareButton(NERtcScreenCaptureSourceType type) {
    return type == NERtcScreenCaptureSourceType.kWindow ||
        type == NERtcScreenCaptureSourceType.kScreen;
  }

  String _getShareButtonText(NERtcScreenCaptureSourceType type) {
    switch (type) {
      case NERtcScreenCaptureSourceType.kWindow:
        return '分享窗口';
      case NERtcScreenCaptureSourceType.kScreen:
        return '分享桌面';
      default:
        return '分享';
    }
  }

  Color? _getShareButtonColor(NERtcScreenCaptureSourceType type) {
    switch (type) {
      case NERtcScreenCaptureSourceType.kWindow:
        return Colors.blue;
      case NERtcScreenCaptureSourceType.kScreen:
        return Colors.green;
      default:
        return null;
    }
  }

  void _handleShareSource(NERtcScreenCaptureSourceInfo sourceInfo) {
    if (sourceInfo.type == NERtcScreenCaptureSourceType.kWindow) {
      _startScreenCaptureByWindow(sourceInfo);
    } else if (sourceInfo.type == NERtcScreenCaptureSourceType.kScreen) {
      _startScreenCaptureByDisplay(sourceInfo);
    }
  }

  void _showScreenCaptureParametersDialog(
      Function(NERtcScreenCaptureParameters) onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final params = ScreenCaptureParametersConfig.parameters;

            final frameRateController =
                TextEditingController(text: params.frameRate.toString());
            final minFrameRateController =
                TextEditingController(text: params.minFrameRate.toString());
            final bitRateController =
                TextEditingController(text: params.bitRate.toString());
            final minBitRateController =
                TextEditingController(text: params.minBitRate.toString());
            final dimensionsWidthController = TextEditingController(
                text: params.dimensions?.width.toString() ?? '1920');
            final dimensionsHeightController = TextEditingController(
                text: params.dimensions?.height.toString() ?? '1080');
            final excludeWindowListController =
                TextEditingController(text: params.excludeWindowList.join(','));
            final highLightWidthController =
                TextEditingController(text: params.highLightWidth.toString());
            final highLightColorController =
                TextEditingController(text: params.highLightColor.toString());
            final highLightLengthController =
                TextEditingController(text: params.highLightLength.toString());

            return AlertDialog(
              title: Text('屏幕捕获参数配置'),
              content: SizedBox(
                width: double.maxFinite,
                height: 600,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('屏幕配置文件:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<NERtcScreenProfileType>(
                        value: params.profile,
                        isExpanded: true,
                        items: NERtcScreenProfileType.values.map((profile) {
                          String displayName;
                          switch (profile) {
                            case NERtcScreenProfileType.kNERtcScreenProfile480P:
                              displayName = '480P (640x480, 5fps)';
                              break;
                            case NERtcScreenProfileType
                                  .kNERtcScreenProfileHD720P:
                              displayName = 'HD720P (1280x720, 5fps)';
                              break;
                            case NERtcScreenProfileType
                                  .kNERtcScreenProfileHD1080P:
                              displayName = 'HD1080P (1920x1080, 5fps)';
                              break;
                            case NERtcScreenProfileType
                                  .kNERtcScreenProfileCustom:
                              displayName = '自定义';
                              break;
                            case NERtcScreenProfileType.kNERtcScreenProfileNone:
                            default:
                              displayName = '无效果';
                              break;
                          }
                          return DropdownMenuItem(
                            value: profile,
                            child: Text(displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            params.profile = value ??
                                NERtcScreenProfileType.kNERtcScreenProfileNone;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      if (params.profile ==
                          NERtcScreenProfileType.kNERtcScreenProfileCustom) ...[
                        Text('自定义尺寸:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: dimensionsWidthController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '宽度',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: dimensionsHeightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '高度',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                      Text('帧率设置:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: frameRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '帧率 (fps)',
                                border: OutlineInputBorder(),
                                helperText: '建议不超过15',
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: minFrameRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '最小帧率',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('码率设置:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: bitRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '码率 (kbps)',
                                border: OutlineInputBorder(),
                                helperText: '0=自动',
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: minBitRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '最小码率',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('编码策略倾向:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<int>(
                        value: params.contentPrefer,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: 0, child: Text('动画内容 (视频/游戏)')),
                          DropdownMenuItem(
                              value: 1, child: Text('细节内容 (图片/文字)')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            params.contentPrefer = value ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text('带宽受限时的降级偏好:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<int>(
                        value: params.preference,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: 0, child: Text('默认 (根据场景调整)')),
                          DropdownMenuItem(
                              value: 1, child: Text('流畅优先 (降低质量保帧率)')),
                          DropdownMenuItem(
                              value: 2, child: Text('清晰优先 (降低帧率保质量)')),
                          DropdownMenuItem(value: 3, child: Text('平衡模式')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            params.preference = value ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text('捕获选项:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      CheckboxListTile(
                        title: Text('捕获鼠标光标'),
                        value: params.captureMouseCursor,
                        onChanged: (value) {
                          setState(() {
                            params.captureMouseCursor = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('窗口前置 (窗口捕获时)'),
                        value: params.windowFocus,
                        onChanged: (value) {
                          setState(() {
                            params.windowFocus = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('启用高性能模式 (macOS)'),
                        value: params.enableHighPerformance,
                        onChanged: (value) {
                          setState(() {
                            params.enableHighPerformance = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('显示高亮边框'),
                        value: params.enableHighLight,
                        onChanged: (value) {
                          setState(() {
                            params.enableHighLight = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('排除高亮框'),
                        value: params.excludeHighLightBox,
                        onChanged: (value) {
                          setState(() {
                            params.excludeHighLightBox = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('强制更新数据'),
                        value: params.forceUpdateData,
                        onChanged: (value) {
                          setState(() {
                            params.forceUpdateData = value ?? false;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text('排除窗口ID列表:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: excludeWindowListController,
                        decoration: InputDecoration(
                          labelText: '窗口ID (用逗号分隔)',
                          border: OutlineInputBorder(),
                          helperText: '例如: 1234,5678',
                        ),
                      ),
                      SizedBox(height: 16),
                      if (params.enableHighLight) ...[
                        Text('高亮边框设置:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextField(
                          controller: highLightWidthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '边框宽度 (像素)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: highLightColorController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '边框颜色 (0xAABBGGRR)',
                            border: OutlineInputBorder(),
                            helperText: '例如: 0xFF7EDE00',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: highLightLengthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '边框长度 (-1=全包)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      params.frameRate = int.parse(frameRateController.text);
                      params.minFrameRate =
                          int.parse(minFrameRateController.text);
                      params.bitRate = int.parse(bitRateController.text);
                      params.minBitRate = int.parse(minBitRateController.text);

                      if (params.profile ==
                          NERtcScreenProfileType.kNERtcScreenProfileCustom) {
                        params.dimensions = NERtcVideoDimensions(
                          width: int.parse(dimensionsWidthController.text),
                          height: int.parse(dimensionsHeightController.text),
                        );
                      }

                      if (excludeWindowListController.text.isNotEmpty) {
                        params.excludeWindowList = excludeWindowListController
                            .text
                            .split(',')
                            .map((s) => int.tryParse(s.trim()) ?? 0)
                            .where((id) => id != 0)
                            .toList();
                      } else {
                        params.excludeWindowList = [];
                      }

                      if (params.enableHighLight) {
                        params.highLightWidth =
                            int.parse(highLightWidthController.text);
                        params.highLightColor =
                            int.parse(highLightColorController.text);
                        params.highLightLength =
                            int.parse(highLightLengthController.text);
                      }

                      ScreenCaptureParametersConfig.updateParameters(params);

                      Navigator.of(context).pop();
                      onConfirm(params);
                    } catch (e) {
                      FlutterToastr.show('参数格式错误: $e', context,
                          position: FlutterToastr.bottom);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('确认'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSourceListDialog(IScreenCaptureList sources, int count) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('屏幕捕获源列表 ($count 个)'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                final sourceInfo = sources.getSourceInfo(index);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: _buildSourceImage(sourceInfo.thumbImage),
                    title: Text(sourceInfo.sourceTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('类型: ${_getSourceTypeString(sourceInfo.type)}'),
                        Text('ID: ${sourceInfo.sourceId}'),
                        if (sourceInfo.processPath.isNotEmpty)
                          Text('路径: ${sourceInfo.processPath}'),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if (sourceInfo.thumbImage.buffer.isNotEmpty)
                              Column(
                                children: [
                                  Text('缩略图:', style: TextStyle(fontSize: 12)),
                                  _buildImagePreview(sourceInfo.thumbImage, 80),
                                ],
                              ),
                            SizedBox(width: 16),
                            if (sourceInfo.iconImage.buffer.isNotEmpty)
                              Column(
                                children: [
                                  Text('图标:', style: TextStyle(fontSize: 12)),
                                  _buildImagePreview(sourceInfo.iconImage, 40),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await channel.setScreenCaptureSource(
                                sourceInfo,
                                NERtcRectangle(
                                    x: 0, y: 0, width: 1920, height: 1080),
                                ScreenCaptureParametersConfig.parameters);
                            Navigator.of(context).pop();
                            FlutterToastr.show('设置屏幕捕获源结果: $result', context,
                                position: FlutterToastr.bottom);
                          },
                          child: Text('动态切换'),
                        ),
                        SizedBox(width: 8),
                        if (_shouldShowShareButton(sourceInfo.type))
                          ElevatedButton(
                            onPressed: () => _handleShareSource(sourceInfo),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _getShareButtonColor(sourceInfo.type),
                            ),
                            child: Text(
                              _getShareButtonText(sourceInfo.type),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _showScreenCaptureParametersDialog((params) {
                  FlutterToastr.show('参数配置已保存', context,
                      position: FlutterToastr.bottom);
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('参数配置'),
            ),
            TextButton(
              onPressed: () {
                sources.release();
                Navigator.of(context).pop();
              },
              child: Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  void _startScreenCaptureByWindow(NERtcScreenCaptureSourceInfo sourceInfo) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController regionXController =
            TextEditingController(text: '0');
        TextEditingController regionYController =
            TextEditingController(text: '0');
        TextEditingController regionWidthController =
            TextEditingController(text: '1920');
        TextEditingController regionHeightController =
            TextEditingController(text: '1080');

        return AlertDialog(
          title: Text('分享窗口: ${sourceInfo.sourceTitle}'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '窗口ID: ${sourceInfo.sourceId}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 16),
                Text('捕获区域设置:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: regionXController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'X坐标',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                      controller: regionYController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Y坐标',
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: regionWidthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '宽度',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                      controller: regionHeightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '高度',
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _showScreenCaptureParametersDialog((params) {
                  FlutterToastr.show('参数配置已更新', context,
                      position: FlutterToastr.bottom);
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('参数配置'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  setState(() {
                    if (_localSubStreamSession == null) {
                      _localSubStreamSession = _UserSession(widget.uid, true);
                    }
                  });
                  final result = await channel.startScreenCaptureByWindowId(
                      sourceInfo.sourceId,
                      NERtcRectangle(
                          x: int.parse(regionXController.text),
                          y: int.parse(regionYController.text),
                          width: int.parse(regionWidthController.text),
                          height: int.parse(regionHeightController.text)),
                      ScreenCaptureParametersConfig.parameters);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  FlutterToastr.show('开始窗口捕获结果: $result', context,
                      position: FlutterToastr.bottom);
                } catch (e) {
                  Navigator.of(context).pop();
                  FlutterToastr.show('错误: $e', context,
                      position: FlutterToastr.bottom);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('开始分享窗口'),
            ),
          ],
        );
      },
    );
  }

  void _startScreenCaptureByDisplay(NERtcScreenCaptureSourceInfo sourceInfo) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController regionXController =
            TextEditingController(text: '0');
        TextEditingController regionYController =
            TextEditingController(text: '0');
        TextEditingController regionWidthController =
            TextEditingController(text: '1920');
        TextEditingController regionHeightController =
            TextEditingController(text: '1080');

        return AlertDialog(
          title: Text('分享桌面: ${sourceInfo.sourceTitle}'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '显示器ID: ${sourceInfo.sourceId}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                if (sourceInfo.primaryMonitor)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '主显示器',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 16),
                Text('捕获区域设置:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: regionXController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'X坐标',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                      controller: regionYController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Y坐标',
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: regionWidthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '宽度',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                      controller: regionHeightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '高度',
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _showScreenCaptureParametersDialog((params) {
                  FlutterToastr.show('参数配置已更新', context,
                      position: FlutterToastr.bottom);
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('参数配置'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  setState(() {
                    if (_localSubStreamSession == null) {
                      _localSubStreamSession = _UserSession(widget.uid, true);
                    }
                  });
                  final result = await channel.startScreenCaptureByDisplayId(
                      sourceInfo.sourceId,
                      NERtcRectangle(
                          x: int.parse(regionXController.text),
                          y: int.parse(regionYController.text),
                          width: int.parse(regionWidthController.text),
                          height: int.parse(regionHeightController.text)),
                      ScreenCaptureParametersConfig.parameters);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  FlutterToastr.show('开始桌面捕获结果: $result', context,
                      position: FlutterToastr.bottom);
                } catch (e) {
                  Navigator.of(context).pop();
                  FlutterToastr.show('错误: $e', context,
                      position: FlutterToastr.bottom);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('开始分享桌面'),
            ),
          ],
        );
      },
    );
  }

  void _debugImageBuffer(NERtcThumbImageBuffer imageBuffer) {
    print('=== 图像调试信息 ===');
    print('Buffer长度: ${imageBuffer.buffer.length}');
    print('声明的长度: ${imageBuffer.length}');
    print('宽度: ${imageBuffer.width}');
    print('高度: ${imageBuffer.height}');

    if (imageBuffer.buffer.length > 0) {
      final header = imageBuffer.buffer.take(10).toList();
      print('前10个字节: $header');

      if (header.length >= 4) {
        if (header[0] == 0x89 &&
            header[1] == 0x50 &&
            header[2] == 0x4E &&
            header[3] == 0x47) {
          print('检测到PNG格式');
        } else if (header[0] == 0xFF &&
            header[1] == 0xD8 &&
            header[2] == 0xFF) {
          print('检测到JPEG格式');
        } else if (header[0] == 0x42 && header[1] == 0x4D) {
          print('检测到BMP格式');
        } else {
          print('未知图像格式或原始像素数据');
        }
      }
    }
    print('==================');
  }

  Widget _buildSourceImage(NERtcThumbImageBuffer imageBuffer) {
    _debugImageBuffer(imageBuffer);

    if (imageBuffer.buffer.isEmpty) {
      return Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
      );
    }

    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: _tryDisplayImage(imageBuffer, 60, 40),
      ),
    );
  }

  Widget _tryDisplayImage(
      NERtcThumbImageBuffer imageBuffer, double width, double height) {
    return FutureBuilder<Widget>(
      future: _processImageData(imageBuffer, width, height),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[200],
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (snapshot.hasData) {
          return snapshot.data!;
        }

        return Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey[600], size: 20),
              Text('格式错误',
                  style: TextStyle(fontSize: 8, color: Colors.grey[600])),
            ],
          ),
        );
      },
    );
  }

  Future<Widget> _processImageData(
      NERtcThumbImageBuffer imageBuffer, double width, double height) async {
    try {
      return Image.memory(
        imageBuffer.buffer,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Image.memory 失败: $error');
          return _tryRawImageData(imageBuffer, width, height);
        },
      );
    } catch (e) {
      print('processImageData 异常: $e');
      return _tryRawImageData(imageBuffer, width, height);
    }
  }

  Widget _tryRawImageData(
      NERtcThumbImageBuffer imageBuffer, double width, double height) {
    try {
      final expectedLength = imageBuffer.width * imageBuffer.height * 4;

      if (imageBuffer.buffer.length == expectedLength) {
        print('尝试RGBA原始数据显示');
        return _createImageFromRGBA(imageBuffer, width, height);
      }

      final rgbLength = imageBuffer.width * imageBuffer.height * 3;
      if (imageBuffer.buffer.length == rgbLength) {
        print('尝试RGB原始数据显示');
        return _createImageFromRGB(imageBuffer, width, height);
      }

      if (imageBuffer.buffer.length == expectedLength) {
        print('尝试BGRA原始数据显示');
        return _createImageFromBGRA(imageBuffer, width, height);
      }

      throw Exception('无法识别的数据格式');
    } catch (e) {
      print('原始数据处理失败: $e');
      return Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 16),
            Text('数据错误', style: TextStyle(fontSize: 8, color: Colors.red)),
          ],
        ),
      );
    }
  }

  Widget _createImageFromRGBA(NERtcThumbImageBuffer imageBuffer,
      double displayWidth, double displayHeight) {
    return FutureBuilder<ui.Image>(
      future: _convertRGBAToImage(imageBuffer),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            size: Size(displayWidth, displayHeight),
            painter: ImagePainter(snapshot.data!),
          );
        }
        return Container(
          color: Colors.grey[300],
          child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
        );
      },
    );
  }

  Future<ui.Image> _convertRGBAToImage(
      NERtcThumbImageBuffer imageBuffer) async {
    final completer = Completer<ui.Image>();

    ui.decodeImageFromPixels(
      imageBuffer.buffer,
      imageBuffer.width,
      imageBuffer.height,
      ui.PixelFormat.rgba8888,
      (ui.Image image) {
        completer.complete(image);
      },
    );

    return completer.future;
  }

  Widget _createImageFromRGB(NERtcThumbImageBuffer imageBuffer,
      double displayWidth, double displayHeight) {
    final rgbaBuffer = Uint8List(imageBuffer.width * imageBuffer.height * 4);
    for (int i = 0; i < imageBuffer.width * imageBuffer.height; i++) {
      final rgbIndex = i * 3;
      final rgbaIndex = i * 4;

      rgbaBuffer[rgbaIndex] = imageBuffer.buffer[rgbIndex];
      rgbaBuffer[rgbaIndex + 1] = imageBuffer.buffer[rgbIndex + 1];
      rgbaBuffer[rgbaIndex + 2] = imageBuffer.buffer[rgbIndex + 2];
      rgbaBuffer[rgbaIndex + 3] = 255;
    }

    final modifiedBuffer = NERtcThumbImageBuffer(
      buffer: rgbaBuffer,
      length: rgbaBuffer.length,
      width: imageBuffer.width,
      height: imageBuffer.height,
    );

    return _createImageFromRGBA(modifiedBuffer, displayWidth, displayHeight);
  }

  Widget _createImageFromBGRA(NERtcThumbImageBuffer imageBuffer,
      double displayWidth, double displayHeight) {
    final rgbaBuffer = Uint8List.fromList(imageBuffer.buffer);
    for (int i = 0; i < imageBuffer.width * imageBuffer.height; i++) {
      final index = i * 4;
      final b = rgbaBuffer[index];
      final r = rgbaBuffer[index + 2];
      rgbaBuffer[index] = r;
      rgbaBuffer[index + 2] = b;
    }

    final modifiedBuffer = NERtcThumbImageBuffer(
      buffer: rgbaBuffer,
      length: rgbaBuffer.length,
      width: imageBuffer.width,
      height: imageBuffer.height,
    );

    return _createImageFromRGBA(modifiedBuffer, displayWidth, displayHeight);
  }

  Widget _buildImagePreview(NERtcThumbImageBuffer imageBuffer, double size) {
    if (imageBuffer.buffer.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey[600],
          size: size * 0.4,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showFullScreenImage(imageBuffer),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              _tryDisplayImage(imageBuffer, size, size),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    '${imageBuffer.width}×${imageBuffer.height}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(NERtcThumbImageBuffer imageBuffer) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: FutureBuilder<Widget>(
                    future: _processImageData(imageBuffer, 400, 400),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 16),
                                Text(
                                  '加载图像中...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        return snapshot.data!;
                      }

                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image,
                                size: 64, color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              '图像加载失败',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '数据长度: ${imageBuffer.buffer.length} bytes\n'
                              '期望格式: ${imageBuffer.width}×${imageBuffer.height}',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '图像信息',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '尺寸: ${imageBuffer.width}×${imageBuffer.height}\n'
                        '数据大小: ${imageBuffer.buffer.length} bytes\n'
                        '声明大小: ${imageBuffer.length} bytes',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSourceTypeString(NERtcScreenCaptureSourceType type) {
    switch (type) {
      case NERtcScreenCaptureSourceType.kWindow:
        return '窗口';
      case NERtcScreenCaptureSourceType.kScreen:
        return '屏幕';
      case NERtcScreenCaptureSourceType.kCustom:
        return '自定义';
      case NERtcScreenCaptureSourceType.kUnknown:
      default:
        return '未知';
    }
  }

  Widget buildControlPanel1(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
              child: buildControlButton(() {
            channel.enableLocalAudio(true);
            channel.enableMediaPub(
                NERtcMediaPubType.kNERtcMediaPubTypeAudio, true);
          }, Text("通用", style: TextStyle(fontSize: 12)))),
          Expanded(
              child: buildControlButton(() {
            channel.leaveChannel();
          }, Text('离开会议', style: TextStyle(fontSize: 12)))),
          Expanded(
              child: buildControlButton(() {
            channel.release();
            // 立即销毁页面
            Navigator.pop(context);
          }, Text('释放子房间', style: TextStyle(fontSize: 12))))
        ],
      ),
    );
  }

  Widget buildControlPanel2(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: [
          if (Platform.isAndroid || Platform.isIOS)
            Expanded(
                child: buildControlButton(() {
              _showScreenCaptureDialog(context);
            }, Text("开启屏幕共享", style: TextStyle(fontSize: 12)))),
          if (Platform.isAndroid || Platform.isIOS)
            Expanded(
                child: buildControlButton(() {
              channel
                  .stopScreenCapture()
                  .then((res) => print('stopScreenCapture'));
            }, Text("停止屏幕共享", style: TextStyle(fontSize: 12)))),
        ],
      ),
    );
  }

  Widget buildControlPanel3(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
              child: buildControlButton(() {
            _showLocalFallbackDialog(context);
          }, Text("设置本端回退选项", style: TextStyle(fontSize: 12)))),
          Expanded(
              child: buildControlButton(() {
            _showRemoteFallbackDialog(context);
          }, Text("设置远端回退选项", style: TextStyle(fontSize: 12)))),
          Expanded(
              child: buildControlButton(() {
            _showHighPriorityDialog(context);
          }, Text("设置高优先级", style: TextStyle(fontSize: 12)))),
        ],
      ),
    );
  }

  Widget buildControlButton(VoidCallback onPressed, Widget child) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }

  void _showScreenCaptureDialog(BuildContext context) {
    final contentPreferController =
        TextEditingController(text: '${NERtcSubStreamContentPrefer.motion}');
    final videoProfileController =
        TextEditingController(text: '${NERtcVideoProfile.standard}');
    final frameRateController =
        TextEditingController(text: '${NERtcVideoFrameRate.fps_7}');
    final minFrameRateController = TextEditingController(text: '0');
    final bitrateController = TextEditingController(text: '0');
    final minBitrateController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('屏幕共享参数配置'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentPreferController,
                  decoration: InputDecoration(
                    labelText: '编码策略倾向 (0:动画, 1:细节)',
                    hintText: '${NERtcSubStreamContentPrefer.motion}',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: videoProfileController,
                  decoration: InputDecoration(
                    labelText: '视频档位 (0-4)',
                    hintText: '${NERtcVideoProfile.standard}',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: frameRateController,
                  decoration: InputDecoration(
                    labelText: '视频编码帧率 (0/7/10/15/24/30)',
                    hintText: '${NERtcVideoFrameRate.fps_7}',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: minFrameRateController,
                  decoration: InputDecoration(
                    labelText: '最小帧率 (0表示默认)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: bitrateController,
                  decoration: InputDecoration(
                    labelText: '视频编码码率(Kbps, 0表示默认)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: minBitrateController,
                  decoration: InputDecoration(
                    labelText: '视频编码最小码率(Kbps, 0表示默认)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                try {
                  final config = NERtcScreenConfig();
                  config.contentPrefer =
                      int.parse(contentPreferController.text);
                  config.videoProfile = int.parse(videoProfileController.text);
                  config.frameRate = int.parse(frameRateController.text);
                  config.minFrameRate = int.parse(minFrameRateController.text);
                  config.bitrate = int.parse(bitrateController.text);
                  config.minBitrate = int.parse(minBitrateController.text);

                  channel.startScreenCapture(config).then((result) {
                    Navigator.of(dialogContext).pop();
                    if (result == 0) {
                      FlutterToastr.show('屏幕共享开启成功', context);
                    } else {
                      FlutterToastr.show('屏幕共享开启失败: $result', context);
                    }
                  }).catchError((error) {
                    Navigator.of(dialogContext).pop();
                    FlutterToastr.show('屏幕共享开启失败: $error', context);
                  });
                } catch (e) {
                  FlutterToastr.show('参数格式错误: $e', context);
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showLocalFallbackDialog(BuildContext context) {
    final optionController = TextEditingController(text: '0');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('设置本端回退选项'),
          content: TextField(
            controller: optionController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'option',
              hintText: '0 / 1 / 2',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final option = int.parse(optionController.text.trim());
                  final result =
                      await channel.setLocalPublishFallbackOption(option);
                  Navigator.of(dialogContext).pop();
                  if (result == 0) {
                    FlutterToastr.show('设置成功', context);
                  } else {
                    FlutterToastr.show('设置失败: $result', context);
                  }
                } catch (e) {
                  FlutterToastr.show('参数错误: $e', context);
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoteFallbackDialog(BuildContext context) {
    final optionController = TextEditingController(text: '0');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('设置远端回退选项'),
          content: TextField(
            controller: optionController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'option',
              hintText: '0 / 1 / 2',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final option = int.parse(optionController.text.trim());
                  final result =
                      await channel.setRemoteSubscribeFallbackOption(option);
                  Navigator.of(dialogContext).pop();
                  if (result == 0) {
                    FlutterToastr.show('设置成功', context);
                  } else {
                    FlutterToastr.show('设置失败: $result', context);
                  }
                } catch (e) {
                  FlutterToastr.show('参数错误: $e', context);
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showHighPriorityDialog(BuildContext context) {
    bool enabled = true;
    final uidController = TextEditingController(text: '0');
    final streamTypeController = TextEditingController(
        text: '${NERtcAudioStreamType.kNERtcAudioStreamTypeMain}');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('设置高优先级'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('启用'),
                      Switch(
                        value: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: uidController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '远端 UID',
                      hintText: '请输入远端用户 ID',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: streamTypeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '音频流类型',
                      hintText:
                          '${NERtcAudioStreamType.kNERtcAudioStreamTypeMain}',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final uid = int.parse(uidController.text.trim());
                    final streamType =
                        int.parse(streamTypeController.text.trim());
                    final result = await channel
                        .setRemoteHighPriorityAudioStream(enabled, uid,
                            streamType: streamType);
                    Navigator.of(dialogContext).pop();
                    if (result == 0) {
                      FlutterToastr.show('设置成功', context);
                    } else {
                      FlutterToastr.show('设置失败: $result', context);
                    }
                  } catch (e) {
                    FlutterToastr.show('参数错误: $e', context);
                  }
                },
                child: Text('确定'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget buildVideoViews(BuildContext context) {
    final sessions = [
      if (_localSession != null) _localSession!,
      if (_localSubStreamSession != null) _localSubStreamSession!,
      ..._remoteSessions,
    ];

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      final isLandscape = orientation == Orientation.landscape;
      return GridView.builder(
          scrollDirection: isLandscape ? Axis.horizontal : Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLandscape ? 1 : 3,
            childAspectRatio: isLandscape ? 16 / 9 : 9 / 16,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
          ),
          itemCount: sessions.length,
          itemBuilder: (BuildContext context, int index) {
            return buildVideoView(context, sessions[index]);
          });
    });
  }

  Widget buildVideoView(BuildContext context, _UserSession session) {
    return Container(
      child: Stack(
        children: [
          NERtcVideoView.withInternalRenderer(
            uid: session.uid == widget.uid ? null : session.uid,
            subStream: session.subStream,
            mirrorListenable: session.mirror,
            rendererEventLister: this,
            fitType: videoViewFitType == 0
                ? NERtcVideoViewFitType.contain
                : NERtcVideoViewFitType.cover,
            channelTag: widget.cname,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                session.subStream ? '${session.uid} @ Sub' : '${session.uid}',
                style: TextStyle(color: Colors.red, fontSize: 10),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void onFirstFrameRendered(int uid) {
    print("--- onFirstFrameRendered uid:$uid");
  }

  @override
  void onFrameResolutionChanged(int uid, int width, int height, int rotation) {
    print(
        "--- onFrameResolutionChanged, uid:$uid, width:$width, height:$height, rotation:$rotation");
  }

  @override
  void onJoinChannel(int result, int channelId, int elapsed, int uid) {
    print(
        "--- onJoinChannel result:$result, channelId:$channelId, elapsed:$elapsed, uid:$uid");
  }

  @override
  void onLeaveChannel(int result) {
    print("--- onLeaveChannel result:$result");
  }

  @override
  void onUserJoined(int uid, NERtcUserJoinExtraInfo? joinExtraInfo) {
    print("--- onUserJoined uid:$uid, joinExtraInfo:$joinExtraInfo");
    setState(() {});
  }

  @override
  void onUserLeave(
      int uid, int reason, NERtcUserLeaveExtraInfo? leaveExtraInfo) {
    print(
        "--- onUserLeave uid:$uid, reason:$reason, leaveExtraInfo:$leaveExtraInfo");
    for (_UserSession session in _remoteSessions.toList()) {
      if (session.uid == uid) {
        _remoteSessions.remove(session);
      }
    }
    setState(() {});
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    print('--- onUserVideoStart uid:$uid');
    setupVideoView(uid, maxProfile, false);
  }

  @override
  void onUserVideoStop(int uid) {
    print('--- onUserVideoStop uid:$uid');
    releaseVideoView(uid, false);
  }

  void onUserSubStreamVideoStart(int uid, int maxProfile) {
    print('--- onUserSubStreamVideoStart uid:$uid');
    setupVideoView(uid, maxProfile, true);
  }

  void onUserSubStreamVideoStop(int uid) {
    print('--- onUserSubStreamVideoStop uid:$uid');
    releaseVideoView(uid, true);
  }

  @override
  void onUserVideoMute(int uid, bool muted, int? streamType) {
    print("--- onUserVideoMute uid:$uid, muted:$muted, streamType:$streamType");
  }

  @override
  void onUserAudioStart(int uid) {
    print("--- onUserAudioStart uid:$uid");
  }

  @override
  void onUserAudioStop(int uid) {
    print("--- onUserAudioStop uid:$uid");
  }

  void onUserSubStreamAudioStart(int uid) {
    print("---- onUserSubStreamAudioStart uid:$uid");
  }

  void onUserSubStreamAudioStop(int uid) {
    print("---- onUserSubStreamAudioStop uid:$uid");
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    print("--- onUserAudioMute uid:$uid, muted:$muted");
  }

  @override
  void onTakeSnapshotResult(int code, String path) {
    print("--- onTakeSnapshotResult code:$code, path:$path");
  }

  @override
  void onLocalAudioVolumeIndication(int volume, bool vadFlag) {
    print("--- onLocalAudioVolumeIndication volume:$volume, vadFlag:$vadFlag");
  }

  @override
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {
    print(
        "--- onRemoteAudioVolumeIndication volumeList:$volumeList, totalVolume:$totalVolume");
  }

  // ------ NERtcStatsEventCallback -----
  @override
  void onRtcStats(NERtcStats stats) {
    print("--- onRtcStats#$stats");
  }

  @override
  void onLocalAudioStats(NERtcAudioSendStats stats) {
    print("--- onLocalAudioStats#$stats");
  }

  @override
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList) {
    print("--- onRemoteAudioStats#$statsList");
  }

  @override
  void onLocalVideoStats(NERtcVideoSendStats stats) {
    print("--- onLocalVideoStats#$stats");
  }

  @override
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList) {
    print("--- onRemoteVideoStats#$statsList");
  }

  @override
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {
    print("--- onNetworkQuality#$statsList");
  }

  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {
    print(
        '--- onLocalPublishFallbackToAudioOnly#isFallback:$isFallback, streamType:$streamType');
  }

  void onRemoteSubscribeFallbackToAudioOnly(
      int uid, bool isFallback, int streamType) {
    print(
        '--- onRemoteSubscribeFallbackToAudioOnly#uid:$uid, isFallback:$isFallback, streamType:$streamType');
  }
}

class _UserSession {
  final int uid;
  final bool subStream;

  _UserSession(this.uid, [this.subStream = false]);

  ValueNotifier<bool>? _mirror;
  ValueNotifier<bool> get mirror {
    _mirror ??= ValueNotifier<bool>(false);
    return _mirror!;
  }
}
