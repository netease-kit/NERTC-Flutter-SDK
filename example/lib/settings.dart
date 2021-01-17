import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nertc/nertc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final Settings _instance = Settings._();
  SharedPreferences _prefs;

  Settings._();

  static Future<Settings> getInstance() async {
    if (_instance._prefs == null) {
      _instance._prefs = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  bool get frontFacingCamera => _prefs?.getBool('frontFacingCamera') ?? true;
  set frontFacingCamera(bool value) =>
      _prefs?.setBool("frontFacingCamera", value);

  bool get frontFacingCameraMirror =>
      _prefs?.getBool('frontFacingCameraMirror') ?? true;
  set frontFacingCameraMirror(bool value) =>
      _prefs?.setBool("frontFacingCameraMirror", value);

  bool get enableDualStreamMode =>
      _prefs?.getBool('enableDualStreamMode') ?? true;
  set enableDualStreamMode(bool value) =>
      _prefs?.setBool("enableDualStreamMode", value);

  int get videoSendMode =>
      _prefs?.getInt('videoSendMode') ?? NERtcVideoSendMode.high.index;
  set videoSendMode(int value) => _prefs?.setInt("videoSendMode", value);

  int get videoProfile =>
      _prefs?.getInt('videoProfile') ?? NERtcVideoProfile.hd720p;
  set videoProfile(int value) => _prefs?.setInt("videoProfile", value);

  int get degradationPreference =>
      _prefs?.getInt('degradationPreference') ??
      NERtcDegradationPreference.degradationDefault;
  set degradationPreference(int value) =>
      _prefs?.setInt("degradationPreference", value);

  int get videoFrameRate =>
      _prefs?.getInt('videoFrameRate') ?? NERtcVideoFrameRate.fps_30;
  set videoFrameRate(int value) => _prefs?.setInt("videoFrameRate", value);

  int get screenProfile =>
      _prefs?.getInt('screenProfile') ?? NERtcScreenProfile.hd1080p;
  set screenProfile(int value) => _prefs?.setInt("screenProfile", value);

  int get screenContentPrefer =>
      _prefs?.getInt('screenContentPrefer') ?? NERtcSubStreamContentPrefer.motion;
  set screenContentPrefer(int value) => _prefs?.setInt("screenContentPrefer", value);

  int get remoteVideoStreamType =>
      _prefs?.getInt('remoteVideoStreamType') ??
      NERtcRemoteVideoStreamType.high;
  set remoteVideoStreamType(int value) =>
      _prefs?.setInt("remoteVideoStreamType", value);

  int get videoViewFitType =>
      _prefs?.getInt('videoViewFitType') ?? NERtcVideoViewFitType.contain.index;
  set videoViewFitType(int value) => _prefs?.setInt("videoViewFitType", value);

  int get videoEncodeMediaCodecMode =>
      _prefs?.getInt('videoEncodeMediaCodecMode') ??
      (Platform.isIOS
          ? NERtcMediaCodecMode.hardware.index
          : NERtcMediaCodecMode.software.index);
  set videoEncodeMediaCodecMode(int value) =>
      _prefs?.setInt("videoEncodeMediaCodecMode", value);

  int get videoDecodeMediaCodecMode =>
      _prefs?.getInt('videoDecodeMediaCodecMode') ??
      (Platform.isIOS
          ? NERtcMediaCodecMode.hardware.index
          : NERtcMediaCodecMode.software.index);
  set videoDecodeMediaCodecMode(int value) =>
      _prefs?.setInt("videoDecodeMediaCodecMode", value);

  int get videoCropMode =>
      _prefs?.getInt('videoCropMode') ?? NERtcVideoCropMode.cropDefault;
  set videoCropMode(int value) => _prefs?.setInt("videoCropMode", value);

  int get audioProfile =>
      _prefs?.getInt('audioProfile') ?? NERtcAudioProfile.profileDefault.index;
  set audioProfile(int value) => _prefs?.setInt("audioProfile", value);

  int get audioScenario =>
      _prefs?.getInt('audioScenario') ??
      NERtcAudioScenario.scenarioDefault.index;
  set audioScenario(int value) => _prefs?.setInt("audioScenario", value);

  bool get serverRecordSpeaker =>
      _prefs?.getBool('serverRecordSpeaker') ?? false;
  set serverRecordSpeaker(bool value) =>
      _prefs?.setBool("serverRecordSpeaker", value);

  bool get serverRecordAudio => _prefs?.getBool('serverRecordAudio') ?? false;
  set serverRecordAudio(bool value) =>
      _prefs?.setBool("serverRecordAudio", value);

  bool get serverRecordVideo => _prefs?.getBool('serverRecordVideo') ?? false;
  set serverRecordVideo(bool value) =>
      _prefs?.setBool("serverRecordVideo", value);

  int get serverRecordMode =>
      _prefs?.getInt('serverRecordMode') ??
      NERtcServerRecordMode.mixAndSingle.index;
  set serverRecordMode(int value) => _prefs?.setInt("serverRecordMode", value);

  String get audioMixingFileUrl =>
      _prefs?.getString('audioMixingFileUrl') ??
      'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3';
  set audioMixingFileUrl(String value) =>
      _prefs?.setString("audioMixingFileUrl", value);

  String get audioMixingFilePath =>
      _prefs?.getString('audioMixingFilePath') ?? '';
  set audioMixingFilePath(String value) =>
      _prefs?.setString("audioMixingFilePath", value);

  bool get audioMixingSendEnabled =>
      _prefs?.getBool('audioMixingSendEnabled') ?? true;
  set audioMixingSendEnabled(bool value) =>
      _prefs?.setBool("audioMixingSendEnabled", value);

  bool get audioMixingPlayEnabled =>
      _prefs?.getBool('audioMixingPlayEnabled') ?? true;
  set audioMixingPlayEnabled(bool value) =>
      _prefs?.setBool("audioMixingPlayEnabled", value);

  int get audioMixingLoopCount => _prefs?.getInt('audioMixingLoopCount') ?? 1;
  set audioMixingLoopCount(int value) =>
      _prefs?.setInt("audioMixingLoopCount", value);

  String get audioEffectFilePath =>
      _prefs?.getString('audioEffectFilePath') ?? '';
  set audioEffectFilePath(String value) =>
      _prefs?.setString("audioEffectFilePath", value);

  bool get audioEffectSendEnabled =>
      _prefs?.getBool('audioEffectSendEnabled') ?? true;
  set audioEffectSendEnabled(bool value) =>
      _prefs?.setBool("audioEffectSendEnabled", value);

  bool get audioEffectPlayEnabled =>
      _prefs?.getBool('audioEffectPlayEnabled') ?? true;
  set audioEffectPlayEnabled(bool value) =>
      _prefs?.setBool("audioEffectPlayEnabled", value);

  int get audioEffectLoopCount => _prefs?.getInt('audioEffectLoopCount') ?? 1;
  set audioEffectLoopCount(int value) =>
      _prefs?.setInt("audioEffectLoopCount", value);

  bool get autoEnableAudio => _prefs?.getBool('autoEnableAudio') ?? true;
  set autoEnableAudio(bool value) => _prefs?.setBool("autoEnableAudio", value);

  bool get autoEnableVideo => _prefs?.getBool('autoEnableVideo') ?? true;
  set autoEnableVideo(bool value) => _prefs?.setBool("autoEnableVideo", value);

  bool get autoSubscribeAudio => _prefs?.getBool('autoSubscribeAudio') ?? true;
  set autoSubscribeAudio(bool value) =>
      _prefs?.setBool("autoSubscribeAudio", value);

  bool get autoSubscribeVideo => _prefs?.getBool('autoSubscribeVideo') ?? true;
  set autoSubscribeVideo(bool value) =>
      _prefs?.setBool("autoSubscribeVideo", value);
}

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings;

  bool _frontFacingCamera = true;
  bool _frontFacingCameraMirror = true;
  bool _enableDualStreamMode = true;
  int _videoSendMode = NERtcVideoSendMode.high.index;
  int _videoProfile = NERtcVideoProfile.hd720p;
  int _degradationPreference = NERtcDegradationPreference.degradationDefault;
  int _videoFrameRate = NERtcVideoFrameRate.fps_30;
  int _screenProfile = NERtcScreenProfile.hd1080p;
  int _screenContentPrefer = NERtcSubStreamContentPrefer.motion;
  int _remoteVideoStreamType = NERtcRemoteVideoStreamType.high;
  int _videoViewFitType = NERtcVideoViewFitType.contain.index;
  int _videoEncodeMediaCodecMode = Platform.isIOS
      ? NERtcMediaCodecMode.hardware.index
      : NERtcMediaCodecMode.software.index;
  int _videoDecodeMediaCodecMode = Platform.isIOS
      ? NERtcMediaCodecMode.hardware.index
      : NERtcMediaCodecMode.software.index;
  int _videoCropMode = NERtcVideoCropMode.cropDefault;
  int _audioProfile = NERtcAudioProfile.profileDefault.index;
  int _audioScenario = NERtcAudioScenario.scenarioDefault.index;
  bool _serverRecordSpeaker = false;
  bool _serverRecordAudio = false;
  bool _serverRecordVideo = false;
  int _serverRecordMode = NERtcServerRecordMode.mixAndSingle.index;
  String _audioMixingFileUrl =
      'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3';
  String _audioMixingFilePath = '';
  bool _audioMixingSendEnabled = true;
  bool _audioMixingPlayEnabled = true;
  int _audioMixingLoopCount = 1;
  String _audioEffectFilePath = '';
  bool _audioEffectSendEnabled = true;
  bool _audioEffectPlayEnabled = true;
  int _audioEffectLoopCount = 1;
  bool _autoEnableAudio = true;
  bool _autoEnableVideo = true;
  bool _autoSubscribeAudio = true;
  bool _autoSubscribeVideo = true;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  void _initSettings() async {
    settings = await Settings.getInstance();
    setState(() {
      _frontFacingCamera = settings.frontFacingCamera;
      _frontFacingCameraMirror = settings.frontFacingCameraMirror;
      _enableDualStreamMode = settings.enableDualStreamMode;
      _videoSendMode = settings.videoSendMode;
      _videoProfile = settings.videoProfile;
      _degradationPreference = settings.degradationPreference;
      _videoFrameRate = settings.videoFrameRate;
      _screenProfile = settings.screenProfile;
      _screenContentPrefer = settings.screenContentPrefer;
      _remoteVideoStreamType = settings.remoteVideoStreamType;
      _videoViewFitType = settings.videoViewFitType;
      _videoEncodeMediaCodecMode = settings.videoEncodeMediaCodecMode;
      _videoDecodeMediaCodecMode = settings.videoDecodeMediaCodecMode;
      _videoCropMode = settings.videoCropMode;
      _audioProfile = settings.audioProfile;
      _audioScenario = settings.audioScenario;
      _serverRecordSpeaker = settings.serverRecordSpeaker;
      _serverRecordAudio = settings.serverRecordAudio;
      _serverRecordVideo = settings.serverRecordVideo;
      _serverRecordMode = settings.serverRecordMode;
      _audioMixingFileUrl = settings.audioMixingFileUrl;
      _audioMixingFilePath = settings.audioMixingFilePath;
      _audioMixingSendEnabled = settings.audioMixingSendEnabled;
      _audioMixingPlayEnabled = settings.audioMixingPlayEnabled;
      _audioMixingLoopCount = settings.audioMixingLoopCount;
      _audioEffectFilePath = settings.audioEffectFilePath;
      _audioEffectSendEnabled = settings.audioEffectSendEnabled;
      _audioEffectPlayEnabled = settings.audioEffectPlayEnabled;
      _audioEffectLoopCount = settings.audioEffectLoopCount;
      _autoEnableAudio = settings.autoEnableAudio;
      _autoEnableVideo = settings.autoEnableVideo;
      _autoSubscribeAudio = settings.autoSubscribeAudio;
      _autoSubscribeVideo = settings.autoSubscribeVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        titleSpacing: 0,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            buildVideoSettings(context),
            buildAudioSettings(context),
            buildServerRecordSettings(context),
            buildAudioMixingSettings(context),
            buildAudioEffectSettings(context),
            buildOtherSettings(context)
          ],
        ),
      ),
    );
  }

  Widget buildOtherSettings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '其它',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
        ),
        Column(
          children: [
            SwitchListTile(
              title: const Text('自动开启音频'),
              subtitle: Text('自动开启音频'),
              onChanged: (bool value) {
                setState(() {
                  _autoEnableAudio = value;
                  settings.autoEnableAudio = _autoEnableAudio;
                });
              },
              value: _autoEnableAudio,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('自动开启视频'),
              subtitle: Text('自动开启视频'),
              onChanged: (bool value) {
                setState(() {
                  _autoEnableVideo = value;
                  settings.autoEnableVideo = _autoEnableVideo;
                });
              },
              value: _autoEnableVideo,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('自动订阅音频'),
              subtitle: Text('自动订阅音频'),
              onChanged: (bool value) {
                setState(() {
                  _autoSubscribeAudio = value;
                  settings.autoSubscribeAudio = _autoSubscribeAudio;
                });
              },
              value: _autoSubscribeAudio,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('自动订阅视频'),
              subtitle: Text('自动订阅视频'),
              onChanged: (bool value) {
                setState(() {
                  _autoSubscribeVideo = value;
                  settings.autoSubscribeVideo = _autoSubscribeVideo;
                });
              },
              value: _autoSubscribeVideo,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
          ],
        )
      ],
    );
  }

  Widget buildAudioEffectSettings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '音效',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
        ),
        Column(
          children: [
            ListTile(
              title: const Text('文件路径'),
              subtitle: Text(_audioEffectFilePath),
              onTap: () {
                _selectAudioEffectFilePath();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('是否发送'),
              subtitle: Text('是否发送'),
              onChanged: (bool value) {
                setState(() {
                  _audioEffectSendEnabled = value;
                  settings.audioEffectSendEnabled = _audioEffectSendEnabled;
                });
              },
              value: _audioEffectSendEnabled,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('是否播放'),
              subtitle: Text('是否播放'),
              onChanged: (bool value) {
                setState(() {
                  _audioEffectPlayEnabled = value;
                  settings.audioEffectPlayEnabled = _audioEffectPlayEnabled;
                });
              },
              value: _audioEffectPlayEnabled,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
          ],
        )
      ],
    );
  }

  Widget buildAudioMixingSettings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '伴音',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
        ),
        Column(
          children: [
            ListTile(
              title: const Text('文件路径'),
              subtitle: Text(_audioMixingFilePath),
              onTap: () {
                _selectAudioMixFilePath();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('是否发送'),
              subtitle: Text('是否发送'),
              onChanged: (bool value) {
                setState(() {
                  _audioMixingSendEnabled = value;
                  settings.audioMixingSendEnabled = _audioMixingSendEnabled;
                });
              },
              value: _audioMixingSendEnabled,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('是否播放'),
              subtitle: Text('是否播放'),
              onChanged: (bool value) {
                setState(() {
                  _audioMixingPlayEnabled = value;
                  settings.audioMixingPlayEnabled = _audioMixingPlayEnabled;
                });
              },
              value: _audioMixingPlayEnabled,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
          ],
        )
      ],
    );
  }

  Widget buildServerRecordSettings(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '服务器录制',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
          ),
          Column(
            children: [
              SwitchListTile(
                title: const Text('录制主讲人'),
                subtitle: Text('录制主讲人'),
                onChanged: (bool value) {
                  setState(() {
                    _serverRecordSpeaker = value;
                    settings.serverRecordSpeaker = _serverRecordSpeaker;
                  });
                },
                value: _serverRecordSpeaker,
              ),
              Divider(
                  height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
              SwitchListTile(
                title: const Text('音频录制'),
                subtitle: Text('音频录制'),
                onChanged: (bool value) {
                  setState(() {
                    _serverRecordAudio = value;
                    settings.serverRecordAudio = _serverRecordAudio;
                  });
                },
                value: _serverRecordAudio,
              ),
              Divider(
                  height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
              SwitchListTile(
                title: const Text('视频录制'),
                subtitle: Text('视频录制'),
                onChanged: (bool value) {
                  setState(() {
                    _serverRecordVideo = value;
                    settings.serverRecordVideo = _serverRecordVideo;
                  });
                },
                value: _serverRecordVideo,
              ),
              Divider(
                  height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
              ListTile(
                title: const Text('录制模式'),
                subtitle: Text(_serverRecordModeToString(_serverRecordMode)),
                onTap: () {
                  _selectServerRecordMode();
                },
              ),
            ],
          )
        ]);
  }

  Widget buildAudioSettings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '音频',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
        ),
        Column(
          children: [
            ListTile(
              title: const Text('音频编码属性'),
              subtitle: Text(_audioProfileToString(_audioProfile)),
              onTap: () {
                _selectAudioProfile();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('音频场景'),
              subtitle: Text(_audioScenarioToString(_audioScenario)),
              onTap: () {
                _selectAudioScenario();
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildVideoSettings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            '视频',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
        ),
        Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('前置摄像头'),
              subtitle: Text('选择摄像头'),
              onChanged: (bool value) {
                setState(() {
                  _frontFacingCamera = value;
                  settings.frontFacingCamera = _frontFacingCamera;
                });
              },
              value: _frontFacingCamera,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('前置镜像'),
              subtitle: Text('本地前置摄像头镜像'),
              onChanged: (bool value) {
                setState(() {
                  _frontFacingCameraMirror = value;
                  settings.frontFacingCameraMirror = _frontFacingCameraMirror;
                });
              },
              value: _frontFacingCameraMirror,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            SwitchListTile(
              title: const Text('开启小流'),
              subtitle: Text('开启小流'),
              onChanged: (bool value) {
                setState(() {
                  _enableDualStreamMode = value;
                  settings.enableDualStreamMode = _enableDualStreamMode;
                });
              },
              value: _enableDualStreamMode,
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('发布流类型'),
              subtitle: Text(_videoSendModeToString(_videoSendMode)),
              onTap: () {
                _selectVideoSendMode();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('发送分辨率'),
              subtitle: Text(_videoProfileToString(_videoProfile)),
              onTap: () {
                _selectVideoProfile();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('编码模式'),
              subtitle:
                  Text(_degradationPreferenceToString(_degradationPreference)),
              onTap: () {
                _selectDegradationPreference();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('编码帧率'),
              subtitle: Text(_videoFrameRateToString(_videoFrameRate)),
              onTap: () {
                _selectVideoFrameRate();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('屏幕共享分辨率'),
              subtitle: Text(_screenProfileToString(_screenProfile)),
              onTap: () {
                _selectScreenProfile();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('录屏模式'),
              subtitle: Text(_subStreamContentPrefer(_screenContentPrefer)),
              onTap: () {
                _selectSubStreamContentPrefer();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('订阅分辨率'),
              subtitle: Text(_remoteVideoStreamTypeToString(_screenProfile)),
              onTap: () {
                _selectRemoteVideoStreamType();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('画布缩放模式'),
              subtitle: Text(_videoViewFitTypeToString(_videoViewFitType)),
              onTap: () {
                _selectVideoViewFitType();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('编码模式'),
              subtitle:
                  Text(_mediaCodecModeToString(_videoEncodeMediaCodecMode)),
              onTap: () {
                _selectVideoEncodeMediaCodecMode();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('解码模式'),
              subtitle:
                  Text(_mediaCodecModeToString(_videoDecodeMediaCodecMode)),
              onTap: () {
                _selectVideoDecodeMediaCodecMode();
              },
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('裁剪模式'),
              subtitle: Text(_videoCropModeToString(_videoCropMode)),
              onTap: () {
                _selectVideoCropMode();
              },
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        )
      ],
    );
  }

  Future<void> _selectServerRecordMode() async {
    int mode = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('录制模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcServerRecordMode.mix.index);
                },
                child: const Text('mix'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcServerRecordMode.single.index);
                },
                child: const Text('single'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcServerRecordMode.mixAndSingle.index);
                },
                child: const Text('mix and single'),
              ),
            ],
          );
        });
    if (mode != null) {
      setState(() {
        _videoCropMode = mode;
        settings.videoCropMode = _videoCropMode;
      });
    }
  }

  Future<void> _selectAudioScenario() async {
    int scenario = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('音频场景'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioScenario.scenarioDefault.index);
                },
                child: const Text('default'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioScenario.scenarioSpeech.index);
                },
                child: const Text('speech'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioScenario.scenarioMusic.index);
                },
                child: const Text('music'),
              ),
            ],
          );
        });
    if (scenario != null) {
      setState(() {
        _audioScenario = scenario;
        settings.audioScenario = _audioScenario;
      });
    }
  }

  Future<void> _selectAudioProfile() async {
    int profile = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('音频编码属性'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioProfile.profileDefault.index);
                },
                child: const Text('default'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioProfile.profileStandard.index);
                },
                child: const Text('standard'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioProfile.profileStandardExtend.index);
                },
                child: const Text('standardex'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioProfile.profileMiddleQuality.index);
                },
                child: const Text('middle quality'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context,
                      NERtcAudioProfile.profileMiddleQualityStereo.index);
                },
                child: const Text('middle quality stereo'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcAudioProfile.profileHighQuality.index);
                },
                child: const Text('high quality'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context,
                      NERtcAudioProfile.profileHighQualityStereo.index);
                },
                child: const Text('high quality stereo'),
              ),
            ],
          );
        });
    if (profile != null) {
      setState(() {
        _audioProfile = profile;
        settings.audioProfile = _audioProfile;
      });
    }
  }

  Future<void> _selectVideoCropMode() async {
    int mode = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('裁剪模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoCropMode.cropDefault);
                },
                child: const Text('default'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoCropMode.crop_1x1);
                },
                child: const Text('1x1'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoCropMode.crop_4x3);
                },
                child: const Text('4x3'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoCropMode.crop_16x9);
                },
                child: const Text('16x9'),
              ),
            ],
          );
        });
    if (mode != null) {
      setState(() {
        _videoCropMode = mode;
        settings.videoCropMode = _videoCropMode;
      });
    }
  }

  Future<void> _selectVideoDecodeMediaCodecMode() async {
    int mode = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('解码模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcMediaCodecMode.hardware.index);
                },
                child: const Text('hardware'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcMediaCodecMode.software.index);
                },
                child: const Text('software'),
              ),
            ],
          );
        });
    if (mode != null) {
      setState(() {
        _videoDecodeMediaCodecMode = mode;
        settings.videoDecodeMediaCodecMode = _videoDecodeMediaCodecMode;
      });
    }
  }

  Future<void> _selectVideoEncodeMediaCodecMode() async {
    int mode = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('编码模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcMediaCodecMode.hardware.index);
                },
                child: const Text('hardware'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcMediaCodecMode.software.index);
                },
                child: const Text('software'),
              ),
            ],
          );
        });
    if (mode != null) {
      setState(() {
        _videoEncodeMediaCodecMode = mode;
        settings.videoEncodeMediaCodecMode = _videoEncodeMediaCodecMode;
      });
    }
  }

  Future<void> _selectVideoViewFitType() async {
    int videoViewFitType = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('画布缩放模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoViewFitType.contain.index);
                },
                child: const Text('contain'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoViewFitType.cover.index);
                },
                child: const Text('cover'),
              ),
            ],
          );
        });
    if (videoViewFitType != null) {
      setState(() {
        _videoViewFitType = videoViewFitType;
        settings.videoViewFitType = _videoViewFitType;
      });
    }
  }

  Future<void> _selectRemoteVideoStreamType() async {
    int remoteVideoStreamType = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('订阅分辨率'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcRemoteVideoStreamType.low);
                },
                child: const Text('low'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcRemoteVideoStreamType.high);
                },
                child: const Text('high'),
              ),
            ],
          );
        });
    if (remoteVideoStreamType != null) {
      setState(() {
        _remoteVideoStreamType = remoteVideoStreamType;
        settings.remoteVideoStreamType = _remoteVideoStreamType;
      });
    }
  }

  Future<void> _selectSubStreamContentPrefer() async {
    int contentPrefer = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('录屏模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcSubStreamContentPrefer.motion);
                },
                child: const Text('motion'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcSubStreamContentPrefer.details);
                },
                child: const Text('details'),
              ),
            ],
          );
        });
    if (contentPrefer != null) {
      setState(() {
        _screenContentPrefer = contentPrefer;
        settings.screenContentPrefer = _screenContentPrefer;
      });
    }
  }

  Future<void> _selectScreenProfile() async {
    int screenProfile = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('屏幕共享分辨率'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcScreenProfile.hd480p);
                },
                child: const Text('480p'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcScreenProfile.hd720p);
                },
                child: const Text('720p'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcScreenProfile.hd1080p);
                },
                child: const Text('1080p'),
              ),
            ],
          );
        });
    if (screenProfile != null) {
      setState(() {
        _screenProfile = screenProfile;
        settings.screenProfile = _screenProfile;
      });
    }
  }

  Future<void> _selectVideoFrameRate() async {
    int videoFrameRate = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('编码帧率'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoFrameRate.fps_7);
                },
                child: const Text('7'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoFrameRate.fps_10);
                },
                child: const Text('10'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoFrameRate.fps_15);
                },
                child: const Text('15'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoFrameRate.fps_24);
                },
                child: const Text('24'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoFrameRate.fps_30);
                },
                child: const Text('30'),
              ),
            ],
          );
        });
    if (videoFrameRate != null) {
      setState(() {
        _videoFrameRate = videoFrameRate;
        settings.videoFrameRate = _videoFrameRate;
      });
    }
  }

  Future<void> _selectDegradationPreference() async {
    int degradationPreference = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('编码模式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcDegradationPreference.degradationDefault);
                },
                child: const Text('default'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, NERtcDegradationPreference.degradationBalanced);
                },
                child: const Text('balanced'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context,
                      NERtcDegradationPreference.degradationMaintainFrameRate);
                },
                child: const Text('maintain frame rate'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context,
                      NERtcDegradationPreference.degradationMaintainQuality);
                },
                child: const Text('maintain quality'),
              ),
            ],
          );
        });
    if (degradationPreference != null) {
      setState(() {
        _degradationPreference = degradationPreference;
        settings.degradationPreference = _degradationPreference;
      });
    }
  }

  Future<void> _selectVideoProfile() async {
    int profile = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('发送分辨率'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoProfile.low);
                },
                child: const Text('low'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoProfile.standard);
                },
                child: const Text('standard'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoProfile.hd720p);
                },
                child: const Text('720p'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoProfile.hd1080p);
                },
                child: const Text('1080p'),
              ),
            ],
          );
        });
    if (profile != null) {
      setState(() {
        _videoProfile = profile;
        settings.videoProfile = _videoProfile;
      });
    }
  }

  Future<void> _selectVideoSendMode() async {
    NERtcVideoSendMode mode = await showDialog<NERtcVideoSendMode>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('发布流类型'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoSendMode.all);
                },
                child: const Text('all'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoSendMode.high);
                },
                child: const Text('high'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoSendMode.low);
                },
                child: const Text('low'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, NERtcVideoSendMode.none);
                },
                child: const Text('none'),
              ),
            ],
          );
        });
    if (mode != null) {
      setState(() {
        _videoSendMode = mode.index;
        settings.videoSendMode = _videoSendMode;
      });
    }
  }

  String _videoSendModeToString(int mode) {
    if (mode == NERtcVideoSendMode.all.index) {
      return 'all';
    } else if (mode == NERtcVideoSendMode.high.index) {
      return 'high';
    } else if (mode == NERtcVideoSendMode.low.index) {
      return 'low';
    } else if (mode == NERtcVideoSendMode.none.index) {
      return 'none';
    } else {
      return 'high';
    }
  }

  String _videoProfileToString(int profile) {
    switch (profile) {
      case NERtcVideoProfile.low:
        return 'low';
      case NERtcVideoProfile.standard:
        return 'standard';
      case NERtcVideoProfile.hd720p:
        return '720p';
      case NERtcVideoProfile.hd1080p:
        return '1080p';
      default:
        return '720p';
    }
  }

  String _degradationPreferenceToString(int degradationPreference) {
    switch (degradationPreference) {
      case NERtcDegradationPreference.degradationDefault:
        return 'default';
      case NERtcDegradationPreference.degradationBalanced:
        return 'balanced';
      case NERtcDegradationPreference.degradationMaintainFrameRate:
        return 'maintain frame rate';
      case NERtcDegradationPreference.degradationMaintainQuality:
        return 'maintain quality';
      default:
        return 'default';
    }
  }

  String _videoFrameRateToString(int frameRate) {
    switch (frameRate) {
      case NERtcVideoFrameRate.fps_7:
        return '7';
      case NERtcVideoFrameRate.fps_10:
        return '10';
      case NERtcVideoFrameRate.fps_15:
        return '15';
      case NERtcVideoFrameRate.fps_24:
        return '24';
      case NERtcVideoFrameRate.fps_30:
        return '30';
      default:
        return '30';
    }
  }

  String _screenProfileToString(int profile) {
    switch (profile) {
      case NERtcScreenProfile.hd480p:
        return '480p';
      case NERtcScreenProfile.hd720p:
        return '720p';
      case NERtcScreenProfile.hd1080p:
        return '1080p';
      default:
        return '1080p';
    }
  }

  String _subStreamContentPrefer(int contentPrefer) {
    switch (contentPrefer) {
      case NERtcSubStreamContentPrefer.motion:
        return 'motion';
      case NERtcSubStreamContentPrefer.details:
        return 'details';
      default:
        return 'motion';
    }
  }

  String _remoteVideoStreamTypeToString(int type) {
    switch (type) {
      case NERtcRemoteVideoStreamType.high:
        return 'high';
      case NERtcRemoteVideoStreamType.low:
        return 'low';
      default:
        return 'high';
    }
  }

  String _videoViewFitTypeToString(int type) {
    if (type == NERtcVideoViewFitType.contain.index) {
      return 'contain';
    } else if (type == NERtcVideoViewFitType.cover.index) {
      return 'cover';
    } else {
      return 'contain';
    }
  }

  String _mediaCodecModeToString(int mode) {
    if (mode == NERtcMediaCodecMode.hardware.index) {
      return 'hardware';
    } else if (mode == NERtcMediaCodecMode.software.index) {
      return 'software';
    } else {
      return 'software';
    }
  }

  String _videoCropModeToString(int mode) {
    switch (mode) {
      case NERtcVideoCropMode.cropDefault:
        return 'default';
      case NERtcVideoCropMode.crop_1x1:
        return '1x1';
      case NERtcVideoCropMode.crop_4x3:
        return '4x3';
      case NERtcVideoCropMode.crop_16x9:
        return '16x9';
      default:
        return 'default';
    }
  }

  String _audioProfileToString(int profile) {
    if (profile == NERtcAudioProfile.profileDefault.index) {
      return 'default';
    } else if (profile == NERtcAudioProfile.profileHighQuality.index) {
      return 'high quality';
    } else if (profile == NERtcAudioProfile.profileHighQualityStereo.index) {
      return 'high quality stereo';
    } else if (profile == NERtcAudioProfile.profileMiddleQuality.index) {
      return 'middle quality';
    } else if (profile == NERtcAudioProfile.profileMiddleQualityStereo.index) {
      return 'middle quality stereo';
    } else if (profile == NERtcAudioProfile.profileStandard.index) {
      return 'standard';
    } else if (profile == NERtcAudioProfile.profileStandardExtend.index) {
      return 'standard extend';
    } else {
      return 'default';
    }
  }

  String _audioScenarioToString(int profile) {
    if (profile == NERtcAudioScenario.scenarioDefault.index) {
      return 'default';
    } else if (profile == NERtcAudioScenario.scenarioSpeech.index) {
      return 'speech';
    } else if (profile == NERtcAudioScenario.scenarioMusic.index) {
      return 'music';
    } else {
      return 'default';
    }
  }

  String _serverRecordModeToString(int mode) {
    if (mode == NERtcServerRecordMode.mix.index) {
      return 'mix';
    } else if (mode == NERtcServerRecordMode.mixAndSingle.index) {
      return 'mix and single';
    } else if (mode == NERtcServerRecordMode.single.index) {
      return 'single';
    } else {
      return 'mix and single';
    }
  }

  void _selectAudioMixFilePath() {
    FilePicker.platform.pickFiles(type: FileType.audio).then((value) => {
          setState(() {
            _audioMixingFilePath = value.paths.first;
            settings.audioMixingFilePath = _audioMixingFilePath;
          })
        });
  }

  void _selectAudioEffectFilePath() {
    FilePicker.platform.pickFiles(type: FileType.audio).then((value) => {
          setState(() {
            _audioEffectFilePath = value.paths.first;
            settings.audioEffectFilePath = _audioEffectFilePath;
          })
        });
  }
}
