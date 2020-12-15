import 'package:FLTNERTC/settings.dart';
import 'package:FLTNERTC/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nertc/nertc.dart';
import 'config.dart';

class CallPage extends StatefulWidget {
  final String cid;
  final int uid;

  CallPage({Key key, @required this.cid, @required this.uid});

  @override
  _CallPageState createState() {
    return _CallPageState();
  }
}

class _CallPageState extends State<CallPage>
    with
        NERtcChannelEventCallback,
        NERtcStatsEventCallback,
        NERtcDeviceEventCallback {
  Settings _settings;
  NERtcEngine _engine = NERtcEngine();
  List<_UserSession> _remoteSessions = List();
  _UserSession _localSession = _UserSession();

  bool _showControlPanel = false;
  bool isAudioEnabled = false;
  bool isVideoEnabled = false;
  bool isFrontCamera = true;
  bool isFrontCameraMirror = true;
  bool isSpeakerphoneOn = false;

  @override
  void initState() {
    super.initState();
    _initSettings().then((value) => _initRtcEngine());
  }

  Future<void> _initSettings() async {
    _settings = await Settings.getInstance();
    isAudioEnabled = _settings.autoEnableAudio;
    isVideoEnabled = _settings.autoEnableVideo;
    isFrontCamera = _settings.frontFacingCamera;
    isFrontCameraMirror = _settings.frontFacingCameraMirror;
  }

  Future<void> updateSettings() async {
    isSpeakerphoneOn = await _engine.deviceManager.isSpeakerphoneOn();
    _showControlPanel = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(widget.cid),
        ),
        body: buildCallingWidget(context),
      ),
      // ignore: missing_return
      onWillPop: () {
        _requestPop();
      },
    );
  }

  Widget buildCallingWidget(BuildContext context) {
    return Stack(children: <Widget>[
      buildVideoViews(context),
      if (_showControlPanel) buildControlPanel(context)
    ]);
  }

  Widget buildControlPanel(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [buildControlPanel1(context), buildControlPanel3(context)],
    );
  }

  Widget buildControlPanel3(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('离开房间'),
          ),
        ),
      ],
    );
  }

  Widget buildControlPanel1(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(
            onPressed: () {
              bool audioEnabled = !isAudioEnabled;
              _engine.enableLocalAudio(audioEnabled).then((value) {
                if (value == 0) {
                  setState(() {
                    isAudioEnabled = audioEnabled;
                  });
                }
              });
            },
            child: Text(isAudioEnabled ? '关闭语音' : '打开语音'),
          ),
        ),
        Expanded(
          child: RaisedButton(
            onPressed: () {
              bool videoEnabled = !isVideoEnabled;
              _engine.enableLocalVideo(videoEnabled).then((value) {
                if (value == 0) {
                  setState(() {
                    isVideoEnabled = videoEnabled;
                  });
                }
              });
            },
            child: Text(isVideoEnabled ? '关闭视频' : '打开视频'),
          ),
        ),
        Expanded(
          child: RaisedButton(
            onPressed: () {
              _engine.deviceManager.switchCamera().then((value) {
                if (value == 0) {
                  isFrontCamera = !isFrontCamera;
                  _localSession.renderer
                      .setMirror(isFrontCamera && isFrontCameraMirror);
                }
              });
            },
            child: Text(
              '切换摄像头',
              softWrap: false,
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        Expanded(
          child: RaisedButton(
            onPressed: () {
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
            child: Text(
              isSpeakerphoneOn ? '关闭扬声器' : '打开扬声器',
              softWrap: false,
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVideoViews(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0),
        itemCount: _remoteSessions.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return buildVideoView(context, _localSession);
          } else {
            return buildVideoView(context, _remoteSessions[index - 1]);
          }
        });
  }

  Widget buildVideoView(BuildContext context, _UserSession session) {
    return Container(
      child: Stack(
        children: [
          session.renderer != null
              ? NERtcVideoView(session.renderer)
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${session.uid}',
                style: TextStyle(color: Colors.red),
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
    _localSession.uid = widget.uid;
    NERtcOptions options = NERtcOptions(
        autoSubscribeAudio: _settings.autoSubscribeAudio,
        serverRecordSpeaker: _settings.serverRecordSpeaker,
        serverRecordAudio: _settings.serverRecordAudio,
        serverRecordVideo: _settings.serverRecordVideo,
        serverRecordMode:
            NERtcServerRecordMode.values[_settings.serverRecordMode],
        videoSendMode: NERtcVideoSendMode.values[_settings.videoSendMode],
        videoEncodeMode:
            NERtcMediaCodecMode.values[_settings.videoEncodeMediaCodecMode],
        videoDecodeMode:
            NERtcMediaCodecMode.values[_settings.videoDecodeMediaCodecMode]);
    _engine
        .create(
            appKey: Config.APP_KEY,
            channelEventCallback: this,
            options: options)
        .then((value) => _initCallbacks())
        .then((value) => _initAudio())
        .then((value) => _initVideo())
        .then((value) => _initRenderer())
        .then((value) => _engine.joinChannel('', widget.cid, widget.uid));
  }

  Future<int> _initCallbacks() async {
    await _engine.setStatsEventCallback(this);
    return _engine.deviceManager.setEventCallback(this);
  }

  Future<int> _initAudio() async {
    await _engine.enableLocalAudio(isAudioEnabled);
    return _engine.setAudioProfile(
        NERtcAudioProfile.values[_settings.audioProfile],
        NERtcAudioScenario.values[_settings.audioScenario]);
  }

  Future<int> _initVideo() async {
    await _engine.enableLocalVideo(isVideoEnabled);
    await _engine.enableDualStreamMode(_settings.enableDualStreamMode);
    NERtcVideoConfig config = NERtcVideoConfig();
    config.videoProfile = _settings.videoProfile;
    config.frameRate = _settings.videoFrameRate;
    config.degradationPrefer = _settings.degradationPreference;
    config.frontCamera = _settings.frontFacingCamera;
    config.videoCropMode = _settings.videoCropMode;
    return _engine.setLocalVideoConfig(config);
  }

  Future<void> _initRenderer() async {
    _localSession.renderer = await VideoRendererFactory.createVideoRenderer();
    _localSession.renderer.setMirror(isFrontCamera && isFrontCameraMirror);
    _localSession.renderer.addToLocalVideoSink();
    setState(() {});
  }

  void _releaseRtcEngine() {
    _engine.release();
  }

  void _leaveChannel() {
    _engine.enableLocalVideo(false);
    _engine.enableLocalAudio(false);
    _engine.stopVideoPreview();
    if (_localSession.renderer != null) {
      _localSession.renderer.dispose();
      _localSession.renderer = null;
    }
    for (_UserSession session in _remoteSessions) {
      session.renderer?.dispose();
      session.renderer = null;
    }
    _engine.leaveChannel();
  }

  @override
  void dispose() {
    _leaveChannel();
    _releaseRtcEngine();
    super.dispose();
  }

  @override
  void onConnectionTypeChanged(int newConnectionType) {
    Fluttertoast.showToast(
        msg:
            'onConnectionTypeChanged#${Utils.connectionType2String(newConnectionType)}',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onDisconnect(int reason) {
    Fluttertoast.showToast(
        msg: 'onDisconnect#$reason', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstAudioDataReceived(int uid) {
    Fluttertoast.showToast(
        msg: 'onFirstAudioDataReceived#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstVideoDataReceived(int uid) {
    Fluttertoast.showToast(
        msg: 'onFirstVideoDataReceived#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onLeaveChannel(int result) {
    Fluttertoast.showToast(
        msg: 'onLeaveChannel#$result', gravity: ToastGravity.CENTER);
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    Fluttertoast.showToast(
        msg: 'onUserAudioStart#uid:$uid, muted:$muted',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onUserAudioStart(int uid) {
    Fluttertoast.showToast(
        msg: 'onUserAudioStart#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onUserAudioStop(int uid) {
    Fluttertoast.showToast(
        msg: 'onUserAudioStop#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onUserJoined(int uid) {
    Fluttertoast.showToast(
        msg: 'onUserJoined#$uid', gravity: ToastGravity.CENTER);
    _UserSession session = _UserSession();
    session.uid = uid;
    _remoteSessions.add(session);
    setState(() {});
  }

  @override
  void onUserLeave(int uid, int reason) {
    Fluttertoast.showToast(
        msg: 'onUserLeave#uid:$uid, reason:$reason',
        gravity: ToastGravity.CENTER);
    for (_UserSession session in _remoteSessions) {
      if (session.uid == uid) {
        NERtcVideoRenderer renderer = session.renderer;
        renderer?.dispose();
        _remoteSessions.remove(session);
        break;
      }
    }
    setState(() {});
  }

  @override
  void onUserVideoMute(int uid, bool muted) {
    Fluttertoast.showToast(
        msg: 'onUserVideoProfileUpdate#uid:$uid, muted:$muted',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onUserVideoProfileUpdate(int uid, int maxProfile) {
    Fluttertoast.showToast(
        msg:
            'onUserVideoProfileUpdate#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    Fluttertoast.showToast(
        msg:
            'onUserVideoStart#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
        gravity: ToastGravity.CENTER);
    setupVideoView(uid, maxProfile);
  }

  Future<void> setupVideoView(int uid, int maxProfile) async {
    NERtcVideoRenderer renderer =
        await VideoRendererFactory.createVideoRenderer();
    for (_UserSession session in _remoteSessions) {
      if (session.uid == uid) {
        session.renderer = renderer;
        session.renderer.addToRemoteVideoSink(uid);
        if (_settings.autoSubscribeVideo) {
          _engine.subscribeRemoteVideoStream(
              uid, NERtcRemoteVideoStreamType.high, true);
        }
        break;
      }
    }
    setState(() {});
  }

  @override
  void onUserVideoStop(int uid) {
    Fluttertoast.showToast(
        msg: 'onUserVideoStop#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList) {}

  @override
  void onLocalVideoStats(NERtcVideoSendStats stats) {}

  @override
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList) {}

  @override
  void onLocalAudioStats(NERtcAudioSendStats stats) {}

  @override
  void onRtcStats(NERtcStats stats) {}

  @override
  void onReJoinChannel(int result) {
    Fluttertoast.showToast(
        msg: 'onReJoinChannel#$result', gravity: ToastGravity.CENTER);
  }

  @override
  void onError(int code) {
    Fluttertoast.showToast(msg: 'onError#$code', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstAudioFrameDecoded(int uid) {
    Fluttertoast.showToast(
        msg: 'onFirstAudioFrameDecoded#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstVideoFrameDecoded(int uid, int width, int height) {
    Fluttertoast.showToast(
        msg: 'onFirstVideoFrameDecoded#uid:$uid, width:$width, height:$height',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onJoinChannel(int result, int channelId, int elapsed) {
    Fluttertoast.showToast(
        msg:
            'onJoinChannel#result:$result, channelId:$channelId, elapsed:$elapsed',
        gravity: ToastGravity.CENTER);
    updateSettings().then((value) {
      setState(() {});
    });
  }

  @override
  void onLocalAudioVolumeIndication(int volume) {}

  @override
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {}

  @override
  void onWarning(int code) {
    Fluttertoast.showToast(
        msg: 'onWarning#$code', gravity: ToastGravity.CENTER);
  }

  @override
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {}

  @override
  void onReconnectingStart() {
    Fluttertoast.showToast(
        msg: 'onReconnectingStart', gravity: ToastGravity.CENTER);
  }

  @override
  void onConnectionStateChanged(int state, int reason) {
    Fluttertoast.showToast(
        msg:
            'onConnectionStateChanged#state:${Utils.connectionState2String(state)}, reason:${Utils.connectionStateChangeReason2String(reason)}',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {
    Fluttertoast.showToast(
        msg:
            'onLiveStreamState#taskId:$taskId, liveState:${Utils.liveStreamState2String(liveState)}',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onAudioDeviceChanged(int selected) {
    Fluttertoast.showToast(
        msg: 'onAudioDeviceChanged#${Utils.audioDevice2String(selected)}',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onAudioDeviceStateChange(int deviceType, int deviceState) {
    Fluttertoast.showToast(
        msg:
            'onAudioDeviceStateChange#deviceType:${Utils.audioDeviceType2String(deviceType)}, deviceState:${Utils.audioDeviceState2String(deviceState)}',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onVideoDeviceStageChange(int deviceState) {
    Fluttertoast.showToast(
        msg:
            'onVideoDeviceStageChange#${Utils.videoDeviceState2String(deviceState)}',
        gravity: ToastGravity.CENTER);
  }
}

class _UserSession {
  int uid;
  NERtcVideoRenderer renderer;
}
