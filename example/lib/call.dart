import 'package:FLTNERTC/settings.dart';
import 'package:flutter/material.dart';
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
  // bool frontCamera = true;

  @override
  void initState() {
    super.initState();
    _initSettings().then((value) => _initRtcEngine());
  }

  Future<void> _initSettings() async {
    _settings = await Settings.getInstance();
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
      Align(
          alignment: Alignment(0.0, 0.9),
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: RawMaterialButton(
                    onPressed: () {
                      _onCallEnd(context);
                    },
                    child: new Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35,
                    ),
                    shape: new CircleBorder(),
                    elevation: 1.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(12.0),
                  )),
            ],
          ))
    ]);
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  // void _onSwitchCamera() {
  //   _engine.deviceManager.switchCamera().then((value) {
  //     if (value == 0) {
  //       frontCamera = !frontCamera;
  //       _localSession.renderer.setMirror(frontCamera);
  //     }
  //   });
  //   _localSession.renderer.setMirror(!_localSession.renderer.getMirrored());
  // }

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
        .then((value) => _engine.setStatsEventCallback(this))
        .then((value) => _initAudio())
        .then((value) => _initVideo())
        .then((value) => _initRenderer())
        .then((value) => _engine.joinChannel('', widget.cid, widget.uid));
  }

  Future<int> _initAudio() async {
    await _engine.enableLocalAudio(_settings.autoEnableAudio);
    return _engine.setAudioProfile(
        NERtcAudioProfile.values[_settings.audioProfile],
        NERtcAudioScenario.values[_settings.audioScenario]);
  }

  Future<int> _initVideo() async {
    await _engine.enableLocalVideo(_settings.autoEnableVideo);
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
    _localSession.renderer.setMirror(
        _settings.frontFacingCamera && _settings.frontFacingCameraMirror);
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
    print('onConnectionTypeChanged->' + newConnectionType.toString());
  }

  @override
  void onDisconnect(int reason) {
    print('onDisconnect->' + reason.toString());
  }

  @override
  void onFirstAudioDataReceived(int uid) {
    print('onFirstAudioDataReceived->' + uid.toString());
  }

  @override
  void onFirstVideoDataReceived(int uid) {
    print('onFirstVideoDataReceived->' + uid.toString());
  }

  @override
  void onLeaveChannel(int result) {
    print('onLeaveChannel->' + result.toString());
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    print('onUserAudioMute->' + uid.toString() + ', ' + muted.toString());
  }

  @override
  void onUserAudioStart(int uid) {
    print('onUserAudioStart->' + uid.toString());
  }

  @override
  void onUserAudioStop(int uid) {
    print('onUserAudioStop->' + uid.toString());
  }

  @override
  void onUserJoined(int uid) {
    print('onUserJoined->' + uid.toString());
    _UserSession session = _UserSession();
    session.uid = uid;
    _remoteSessions.add(session);
    setState(() {});
  }

  @override
  void onUserLeave(int uid, int reason) {
    print('onUserLeave->' + uid.toString() + ', ' + reason.toString());
  }

  @override
  void onUserVideoMute(int uid, bool muted) {
    print('onUserVideoMute->' + uid.toString() + ', ' + muted.toString());
  }

  @override
  void onUserVideoProfileUpdate(int uid, int maxProfile) {
    print('onUserVideoProfileUpdate->' +
        uid.toString() +
        ', ' +
        maxProfile.toString());
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    print('onUserVideoStart->' + uid.toString() + ', ' + maxProfile.toString());
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
  void onUserVideoStop(int uid) {}

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
  void onReJoinChannel(int result) {}

  @override
  void onError(int code) {}

  @override
  void onFirstAudioFrameDecoded(int uid) {}

  @override
  void onFirstVideoFrameDecoded(int uid, int width, int height) {}

  @override
  void onJoinChannel(int result, int channelId, int elapsed) {}

  @override
  void onLocalAudioVolumeIndication(int volume) {}

  @override
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {}

  @override
  void onWarning(int code) {}

  @override
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {}

  @override
  void onReconnectingStart() {}

  @override
  void onConnectionStateChanged(int state, int reason) {}

  @override
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {}

  @override
  void onAudioDeviceChanged(int selected) {}

  @override
  void onAudioDeviceStateChange(int deviceType, int deviceState) {}

  @override
  void onVideoDeviceStageChange(int deviceState) {}
}

class _UserSession {
  int uid;
  NERtcVideoRenderer renderer;
}
