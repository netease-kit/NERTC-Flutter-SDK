// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

class CreateEngineRequest {
  String? appKey;
  String? logDir;
  int? logLevel;
  bool? audioAutoSubscribe;
  bool? audioDisableOverrideSpeakerOnReceiver;
  bool? audioDisableSWAECOnHeadset;
  bool? audioAINSEnabled;
  bool? serverRecordAudio;
  bool? serverRecordVideo;
  int? serverRecordMode;
  bool? serverRecordSpeaker;
  bool? publishSelfStream;
  bool? videoCaptureObserverEnabled;
  int? videoEncodeMode;
  int? videoDecodeMode;
  int? videoSendMode;
  bool? videoH265Enabled;
  bool? mode1v1Enabled;
}

class JoinChannelRequest {
  String? token;
  String? channelName;
  int? uid;
}

class SubscribeRemoteAudioRequest {
  int? uid;
  bool? subscribe;
}

class SetAudioProfileRequest {
  int? profile;
  int? scenario;
}

class SetLocalVideoConfigRequest {
  int? videoProfile;
  int? videoCropMode;
  bool? frontCamera;
  int? frameRate;
  int? minFrameRate;
  int? bitrate;
  int? minBitrate;
  int? degradationPrefer;
  int? width;
  int? height;
  int? cameraType;
  int? mirrorMode;
  int? orientationMode;
}

class StartScreenCaptureRequest {
  int? contentPrefer;
  int? videoProfile;
  int? frameRate;
  int? minFrameRate;
  int? bitrate;
  int? minBitrate;
}

class SubscribeRemoteVideoRequest {
  int? uid;
  int? streamType;
  bool? subscribe;
}

class SubscribeRemoteSubStreamVideoRequest {
  int? uid;
  bool? subscribe;
}

class SetupRemoteVideoRendererRequest {
  int? uid;
  int? textureId;
}

class SetupRemoteSubStreamVideoRendererRequest {
  int? uid;
  int? textureId;
}

class EnableAudioVolumeIndicationRequest {
  bool? enable;
  int? interval;
}

class IntValue {
  int? value;
}

class DoubleValue {
  double? value;
}

class BoolValue {
  bool? value;
}

class StringValue {
  String? value;
}

class StartAudioMixingRequest {
  String? path;
  int? loopCount;
  bool? sendEnabled;
  int? sendVolume;
  bool? playbackEnabled;
  int? playbackVolume;
}

class PlayEffectRequest {
  int? effectId;
  String? path;
  int? loopCount;
  bool? sendEnabled;
  int? sendVolume;
  bool? playbackEnabled;
  int? playbackVolume;
}

class SetEffectSendVolumeRequest {
  int? effectId;
  int? volume;
}

class SetEffectPlaybackVolumeRequest {
  int? effectId;
  int? volume;
}

class SetCameraFocusPositionRequest {
  double? x;
  double? y;
}

class EnableEarbackRequest {
  bool? enabled;
  int? volume;
}

class AddOrUpdateLiveStreamTaskRequest {
  int? serial;
  String? taskId;
  String? url;
  bool? serverRecordEnabled;
  int? liveMode;
  int? layoutWidth;
  int? layoutHeight;
  int? layoutBackgroundColor;
  String? layoutImageUrl;
  int? layoutImageX;
  int? layoutImageY;
  int? layoutImageWidth;
  int? layoutImageHeight;
  List? layoutUserTranscodingList;
}

class DeleteLiveStreamTaskRequest {
  int? serial;
  String? taskId;
}

class SetVideoRendererMirrorRequest {
  int? textureId;
  bool? mirror;
}

class SendSEIMsgRequest {
  String? seiMsg;
  int? streamType;
}

class ListValue {
  List? list;
}

class SetLocalVoiceEqualizationRequest {
  int? bandFrequency;
  int? bandGain;
}

class SwitchChannelRequest {
  String? token;
  String? channelName;
}

class StartAudioRecordingRequest {
  String? filePath;
  int? sampleRate;
  int? quality;
}

class SetLocalMediaPriorityRequest {
  int? priority;
  bool? isPreemptive;
}

class StartOrUpdateChannelMediaReplayRequest {
  Map<String, String>? sourceMediaInfo;
  Map<String, Map<String, String>>? destMediaInfo;
}

class AdjustUserPlaybackSignalVolumeRequest {
  int? uid;
  int? volume;
}

class EnableEncryptionRequest {
  String? key;
  int? mode;
  bool? enable;
}

@HostApi()
abstract class EngineApi {
  IntValue create(CreateEngineRequest request);

  @async
  IntValue release();

  IntValue setStatsEventCallback();

  IntValue clearStatsEventCallback();

  IntValue setChannelProfile(IntValue channelProfile);

  IntValue joinChannel(JoinChannelRequest request);

  IntValue leaveChannel();

  IntValue enableLocalAudio(BoolValue enable);

  IntValue subscribeRemoteAudio(SubscribeRemoteAudioRequest request);

  IntValue subscribeAllRemoteAudio(BoolValue subscribe);

  IntValue setAudioProfile(SetAudioProfileRequest request);

  IntValue enableDualStreamMode(BoolValue enable);

  IntValue setLocalVideoConfig(SetLocalVideoConfigRequest request);

  IntValue startVideoPreview();

  IntValue stopVideoPreview();

  IntValue enableLocalVideo(BoolValue enable);

  @async
  IntValue startScreenCapture(StartScreenCaptureRequest request);

  IntValue stopScreenCapture();

  IntValue subscribeRemoteVideo(SubscribeRemoteVideoRequest request);

  IntValue subscribeRemoteSubStreamVideo(
      SubscribeRemoteSubStreamVideoRequest request);

  IntValue muteLocalAudioStream(BoolValue mute);

  IntValue muteLocalVideoStream(BoolValue mute);

  IntValue startAudioDump();

  IntValue stopAudioDump();

  IntValue enableAudioVolumeIndication(
      EnableAudioVolumeIndicationRequest request);

  IntValue adjustRecordingSignalVolume(IntValue volume);

  IntValue adjustPlaybackSignalVolume(IntValue volume);

  IntValue addLiveStreamTask(AddOrUpdateLiveStreamTaskRequest request);

  IntValue updateLiveStreamTask(AddOrUpdateLiveStreamTaskRequest request);

  IntValue removeLiveStreamTask(DeleteLiveStreamTaskRequest request);

  IntValue setClientRole(IntValue role);

  IntValue getConnectionState();

  IntValue uploadSdkInfo();

  IntValue sendSEIMsg(SendSEIMsgRequest request);

  IntValue setAudioEffectPreset(IntValue preset);

  IntValue setVoiceBeautifierPreset(IntValue preset);

  IntValue setLocalVoicePitch(DoubleValue pitch);

  IntValue setLocalVoiceEqualization(SetLocalVoiceEqualizationRequest request);

  IntValue switchChannel(SwitchChannelRequest request);

  IntValue startAudioRecording(StartAudioRecordingRequest request);

  IntValue stopAudioRecording();

  IntValue setLocalMediaPriority(SetLocalMediaPriorityRequest request);

  IntValue startChannelMediaReplay(
      StartOrUpdateChannelMediaReplayRequest request);
  IntValue updateChannelMediaRelay(
      StartOrUpdateChannelMediaReplayRequest request);
  IntValue stopChannelMediaRelay();

  IntValue adjustUserPlaybackSignalVolume(
      AdjustUserPlaybackSignalVolumeRequest request);

  IntValue setLocalPublishFallbackOption(IntValue option);
  IntValue setRemoteSubscribeFallbackOption(IntValue option);

  IntValue enableSuperResolution(BoolValue enable);
  IntValue enableEncryption(EnableEncryptionRequest request);
}

@HostApi()
abstract class VideoRendererApi {
  IntValue createVideoRenderer();

  IntValue setMirror(SetVideoRendererMirrorRequest request);

  IntValue setupLocalVideoRenderer(IntValue textureId);

  IntValue setupRemoteVideoRenderer(SetupRemoteVideoRendererRequest request);

  IntValue setupLocalSubStreamVideoRenderer(IntValue textureId);

  IntValue setupRemoteSubStreamVideoRenderer(
      SetupRemoteSubStreamVideoRendererRequest request);

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

  IntValue setAudioFocusMode(IntValue focusMode);
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

  IntValue getEffectDuration(IntValue effectId);

  IntValue getEffectCurrentPosition(IntValue effectId);
}
