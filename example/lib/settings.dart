import 'package:flutter/material.dart';
import 'package:nertc/nertc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;

  bool _frontFacingCamera;
  bool _frontFacingCameraMirror;
  bool _enableDualStreamMode;
  int _videoSendMode;
  int _videoProfile;
  int _degradationPreference;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  void _initSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _frontFacingCamera = prefs.getBool('_frontFacingCamera') ?? true;
      _frontFacingCameraMirror =
          prefs.getBool('_frontFacingCameraMirror') ?? true;
      _enableDualStreamMode = prefs.getBool('_enableDualStreamMode') ?? true;
      _videoSendMode =
          prefs.getInt('_videoSendMode') ?? NERtcVideoSendMode.high.index;
      _videoProfile = prefs.getInt('_videoProfile') ?? NERtcVideoProfile.hd720p;
      _degradationPreference = prefs.getInt('_degradationPreference') ??
          NERtcDegradationPreference.degradationDefault;
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
          ],
        ),
      ),
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
                  prefs.setBool("_frontFacingCamera", _frontFacingCamera);
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
                  prefs.setBool(
                      "_frontFacingCameraMirror", _frontFacingCameraMirror);
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
                  prefs.setBool("_enableDualStreamMode", _enableDualStreamMode);
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
          ],
          mainAxisSize: MainAxisSize.min,
        )
      ],
    );
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
                child: const Text('maintain frame rate)'),
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
        prefs.setInt("_degradationPreference", _degradationPreference);
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
        prefs.setInt("_videoProfile", _videoProfile);
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
        prefs.setInt("_videoSendMode", _videoSendMode);
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
}
