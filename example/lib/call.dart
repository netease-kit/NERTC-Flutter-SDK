// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nertc_core_example/config.dart';
import 'package:path_provider/path_provider.dart';
import 'channel.dart';
import 'settings.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:nertc_core/nertc_core.dart';
import 'package:nertc_core_platform_interface/nertc_core_platform_interface.dart';
import 'package:nertc_core_example/native_log_helper.dart';

// 自定义画笔绘制图像
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

// 添加一个全局的屏幕捕获参数配置
class ScreenCaptureParametersConfig {
  static NERtcScreenCaptureParameters _parameters =
      NERtcScreenCaptureParameters();

  static NERtcScreenCaptureParameters get parameters => _parameters;

  static void updateParameters(NERtcScreenCaptureParameters newParams) {
    _parameters = newParams;
  }
}

class CallPage extends StatefulWidget {
  final String cid;
  final int uid;

  CallPage({Key? key, required this.cid, required this.uid});

  @override
  _CallPageState createState() {
    return _CallPageState();
  }
}

class _CallPageState extends State<CallPage>
    with
        AppLoggerMixin,
        NERtcVideoRendererEventListener,
        NERtcChannelEventCallback,
        NERtcAudioMixingEventCallback,
        NERtcAudioEffectEventCallback,
        NERtcStatsEventCallback,
        NERtcDeviceEventCallback,
        NERtcLiveTaskCallback {
  late Settings _settings;
  NERtcEngine _engine = NERtcEngine.instance;
  List<_UserSession> _remoteSessions = [];
  _UserSession? _localSession;
  _UserSession? _localSubStreamSession;

  bool showControlPanel = false;
  final List<String> _localRecordingTaskIds = [];
  bool isFullScreen = false;
  bool isDebugEnv = false;
  late Size screenSize;
  // Control 1
  bool isAudioEnabled = false;
  bool isVideoEnabled = false;
  bool isFrontCamera = true;
  bool isFrontCameraMirror = true;
  bool isSpeakerphoneOn = false;

  // Control 2
  bool isAudioDumpEnabled = false;
  bool isEarBackEnabled = false;
  bool isScreenRecordEnabled = false;

  // Control 3
  bool isLeaveChannel = false;
  bool isAudience = false;
  bool isAudioMixPlaying = false;
  bool isAudioEffectPlaying = false;

  // Control 4
  bool isMuteAudio = false;
  bool isMuteVideo = false;
  bool isMuteMic = false;
  bool isMuteSpeaker = false;
  bool isSubAllAudio = true;

  bool setMediaSever = false;
  int videoViewFitType = 0;

  // 创建一个数据流控制器
  final StreamController<Uint8List> streamController =
      StreamController<Uint8List>();

  // force to call sub and unsub
  bool forceSubAndUnsubVideo = false;
  final foregroundServiceChannel = const MethodChannel(
      'com.netease.nertc_core.nertc_core_example.foreground_service');

  // 统计回调计数器
  int _remoteVideoStatsCount = 0;
  int _localVideoStatsCount = 0;
  int _remoteAudioStatsCount = 0;
  int _localAudioStatsCount = 0;
  int _rtcStatsCount = 0;

  @override
  void initState() {
    super.initState();
    print('start call: uid=${widget.uid}, cid=${widget.cid}');
    _initSettings().then((value) => _initRtcEngine()).then((value) {
      if (_settings.forceLandScapeMode) {
        // 强制设置为横屏模式
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    });
    if (Platform.isAndroid) {
      foregroundServiceChannel.invokeMethod('startForegroundService');
    }
  }

  Future<void> _initSettings() async {
    _settings = await Settings.getInstance();
    isAudioEnabled = _settings.autoEnableAudio;
    isVideoEnabled = _settings.autoEnableVideo;
    isFrontCamera = _settings.frontFacingCamera;
    isFrontCameraMirror = _settings.frontFacingCameraMirror;
    videoViewFitType = _settings.videoViewFitType;
    updateLocalMirror();
  }

  void updateLocalMirror() {
    _localSession?.mirror.value = isFrontCamera && isFrontCameraMirror;
  }

  Future<String?> getLogPath(String path) async {
    Directory? directory;
    if (Platform.isIOS || Platform.isMacOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    }
    if (directory != null) {
      return '${directory.path}/${path}';
    }
    return null;
  }

  Future<void> updateSettings() async {
    isSpeakerphoneOn = await _engine.deviceManager.isSpeakerphoneOn();
    showControlPanel = true;
  }

  Future<void> testFlutterInterface() async {
    // NERtcAudioMixingOptions options = NERtcAudioMixingOptions(path: 'http://jdvodbbjc75zn.vod.126.net/jdvodbbjc75zn/7596994f848844e99a4d37b91d0c77da.mp3')
    //   ..sendWithAudioType = NERtcAudioStreamType.kNERtcAudioStreamTypeSub
    //   ..sendEnabled = true;
    // _engine.audioMixingManager.startAudioMixing(options);
    _engine.subscribeRemoteSubStreamAudio(123456, true);
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
            title: Text(widget.cid),
          ),
          body: buildCallingWidget(context),
        ),
      ),
      // ignore: missing_return
      onWillPop: () {
        _requestPop();
        return Future.value(true);
      },
    );
  }

  Widget buildControlButton(VoidCallback onPressed, Widget child) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
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
        buildControlPanel4(context),
        if (Platform.isMacOS || Platform.isWindows) buildControlPanel5(context),
        if (Platform.isMacOS || Platform.isWindows) buildControlPanel6(context),
        buildControlPanel7(context),
        if (Platform.isMacOS || Platform.isWindows) buildControlPanel8(context),
        if (Platform.isMacOS || Platform.isWindows) buildControlPanel9(context),
      ],
    );
  }

  Widget buildControlPanel8(BuildContext context) {
    List<Widget> children = [];
    children.add(Expanded(
        child: buildControlButton(() {
      _showAddLocalRecorderDialog();
    }, Text('本地录制任务', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showRemoveLocalRecorderDialog();
    }, Text('删除录制任务', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showAddRecorderStreamLayoutDialog();
    }, Text('指定流录制任务', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showRemoveRecorderStreamLayoutDialog();
    }, Text('删除流录制任务', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showUpdateRecorderStreamLayoutDialog();
    }, Text('更新流录制任务', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showReplaceRecorderStreamLayoutDialog();
    }, Text('替换流录制任务', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showUpdateRecorderWatermarksDialog();
    }, Text('更新录制文件水印', style: TextStyle(fontSize: 10)))));
    return Container(
        height: 40,
        child: Row(
          children: children,
        ));
  }

  Widget buildControlPanel9(BuildContext context) {
    List<Widget> children = [];
    children.add(Expanded(
        child: buildControlButton(() {
      _showShowDefaultCoverDialog();
    }, Text('是否显示封面', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showStopRemuxMp4Dialog();
    }, Text('停止转码mp4', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showRemuxFlvToMp4Dialog();
    }, Text('flv转码mp4', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showStopRemuxFlvToMp4Dialog();
    }, Text('停止flv转码mp4', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
        child: buildControlButton(() {
      _showPushLocalRecorderVideoFrameDialog();
    }, Text('推送本地录制视频帧', style: TextStyle(fontSize: 10)))));
    return Container(
      height: 40,
      child: Row(
        children: children,
      ),
    );
  }

  void _showAddRecorderStreamLayoutDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    final uidController = TextEditingController(text: '0');
    final streamTypeController = TextEditingController(text: '0');
    final streamLayerController = TextEditingController(text: '0');
    final offsetXController = TextEditingController(text: '0');
    final offsetYController = TextEditingController(text: '0');
    final widthController = TextEditingController(text: '640');
    final heightController = TextEditingController(text: '360');
    final scalingModeController = TextEditingController(text: '0');
    final isScreenShareController = TextEditingController(text: '0');
    final bgColorController = TextEditingController(text: '0xFF000000');
    final List<_WatermarkFormEntry> watermarkEntries = [];

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('添加指定流录制任务'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: '选择任务 ID', border: OutlineInputBorder()),
                      value: selectedTaskId,
                      items: _localRecordingTaskIds
                          .map((id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedTaskId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDialogTextField('用户 UID', uidController,
                        keyboardType: TextInputType.number),
                    _buildDialogTextField('流类型 (int)', streamTypeController,
                        keyboardType: TextInputType.number,
                        hint: '0: 主流, 1: 辅流'),
                    _buildDialogTextField('流层级', streamLayerController,
                        keyboardType: TextInputType.number),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDialogTextField(
                                '偏移 X', offsetXController,
                                keyboardType: TextInputType.number)),
                        SizedBox(width: 8),
                        Expanded(
                            child: _buildDialogTextField(
                                '偏移 Y', offsetYController,
                                keyboardType: TextInputType.number)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDialogTextField('宽度', widthController,
                                keyboardType: TextInputType.number)),
                        SizedBox(width: 8),
                        Expanded(
                            child: _buildDialogTextField('高度', heightController,
                                keyboardType: TextInputType.number)),
                      ],
                    ),
                    _buildDialogTextField('缩放模式 (int)', scalingModeController,
                        keyboardType: TextInputType.number,
                        hint: '0: FullFill, 1: Fit, 2: CropFill'),
                    _buildDialogTextField(
                        '是否屏幕共享 (0/1)', isScreenShareController,
                        keyboardType: TextInputType.number),
                    _buildDialogTextField('背景色 (ARGB)', bgColorController,
                        keyboardType: TextInputType.text,
                        hint: '例如 0xFF000000'),
                    const SizedBox(height: 12),
                    _buildWatermarkSection(
                        title: '水印列表（可选）',
                        entries: watermarkEntries,
                        setState: setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final uid =
                            int.tryParse(uidController.text.trim()) ?? 0;
                        final streamTypeValue =
                            int.tryParse(streamTypeController.text.trim()) ?? 0;
                        final layer =
                            int.tryParse(streamLayerController.text.trim()) ??
                                0;
                        final offsetX =
                            int.tryParse(offsetXController.text.trim()) ?? 0;
                        final offsetY =
                            int.tryParse(offsetYController.text.trim()) ?? 0;
                        final width =
                            int.tryParse(widthController.text.trim()) ?? 0;
                        final height =
                            int.tryParse(heightController.text.trim()) ?? 0;
                        final scalingModeValue =
                            int.tryParse(scalingModeController.text.trim()) ??
                                0;
                        final isScreenShare =
                            isScreenShareController.text.trim() == '1';
                        final bgColor = _WatermarkFormEntry._parseColor(
                            bgColorController.text, 0);
                        final watermarkList =
                            _buildWatermarkConfigs(watermarkEntries);

                        final streamType = streamTypeValue == 1
                            ? NERtcVideoStreamType.sub
                            : NERtcVideoStreamType.main;
                        final scalingMode = _mapScalingMode(scalingModeValue);

                        final layoutConfig = NERtcLocalRecordingLayoutConfig(
                            offsetX: offsetX,
                            offsetY: offsetY,
                            width: width,
                            height: height,
                            scalingMode: scalingMode,
                            watermarkList: watermarkList,
                            isScreenShare: isScreenShare,
                            bgColor: bgColor);

                        final ret =
                            await _engine.addLocalRecorderStreamLayoutForTask(
                                layoutConfig,
                                uid,
                                streamType,
                                layer,
                                selectedTaskId);
                        FlutterToastr.show('添加结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('添加失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  Widget buildControlPanel7(BuildContext context) {
    List<Widget> children = [];
    children.add(
      Expanded(
        child: buildControlButton(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChannelPage(
                        cname: "12345",
                        uid: 5930,
                      )));
        }, Text('子房间', style: TextStyle(fontSize: 10))),
      ),
    );
    children.add(Expanded(
        child: buildControlButton(() {
      Navigator.pop(context);
    }, Text('销毁页面', style: TextStyle(fontSize: 10)))));

    children.add(Expanded(
        child: buildControlButton(() {
      testFlutterInterface();
    }, Text('Test', style: TextStyle(fontSize: 10)))));
    return Container(
      height: 40,
      child: Row(
        children: children,
      ),
    );
  }

  String _enumLabel(Object value) {
    final segments = value.toString().split('.');
    return segments.isNotEmpty ? segments.last : value.toString();
  }

  void _showAddLocalRecorderDialog() {
    final taskIdController = TextEditingController(
        text: 'task_${DateTime.now().millisecondsSinceEpoch}');
    final filePathController = TextEditingController(text: '/tmp');
    final fileNameController = TextEditingController(text: 'record');
    final widthController = TextEditingController(text: '1280');
    final heightController = TextEditingController(text: '720');
    final frameRateController = TextEditingController(text: '15');
    final coverPathController = TextEditingController();
    final defaultCoverPathController = TextEditingController();
    final List<_WatermarkFormEntry> watermarkEntries = [];
    final List<_WatermarkFormEntry> coverWatermarkEntries = [];
    bool remuxToMp4 = false;
    bool videoMerge = false;
    bool recordAudio = true;
    bool recordVideo = true;
    NERtcLocalRecordingFileType selectedFileType =
        NERtcLocalRecordingFileType.kNERtcLocalRecordingFileTypeMp4;
    NERtcLocalRecordingAudioFormat selectedAudioFormat =
        NERtcLocalRecordingAudioFormat.kNERtcLocalRecorderAudioFormatAac;
    NERtcLocalRecordingVideoMode selectedVideoMode =
        NERtcLocalRecordingVideoMode.kNERtcLocalRecorderVideoWithAudio;

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('添加本地录制流任务'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogTextField('任务 ID', taskIdController),
                    _buildDialogTextField('文件路径', filePathController),
                    _buildDialogTextField('文件名称', fileNameController),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDialogTextField('宽度', widthController,
                                keyboardType: TextInputType.number)),
                        SizedBox(width: 8),
                        Expanded(
                            child: _buildDialogTextField('高度', heightController,
                                keyboardType: TextInputType.number)),
                      ],
                    ),
                    _buildDialogTextField('帧率', frameRateController,
                        keyboardType: TextInputType.number),
                    _buildDropdown<NERtcLocalRecordingFileType>(
                        '文件类型',
                        selectedFileType,
                        NERtcLocalRecordingFileType.values, (value) {
                      setState(() {
                        selectedFileType = value!;
                      });
                    }),
                    _buildDropdown<NERtcLocalRecordingAudioFormat>(
                        '音频格式',
                        selectedAudioFormat,
                        NERtcLocalRecordingAudioFormat.values, (value) {
                      setState(() {
                        selectedAudioFormat = value!;
                      });
                    }),
                    _buildDropdown<NERtcLocalRecordingVideoMode>(
                        '视频模式',
                        selectedVideoMode,
                        NERtcLocalRecordingVideoMode.values, (value) {
                      setState(() {
                        selectedVideoMode = value!;
                      });
                    }),
                    SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('转码为 MP4'),
                        value: remuxToMp4,
                        onChanged: (value) {
                          setState(() {
                            remuxToMp4 = value;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('视频混流'),
                        value: videoMerge,
                        onChanged: (value) {
                          setState(() {
                            videoMerge = value;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('录制音频'),
                        value: recordAudio,
                        onChanged: (value) {
                          setState(() {
                            recordAudio = value;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('录制视频'),
                        value: recordVideo,
                        onChanged: (value) {
                          setState(() {
                            recordVideo = value;
                          });
                        }),
                    const SizedBox(height: 12),
                    _buildWatermarkSection(
                        title: '水印列表（可选）',
                        entries: watermarkEntries,
                        setState: setState),
                    const SizedBox(height: 12),
                    _buildWatermarkSection(
                        title: '封面水印列表（可选）',
                        entries: coverWatermarkEntries,
                        setState: setState),
                    const SizedBox(height: 12),
                    _buildDialogTextField('封面文件路径', coverPathController),
                    _buildDialogTextField(
                        '默认封面文件路径', defaultCoverPathController),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      final width = int.tryParse(widthController.text) ?? 1280;
                      final height = int.tryParse(heightController.text) ?? 720;
                      final frameRate =
                          int.tryParse(frameRateController.text) ?? 15;
                      final taskId = taskIdController.text.trim();
                      if (taskId.isEmpty) {
                        FlutterToastr.show('任务 ID 不能为空', context);
                        return;
                      }
                      List<NERtcVideoWatermarkConfig>? watermarkList;
                      List<NERtcVideoWatermarkConfig>? coverWatermarkList;
                      try {
                        watermarkList =
                            _buildWatermarkConfigs(watermarkEntries);
                        coverWatermarkList =
                            _buildWatermarkConfigs(coverWatermarkEntries);
                      } catch (e) {
                        FlutterToastr.show('水印配置有误: $e', context);
                        return;
                      }
                      final config = NERtcLocalRecordingConfig(
                        filePath: filePathController.text.trim(),
                        fileName: fileNameController.text.trim(),
                        width: width,
                        height: height,
                        framerate: frameRate,
                        recordFileType: selectedFileType,
                        remuxToMp4: remuxToMp4,
                        videoMerge: videoMerge,
                        recordAudio: recordAudio,
                        audioFormat: selectedAudioFormat,
                        recordVideo: recordVideo,
                        videoRecordMode: selectedVideoMode,
                        watermarkList: watermarkList,
                        coverFilePath: coverPathController.text.isEmpty
                            ? null
                            : coverPathController.text.trim(),
                        coverWatermarkList: coverWatermarkList,
                        defaultCoverFilePath:
                            defaultCoverPathController.text.isEmpty
                                ? null
                                : defaultCoverPathController.text.trim(),
                      );
                      try {
                        final ret = await _engine.addLocalRecorderStreamForTask(
                            config, taskId);
                        FlutterToastr.show('调用结果: $ret', context);
                        if (mounted) {
                          if (ret == 0 &&
                              !_localRecordingTaskIds.contains(taskId)) {
                            setState(() {
                              _localRecordingTaskIds.add(taskId);
                            });
                          }
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('调用失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showRemoveLocalRecorderDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('暂无可删除的任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('删除录制任务'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('请选择要删除的任务：'),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedTaskId,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedTaskId = value;
                        });
                      }
                    },
                    items: _localRecordingTaskIds
                        .map((id) => DropdownMenuItem<String>(
                              value: id,
                              child: Text(id),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('确认后将从引擎中移除该录制任务。'),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final ret = await _engine
                            .removeLocalRecorderStreamForTask(selectedTaskId);
                        FlutterToastr.show('删除结果: $ret', context);
                        if (ret == 0) {
                          setState(() {
                            _localRecordingTaskIds.remove(selectedTaskId);
                          });
                          if (mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        }
                      } catch (e) {
                        FlutterToastr.show('删除失败: $e', context);
                      }
                    },
                    child: Text('确认删除')),
              ],
            );
          });
        });
  }

  void _showRemoveRecorderStreamLayoutDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    final uidController = TextEditingController(text: '0');
    final streamTypeController = TextEditingController(text: '0');
    final streamLayerController = TextEditingController(text: '0');

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('删除流录制任务'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: '选择任务 ID', border: OutlineInputBorder()),
                    value: selectedTaskId,
                    items: _localRecordingTaskIds
                        .map((id) => DropdownMenuItem<String>(
                              value: id,
                              child: Text(id),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedTaskId = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDialogTextField('用户 UID', uidController,
                      keyboardType: TextInputType.number),
                  _buildDialogTextField('流类型 (int)', streamTypeController,
                      keyboardType: TextInputType.number, hint: '0: 主流, 1: 辅流'),
                  _buildDialogTextField('流层级', streamLayerController,
                      keyboardType: TextInputType.number),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final uid =
                            int.tryParse(uidController.text.trim()) ?? 0;
                        final streamTypeValue =
                            int.tryParse(streamTypeController.text.trim()) ?? 0;
                        final layer =
                            int.tryParse(streamLayerController.text.trim()) ??
                                0;
                        final streamType = streamTypeValue == 1
                            ? NERtcVideoStreamType.sub
                            : NERtcVideoStreamType.main;

                        final ret = await _engine
                            .removeLocalRecorderStreamLayoutForTask(
                                uid, streamType, layer, selectedTaskId);
                        FlutterToastr.show('删除结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('删除失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showUpdateRecorderStreamLayoutDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    final List<_StreamInfoFormEntry> streamInfoEntries = [];

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('更新流录制任务'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: '选择任务 ID', border: OutlineInputBorder()),
                      value: selectedTaskId,
                      items: _localRecordingTaskIds
                          .map((id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedTaskId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('流信息列表', style: TextStyle(fontSize: 16)),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              streamInfoEntries.add(_StreamInfoFormEntry());
                            });
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text('添加流信息'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...streamInfoEntries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final streamInfo = entry.value;
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('流信息 ${index + 1}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        streamInfoEntries.removeAt(index);
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildDialogTextField(
                                  '用户 UID', streamInfo.uidController,
                                  keyboardType: TextInputType.number),
                              _buildDialogTextField(
                                  '流类型 (int)', streamInfo.streamTypeController,
                                  keyboardType: TextInputType.number,
                                  hint: '0: 主流, 1: 辅流'),
                              _buildDialogTextField(
                                  '流层级', streamInfo.streamLayerController,
                                  keyboardType: TextInputType.number),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '偏移 X', streamInfo.offsetXController,
                                          keyboardType: TextInputType.number)),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '偏移 Y', streamInfo.offsetYController,
                                          keyboardType: TextInputType.number)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '宽度', streamInfo.widthController,
                                          keyboardType: TextInputType.number)),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '高度', streamInfo.heightController,
                                          keyboardType: TextInputType.number)),
                                ],
                              ),
                              _buildDialogTextField('缩放模式 (int)',
                                  streamInfo.scalingModeController,
                                  keyboardType: TextInputType.number,
                                  hint: '0: FullFill, 1: Fit, 2: CropFill'),
                              _buildDialogTextField('是否屏幕共享 (0/1)',
                                  streamInfo.isScreenShareController,
                                  keyboardType: TextInputType.number),
                              _buildDialogTextField(
                                  '背景色 (ARGB)', streamInfo.bgColorController,
                                  keyboardType: TextInputType.text,
                                  hint: '例如 0xFF000000'),
                              const SizedBox(height: 8),
                              _buildWatermarkSection(
                                  title: '水印列表（可选）',
                                  entries: streamInfo.watermarkEntries,
                                  setState: setState),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    if (streamInfoEntries.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('请至少添加一个流信息',
                            style: TextStyle(color: Colors.grey)),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      if (streamInfoEntries.isEmpty) {
                        FlutterToastr.show('请至少添加一个流信息', context);
                        return;
                      }
                      try {
                        final infos = streamInfoEntries.map((entry) {
                          final uid =
                              int.tryParse(entry.uidController.text.trim()) ??
                                  0;
                          final streamTypeValue = int.tryParse(
                                  entry.streamTypeController.text.trim()) ??
                              0;
                          final layer = int.tryParse(
                                  entry.streamLayerController.text.trim()) ??
                              0;
                          final offsetX = int.tryParse(
                                  entry.offsetXController.text.trim()) ??
                              0;
                          final offsetY = int.tryParse(
                                  entry.offsetYController.text.trim()) ??
                              0;
                          final width =
                              int.tryParse(entry.widthController.text.trim()) ??
                                  0;
                          final height = int.tryParse(
                                  entry.heightController.text.trim()) ??
                              0;
                          final scalingModeValue = int.tryParse(
                                  entry.scalingModeController.text.trim()) ??
                              0;
                          final isScreenShare =
                              entry.isScreenShareController.text.trim() == '1';
                          final bgColor = _WatermarkFormEntry._parseColor(
                              entry.bgColorController.text, 0);
                          final watermarkList =
                              _buildWatermarkConfigs(entry.watermarkEntries);

                          final streamType = streamTypeValue == 1
                              ? NERtcVideoStreamType.sub
                              : NERtcVideoStreamType.main;
                          final scalingMode = _mapScalingMode(scalingModeValue);

                          final layoutConfig = NERtcLocalRecordingLayoutConfig(
                              offsetX: offsetX,
                              offsetY: offsetY,
                              width: width,
                              height: height,
                              scalingMode: scalingMode,
                              watermarkList: watermarkList,
                              isScreenShare: isScreenShare,
                              bgColor: bgColor);

                          return NERtcLocalRecordingStreamInfo(
                              uid: uid,
                              streamType: streamType,
                              streamLayer: layer,
                              layoutConfig: layoutConfig);
                        }).toList();

                        final ret = await _engine
                            .updateLocalRecorderStreamLayoutForTask(
                                infos, selectedTaskId);
                        FlutterToastr.show('更新结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('更新失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showReplaceRecorderStreamLayoutDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    final List<_StreamInfoFormEntry> streamInfoEntries = [];

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('替换流录制任务'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: '选择任务 ID', border: OutlineInputBorder()),
                      value: selectedTaskId,
                      items: _localRecordingTaskIds
                          .map((id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedTaskId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('流信息列表', style: TextStyle(fontSize: 16)),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              streamInfoEntries.add(_StreamInfoFormEntry());
                            });
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text('添加流信息'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...streamInfoEntries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final streamInfo = entry.value;
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('流信息 ${index + 1}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        streamInfoEntries.removeAt(index);
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildDialogTextField(
                                  '用户 UID', streamInfo.uidController,
                                  keyboardType: TextInputType.number),
                              _buildDialogTextField(
                                  '流类型 (int)', streamInfo.streamTypeController,
                                  keyboardType: TextInputType.number,
                                  hint: '0: 主流, 1: 辅流'),
                              _buildDialogTextField(
                                  '流层级', streamInfo.streamLayerController,
                                  keyboardType: TextInputType.number),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '偏移 X', streamInfo.offsetXController,
                                          keyboardType: TextInputType.number)),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '偏移 Y', streamInfo.offsetYController,
                                          keyboardType: TextInputType.number)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '宽度', streamInfo.widthController,
                                          keyboardType: TextInputType.number)),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: _buildDialogTextField(
                                          '高度', streamInfo.heightController,
                                          keyboardType: TextInputType.number)),
                                ],
                              ),
                              _buildDialogTextField('缩放模式 (int)',
                                  streamInfo.scalingModeController,
                                  keyboardType: TextInputType.number,
                                  hint: '0: FullFill, 1: Fit, 2: CropFill'),
                              _buildDialogTextField('是否屏幕共享 (0/1)',
                                  streamInfo.isScreenShareController,
                                  keyboardType: TextInputType.number),
                              _buildDialogTextField(
                                  '背景色 (ARGB)', streamInfo.bgColorController,
                                  keyboardType: TextInputType.text,
                                  hint: '例如 0xFF000000'),
                              const SizedBox(height: 8),
                              _buildWatermarkSection(
                                  title: '水印列表（可选）',
                                  entries: streamInfo.watermarkEntries,
                                  setState: setState),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    if (streamInfoEntries.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('请至少添加一个流信息',
                            style: TextStyle(color: Colors.grey)),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      if (streamInfoEntries.isEmpty) {
                        FlutterToastr.show('请至少添加一个流信息', context);
                        return;
                      }
                      try {
                        final infos = streamInfoEntries.map((entry) {
                          final uid =
                              int.tryParse(entry.uidController.text.trim()) ??
                                  0;
                          final streamTypeValue = int.tryParse(
                                  entry.streamTypeController.text.trim()) ??
                              0;
                          final layer = int.tryParse(
                                  entry.streamLayerController.text.trim()) ??
                              0;
                          final offsetX = int.tryParse(
                                  entry.offsetXController.text.trim()) ??
                              0;
                          final offsetY = int.tryParse(
                                  entry.offsetYController.text.trim()) ??
                              0;
                          final width =
                              int.tryParse(entry.widthController.text.trim()) ??
                                  0;
                          final height = int.tryParse(
                                  entry.heightController.text.trim()) ??
                              0;
                          final scalingModeValue = int.tryParse(
                                  entry.scalingModeController.text.trim()) ??
                              0;
                          final isScreenShare =
                              entry.isScreenShareController.text.trim() == '1';
                          final bgColor = _WatermarkFormEntry._parseColor(
                              entry.bgColorController.text, 0);
                          final watermarkList =
                              _buildWatermarkConfigs(entry.watermarkEntries);

                          final streamType = streamTypeValue == 1
                              ? NERtcVideoStreamType.sub
                              : NERtcVideoStreamType.main;
                          final scalingMode = _mapScalingMode(scalingModeValue);

                          final layoutConfig = NERtcLocalRecordingLayoutConfig(
                              offsetX: offsetX,
                              offsetY: offsetY,
                              width: width,
                              height: height,
                              scalingMode: scalingMode,
                              watermarkList: watermarkList,
                              isScreenShare: isScreenShare,
                              bgColor: bgColor);

                          return NERtcLocalRecordingStreamInfo(
                              uid: uid,
                              streamType: streamType,
                              streamLayer: layer,
                              layoutConfig: layoutConfig);
                        }).toList();

                        final ret = await _engine
                            .replaceLocalRecorderStreamLayoutForTask(
                                infos, selectedTaskId);
                        FlutterToastr.show('替换结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('替换失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showUpdateRecorderWatermarksDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    final List<_WatermarkFormEntry> watermarkEntries = [];

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('更新录制文件水印'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: '选择任务 ID', border: OutlineInputBorder()),
                      value: selectedTaskId,
                      items: _localRecordingTaskIds
                          .map((id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedTaskId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildWatermarkSection(
                        title: '水印列表',
                        entries: watermarkEntries,
                        setState: setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final watermarks =
                            _buildWatermarkConfigs(watermarkEntries);
                        if (watermarks == null || watermarks.isEmpty) {
                          FlutterToastr.show('请至少添加一个水印', context);
                          return;
                        }

                        final ret =
                            await _engine.updateLocalRecorderWaterMarksForTask(
                                watermarks, selectedTaskId);
                        FlutterToastr.show('更新结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('更新失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showShowDefaultCoverDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    bool showEnabled = true;
    final uidController = TextEditingController(text: '0');
    final streamTypeController = TextEditingController(text: '0');
    final streamLayerController = TextEditingController(text: '0');

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('是否显示封面'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: '选择任务 ID', border: OutlineInputBorder()),
                      value: selectedTaskId,
                      items: _localRecordingTaskIds
                          .map((id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedTaskId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('是否显示封面'),
                      value: showEnabled,
                      onChanged: (value) {
                        setState(() {
                          showEnabled = value;
                        });
                      },
                    ),
                    _buildDialogTextField('用户 UID', uidController,
                        keyboardType: TextInputType.number),
                    _buildDialogTextField('流类型 (int)', streamTypeController,
                        keyboardType: TextInputType.number,
                        hint: '0: 主流, 1: 辅流'),
                    _buildDialogTextField('流层级', streamLayerController,
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final uid =
                            int.tryParse(uidController.text.trim()) ?? 0;
                        final streamType =
                            int.tryParse(streamTypeController.text.trim()) ?? 0;
                        final layer =
                            int.tryParse(streamLayerController.text.trim()) ??
                                0;

                        final ret = await _engine
                            .showLocalRecorderStreamDefaultCoverForTask(
                                showEnabled,
                                uid,
                                streamType,
                                layer,
                                selectedTaskId);
                        FlutterToastr.show('操作结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('操作失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showStopRemuxMp4Dialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('停止转码mp4'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: '选择任务 ID', border: OutlineInputBorder()),
                    value: selectedTaskId,
                    items: _localRecordingTaskIds
                        .map((id) => DropdownMenuItem<String>(
                              value: id,
                              child: Text(id),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedTaskId = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final ret = await _engine
                            .stopLocalRecorderRemuxMp4(selectedTaskId);
                        FlutterToastr.show('操作结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('操作失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showRemuxFlvToMp4Dialog() {
    final flvPathController = TextEditingController();
    final mp4PathController = TextEditingController();
    bool saveOri = true;

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('flv转码mp4'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogTextField('FLV文件路径', flvPathController,
                        hint: '包含文件名及后缀名，例如：/tmp/video.flv'),
                    const SizedBox(height: 12),
                    _buildDialogTextField('MP4文件路径', mp4PathController,
                        hint: '包含文件名及后缀名，例如：/tmp/video.mp4'),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('是否保留FLV文件'),
                      value: saveOri,
                      onChanged: (value) {
                        setState(() {
                          saveOri = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final flvPath = flvPathController.text.trim();
                        final mp4Path = mp4PathController.text.trim();
                        if (flvPath.isEmpty) {
                          FlutterToastr.show('请输入FLV文件路径', context);
                          return;
                        }
                        if (mp4Path.isEmpty) {
                          FlutterToastr.show('请输入MP4文件路径', context);
                          return;
                        }

                        final ret = await _engine.remuxFlvToMp4(
                            flvPath, mp4Path, saveOri);
                        FlutterToastr.show('操作结果: $ret', context);
                        if (ret == 0 && mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } catch (e) {
                        FlutterToastr.show('操作失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  void _showStopRemuxFlvToMp4Dialog() {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('停止flv转码mp4'),
            content: Text('确定要停止flv转码mp4操作吗？'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('取消')),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final ret = await _engine.stopRemuxFlvToMp4();
                      FlutterToastr.show('操作结果: $ret', context);
                      if (ret == 0 && mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    } catch (e) {
                      FlutterToastr.show('操作失败: $e', context);
                    }
                  },
                  child: Text('确认')),
            ],
          );
        });
  }

  void _showPushLocalRecorderVideoFrameDialog() {
    if (_localRecordingTaskIds.isEmpty) {
      FlutterToastr.show('请先创建录制任务', context);
      return;
    }

    String selectedTaskId = _localRecordingTaskIds.first;
    int streamType = 0; // 0: 主流, 1: 辅流
    final uidController = TextEditingController(text: '0');
    final streamLayerController = TextEditingController(text: '0');
    final yuvFilePathController = TextEditingController();
    final widthController = TextEditingController();
    final heightController = TextEditingController();
    final fpsController = TextEditingController(text: '30');
    final formatController = TextEditingController(text: '0'); // I420
    final rotationController = TextEditingController(text: '0');
    bool loop = false;

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('推送本地录制视频帧'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: '选择任务 ID', border: OutlineInputBorder()),
                      value: selectedTaskId,
                      items: _localRecordingTaskIds
                          .map((id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedTaskId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDialogTextField('用户 UID', uidController,
                        keyboardType: TextInputType.number),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                          labelText: '流类型', border: OutlineInputBorder()),
                      value: streamType,
                      items: [
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text('视频主流'),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('视频辅流'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            streamType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDialogTextField('流层级', streamLayerController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildDialogTextField('YUV文件路径', yuvFilePathController,
                        hint: '例如: test2_176_144_15.yuv', onChanged: (value) {
                      // 尝试从文件名解析宽高和fps
                      // 例如: test2_176_144_15.yuv -> 176x144, 15fps
                      final parts = value.replaceAll('.yuv', '').split('_');
                      if (parts.length >= 3) {
                        try {
                          final width = int.tryParse(parts[parts.length - 3]);
                          final height = int.tryParse(parts[parts.length - 2]);
                          final fps = int.tryParse(parts[parts.length - 1]);
                          if (width != null)
                            widthController.text = width.toString();
                          if (height != null)
                            heightController.text = height.toString();
                          if (fps != null) fpsController.text = fps.toString();
                        } catch (e) {
                          // 忽略解析错误
                        }
                      }
                    }),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDialogTextField('宽度', widthController,
                                keyboardType: TextInputType.number)),
                        SizedBox(width: 8),
                        Expanded(
                            child: _buildDialogTextField('高度', heightController,
                                keyboardType: TextInputType.number)),
                      ],
                    ),
                    _buildDialogTextField('帧率 (FPS)', fpsController,
                        keyboardType: TextInputType.number),
                    _buildDialogTextField('格式 (0=I420)', formatController,
                        keyboardType: TextInputType.number, hint: '0: I420'),
                    _buildDialogTextField('旋转角度', rotationController,
                        keyboardType: TextInputType.number,
                        hint: '0, 90, 180, 270'),
                    SwitchListTile(
                      title: Text('循环播放'),
                      value: loop,
                      onChanged: (value) {
                        setState(() {
                          loop = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('取消')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final uid =
                            int.tryParse(uidController.text.trim()) ?? 0;
                        final layer =
                            int.tryParse(streamLayerController.text.trim()) ??
                                0;
                        final width = int.tryParse(widthController.text.trim());
                        final height =
                            int.tryParse(heightController.text.trim());
                        final fps =
                            int.tryParse(fpsController.text.trim()) ?? 30;
                        final format =
                            int.tryParse(formatController.text.trim()) ?? 0;
                        final rotation =
                            int.tryParse(rotationController.text.trim()) ?? 0;

                        if (width == null || height == null) {
                          FlutterToastr.show('请输入宽度和高度', context);
                          return;
                        }

                        final yuvFilePath = yuvFilePathController.text.trim();
                        if (yuvFilePath.isEmpty) {
                          FlutterToastr.show('请输入YUV文件路径', context);
                          return;
                        }

                        // 开始推送视频帧
                        Navigator.of(dialogContext).pop();
                        await _pushLocalRecorderVideoFrame(
                            selectedTaskId,
                            uid,
                            streamType,
                            layer,
                            yuvFilePath,
                            width,
                            height,
                            fps,
                            format,
                            rotation,
                            loop);
                      } catch (e) {
                        FlutterToastr.show('操作失败: $e', context);
                      }
                    },
                    child: Text('确认')),
              ],
            );
          });
        });
  }

  Future<void> _pushLocalRecorderVideoFrame(
      String taskId,
      int uid,
      int streamType,
      int streamLayer,
      String yuvFilePath,
      int width,
      int height,
      int fps,
      int format,
      int rotation,
      bool loop) async {
    try {
      yuvFilePath = "assets/" + yuvFilePath;
      final byteData = await rootBundle.load(yuvFilePath);
      final Uint8List yuvData = byteData.buffer.asUint8List();

      int duration = 1000 ~/ fps;
      int loopTimes = loop ? 100 : 1;

      final frameSize = width * height * 3 ~/ 2; // YUV420 每帧大小
      int position = 0;

      FlutterToastr.show('开始推送视频帧...', context);

      Future.delayed(Duration(milliseconds: 100)).then((value) async {
        while (loopTimes > 0) {
          position = 0;
          final StreamController<Uint8List> streams =
              StreamController<Uint8List>();
          Timer? timer;
          timer = Timer.periodic(Duration(milliseconds: duration), (_) {
            if (position + frameSize <= yuvData.length) {
              final frameData = yuvData.sublist(position, position + frameSize);
              streams.add(frameData);
              position += frameSize;
            } else {
              streams.close();
              timer?.cancel();
            }
          });

          loopTimes--;

          await for (final frame in streams.stream) {
            final ret = await _engine.pushLocalRecorderVideoFrameForTask(
                uid,
                streamType,
                streamLayer,
                taskId,
                NERtcVideoFrame(
                    height: height,
                    width: width,
                    rotation: rotation,
                    data: frame,
                    format: format,
                    timeStamp: DateTime.now().millisecondsSinceEpoch));
            if (ret != 0) {
              print('push failed.');
              break;
            } else {
              print('push success, width:$width, height:$height}');
            }
          }
        }
        FlutterToastr.show('推送完成', context);
      });
    } catch (e) {
      FlutterToastr.show('推送失败: $e', context);
    }
  }

  List<NERtcVideoWatermarkConfig>? _buildWatermarkConfigs(
      List<_WatermarkFormEntry> entries) {
    if (entries.isEmpty) return null;
    return entries.map((entry) => entry.toConfig()).toList();
  }

  NERtcVideoScalingModeEnum _mapScalingMode(int value) {
    switch (value) {
      case 0:
        return NERtcVideoScalingModeEnum.kNERtcVideoScaleFullFill;
      case 1:
        return NERtcVideoScalingModeEnum.kNERtcVideoScaleFit;
      case 2:
        return NERtcVideoScalingModeEnum.kNERtcVideoScaleCropFill;
      default:
        return NERtcVideoScalingModeEnum.kNERtcVideoScaleFullFill;
    }
  }

  Widget _buildWatermarkSection(
      {required String title,
      required List<_WatermarkFormEntry> entries,
      required StateSetter setState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.start),
        const SizedBox(height: 8),
        ...entries
            .asMap()
            .entries
            .map((entry) => _buildWatermarkCard(
                index: entry.key,
                formEntry: entry.value,
                entries: entries,
                setState: setState))
            .toList(),
        OutlinedButton.icon(
            onPressed: () {
              setState(() {
                entries.add(_WatermarkFormEntry());
              });
            },
            icon: Icon(Icons.add),
            label: Text('添加水印')),
      ],
    );
  }

  Widget _buildWatermarkCard(
      {required int index,
      required _WatermarkFormEntry formEntry,
      required List<_WatermarkFormEntry> entries,
      required StateSetter setState}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDropdown<NERtcVideoWatermarkType>(
                      '水印类型', formEntry.type, NERtcVideoWatermarkType.values,
                      (value) {
                    setState(() {
                      formEntry.type = value!;
                    });
                  }),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        entries.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete_outline))
              ],
            ),
            _buildDialogTextField('透明度(0~1)', formEntry.wmAlphaController,
                keyboardType: TextInputType.number),
            Row(
              children: [
                Expanded(
                    child: _buildDialogTextField(
                        '宽度(px)', formEntry.wmWidthController,
                        keyboardType: TextInputType.number)),
                SizedBox(width: 8),
                Expanded(
                    child: _buildDialogTextField(
                        '高度(px)', formEntry.wmHeightController,
                        keyboardType: TextInputType.number)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildDialogTextField(
                        'Offset X', formEntry.offsetXController,
                        keyboardType: TextInputType.number)),
                SizedBox(width: 8),
                Expanded(
                    child: _buildDialogTextField(
                        'Offset Y', formEntry.offsetYController,
                        keyboardType: TextInputType.number)),
              ],
            ),
            if (formEntry.type ==
                NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeImage) ...[
              _buildDialogTextField(
                  '图片路径(逗号分隔)', formEntry.imagePathsController),
              _buildDialogTextField('帧率', formEntry.fpsController,
                  keyboardType: TextInputType.number),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('循环播放'),
                  value: formEntry.loop,
                  onChanged: (value) {
                    setState(() {
                      formEntry.loop = value;
                    });
                  }),
            ] else ...[
              _buildDialogTextField('背景颜色(ARGB)', formEntry.wmColorController,
                  keyboardType: TextInputType.text, hint: '例如 0xFFFFFFFF'),
              Row(
                children: [
                  Expanded(
                      child: _buildDialogTextField(
                          '字体大小', formEntry.fontSizeController,
                          keyboardType: TextInputType.number)),
                  SizedBox(width: 8),
                  Expanded(
                      child: _buildDialogTextField(
                          '字体颜色(ARGB)', formEntry.fontColorController,
                          keyboardType: TextInputType.text,
                          hint: '例如 0xFF0000FF')),
                ],
              ),
              _buildDialogTextField('字体文件路径', formEntry.fontNameController),
              if (formEntry.type ==
                  NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeText)
                _buildDialogTextField('文字内容', formEntry.contentController,
                    maxLines: 2),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      String? hint,
      ValueChanged<String>? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      String label, T value, List<T> items, ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            onChanged: onChanged,
            items: items
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(_enumLabel(item as Object)),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildControlPanel6(BuildContext context) {
    List<Widget> children = [];

    // 获取屏幕捕获源列表
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
                          final sources = await _engine.desktopScreenCapture
                              .getScreenCaptureSources(
                                  NERtcSize(
                                      width:
                                          int.parse(thumbWidthController.text),
                                      height: int.parse(
                                          thumbHeightController.text)),
                                  NERtcSize(
                                      width:
                                          int.parse(iconWidthController.text),
                                      height:
                                          int.parse(iconHeightController.text)),
                                  includeScreen);

                          Navigator.of(context).pop();

                          if (sources != null) {
                            final count = sources.getCount();
                            _showSourceListDialog(sources, count);
                          } else {
                            print('获取屏幕捕获源失败');
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

    // 通过屏幕矩形开始屏幕捕获
    children.add(Expanded(
      child: buildControlButton(() {
        if (Platform.isMacOS) {
          // macOS 平台不支持屏幕矩形捕获
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
                      final result = await _engine.desktopScreenCapture
                          .startScreenCaptureByScreenRect(
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
                              ScreenCaptureParametersConfig
                                  .parameters // 使用配置的参数
                              );
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

    // 更新屏幕捕获区域
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
                      final result = await _engine.desktopScreenCapture
                          .updateScreenCaptureRegion(NERtcRectangle(
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

    // 设置鼠标光标捕获
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
                      final result = await _engine.desktopScreenCapture
                          .setScreenCaptureMouseCursor(true);
                      Navigator.of(context).pop();
                      FlutterToastr.show('显示光标结果: $result', context,
                          position: FlutterToastr.bottom);
                    },
                  ),
                  ListTile(
                    title: Text('隐藏鼠标光标'),
                    onTap: () async {
                      final result = await _engine.desktopScreenCapture
                          .setScreenCaptureMouseCursor(false);
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

    // 控制按钮：暂停、恢复、停止
    children.add(Expanded(
      child: buildControlButton(() async {
        final result = await _engine.desktopScreenCapture.pauseScreenCapture();
        FlutterToastr.show('暂停屏幕捕获结果: $result', context,
            position: FlutterToastr.bottom);
      }, Text("暂停", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() async {
        final result = await _engine.desktopScreenCapture.resumeScreenCapture();
        FlutterToastr.show('恢复屏幕捕获结果: $result', context,
            position: FlutterToastr.bottom);
      }, Text("恢复", style: TextStyle(fontSize: 10))),
    ));

    children.add(Expanded(
      child: buildControlButton(() async {
        final result = await _engine.desktopScreenCapture.stopScreenCapture();
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

// 判断是否应该显示分享按钮
  bool _shouldShowShareButton(NERtcScreenCaptureSourceType type) {
    return type == NERtcScreenCaptureSourceType.kWindow ||
        type == NERtcScreenCaptureSourceType.kScreen;
  }

// 获取分享按钮文本
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

// 获取分享按钮颜色
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

// 处理分享源的点击事件
  void _handleShareSource(NERtcScreenCaptureSourceInfo sourceInfo) {
    if (sourceInfo.type == NERtcScreenCaptureSourceType.kWindow) {
      _startScreenCaptureByWindow(sourceInfo);
    } else if (sourceInfo.type == NERtcScreenCaptureSourceType.kScreen) {
      _startScreenCaptureByDisplay(sourceInfo);
    }
  }

// 显示屏幕捕获参数配置对话框
  void _showScreenCaptureParametersDialog(
      Function(NERtcScreenCaptureParameters) onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final params = ScreenCaptureParametersConfig.parameters;

            // 控制器
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
                      // 屏幕配置文件
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

                      // 自定义尺寸 (仅在自定义模式下生效)
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

                      // 帧率设置
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

                      // 码率设置
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

                      // 编码策略倾向
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

                      // 降级偏好
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

                      // 布尔值选项
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

                      // 排除窗口列表
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

                      // 高亮边框设置 (仅在启用高亮时显示)
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
                      // 更新参数
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

                      // 解析排除窗口列表
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

                      // 保存配置
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

// 修改 _showSourceListDialog 方法
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
                    title: Text(sourceInfo.sourceTitle ?? '未知源'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('类型: ${_getSourceTypeString(sourceInfo.type)}'),
                        Text('ID: ${sourceInfo.sourceId}'),
                        if (sourceInfo.processPath?.isNotEmpty == true)
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
                        // 动态切换按钮
                        ElevatedButton(
                          onPressed: () async {
                            final result = await _engine.desktopScreenCapture
                                .setScreenCaptureSource(
                                    sourceInfo,
                                    NERtcRectangle(
                                        x: 0, y: 0, width: 1920, height: 1080),
                                    ScreenCaptureParametersConfig
                                        .parameters // 使用配置的参数
                                    );
                            Navigator.of(context).pop();
                            FlutterToastr.show('设置屏幕捕获源结果: $result', context,
                                position: FlutterToastr.bottom);
                          },
                          child: Text('动态切换'),
                        ),
                        SizedBox(width: 8),
                        // 根据源类型显示不同的分享按钮
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

// 修改 _startScreenCaptureByWindow 方法
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
          title: Text('分享窗口: ${sourceInfo.sourceTitle ?? '未知窗口'}'),
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
                  final result = await _engine.desktopScreenCapture
                      .startScreenCaptureByWindowId(
                          sourceInfo.sourceId,
                          NERtcRectangle(
                              x: int.parse(regionXController.text),
                              y: int.parse(regionYController.text),
                              width: int.parse(regionWidthController.text),
                              height: int.parse(regionHeightController.text)),
                          ScreenCaptureParametersConfig.parameters // 使用配置的参数
                          );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // 关闭源列表对话框
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

// 修改 _startScreenCaptureByDisplay 方法
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
          title: Text('分享桌面: ${sourceInfo.sourceTitle ?? '主显示器'}'),
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
                  final result = await _engine.desktopScreenCapture
                      .startScreenCaptureByDisplayId(
                          sourceInfo.sourceId,
                          NERtcRectangle(
                              x: int.parse(regionXController.text),
                              y: int.parse(regionYController.text),
                              width: int.parse(regionWidthController.text),
                              height: int.parse(regionHeightController.text)),
                          ScreenCaptureParametersConfig.parameters // 使用配置的参数
                          );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // 关闭源列表对话框
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

// 添加调试方法来检查图像数据
  void _debugImageBuffer(NERtcThumbImageBuffer imageBuffer) {
    print('=== 图像调试信息 ===');
    print('Buffer长度: ${imageBuffer.buffer.length}');
    print('声明的长度: ${imageBuffer.length}');
    print('宽度: ${imageBuffer.width}');
    print('高度: ${imageBuffer.height}');

    if (imageBuffer.buffer.length > 0) {
      // 检查前几个字节来判断格式
      final header = imageBuffer.buffer.take(10).toList();
      print('前10个字节: $header');

      // 检查是否是常见图像格式的魔数
      if (header.length >= 4) {
        // PNG: 89 50 4E 47
        if (header[0] == 0x89 &&
            header[1] == 0x50 &&
            header[2] == 0x4E &&
            header[3] == 0x47) {
          print('检测到PNG格式');
        }
        // JPEG: FF D8 FF
        else if (header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF) {
          print('检测到JPEG格式');
        }
        // BMP: 42 4D
        else if (header[0] == 0x42 && header[1] == 0x4D) {
          print('检测到BMP格式');
        } else {
          print('未知图像格式或原始像素数据');
        }
      }
    }
    print('==================');
  }

// 修改图像构建方法，添加调试和格式处理
  Widget _buildSourceImage(NERtcThumbImageBuffer imageBuffer) {
    // 添加调试信息
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

// 尝试多种方式显示图像
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

        // 如果所有方法都失败，显示错误图标
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

// 处理图像数据的异步方法
  Future<Widget> _processImageData(
      NERtcThumbImageBuffer imageBuffer, double width, double height) async {
    try {
      // 方法1: 直接作为编码图像显示
      return Image.memory(
        imageBuffer.buffer,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Image.memory 失败: $error');
          // 方法2: 尝试作为原始RGBA数据处理
          return _tryRawImageData(imageBuffer, width, height);
        },
      );
    } catch (e) {
      print('processImageData 异常: $e');
      return _tryRawImageData(imageBuffer, width, height);
    }
  }

// 尝试将数据作为原始像素数据处理
  Widget _tryRawImageData(
      NERtcThumbImageBuffer imageBuffer, double width, double height) {
    try {
      // 假设数据是RGBA格式 (4字节/像素)
      final expectedLength = imageBuffer.width * imageBuffer.height * 4;

      if (imageBuffer.buffer.length == expectedLength) {
        print('尝试RGBA原始数据显示');
        return _createImageFromRGBA(imageBuffer, width, height);
      }

      // 假设数据是RGB格式 (3字节/像素)
      final rgbLength = imageBuffer.width * imageBuffer.height * 3;
      if (imageBuffer.buffer.length == rgbLength) {
        print('尝试RGB原始数据显示');
        return _createImageFromRGB(imageBuffer, width, height);
      }

      // 假设数据是BGRA格式
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

// 从RGBA数据创建图像
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

// 转换RGBA数据为Flutter Image对象
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

// 从RGB数据创建图像（需要转换为RGBA）
  Widget _createImageFromRGB(NERtcThumbImageBuffer imageBuffer,
      double displayWidth, double displayHeight) {
    // 将RGB转换为RGBA
    final rgbaBuffer = Uint8List(imageBuffer.width * imageBuffer.height * 4);
    for (int i = 0; i < imageBuffer.width * imageBuffer.height; i++) {
      final rgbIndex = i * 3;
      final rgbaIndex = i * 4;

      rgbaBuffer[rgbaIndex] = imageBuffer.buffer[rgbIndex]; // R
      rgbaBuffer[rgbaIndex + 1] = imageBuffer.buffer[rgbIndex + 1]; // G
      rgbaBuffer[rgbaIndex + 2] = imageBuffer.buffer[rgbIndex + 2]; // B
      rgbaBuffer[rgbaIndex + 3] = 255; // A
    }

    final modifiedBuffer = NERtcThumbImageBuffer(
      buffer: rgbaBuffer,
      length: rgbaBuffer.length,
      width: imageBuffer.width,
      height: imageBuffer.height,
    );

    return _createImageFromRGBA(modifiedBuffer, displayWidth, displayHeight);
  }

// 从BGRA数据创建图像（需要转换通道顺序）
  Widget _createImageFromBGRA(NERtcThumbImageBuffer imageBuffer,
      double displayWidth, double displayHeight) {
    // 将BGRA转换为RGBA
    final rgbaBuffer = Uint8List.fromList(imageBuffer.buffer);
    for (int i = 0; i < imageBuffer.width * imageBuffer.height; i++) {
      final index = i * 4;
      final b = rgbaBuffer[index];
      final r = rgbaBuffer[index + 2];
      rgbaBuffer[index] = r; // R
      rgbaBuffer[index + 2] = b; // B
      // G和A保持不变
    }

    final modifiedBuffer = NERtcThumbImageBuffer(
      buffer: rgbaBuffer,
      length: rgbaBuffer.length,
      width: imageBuffer.width,
      height: imageBuffer.height,
    );

    return _createImageFromRGBA(modifiedBuffer, displayWidth, displayHeight);
  }

// 构建图像预览
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
              // 使用更完善的图像显示逻辑
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

// 显示全屏图像
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

// 获取源类型字符串
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

  Widget buildControlPanel5(BuildContext context) {
    List<Widget> children = [];
    children.add(Expanded(
        child: buildControlButton(() {
      final controller =
          _engine.deviceManager.getDeviceCollection(NERtcDeviceType.video);
      final count = controller?.getCount() ?? 0;
      print("count: $count");
      setState(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('视频采集设备列表'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (context, idx) {
                    final dev = controller?.getDevice(idx);
                    return ListTile(
                      title: Text(dev?.deviceName ?? '未知设备'),
                      subtitle: Text(dev?.deviceId ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final info = controller?.getDeviceInfo(idx);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('设备信息'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('设备名称: ${info?.deviceName}'),
                                      Text('设备ID: ${info?.deviceId}'),
                                      Text('设备链接类型: ${info?.transportType}'),
                                      Text(
                                          '是不是推荐设备？: ${info?.suspectedUnavailable}'),
                                      Text(
                                          '是否是系统默认设备: ${info?.systemDefaultDevice}'),
                                      Text(
                                          '是否是SDK优先选择设备: ${info?.systemPriorityDevice}'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('关闭'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text('信息'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _engine.deviceManager
                                  .setDevice(NERtcDeviceType.video,
                                      dev?.deviceId ?? '')
                                  .then((value) {
                                print("setDevice value: $value");
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('选择'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('关闭'),
                ),
              ],
            );
          },
        );
      });
    },
            Text(
              "获取视频采集设备",
              style: TextStyle(fontSize: 10),
            ))));
    children.add(Expanded(
        child: buildControlButton(() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('选择查询流类型'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('主流'),
                  onTap: () async {
                    final id = await _engine.deviceManager
                        .queryVideoDevice(NERtcVideoStreamType.main);
                    FlutterToastr.show('主流设备ID: $id', context,
                        position: FlutterToastr.bottom);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('辅流'),
                  onTap: () async {
                    final id = await _engine.deviceManager
                        .queryVideoDevice(NERtcVideoStreamType.sub);
                    FlutterToastr.show('辅流设备ID: $id', context,
                        position: FlutterToastr.bottom);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('关闭'),
              ),
            ],
          );
        },
      );
    }, Text('获取视频设备ID', style: TextStyle(fontSize: 10)))));
    children.add(Expanded(
      child: buildControlButton(() async {
        IDeviceCollection? controller =
            _engine.deviceManager.getDeviceCollection(NERtcDeviceType.audio);
        int count = controller?.getCount() ?? 0;
        setState(() {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('音频采集设备列表'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (context, idx) {
                      final dev = controller?.getDevice(idx);
                      return ListTile(
                        title: Text(dev?.deviceName ?? '未知设备'),
                        subtitle: Text(dev?.deviceId ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final info = controller?.getDeviceInfo(idx);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('设备信息'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('设备名称: ${info?.deviceName}'),
                                        Text('设备ID: ${info?.deviceId}'),
                                        Text('设备链接类型: ${info?.transportType}'),
                                        Text(
                                            '是不是推荐设备？: ${info?.suspectedUnavailable}'),
                                        Text(
                                            '是否是系统默认设备: ${info?.systemDefaultDevice}'),
                                        Text(
                                            '是否是SDK优先选择设备: ${info?.systemPriorityDevice}'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('关闭'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('信息'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _engine.deviceManager
                                    .setDevice(NERtcDeviceType.audio,
                                        dev?.deviceId ?? '')
                                    .then((value) {
                                  print("setAudioDevice value: $value");
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text('选择'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('关闭'),
                  ),
                ],
              );
            },
          );
        });
      }, Text("获取音频采集设备", style: TextStyle(fontSize: 10))),
    ));
    children.add(Expanded(
      child: buildControlButton(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('选择查询音频流类型'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('主流'),
                    onTap: () async {
                      final id = await _engine.deviceManager.queryAudioDevice(
                          NERtcAudioStreamType.kNERtcAudioStreamTypeMain);
                      FlutterToastr.show('主流音频设备ID: $id', context,
                          position: FlutterToastr.bottom);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('辅流'),
                    onTap: () async {
                      final id = await _engine.deviceManager.queryAudioDevice(
                          NERtcAudioStreamType.kNERtcAudioStreamTypeSub);
                      FlutterToastr.show('辅流音频设备ID: $id', context,
                          position: FlutterToastr.bottom);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('关闭'),
                ),
              ],
            );
          },
        );
      }, Text('获取音频采集设备ID', style: TextStyle(fontSize: 10))),
    ));
    children.add(Expanded(
      child: buildControlButton(() async {
        IDeviceCollection? controller = _engine.deviceManager
            .getDeviceCollection(NERtcDeviceType.audio,
                usage: NERtcDeviceUsage.playout);
        int count = controller?.getCount() ?? 0;
        setState(() {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('音频播放设备列表'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (context, idx) {
                      final dev = controller?.getDevice(idx);
                      return ListTile(
                        title: Text(dev?.deviceName ?? '未知设备'),
                        subtitle: Text(dev?.deviceId ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final info = controller?.getDeviceInfo(idx);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('设备信息'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('设备名称: ${info?.deviceName}'),
                                        Text('设备ID: ${info?.deviceId}'),
                                        Text('设备链接类型: ${info?.transportType}'),
                                        Text(
                                            '是不是推荐设备？: ${info?.suspectedUnavailable}'),
                                        Text(
                                            '是否是系统默认设备: ${info?.systemDefaultDevice}'),
                                        Text(
                                            '是否是SDK优先选择设备: ${info?.systemPriorityDevice}'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('关闭'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('信息'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _engine.deviceManager
                                    .setDevice(NERtcDeviceType.audio,
                                        dev?.deviceId ?? '',
                                        usage: NERtcDeviceUsage.playout)
                                    .then((value) {
                                  print("setPlayoutDevice value: $value");
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text('选择'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('关闭'),
                  ),
                ],
              );
            },
          );
        });
      }, Text("获取音频播放设备", style: TextStyle(fontSize: 10))),
    ));
    children.add(Expanded(
      child: buildControlButton(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('选择查询音频播放流类型'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('主流'),
                    onTap: () async {
                      final id = await _engine.deviceManager.queryAudioDevice(
                          NERtcAudioStreamType.kNERtcAudioStreamTypeMain,
                          usage: NERtcDeviceUsage.playout);
                      FlutterToastr.show('主流音频播放设备ID: $id', context,
                          position: FlutterToastr.bottom);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('辅流'),
                    onTap: () async {
                      final id = await _engine.deviceManager.queryAudioDevice(
                          NERtcAudioStreamType.kNERtcAudioStreamTypeSub,
                          usage: NERtcDeviceUsage.playout);
                      FlutterToastr.show('辅流音频播放设备ID: $id', context,
                          position: FlutterToastr.bottom);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('关闭'),
                ),
              ],
            );
          },
        );
      }, Text('获取音频播放设备ID', style: TextStyle(fontSize: 10))),
    ));
    return Container(
        height: 40,
        child: Row(
          children: children,
        ));
  }

  Widget buildControlPanel4(BuildContext context) {
    List<Widget> children = [];
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool muteAudio = !isMuteAudio;
        _engine.muteLocalAudioStream(muteAudio).then((value) {
          if (value == 0) {
            setState(() {
              isMuteAudio = muteAudio;
            });
          }
        });
      },
      Text(
        isMuteAudio ? '取消静音' : '静音',
        style: TextStyle(fontSize: 10),
      ),
    )));
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool muteVideo = !isMuteVideo;
        _engine.muteLocalVideoStream(muteVideo).then((value) {
          if (value == 0) {
            setState(() {
              isMuteVideo = muteVideo;
            });
          }
        });
      },
      Text(
        isMuteVideo ? 'UnMuteVideo' : 'MuteVideo',
        style: TextStyle(fontSize: 10),
      ),
    )));
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool muteMic = !isMuteMic;
        _engine.deviceManager.setRecordDeviceMute(muteMic).then((value) {
          if (value == 0) {
            setState(() {
              isMuteMic = muteMic;
            });
          }
        });
      },
      Text(
        isMuteMic ? 'UnMuteMic' : 'MuteMic',
        style: TextStyle(fontSize: 10),
      ),
    )));
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool muteSpeaker = !isMuteSpeaker;
        _engine.deviceManager.setPlayoutDeviceMute(muteSpeaker).then((value) {
          if (value == 0) {
            setState(() {
              isMuteSpeaker = muteSpeaker;
            });
          }
        });
      },
      Text(
        isMuteSpeaker ? 'UnMuteSpeaker' : 'MuteSpeaker',
        style: TextStyle(fontSize: 10),
      ),
    )));
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool subAllAudio = !isSubAllAudio;
        _engine.subscribeAllRemoteAudio(subAllAudio).then((value) {
          if (value == 0) {
            setState(() {
              isSubAllAudio = subAllAudio;
            });
          }
        });
      },
      Text(
        isSubAllAudio ? 'UnSubAllA' : 'SubAllA',
        style: TextStyle(fontSize: 10),
      ),
    )));
    return Container(
        height: 40,
        child: Row(
          children: children,
        ));
  }

  Widget buildControlPanel3(BuildContext context) {
    List<Widget> children = [];
    if (Platform.isIOS) {
      children.add(Expanded(
          child: buildControlButton(
        () {
          _requestPop();
        },
        Text(
          '结束通话',
          style: TextStyle(fontSize: 12),
        ),
      )));
    }
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool leaveChannel = !isLeaveChannel;
        if (leaveChannel) {
          _engine.leaveChannel().then((value) {
            if (value == 0) {
              streamController.close();
              setState(() {
                _localSession = null;
                isLeaveChannel = leaveChannel;
              });
            }
          });
        } else {
          _initCallbacks()
              .then((value) => _initAudio())
              .then((value) => _initVideo())
              .then((value) => _initRenderer())
              .then((value) => _engine.joinChannel('', widget.cid, widget.uid))
              .then((value) {
            if (value == 0) {
              setState(() {
                isLeaveChannel = leaveChannel;
              });
            }
          });
        }
      },
      Text(
        isLeaveChannel ? '加入房间' : '离开房间',
        style: TextStyle(fontSize: 12),
      ),
    )));
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool audience = !isAudience;
        _engine
            .setClientRole(
                audience ? NERtcUserRole.audience : NERtcUserRole.broadcaster)
            .then((value) {
          if (value == 0) {
            setState(() {
              isAudience = audience;
            });
          }
        });
      },
      Text(
        isAudience ? '切主播' : '切观众',
        style: TextStyle(fontSize: 12),
      ),
    )));

    children.add(Expanded(
        child: buildControlButton(
      () {
        bool playAudioMixing = !isAudioMixPlaying;
        if (playAudioMixing) {
          String path = _settings.audioMixingFileUrl.isNotEmpty
              ? _settings.audioMixingFileUrl
              : _settings.audioEffectFilePath;
          NERtcAudioMixingOptions options = NERtcAudioMixingOptions(
              path: path,
              sendEnabled: _settings.audioMixingSendEnabled,
              playbackEnabled: _settings.audioMixingPlayEnabled);
          _engine.audioMixingManager.startAudioMixing(options).then((value) {
            if (value == 0) {
              setState(() {
                isAudioMixPlaying = playAudioMixing;
              });
            }
          });
        } else {
          _engine.audioMixingManager.stopAudioMixing().then((value) {
            if (value == 0) {
              setState(() {
                isAudioMixPlaying = playAudioMixing;
              });
            }
          });
        }
      },
      Text(
        isAudioMixPlaying ? '结束伴音' : '开始伴音',
        style: TextStyle(fontSize: 12),
      ),
    )));
    if (Platform.isAndroid) {
      children.add(Expanded(
          child: buildControlButton(
        () {
          bool playAudioEffect = !isAudioEffectPlaying;
          if (playAudioEffect) {
            NERtcAudioEffectOptions options = NERtcAudioEffectOptions(
              path: Settings.defaultFileUrl,
              sendEnabled: _settings.audioEffectSendEnabled,
              playbackEnabled: _settings.audioEffectPlayEnabled,
            );
            _engine.audioEffectManager.playEffect(1, options).then((value) {
              if (value == 0) {
                setState(() {
                  isAudioEffectPlaying = playAudioEffect;
                });
              }
            });
          } else {
            _engine.audioEffectManager.stopEffect(1).then((value) {
              if (value == 0) {
                setState(() {
                  isAudioEffectPlaying = playAudioEffect;
                });
              }
            });
          }
        },
        Text(
          isAudioEffectPlaying ? '结束音效' : '开始音效',
          style: TextStyle(fontSize: 12),
        ),
      )));
    }
    return Container(
        height: 40,
        child: Row(
          children: children,
        ));
  }

  Widget buildControlPanel1(BuildContext context) {
    return Container(
        height: 40,
        child: Row(
          children: [
            Expanded(
                child: buildControlButton(
              () {
                _engine.getConnectionState().then((value) {
                  print("getConnectionState: $value");
                });

                bool audioEnabled = !isAudioEnabled;
                _engine.enableLocalAudio(audioEnabled).then((value) {
                  if (value == 0) {
                    setState(() {
                      isAudioEnabled = audioEnabled;
                    });
                  }
                });
                _engine.enableMediaPub(0, audioEnabled);
              },
              Text(
                isAudioEnabled ? '关闭语音' : '打开语音',
                style: TextStyle(fontSize: 12),
              ),
            )),
            Expanded(
                child: buildControlButton(
              () {
                bool videoEnabled = !isVideoEnabled;
                _engine.enableLocalVideo(videoEnabled).then((value) {
                  if (value == 0) {
                    setState(() {
                      isVideoEnabled = videoEnabled;
                    });
                  }
                });
              },
              Text(
                isVideoEnabled ? '关闭视频' : '打开视频',
                style: TextStyle(fontSize: 12),
              ),
            )),
            Expanded(
                child: buildControlButton(
              () {
                _engine.deviceManager.switchCamera().then((value) {
                  if (value == 0) {
                    isFrontCamera = !isFrontCamera;
                    updateLocalMirror();
                  }
                });
              },
              Text(
                '切换摄像头',
                style: TextStyle(fontSize: 12),
              ),
            )),
            Expanded(
                child: buildControlButton(
              () {
                bool speakerphoneOn = !isSpeakerphoneOn;
                _engine.deviceManager
                    .setSpeakerphoneOn(speakerphoneOn)
                    .then((value) {
                  if (value == 0) {
                    setState(() {
                      isSpeakerphoneOn = speakerphoneOn;
                    });
                  }
                });
              },
              Text(
                isSpeakerphoneOn ? '关闭扬声器' : '打开扬声器',
                style: TextStyle(fontSize: 12),
              ),
            )),
            // Expanded(
            //     child: buildControlButton(
            //           () {
            //             // NERtcVideoWatermarkConfig config = NERtcVideoWatermarkConfig(WatermarkType: NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeText);
            //             // config.textWatermark = NERtcVideoWatermarkTextConfig(content: "Test");
            //             // config.textWatermark?.wmAlpha = 0.8;
            //             // config.textWatermark?.wmWidth = 100;
            //             // config.textWatermark?.wmHeight = 100;
            //             // config.textWatermark?.offsetX = 0;
            //             // config.textWatermark?.offsetY = 0;
            //             // config.textWatermark?.wmColor = 42782250;
            //             // config.textWatermark?.fontSize = 10;
            //             // config.textWatermark?.fontColor = 42781900;
            //             // config.textWatermark?.fontNameOrPath = "test_watermark_text_context";
            //             // _engine.setLocalVideoWatermarkConfigs(0, config);
            //             NERtcAudioRecordingConfiguration config = NERtcAudioRecordingConfiguration(filePath: "99.9999");
            //             config.cycleTime = null;
            //             config.quality = null;
            //             config.position = null;
            //             config.sampleRate = null;
            //             _engine.startAudioRecordingWithConfig(config);
            //       },
            //       Text(
            //         'Test',
            //         style: TextStyle(fontSize: 12),
            //       ),
            // )),
          ],
        ));
  }

  Widget buildControlPanel2(BuildContext context) {
    List<Widget> children = [];
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool audioDumpEnabled = !isAudioDumpEnabled;
        if (audioDumpEnabled) {
          _engine.startAudioDump().then((value) {
            if (value == 0) {
              setState(() {
                isAudioDumpEnabled = audioDumpEnabled;
              });
            }
          });
        } else {
          _engine.stopAudioDump().then((value) {
            if (value == 0) {
              setState(() {
                isAudioDumpEnabled = audioDumpEnabled;
              });
            }
          });
        }
      },
      Text(
        isAudioDumpEnabled ? '录音关' : '录音开',
        style: TextStyle(fontSize: 12),
      ),
    )));
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool earBackEnabled = !isEarBackEnabled;
        _engine.deviceManager.enableEarback(earBackEnabled, 100).then((value) {
          if (value == 0) {
            setState(() {
              isEarBackEnabled = earBackEnabled;
            });
          }
        });
      },
      Text(
        isEarBackEnabled ? '耳返开' : '耳返关',
        style: TextStyle(fontSize: 12),
      ),
    )));
    // if (Platform.isAndroid) {
    children.add(Expanded(
        child: buildControlButton(
      () {
        bool screenRecordEnabled = !isScreenRecordEnabled;
        if (screenRecordEnabled) {
          NERtcScreenConfig config = NERtcScreenConfig();
          config.contentPrefer = _settings.screenContentPrefer;
          config.videoProfile = _settings.screenProfile;
          config.frameRate = _settings.screenFrameRate;
          config.minFrameRate = _settings.screenMinFrameRate;
          config.bitrate = _settings.screenBitRate;
          config.minBitrate = _settings.screenMinBitRate;
          _engine.startScreenCapture(config).then((value) {
            if (value == 0) {
              setState(() {
                isScreenRecordEnabled = screenRecordEnabled;
                _localSubStreamSession = _UserSession(widget.uid, true);
              });
            } else if (value == -1) {
              FlutterToastr.show("当前 iOS 系统版本不支持！", context,
                  position: FlutterToastr.bottom);
            } else if (value == -2) {
              FlutterToastr.show("请跳转控制中心长按屏幕录制！", context,
                  position: FlutterToastr.bottom);
            } else {
              FlutterToastr.show(
                  "startScreenCapture failed, err:$value", context,
                  position: FlutterToastr.bottom);
            }
          });
        } else {
          _engine.stopScreenCapture().then((value) {
            if (value == 0) {
              setState(() {
                isScreenRecordEnabled = screenRecordEnabled;
                _localSubStreamSession = null;
              });
            }
          });
        }
      },
      Text(
        isScreenRecordEnabled ? '屏幕录制关' : '屏幕录制开',
        style: TextStyle(fontSize: 12),
      ),
    )));
    // }
    children.add(Expanded(
        child: buildControlButton(
      () {
        _engine.uploadSdkInfo().then((value) {
          FlutterToastr.show("upload sdk info result:$value", context,
              position: FlutterToastr.bottom);
        });
      },
      Text(
        '上传日志',
        style: TextStyle(fontSize: 12),
      ),
    )));
    return Container(
        height: 40,
        child: Row(
          children: children,
        ));
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

  void _requestPop() {
    Navigator.pop(context);
  }

  void _initRtcEngine() async {
    NERtcParameters parameters = new NERtcParameters();
    if (Platform.isAndroid) {
      parameters.setParameter(NERtcParameterKey<bool>('key_test_server_uri'),
          _settings.openTestEnvironment);
    } else if (Platform.isIOS) {
      parameters.setParameter(
          NERtcParameterKey<bool>('nertc.engine.debug.setting.enabled'),
          _settings.openTestEnvironment);
    } else if (Platform.isMacOS || Platform.isWindows) {
      parameters.setParameter(
          NERtcParameterKey<bool>('sdk.enable.debug.environment'),
          _settings.openTestEnvironment);
    }

    parameters.setParameter(
        NERtcParameterKey<bool>('sdk.enable.encrypt.log'), false);
    await _engine.setParameters(parameters);

    final logDir = await getLogPath('Logs');
    print('+++ logDir: $logDir +++');
    if (Platform.isMacOS) {
      NativeLogHelper.log('+++ logDir: $logDir +++');
    }

    NERtcOptions options = NERtcOptions(
        logDir: await getLogPath('Logs'),
        logLevel: NERtcLogLevel.info,
        audioAutoSubscribe: _settings.autoSubscribeAudio,
        videoAutoSubscribe: _settings.autoSubscribeVideo,
        disableFirstJoinUserCreateChannel:
            _settings.disableFirstJoinUserCreateChannel,
        serverRecordSpeaker: _settings.serverRecordSpeaker,
        serverRecordAudio: _settings.serverRecordAudio,
        serverRecordVideo: _settings.serverRecordVideo,
        serverRecordMode:
            NERtcServerRecordMode.values[_settings.serverRecordMode],
        videoSendMode: NERtcVideoSendMode.values[_settings.videoSendMode],
        videoEncodeMode:
            NERtcMediaCodecMode.values[_settings.videoEncodeMediaCodecMode],
        videoDecodeMode:
            NERtcMediaCodecMode.values[_settings.videoDecodeMediaCodecMode],
        appGroup: "group.com.netease.nertcflutter.Example");

    String appKey =
        _settings.openTestEnvironment ? Config.DEBUG_APP_KEY : Config.APP_KEY;

    if (Platform.isMacOS) {
      NativeLogHelper.log(
          '_settings.openTestEnvironment:${_settings.openTestEnvironment}, appKey:$appKey');
    }

    _engine
        .create(appKey: appKey, channelEventCallback: this, options: options)
        .then((value) => _initCallbacks())
        .then((value) => _initAudio())
        .then((value) => _initVideo())
        .then((value) => _initRenderer())
        .then((value) => _setVideoRotationMode())
        .then((value) => _engine.joinChannel('', widget.cid, widget.uid))
        .catchError((e) {
      FlutterToastr.show("catchError:' + e.toString()", context,
          position: FlutterToastr.bottom);
      return -1;
    });
  }

  Future<int?> _initCallbacks() async {
    _engine.setStatsEventCallback(this);
    _engine.audioMixingManager.setEventCallback(this);
    _engine.audioEffectManager.setEventCallback(this);
    _engine.deviceManager.setEventCallback(this);
    _engine.setLiveTaskEventCallback(this);
    _engine.setEventCallback(this);
    return 0;
  }

  Future<int?> _initAudio() async {
    if (Platform.isIOS) {
      await _engine.setAudioSessionOperationRestriction(
          NERtcAudioSessionOperationRestriction
              .values[_settings.audioSessionRestriction]);
    }
    await _engine.setAudioProfile(
        NERtcAudioProfile.values[_settings.audioProfile],
        NERtcAudioScenario.values[_settings.audioScenario]);
    await _engine.enableAudioVolumeIndication(true, 1000);
    return _engine.enableLocalAudio(isAudioEnabled);
  }

  Future<int?> _initVideo() async {
    await _engine.enableLocalVideo(isVideoEnabled);
    await _engine.enableDualStreamMode(_settings.enableDualStreamMode);
    NERtcVideoConfig config = NERtcVideoConfig.empty();
    config.videoProfile = _settings.videoProfile;
    config.frameRate = _settings.videoFrameRate;
    config.degradationPrefer = _settings.degradationPreference;
    config.videoCropMode = _settings.videoCropMode;
    return _engine.setLocalVideoConfig(config);
  }

  Future<void> _setVideoRotationMode() async {
    if (_settings.forceLandScapeMode) {
      int reply = await _engine.setVideoRotationMode(
          NERtcVideoRotationMode.NERtcVideoRotationModeByApp);
      print('setVideoRotationMode reply:$reply');
    }
  }

  Future<void> _initRenderer() async {
    setState(() {
      _localSession = _UserSession(widget.uid);
      updateLocalMirror();
    });
  }

  void _releaseRtcEngine() {
    _engine.release();
  }

  void _leaveChannel() async {
    await _engine.enableLocalVideo(false);
    await _engine.enableLocalAudio(false);
    await _engine.stopVideoPreview();
    _engine.removeStatsEventCallback(this);
    _localSession = null;
    _localSubStreamSession = null;
    _remoteSessions.clear();
    await _engine.leaveChannel();
  }

  @override
  void dispose() {
    if (_settings.forceLandScapeMode) {
      // 恢复默认屏幕方向
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    _leaveChannel();
    _releaseRtcEngine();
    if (Platform.isAndroid) {
      foregroundServiceChannel.invokeMethod('cancelForegroundService');
    }
    super.dispose();
  }

  @override
  void onAddLiveStreamTask(String taskId, int errCode) {
    FlutterToastr.show(
        "onAddLiveStreamTask#$taskId ,errorCode:$errCode}", context,
        position: FlutterToastr.bottom);
  }

  @override
  void onConnectionTypeChanged(int newConnectionType) {
    FlutterToastr.show(
        'onConnectionTypeChanged#${Utils.connectionType2String(newConnectionType)}',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onDisconnect(int reason) {
    FlutterToastr.show('onDisconnect#$reason', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onFirstAudioDataReceived(int uid) {
    FlutterToastr.show('onFirstAudioDataReceived#$uid', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onFirstVideoDataReceived(int uid, int? streamType) {
    FlutterToastr.show(
        'onFirstVideoDataReceived#$uid,streamType:$streamType', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onLeaveChannel(int result) {
    FlutterToastr.show('onLeaveChannel#$result', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    FlutterToastr.show('onUserAudioStart#uid:$uid, muted:$muted', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserAudioStart(int uid) {
    FlutterToastr.show('onUserAudioStart#$uid', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserAudioStop(int uid) {
    FlutterToastr.show('onUserAudioStop#$uid', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserLeave(
      int uid, int reason, NERtcUserLeaveExtraInfo? leaveExtraInfo) {
    FlutterToastr.show(
        'onUserLeave#uid:$uid, reason:$reason,leaveExtraInfo:$leaveExtraInfo',
        context,
        position: FlutterToastr.bottom);
    for (_UserSession session in _remoteSessions.toList()) {
      if (session.uid == uid) {
        _remoteSessions.remove(session);
      }
    }
    setState(() {});
  }

  @override
  void onUserVideoMute(int uid, bool muted, int? streamType) {
    FlutterToastr.show(
        'onUserVideoProfileUpdate#uid:$uid, muted:$muted,streamType:$streamType',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    FlutterToastr.show(
        'onUserVideoStart#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
        context,
        position: FlutterToastr.bottom);
    setupVideoView(uid, maxProfile, false);
  }

  Future<void> setupVideoView(int uid, int maxProfile, bool subStream) async {
    final session = _UserSession(uid, subStream);
    _remoteSessions.add(session);
    if (forceSubAndUnsubVideo || !_settings.autoSubscribeVideo) {
      if (subStream) {
        _engine.subscribeRemoteSubStreamVideo(uid, true);
      } else {
        _engine.subscribeRemoteVideoStream(
            uid, NERtcRemoteVideoStreamType.high, true);
      }
    }
    setState(() {});
  }

  Future<void> releaseVideoView(int uid, bool subStream) async {
    for (_UserSession session in _remoteSessions.toList()) {
      if (session.uid == uid && subStream == session.subStream) {
        _remoteSessions.remove(session);
        if (forceSubAndUnsubVideo || !_settings.autoSubscribeVideo) {
          if (!subStream) {
            _engine.subscribeRemoteVideoStream(
                uid, NERtcRemoteVideoStreamType.high, false);
          } else {
            _engine.subscribeRemoteSubStreamVideo(uid, false);
          }
        }
        setState(() {});
        break;
      }
    }
  }

  @override
  void onUserVideoStop(int uid) {
    FlutterToastr.show('onUserVideoStop#$uid', context,
        position: FlutterToastr.bottom);
    releaseVideoView(uid, false);
  }

  @override
  void onJoinChannel(int result, int channelId, int elapsed, int uid) {
    FlutterToastr.show(
        'onJoinChannel#$uid,channelId:$channelId,result:$result,elapsed:$elapsed',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onReleasedHwResources(int result) {
    // TODO: implement onReleasedHwResources
    super.onReleasedHwResources(result);
    print('onReleasedHwResources: $result');
  }

  @override
  void onAiData(String type, String data) {
    // TODO: implement onAiData
    super.onAiData(type, data);
    print('type: $type, data:$data');
  }

  @override
  void onTakeSnapshotResult(int code, String path) {
    // TODO: implement onTakeSnapshotResult
    super.onTakeSnapshotResult(code, path);
  }

  @override
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList) {
    _remoteVideoStatsCount++;
    if (_remoteVideoStatsCount % 10 == 0) {
      FlutterToastr.show('onRemoteVideoStats#$statsList', context,
          position: FlutterToastr.bottom);
    }
  }

  @override
  void onLocalVideoStats(NERtcVideoSendStats stats) {
    _localVideoStatsCount++;
    if (_localVideoStatsCount % 10 == 0) {
      FlutterToastr.show('onLocalVideoStats#$stats', context,
          position: FlutterToastr.bottom);
    }
  }

  @override
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList) {
    _remoteAudioStatsCount++;
    if (_remoteAudioStatsCount % 10 == 0) {
      FlutterToastr.show('onRemoteAudioStats#$statsList', context,
          position: FlutterToastr.bottom);
    }
    print('onRemoteAudioStats#$statsList');
  }

  @override
  void onLocalAudioStats(NERtcAudioSendStats stats) {
    _localAudioStatsCount++;
    if (_localAudioStatsCount % 10 == 0) {
      FlutterToastr.show('onLocalAudioStats#$stats', context,
          position: FlutterToastr.bottom);
    }
    print('onLocalAudioStats#$stats');
  }

  @override
  void onRtcStats(NERtcStats stats) {
    _rtcStatsCount++;
    if (_rtcStatsCount % 10 == 0) {
      FlutterToastr.show('onRtcStats#$stats', context,
          position: FlutterToastr.bottom);
    }
  }

  @override
  void onReJoinChannel(int result, int channelId) {
    FlutterToastr.show('onReJoinChannel#$result,channelId:$channelId', context,
        position: FlutterToastr.bottom);
  }

  void onError(int code) {
    FlutterToastr.show('onError#$code', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onFirstAudioFrameDecoded(int uid) {
    FlutterToastr.show('onFirstAudioFrameDecoded#$uid', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onFirstVideoFrameDecoded(
      int uid, int width, int height, int? streamType) {
    FlutterToastr.show(
        'onFirstVideoFrameDecoded#uid:$uid, width:$width, height:$height',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onLocalAudioVolumeIndication(int volume, bool vadFlag) {
    FlutterToastr.show(
        'onLocalAudioVolumeIndication#$volume,vadFlag:$vadFlag', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {
    FlutterToastr.show(
        'onRemoteAudioVolumeIndication#$totalVolume,volumeList:$volumeList',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onWarning(int code) {
    FlutterToastr.show('onWarning#$code', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {
    // Fluttertoast.showToast(
    //     msg: 'onNetworkQuality:$statsList', gravity: ToastGravity.CENTER);
  }

  @override
  void onReconnectingStart() {
    FlutterToastr.show('onReconnectingStart', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onConnectionStateChanged(int state, int reason) {
    FlutterToastr.show(
        'onConnectionStateChanged#state:${Utils.connectionState2String(state)}, reason:${Utils.connectionStateChangeReason2String(reason)}',
        context,
        position: FlutterToastr.bottom);
    switch (reason) {
      case NERtcConnectionStateChangeReason.leaveChannel:
        // 离开房间 ，通话已经结束了。建议优先关注 onLeaveChannel 回调
        break;

      case NERtcConnectionStateChangeReason.channelClosed:
        // 房间被关闭，通话已经结束了。建议优先关注onDisconnect 回调（code为NERtcConstants.ErrorCode.ENGINE_ERROR_ROOM_CLOSED）
        break;

      case NERtcConnectionStateChangeReason.serverKicked:
        // 被踢出房间，通话已经结束了。建议优先关注onDisconnect 回调（code为NERtcConstants.ErrorCode.ENGINE_ERROR_SERVER_KICKED）
        break;

      case NERtcConnectionStateChangeReason.timeout:
        // 网络超时，通话已经结束了。或关注onDisconnect 回调即可（其他code）
        break;

      case NERtcConnectionStateChangeReason.joinChannel:
        //开始加入房间
        break;

      case NERtcConnectionStateChangeReason.joinSucceed:
        //加入房间成功，与服务器成功建立连接。建议优先关注 onJoinChannel 回调即可
        break;

      case NERtcConnectionStateChangeReason.rejoinSucceed:
        // 重连成功，指在网络变化或超时后的重连成功通知
        break;

      case NERtcConnectionStateChangeReason.signalDisconnected:
        // 网络超时，指与媒体服务器暂时失去连接，后续SDK 内部会自动重连
        break;

      case NERtcConnectionStateChangeReason.mediaConnectionDisconnected:
        // 网络超时，指与信令服务器暂时失去连接，后续SDK 内部会自动重连
        break;

      case NERtcConnectionStateChangeReason.requestChannelFailed:
        //加入房间获取房间信息这一步就失败。建议优先关注 onJoinChannel 回调即可
        break;

      case NERtcConnectionStateChangeReason.joinChannelFailed:
        //加入房间时与服务器建立长连失败。建议优先关注 onJoinChannel 回调即可
        break;
    }
  }

  @override
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {
    FlutterToastr.show(
        'onLiveStreamState#taskId:$taskId, liveState:${Utils.liveStreamState2String(liveState)}',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onAudioDeviceChanged(int selected) {
    String audioDevice;
    switch (selected) {
      case NERtcAudioDevice.earpiece:
        audioDevice = "听筒";
        break;
      case NERtcAudioDevice.bluetoothHeadset:
        audioDevice = "蓝牙耳机";
        break;
      case NERtcAudioDevice.speakerPhone:
        audioDevice = "扬声器";
        break;
      case NERtcAudioDevice.wiredHeadset:
        audioDevice = "有线耳机";
        break;
      default:
        audioDevice = "EARPIECE";
        break;
    }
    print('onAudioDeviceChanged:$audioDevice');
  }

  @override
  void onAudioDeviceStateChange(int deviceType, int deviceState) {
    FlutterToastr.show(
        'onAudioDeviceStateChange#deviceType:${Utils.audioDeviceType2String(deviceType)}, deviceState:${Utils.audioDeviceState2String(deviceState)}',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onVideoDeviceStateChange(int deviceType, int deviceState) {
    FlutterToastr.show(
        'onVideoDeviceStateChange#${Utils.videoDeviceState2String(deviceState)}',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onCameraExposureChanged(CGPoint exposurePoint) {
    //  Fluttertoast.showToast(
    //     msg: 'onCameraExposureChanged#$exposurePoint',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onCameraFocusChanged(CGPoint focusPoint) {
    FlutterToastr.show('onCameraFocusChanged#$focusPoint', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onClientRoleChange(int oldRole, int newRole) {
    FlutterToastr.show(
        'onClientRoleChange#oldRole:$oldRole, newRole:$newRole', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserSubStreamVideoStart(int uid, int maxProfile) {
    FlutterToastr.show(
        'onUserSubStreamVideoStart#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
        context,
        position: FlutterToastr.bottom);
    print(
        'onUserSubStreamVideoStart#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}');
    setupVideoView(uid, maxProfile, true);
  }

  @override
  void onUserSubStreamVideoStop(int uid) {
    FlutterToastr.show('onUserSubStreamVideoStop#$uid', context,
        position: FlutterToastr.bottom);
    releaseVideoView(uid, true);
  }

  @override
  void onAudioHasHowling() {
    FlutterToastr.show('onAudioHasHowling', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onRecvSEIMsg(int userID, String seiMsg) {
    FlutterToastr.show('onReceiveSEIMsg:userID:$userID,seiMsg:$seiMsg', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onAudioRecording(int code, String filePath) {
    FlutterToastr.show('onReceiveSEIMsg:code:$code,filePath:$filePath', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onMediaRelayReceiveEvent(int event, int code, String channelName) {}
  @override
  void onMediaRelayStatesChange(int state, String channelName) {}
  @override
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {}
  @override
  void onRemoteSubscribeFallbackToAudioOnly(
      int uid, bool isFallback, int streamType) {}
  @override
  void onAudioEffectFinished(int effectId) {
    FlutterToastr.show('onAudioEffectFinished#$effectId', context,
        position: FlutterToastr.bottom);
    setState(() {
      isAudioEffectPlaying = false;
    });
  }

  @override
  void onAudioMixingStateChanged(int reason) {
    FlutterToastr.show('onAudioMixingStateChanged#$reason', context,
        position: FlutterToastr.bottom);
    setState(() {
      isAudioMixPlaying = false;
    });
  }

  @override
  void onAudioMixingTimestampUpdate(int timestampMs) {}
  @override
  void onUserSubStreamAudioMute(int uid, bool muted) {
    FlutterToastr.show('onUserSubStreamAudioMute#$uid $muted', context,
        position: FlutterToastr.bottom);
    setState(() {
      //...
    });
  }

  @override
  void onUserSubStreamAudioStart(int uid) {
    FlutterToastr.show('onUserSubStreamAudioStart#$uid ', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserSubStreamAudioStop(int uid) {
    FlutterToastr.show('onUserSubStreamAudioStop#$uid ', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onVirtualBackgroundSourceEnabled(bool enabled, int reason) {
    FlutterToastr.show(
        'onVirtualBackgroundSourceEnabled#$enabled, reason:$reason ', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onAudioEffectTimestampUpdate(int id, int timestampMs) {
    FlutterToastr.show(
        'onAudioEffectTimestampUpdate#$id, timestampMs:$timestampMs', context,
        position: FlutterToastr.bottom);
  }

  @override
  void onLocalVideoWatermarkState(int videoStreamType, int state) {
    FlutterToastr.show(
        'onLocalVideoWatermarkState#$state, videoStreamType:$videoStreamType',
        context,
        position: FlutterToastr.bottom);
  }

  @override
  void onUserJoined(int uid, NERtcUserJoinExtraInfo? joinExtraInfo) {
    FlutterToastr.show('onUserJoined#$uid ,$joinExtraInfo', context,
        position: FlutterToastr.bottom);
    setState(() {});
  }

  @override
  void onFirstFrameRendered(int uid) {
    logger.i(
      'onFirstFrameRendered#uid:$uid',
    );
  }

  @override
  void onFrameResolutionChanged(int uid, int width, int height, int rotation) {
    logger.i(
        'onFrameResolutionChanged#uid:$uid, width:$width, height:$height, rotation:$rotation');
  }

  @override
  void onUserDataStart(int uid) {
    logger.i('onUserDataStart#uid:$uid');
  }

  @override
  void onUserDataStop(int uid) {
    logger.i('onUserDataStop#uid$uid');
  }

  @override
  void onUserDataReceiveMessage(int uid, Uint8List bufferData, int bufferSize) {
    logger.i(
        'onUserDataReceiveMessage#uid$uid, bufferData:${bufferData.toString()}, bufferSize:$bufferSize');
  }

  @override
  void onUserDataStateChanged(int uid) {
    logger.i('onUserDataStateChanged#uid:$uid');
  }

  @override
  void onUserDataBufferedAmountChanged(int uid, int previousAmount) {
    logger.i(
        'onUserDataBufferedAmountChanged#uid:$uid, previousAmount:$previousAmount');
  }

  @override
  void onLocalRecorderStatus(int status, String taskId) {
    logger.i('onLocalRecorderStatus#status:$status, taskId:$taskId');
  }

  @override
  void onLocalRecorderError(int error, String taskId) {
    logger.i('onLocalRecorderError#error:$error, taskId:$taskId');
  }

  @override
  void onCheckNECastAudioDriverResult(int result) {
    logger.i('onCheckNECastAudioDriverResult#result:$result');
    FlutterToastr.show('onCheckNECastAudioDriverResult#$result', context);
  }

  @override
  void onScreenCaptureStatus(int status) {
    FlutterToastr.show('onScreenCaptureStatus#$status', context);
    print('onScreenCaptureStatus#status:$status');
  }

  @override
  void onScreenCaptureSourceDataUpdate(NERtcScreenCaptureSourceData data) {
    FlutterToastr.show('onScreenCaptureSourceDataUpdate#$data', context);
    print('onScreenCaptureSourceDataUpdate#data:$data');
  }

  @override
  void onRemoteVideoSizeChanged(
      int userId, int videoType, int width, int height) {
    print(
        'onRemoteVideoSizeChanged#userId:$userId, videoType:$videoType, width:$width, height:$height');
  }
}

class _StreamInfoFormEntry {
  final TextEditingController uidController = TextEditingController(text: '0');
  final TextEditingController streamTypeController =
      TextEditingController(text: '0');
  final TextEditingController streamLayerController =
      TextEditingController(text: '0');
  final TextEditingController offsetXController =
      TextEditingController(text: '0');
  final TextEditingController offsetYController =
      TextEditingController(text: '0');
  final TextEditingController widthController =
      TextEditingController(text: '640');
  final TextEditingController heightController =
      TextEditingController(text: '360');
  final TextEditingController scalingModeController =
      TextEditingController(text: '0');
  final TextEditingController isScreenShareController =
      TextEditingController(text: '0');
  final TextEditingController bgColorController =
      TextEditingController(text: '0xFF000000');
  final List<_WatermarkFormEntry> watermarkEntries = [];
}

class _WatermarkFormEntry {
  NERtcVideoWatermarkType type;
  final TextEditingController wmAlphaController =
      TextEditingController(text: '1.0');
  final TextEditingController wmWidthController =
      TextEditingController(text: '0');
  final TextEditingController wmHeightController =
      TextEditingController(text: '0');
  final TextEditingController offsetXController =
      TextEditingController(text: '0');
  final TextEditingController offsetYController =
      TextEditingController(text: '0');

  // Image specific
  final TextEditingController imagePathsController =
      TextEditingController(text: '/tmp/watermark.png');
  final TextEditingController fpsController = TextEditingController(text: '0');
  bool loop = true;

  // Text/Timestamp specific
  final TextEditingController wmColorController =
      TextEditingController(text: '0x88888888');
  final TextEditingController fontSizeController =
      TextEditingController(text: '15');
  final TextEditingController fontColorController =
      TextEditingController(text: '0xFFFFFFFF');
  final TextEditingController fontNameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  _WatermarkFormEntry()
      : type = NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeImage;

  NERtcVideoWatermarkConfig toConfig() {
    final double alpha = _parseDouble(wmAlphaController.text, 1.0);
    final int width = _parseInt(wmWidthController.text, 0);
    final int height = _parseInt(wmHeightController.text, 0);
    final int offsetX = _parseInt(offsetXController.text, 0);
    final int offsetY = _parseInt(offsetYController.text, 0);

    switch (type) {
      case NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeImage:
        final paths = imagePathsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (paths.isEmpty) {
          throw FormatException('图片水印需要至少一个图片路径');
        }
        return NERtcVideoWatermarkConfig(
            WatermarkType: type,
            imageWatermark: NERtcVideoWatermarkImageConfig(
                wmAlpha: alpha,
                wmWidth: width,
                wmHeight: height,
                offsetX: offsetX,
                offsetY: offsetY,
                imagePaths: paths,
                fps: _parseInt(fpsController.text, 0),
                loop: loop));
      case NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeText:
        final content = contentController.text.trim();
        if (content.isEmpty) {
          throw FormatException('文字水印需要文字内容');
        }
        return NERtcVideoWatermarkConfig(
            WatermarkType: type,
            textWatermark: NERtcVideoWatermarkTextConfig(
                wmAlpha: alpha,
                wmWidth: width,
                wmHeight: height,
                offsetX: offsetX,
                offsetY: offsetY,
                wmColor: _parseColor(wmColorController.text, 0x88888888),
                fontSize: _parseInt(fontSizeController.text, 15),
                fontColor: _parseColor(fontColorController.text, 0xFFFFFFFF),
                fontNameOrPath: fontNameController.text.trim(),
                content: content));
      case NERtcVideoWatermarkType.kNERtcVideoWatermarkTypeTimeStamp:
        return NERtcVideoWatermarkConfig(
            WatermarkType: type,
            timestampWatermark: NERtcVideoWatermarkTimestampConfig(
                wmAlpha: alpha,
                wmWidth: width,
                wmHeight: height,
                offsetX: offsetX,
                offsetY: offsetY,
                wmColor: _parseColor(wmColorController.text, 0x88888888),
                fontSize: _parseInt(fontSizeController.text, 15),
                fontColor: _parseColor(fontColorController.text, 0xFFFFFFFF),
                fontNameOrPath: fontNameController.text.trim()));
    }
  }

  static double _parseDouble(String text, double defaultValue) {
    final value = double.tryParse(text.trim());
    return value ?? defaultValue;
  }

  static int _parseInt(String text, int defaultValue) {
    final value = int.tryParse(text.trim());
    return value ?? defaultValue;
  }

  static int _parseColor(String text, int defaultValue) {
    final valueText = text.trim();
    if (valueText.isEmpty) return defaultValue;
    return int.tryParse(valueText) ??
        int.tryParse(valueText.replaceFirst('0x', ''), radix: 16) ??
        defaultValue;
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
