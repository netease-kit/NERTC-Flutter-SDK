// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'about.dart';
import 'call.dart';
import 'package:nertc_core/nertc_core.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;

void main() => runApp(RtcApp());

class RtcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLTNERTC',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

enum OptionsMenu { SETTINGS, ABOUT, MUSIC, AUDIO_SESSION }

enum ConfirmAction { CANCEL, ACCEPT }

class _MainPageState extends State<MainPage> {
  static const audioSessionChannel = const MethodChannel(
      'com.netease.nertc_core.nertc_core_example.audio_session');
  static const permissionMacOsChannel = const MethodChannel('permission_macos');

  FocusNode _channelFocusNode = FocusNode();
  FocusNode _uidFocusNode = FocusNode();
  final _channelController = TextEditingController();
  bool _channelValidateError = false;
  final _uidController = TextEditingController();
  bool _uidValidateError = false;
  bool isPlayingMusic = false;

  @override
  void initState() {
    super.initState();
    _uidController.text = Random().nextInt(1 << 32).toString();
    Settings.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLTNERTC'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (OptionsMenu result) {
                _onOptionsItemSelected(result);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OptionsMenu>>[
                    const PopupMenuItem<OptionsMenu>(
                      value: OptionsMenu.SETTINGS,
                      child: Text('Settings'),
                    ),
                    const PopupMenuItem<OptionsMenu>(
                      value: OptionsMenu.ABOUT,
                      child: Text('About'),
                    ),
                    if (Platform.isIOS)
                      PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.MUSIC,
                        child:
                            Text(isPlayingMusic ? 'Stop music' : 'Start music'),
                      ),
                    if (Platform.isIOS)
                      const PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.AUDIO_SESSION,
                        child: Text('Audio session'),
                      ),
                  ]),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              focusNode: _uidFocusNode,
              controller: _uidController,
              onChanged: (value) {
                if (_uidValidateError) {
                  setState(() {
                    _uidValidateError = value.isEmpty;
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: 'UID',
                  errorText: _uidValidateError ? 'Required' : null),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: _channelController,
                onChanged: (value) {
                  if (_channelValidateError) {
                    setState(() {
                      _channelValidateError = value.isEmpty;
                    });
                  }
                },
                autofocus: true,
                focusNode: _channelFocusNode,
                decoration: InputDecoration(
                    hintText: 'Channel Name',
                    errorText: _channelValidateError ? 'Required' : null),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 5),
            //   child: TextField(
            //     controller: _ipController,
            //     onChanged: (value) {
            //       if (_channelValidateError) {
            //         setState(() {
            //           _channelValidateError = value.isEmpty;
            //         });
            //       }
            //     },
            //     autofocus: true,
            //     focusNode: _ipFocusNode,
            //     decoration: InputDecoration(
            //         hintText: 'ip address',
            //         errorText: _channelValidateError ? 'Required' : null),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 200.0,
                  height: 55.0,
                  child: ElevatedButton(
                      onPressed: () {
                        _channelFocusNode.unfocus();
                        _uidFocusNode.unfocus();
                        _startRTC(context);
                      },
                      child: const Text(
                        '开始会话',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onOptionsItemSelected(OptionsMenu item) {
    switch (item) {
      case OptionsMenu.SETTINGS:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case OptionsMenu.ABOUT:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutPage()));
        break;
      case OptionsMenu.MUSIC:
        audioSessionChannel
            .invokeMethod(isPlayingMusic ? 'stopPlayMusic' : 'startPlayMusic');
        isPlayingMusic = !isPlayingMusic;
        break;
      case OptionsMenu.AUDIO_SESSION:
        Settings.getInstance().then((settings) {
          if (settings.audioScenario ==
              NERtcAudioScenario.scenarioDefault.index) {
            audioSessionChannel.invokeMethod('setupAudioSession', 0);
          } else if (settings.audioScenario ==
              NERtcAudioScenario.scenarioSpeech.index) {
            audioSessionChannel.invokeMethod('setupAudioSession', 1);
          }
        });
        break;
    }
  }

  Future<void> _startRTC(BuildContext context) async {
    _channelValidateError = _channelController.text.isEmpty;
    _uidValidateError = _uidController.text.isEmpty;

    setState(() {});

    if (_channelValidateError || _uidValidateError) return;

    if (Platform.isMacOS) {
      bool ret =
          await permissionMacOsChannel.invokeMethod("checkCameraPermission");
      if (!ret) {
        await permissionMacOsChannel.invokeMethod("requestCameraPermission");
      }

      ret = await permissionMacOsChannel
          .invokeMethod("checkMicrophonePermission");
      if (!ret) {
        await permissionMacOsChannel
            .invokeMethod("requestMicrophonePermission");
      }
    } else {
      //检查权限
      final permissions = [Permission.camera, Permission.microphone];
      if (Platform.isAndroid) {
        permissions.add(Permission.storage);
      }
      List<Permission> missed = [];
      for (var permission in permissions) {
        PermissionStatus status = await permission.status;
        if (status != PermissionStatus.granted) {
          missed.add(permission);
        }
      }

      bool allGranted = missed.isEmpty;
      if (!allGranted) {
        List<Permission> showRationale = [];
        for (var permission in missed) {
          bool isShown = await permission.shouldShowRequestRationale;
          if (isShown) {
            showRationale.add(permission);
          }
        }

        if (showRationale.isNotEmpty) {
          ConfirmAction? action = await showDialog<ConfirmAction>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text('You need to allow some permissions'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.CANCEL);
                      },
                    ),
                    TextButton(
                      child: const Text('Accept'),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.ACCEPT);
                      },
                    )
                  ],
                );
              });
          if (action == ConfirmAction.ACCEPT) {
            Map<Permission, PermissionStatus> allStatus =
                await missed.request();
            allGranted = true;
            for (var status in allStatus.values) {
              if (status != PermissionStatus.granted) {
                allGranted = false;
              }
            }
          }
        } else {
          Map<Permission, PermissionStatus> allStatus = await missed.request();
          allGranted = true;
          for (var status in allStatus.values) {
            if (status != PermissionStatus.granted) {
              allGranted = false;
            }
          }
        }
      }
    }

    // if (!allGranted) {
    //   // openAppSettings();
    // } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallPage(
                  cid: _channelController.text,
                  uid: int.parse(_uidController.text),
                )));
    // }
  }
}
