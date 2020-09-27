import 'package:pigeon/pigeon.dart';

class CreateEngineRequest {
  String appKey;
  String logDir;
  int logLevel;
  bool autoSubscribeAudio;
  int videoEncodeMode;
  int videoDecodeMode;
  bool serverRecordAudio;
  bool serverRecordVideo;
  bool videoAdapt;
  int serverRecordMode;
  bool serverRecordSpeaker;
  bool publishSelfStream;
  int channelProfile;
}

class JoinChannelRequest {
  String token;
  String channelName;
  int uid;
}

class SubscribeRemoteAudioStreamRequest {
  int uid;
  bool subscribe;
}

class SetAudioProfileRequest {
  int profile;
  int scenario;
}

class SetLocalVideoConfigRequest {
  int videoProfile;
  int videoCropMode;
  bool frontCamera;
}

class SubscribeRemoteVideoStreamRequest {
  int uid;
  int streamType;
  bool subscribe;
}

class SetupRemoteVideoRendererRequest {
  int uid;
  int textureId;
}

class EnableAudioVolumeIndicationRequest {
  bool enable;
  int interval;
}

class IntValue {
  int value;
}

class DoubleValue {
  double value;
}

class BoolValue {
  bool value;
}

class StartAudioMixingRequest {
  String path;
  int loopCount;
  bool sendEnabled;
  int sendVolume;
  bool playbackEnabled;
  int playbackVolume;
}

class PlayEffectRequest {
  int effectId;
  String path;
  int loopCount;
  bool sendEnabled;
  int sendVolume;
  bool playbackEnabled;
  int playbackVolume;
}

class SetEffectSendVolumeRequest {
  int effectId;
  int volume;
}

class SetEffectPlaybackVolumeRequest {
  int effectId;
  int volume;
}

class SetCameraFocusPositionRequest {
  double x;
  double y;
}

class EnableEarbackRequest {
  bool enabled;
  int volume;
}

@HostApi()
abstract class EngineApi {
  IntValue create(CreateEngineRequest request);
  void release();
  IntValue setStatsEventCallback();
  IntValue clearStatsEventCallback();
  IntValue joinChannel(JoinChannelRequest request);
  IntValue leaveChannel();
  IntValue enableLocalAudio(BoolValue enable);
  IntValue subscribeRemoteAudioStream(
      SubscribeRemoteAudioStreamRequest request);
  IntValue subscribeAllRemoteAudioStreams(BoolValue subscribe);
  IntValue setAudioProfile(SetAudioProfileRequest request);
  IntValue setLocalVideoConfig(SetLocalVideoConfigRequest request);
  IntValue startVideoPreview();
  IntValue stopVideoPreview();
  IntValue enableLocalVideo(BoolValue enable);
  IntValue startScreenCapture(IntValue screenProfile);
  IntValue stopScreenCapture();
  IntValue subscribeRemoteVideoStream(
      SubscribeRemoteVideoStreamRequest request);
  IntValue muteLocalAudioStream(BoolValue mute);
  IntValue muteLocalVideoStream(BoolValue mute);
  IntValue startAudioDump();
  IntValue stopAudioDump();
  IntValue enableAudioVolumeIndication(
      EnableAudioVolumeIndicationRequest request);
  IntValue adjustRecordingSignalVolume(IntValue volume);
  IntValue adjustPlaybackSignalVolume(IntValue volume);
}

@HostApi()
abstract class VideoRendererApi {
  IntValue createVideoRenderer();
  IntValue setupLocalVideoRenderer(IntValue textureId);
  IntValue setupRemoteVideoRenderer(SetupRemoteVideoRendererRequest request);
  void disposeVideoRenderer(IntValue textureId);
}

@HostApi()
abstract class DeviceManagerApi {
  IntValue setDeviceEventCallback();
  IntValue clearDeviceEventCallback();
  BoolValue isSpeakerphoneOn();
  IntValue setSpeakerphoneOn(BoolValue enable);
  IntValue switchCamera();
  IntValue setCameraZoomFactor(IntValue factor);
  DoubleValue getCameraMaxZoom();
  IntValue setCameraTorchOn(BoolValue on);
  IntValue setCameraFocusPosition(SetCameraFocusPositionRequest request);
  IntValue setPlayoutDeviceMute(BoolValue mute);
  BoolValue isPlayoutDeviceMute();
  IntValue setRecordDeviceMute(BoolValue mute);
  BoolValue isRecordDeviceMute();
  IntValue enableEarback(EnableEarbackRequest request);
  IntValue setEarbackVolume(IntValue volume);
}

@HostApi()
abstract class AudioMixingApi {
  IntValue setAudioMixingEventCallback();
  IntValue clearAudioMixingEventCallback();
  IntValue startAudioMixing(StartAudioMixingRequest request);
  IntValue stopAudioMixing();
  IntValue pauseAudioMixing();
  IntValue resumeAudioMixing();
  IntValue setAudioMixingSendVolume(IntValue volume);
  IntValue getAudioMixingSendVolume();
  IntValue setAudioMixingPlaybackVolume(IntValue volume);
  IntValue getAudioMixingPlaybackVolume();
  IntValue getAudioMixingDuration();
  IntValue getAudioMixingCurrentPosition();
  IntValue setAudioMixingPosition(IntValue position);
}

@HostApi()
abstract class AudioEffectApi {
  IntValue setAudioEffectEventCallback();
  IntValue clearAudioEffectEventCallback();
  IntValue playEffect(PlayEffectRequest request);
  IntValue stopEffect(IntValue effectId);
  IntValue stopAllEffects();
  IntValue pauseEffect(IntValue effectId);
  IntValue resumeEffect(IntValue effectId);
  IntValue pauseAllEffects();
  IntValue resumeAllEffects();
  IntValue setEffectSendVolume(SetEffectSendVolumeRequest request);
  IntValue getEffectSendVolume(IntValue effectId);
  IntValue setEffectPlaybackVolume(SetEffectPlaybackVolumeRequest request);
  IntValue getEffectPlaybackVolume(IntValue effectId);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/src/internal/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FLT';
  opts.javaOut = 'android/src/main/java/com/netease/nertcflutter/Messages.java';
  opts.javaOptions.package = 'com.netease.nertcflutter';
}
