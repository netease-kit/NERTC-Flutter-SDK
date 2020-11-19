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
    with NERtcChannelEventCallback, NERtcStatsEventCallback {
  NERtcEngine _engine = NERtcEngine();
  _UserSession _localSession = _UserSession();
  _UserSession _remoteSession = _UserSession();

  @override
  void initState() {
    super.initState();
    _initLocalUserSession();
    _initRtcEngine();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: buildCallingWidget(context),
      ),
      // ignore: missing_return
      onWillPop: () {
        _requestPop();
      },
    );
  }

  Future<void> _initRenderers() async {
    _localSession.renderer = await VideoRendererFactory.createVideoRenderer();
    setState(() {});
  }

  Widget buildCallingWidget(BuildContext context) {
    return Stack(children: <Widget>[
      buildCallingVideoViewWidget(context),
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

  Widget buildCallingVideoViewWidget(BuildContext context) {
    if (_remoteSession.renderer != null && _localSession.renderer != null) {
      NERtcVideoRenderer big = _remoteSession.renderer;
      NERtcVideoRenderer small = _localSession.renderer;
      return Stack(children: <Widget>[
        NERtcVideoView(big),
        Align(
          alignment: Alignment(0.9, -0.9),
          child: Container(
            width: 150,
            height: 200,
            child: NERtcVideoView(small),
          ),
        ),
      ]);
    } else if (_localSession.renderer != null) {
      return NERtcVideoView(_localSession.renderer);
    } else {
      return Container();
    }
  }

  void _requestPop() {
    Navigator.pop(context);
  }

  Future<void> _startLocalVideoPreview() async {
    _engine.enableLocalVideo(true);
    _localSession.renderer.addToLocalVideoSink();
    NERtcVideoConfig config = NERtcVideoConfig();
    config.videoProfile = NERtcVideoProfile.hd720p;
    _engine.setLocalVideoConfig(config);
    _engine.startVideoPreview();
  }

  void _initLocalUserSession() {
    _localSession.uid = widget.uid;
  }

  void _initRtcEngine() async {
    await _initParameters();
    await _initRenderers();
    _startLocalVideoPreview();
    _engine.joinChannel('', widget.cid, widget.uid);
  }

  Future<void> _initParameters() async {
    NERtcOptions options = NERtcOptions(
        autoSubscribeAudio: true,
        videoEncodeMode: NERtcMediaCodecMode.software,
        videoDecodeMode: NERtcMediaCodecMode.software);
    _engine.create(
        appKey: Config.APP_KEY, channelEventCallback: this, options: options);
    _engine.setStatsEventCallback(this);
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
    if (_remoteSession.renderer != null) {
      _remoteSession.renderer.dispose();
      _remoteSession.renderer = null;
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
    _remoteSession.uid = uid;
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
    _remoteSession.renderer = await VideoRendererFactory.createVideoRenderer();
    _remoteSession.renderer.addToRemoteVideoSink(uid);
    _engine.subscribeRemoteVideoStream(
        uid, NERtcRemoteVideoStreamType.high, true);
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
}

class _UserSession {
  int uid;
  NERtcVideoRenderer renderer;
}
