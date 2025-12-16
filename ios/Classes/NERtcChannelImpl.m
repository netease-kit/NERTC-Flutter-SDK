// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NERtcChannelImpl.h"
#import <NERtcSDK/NERtcSDK.h>
#import <NERtcSDk/NERtcEngineEnum.h>
#import "NERtcChannelManager.h"
#import "NERtcSubCallbackImpl.h"

@interface NERtcChannelImpl ()
@property(nonatomic, weak) NSObject<FlutterBinaryMessenger> *messenger;
@end

@implementation NERtcChannelImpl

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

#pragma mark - NEFLTChannelApi

- (nullable NSString *)getChannelNameChannelTag:(NSString *)channelTag
                                          error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @"";
  }
  return [channel getChannelName];
}

- (nullable NSNumber *)setStatsEventCallbackChannelTag:(NSString *)channelTag
                                                 error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  id<NERtcChannelMediaStatsObserver> observer =
      [[NERtcChannelManager sharedInstance] createStatsObserver:channelTag];
  [channel addChannelMediaStatsObserver:observer];
  return @(0);
}

- (nullable NSNumber *)clearStatsEventCallbackChannelTag:(NSString *)channelTag
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  id<NERtcChannelMediaStatsObserver> observer =
      [[NERtcChannelManager sharedInstance] createStatsObserver:channelTag];
  [channel removeChannelMediaStatsObserver:observer];
  return @(0);
}

- (nullable NSNumber *)setChannelProfileChannelTag:(NSString *)channelTag
                                    channelProfile:(NSNumber *)channelProfile
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  //    int result = [channel setChannelProfile:(NERtcChannelProfileType)channelProfile.intValue];
  //    return @(result);
  return @(-1);
}

- (nullable NSNumber *)enableMediaPubChannelTag:(NSString *)channelTag
                                      mediaType:(NSNumber *)mediaType
                                         enable:(NSNumber *)enable
                                          error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel enableMediaPub:enable.boolValue
                         withMediaType:mediaType.unsignedIntegerValue];
  return @(result);
}

- (nullable NSNumber *)joinChannelChannelTag:(NSString *)channelTag
                                     request:(NEFLTJoinChannelRequest *)request
                                       error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NSNumber *result = [[NSNumber alloc] init];
  NERtcJoinChannelOptions *opts =
      request.channelOptions == nil ? nil : [[NERtcJoinChannelOptions alloc] init];
  if (request.channelOptions != nil) {
    opts.customInfo = request.channelOptions.customInfo;
    opts.permissionKey = request.channelOptions.permissionKey;
  }

  int ret = [channel
      joinChannelWithToken:request.token
                     myUid:request.uid.unsignedLongLongValue
            channelOptions:opts
                completion:^(NSError *_Nullable error, uint64_t channelId, uint64_t elapesd,
                             uint64_t uid, NERtcJoinChannelExtraInfo *_Nullable info) {

#ifdef DEBUG
                  NSLog(@"FlutterCalled:NERtcChannelEventSink#onJoinChannelResult");
#endif

                  id<NERtcChannelDelegate> callback =
                      [[NERtcChannelManager sharedInstance] getCallback:channelTag];

                  // 检查并转换为具体的实现类
                  if (callback && [callback isKindOfClass:[NERtcSubCallbackImpl class]]) {
                    NERtcSubCallbackImpl *subCallback = (NERtcSubCallbackImpl *)callback;
                    [subCallback onNERtcChannelDidJoinChannelWithResult:(NERtcError)error.code
                                                              channelId:channelId
                                                                elapsed:elapesd
                                                                 userID:uid];
                  }
                  // 子房间不需要做
                  //[self configureEngineOnJoinedChannel];
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)leaveChannelChannelTag:(NSString *)channelTag
                                        error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel leaveChannel];
  return @(ret);
}

- (nullable NSNumber *)setClientRoleChannelTag:(NSString *)channelTag
                                          role:(NSNumber *)role
                                         error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel setClientRole:(NERtcClientRole)role.intValue];
  return @(result);
}

- (nullable NSNumber *)getConnectionStateChannelTag:(NSString *)channelTag
                                              error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NERtcConnectionStateType state = [channel connectionState];
  return @(state);
}

- (nullable NSNumber *)releaseChannelTag:(NSString *)channelTag
                                   error:(FlutterError *_Nullable *_Nonnull)error {
  [[NERtcChannelManager sharedInstance] releaseChannel:channelTag];
  return @(0);
}

- (nullable NSNumber *)enableLocalAudioChannelTag:(NSString *)channelTag
                                           enable:(NSNumber *)enable
                                            error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel enableLocalAudio:enable.boolValue];
  return @(result);
}

- (nullable NSNumber *)muteLocalAudioStreamChannelTag:(NSString *)channelTag
                                                 mute:(NSNumber *)mute
                                                error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel muteLocalAudio:mute.boolValue];
  return @(result);
}

- (nullable NSNumber *)subscribeRemoteAudioChannelTag:(NSString *)channelTag
                                                  uid:(NSNumber *)uid
                                            subscribe:(NSNumber *)subscribe
                                                error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel subscribeRemoteAudio:subscribe.boolValue
                                   forUserID:uid.unsignedLongLongValue];
  return @(result);
}

- (nullable NSNumber *)subscribeRemoteSubAudioChannelTag:(NSString *)channelTag
                                                     uid:(NSNumber *)uid
                                               subscribe:(NSNumber *)subscribe
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel subscribeRemoteSubStreamAudio:subscribe.boolValue
                                            forUserID:uid.unsignedLongLongValue];
  return @(result);
}

- (nullable NSNumber *)setLocalVideoConfigChannelTag:(NSString *)channelTag
                                             request:(NEFLTSetLocalVideoConfigRequest *)request
                                               error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

#ifdef DEBUG
  NSLog(@"FlutterCalled:ChannelApi#setLocalVideoConfig");
#endif
  NERtcVideoEncodeConfiguration *config = [[NERtcVideoEncodeConfiguration alloc] init];
  config.maxProfile = request.videoProfile.unsignedIntegerValue;
  config.cropMode = request.videoCropMode.unsignedIntegerValue;
  config.bitrate = request.bitrate.integerValue;
  config.minBitrate = request.minBitrate.integerValue;
  config.frameRate = request.frameRate.integerValue;
  config.minFrameRate = request.minBitrate.intValue;
  config.degradationPreference = request.degradationPrefer.unsignedIntegerValue;
  config.width = request.width.intValue;
  config.height = request.height.intValue;
  config.orientationMode = request.orientationMode.unsignedIntegerValue;
  config.mirrorMode = request.mirrorMode.unsignedIntegerValue;

  int ret = -1;
  if (request.streamType == nil) {
    ret = [channel setLocalVideoConfig:config];
  } else {
    NERtcStreamChannelType streamType = (NERtcStreamChannelType)request.streamType.intValue;
    ret = [channel setLocalVideoConfig:config streamType:streamType];
  }
  return @(ret);
}

- (nullable NSNumber *)enableLocalVideoChannelTag:(NSString *)channelTag
                                          request:(NEFLTEnableLocalVideoRequest *)request
                                            error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = -1;
  if (request.streamType == nil) {
    ret = [channel enableLocalVideo:request.enable.boolValue];
  } else {
    ret = [channel enableLocalVideo:request.enable.boolValue
                         streamType:(NERtcStreamChannelType)request.streamType.intValue];
  }
  return @(ret);
}

- (nullable NSNumber *)muteLocalVideoStreamChannelTag:(NSString *)channelTag
                                                 mute:(NSNumber *)mute
                                           streamType:(NSNumber *)streamType
                                                error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel muteLocalVideo:mute.boolValue
                         streamType:(NERtcStreamChannelType)streamType.intValue];
  return @(ret);
}

- (nullable NSNumber *)switchCameraChannelTag:(NSString *)channelTag
                                        error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int result = [channel switchCamera];
  return @(result);
}

- (nullable NSNumber *)
    subscribeRemoteVideoStreamChannelTag:(NSString *)channelTag
                                 request:(NEFLTSubscribeRemoteVideoStreamRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel subscribeRemoteVideo:request.subscribe.boolValue
                                forUserID:request.uid.unsignedLongLongValue
                               streamType:(NERtcRemoteVideoStreamType)request.streamType.intValue];
  return @(ret);
}

- (nullable NSNumber *)subscribeRemoteSubVideoStreamChannelTag:(NSString *)channelTag
                                                           uid:(NSNumber *)uid
                                                     subscribe:(NSNumber *)subscribe
                                                         error:(FlutterError *_Nullable *_Nonnull)
                                                                   error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel subscribeRemoteSubStreamVideo:subscribe.boolValue
                                         forUserID:uid.unsignedLongLongValue];
  return @(ret);
}

- (nullable NSNumber *)
    enableAudioVolumeIndicationChannelTag:(NSString *)channelTag
                                  request:(NEFLTEnableAudioVolumeIndicationRequest *)request
                                    error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel enableAudioVolumeIndication:request.enable.boolValue
                                        interval:request.interval.intValue
                                             vad:request.vad.boolValue];
  return @(ret);
}

- (nullable NSNumber *)takeLocalSnapshotChannelTag:(NSString *)channelTag
                                        streamType:(NSNumber *)streamType
                                              path:(NSString *)path
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel
      takeLocalSnapshot:(NERtcStreamChannelType)streamType.intValue
               callback:^(int errorCode, UIImage *_Nullable image) {
                 if (image != nil) {
                   NSData *imageData = nil;
                   NSString *extension = [path pathExtension].lowercaseString;

                   if ([extension isEqualToString:@"png"]) {
                     imageData = UIImagePNGRepresentation(image);
                   } else if ([extension isEqualToString:@"jpg"] ||
                              [extension isEqualToString:@"jpeg"]) {
                     imageData = UIImageJPEGRepresentation(image, 1.0);
                   } else {
                     NSLog(@"[NERtcChannelImpl] Unsupported image format: %@", extension);
                     return;
                   }

                   if (imageData != nil) {
                     [imageData writeToFile:path atomically:YES];
                   }
                 }

                 // 通知 Flutter 层截图结果
                 id<NERtcChannelDelegate> callback =
                     [[NERtcChannelManager sharedInstance] getCallback:channelTag];
                 if (callback && [callback isKindOfClass:[NERtcSubCallbackImpl class]]) {
                   NERtcSubCallbackImpl *subCallback = (NERtcSubCallbackImpl *)callback;
                   [subCallback onNERtcChannelDidTakeSnapshotWithResult:@(errorCode) path:path];
                 }
               }];

  return @(ret);
}

- (nullable NSNumber *)takeRemoteSnapshotChannelTag:(NSString *)channelTag
                                                uid:(NSNumber *)uid
                                         streamType:(NSNumber *)streamType
                                               path:(NSString *)path
                                              error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  int ret = [channel
      takeRemoteSnapshot:(NERtcStreamChannelType)streamType.intValue
               forUserID:uid.unsignedLongLongValue
                callback:^(int errorCode, UIImage *_Nullable image) {
                  if (image != nil) {
                    NSData *imageData = nil;
                    NSString *extension = [path pathExtension].lowercaseString;

                    if ([extension isEqualToString:@"png"]) {
                      imageData = UIImagePNGRepresentation(image);
                    } else if ([extension isEqualToString:@"jpg"] ||
                               [extension isEqualToString:@"jpeg"]) {
                      imageData = UIImageJPEGRepresentation(image, 1.0);
                    } else {
                      NSLog(@"[NERtcChannelImpl] Unsupported image format: %@", extension);
                      return;
                    }

                    if (imageData != nil) {
                      [imageData writeToFile:path atomically:YES];
                    }
                  }

                  // 通知 Flutter 层截图结果
                  id<NERtcChannelDelegate> callback =
                      [[NERtcChannelManager sharedInstance] getCallback:channelTag];

                  if (callback && [callback isKindOfClass:[NERtcSubCallbackImpl class]]) {
                    NERtcSubCallbackImpl *subCallback = (NERtcSubCallbackImpl *)callback;
                    [subCallback onNERtcChannelDidTakeSnapshotWithResult:@(errorCode) path:path];
                  }
                }];

  return @(ret);
}

- (nullable NSNumber *)subscribeAllRemoteAudioChannelTag:(NSString *)channelTag
                                               subscribe:(NSNumber *)subscribe
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel subscribeAllRemoteAudio:subscribe.boolValue];
  return @(result);
}

- (nullable NSNumber *)setCameraCaptureConfigChannelTag:(NSString *)channelTag
                                                request:
                                                    (NEFLTSetCameraCaptureConfigRequest *)request
                                                  error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NERtcCameraCaptureConfiguration *config = [[NERtcCameraCaptureConfiguration alloc] init];

  if (request.captureWidth != nil) {
    config.captureWidth = request.captureWidth.intValue;
  }

  if (request.captureHeight != nil) {
    config.captureHeight = request.captureHeight.intValue;
  }

  int result = -1;
  if (request.streamType == nil) {
    result = [channel setCameraCaptureConfig:config];
  } else {
    NERtcStreamChannelType streamType = (NERtcStreamChannelType)request.streamType.intValue;
    result = [channel setCameraCaptureConfig:config streamType:streamType];
  }
  return @(result);
}

- (nullable NSNumber *)setVideoStreamLayerCountChannelTag:(NSString *)channelTag
                                               layerCount:(NSNumber *)layerCount
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcVideoStreamLayerCount count = kNERtcVideoStreamLayerCountOne;
  if (layerCount != nil) {
    if (layerCount.intValue == 2) {
      count = kNERtcVideoStreamLayerCountTwo;
    } else if (layerCount.intValue == 3) {
      count = kNERtcVideoStreamLayerCountThree;
    }
  }
  int result = [channel setVideoStreamLayerCount:count];
  return @(result);
}

- (nullable NSNumber *)getFeatureSupportedTypeChannelTag:(NSString *)channelTag
                                                    type:(NSNumber *)type
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  return @(30004);
}

- (nullable NSNumber *)switchCameraWithPositionChannelTag:(NSString *)channelTag
                                                 position:(NSNumber *)position
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel switchCameraWithPosition:position.intValue];
  return @(result);
}

- (void)startScreenCaptureChannelTag:(NSString *)channelTag
                             request:(NEFLTStartScreenCaptureRequest *)request
                          completion:
                              (void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    completion(@(-1), nil);
    return;
  }

  NERtcVideoSubStreamEncodeConfiguration *config =
      [[NERtcVideoSubStreamEncodeConfiguration alloc] init];

  if (request.contentPrefer != nil) {
    config.contentPrefer = (NERtcSubStreamContentPrefer)request.contentPrefer.intValue;
  }

  // NERtcBaseVideoEncodeConfiguration maxProfile
  if (request.videoProfile != nil) {
    config.maxProfile = request.videoProfile.intValue;
  }

  if (request.frameRate != nil) {
    config.frameRate = (NERtcVideoFrameRate)request.frameRate.intValue;
  }

  if (request.minFrameRate != nil) {
    config.minFrameRate = request.minFrameRate.intValue;
  }

  if (request.bitrate != nil) {
    config.bitrate = request.bitrate.intValue;
  }

  if (request.minBitrate != nil) {
    config.minBitrate = request.minBitrate.intValue;
  }

  int result = [channel startScreenCapture:config];
  completion(@(result), nil);
}

- (nullable NSNumber *)stopScreenCaptureChannelTag:(NSString *)channelTag
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  [channel stopScreenCapture];
  return @(0);
}

- (nullable NSNumber *)enableLoopbackRecordingChannelTag:(NSString *)channelTag
                                                  enable:(NSNumber *)enable
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  return @(30004);
}

- (nullable NSNumber *)
    adjustLoopBackRecordingSignalVolumeChannelTag:(NSString *)channelTag
                                           volume:(NSNumber *)volume
                                            error:(FlutterError *_Nullable *_Nonnull)error {
  return @(30004);
}

- (nullable NSNumber *)setExternalVideoSourceChannelTag:(NSString *)channelTag
                                             streamType:(NSNumber *)streamType
                                                 enable:(NSNumber *)enable
                                                  error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcStreamChannelType type = (NERtcStreamChannelType)streamType.intValue;
  int result = [channel setExternalVideoSource:enable.boolValue streamType:type];
  return @(result);
}

- (nullable NSNumber *)pushExternalVideoFrameChannelTag:(NSString *)channelTag
                                             streamType:(NSNumber *)streamType
                                                  frame:(NEFLTVideoFrame *)frame
                                                  error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NSData *buffer = [[NSData alloc] initWithBytes:frame.data.data.bytes
                                          length:frame.data.data.length];
  NERtcVideoFrame *videoFrame = [[NERtcVideoFrame alloc] init];
  videoFrame.width = frame.width.unsignedIntValue;
  videoFrame.height = frame.height.unsignedIntValue;
  videoFrame.buffer = (void *)[buffer bytes];
  videoFrame.timestamp = frame.timeStamp.unsignedLongLongValue;
  videoFrame.format = frame.format.unsignedIntegerValue;
  switch (frame.rotation.unsignedIntegerValue) {
    case 90:
      videoFrame.rotation = kNERtcVideoRotation_90;
      break;

    case 180:
      videoFrame.rotation = kNERtcVideoRotation_180;
      break;

    case 270:
      videoFrame.rotation = kNERtcVideoRotation_270;
      break;

    case 0:
    default:
      videoFrame.rotation = kNERtcVideoRotation_0;
      break;
  }
  int ret = [channel pushExternalVideoFrame:videoFrame streamType:streamType.unsignedIntegerValue];
  return ret ? @(0) : @(-1);
}

- (nullable NSNumber *)addLiveStreamTaskChannelTag:(NSString *)channelTag
                                           request:(NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NSNumber *result = [[NSNumber alloc] init];
  NERtcLiveStreamTaskInfo *taskInfo = [[NERtcLiveStreamTaskInfo alloc] init];
  NSNumber *serial = request.serial;
  if (request.taskId != nil) {
    taskInfo.taskID = request.taskId;
  }
  if (request.url != nil) {
    taskInfo.streamURL = request.url;
  }
  if (request.serverRecordEnabled != nil) {
    taskInfo.serverRecordEnabled = request.serverRecordEnabled.boolValue;
  }
  if (request.liveMode != nil) {
    taskInfo.lsMode = request.liveMode.integerValue;
  }
  NERtcLiveStreamLayout *layout = [[NERtcLiveStreamLayout alloc] init];
  taskInfo.layout = layout;
  if (request.layoutWidth != nil) {
    layout.width = request.layoutWidth.integerValue;
  }
  if (request.layoutHeight != nil) {
    layout.height = request.layoutHeight.integerValue;
  }
  if (request.layoutBackgroundColor != nil) {
    layout.backgroundColor = request.layoutBackgroundColor.integerValue & 0x00FFFFFF;
  }
  NERtcLiveStreamImageInfo *imageInfo = [[NERtcLiveStreamImageInfo alloc] init];
  if (request.layoutImageUrl != nil) {
    imageInfo.url = request.layoutImageUrl;
    // 服务器根据Url来判断Image Info 是否合法, 不合法情况下不能有Image节点参数
    layout.bgImage = imageInfo;
  }
  if (request.layoutImageX != nil) {
    imageInfo.x = request.layoutImageX.integerValue;
  }
  if (request.layoutImageY != nil) {
    imageInfo.y = request.layoutImageY.integerValue;
  }
  if (request.layoutImageWidth != nil) {
    imageInfo.width = request.layoutImageWidth.integerValue;
  }
  if (request.layoutImageHeight != nil) {
    imageInfo.height = request.layoutImageHeight.integerValue;
  }
  NSMutableArray *userTranscodingArray = [[NSMutableArray alloc] init];
  if (request.layoutUserTranscodingList != nil) {
    for (id dict in request.layoutUserTranscodingList) {
      NERtcLiveStreamUserTranscoding *userTranscoding =
          [[NERtcLiveStreamUserTranscoding alloc] init];
      NSNumber *uid = dict[@"uid"];
      if ((NSNull *)uid != [NSNull null]) {
        userTranscoding.uid = uid.unsignedLongLongValue;
      }
      NSNumber *videoPush = dict[@"videoPush"];
      if ((NSNull *)videoPush != [NSNull null]) {
        userTranscoding.videoPush = videoPush.boolValue;
      }
      NSNumber *audioPush = dict[@"audioPush"];
      if ((NSNull *)audioPush != [NSNull null]) {
        userTranscoding.audioPush = audioPush.boolValue;
      }
      NSNumber *adaption = dict[@"adaption"];
      if ((NSNull *)adaption != [NSNull null]) {
        userTranscoding.adaption = adaption.intValue;
      }
      NSNumber *x = dict[@"x"];
      if ((NSNull *)x != [NSNull null]) {
        userTranscoding.x = x.integerValue;
      }
      NSNumber *y = dict[@"y"];
      if ((NSNull *)y != [NSNull null]) {
        userTranscoding.y = y.integerValue;
      }
      NSNumber *width = dict[@"width"];
      if ((NSNull *)width != [NSNull null]) {
        userTranscoding.width = width.integerValue;
      }
      NSNumber *height = dict[@"height"];
      if ((NSNull *)height != [NSNull null]) {
        userTranscoding.height = height.integerValue;
      }
      [userTranscodingArray addObject:userTranscoding];
    }
  }
  layout.users = userTranscodingArray;
  taskInfo.layout = layout;

  int ret =
      [channel addLiveStreamTask:taskInfo
                      compeltion:^(NSString *_Nonnull taskId, kNERtcLiveStreamError errorCode) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                          NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                          [dictionary setValue:serial forKey:@"serial"];
                          NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
                          [arguments setValue:taskId forKey:@"taskId"];
                          [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
                          [dictionary setValue:arguments forKey:@"arguments"];
                          // todo
                          //  [self->_liveTaskEventSink
                          //      onAddLiveStreamTaskTaskId:taskId
                          //                        errCode:[NSNumber numberWithInt:errorCode]
                          //                     completion:^(FlutterError *_Nullable error){
                          //                     }];
                        });
                      }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)updateLiveStreamTaskChannelTag:(NSString *)channelTag
                                              request:
                                                  (NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NSNumber *result = [[NSNumber alloc] init];
  NERtcLiveStreamTaskInfo *taskInfo = [[NERtcLiveStreamTaskInfo alloc] init];
  NSNumber *serial = request.serial;
  if (request.taskId != nil) {
    taskInfo.taskID = request.taskId;
  }
  if (request.url != nil) {
    taskInfo.streamURL = request.url;
  }
  if (request.serverRecordEnabled != nil) {
    taskInfo.serverRecordEnabled = request.serverRecordEnabled.boolValue;
  }
  if (request.liveMode != nil) {
    taskInfo.lsMode = request.liveMode.intValue;
  }
  NERtcLiveStreamLayout *layout = [[NERtcLiveStreamLayout alloc] init];
  taskInfo.layout = layout;
  if (request.layoutWidth != nil) {
    layout.width = request.layoutWidth.intValue;
  }
  if (request.layoutHeight != nil) {
    layout.height = request.layoutHeight.intValue;
  }
  if (request.layoutBackgroundColor != nil) {
    layout.backgroundColor = request.layoutBackgroundColor.intValue & 0x00FFFFFF;
  }
  NERtcLiveStreamImageInfo *imageInfo = [[NERtcLiveStreamImageInfo alloc] init];
  if (request.layoutImageUrl != nil) {
    imageInfo.url = request.layoutImageUrl;
    // 服务器根据Url来判断Image Info 是否合法, 不合法情况下不能有Image节点参数
    layout.bgImage = imageInfo;
  }
  if (request.layoutImageX != nil) {
    imageInfo.x = request.layoutImageX.intValue;
  }
  if (request.layoutImageY != nil) {
    imageInfo.y = request.layoutImageY.intValue;
  }
  if (request.layoutImageWidth != nil) {
    imageInfo.width = request.layoutImageWidth.intValue;
  }
  if (request.layoutImageHeight != nil) {
    imageInfo.height = request.layoutImageHeight.intValue;
  }
  NSMutableArray *userTranscodingArray = [NSMutableArray array];
  layout.users = userTranscodingArray;
  if (request.layoutUserTranscodingList != nil) {
    for (id dict in request.layoutUserTranscodingList) {
      NERtcLiveStreamUserTranscoding *userTranscoding =
          [[NERtcLiveStreamUserTranscoding alloc] init];
      NSNumber *uid = dict[@"uid"];
      if ((NSNull *)uid != [NSNull null]) {
        userTranscoding.uid = uid.unsignedLongLongValue;
      }
      NSNumber *videoPush = dict[@"videoPush"];
      if ((NSNull *)videoPush != [NSNull null]) {
        userTranscoding.videoPush = videoPush.boolValue;
      }
      NSNumber *audioPush = dict[@"audioPush"];
      if ((NSNull *)audioPush != [NSNull null]) {
        userTranscoding.audioPush = audioPush.boolValue;
      }
      NSNumber *adaption = dict[@"adaption"];
      if ((NSNull *)adaption != [NSNull null]) {
        userTranscoding.adaption = adaption.intValue;
      }
      NSNumber *x = dict[@"x"];
      if ((NSNull *)x != [NSNull null]) {
        userTranscoding.x = x.intValue;
      }
      NSNumber *y = dict[@"y"];
      if ((NSNull *)y != [NSNull null]) {
        userTranscoding.y = y.intValue;
      }
      NSNumber *width = dict[@"width"];
      if ((NSNull *)width != [NSNull null]) {
        userTranscoding.width = width.intValue;
      }
      NSNumber *height = dict[@"height"];
      if ((NSNull *)height != [NSNull null]) {
        userTranscoding.height = height.intValue;
      }
      [userTranscodingArray addObject:userTranscoding];
    }
  }

  layout.users = userTranscodingArray;
  taskInfo.layout = layout;
  int ret = [channel
      updateLiveStreamTask:taskInfo
                compeltion:^(NSString *_Nonnull taskId, kNERtcLiveStreamError errorCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                    [dictionary setValue:serial forKey:@"serial"];
                    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
                    [arguments setValue:taskId forKey:@"taskId"];
                    [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
                    [dictionary setValue:arguments forKey:@"arguments"];
                    // todo
                    //  [self->_liveTaskEventSink
                    //      onUpdateLiveStreamTaskTaskId:taskId
                    //                           errCode:[NSNumber numberWithInt:errorCode]
                    //                        completion:^(FlutterError *_Nullable error){
                    //                        }];
                  });
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)removeLiveStreamTaskChannelTag:(NSString *)channelTag
                                              request:(NEFLTDeleteLiveStreamTaskRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NSNumber *result = [[NSNumber alloc] init];
  NSNumber *serial = request.serial;
  int ret = [channel
      removeLiveStreamTask:request.taskId
                compeltion:^(NSString *_Nonnull taskId, kNERtcLiveStreamError errorCode) {
                  dispatch_async(
                      dispatch_get_main_queue(), ^{
                          // todo
                          // [self->_liveTaskEventSink
                          //     onDeleteLiveStreamTaskTaskId:taskId
                          //                          errCode:[NSNumber numberWithInt:errorCode]
                          //                       completion:^(FlutterError *_Nullable error){
                          //                       }];
                      });
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)sendSEIMsgChannelTag:(NSString *)channelTag
                                    request:(NEFLTSendSEIMsgRequest *)request
                                      error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcStreamChannelType streamType = (NERtcStreamChannelType)request.streamType.intValue;
  int result = [channel sendSEIMsg:request.seiMsg streamChannelType:streamType];
  return @(result);
}

- (nullable NSNumber *)setLocalMediaPriorityChannelTag:(NSString *)channelTag
                                               request:(NEFLTSetLocalMediaPriorityRequest *)request
                                                 error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel setLocalMediaPriority:request.priority.intValue
                                   preemptive:request.isPreemptive.boolValue];
  return @(result);
}

- (nullable NSNumber *)
    startChannelMediaRelayChannelTag:(NSString *)channelTag
                             request:(NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                               error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NSNumber *result = [[NSNumber alloc] init];
  NERtcChannelMediaRelayConfiguration *config = [[NERtcChannelMediaRelayConfiguration alloc] init];
  config.sourceInfo = [[NERtcChannelMediaRelayInfo alloc] init];
  NSString *channelName = request.sourceMediaInfo[@"channelName"];
  if ((NSNull *)channelName != [NSNull null]) {
    config.sourceInfo.channelName = channelName;
  }
  NSString *channelToken = request.sourceMediaInfo[@"channelToken"];
  if ((NSNull *)channelToken != [NSNull null]) {
    config.sourceInfo.token = channelToken;
  }
  NSNumber *channelUid = request.sourceMediaInfo[@"channelUid"];
  if ((NSNull *)channelUid != [NSNull null]) {
    config.sourceInfo.uid = channelUid.unsignedLongLongValue;
  }
  for (NSString *key in request.destMediaInfo) {
    id dic = [request.destMediaInfo objectForKey:key];
    NERtcChannelMediaRelayInfo *info = [[NERtcChannelMediaRelayInfo alloc] init];
    NSString *channelName = dic[@"channelName"];
    if ((NSNull *)channelName != [NSNull null]) {
      info.channelName = channelName;
    }
    NSString *channelToken = dic[@"channelToken"];
    if ((NSNull *)channelToken != [NSNull null]) {
      info.token = channelToken;
    }
    NSNumber *channelUid = dic[@"channelUid"];
    if ((NSNull *)channelUid != [NSNull null]) {
      info.uid = channelUid.unsignedLongLongValue;
    }
    [config setDestinationInfo:info forChannelName:key];
  }
  int ret = [channel startChannelMediaRelay:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    updateChannelMediaRelayChannelTag:(NSString *)channelTag
                              request:(NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                                error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NSNumber *result = [[NSNumber alloc] init];
  NERtcChannelMediaRelayConfiguration *config = [[NERtcChannelMediaRelayConfiguration alloc] init];
  config.sourceInfo = [[NERtcChannelMediaRelayInfo alloc] init];
  NSString *channelName = request.sourceMediaInfo[@"channelName"];
  if ((NSNull *)channelName != [NSNull null]) {
    config.sourceInfo.channelName = channelName;
  }
  NSString *channelToken = request.sourceMediaInfo[@"channelToken"];
  if ((NSNull *)channelToken != [NSNull null]) {
    config.sourceInfo.token = channelToken;
  }
  NSNumber *channelUid = request.sourceMediaInfo[@"channelUid"];
  if ((NSNull *)channelUid != [NSNull null]) {
    config.sourceInfo.uid = channelUid.unsignedLongLongValue;
  }
  for (NSString *key in request.destMediaInfo) {
    id dic = [request.destMediaInfo objectForKey:key];
    NERtcChannelMediaRelayInfo *info = [[NERtcChannelMediaRelayInfo alloc] init];
    NSString *channelName = dic[@"channelName"];
    if ((NSNull *)channelName != [NSNull null]) {
      info.channelName = channelName;
    }
    NSString *channelToken = dic[@"channelToken"];
    if ((NSNull *)channelToken != [NSNull null]) {
      info.token = channelToken;
    }
    NSNumber *channelUid = dic[@"channelUid"];
    if ((NSNull *)channelUid != [NSNull null]) {
      info.uid = channelUid.unsignedLongLongValue;
    }
    [config setDestinationInfo:info forChannelName:key];
  }
  int ret = [channel updateChannelMediaRelay:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopChannelMediaRelayChannelTag:(NSString *)channelTag
                                                 error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel stopChannelMediaRelay];
  return @(result);
}

- (nullable NSNumber *)
    adjustUserPlaybackSignalVolumeChannelTag:(NSString *)channelTag
                                     request:(NEFLTAdjustUserPlaybackSignalVolumeRequest *)request
                                       error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  if (request.uid == nil || request.volume == nil) {
    return @(-1);
  }

  int result = [channel adjustUserPlaybackSignalVolume:request.volume.intValue
                                             forUserID:request.uid.unsignedLongLongValue];
  return @(result);
}

- (nullable NSNumber *)setLocalPublishFallbackOptionChannelTag:(NSString *)channelTag
                                                        option:(NSNumber *)option
                                                         error:(FlutterError *_Nullable *_Nonnull)
                                                                   error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel setLocalPublishFallbackOption:option.intValue];
  return @(result);
}

- (nullable NSNumber *)
    setRemoteSubscribeFallbackOptionChannelTag:(NSString *)channelTag
                                        option:(NSNumber *)option
                                         error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel setRemoteSubscribeFallbackOption:option.intValue];
  return @(result);
}

- (nullable NSNumber *)enableEncryptionChannelTag:(NSString *)channelTag
                                          request:(NEFLTEnableEncryptionRequest *)request
                                            error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  return @(30004);
}

- (nullable NSNumber *)
    setRemoteHighPriorityAudioStreamChannelTag:(NSString *)channelTag
                                       request:
                                           (NEFLTSetRemoteHighPriorityAudioStreamRequest *)request
                                         error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel setRemoteHighPriorityAudioStream:request.enabled.boolValue
                                               forUserID:request.uid.unsignedLongLongValue
                                              streamType:request.streamType.intValue];
  return @(result);
}

- (nullable NSNumber *)setAudioSubscribeOnlyByChannelTag:(NSString *)channelTag
                                                 request:
                                                     (NEFLTSetAudioSubscribeOnlyByRequest *)request
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NSMutableArray<NSNumber *> *uidArray = [[NSMutableArray alloc] init];
  if (request.uidArray != nil) {
    for (NSNumber *uid in request.uidArray) {
      [uidArray addObject:uid];
    }
  }
  int result = [channel setAudioSubscribeOnlyBy:uidArray];
  return @(result);
}

- (nullable NSNumber *)enableLocalSubStreamAudioChannelTag:(NSString *)channelTag
                                                    enable:(NSNumber *)enable
                                                     error:
                                                         (FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel enableLocalSubStreamAudio:enable.boolValue];
  return @(result);
}

- (nullable NSNumber *)enableLocalDataChannelTag:(NSString *)channelTag
                                         enabled:(NSNumber *)enabled
                                           error:(FlutterError *_Nullable *_Nonnull)error {
  return @(30004);
}

- (nullable NSNumber *)subscribeRemoteDataChannelTag:(NSString *)channelTag
                                           subscribe:(NSNumber *)subscribe
                                              userID:(NSNumber *)userID
                                               error:(FlutterError *_Nullable *_Nonnull)error {
  return @(30004);
}

- (nullable NSNumber *)sendDataChannelTag:(NSString *)channelTag
                                    frame:(NEFLTDataExternalFrame *)frame
                                    error:(FlutterError *_Nullable *_Nonnull)error {
  return @(30004);
}

- (nullable NSNumber *)reportCustomEventChannelTag:(NSString *)channelTag
                                           request:(NEFLTReportCustomEventRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NSDictionary *params = nil;
  if (request.param != nil) {
    params = request.param;
  }
  int result = [channel reportCustomEvent:request.eventName
                           customIdentify:request.customIdentify
                                    param:params];
  return @(result);
}

- (nullable NSNumber *)setAudioRecvRangeChannelTag:(NSString *)channelTag
                                   audibleDistance:(NSNumber *)audibleDistance
                            conversationalDistance:(NSNumber *)conversationalDistance
                                       rollOffMode:(NSNumber *)rollOffMode
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }

  NERtcDistanceRolloffModel rollOff = (NERtcDistanceRolloffModel)rollOffMode.intValue;
  int ret = [channel setAudioRecvRange:audibleDistance.intValue
                conversationalDistance:conversationalDistance.intValue
                               rollOff:rollOff];
  return @(ret);
}

- (nullable NSNumber *)setRangeAudioModeChannelTag:(NSString *)channelTag
                                         audioMode:(NSNumber *)audioMode
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcRangeAudioMode mode = (NERtcRangeAudioMode)audioMode.intValue;
  int result = [channel setRangeAudioMode:mode];
  return @(result);
}

- (nullable NSNumber *)setRangeAudioTeamIDChannelTag:(NSString *)channelTag
                                              teamID:(NSNumber *)teamID
                                               error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel setRangeAudioTeamID:teamID.intValue];
  return @(result);
}

- (nullable NSNumber *)updateSelfPositionChannelTag:(NSString *)channelTag
                                       positionInfo:(NEFLTPositionInfo *)positionInfo
                                              error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcPositionInfo *info = [[NERtcPositionInfo alloc] init];

  // Convert speaker position array to individual properties
  if (positionInfo.mSpeakerPosition.count >= 3) {
    info.speakerPositionX = [positionInfo.mSpeakerPosition[0] floatValue];
    info.speakerPositionY = [positionInfo.mSpeakerPosition[1] floatValue];
    info.speakerPositionZ = [positionInfo.mSpeakerPosition[2] floatValue];
  }

  // Convert speaker quaternion array to individual properties
  if (positionInfo.mSpeakerQuaternion.count >= 4) {
    info.speakerQuaternionW = [positionInfo.mSpeakerQuaternion[0] floatValue];
    info.speakerQuaternionX = [positionInfo.mSpeakerQuaternion[1] floatValue];
    info.speakerQuaternionY = [positionInfo.mSpeakerQuaternion[2] floatValue];
    info.speakerQuaternionZ = [positionInfo.mSpeakerQuaternion[3] floatValue];
  }

  // Convert head position array to individual properties
  if (positionInfo.mHeadPosition.count >= 3) {
    info.headPositionX = [positionInfo.mHeadPosition[0] floatValue];
    info.headPositionY = [positionInfo.mHeadPosition[1] floatValue];
    info.headPositionZ = [positionInfo.mHeadPosition[2] floatValue];
  }

  // Convert head quaternion array to individual properties
  if (positionInfo.mHeadQuaternion.count >= 4) {
    info.headQuaternionW = [positionInfo.mHeadQuaternion[0] floatValue];
    info.headQuaternionX = [positionInfo.mHeadQuaternion[1] floatValue];
    info.headQuaternionY = [positionInfo.mHeadQuaternion[2] floatValue];
    info.headQuaternionZ = [positionInfo.mHeadQuaternion[3] floatValue];
  }

  int result = [channel updateSelfPosition:info];
  return @(result);
}

- (nullable NSNumber *)enableSpatializerRoomEffectsChannelTag:(NSString *)channelTag
                                                       enable:(NSNumber *)enable
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel enableSpatializerRoomEffects:enable.boolValue];
  return @(result);
}

- (nullable NSNumber *)setSpatializerRoomPropertyChannelTag:(NSString *)channelTag
                                                   property:(NEFLTSpatializerRoomProperty *)property
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcSpatializerRoomProperty *roomProperty = [[NERtcSpatializerRoomProperty alloc] init];
  roomProperty.roomCapacity = (NERtcSpatializerRoomCapacity)property.roomCapacity.intValue;
  roomProperty.material = (NERtcSpatializerMaterialName)property.material.intValue;
  roomProperty.reflectionScalar = property.reflectionScalar.floatValue;
  roomProperty.reverbGain = property.reverbGain.floatValue;
  roomProperty.reverbTime = property.reverbTime.floatValue;
  roomProperty.reverbBrightness = property.reverbBrightness.floatValue;
  int result = [channel setSpatializerRoomProperty:roomProperty];
  return @(result);
}

- (nullable NSNumber *)setSpatializerRenderModeChannelTag:(NSString *)channelTag
                                               renderMode:(NSNumber *)renderMode
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  NERtcSpatializerRenderMode mode = (NERtcSpatializerRenderMode)renderMode.intValue;
  int result = [channel setSpatializerRenderMode:mode];
  return @(result);
}

- (nullable NSNumber *)enableSpatializerChannelTag:(NSString *)channelTag
                                            enable:(NSNumber *)enable
                                       applyToTeam:(NSNumber *)applyToTeam
                                             error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel enableSpatializer:enable.boolValue applyToTeam:applyToTeam.boolValue];
  return @(result);
}

- (nullable NSNumber *)setUpSpatializerChannelTag:(NSString *)channelTag
                                            error:(FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int result = [channel initSpatializer];
  return @(result);
}

- (nullable NSNumber *)setSubscribeAudioBlocklistChannelTag:(NSString *)channelTag
                                                   uidArray:(NSArray<NSNumber *> *)uidArray
                                                 streamType:(NSNumber *)streamType
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int ret = [channel setSubscribeAudioBlocklist:streamType.unsignedIntegerValue uidArray:uidArray];
  return @(ret);
}

- (nullable NSNumber *)setSubscribeAudioAllowlistChannelTag:(NSString *)channelTag
                                                   uidArray:(NSArray<NSNumber *> *)uidArray
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error {
  NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
  if (channel == nil) {
    NSLog(@"[NERtcChannelImpl] channel is null");
    return @(-1);
  }
  int ret = [channel setSubscribeAudioAllowlist:uidArray];
  return @(ret);
}

@end
