// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
#import "NERtcCorePlugin.h"
#import <Foundation/Foundation.h>
#import <NERtcReplayKit/NERtcReplayKit.h>
#import <NERtcSDK/NERtcSDK.h>
#import <ReplayKit/ReplayKit.h>
#import <UIKit/UIKit.h>
#import "FLNERtcEngineVideoFrameDelegate.h"
#import "FlutterVideoRenderer.h"
#import "Messages.h"
#import "NERtcChannelImpl.h"
#import "NERtcChannelManager.h"
#import "NERtcScreenShareHostDelegate.h"

static NSString *const kLiteSDKBusinessScenarioFlutter = @"sdk.business.scenario.type";
#define IPHONE_OS_VERSION_iOS12 [UIDevice currentDevice].systemVersion.floatValue >= 12.0f

@interface NERtcCorePlugin () <NEFLTEngineApi,
                               NERtcEngineDelegateEx,
                               NEFLTDeviceManagerApi,
                               NEFLTAudioEffectApi,
                               NEFLTAudioMixingApi,
                               NEFLTVideoRendererApi,
                               NERtcEngineMediaStatsObserver,
                               NEScreenShareHostDelegate>
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, FlutterVideoRenderer *> *renderers;
@property(nonatomic, strong) NEFLTCreateEngineRequest *createEngineRequest;
@property(nonatomic, strong) NEFLTNERtcChannelEventSink *channelEventSink;
@property(nonatomic, strong) NEFLTNERtcDeviceEventSink *deviceEventSink;
@property(nonatomic, strong) NEFLTNERtcStatsEventSink *statsEventSink;
@property(nonatomic, strong) NEFLTNERtcAudioMixingEventSink *mixingEventSink;
@property(nonatomic, strong) NEFLTNERtcAudioEffectEventSink *effectEventSink;
@property(nonatomic, strong) NEFLTNERtcLiveStreamEventSink *liveTaskEventSink;
@property(nonatomic, strong) NERtcScreenShareHostDelegate *screenShareDelegate;
@property(nonatomic, strong) NEScreenShareHost *shareHost;
#ifdef IPHONE_OS_VERSION_iOS12
@property(nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView;
#endif
@end

@implementation NERtcCorePlugin {
  FlutterMethodChannel *_channel;
  id _registry;
  id _messenger;
  id _textures;
  BOOL _statsCallbackEnabled;
  BOOL _isInitialized;
  NSString *_appGroup;
}

#pragma mark - FlutterPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
  NERtcCorePlugin *instance = [[NERtcCorePlugin alloc] initWithRegistrar:registrar];
  [registrar publish:instance];
  NEFLTEngineApiSetup(registrar.messenger, instance);
  NEFLTDeviceManagerApiSetup(registrar.messenger, instance);
  NEFLTAudioEffectApiSetup(registrar.messenger, instance);
  NEFLTAudioMixingApiSetup(registrar.messenger, instance);
  NEFLTVideoRendererApiSetup(registrar.messenger, instance);

  [[NERtcChannelManager sharedInstance] setBinaryMessenger:registrar.messenger];
  NERtcChannelImpl *channel =
      [[NERtcChannelImpl alloc] initWithBinaryMessenger:registrar.messenger];
  NEFLTChannelApiSetup(registrar.messenger, channel);
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  _channelEventSink = nil;
  _deviceEventSink = nil;
  _mixingEventSink = nil;
  _effectEventSink = nil;
  _statsEventSink = nil;
  _liveTaskEventSink = nil;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _channelEventSink = self.channelEventSink;
    _deviceEventSink = self.deviceEventSink;
    _statsEventSink = self.statsEventSink;
    _mixingEventSink = self.mixingEventSink;
    _effectEventSink = self.effectEventSink;
    _liveTaskEventSink = self.liveTaskEventSink;
  }
  return self;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  _registry = [registrar textures];
  _messenger = [registrar messenger];
  _textures = [registrar textures];
  self.renderers = [[NSMutableDictionary alloc] init];
  _isInitialized = NO;

  _channel = [FlutterMethodChannel methodChannelWithName:@"flutter.yunxin.163.com/nertc_core"
                                         binaryMessenger:[registrar messenger]];

  _channelEventSink =
      [[NEFLTNERtcChannelEventSink alloc] initWithBinaryMessenger:[registrar messenger]];

  _deviceEventSink =
      [[NEFLTNERtcDeviceEventSink alloc] initWithBinaryMessenger:[registrar messenger]];

  _statsEventSink =
      [[NEFLTNERtcStatsEventSink alloc] initWithBinaryMessenger:[registrar messenger]];

  _mixingEventSink =
      [[NEFLTNERtcAudioMixingEventSink alloc] initWithBinaryMessenger:[registrar messenger]];

  _effectEventSink =
      [[NEFLTNERtcAudioEffectEventSink alloc] initWithBinaryMessenger:[registrar messenger]];

  _liveTaskEventSink =
      [[NEFLTNERtcLiveStreamEventSink alloc] initWithBinaryMessenger:[registrar messenger]];
  _statsCallbackEnabled = NO;
  return self;
}
#pragma mark - NEFLTEngineApi
// 初始化引擎
- (nullable NSNumber *)createRequest:(nonnull NEFLTCreateEngineRequest *)request
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#create");
#endif

  _createEngineRequest = request;
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

  [params setObject:[NSNumber numberWithInt:7] forKey:kLiteSDKBusinessScenarioFlutter];
  // Audio
  if (request.audioAutoSubscribe != nil) {
    [params setObject:request.audioAutoSubscribe forKey:kNERtcKeyAutoSubscribeAudio];
  }
  if (request.audioDisableSWAECOnHeadset != nil) {
    [params setObject:request.audioDisableSWAECOnHeadset forKey:KNERtcKeyDisableSWAECOnHeadset];
  }
  if (request.audioDisableOverrideSpeakerOnReceiver != nil) {
    [params setObject:request.audioDisableOverrideSpeakerOnReceiver
               forKey:KNERtcKeyDisableOverrideSpeakerOnReceiver];
  }
  if (request.audioAINSEnabled != nil) {
    [params setObject:request.audioAINSEnabled forKey:KNERtcKeyAudioAINSEnable];
  }

  // Server Record
  if (request.serverRecordSpeaker != nil) {
    [params setObject:request.serverRecordSpeaker forKey:kNERtcKeyRecordHostEnabled];
  }
  if (request.serverRecordAudio != nil) {
    [params setObject:request.serverRecordAudio forKey:kNERtcKeyRecordAudioEnabled];
  }
  if (request.serverRecordVideo != nil) {
    [params setObject:request.serverRecordVideo forKey:kNERtcKeyRecordVideoEnabled];
  }
  if (request.serverRecordMode != nil) {
    [params setObject:request.serverRecordMode forKey:kNERtcKeyRecordType];
  }

  // Video
  if (request.videoAutoSubscribe != nil) {
    [params setObject:request.videoAutoSubscribe forKey:kNERtcKeyAutoSubscribeVideo];
  }
  if (request.videoEncodeMode != nil) {
    [params setObject:request.videoEncodeMode.intValue == 0 ? @(YES) : @(NO)
               forKey:kNERtcKeyVideoPreferHWEncode];
  }
  if (request.videoDecodeMode != nil) {
    [params setObject:request.videoDecodeMode.intValue == 0 ? @(YES) : @(NO)
               forKey:kNERtcKeyVideoPreferHWDecode];
  }
  if (request.videoSendMode != nil) {
    [params setObject:request.videoSendMode forKey:kNERtcKeyVideoSendOnPubType];
  }
  if (request.videoCaptureObserverEnabled != nil) {
    [params setObject:request.videoCaptureObserverEnabled
               forKey:kNERtcKeyVideoCaptureObserverEnabled];
  }
  if (request.disableFirstJoinUserCreateChannel != nil) {
    [params setObject:request.disableFirstJoinUserCreateChannel
               forKey:kNERtcKeyDisableFirstJoinUserCreateChannel];
  }

  [params setObject:@(YES) forKey:kNERtcKeyVideoPreferMetalRender];
  if (request.mode1v1Enabled) {
    [params setObject:request.mode1v1Enabled forKey:kNERtcKeyChannel1V1ModeEnabled];
  }

  // Live Stream
  if (request.publishSelfStream != nil) {
    [params setObject:request.publishSelfStream forKey:kNERtcKeyPublishSelfStreamEnabled];
  }
  [params setObject:[NSNumber numberWithBool:true] forKey:KNERtcKeyEnableReportVolumeWhenMute];
  [[NERtcEngine sharedEngine] setParameters:params];

  NERtcEngineContext *context = [[NERtcEngineContext alloc] init];
  context.appKey = request.appKey;
  context.logSetting = [[NERtcLogSetting alloc] init];
  if (request.logDir != nil) {
    context.logSetting.logDir = request.logDir;
  }
  if (request.logLevel != nil) {
    context.logSetting.logLevel = request.logLevel.intValue;
  } else {
#ifdef DEBUG
    context.logSetting.logLevel = kNERtcLogLevelInfo;
#endif
  }

  NEFLTRtcServerAddresses *serverAddresses = request.serverAddresses;
  BOOL serverAddressesValid = NO;
  if (serverAddresses.valid != nil) {
    serverAddressesValid = serverAddresses.valid.intValue != 0 ? YES : NO;
  }
  if (serverAddresses != nil && serverAddressesValid) {
    NERtcServerAddresses *customServerAddresses = [[NERtcServerAddresses alloc] init];
    customServerAddresses.channelServer = serverAddresses.channelServer;
    customServerAddresses.statisticsServer = serverAddresses.statisticsServer;
    customServerAddresses.roomServer = serverAddresses.roomServer;
    customServerAddresses.nosLbsServer = serverAddresses.nosLbsServer;
    customServerAddresses.nosUploadSever = serverAddresses.nosUploadSever;
    customServerAddresses.nosTokenServer = serverAddresses.nosTokenServer;
    customServerAddresses.compatServer = serverAddresses.compatServer;
    customServerAddresses.cloudProxyServer = serverAddresses.cloudProxyServer;
    customServerAddresses.webSocketProxyServer = serverAddresses.webSocketProxyServer;
    customServerAddresses.quicProxyServer = serverAddresses.quicProxyServer;
    customServerAddresses.mediaProxyServer = serverAddresses.mediaProxyServer;
    customServerAddresses.statisticsDispatchServer = serverAddresses.statisticsDispatchServer;
    customServerAddresses.statisticsBackupServer = serverAddresses.statisticsBackupServer;
    customServerAddresses.useIPv6 = serverAddresses.useIPv6.intValue != 0 ? YES : NO;

    context.serverAddress = customServerAddresses;
  }
  context.engineDelegate = self;
  int ret = [[NERtcEngine sharedEngine] setupEngineWithContext:context];
  if (ret == 0) {
    _isInitialized = YES;
    _appGroup = request.appGroup;
  }
  NSNumber *result = [[NSNumber alloc] init];
  result = @(ret);
  return result;
}

- (void)configureEngineOnJoinedChannel {
  if (_createEngineRequest) {
    // 部分参数在初始化后设置才生效
    NSMutableDictionary *delayParams = [NSMutableDictionary dictionary];
    if (_createEngineRequest.audioAINSEnabled != nil) {
      [delayParams setObject:_createEngineRequest.audioAINSEnabled forKey:KNERtcKeyAudioAINSEnable];
    }
    [[NERtcEngine sharedEngine] setParameters:delayParams];

    _createEngineRequest = nil;
  }
}

- (nullable NSNumber *)joinChannelRequest:(nonnull NEFLTJoinChannelRequest *)request
                                    error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#joinChannel");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcJoinChannelOptions *opts =
      request.channelOptions == nil ? nil : [[NERtcJoinChannelOptions alloc] init];
  if (request.channelOptions != nil) {
    opts.customInfo = request.channelOptions.customInfo;
    opts.permissionKey = request.channelOptions.permissionKey;
  }
  int ret = [[NERtcEngine sharedEngine]
      joinChannelWithToken:request.token
               channelName:request.channelName
                     myUid:request.uid.unsignedLongLongValue
            channelOptions:opts
                completion:^(NSError *_Nullable error, uint64_t channelId, uint64_t elapesd,
                             uint64_t uid, NERtcJoinChannelExtraInfo *_Nullable info) {
                  long code;
                  if (error) {
                    code = error.code;
                  } else {
                    code = 0;
                  }
    //      [self onJoinChannel:code channelId:channelId elapsed:elapesd uid:uid];
#ifdef DEBUG
                  NSLog(@"FlutterCalled:NERtcChannelEventSink#onJoinChannelResult");
#endif
                  [self->_channelEventSink
                      onJoinChannelResult:[NSNumber numberWithLong:code]
                                channelId:[NSNumber numberWithUnsignedLongLong:channelId]
                                  elapsed:[NSNumber numberWithUnsignedLongLong:elapesd]
                                      uid:[NSNumber numberWithUnsignedLongLong:uid]
                               completion:^(FlutterError *_Nullable error){

                               }];
                  [self configureEngineOnJoinedChannel];
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)createChannelChannelTag:(NSString *)channelTag
                                         error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#createChannel");
#endif
  NSInteger ret = [[NERtcChannelManager sharedInstance] createChannel:channelTag];
  NSNumber *result = @(ret);
  return result;
}

- (void)releaseWithCompletion:(nonnull void (^)(NSNumber *_Nullable,
                                                FlutterError *_Nullable))completion {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#release");
#endif
  [[NERtcEngine sharedEngine] cleanupEngineMediaStatsObserver];

  // 释放所有 channel 资源
  [[NERtcChannelManager sharedInstance] releaseAll];

  _isInitialized = NO;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [NERtcEngine destroyEngine];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSNumber *value = [[NSNumber alloc] init];
      value = @(0);
      completion(value, nil);
    });
  });
}

- (nullable NSNumber *)enableLocalAudioEnable:(nonnull NSNumber *)enable
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableLocalAudio");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableLocalAudio:enable.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)enableLocalVideoRequest:(nonnull NEFLTEnableLocalVideoRequest *)request
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableLocalVideo");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSUInteger type = request.streamType.unsignedIntegerValue;
  int ret = [[NERtcEngine sharedEngine] enableLocalVideo:request.enable.boolValue streamType:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setCameraCaptureConfigRequest:(nonnull NEFLTSetCameraCaptureConfigRequest *)request
                            error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setCameraCaptureConfig");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcCameraCaptureConfiguration *config = [[NERtcCameraCaptureConfiguration alloc] init];
  config.captureWidth = request.captureWidth.intValue;
  config.captureHeight = request.captureHeight.intValue;

  NSUInteger type = request.streamType.unsignedIntegerValue;

  int ret = [[NERtcEngine sharedEngine] setCameraCaptureConfig:config streamType:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setLocalVideoConfigRequest:(nonnull NEFLTSetLocalVideoConfigRequest *)request
                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalVideoConfig");
#endif
  NSNumber *result = [[NSNumber alloc] init];
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
  NSUInteger type = request.streamType.unsignedIntegerValue;

  int ret = [[NERtcEngine sharedEngine] setLocalVideoConfig:config streamType:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setAudioProfileRequest:(nonnull NEFLTSetAudioProfileRequest *)request
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAudioProfile");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setAudioProfile:request.profile.integerValue
                                               scenario:request.scenario.integerValue];
  result = @(ret);
  return result;
}
- (nullable NSNumber *)leaveChannelWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#leaveChannel");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] leaveChannel];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)muteLocalAudioStreamMute:(nonnull NSNumber *)mute
                                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                    error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#muteLocalAudioStreamMute");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] muteLocalAudio:mute.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    muteLocalSubStreamAudioMuted:(nonnull NSNumber *)muted
                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#muteLocalSubStreamAudio");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] muteLocalSubStreamAudio:muted.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)muteLocalVideoStreamMute:(nonnull NSNumber *)mute
                                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                    error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#muteLocalVideoStreamMute");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] muteLocalAudio:mute.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    subscribeAllRemoteAudioSubscribe:(nonnull NSNumber *)subscribe
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#subscribeAllRemoteAudio");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] subscribeAllRemoteAudio:subscribe.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    subscribeRemoteAudioRequest:(nonnull NEFLTSubscribeRemoteAudioRequest *)request
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#subscribeRemoteAudio");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] subscribeRemoteAudio:request.subscribe.boolValue
                                                   forUserID:request.uid.unsignedLongLongValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    subscribeRemoteSubStreamAudioRequest:
        (nonnull NEFLTSubscribeRemoteSubStreamAudioRequest *)request
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#subscribeRemoteSubStreamAudio");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret =
      [[NERtcEngine sharedEngine] subscribeRemoteSubStreamAudio:request.subscribe.boolValue
                                                      forUserID:request.uid.unsignedLongLongValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    subscribeRemoteSubStreamVideoRequest:
        (nonnull NEFLTSubscribeRemoteSubStreamVideoRequest *)request
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#subscribeRemoteSubStreamVideo");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret =
      [[NERtcEngine sharedEngine] subscribeRemoteSubStreamVideo:request.subscribe.boolValue
                                                      forUserID:request.uid.unsignedLongLongValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    subscribeRemoteVideoStreamRequest:(nonnull NEFLTSubscribeRemoteVideoStreamRequest *)request
                                error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#subscribeRemoteVideoStream");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcRemoteVideoStreamType type = request.streamType.unsignedIntegerValue;
  int ret = [[NERtcEngine sharedEngine] subscribeRemoteVideo:request.subscribe.boolValue
                                                   forUserID:request.uid.unsignedLongLongValue
                                                  streamType:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setVideoRotationModeRotationMode:(NSNumber *)rotationMode
                                                  error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setVideoRotationMode");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcVideoRotationMode mode = rotationMode.unsignedIntegerValue;
  int ret = [[NERtcEngine sharedEngine] setVideoRotationMode:mode];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    startVideoPreviewRequest:(nonnull NEFLTStartorStopVideoPreviewRequest *)request
                       error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startVideoPreview");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSUInteger type = request.streamType.unsignedIntegerValue;
  int ret = [[NERtcEngine sharedEngine] startPreview:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopAudioDumpwithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopAudioDump");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopAudioDump];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopAudioRecordingwithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopAudioRecording");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopAudioRecording];
  result = @(ret);
  return result;
}
- (nullable NSNumber *)startAudioDumpWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startAudioDump");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] startAudioDump];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    startAudioRecordingRequest:(nonnull NEFLTStartAudioRecordingRequest *)request
                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startAudioRecording");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] startAudioRecording:request.filePath
                                                 sampleRate:request.sampleRate.intValue
                                                    quality:request.quality.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    startAudioRecordingWithConfigRequest:(nonnull NEFLTAudioRecordingConfigurationRequest *)request
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startAudioRecordingWithConfig");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcAudioRecordingConfiguration *config = [[NERtcAudioRecordingConfiguration alloc] init];
  config.filePath = request.filePath;
  config.sampleRate = request.sampleRate.intValue;
  config.quality = request.quality.integerValue;
  config.position = request.position.integerValue;
  config.cycleTime = request.cycleTime.integerValue;
  int ret = [[NERtcEngine sharedEngine] startAudioRecordingWithConfig:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    enableAudioVolumeIndicationRequest:(nonnull NEFLTEnableAudioVolumeIndicationRequest *)request
                                 error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableAudioVolumeIndication");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret =
      [[NERtcEngine sharedEngine] enableAudioVolumeIndication:request.enable.boolValue
                                                     interval:request.interval.unsignedLongLongValue
                                                          vad:request.vad.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    adjustPlaybackSignalVolumeVolume:(nonnull NSNumber *)volume
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#adjustPlaybackSignalVolume");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] adjustPlaybackSignalVolume:volume.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    adjustRecordingSignalVolumeVolume:(nonnull NSNumber *)volume
                                error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#adjustRecordingSignalVolume");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] adjustRecordingSignalVolume:volume.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    adjustUserPlaybackSignalVolumeRequest:
        (nonnull NEFLTAdjustUserPlaybackSignalVolumeRequest *)request
                                    error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#adjustUserPlaybackSignalVolume");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret =
      [[NERtcEngine sharedEngine] adjustUserPlaybackSignalVolume:request.volume.unsignedIntValue
                                                       forUserID:request.uid.unsignedLongLongValue];
  result = @(ret);
  return result;
}

- (void)setupShareKit:(NSDictionary *)params appGroup:(NSString *)appGroup {
  NEScreenShareHostOptions *options = [[NEScreenShareHostOptions alloc] init];
  options.appGroup = appGroup;
  NSLog(@"appGroup: %@", options.appGroup);
#if DEBUG
  options.enableDebug = YES;
#else
  options.enableDebug = NO;
#endif
  if (!self.screenShareDelegate) {
    self.screenShareDelegate = [[NERtcScreenShareHostDelegate alloc] init];
  }
  options.delegate = self.screenShareDelegate;
  if (params != nil) {
    options.extraInfoDict = params;
  }
  self.shareHost = [NEScreenShareHost sharedInstance];
  [self.shareHost setupScreenshareOptions:options];
}

- (void)startScreenCaptureRequest:(nonnull NEFLTStartScreenCaptureRequest *)request
                       completion:(nonnull void (^)(NSNumber *_Nullable,
                                                    FlutterError *_Nullable))completion {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startScreenCapture");
#endif
  NSNumber *value = [[NSNumber alloc] init];
  [[NERtcEngine sharedEngine] setExternalVideoSource:YES
                                          streamType:kNERtcStreamChannelTypeSubStream];
  NERtcVideoSubStreamEncodeConfiguration *config =
      [[NERtcVideoSubStreamEncodeConfiguration alloc] init];
  if (request.contentPrefer != nil) {
    config.contentPrefer = request.contentPrefer.unsignedIntegerValue;
  }
  if (request.videoProfile != nil) {
    config.maxProfile = request.videoProfile.unsignedIntegerValue;
  }
  if (request.frameRate != nil) {
    config.frameRate = request.frameRate.unsignedIntegerValue;
  }
  if (request.minFrameRate != nil) {
    config.minFrameRate = request.minFrameRate.integerValue;
  }
  if (request.bitrate != nil) {
    config.bitrate = request.bitrate.integerValue;
  }
  if (request.minBitrate != nil) {
    config.minBitrate = request.minBitrate.integerValue;
  }

  int ret = [[NERtcEngine sharedEngine] startScreenCapture:config];
  value = @(ret);

  if (ret == kNERtcNoError) {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 13.1f) {
      bool is_captured = [UIScreen mainScreen].isCaptured;
      if (@available(iOS 13.1, *) && !is_captured) {
        self.broadPickerView =
            [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        {
          NSString *plugInPath = NSBundle.mainBundle.builtInPlugInsPath;
          if (!plugInPath) {
            return;
          }
          NSArray *contents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:plugInPath
                                                                                error:nil];
          for (NSString *content in contents) {
            NSURL *url = [NSURL fileURLWithPath:plugInPath];
            NSBundle *bundle =
                [NSBundle bundleWithPath:[url URLByAppendingPathComponent:content].path];

            NSDictionary *extension = [bundle.infoDictionary objectForKey:@"NSExtension"];
            if (extension == nil) {
              continue;
            }
            NSString *identifier = [extension objectForKey:@"NSExtensionPointIdentifier"];
            if ([identifier isEqualToString:@"com.apple.broadcast-services-upload"]) {
              self.broadPickerView.preferredExtension = bundle.bundleIdentifier;
              self.broadPickerView.showsMicrophoneButton = NO;
              break;
            }
          }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
          for (UIView *view in [self.broadPickerView subviews]) {
            if ([view isKindOfClass:UIButton.class]) {
              [((UIButton *)view) sendActionsForControlEvents:UIControlEventAllTouchEvents];
            }
          }
        });
      }
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f) {
      NSLog(@"FlutterCalled:EngineApi#startScreenCapture, 需要用户到设置主动打开");
      ret = -1;
    } else {
      NSLog(@"FlutterCalled:EngineApi#startScreenCapture, 当前版本不支持屏幕共享");
      ret = -2;
    }
    [self setupShareKit:request.dict appGroup:_appGroup];
  }
  completion(value, nil);
}

- (nullable NSNumber *)stopScreenCaptureWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopScreenCapture");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopScreenCapture];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    enableDualStreamModeEnable:(nonnull NSNumber *)enable
                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableDualStreamMode");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableDualStreamMode:enable.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setChannelProfileChannelProfile:(nonnull NSNumber *)channelProfile
                              error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setChannelProfile");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setChannelProfile:channelProfile.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setClientRoleRole:(nonnull NSNumber *)role
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setClientRole");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setClientRole:role.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    addLiveStreamTaskRequest:(nonnull NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                       error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#addLiveStreamTask");
#endif
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

  int ret = [[NERtcEngine sharedEngine]
      addLiveStreamTask:taskInfo
             compeltion:^(NSString *_Nonnull taskId, kNERtcLiveStreamError errorCode) {
               dispatch_async(dispatch_get_main_queue(), ^{
                 NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                 [dictionary setValue:serial forKey:@"serial"];
                 NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
                 [arguments setValue:taskId forKey:@"taskId"];
                 [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
                 [dictionary setValue:arguments forKey:@"arguments"];
                 [self->_liveTaskEventSink
                     onAddLiveStreamTaskTaskId:taskId
                                       errCode:[NSNumber numberWithInt:errorCode]
                                    completion:^(FlutterError *_Nullable error){
                                    }];
               });
             }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    removeLiveStreamTaskRequest:(nonnull NEFLTDeleteLiveStreamTaskRequest *)request
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#removeLiveStreamTask");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSNumber *serial = request.serial;
  int ret = [[NERtcEngine sharedEngine]
      removeLiveStreamTask:request.taskId
                compeltion:^(NSString *_Nonnull taskId, kNERtcLiveStreamError errorCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    //                    NSMutableDictionary *dictionary = [[NSMutableDictionary
                    //                    alloc] init]; [dictionary setValue:serial
                    //                    forKey:@"serial"]; NSMutableDictionary *arguments =
                    //                    [[NSMutableDictionary alloc] init]; [arguments
                    //                    setValue:taskId forKey:@"taskId"]; [arguments
                    //                    setValue:[NSNumber numberWithInt:errorCode]
                    //                    forKey:@"errCode"]; [dictionary setValue:arguments
                    //                    forKey:@"arguments"];
                    [self->_liveTaskEventSink
                        onDeleteLiveStreamTaskTaskId:taskId
                                             errCode:[NSNumber numberWithInt:errorCode]
                                          completion:^(FlutterError *_Nullable error){
                                          }];
                  });
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    updateLiveStreamTaskRequest:(nonnull NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#updateLiveStreamTask");
#endif
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
  int ret = [[NERtcEngine sharedEngine]
      updateLiveStreamTask:taskInfo
                compeltion:^(NSString *_Nonnull taskId, kNERtcLiveStreamError errorCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                    [dictionary setValue:serial forKey:@"serial"];
                    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
                    [arguments setValue:taskId forKey:@"taskId"];
                    [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
                    [dictionary setValue:arguments forKey:@"arguments"];
                    [self->_liveTaskEventSink
                        onUpdateLiveStreamTaskTaskId:taskId
                                             errCode:[NSNumber numberWithInt:errorCode]
                                          completion:^(FlutterError *_Nullable error){
                                          }];
                  });
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)getConnectionStateWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#getConnectionState");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcConnectionStateType ret = [[NERtcEngine sharedEngine] connectionState];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)switchChannelRequest:(nonnull NEFLTSwitchChannelRequest *)request
                                      error:
                                          (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#switchChannel");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcJoinChannelOptions *channelOptions = [[NERtcJoinChannelOptions alloc] init];
  channelOptions.customInfo = request.channelOptions.customInfo;
  channelOptions.permissionKey = request.channelOptions.permissionKey;
  int ret = [[NERtcEngine sharedEngine]
      switchChannelWithToken:request.token
                 channelName:request.channelName
              channelOptions:channelOptions
                  completion:^(NSError *_Nullable error, uint64_t channelId, uint64_t elapesd,
                               uint64_t uid, NERtcJoinChannelExtraInfo *_Nullable info) {
                    long code;
                    if (error) {
                      code = error.code;
                    } else {
                      code = 0;
                    }
                    //                    [self onJoinChannel:code channelId:channelId
                    //                    elapsed:elapesd uid:uid];
                    [self->_channelEventSink
                        onJoinChannelResult:[NSNumber numberWithLong:code]
                                  channelId:[NSNumber numberWithUnsignedLongLong:channelId]
                                    elapsed:[NSNumber numberWithUnsignedLongLong:elapesd]
                                        uid:[NSNumber numberWithUnsignedLongLong:uid]
                                 completion:^(FlutterError *_Nullable error){

                                 }];
                  }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)sendSEIMsgRequest:(nonnull NEFLTSendSEIMsgRequest *)request
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#sendSEIMsg");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSUInteger type = request.streamType.unsignedIntegerValue;
  int ret =
      [[NERtcEngine sharedEngine] sendSEIMsg:[request.seiMsg dataUsingEncoding:NSUTF8StringEncoding]
                           streamChannelType:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setAudioEffectPresetPreset:(nonnull NSNumber *)preset
                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAudioEffectPreset");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setAudioEffectPreset:preset.integerValue];
  result = @(ret);
  return result;
}
- (NSNumber *)
    setLocalVideoWatermarkConfigsRequest:(NEFLTSetLocalVideoWatermarkConfigsRequest *)request
                                   error:(FlutterError *_Nullable __autoreleasing *)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalVideoWatermarkConfigs");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcStreamChannelType types = request.type.unsignedIntegerValue;
  if (request.config == nil) {
    int ret = [[NERtcEngine sharedEngine] setLocalVideoWatermarkConfigs:nil withStreamType:types];
    return @(ret);
  }
  NERtcVideoWatermarkConfig *configs = [[NERtcVideoWatermarkConfig alloc] init];
  NERtcVideoWatermarkType wmType = 0;
  NEFLTNERtcVideoWatermarkType tmp = request.config.WatermarkType;
  switch (tmp) {
    case 0:
      wmType = kNERtcVideoWatermarkTypeImage;
      break;
    case 1:
      wmType = kNERtcVideoWatermarkTypeText;
      break;

    default:
      wmType = kNERtcVideoWatermarkTypeTimeStamp;
      break;
  }
  configs.watermarkType = wmType;
  if (wmType == kNERtcVideoWatermarkTypeText) {
    NERtcVideoWatermarkTextConfig *textConfig = [[NERtcVideoWatermarkTextConfig alloc] init];
    textConfig.wmAlpha = request.config.textWatermark.wmAlpha.floatValue;
    textConfig.wmWidth = request.config.textWatermark.wmWidth.unsignedIntegerValue;
    textConfig.wmHeight = request.config.textWatermark.wmHeight.unsignedIntegerValue;
    textConfig.wmColor = request.config.textWatermark.wmColor.unsignedIntegerValue;
    textConfig.offsetX = request.config.textWatermark.offsetX.unsignedIntegerValue;
    textConfig.offsetY = request.config.textWatermark.offsetY.unsignedIntegerValue;
    textConfig.fontSize = request.config.textWatermark.fontSize.unsignedIntegerValue;
    textConfig.fontName = request.config.textWatermark.fontNameOrPath;
    textConfig.fontColor = request.config.textWatermark.fontColor.unsignedIntegerValue;
    textConfig.content = request.config.textWatermark.content;
    configs.textWatermark = textConfig;
  } else if (wmType == kNERtcVideoWatermarkTypeImage) {
    NERtcVideoWatermarkImageConfig *imageConfig = [[NERtcVideoWatermarkImageConfig alloc] init];
    imageConfig.wmAlpha = request.config.imageWatermark.wmAlpha.floatValue;
    imageConfig.wmWidth = request.config.imageWatermark.wmWidth.unsignedIntegerValue;
    imageConfig.wmHeight = request.config.imageWatermark.wmHeight.unsignedIntegerValue;
    imageConfig.offsetX = request.config.imageWatermark.offsetX.unsignedIntegerValue;
    imageConfig.offsetY = request.config.imageWatermark.offsetY.unsignedIntegerValue;
    imageConfig.imagePaths = request.config.imageWatermark.imagePaths;
    imageConfig.fps = request.config.imageWatermark.fps.unsignedIntegerValue;
    imageConfig.loop = request.config.imageWatermark.loop.boolValue;
    configs.imageWatermark = imageConfig;
  } else if (wmType == kNERtcVideoWatermarkTypeTimeStamp) {
    NERtcVideoWatermarkTimestampConfig *timeConfig =
        [[NERtcVideoWatermarkTimestampConfig alloc] init];
    timeConfig.wmAlpha = request.config.timestampWatermark.wmAlpha.floatValue;
    timeConfig.wmWidth = request.config.timestampWatermark.wmWidth.unsignedIntegerValue;
    timeConfig.wmHeight = request.config.timestampWatermark.wmHeight.unsignedIntegerValue;
    timeConfig.wmColor = request.config.timestampWatermark.wmColor.unsignedIntegerValue;
    timeConfig.offsetX = request.config.timestampWatermark.offsetX.unsignedIntegerValue;
    timeConfig.offsetY = request.config.timestampWatermark.offsetY.unsignedIntegerValue;
    timeConfig.fontSize = request.config.timestampWatermark.fontSize.unsignedIntegerValue;
    timeConfig.fontColor = request.config.timestampWatermark.fontColor.unsignedIntegerValue;
    timeConfig.fontName = request.config.timestampWatermark.fontNameOrPath;
    configs.timestampWatermark = timeConfig;
  }
  int ret = [[NERtcEngine sharedEngine] setLocalVideoWatermarkConfigs:configs withStreamType:types];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setLocalVoiceEqualizationRequest:(nonnull NEFLTSetLocalVoiceEqualizationRequest *)request
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalVoiceEqualization");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine]
      setLocalVoiceEqualizationOfBandFrequency:request.bandFrequency.integerValue
                                      withGain:request.bandGain.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setLocalVoicePitchPitch:(nonnull NSNumber *)pitch
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalVoicePitch");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setLocalVoicePitch:pitch.doubleValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setLocalVoiceReverbParamRequest:(nonnull NEFLTSetLocalVoiceReverbParamRequest *)request
                              error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalVoiceReverbParam");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcReverbParam *param = [[NERtcReverbParam alloc] init];
  param.wetGain = request.wetGain.floatValue;
  param.dryGain = request.dryGain.floatValue;
  param.damping = request.damping.floatValue;
  param.roomSize = request.roomSize.floatValue;
  param.decayTime = request.decayTime.floatValue;
  param.preDelay = request.preDelay.floatValue;

  int ret = [[NERtcEngine sharedEngine] setLocalVoiceReverbParam:param];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setLocalMediaPriorityRequest:(nonnull NEFLTSetLocalMediaPriorityRequest *)request
                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalMediaPriority");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setLocalMediaPriority:request.priority.integerValue
                                                   preemptive:request.isPreemptive.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setLocalPublishFallbackOptionOption:(nonnull NSNumber *)option
                                  error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setLocalVoicePitch");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setLocalPublishFallbackOption:option.integerValue];
  result = @(ret);
  return result;
}

- (NSNumber *)addBeautyFilterPath:(NSString *)path
                             name:(NSString *)name
                            error:(FlutterError *_Nullable __autoreleasing *)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#addBeautyFilter");
#endif
  [[NERtcBeauty shareInstance] addBeautyFilterWithPath:path andName:name];
  return @(0);
}

- (nullable NSNumber *)clearStatsEventCallbackWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#clearStatsEvent");
#endif
  [[NERtcEngine sharedEngine] removeEngineMediaStatsObserver:self];
  return @(0);
}

- (nullable NSNumber *)enableBeautyEnabled:(nonnull NSNumber *)enabled
                                     error:
                                         (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableBeauty");
#endif
  [[NERtcBeauty shareInstance] setIsOpenBeauty:enabled.boolValue];
  return @(0);
}

- (nullable NSNumber *)enableEncryptionRequest:(nonnull NEFLTEnableEncryptionRequest *)request
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableEncryption");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcEncryptionConfig *config = [[NERtcEncryptionConfig alloc] init];
  if (request.mode.intValue == 0) {
    config.mode = NERtcEncryptionModeGMCryptoSM4ECB;
  }
  config.key = request.key;
  int ret = [[NERtcEngine sharedEngine] enableEncryption:request.enable.boolValue config:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    enableLocalSubStreamAudioEnable:(nonnull NSNumber *)enable
                              error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableLocalSubStreamAudio");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableLocalSubStreamAudio:enable.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    enableSuperResolutionEnable:(nonnull NSNumber *)enable
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableSuperResolution");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableSuperResolution:enable.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    enableVideoCorrectionEnable:(nonnull NSNumber *)enable
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableVideoCorrection");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableVideoCorrection:enable.boolValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    enableVirtualBackgroundRequest:(nonnull NEFLTEnableVirtualBackgroundRequest *)request
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableVirtualBackground");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcVirtualBackgroundSource *backData = [[NERtcVirtualBackgroundSource alloc] init];
  backData.backgroundSourceType = request.backgroundSourceType.unsignedIntegerValue;
  backData.color = request.color.unsignedIntegerValue;
  backData.source = request.source;
  backData.blur_degree = request.blur_degree.unsignedIntegerValue;

  int ret = [[NERtcEngine sharedEngine] enableVirtualBackground:request.enabled.boolValue
                                                       backData:backData];
  result = @(ret);
  return result;
}
#pragma mark AudioEffectApi

- (nullable NSNumber *)getEffectDurationEffectId:(nonnull NSNumber *)effectId
                                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                     error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#getEffectDuration");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  uint64_t duration = 0;
  int ret = [[NERtcEngine sharedEngine] getEffectDurationWithId:effectId.unsignedIntValue
                                                       duration:&duration];
  result = @(duration);
  return result;
}

- (nullable NSNumber *)getEffectPitchEffectId:(nonnull NSNumber *)effectId
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#getEffectPitch");
#endif
  int32_t pitch = 0;
  int ret = [[NERtcEngine sharedEngine] getEffectPitchWithId:effectId.unsignedIntValue
                                                       pitch:&pitch];
  NSNumber *result = [NSNumber numberWithInt:pitch];
  return result;
}

- (nullable NSNumber *)
    getEffectPlaybackVolumeEffectId:(nonnull NSNumber *)effectId
                              error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#getEffectPlaybackVolume");
#endif

  uint32_t volume = 0;
  int ret = [[NERtcEngine sharedEngine] getEffectPlaybackVolumeWithId:effectId.unsignedIntValue
                                                               volume:&volume];
  NSNumber *result = [[NSNumber alloc] initWithUnsignedInt:volume];
  return result;
}

- (nullable NSNumber *)
    getEffectSendVolumeEffectId:(nonnull NSNumber *)effectId
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#getEffectSendVolume");
#endif

  uint32_t volume = 0;
  int ret = [[NERtcEngine sharedEngine] getEffectSendVolumeWithId:effectId.unsignedIntValue
                                                           volume:&volume];
  NSNumber *result = [[NSNumber alloc] initWithUnsignedInt:volume];
  return result;
}

- (nullable NSNumber *)pauseAllEffectsWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#pauseAllEffects");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] pauseAllEffects];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)pauseEffectEffectId:(nonnull NSNumber *)effectId
                                     error:
                                         (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#pauseEffect");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] pauseEffectWitdId:effectId.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)playEffectRequest:(nonnull NEFLTPlayEffectRequest *)request
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#playEffect");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  uint32_t effectID = [request.effectId unsignedIntValue];
  NERtcCreateAudioEffectOption *option = [[NERtcCreateAudioEffectOption alloc] init];
  option.path = request.path;
  option.loopCount = [request.loopCount intValue];
  option.sendEnabled = [request.sendEnabled boolValue];
  option.playbackVolume = [request.playbackVolume boolValue];
  option.sendVolume = [request.sendVolume unsignedIntValue];
  option.playbackVolume = [request.playbackVolume unsignedIntValue];
  option.startTimeStamp = [request.startTimestamp longLongValue];
  option.sendWithAudioType = [request.sendWithAudioType intValue];
  option.progressInterval = [request.progressInterval unsignedLongLongValue];

  int ret = [[NERtcEngine sharedEngine] playEffectWitdId:effectID effectOption:option];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)resumeAllEffectsWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#resumeAllEffects");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] resumeAllEffects];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)resumeEffectEffectId:(nonnull NSNumber *)effectId
                                      error:
                                          (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#resumeEffect");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] resumeEffectWitdId:effectId.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setEffectPitchEffectId:(nonnull NSNumber *)effectId
                                        pitch:(nonnull NSNumber *)pitch
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#setEffectPitch");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setEffectPitchWithId:effectId.unsignedIntValue
                                                       pitch:pitch.intValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setEffectPlaybackVolumeEffectId:(nonnull NSNumber *)effectId
                             volume:(nonnull NSNumber *)volume
                              error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#setEffectPlaybackVolume");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setEffectPlaybackVolumeWithId:effectId.unsignedIntValue
                                                               volume:volume.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setEffectPositionEffectId:(nonnull NSNumber *)effectId
                                        position:(nonnull NSNumber *)position
                                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                     error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#setEffectPosition");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setEffectPositionWithId:effectId.unsignedIntValue
                                                       position:position.unsignedLongLongValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setEffectSendVolumeEffectId:(nonnull NSNumber *)effectId
                         volume:(nonnull NSNumber *)volume
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#setEffectSendVolume");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setEffectSendVolumeWithId:effectId.unsignedIntValue
                                                           volume:volume.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopEffectEffectId:(nonnull NSNumber *)effectId
                                    error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#stopEffect");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopEffectWitdId:effectId.unsignedIntValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    getEffectCurrentPositionEffectId:(nonnull NSNumber *)effectId
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#getEffectCurrentPosition");
#endif
  NSNumber *result;
  uint64_t position = 0;
  [[NERtcEngine sharedEngine] getEffectCurrentPositionWithId:effectId.unsignedIntValue
                                                    position:&position];
  result = [[NSNumber alloc] initWithUnsignedLongLong:position];
  return result;
}

- (nullable NSNumber *)setEffectPositionEffectId:(nonnull NSNumber *)effectId
                                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                     error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#setEffectPosition");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  uint64_t position = 0;
  int ret = [[NERtcEngine sharedEngine] setEffectPositionWithId:effectId.unsignedIntValue
                                                       position:position];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopAllEffectsWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioEffectApi#stopAllEffects");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopAllEffects];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)reportCustomEventRequest:(nonnull NEFLTReportCustomEventRequest *)request
                                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                    error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#reportCustomEvent");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] reportCustomEvent:request.eventName
                                           customIdentify:request.customIdentify
                                                    param:request.param];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setAudioSessionOperationRestrictionOption:(nonnull NSNumber *)option
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAudioSessionOperationRestriction");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setAudioSessionOperationRestriction:option.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setAudioSubscribeOnlyByRequest:(nonnull NEFLTSetAudioSubscribeOnlyByRequest *)request
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAudioSubscribeOnlyBy");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSArray<NSNumber *> *params = request.uidArray;
  int ret = [[NERtcEngine sharedEngine] setAudioSubscribeOnlyBy:params];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setBeautyEffectLevel:(nonnull NSNumber *)level
                                 beautyType:(nonnull NSNumber *)beautyType
                                      error:
                                          (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setBeautyEffect");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  [[NERtcBeauty shareInstance] setBeautyEffectWithValue:level.floatValue
                                                 atType:beautyType.integerValue];
  result = @(0);
  return result;
}

- (nullable NSNumber *)setBeautyFilterLevelLevel:(nonnull NSNumber *)level
                                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                     error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setBeautyFilterLevel");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  result = @(0);
  return result;
}

- (nullable NSNumber *)setCloudProxyProxyType:(nonnull NSNumber *)proxyType
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setCloudProxy");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setCloudProxy:proxyType.unsignedIntegerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setRemoteHighPriorityAudioStreamRequest:
        (nonnull NEFLTSetRemoteHighPriorityAudioStreamRequest *)request
                                      error:
                                          (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setRemoteHighPriorityAudioStream");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret =
      [[NERtcEngine sharedEngine] setRemoteHighPriorityAudioStream:request.enabled.boolValue
                                                         forUserID:request.uid.unsignedLongLongValue
                                                        streamType:request.streamType.intValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setRemoteSubscribeFallbackOptionOption:(nonnull NSNumber *)option
                                     error:
                                         (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setRemoteSubscribeFallbackOption");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setRemoteSubscribeFallbackOption:option.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)setStatsEventCallbackWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setStatsEventCallback");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] addEngineMediaStatsObserver:self];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setVideoCorrectionConfigRequest:(nonnull NEFLTSetVideoCorrectionConfigRequest *)request
                              error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setVideoCorrectionConfig");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = -1;
  if (request.topLeft == nil && request.bottomLeft == nil) {
    ret = [[NERtcEngine sharedEngine] setVideoCorrectionConfig:nil];
    return @(ret);
  }
  NERtcVideoCorrectionConfiguration *config = [[NERtcVideoCorrectionConfiguration alloc] init];
  config.topLeft = CGPointMake(request.topLeft.x.doubleValue, request.topLeft.y.doubleValue);
  config.topRight = CGPointMake(request.topRight.x.doubleValue, request.topRight.y.doubleValue);
  config.bottomLeft =
      CGPointMake(request.bottomLeft.x.doubleValue, request.bottomLeft.y.doubleValue);
  config.bottomRight =
      CGPointMake(request.bottomRight.x.floatValue, request.bottomRight.y.floatValue);
  config.canvasWidth = request.canvasWidth.floatValue;
  config.canvasHeight = request.canvasHeight.floatValue;
  config.enableMirror = request.enableMirror.boolValue;
  ret = [[NERtcEngine sharedEngine] setVideoCorrectionConfig:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setVoiceBeautifierPresetPreset:(nonnull NSNumber *)preset
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setVoiceBeautifierPreset");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] setVoiceBeautifierPreset:preset.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)startBeautyWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startBeauty");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcBeauty shareInstance] startBeauty];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    startChannelMediaRelayRequest:(nonnull NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                            error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startChannelMediaReplay");
#endif
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
  int ret = [[NERtcEngine sharedEngine] startChannelMediaRelay:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    startLastmileProbeTestRequest:(nonnull NEFLTStartLastmileProbeTestRequest *)request
                            error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startLastmileProbeTest");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcLastmileProbeConfig *config = [[NERtcLastmileProbeConfig alloc] init];
  config.probeUplink = request.probeUplink;
  config.probeDownlink = request.probeDownlink;
  config.expectedUplinkBitrate = request.expectedUplinkBitrate.intValue;
  config.expectedDownlinkBitrate = request.expectedDownlinkBitrate.intValue;
  int ret = [[NERtcEngine sharedEngine] startLastmileProbeTest:config];
  result = @(ret);
  return result;
}

- (void)stopBeautyWithError:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopBeauty");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  [[NERtcBeauty shareInstance] stopBeauty];
  result = @(0);
  return;
}

- (nullable NSNumber *)stopChannelMediaRelayWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopChannelMediaRelay");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopChannelMediaRelay];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopLastmileProbeTestWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopLastmileProbeTest");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopLastmileProbeTest];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    stopVideoPreviewRequest:(nonnull NEFLTStartorStopVideoPreviewRequest *)request
                      error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopVideoPreview");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSUInteger type = request.streamType.unsignedIntegerValue;
  int ret = [[NERtcEngine sharedEngine] stopPreview:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    updateChannelMediaRelayRequest:(nonnull NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#updateChannelMediaRelay");
#endif
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
  int ret = [[NERtcEngine sharedEngine] updateChannelMediaRelay:config];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopAudioDumpWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopAudioDump");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopAudioDump];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)stopAudioRecordingWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopAudioRecording");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] stopAudioRecording];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)muteLocalVideoStreamMute:(nonnull NSNumber *)mute
                                     streamType:(nonnull NSNumber *)streamType
                                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                    error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#muteLocalVideoStream");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSUInteger type = streamType.unsignedIntegerValue;
  int ret = [[NERtcEngine sharedEngine] muteLocalVideo:mute.boolValue streamType:type];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    startAudioDumpWithTypeDumpType:(nonnull NSNumber *)dumpType
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startAudioDumpWithType");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] startAudioDumpWithType:dumpType.integerValue];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)updatePermissionKeyKey:(nonnull NSString *)key
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#updatePermissionKey");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] updatePermissionKey:key];
  result = @(ret);
  return result;
}

//- (nullable NEFLTRtcVersion *)versionWithError:
//    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
// #ifdef DEBUG
//  NSLog(@"FlutterCalled:EngineApi#version");
// #endif
//  NSNumber *result = [[NSNumber alloc] init];
//    NERtcEngine *ret = NERtcChannel.version;
//  result = @(ret);
//  return result;
//}

- (void)removeBeautyFilterWithError:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#removeBeautyFilter");
#endif
  [[NERtcBeauty shareInstance] removeBeautyFilter];
  return;
}

- (nullable NSNumber *)uploadSdkInfoWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#uploadSdkInfo");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  if (!_isInitialized) {
    result = @(-1);
    return result;
  }
  int ret = [[NERtcEngine sharedEngine] uploadSdkInfo];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    adjustLoopBackRecordingSignalVolumeVolume:(nonnull NSNumber *)volume
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#adjustLoopBackRecordingSignalVolume");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = 0;
  result = @(ret);
  return result;
}

- (nullable NSNumber *)getNtpTimeOffsetWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#getNtpTimeOffse");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int64_t ret = [[NERtcEngine sharedEngine] getNtpTimeOffset];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setStreamAlignmentPropertyEnable:(nonnull NSNumber *)enable
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setStreamAlignmentProperty");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  [[NERtcEngine sharedEngine] setStreamAlignmentProperty:enable.boolValue];
  result = @(0);
  return result;
}

- (nullable NSNumber *)enableMediaPubMediaType:(nonnull NSNumber *)mediaType
                                        enable:(nonnull NSNumber *)enable
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableMediaPub");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableMediaPub:enable.boolValue
                                         withMediaType:mediaType.unsignedIntegerValue];
  result = @(ret);
  return result;
}

- (nullable NSArray<NSString *> *)checkPermissionWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#checkPermission");
#endif
  NSArray<NSString *> *array = [[NSArray alloc] init];
  return array;
}

- (nullable NSNumber *)
    enableLoopbackRecordingEnable:(nonnull NSNumber *)enable
                            error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableLoopbackRecording");
#endif
  NSNumber *result = [NSNumber numberWithInt:0];
  return result;
}
- (NSNumber *)setParametersParams:(NSDictionary<NSString *, id> *)params
                            error:(FlutterError *_Nullable __autoreleasing *)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setParameters");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

  if ([params objectForKey:@"key_audio_ai_ns_enable"]) {
    [dic setObject:[params objectForKey:@"key_audio_ai_ns_enable"]
            forKey:kNERtcKeyChannel1V1ModeEnabled];
  }
  // video
  if ([params objectForKey:@"key_video_decode_mode"]) {
    NSString *value = [params objectForKey:@"key_video_decode_mode"];
    NSNumber *res = [[NSNumber alloc] initWithBool:false];
    if ([value isEqualToString:@"media_codec_default"]) {
      res = @(true);
    } else if ([value isEqualToString:@"media_codec_hardware"]) {
      res = @(true);
    } else {
      res = @(false);
    }
    [dic setObject:res forKey:kNERtcKeyVideoPreferHWDecode];
  }
  if ([params objectForKey:@"key_video_encode_mode"]) {
    NSString *value = [params objectForKey:@"key_video_encode_mode"];
    NSNumber *res = [[NSNumber alloc] initWithBool:false];
    if ([value isEqualToString:@"media_codec_default"]) {
      res = @(true);
    } else if ([value isEqualToString:@"media_codec_hardware"]) {
      res = @(true);
    } else {
      res = @(false);
    }
    [dic setObject:res forKey:kNERtcKeyVideoPreferHWEncode];
  }
  if ([params objectForKey:@"key_start_with_back_camera"]) {
    [dic setObject:[params objectForKey:@"key_start_with_back_camera"]
            forKey:kNERtcKeyVideoStartWithBackCamera];
  }
  if ([params objectForKey:@"key_video_send_mode"]) {
    NSUInteger mode = [[params objectForKey:@"key_video_send_mode"] unsignedIntValue];
    NSNumber *value = [[NSNumber alloc] initWithUnsignedLong:mode];
    [dic setObject:value forKey:kNERtcKeyVideoSendOnPubType];
  }
  if ([params objectForKey:@"key_auto_subscribe_video"]) {
    bool mode = [[params objectForKey:@"key_auto_subscribe_video"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyAutoSubscribeVideo];
  }

  // audio
  if ([params objectForKey:@"key_auto_subscribe_audio"]) {
    bool mode = [[params objectForKey:@"key_auto_subscribe_audio"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyAutoSubscribeAudio];
  }

  // record
  if ([params objectForKey:@"key_server_record_audio"]) {
    bool mode = [[params objectForKey:@"key_server_record_audio"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyRecordAudioEnabled];
  }
  if ([params objectForKey:@"key_server_record_mode"]) {
    NSUInteger mode = [[params objectForKey:@"key_server_record_mode"] unsignedIntValue];
    NSNumber *value = [[NSNumber alloc] initWithUnsignedLong:mode];
    [dic setObject:value forKey:kNERtcKeyRecordType];
  }
  if ([params objectForKey:@"key_server_record_speaker"]) {
    bool mode = [[params objectForKey:@"key_server_record_speaker"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyRecordHostEnabled];
  }
  if ([params objectForKey:@"key_server_record_video"]) {
    bool mode = [[params objectForKey:@"key_server_record_video"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyRecordVideoEnabled];
  }
  //
  if ([params objectForKey:@"sdk.getChannelInfo.custom.data"]) {
    NSString *value = [params objectForKey:@"sdk.getChannelInfo.custom.data"];
    [dic setObject:value forKey:kNERtcKeyLoginCustomData];
  }
  if ([params objectForKey:@"key_enable_1v1_mode"]) {
    bool mode = [[params objectForKey:@"key_enable_1v1_mode"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyChannel1V1ModeEnabled];
  }
  if ([params objectForKey:@"key_enable_report_volume_when_mute"]) {
    bool mode = [[params objectForKey:@"key_enable_report_volume_when_mute"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:KNERtcKeyEnableReportVolumeWhenMute];
  }
  if ([params objectForKey:@"key_custom_extra_info"]) {
    bool mode = [[params objectForKey:@"key_custom_extra_info"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeyExtraInfo];
  }
  if ([params objectForKey:@"key_disable_override_speaker_on_receiver"]) {
    bool mode = [[params objectForKey:@"key_disable_override_speaker_on_receiver"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:KNERtcKeyDisableOverrideSpeakerOnReceiver];
  }
  if ([params objectForKey:@"key_support_callkit"]) {
    bool mode = [[params objectForKey:@"key_support_callkit"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:kNERtcKeySupportCallkit];
  }

  if ([params objectForKey:@"key_disable_swaec_on_headset"]) {
    bool mode = [[params objectForKey:@"key_disable_swaec_on_headset"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:KNERtcKeyEnableReportVolumeWhenMute];
  }
  // 设置 debug 环境
  if ([params objectForKey:@"nertc.engine.debug.setting.enabled"]) {
    bool mode = [[params objectForKey:@"nertc.engine.debug.setting.enabled"] boolValue];
    NSNumber *value = [[NSNumber alloc] initWithBool:mode];
    [dic setObject:value forKey:@"nertc.engine.debug.setting.enabled"];
  }
  // 设置媒体服务器地址
  if ([params objectForKey:@"nrtc.g2.demo.server.uri"]) {
    NSString *mediaUrl = [params objectForKey:@"nrtc.g2.demo.server.uri"];
    [dic setObject:mediaUrl forKey:@"nrtc.g2.demo.server.uri"];
  }
  // 设置日志不加密
  if ([params objectForKey:@"sdk.enable.encrypt.log"]) {
    bool enableEncrypt = [[params objectForKey:@"sdk.enable.encrypt.log"] boolValue];
    [dic setObject:@(enableEncrypt) forKey:@"sdk.enable.encrypt.log"];
  }
  if ([params objectForKey:@"key_disable_first_user_create_channel"]) {
    bool disable = [[params objectForKey:@"key_disable_first_user_create_channel"] boolValue];
    [dic setObject:@(disable) forKey:kNERtcKeyDisableFirstJoinUserCreateChannel];
  }
  // 开启测试环境
  if ([params objectForKey:@"key_test_server_uri"]) {
    bool enableDebug = [[params objectForKey:@"key_test_server_uri"] boolValue];
    [dic setObject:@(enableDebug) forKey:@"sdk.enable.debug.environment"];
  }

  int ret = [[NERtcEngine sharedEngine] setParameters:dic];
  result = @(ret);
  return result;
}

- (nullable NEFLTNERtcVersion *)versionWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#versionWithError");
#endif
  NEFLTNERtcVersion *version = [[NEFLTNERtcVersion alloc] init];
  version.versionName = NERtcEngine.getVersion;
  return version;
}

- (nullable NSNumber *)
    takeLocalSnapshotStreamType:(nonnull NSNumber *)streamType
                           path:(nonnull NSString *)path
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#takeLocalSnapshot");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcStreamChannelType type = streamType.intValue;
  int ret = [[NERtcEngine sharedEngine]
      takeLocalSnapshot:type
               callback:^(int errorCode, UIImage *_Nullable image) {
                 NSNumber *code = [NSNumber numberWithInt:errorCode];
                 if (errorCode == 0) {
                   /// 将image存放至指定的路径
                   NSData *imageData = nil;
                   NSString *extension = [path pathExtension];
                   if ([extension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
                     imageData = UIImagePNGRepresentation(image);
                     NSError *error = nil;
                     BOOL success = [imageData writeToFile:path
                                                   options:NSDataWritingAtomic
                                                     error:&error];
                     if (!success) {
                       code = @(-1);
                     }
                   } else if ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame ||
                              [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame) {
                     imageData = UIImageJPEGRepresentation(image, 1.0);
                     BOOL success = [imageData writeToFile:path
                                                   options:NSDataWritingAtomic
                                                     error:&error];
                     if (!success) {
                       code = @(-1);
                     }
                   } else {
                     code = @(-1);
                   }
                 }

                 [self->_channelEventSink onTakeSnapshotResultCode:code
                                                              path:path
                                                        completion:^(FlutterError *_Nullable error){

                                                        }];
               }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)takeRemoteSnapshotUid:(nonnull NSNumber *)uid
                                  streamType:(nonnull NSNumber *)streamType
                                        path:(nonnull NSString *)path
                                       error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                 error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#takeRemoteSnapshotUid");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  NERtcStreamChannelType type = streamType.intValue;
  uint64_t userID = uid.unsignedLongLongValue;
  int ret = [[NERtcEngine sharedEngine]
      takeRemoteSnapshot:type
               forUserID:userID
                callback:^(int errorCode, UIImage *_Nullable image) {
                  if (errorCode == 0) {
                    NSNumber *code = [NSNumber numberWithInt:errorCode];
                    /// 将image存放至指定的路径
                    NSData *imageData = nil;
                    NSString *extension = [path pathExtension];
                    if ([extension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
                      imageData = UIImagePNGRepresentation(image);
                      BOOL success = [imageData writeToFile:path
                                                    options:NSDataWritingAtomic
                                                      error:&error];
                      if (!success) {
                        code = @(-1);
                      }
                    } else if ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame ||
                               [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame) {
                      imageData = UIImageJPEGRepresentation(image, 1.0);
                      BOOL success = [imageData writeToFile:path
                                                    options:NSDataWritingAtomic
                                                      error:&error];
                      if (!success) {
                        code = @(-1);
                      }
                    } else {
                      code = @(-1);
                    }
                    [self->_channelEventSink
                        onTakeSnapshotResultCode:code
                                            path:path
                                      completion:^(FlutterError *_Nullable error){

                                      }];
                  }
                }];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setExternalVideoSourceStreamType:(nonnull NSNumber *)streamType
                              enable:(nonnull NSNumber *)enable
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setExternalVideoSource");
#endif
  int ret = [[NERtcEngine sharedEngine] setExternalVideoSource:enable.boolValue
                                                    streamType:streamType.unsignedIntegerValue];
  return @(ret);
}

- (nullable NSNumber *)
    pushExternalVideoFrameStreamType:(nonnull NSNumber *)streamType
                               frame:(nonnull NEFLTVideoFrame *)frame
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#pushExternalVideoFrame");
#endif
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
  int ret = [[NERtcEngine sharedEngine] pushExternalVideoFrame:videoFrame
                                                    streamType:streamType.unsignedIntegerValue];
  return @(ret);
}

- (nullable NSNumber *)setVideoDumpDumpType:(NSNumber *)dumpType
                                      error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setVideoDumpDumpType");
#endif
  int ret = [[NERtcEngine sharedEngine] setVideoDump:dumpType.unsignedIntegerValue];
  return @(ret);
}

- (nullable NSString *)getParameterKey:(NSString *)key
                             extraInfo:(NSString *)extraInfo
                                 error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#getParameter");
#endif
  NSString *res = [[NERtcEngine sharedEngine] getParameter:key extraInfo:extraInfo];
  return res;
}

- (nullable NSNumber *)setVideoStreamLayerCountLayerCount:(NSNumber *)layerCount
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setVideoStreamLayerCount");
#endif
  int ret = [[NERtcEngine sharedEngine] setVideoStreamLayerCount:layerCount.unsignedIntegerValue];
  return @(ret);
}

- (nullable NSNumber *)enableLocalDataEnabled:(NSNumber *)enabled
                                        error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableLocalData");
#endif
  int ret = [[NERtcEngine sharedEngine] enableLocalData:enabled.boolValue];
  return @(ret);
}

- (nullable NSNumber *)subscribeRemoteDataSubscribe:(NSNumber *)subscribe
                                             userID:(NSNumber *)userID
                                              error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#subscribeRemoteData");
#endif
  int ret = [[NERtcEngine sharedEngine] subscribeRemoteData:subscribe.boolValue
                                                  forUserID:userID.unsignedLongLongValue];
  return @(ret);
}

- (nullable NSNumber *)getFeatureSupportedTypeType:(NSNumber *)type
                                             error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#getFeatureSupportedType");
#endif
  NERtcFeatureSupportType supportType =
      [[NERtcEngine sharedEngine] getFeatureSupportedType:type.unsignedIntegerValue];
  return @(supportType);
}

- (nullable NSNumber *)isFeatureSupportedType:(NSNumber *)type
                                        error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#isFeatureSupported");
#endif
  BOOL supported =
      [[NERtcEngine sharedEngine] isFeatureSupportedWithType:type.unsignedIntegerValue];
  return @(supported);
}

- (nullable NSNumber *)setSubscribeAudioBlocklistUidArray:(NSArray<NSNumber *> *)uidArray
                                               streamType:(NSNumber *)streamType
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setSubscribeAudioBlocklist");
#endif
  int ret = [[NERtcEngine sharedEngine] setSubscribeAudioBlocklist:streamType.unsignedIntegerValue
                                                          uidArray:uidArray];
  return @(ret);
}

- (nullable NSNumber *)setSubscribeAudioAllowlistUidArray:(NSArray<NSNumber *> *)uidArray
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setSubscribeAudioAllowlist");
#endif
  int ret = [[NERtcEngine sharedEngine] setSubscribeAudioAllowlist:uidArray];
  return @(ret);
}

- (int)convertNetworkType:(NERtcNetworkConnectionType)type {
  switch (type) {
    case kNERtcNetworkConnectionTypeNone:
      return 10;
    case kNERtcNetworkConnectionTypeUnknown:
      return 0;
    case kNERtcNetworkConnectionType2G:
      return 5;
    case kNERtcNetworkConnectionType3G:
      return 4;
    case kNERtcNetworkConnectionType4G:
      return 3;
    case kNERtcNetworkConnectionType5G:
      return 9;
    case kNERtcNetworkConnectionTypeWiFi:
      return 2;
    case kNERtcNetworkConnectionTypeWWAN:
      return 6;
    default:
      return 0;
  }
}

- (nullable NSNumber *)getNetworkTypeWithError:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#getNetworkType");
#endif
  NERtcNetworkConnectionType type = [[NERtcEngine sharedEngine] getNetworkType];
  return @([self convertNetworkType:type]);
}

- (nullable NSNumber *)stopPushStreamingWithError:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopPushStreaming");
#endif
  int ret = [[NERtcEngine sharedEngine] stopPushStreaming];
  return @(ret);
}

- (nullable NSNumber *)stopPlayStreamingStreamId:(NSString *)streamId
                                           error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopPlayStreaming");
#endif
  int ret = [[NERtcEngine sharedEngine] stopPlayStreaming:streamId];
  return @(ret);
}

- (nullable NSNumber *)pausePlayStreamingStreamId:(NSString *)streamId
                                            error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#pausePlayStreaming");
#endif
  int ret = [[NERtcEngine sharedEngine] pausePlayStreaming:streamId];
  return @(ret);
}

- (nullable NSNumber *)resumePlayStreamingStreamId:(NSString *)streamId
                                             error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#resumePlayStreaming");
#endif
  int ret = [[NERtcEngine sharedEngine] resumePlayStreaming:streamId];
  return @(ret);
}

- (nullable NSNumber *)muteVideoForPlayStreamingStreamId:(NSString *)streamId
                                                    mute:(NSNumber *)mute
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#muteVideoForPlayStreaming");
#endif
  int ret = [[NERtcEngine sharedEngine] muteVideoForPlayStreaming:streamId mute:mute.boolValue];
  return @(ret);
}

- (nullable NSNumber *)muteAudioForPlayStreamingStreamId:(NSString *)streamId
                                                    mute:(NSNumber *)mute
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#muteAudioForPlayStreaming");
#endif
  int ret = [[NERtcEngine sharedEngine] muteAudioForPlayStreaming:streamId mute:mute.boolValue];
  return @(ret);
}

- (nullable NSNumber *)startASRCaptionRequest:(NEFLTStartASRCaptionRequest *)request
                                        error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startASRCaption");
#endif
  NERtcASRCaptionConfig *config = [[NERtcASRCaptionConfig alloc] init];
  if (request.srcLanguage != nil) {
    config.srcLanguage = request.srcLanguage;
  }
  if (request.srcLanguageArr != nil) {
    config.srcLanguages = request.srcLanguageArr;
  }
  if (request.dstLanguageArr != nil) {
    config.dstLanguages = request.dstLanguageArr;
  }
  if (request.needTranslateSameLanguage != nil) {
    config.needTranslateSameLanguage = request.needTranslateSameLanguage.boolValue;
  }
  int ret = [[NERtcEngine sharedEngine] startASRCaption:config];
  return @(ret);
}

- (nullable NSNumber *)stopASRCaptionWithError:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopASRCaption");
#endif
  int ret = [[NERtcEngine sharedEngine] stopASRCaption];
  return @(ret);
}

- (nullable NSNumber *)aiManualInterruptDstUid:(NSNumber *)dstUid
                                         error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#aiManualInterrupt");
#endif
  int ret = [[NERtcEngine sharedEngine] aiManualInterrupt:dstUid.unsignedLongLongValue];
  return @(ret);
}

- (nullable NSNumber *)AINSModeMode:(NSNumber *)mode
                              error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAINSMode");
#endif
  int ret = [[NERtcEngine sharedEngine] setAINSMode:mode.unsignedIntegerValue];
  return @(ret);
}

- (nullable NSNumber *)setAudioScenarioScenario:(NSNumber *)scenario
                                          error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAudioScenario");
#endif
  int ret = [[NERtcEngine sharedEngine] setAudioScenario:scenario.unsignedIntegerValue];
  return @(ret);
}

- (nullable NSNumber *)setExternalAudioSourceEnabled:(NSNumber *)enabled
                                          sampleRate:(NSNumber *)sampleRate
                                            channels:(NSNumber *)channels
                                               error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setExternalAudioSource");
#endif
  int ret = [[NERtcEngine sharedEngine] setExternalAudioSource:enabled.boolValue
                                                    sampleRate:sampleRate.intValue
                                                      channels:channels.intValue];
  return @(ret);
}

- (nullable NSNumber *)setExternalSubStreamAudioSourceEnabled:(NSNumber *)enabled
                                                   sampleRate:(NSNumber *)sampleRate
                                                     channels:(NSNumber *)channels
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setExternalSubStreamAudioSource");
#endif
  int ret = [[NERtcEngine sharedEngine] setExternalSubStreamAudioSource:enabled.boolValue
                                                             sampleRate:sampleRate.intValue
                                                               channels:channels.intValue];
  return @(ret);
}

- (nullable NSNumber *)setAudioRecvRangeAudibleDistance:(NSNumber *)audibleDistance
                                 conversationalDistance:(NSNumber *)conversationalDistance
                                            rollOffMode:(NSNumber *)rollOffMode
                                                  error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setAudioRecvRange");
#endif
  NERtcDistanceRolloffModel rollOff = (NERtcDistanceRolloffModel)rollOffMode.intValue;
  int ret = [[NERtcEngine sharedEngine] setAudioRecvRange:audibleDistance.intValue
                                   conversationalDistance:conversationalDistance.intValue
                                                  rollOff:rollOff];
  return @(ret);
}

- (nullable NSNumber *)setRangeAudioModeAudioMode:(NSNumber *)audioMode
                                            error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setRangeAudioMode");
#endif
  NERtcRangeAudioMode mode = (NERtcRangeAudioMode)audioMode.intValue;
  int ret = [[NERtcEngine sharedEngine] setRangeAudioMode:mode];
  return @(ret);
}

- (nullable NSNumber *)setRangeAudioTeamIDTeamID:(NSNumber *)teamID
                                           error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setRangeAudioTeamID");
#endif
  int ret = [[NERtcEngine sharedEngine] setRangeAudioTeamID:teamID.intValue];
  return @(ret);
}

- (nullable NSNumber *)updateSelfPositionPositionInfo:(NEFLTPositionInfo *)positionInfo
                                                error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#updateSelfPosition");
#endif
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

  int ret = [[NERtcEngine sharedEngine] updateSelfPosition:info];
  return @(ret);
}

- (nullable NSNumber *)enableSpatializerRoomEffectsEnable:(NSNumber *)enable
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableSpatializerRoomEffects");
#endif
  int ret = [[NERtcEngine sharedEngine] enableSpatializerRoomEffects:enable.boolValue];
  return @(ret);
}

- (nullable NSNumber *)setSpatializerRoomPropertyProperty:(NEFLTSpatializerRoomProperty *)property
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setSpatializerRoomProperty");
#endif
  NERtcSpatializerRoomProperty *roomProperty = [[NERtcSpatializerRoomProperty alloc] init];
  roomProperty.roomCapacity = (NERtcSpatializerRoomCapacity)property.roomCapacity.intValue;
  roomProperty.material = (NERtcSpatializerMaterialName)property.material.intValue;
  roomProperty.reflectionScalar = property.reflectionScalar.floatValue;
  roomProperty.reverbGain = property.reverbGain.floatValue;
  roomProperty.reverbTime = property.reverbTime.floatValue;
  roomProperty.reverbBrightness = property.reverbBrightness.floatValue;

  int ret = [[NERtcEngine sharedEngine] setSpatializerRoomProperty:roomProperty];
  return @(ret);
}

- (nullable NSNumber *)setSpatializerRenderModeRenderMode:(NSNumber *)renderMode
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setSpatializerRenderMode");
#endif
  NERtcSpatializerRenderMode mode = (NERtcSpatializerRenderMode)renderMode.intValue;
  int ret = [[NERtcEngine sharedEngine] setSpatializerRenderMode:mode];
  return @(ret);
}

- (nullable NSNumber *)enableSpatializerEnable:(NSNumber *)enable
                                   applyToTeam:(NSNumber *)applyToTeam
                                         error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#enableSpatializer");
#endif
  int ret = [[NERtcEngine sharedEngine] enableSpatializer:enable.boolValue
                                              applyToTeam:applyToTeam.boolValue];
  return @(ret);
}

- (nullable NSNumber *)setUpSpatializerWithError:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#initSpatializer");
#endif
  int ret = [[NERtcEngine sharedEngine] initSpatializer];
  return @(ret);
}

- (nullable NSNumber *)addLocalRecordStreamForTaskConfig:(NEFLTLocalRecordingConfig *)config
                                                  taskId:(NSString *)taskId
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#addLocalRecordStreamForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)removeLocalRecorderStreamForTaskTaskId:(NSString *)taskId
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#removeLocalRecorderStreamForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)
    addLocalRecorderStreamLayoutForTaskConfig:(NEFLTLocalRecordingLayoutConfig *)config
                                          uid:(NSNumber *)uid
                                   streamType:(NSNumber *)streamType
                                  streamLayer:(NSNumber *)streamLayer
                                       taskId:(NSNumber *)taskId
                                        error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#addLocalRecorderStreamLayoutForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)removeLocalRecorderStreamLayoutForTaskUid:(NSNumber *)uid
                                                      streamType:(NSNumber *)streamType
                                                     streamLayer:(NSNumber *)streamLayer
                                                          taskId:(NSString *)taskId
                                                           error:(FlutterError *_Nullable *_Nonnull)
                                                                     error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#removeLocalRecorderStreamLayoutForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)
    updateLocalRecorderStreamLayoutForTaskInfos:(NSArray<NEFLTLocalRecordingStreamInfo *> *)infos
                                         taskId:(NSString *)taskId
                                          error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#updateLocalRecorderStreamLayoutForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)
    replaceLocalRecorderStreamLayoutForTaskInfos:(NSArray<NEFLTLocalRecordingStreamInfo *> *)infos
                                          taskId:(NSString *)taskId
                                           error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#replaceLocalRecorderStreamLayoutForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)
    updateLocalRecorderWaterMarksForTaskWatermarks:
        (NSArray<NEFLTVideoWatermarkConfig *> *)watermarks
                                            taskId:(NSString *)taskId
                                             error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#updateLocalRecorderWaterMarksForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)pushLocalRecorderVideoFrameForTaskUid:(NSNumber *)uid
                                                  streamType:(NSNumber *)streamType
                                                 streamLayer:(NSNumber *)streamLayer
                                                      taskId:(NSString *)taskId
                                                       frame:(NEFLTVideoFrame *)frame
                                                       error:(FlutterError *_Nullable *_Nonnull)
                                                                 error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#pushLocalRecorderVideoFrameForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)
    showLocalRecorderStreamDefaultCoverForTaskShowEnabled:(NSNumber *)showEnabled
                                                      uid:(NSNumber *)uid
                                               streamType:(NSNumber *)streamType
                                              streamLayer:(NSNumber *)streamLayer
                                                   taskId:(NSString *)taskId
                                                    error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#showLocalRecorderStreamDefaultCoverForTask");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)stopLocalRecorderRemuxMp4TaskId:(NSString *)taskId
                                                 error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopLocalRecorderRemuxMp4");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)remuxFlvToMp4FlvPath:(NSString *)flvPath
                                    mp4Path:(NSString *)mp4Path
                                    saveOri:(NSNumber *)saveOri
                                      error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#remuxFlvToMp4");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)stopRemuxFlvToMp4WithError:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#stopRemuxFlvToMp4");
#endif
  NSNumber *result = @(0);
  return result;
}

- (nullable NSNumber *)sendDataFrame:(NEFLTDataExternalFrame *)frame
                               error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#sendDataFrame");
#endif
  if (!frame || !frame.data) {
    if (error) {
      *error = [FlutterError errorWithCode:@"INVALID_PARAMETER"
                                   message:@"frame or frame.data is null"
                                   details:nil];
    }
    return @(-1);
  }

  NSData *data = frame.data.data;
  int ret = [[NERtcEngine sharedEngine] sendData:data];
  return @(ret);
}

- (nullable NSNumber *)pushExternalAudioFrameFrame:(NEFLTAudioExternalFrame *)frame
                                             error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#pushExternalAudioFrame");
#endif
  if (!frame || !frame.data) {
    if (error) {
      *error = [FlutterError errorWithCode:@"INVALID_PARAMETER"
                                   message:@"frame or frame.data is null"
                                   details:nil];
    }
    return @(-1);
  }

  // 创建 NERtcAudioFormat
  NERtcAudioFormat *audioFormat = [[NERtcAudioFormat alloc] init];
  audioFormat.type = kNERtcAudioTypePCM16;
  audioFormat.sampleRate = frame.sampleRate ? frame.sampleRate.unsignedIntValue : 48000;
  audioFormat.channels = frame.numberOfChannels ? frame.numberOfChannels.unsignedIntValue : 1;
  audioFormat.bytesPerSample = 2;  // PCM16 每个采样点 2 字节
  audioFormat.samplesPerChannel =
      frame.samplesPerChannel ? frame.samplesPerChannel.unsignedIntValue : 480;

  // 创建 NERtcAudioFrame
  NERtcAudioFrame *audioFrame = [[NERtcAudioFrame alloc] init];
  audioFrame.format = audioFormat;
  audioFrame.syncTimestamp = frame.syncTimestamp ? frame.syncTimestamp.longLongValue : 0;

  // 获取音频数据
  NSData *audioData = frame.data.data;
  if (audioData && audioData.length > 0) {
    // 需要将 NSData 转换为 void*，注意内存管理
    void *dataPtr = (void *)audioData.bytes;
    audioFrame.data = dataPtr;

    int ret = [[NERtcEngine sharedEngine] pushExternalAudioFrame:audioFrame];
    return @(ret);
  } else {
    if (error) {
      *error = [FlutterError errorWithCode:@"INVALID_PARAMETER"
                                   message:@"frame.data is empty"
                                   details:nil];
    }
    return @(-1);
  }
}

- (nullable NSNumber *)pushExternalSubAudioFrameFrame:(NEFLTAudioExternalFrame *)frame
                                                error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#pushExternalSubAudioFrame");
#endif
  if (!frame || !frame.data) {
    if (error) {
      *error = [FlutterError errorWithCode:@"INVALID_PARAMETER"
                                   message:@"frame or frame.data is null"
                                   details:nil];
    }
    return @(-1);
  }

  // 创建 NERtcAudioFormat
  NERtcAudioFormat *audioFormat = [[NERtcAudioFormat alloc] init];
  audioFormat.type = kNERtcAudioTypePCM16;
  audioFormat.sampleRate = frame.sampleRate ? frame.sampleRate.unsignedIntValue : 48000;
  audioFormat.channels = frame.numberOfChannels ? frame.numberOfChannels.unsignedIntValue : 1;
  audioFormat.bytesPerSample = 2;  // PCM16 每个采样点 2 字节
  audioFormat.samplesPerChannel =
      frame.samplesPerChannel ? frame.samplesPerChannel.unsignedIntValue : 480;

  // 创建 NERtcAudioFrame
  NERtcAudioFrame *audioFrame = [[NERtcAudioFrame alloc] init];
  audioFrame.format = audioFormat;
  audioFrame.syncTimestamp = frame.syncTimestamp ? frame.syncTimestamp.longLongValue : 0;

  // 获取音频数据
  NSData *audioData = frame.data.data;
  if (audioData && audioData.length > 0) {
    // 需要将 NSData 转换为 void*，注意内存管理
    void *dataPtr = (void *)audioData.bytes;
    audioFrame.data = dataPtr;

    int ret = [[NERtcEngine sharedEngine] pushExternalSubStreamAudioFrame:audioFrame];
    return @(ret);
  } else {
    if (error) {
      *error = [FlutterError errorWithCode:@"INVALID_PARAMETER"
                                   message:@"frame.data is empty"
                                   details:nil];
    }
    return @(-1);
  }
}

#pragma mark - NEFLTVideoRendererApi

- (nullable NSNumber *)createVideoRendererWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#createVideoRenderer");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = [self createWithTextureRegistry:_textures messenger:_messenger];
  self.renderers[@(renderer.textureId)] = renderer;
  result = @(renderer.textureId);
  return result;
}

- (nullable NSNumber *)
    setupPlayStreamingCanvasStreamId:(nonnull NSString *)streamId
                           textureId:(nonnull NSNumber *)textureId
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#setupPlayStreamingCanvas");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
  canvas.useExternalRender = YES;
  canvas.externalVideoRender = renderer;

  int ret = -1;
  if (renderer) {
    ret = [[NERtcEngine sharedEngine] setupPlayStreamingCanvas:streamId canvas:canvas];
  }
  result = @(ret);
  return result;
}

- (void)disposeVideoRendererTextureId:(nonnull NSNumber *)textureId
                                error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#disposeVideoRenderer");
#endif
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  [renderer dispose];
  [self.renderers removeObjectForKey:textureId];
}

- (nullable NSNumber *)setMirrorTextureId:(nonnull NSNumber *)textureId
                                   mirror:(nonnull NSNumber *)mirror
                                    error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#setMirror");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  int ret = -1;
  if (renderer) {
    [renderer setMirror:mirror.boolValue];
    ret = 0;
  }
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setupLocalSubStreamVideoRendererTextureId:(nonnull NSNumber *)textureId
                                   channelTag:(NSString *)channelTag
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#setupLocalSubStreamVideoRenderer");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
  canvas.useExternalRender = YES;
  canvas.externalVideoRender = renderer;

  int ret = -1;
  if (channelTag == nil || [channelTag isEqualToString:@""]) {
    ret = [[NERtcEngine sharedEngine] setupLocalSubStreamVideoCanvas:canvas];
  } else {
    NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
    ret = [channel setupLocalSubStreamVideoCanvas:canvas];
  }
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setupLocalVideoRendererTextureId:(nonnull NSNumber *)textureId
                          channelTag:(NSString *)channelTag
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#setupLocalVideoRenderer");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
  canvas.useExternalRender = YES;
  canvas.externalVideoRender = renderer;

  int ret = -1;
  if (channelTag == nil || [channelTag isEqualToString:@""]) {
    ret = [[NERtcEngine sharedEngine] setupLocalVideoCanvas:canvas];
  } else {
    NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
    ret = [channel setupLocalVideoCanvas:canvas];
  }

  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setupRemoteSubStreamVideoRendererUid:(nonnull NSNumber *)uid
                               textureId:(nonnull NSNumber *)textureId
                              channelTag:(NSString *)channelTag
                                   error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#setupRemoteSubStreamVideoRenderer");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
  canvas.useExternalRender = YES;
  canvas.externalVideoRender = renderer;

  int ret = -1;
  if (channelTag == nil || [channelTag isEqualToString:@""]) {
    ret = [[NERtcEngine sharedEngine] setupRemoteSubStreamVideoCanvas:canvas
                                                            forUserID:uid.unsignedLongLongValue];
  } else {
    NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
    ret = [channel setupRemoteSubStreamVideoCanvas:canvas forUserID:uid.unsignedLongLongValue];
  }
  result = @(ret);
  return result;
}

- (nullable NSNumber *)
    setupRemoteVideoRendererUid:(nonnull NSNumber *)uid
                      textureId:(nonnull NSNumber *)textureId
                     channelTag:(NSString *)channelTag
                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:VideoRendererApi#setupRemoteVideoRenderer");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  FlutterVideoRenderer *renderer = self.renderers[textureId];
  NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
  canvas.useExternalRender = YES;
  canvas.externalVideoRender = renderer;

  int ret = -1;
  if (channelTag == nil || [channelTag isEqualToString:@""]) {
    ret = [[NERtcEngine sharedEngine] setupRemoteVideoCanvas:canvas
                                                   forUserID:uid.unsignedLongLongValue];
  } else {
    NERtcChannel *channel = [[NERtcChannelManager sharedInstance] getChannel:channelTag];
    ret = [channel setupRemoteVideoCanvas:canvas forUserID:uid.unsignedLongLongValue];
  }
  result = @(ret);
  return result;
}
#pragma mark - NEFLTNERtcChannelEventSink

- (void)onNERtcEngineRejoinChannel:(NERtcError)result {
  [_channelEventSink onReJoinChannelResult:[NSNumber numberWithInt:result]
                                 channelId:@(0)
                                completion:^(FlutterError *_Nullable error){

                                }];
}

- (void)onNERtcEngineDidLeaveChannelWithResult:(NERtcError)result {
  NSNumber *res = [NSNumber numberWithInt:result];
#ifdef DEBUG
  NSLog(@"onNERtcEngineDidLeaveChannelWithResult");
#endif
  [_channelEventSink onLeaveChannelResult:res
                               completion:^(FlutterError *_Nullable error){
                               }];
}

- (void)onNERtcEngineConnectionStateChangeWithState:(NERtcConnectionStateType)state
                                             reason:(NERtcReasonConnectionChangedType)reason {
  NSNumber *states = [NSNumber numberWithUnsignedInteger:state];
  NSNumber *reasons = [NSNumber numberWithUnsignedInteger:reason];
  [_channelEventSink onConnectionStateChangedState:states
                                            reason:reasons
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}

- (void)onNERtcEngineNetworkConnectionTypeChanged:(NERtcNetworkConnectionType)newConnectionType {
  [_channelEventSink onConnectionTypeChangedNewConnectionType:
                         [NSNumber numberWithInteger:[self convertNetworkType:newConnectionType]]
                                                   completion:^(FlutterError *_Nullable error){

                                                   }];
}

- (void)onNERtcEngineDidDisconnectWithReason:(NERtcError)reason {
  [_channelEventSink onDisconnectReason:[NSNumber numberWithInt:reason]
                             completion:^(FlutterError *_Nullable error){
                             }];
}

- (void)onNERtcEngineReconnectingStart {
  [_channelEventSink onReconnectingStartWithCompletion:^(FlutterError *_Nullable error){
  }];
}

- (void)onNERtcEngineDidError:(NERtcError)errCode {
  [_channelEventSink onErrorCode:[NSNumber numberWithInt:errCode]
                      completion:^(FlutterError *_Nullable error){

                      }];
}

- (void)onNERtcEngineDidWarning:(NERtcWarning)warnCode msg:(NSString *)msg {
  [_channelEventSink onWarningCode:[NSNumber numberWithInt:warnCode]
                        completion:^(FlutterError *_Nullable error){

                        }];
}

- (void)onNERtcEngineUserDidJoinWithUserID:(uint64_t)userID
                                  userName:(NSString *)userName
                             joinExtraInfo:(NERtcUserJoinExtraInfo *)joinExtraInfo {
  NEFLTNERtcUserJoinExtraInfo *info =
      [NEFLTNERtcUserJoinExtraInfo makeWithCustomInfo:joinExtraInfo.customInfo];
  NEFLTUserJoinedEvent *event =
      [NEFLTUserJoinedEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                          joinExtraInfo:info];
  [_channelEventSink onUserJoinedEvent:event
                            completion:^(FlutterError *_Nullable error){

                            }];
}

- (void)onNERtcEngineUserDidLeaveWithUserID:(uint64_t)userID
                                     reason:(NERtcSessionLeaveReason)reason
                             leaveExtraInfo:(NERtcUserLeaveExtraInfo *)leaveExtraInfo {
  NEFLTNERtcUserLeaveExtraInfo *info =
      [NEFLTNERtcUserLeaveExtraInfo makeWithCustomInfo:leaveExtraInfo.customInfo];

  NEFLTUserLeaveEvent *event =
      [NEFLTUserLeaveEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                reason:[NSNumber numberWithInteger:reason]
                        leaveExtraInfo:info];
  [_channelEventSink onUserLeaveEvent:event
                           completion:^(FlutterError *_Nullable error){

                           }];
}

- (void)onNERtcEngineUserAudioDidStart:(uint64_t)userID {
  [_channelEventSink onUserAudioStartUid:[NSNumber numberWithUnsignedLongLong:userID]
                              completion:^(FlutterError *_Nullable error){

                              }];
}

- (void)onNERtcEngineUserAudioDidStop:(uint64_t)userID {
  [_channelEventSink onUserAudioStopUid:[NSNumber numberWithUnsignedLongLong:userID]
                             completion:^(FlutterError *_Nullable error){

                             }];
}

- (void)onNERtcEngineUserSubStreamDidStartWithUserID:(uint64_t)userID
                                    subStreamProfile:(NERtcVideoProfileType)profile {
  [_channelEventSink onUserSubStreamVideoStartUid:[NSNumber numberWithUnsignedLongLong:userID]
                                       maxProfile:[NSNumber numberWithUnsignedInteger:profile]
                                       completion:^(FlutterError *_Nullable error){

                                       }];
}

- (void)onNERtcEngineUserSubStreamDidStop:(uint64_t)userID {
  [_channelEventSink onUserSubStreamVideoStopUid:[NSNumber numberWithUnsignedLongLong:userID]
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineUserSubStreamAudioDidStart:(uint64_t)userID {
  [_channelEventSink onUserSubStreamAudioStartUid:[NSNumber numberWithUnsignedLongLong:userID]
                                       completion:^(FlutterError *_Nullable error){

                                       }];
}

- (void)onNERtcEngineUserSubStreamAudioDidStop:(uint64_t)userID {
  [_channelEventSink onUserSubStreamAudioStopUid:[NSNumber numberWithUnsignedLongLong:userID]
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineUserVideoDidStartWithUserID:(uint64_t)userID
                                    videoProfile:(NERtcVideoProfileType)profile {
  [_channelEventSink onUserVideoStartUid:[NSNumber numberWithUnsignedLongLong:userID]
                              maxProfile:[NSNumber numberWithUnsignedInteger:profile]
                              completion:^(FlutterError *_Nullable error){

                              }];
}

- (void)onNERtcEngineUserVideoDidStop:(uint64_t)userID {
  [_channelEventSink onUserVideoStopUid:[NSNumber numberWithUnsignedLongLong:userID]
                             completion:^(FlutterError *_Nullable error){

                             }];
}

- (void)onNERtcEngineUser:(uint64_t)userID videoMuted:(BOOL)muted {
  NEFLTUserVideoMuteEvent *event = [NEFLTUserVideoMuteEvent
      makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
            muted:[NSNumber numberWithBool:muted]
       streamType:[NSNumber numberWithUnsignedInteger:kNERtcAudioStreamMain]];
  [_channelEventSink onUserVideoMuteEvent:event
                               completion:^(FlutterError *_Nullable error){

                               }];
}

- (void)onNERtcEngineUser:(uint64_t)userID
               videoMuted:(BOOL)muted
               streamType:(NERtcStreamChannelType)streamType {
  NEFLTUserVideoMuteEvent *event =
      [NEFLTUserVideoMuteEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                     muted:[NSNumber numberWithBool:muted]
                                streamType:[NSNumber numberWithUnsignedInteger:streamType]];
  [_channelEventSink onUserVideoMuteEvent:event
                               completion:^(FlutterError *_Nullable error){

                               }];
}

- (void)onNERtcEngineUser:(uint64_t)userID audioMuted:(BOOL)muted {
  [_channelEventSink onUserAudioMuteUid:[NSNumber numberWithUnsignedLongLong:userID]
                                  muted:[NSNumber numberWithBool:muted]
                             completion:^(FlutterError *_Nullable error){

                             }];
}

- (void)onNERtcEngineUser:(uint64_t)userID subStreamAudioMuted:(BOOL)muted {
  [_channelEventSink onUserSubStreamAudioMuteUid:[NSNumber numberWithUnsignedLongLong:userID]
                                           muted:[NSNumber numberWithBool:muted]
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineFirstAudioDataDidReceiveWithUserID:(uint64_t)userID {
  [_channelEventSink onFirstAudioDataReceivedUid:[NSNumber numberWithUnsignedLongLong:userID]
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onEngineFirstAudioFrameDecoded:(uint64_t)userID {
  [_channelEventSink onFirstAudioFrameDecodedUid:[NSNumber numberWithUnsignedLongLong:userID]
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineFirstVideoDataDidReceiveWithUserID:(uint64_t)userID
                                             streamType:(NERtcStreamChannelType)streamType {
  NSNumber *type = [NSNumber numberWithUnsignedInteger:streamType];
  NEFLTFirstVideoDataReceivedEvent *event =
      [NEFLTFirstVideoDataReceivedEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                         streamType:type];
  [_channelEventSink onFirstVideoDataReceivedEvent:event
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}
- (void)onNERtcEngineLastmileQuality:(NERtcNetworkQuality)quality {
  NSNumber *qual = [NSNumber numberWithInt:quality];
  [_channelEventSink onLastmileQualityQuality:qual
                                   completion:^(FlutterError *_Nullable error){

                                   }];
}

- (void)onNERtcEngineLastmileProbeTestResult:(NERtcLastmileProbeResult *)result {
  NSNumber *state = [NSNumber numberWithUnsignedInteger:result.state];
  NSNumber *rtt = [NSNumber numberWithUnsignedInteger:result.rtt];
  NEFLTNERtcLastmileProbeOneWayResult *uplinkReport = [NEFLTNERtcLastmileProbeOneWayResult
      makeWithPacketLossRate:[NSNumber numberWithUnsignedInteger:result.uplinkReport.packetLossRate]
                      jitter:[NSNumber numberWithUnsignedInteger:result.uplinkReport.jitter]
          availableBandwidth:[NSNumber
                                 numberWithUnsignedInteger:result.uplinkReport.availableBandwidth]];
  NEFLTNERtcLastmileProbeOneWayResult *downlinkReport = [NEFLTNERtcLastmileProbeOneWayResult
      makeWithPacketLossRate:[NSNumber
                                 numberWithUnsignedInteger:result.downlinkReport.packetLossRate]
                      jitter:[NSNumber numberWithUnsignedInteger:result.downlinkReport.jitter]
          availableBandwidth:[NSNumber numberWithUnsignedInteger:result.downlinkReport
                                                                     .availableBandwidth]];

  NEFLTNERtcLastmileProbeResult *res = [NEFLTNERtcLastmileProbeResult makeWithState:state
                                                                                rtt:rtt
                                                                       uplinkReport:uplinkReport
                                                                     downlinkReport:downlinkReport];
  [_channelEventSink onLastmileProbeResultResult:res
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onEngineFirstVideoFrameDecoded:(uint64_t)userID
                                 width:(uint32_t)width
                                height:(uint32_t)height
                            streamType:(NERtcStreamChannelType)streamType {
  NSNumber *type = [NSNumber numberWithUnsignedInteger:streamType];
  NEFLTFirstVideoFrameDecodedEvent *event =
      [NEFLTFirstVideoFrameDecodedEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                              width:[NSNumber numberWithUnsignedInt:width]
                                             height:[NSNumber numberWithUnsignedInt:height]
                                         streamType:type];
  [_channelEventSink onFirstVideoFrameDecodedEvent:event
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}

- (void)onLocalAudioVolumeIndication:(int)volume withVad:(BOOL)enableVad {
  [_channelEventSink onLocalAudioVolumeIndicationVolume:[NSNumber numberWithInt:volume]
                                                vadFlag:[NSNumber numberWithBool:enableVad]
                                             completion:^(FlutterError *_Nullable error){

                                             }];
}

- (void)onRemoteAudioVolumeIndication:(NSArray<NERtcAudioVolumeInfo *> *)speakers
                          totalVolume:(int)totalVolume {
  NSMutableArray<NEFLTAudioVolumeInfo *> *speaker = [[NSMutableArray alloc] init];
  for (NERtcAudioVolumeInfo *item in speakers) {
    NEFLTAudioVolumeInfo *info = [NEFLTAudioVolumeInfo
            makeWithUid:[NSNumber numberWithUnsignedLongLong:item.uid]
                 volume:[NSNumber numberWithUnsignedInteger:item.volume]
        subStreamVolume:[NSNumber numberWithUnsignedInteger:item.subStreamVolume]];
    [speaker addObject:info];
  }
  NEFLTRemoteAudioVolumeIndicationEvent *event = [NEFLTRemoteAudioVolumeIndicationEvent
      makeWithVolumeList:speaker
             totalVolume:[NSNumber numberWithInt:totalVolume]];
  [_channelEventSink onRemoteAudioVolumeIndicationEvent:event
                                             completion:^(FlutterError *_Nullable error){

                                             }];
}

- (void)onNERTCEngineLiveStreamState:(NERtcLiveStreamStateCode)state
                              taskID:(NSString *)taskID
                                 url:(NSString *)url {
  [_channelEventSink onLiveStreamStateTaskId:taskID
                                     pushUrl:url
                                   liveState:[NSNumber numberWithInteger:state]
                                  completion:^(FlutterError *_Nullable error){

                                  }];
}

- (void)onNERtcEngineDidClientRoleChanged:(NERtcClientRole)oldRole
                                  newRole:(NERtcClientRole)newRole {
  [_channelEventSink onClientRoleChangeOldRole:[NSNumber numberWithInteger:oldRole]
                                       newRole:[NSNumber numberWithInteger:newRole]
                                    completion:^(FlutterError *_Nullable error){

                                    }];
}

- (void)onNERtcEngineAudioHasHowling {
  [_channelEventSink onAudioHasHowlingWithCompletion:^(FlutterError *_Nullable error){

  }];
}

- (void)onNERtcEngineAudioRecording:(NERtcAudioRecordingCode)code filePath:(NSString *)filePath {
  [_channelEventSink onAudioRecordingCode:[NSNumber numberWithInteger:code]
                                 filePath:filePath
                               completion:^(FlutterError *_Nullable error){

                               }];
}

- (void)onNERtcEngineRecvSEIMsg:(uint64_t)userID message:(NSData *)message {
  NSString *msg = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
  [_channelEventSink onRecvSEIMsgUserID:[NSNumber numberWithUnsignedLongLong:userID]
                                 seiMsg:msg
                             completion:^(FlutterError *_Nullable error){

                             }];
}

- (void)onNERtcEngineMediaRightChangeWithAudio:(BOOL)isAudioBannedByServer
                                         video:(BOOL)isVideoBannedByServer {
  [_channelEventSink
      onMediaRightChangeIsAudioBannedByServer:[NSNumber numberWithBool:isAudioBannedByServer]
                        isVideoBannedByServer:[NSNumber numberWithBool:isVideoBannedByServer]
                                   completion:^(FlutterError *_Nullable error){

                                   }];
}

- (void)onNERtcEngineChannelMediaRelayStateDidChange:(NERtcChannelMediaRelayState)state
                                         channelName:(NSString *)channelName {
  [_channelEventSink onMediaRelayStatesChangeState:[NSNumber numberWithInteger:state]
                                       channelName:channelName
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}

- (void)onNERtcEngineDidReceiveChannelMediaRelayEvent:(NERtcChannelMediaRelayEvent)event
                                          channelName:(NSString *)channelName
                                                error:(NERtcError)error {
  [_channelEventSink onMediaRelayReceiveEventEvent:[NSNumber numberWithInteger:event]
                                              code:[NSNumber numberWithInteger:error]
                                       channelName:channelName
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}

- (void)onNERtcEngineLocalPublishFallbackToAudioOnly:(BOOL)isFallback
                                          streamType:(NERtcStreamChannelType)streamType {
  NSNumber *type = [NSNumber numberWithUnsignedInteger:streamType];
  [_channelEventSink
      onLocalPublishFallbackToAudioOnlyIsFallback:[NSNumber numberWithBool:isFallback]
                                       streamType:type
                                       completion:^(FlutterError *_Nullable error){

                                       }];
}

- (void)onNERtcEngineRemoteSubscribeFallbackToAudioOnly:(uint64_t)uid
                                             isFallback:(BOOL)isFallback
                                             streamType:(NERtcStreamChannelType)streamType {
  NSNumber *type = [NSNumber numberWithUnsignedInteger:streamType];
  [_channelEventSink
      onRemoteSubscribeFallbackToAudioOnlyUid:[NSNumber numberWithUnsignedLongLong:uid]
                                   isFallback:[NSNumber numberWithBool:isFallback]
                                   streamType:type
                                   completion:^(FlutterError *_Nullable error){

                                   }];
}

- (void)onNERtcEngineLocalVideoWatermarkStateWithStreamType:(NERtcStreamChannelType)type
                                                      state:(NERtcLocalVideoWatermarkState)state {
  NSNumber *streamType = [NSNumber numberWithUnsignedInteger:type];
  [_channelEventSink onLocalVideoWatermarkStateVideoStreamType:streamType
                                                         state:[NSNumber numberWithInteger:state]
                                                    completion:^(FlutterError *_Nullable error){

                                                    }];
}

- (void)onNERtcEngineVirtualBackgroundSourceEnabled:(BOOL)enabled
                                             reason:
                                                 (NERtcVirtualBackgroundSourceStateReason)reason {
  NEFLTVirtualBackgroundSourceEnabledEvent *event = [NEFLTVirtualBackgroundSourceEnabledEvent
      makeWithEnabled:[NSNumber numberWithBool:enabled]
               reason:[NSNumber numberWithInteger:reason]];
  [_channelEventSink onVirtualBackgroundSourceEnabledEvent:event
                                                completion:^(FlutterError *_Nullable error){

                                                }];
}

- (void)onNERtcEnginePermissionKeyWillExpire {
  [_channelEventSink onPermissionKeyWillExpireWithCompletion:^(FlutterError *_Nullable error){

  }];
}

- (void)onNERtcEngineUpdatePermissionKey:(NSString *)key
                                   error:(NERtcError)error
                                 timeout:(NSUInteger)timeout {
  [_channelEventSink onUpdatePermissionKeyKey:key
                                        error:@(error)
                                      timeout:@(timeout)
                                   completion:^(FlutterError *_Nullable error){

                                   }];
}

- (void)onNERtcEngineAsrCaptionStateChanged:(NERtcAsrCaptionState)state
                                       code:(int)code
                                    message:(NSString *)message {
  [_channelEventSink onAsrCaptionStateChangedAsrState:@(state)
                                                 code:@(code)
                                              message:message
                                           completion:^(FlutterError *_Nullable error){

                                           }];
}

- (void)onNERtcEngineAsrCaptionResult:(NSArray<NERtcAsrCaptionResult *> *)results {
  if (results == nil || results.count == 0) {
    return;
  }
  NSMutableArray<NSDictionary<id, id> *> *resultArray =
      [NSMutableArray arrayWithCapacity:results.count];
  for (NERtcAsrCaptionResult *result in results) {
    NSMutableDictionary<id, id> *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = @(result.uid);
    dict[@"isLocalUser"] = @(result.isLocalUser);
    dict[@"timestamp"] = @(result.timestamp);
    dict[@"content"] = result.content ?: @"";
    dict[@"language"] = result.language ?: @"";
    dict[@"haveTranslation"] = @(result.haveTranslation);
    dict[@"translatedText"] = result.translatedText ?: @"";
    dict[@"translationLanguage"] = result.translationLanguage ?: @"";
    dict[@"isFinal"] = @(result.isFinal);
    [resultArray addObject:dict];
  }
  [_channelEventSink onAsrCaptionResultResult:resultArray
                                  resultCount:@(results.count)
                                   completion:^(FlutterError *_Nullable error){

                                   }];
}

- (void)onNERtcEnginePlayStreamingStateChange:(NSString *)streamId
                                        state:(NERtcLivePlayStreamState)state
                                        error:(NERtcError)error {
  [_channelEventSink onPlayStreamingStateChangeStreamId:streamId
                                                  state:@(state)
                                                 reason:@(error)
                                             completion:^(FlutterError *_Nullable error){

                                             }];
}

- (void)onNERtcEnginePlayStreamingReceiveSeiMessage:(NSString *)streamId
                                            message:(NSString *)message {
  [_channelEventSink onPlayStreamingReceiveSeiMessageStreamId:streamId
                                                      message:message
                                                   completion:^(FlutterError *_Nullable error){

                                                   }];
}

- (void)onNERtcEnginePlayStreamingFirstAudioFramePlayed:(NSString *)streamId
                                                 timeMs:(int64_t)time_ms {
  [_channelEventSink onPlayStreamingFirstAudioFramePlayedStreamId:streamId
                                                           timeMs:@(time_ms)
                                                       completion:^(FlutterError *_Nullable error){

                                                       }];
}

- (void)onNERtcEnginePlayStreamingFirstVideoFrameRender:(NSString *)streamId
                                                 timeMs:(int64_t)time_ms
                                                  width:(uint32_t)width
                                                 height:(uint32_t)height {
  [_channelEventSink onPlayStreamingFirstVideoFrameRenderStreamId:streamId
                                                           timeMs:@(time_ms)
                                                            width:@(width)
                                                           height:@(height)
                                                       completion:^(FlutterError *_Nullable error){

                                                       }];
}

- (void)onNERtcEngineLocalFirstAudioPacketSent:(NERtcAudioStreamType)streamType {
  [_channelEventSink onLocalAudioFirstPacketSentAudioStreamType:@(streamType)
                                                     completion:^(FlutterError *_Nullable error){

                                                     }];
}

- (void)onEngineFirstVideoFrameRender:(uint64_t)userID
                                width:(uint32_t)width
                               height:(uint32_t)height
                              elapsed:(uint64_t)elapsed
                           streamType:(NERtcStreamChannelType)streamType {
  [_channelEventSink onFirstVideoFrameRenderUserID:@(userID)
                                        streamType:@(streamType)
                                             width:@(width)
                                            height:@(height)
                                       elapsedTime:@(elapsed)
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}

- (void)onNERtcEngineLocalVideoRenderSizeChanged:(NERtcStreamChannelType)streamType
                                           width:(uint32_t)width
                                          height:(uint32_t)height {
  [_channelEventSink onLocalVideoRenderSizeChangedVideoType:@(streamType)
                                                      width:@(width)
                                                     height:@(height)
                                                 completion:^(FlutterError *_Nullable error){

                                                 }];
}

- (void)onNERtcEngineUserVideoProfileDidUpdate:(uint64_t)userID
                                    maxProfile:(NERtcVideoProfileType)maxProfile {
  [_channelEventSink onUserVideoProfileUpdateUid:@(userID)
                                      maxProfile:@(maxProfile)
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineAudioDeviceStateChangeWithDeviceID:(NSString *)deviceID
                                             deviceType:(NERtcAudioDeviceType)deviceType
                                            deviceState:(NERtcAudioDeviceState)deviceState {
  [_channelEventSink onAudioDeviceStateChangeDeviceType:@(deviceType)
                                            deviceState:@(deviceState)
                                             completion:^(FlutterError *_Nullable error){

                                             }];
}

- (void)onNERtcEngineApiDidExecuted:(NSString *)apiName
                            errCode:(NERtcError)errCode
                                msg:(NSString *)msg {
  [_channelEventSink onApiCallExecutedApiName:apiName
                                       result:@(errCode)
                                      message:msg
                                   completion:^(FlutterError *_Nullable error){

                                   }];
}

- (void)onNERtcEngineRemoteVideoSizeDidChangedWithUserID:(uint64_t)userID
                                                   width:(uint32_t)width
                                                  height:(uint32_t)height
                                              streamType:(NERtcStreamChannelType)streamType {
  [_channelEventSink onRemoteVideoSizeChangedUserId:@(userID)
                                          videoType:@(streamType)
                                              width:@(width)
                                             height:@(height)
                                         completion:^(FlutterError *_Nullable error){

                                         }];
}

- (void)onNERtcEngineUserDataDidStart:(uint64_t)userID {
  [_channelEventSink onUserDataStartUid:@(userID)
                             completion:^(FlutterError *_Nullable error){

                             }];
}

- (void)onNERtcEngineUserDataDidStop:(uint64_t)userID {
  [_channelEventSink onUserDataStopUid:@(userID)
                            completion:^(FlutterError *_Nullable error){

                            }];
}

- (void)onNERtcEngineUserDataReceiveMessage:(uint64_t)userID data:(NSData *)data {
  FlutterStandardTypedData *bufferData = [FlutterStandardTypedData typedDataWithBytes:data];
  [_channelEventSink onUserDataReceiveMessageUid:@(userID)
                                      bufferData:bufferData
                                      bufferSize:@(data.length)
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineUserDataStateChanged:(uint64_t)userID {
  [_channelEventSink onUserDataStateChangedUid:@(userID)
                                    completion:^(FlutterError *_Nullable error){

                                    }];
}

- (void)onNERtcEngineUserDataBufferedAmountChanged:(uint64_t)userID
                                    previousAmount:(uint64_t)previousAmount {
  [_channelEventSink onUserDataBufferedAmountChangedUid:@(userID)
                                         previousAmount:@(previousAmount)
                                             completion:^(FlutterError *_Nullable error){

                                             }];
}

- (void)onNERtcEngineLabFeatureDidCallbackWithKey:(NSString *)key param:(id)param {
  NSDictionary<id, id> *paramDict = nil;
  if ([param isKindOfClass:[NSDictionary class]]) {
    paramDict = (NSDictionary<id, id> *)param;
  } else if (param != nil) {
    paramDict = @{@"value" : param};
  } else {
    paramDict = @{};
  }
  [_channelEventSink onLabFeatureCallbackKey:key
                                       param:paramDict
                                  completion:^(FlutterError *_Nullable error){

                                  }];
}

- (void)onNERtcEngineAiDataWithType:(NSString *)type data:(NSString *)data {
  [_channelEventSink onAiDataType:type
                             data:data
                       completion:^(FlutterError *_Nullable error){

                       }];
}

- (void)onNERtcEngineStartPushStreamingWithResult:(NERtcError)result channelId:(uint64_t)channelId {
  [_channelEventSink onStartPushStreamingResult:@(result)
                                      channelId:@(channelId)
                                     completion:^(FlutterError *_Nullable error){

                                     }];
}

- (void)onNERtcEngineStopPushStreaming:(NERtcError)result {
  [_channelEventSink onStopPushStreamingResult:@(result)
                                    completion:^(FlutterError *_Nullable error){

                                    }];
}

- (void)onNERtcEnginePushStreamingChangeToReconnectingWithReason:(NERtcError)reason {
  [_channelEventSink onPushStreamingReconnectingReason:@(reason)
                                            completion:^(FlutterError *_Nullable error){

                                            }];
}

- (void)onNERtcEnginePushStreamingReconnectedSuccess {
  [_channelEventSink
      onPushStreamingReconnectedSuccessWithCompletion:^(FlutterError *_Nullable error){

      }];
}

#pragma mark - DeviceManagerApi
// ios没有此接口
- (nullable NSNumber *)enableEarbackEnabled:(nonnull NSNumber *)enabled
                                     volume:(nonnull NSNumber *)volume
                                      error:
                                          (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#enableEarback");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = [[NERtcEngine sharedEngine] enableEarback:enabled.boolValue
                                               volume:volume.unsignedIntValue];
  result = @(ret);
  return result;
}
// ios没有此接口
- (nullable NSNumber *)getCameraCurrentZoomWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#getCameraCurrentZoom");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = 0;
  result = @(ret);
  return result;
}

- (nullable NSNumber *)getCameraMaxZoomWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#getCameraMaxZoom");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  float ret = [[NERtcEngine sharedEngine] maxCameraZoomScale];
  result = @(ret);
  return result;
}

- (nullable NSNumber *)getCurrentCameraWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#getCurrentCamera");
#endif
  NSNumber *result = [[NSNumber alloc] init];
  int ret = 0;
  result = @(ret);
  return result;
}

- (nullable NSNumber *)isCameraExposurePositionSupportedWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isCameraExposurePositionSupported");
#endif
  bool ret = [[NERtcEngine sharedEngine] isCameraExposurePositionSupported];
  NSNumber *result = [NSNumber numberWithBool:ret];
  return result;
}

- (nullable NSNumber *)isCameraFocusSupportedWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isCameraFocusSupported");
#endif
  bool ret = [[NERtcEngine sharedEngine] isCameraFocusSupported];
  NSNumber *result = [NSNumber numberWithBool:ret];
  return result;
}

- (nullable NSNumber *)isCameraTorchSupportedWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isCameraTorchSupported");
#endif
  bool ret = [[NERtcEngine sharedEngine] isCameraTorchSupported];
  NSNumber *result = [NSNumber numberWithBool:ret];
  return result;
}

- (nullable NSNumber *)isCameraZoomSupportedWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isCameraZoomSupported");
#endif
  bool ret = [[NERtcEngine sharedEngine] isCameraZoomSupported];
  NSNumber *result = [NSNumber numberWithBool:ret];
  return result;
}

- (nullable NSNumber *)isPlayoutDeviceMuteWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isPlayoutDeviceMute");
#endif
  bool mute = false;
  [[NERtcEngine sharedEngine] getPlayoutDeviceMute:&mute];
  NSNumber *result = [NSNumber numberWithBool:mute];
  return result;
}

- (nullable NSNumber *)isRecordDeviceMuteWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isRecordDeviceMute");
#endif
  bool mute = false;
  [[NERtcEngine sharedEngine] getRecordDeviceMute:&mute];
  NSNumber *result = [NSNumber numberWithBool:mute];
  return result;
}

- (nullable NSNumber *)isSpeakerphoneOnWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#isSpeakerphoneOn");
#endif
  bool enable = false;
  [[NERtcEngine sharedEngine] getLoudspeakerMode:&enable];
  NSNumber *result = [NSNumber numberWithBool:enable];
  return result;
}

- (nullable NSNumber *)
    setAudioFocusModeFocusMode:(nonnull NSNumber *)focusMode
                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setAudioFocusMode");
#endif
  NSNumber *result = [NSNumber numberWithInt:0];
  return result;
}

- (nullable NSNumber *)
    setCameraExposurePositionRequest:(nonnull NEFLTSetCameraPositionRequest *)request
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setCameraExposurePosition");
#endif
  CGPoint point = CGPointMake(request.x.doubleValue, request.y.doubleValue);
  int ret = [[NERtcEngine sharedEngine] setCameraExposurePosition:point];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)
    setCameraFocusPositionRequest:(nonnull NEFLTSetCameraPositionRequest *)request
                            error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setCameraFocusPosition");
#endif
  int ret = [[NERtcEngine sharedEngine] setCameraFocusPositionX:request.x.floatValue
                                                              Y:request.y.floatValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setCameraTorchOnOn:(nonnull NSNumber *)on
                                    error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setCameraFocusPosition");
#endif
  int ret = [[NERtcEngine sharedEngine] setCameraTorchOn:on.boolValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setCameraZoomFactorFactor:(nonnull NSNumber *)factor
                                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                     error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setCameraZoomFactor");
#endif
  int ret = [[NERtcEngine sharedEngine] setCameraZoomFactor:factor.floatValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setEarbackVolumeVolume:(nonnull NSNumber *)volume
                                        error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                  error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setEarbackVolume");
#endif
  uint32_t volumes = [volume unsignedIntValue];
  int ret = [[NERtcEngine sharedEngine] setEarbackVolume:volumes];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setPlayoutDeviceMuteMute:(nonnull NSNumber *)mute
                                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                    error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setPlayoutDeviceMute");
#endif
  int ret = [[NERtcEngine sharedEngine] setPlayoutDeviceMute:mute.boolValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setRecordDeviceMuteMute:(nonnull NSNumber *)mute
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setRecordDeviceMute");
#endif
  int ret = [[NERtcEngine sharedEngine] setRecordDeviceMute:mute.boolValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setSpeakerphoneOnEnable:(nonnull NSNumber *)enable
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#setSpeakerphoneOn");
#endif
  int ret = [[NERtcEngine sharedEngine] setLoudspeakerMode:enable.boolValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)switchCameraWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#switchCamera");
#endif
  int ret = [[NERtcEngine sharedEngine] switchCamera];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)
    switchCameraWithPositionPosition:(nonnull NSNumber *)position
                               error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:DeviceManagerApi#switchCameraWithPosition");
#endif
  int ret = [[NERtcEngine sharedEngine] switchCameraWithPosition:position.unsignedIntegerValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

#pragma mark - DeviceDelegate

- (void)onNERtcEngineAudioDeviceRoutingDidChange:(NERtcAudioOutputRouting)routing {
  int selected = 0;
  switch (routing) {
    case kNERtcAudioOutputRoutingHeadset:
      selected = 1;
      break;
    case kNERtcAudioOutputRoutingEarpiece:
      selected = 2;
      break;
    case kNERtcAudioOutputRoutingLoudspeaker:
      selected = 0;
      break;
    case kNERtcAudioOutputRoutingBluetooth:
      selected = 3;
      break;
    default:
      break;
  }
  [_deviceEventSink onAudioDeviceChangedSelected:[NSNumber numberWithInt:selected]
                                      completion:^(FlutterError *_Nullable error){

                                      }];
}

- (void)onNERtcEngineVideoDeviceStateChangeWithDeviceID:(NSString *)deviceID
                                             deviceType:(NERtcVideoDeviceType)deviceType
                                            deviceState:(NERtcVideoDeviceState)deviceState {
  int state = 0;
  switch (deviceState) {
    case kNERtcVideoDeviceStateInitialized:
      state = 0;
      break;
    case kNERtcVideoDeviceStateStarted:
      state = 1;
      break;
    case kNERtcVideoDeviceStateStoped:
      state = 2;
      break;
    case kNERtcVideoDeviceStateUnInitialized:
      state = 6;
      break;
    default:
      break;
  }
  [_deviceEventSink onVideoDeviceStateChangeDeviceType:[NSNumber numberWithInt:deviceType]
                                           deviceState:@(state)
                                            completion:^(FlutterError *_Nullable error){

                                            }];
}

- (void)onNERtcCameraFocusChanged:(CGPoint)focusPoint {
  NSNumber *x = [NSNumber numberWithFloat:focusPoint.x];
  NSNumber *y = [NSNumber numberWithFloat:focusPoint.y];
  NEFLTCGPoint *point = [NEFLTCGPoint makeWithX:x y:y];
  [_deviceEventSink onCameraFocusChangedFocusPoint:point
                                        completion:^(FlutterError *_Nullable error){

                                        }];
}

- (void)onNERtcCameraExposureChanged:(CGPoint)exposurePoint {
  NSNumber *x = [NSNumber numberWithFloat:exposurePoint.x];
  NSNumber *y = [NSNumber numberWithFloat:exposurePoint.y];
  NEFLTCGPoint *point = [NEFLTCGPoint makeWithX:x y:y];
  [_deviceEventSink onCameraExposureChangedExposurePoint:point
                                              completion:^(FlutterError *_Nullable error){

                                              }];
}

#pragma mark - AudioMixingApi

- (nullable NSNumber *)getAudioMixingCurrentPositionWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingCurrentPosition");
#endif
  uint64_t posi = 0;
  [[NERtcEngine sharedEngine] getAudioMixingCurrentPosition:&posi];
  NSNumber *result = [NSNumber numberWithUnsignedLongLong:posi];
  return result;
}

- (nullable NSNumber *)getAudioMixingDurationWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingDuration");
#endif
  uint64_t param = 0;
  [[NERtcEngine sharedEngine] getAudioMixingDuration:&param];
  NSNumber *result = [NSNumber numberWithUnsignedLongLong:param];
  return result;
}

- (nullable NSNumber *)getAudioMixingPitchWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingPitch");
#endif
  int32_t param = 0;
  [[NERtcEngine sharedEngine] getAudioMixingPitch:&param];
  NSNumber *result = [NSNumber numberWithInt:param];
  return result;
}

- (nullable NSNumber *)getAudioMixingPlaybackVolumeWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingPlaybackVolume");
#endif
  uint32_t param = 0;
  [[NERtcEngine sharedEngine] getAudioMixingPlaybackVolume:&param];
  NSNumber *result = [NSNumber numberWithUnsignedInt:param];
  return result;
}

- (nullable NSNumber *)getAudioMixingSendVolumeWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingSendVolume");
#endif
  uint32_t param = 0;
  [[NERtcEngine sharedEngine] getAudioMixingSendVolume:&param];
  NSNumber *result = [NSNumber numberWithUnsignedInt:param];
  return result;
}

- (nullable NSNumber *)pauseAudioMixingWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#pauseAudioMixing");
#endif
  int ret = [[NERtcEngine sharedEngine] pauseAudioMixing];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)resumeAudioMixingWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#resumeAudioMixing");
#endif
  int ret = [[NERtcEngine sharedEngine] resumeAudioMixing];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)setAudioMixingPitchPitch:(nonnull NSNumber *)pitch
                                          error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                    error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPitch");
#endif
  int ret = [[NERtcEngine sharedEngine] setAudioMixingPitch:pitch.intValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)
    setAudioMixingPlaybackVolumeVolume:(nonnull NSNumber *)volume
                                 error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPlaybackVolume");
#endif
  int ret = [[NERtcEngine sharedEngine] setAudioMixingPlaybackVolume:volume.unsignedIntValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)
    setAudioMixingPositionPosition:(nonnull NSNumber *)position
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPosition");
#endif
  int ret = [[NERtcEngine sharedEngine] setAudioMixingPosition:position.unsignedLongLongValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)
    setAudioMixingSendVolumeVolume:(nonnull NSNumber *)volume
                             error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingSendVolume");
#endif
  int ret = [[NERtcEngine sharedEngine] setAudioMixingSendVolume:volume.unsignedIntValue];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)startAudioMixingRequest:(nonnull NEFLTStartAudioMixingRequest *)request
                                         error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                   error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#startAudioMixing");
#endif
  NERtcCreateAudioMixingOption *option = [[NERtcCreateAudioMixingOption alloc] init];
  option.path = request.path;
  option.loopCount = request.loopCount.intValue;
  option.sendEnabled = request.sendEnabled.boolValue;
  option.sendVolume = request.sendVolume.unsignedIntValue;
  option.playbackEnabled = request.playbackEnabled.boolValue;
  option.playbackVolume = request.playbackVolume.unsignedIntValue;
  option.startTimeStamp = request.startTimeStamp.longLongValue;
  option.progressInterval = request.progressInterval.unsignedLongLongValue;
  option.sendWithAudioType = request.sendWithAudioType.intValue;
  int ret = [[NERtcEngine sharedEngine] startAudioMixingWithOption:option];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)stopAudioMixingWithError:
    (FlutterError *_Nullable __autoreleasing *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:AudioMixingApi#stopAudioMixing");
#endif
  int ret = [[NERtcEngine sharedEngine] stopAudioMixing];
  NSNumber *result = [NSNumber numberWithInt:ret];
  return result;
}

- (nullable NSNumber *)startPushStreamingRequest:(NEFLTStartPushStreamingRequest *)request
                                           error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startPushStreaming");
#endif
  NERtcPushStreamingConfig *config = [[NERtcPushStreamingConfig alloc] init];
  if (request.streamingUrl != nil) {
    config.streamingUrl = request.streamingUrl;
  }
  if (request.streamingRoomInfo != nil) {
    NERtcStreamingRoomInfo *roomInfo = [[NERtcStreamingRoomInfo alloc] init];
    if (request.streamingRoomInfo.uid != nil) {
      roomInfo.uId = request.streamingRoomInfo.uid.unsignedLongLongValue;
    }
    if (request.streamingRoomInfo.channelName != nil) {
      roomInfo.channelName = request.streamingRoomInfo.channelName;
    }
    if (request.streamingRoomInfo.token != nil) {
      roomInfo.token = request.streamingRoomInfo.token;
    }
    config.streamingRoomInfo = roomInfo;
  }
  int ret = [[NERtcEngine sharedEngine] startPushStreaming:config];
  return @(ret);
}

- (nullable NSNumber *)startPlayStreamingRequest:(NEFLTStartPlayStreamingRequest *)request
                                           error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#startPlayStreaming");
#endif
  NERtcPlayStreamingConfig *config = [[NERtcPlayStreamingConfig alloc] init];
  if (request.streamingUrl != nil) {
    config.streamUrl = request.streamingUrl;
  }
  if (request.playOutDelay != nil) {
    config.playOutDelay = request.playOutDelay.unsignedIntValue;
  }
  if (request.reconnectTimeout != nil) {
    config.reconnectTimeout = request.reconnectTimeout.unsignedIntValue;
  }
  if (request.muteAudio != nil) {
    config.enableAudioPlay = !request.muteAudio.boolValue;
  }
  if (request.muteVideo != nil) {
    config.enableVideoPlay = !request.muteVideo.boolValue;
  }
  if (request.pausePullStream != nil) {
    config.pausePlayStreaming = request.pausePullStream.boolValue;
  }
  NSString *streamId = request.streamId ?: @"";
  int ret = [[NERtcEngine sharedEngine] startPlayStreaming:streamId playConfig:config];
  return @(ret);
}

- (nullable NSNumber *)setMultiPathOptionRequest:(NEFLTSetMultiPathOptionRequest *)request
                                           error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
  NSLog(@"FlutterCalled:EngineApi#setMultiPathOption");
#endif
  NERtcMultiPathOption *option = [[NERtcMultiPathOption alloc] init];
  if (request.enableMediaMultiPath != nil) {
    option.enableMultiPath = request.enableMediaMultiPath.boolValue;
  }
  if (request.mediaMode != nil) {
    option.mediaMode = request.mediaMode.integerValue;
  }
  if (request.badRttThreshold != nil) {
    option.badRttThreshold = request.badRttThreshold.unsignedIntValue;
  }
  if (request.redAudioPacket != nil) {
    option.redAudioPacket = request.redAudioPacket.boolValue;
  }
  if (request.redAudioRtxPacket != nil) {
    option.redAudioRtxPacket = request.redAudioRtxPacket.boolValue;
  }
  if (request.redVideoPacket != nil) {
    option.redVideoPacket = request.redVideoPacket.boolValue;
  }
  if (request.redVideoRtxPacket != nil) {
    option.redVideoRtxPacket = request.redVideoRtxPacket.boolValue;
  }
  int ret = [[NERtcEngine sharedEngine] setMultiPathOption:option];
  return @(ret);
}

#pragma mark NEFLTNERtcAudioMixingEventSink

- (void)onAudioMixingStateChanged:(NERtcAudioMixingState)state
                        errorCode:(NERtcAudioMixingErrorCode)errorCode {
#ifdef DEBUG
  NSLog(@"FlutterCallbaCK:onAudioMixingStateChanged");
#endif
  NSNumber *reason = [NSNumber numberWithUnsignedInteger:state];
  [_mixingEventSink onAudioMixingStateChangedReason:reason
                                         completion:^(FlutterError *_Nullable error){
                                         }];
}

- (void)onAudioMixingTimestampUpdate:(uint64_t)timeStampMS {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onAudioMixingTimestampUpdate");
#endif
  NSNumber *timestamp = [NSNumber numberWithUnsignedLongLong:timeStampMS];
  [_mixingEventSink onAudioMixingTimestampUpdateTimestampMs:timestamp
                                                 completion:^(FlutterError *_Nullable error){
                                                 }];
}

#pragma mark NEFLTNERtcAudioEffectEventSink

- (void)onAudioEffectFinished:(uint32_t)effectId {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onAudioEffectFinished");
#endif
  NSNumber *effId = [NSNumber numberWithUnsignedInt:effectId];
  [_effectEventSink onAudioEffectFinishedEffectId:effId
                                       completion:^(FlutterError *_Nullable error){

                                       }];
}

- (void)onAudioEffectTimestampUpdateWithId:(uint32_t)effectId timeStampMS:(uint64_t)timeStampMS {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onAudioEffectTimestampUpdateWithId");
#endif
  NSNumber *effId = [NSNumber numberWithUnsignedInt:effectId];
  NSNumber *timeStamp = [NSNumber numberWithUnsignedLongLong:timeStampMS];
  [_effectEventSink onAudioEffectTimestampUpdateId:effId
                                       timestampMs:timeStamp
                                        completion:^(FlutterError *_Nullable error){
                                        }];
}

#pragma mark NEFLTNERtcStatsEventSink

- (void)onLocalAudioStat:(NERtcAudioSendStats *)stat {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onLocalAudioStat");
#endif
  if (!stat) return;
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
  for (NERtcAudioLayerSendStats *list in stat.audioLayers) {
    [statList addObject:[self toAudioSend:list]];
  }
  [dic setObject:statList forKey:@"layers"];
  [_statsEventSink onLocalAudioStatsArguments:dic
                                   channelTag:@""
                                   completion:^(FlutterError *_Nullable error){
                                   }];
}

- (void)onLocalVideoStat:(NERtcVideoSendStats *)stat {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onLocalVideoStat");
#endif
  if (!stat) return;
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
  for (NERtcVideoLayerSendStats *list in stat.videoLayers) {
    [statList addObject:[self toVideoSend:list]];
  }
  [dic setObject:statList forKey:@"layers"];
  [_statsEventSink onLocalVideoStatsArguments:dic
                                   channelTag:@""
                                   completion:^(FlutterError *_Nullable error){
                                   }];
}

- (void)onRtcStats:(NERtcStats *)stat {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onRtcStats");
#endif
  if (!stat) return;
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setDictionary:[self toRtcStats:stat]];
  [_statsEventSink onRtcStatsArguments:dic
                            channelTag:@""
                            completion:^(FlutterError *_Nullable error){
                            }];
}

- (void)onNetworkQuality:(NSArray<NERtcNetworkQualityStats *> *)stats {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onNetworkQuality");
#endif
  NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
  for (NERtcNetworkQualityStats *stat in stats) {
    [statList addObject:[self toNetworkQuality:stat]];
  }
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setObject:statList forKey:@"list"];
  [_statsEventSink onNetworkQualityArguments:dic
                                  channelTag:@""
                                  completion:^(FlutterError *_Nullable error){
                                  }];
}

- (void)onRemoteAudioStats:(NSArray<NERtcAudioRecvStats *> *)stats {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onRemoteAudioStats");
#endif
  if (stats != nil && stats.count > 0) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
    for (NERtcAudioRecvStats *stat in stats) {
      [statList addObject:[self toRemoteAudioStats:stat]];
    }
    [dic setObject:statList forKey:@"list"];
    [_statsEventSink onRemoteAudioStatsArguments:dic
                                      channelTag:@""
                                      completion:^(FlutterError *_Nullable error){
                                      }];
  }
}

- (void)onRemoteVideoStats:(NSArray<NERtcVideoRecvStats *> *)stats {
#ifdef DEBUG
  NSLog(@"FlutterCallback:onRemoteVideoStats");
#endif
  if (stats != nil && stats.count > 0) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
    for (NERtcVideoRecvStats *stat in stats) {
      [statList addObject:[self toRemoteVideoStats:stat]];
    }
    [dic setObject:statList forKey:@"list"];
    [_statsEventSink onRemoteVideoStatsArguments:dic
                                      channelTag:@""
                                      completion:^(FlutterError *_Nullable error){
                                      }];
  }
}

- (NSMutableDictionary *)toRemoteVideoStats:(NERtcVideoRecvStats *)stats {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stats.uid] forKey:@"uid"];
  NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
  if (stats.videoLayers != nil) {
    for (NERtcVideoLayerRecvStats *stat in stats.videoLayers) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      [dic setObject:[NSNumber numberWithInt:stat.layerType] forKey:@"layerType"];
      [dic setObject:[NSNumber numberWithLongLong:stat.fps] forKey:@"fps"];
      [dic setObject:[NSNumber numberWithShort:stat.receivedBitrate] forKey:@"receivedBitrate"];
      [dic setObject:[NSNumber numberWithInt:stat.width] forKey:@"width"];
      [dic setObject:[NSNumber numberWithInt:stat.height] forKey:@"height"];
      [dic setObject:[NSNumber numberWithLongLong:stat.totalFrozenTime] forKey:@"totalFrozenTime"];
      [dic setObject:[NSNumber numberWithInt:stat.frozenRate] forKey:@"frozenRate"];
      [dic setObject:[NSNumber numberWithInt:stat.packetLossRate] forKey:@"packetLossRate"];
      [dic setObject:[NSNumber numberWithInt:stat.decoderOutputFrameRate]
              forKey:@"decoderOutputFrameRate"];
      [dic setObject:[NSNumber numberWithInt:stat.rendererOutputFrameRate]
              forKey:@"rendererOutputFrameRate"];
      [dic setObject:stat.decoderName forKey:@"decoderName"];
      [statList addObject:dic];
    }
  }
  [map setObject:statList forKey:@"layers"];
  return map;
}

- (NSMutableDictionary *)toRemoteAudioStats:(NERtcAudioRecvStats *)stats {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stats.uid] forKey:@"uid"];
  NSMutableArray<NSMutableDictionary *> *statList = [[NSMutableArray alloc] init];
  if (stats.audioLayers != nil) {
    for (NERtcAudioLayerRecvStats *stat in stats.audioLayers) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      [dic setObject:[NSNumber numberWithLongLong:stat.receivedBitrate] forKey:@"kbps"];
      [dic setObject:[NSNumber numberWithShort:stat.audioLossRate] forKey:@"lossRate"];
      [dic setObject:[NSNumber numberWithInt:stat.volume] forKey:@"volume"];
      [dic setObject:[NSNumber numberWithLongLong:stat.totalFrozenTime] forKey:@"totalFrozenTime"];
      [dic setObject:[NSNumber numberWithInt:stat.frozenRate] forKey:@"frozenRate"];
      [dic setObject:[NSNumber numberWithInt:stat.streamType] forKey:@"streamType"];
      [statList addObject:dic];
    }
    [map setValue:statList forKey:@"list"];
  }
  return map;
}

- (NSMutableDictionary *)toNetworkQuality:(NERtcNetworkQualityStats *)stats {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:[NSNumber numberWithLongLong:stats.userId] forKey:@"uid"];
  [map setObject:[NSNumber numberWithInt:stats.txQuality] forKey:@"txQuality"];
  [map setObject:[NSNumber numberWithInt:stats.rxQuality] forKey:@"rxQuality"];
  return map;
}

- (NSMutableDictionary *)toRtcStats:(NERtcStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:[NSNumber numberWithLongLong:stat.txBytes] forKey:@"txBytes"];
  [map setObject:[NSNumber numberWithLongLong:stat.rxBytes] forKey:@"rxBytes"];
  [map setObject:[NSNumber numberWithUnsignedInt:stat.cpuAppUsage] forKey:@"cpuAppUsage"];
  [map setObject:[NSNumber numberWithUnsignedInt:stat.cpuTotalUsage] forKey:@"cpuTotalUsage"];
  [map setObject:[NSNumber numberWithUnsignedInt:stat.memoryAppUsageRatio]
          forKey:@"memoryAppUsageRatio"];
  [map setObject:[NSNumber numberWithUnsignedInt:stat.memoryTotalUsageRatio]
          forKey:@"memoryTotalUsageRatio"];
  [map setObject:[NSNumber numberWithUnsignedInt:stat.memoryAppUsageInKBytes]
          forKey:@"memoryAppUsageInKBytes"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.totalDuration] forKey:@"totalDuration"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txAudioBytes] forKey:@"txAudioBytes"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txVideoBytes] forKey:@"txVideoBytes"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxAudioBytes] forKey:@"rxAudioBytes"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxVideoBytes] forKey:@"rxVideoBytes"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxVideoKBitRate]
          forKey:@"rxVideoKBitRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxAudioKBitRate]
          forKey:@"rxAudioKBitRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txAudioKBitRate]
          forKey:@"txAudioKBitRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txVideoKBitRate]
          forKey:@"txVideoKBitRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.upRtt] forKey:@"upRtt"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.downRtt] forKey:@"downRtt"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txAudioPacketLossRate]
          forKey:@"txAudioPacketLossRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txVideoPacketLossRate]
          forKey:@"txVideoPacketLossRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txVideoPacketLossSum]
          forKey:@"txVideoPacketLossSum"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txAudioPacketLossSum]
          forKey:@"txAudioPacketLossSum"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txAudioJitter] forKey:@"txAudioJitter"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.txVideoJitter] forKey:@"txVideoJitter"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxAudioPacketLossRate]
          forKey:@"rxAudioPacketLossRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxVideoPacketLossRate]
          forKey:@"rxVideoPacketLossRate"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxVideoPacketLossSum]
          forKey:@"rxVideoPacketLossSum"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxAudioPacketLossSum]
          forKey:@"rxAudioPacketLossSum"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxAudioJitter] forKey:@"rxAudioJitter"];
  [map setObject:[NSNumber numberWithUnsignedLongLong:stat.rxVideoJitter] forKey:@"rxVideoJitter"];
  return map;
}

- (NSMutableDictionary *)toAudioSend:(NERtcAudioLayerSendStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  int streamType = (stat.streamType == kNERtcAudioStreamMain) ? 0 : 1;
  [map setObject:@(streamType) forKey:@"streamType"];
  [map setObject:[NSNumber numberWithLongLong:stat.sentBitrate] forKey:@"kbps"];
  [map setObject:[NSNumber numberWithLongLong:stat.rtt] forKey:@"rtt"];
  [map setObject:[NSNumber numberWithInt:stat.volume] forKey:@"volume"];
  [map setObject:[NSNumber numberWithInt:stat.capVolume] forKey:@"capVolume"];
  [map setObject:[NSNumber numberWithShort:stat.numChannels] forKey:@"numChannels"];
  [map setObject:[NSNumber numberWithInt:stat.sentSampleRate] forKey:@"sentSampleRate"];
  [map setObject:[NSNumber numberWithShort:stat.lossRate] forKey:@"lossRate"];
  return map;
}

- (NSMutableDictionary *)toVideoSend:(NERtcVideoLayerSendStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:[NSNumber numberWithInt:stat.width] forKey:@"width"];
  [map setObject:[NSNumber numberWithInt:stat.height] forKey:@"height"];
  [map setObject:[NSNumber numberWithInt:stat.layerType] forKey:@"layerType"];
  [map setObject:[NSNumber numberWithInt:stat.captureWidth] forKey:@"captureWidth"];
  [map setObject:[NSNumber numberWithInt:stat.captureHeight] forKey:@"captureHeight"];
  [map setObject:[NSNumber numberWithInt:stat.captureFrameRate] forKey:@"captureFrameRate"];
  [map setObject:[NSNumber numberWithLongLong:stat.sendBitrate] forKey:@"sendBitrate"];
  [map setObject:[NSNumber numberWithInt:stat.encoderOutputFrameRate]
          forKey:@"encoderOutputFrameRate"];
  [map setObject:[NSNumber numberWithInt:stat.targetBitrate] forKey:@"targetBitrate"];
  [map setObject:[NSNumber numberWithInt:stat.encoderBitrate] forKey:@"encoderBitrate"];
  [map setObject:[NSNumber numberWithInt:stat.sentFrameRate] forKey:@"sentFrameRate"];
  [map setObject:stat.encoderName forKey:@"encoderName"];
  [map setObject:[NSNumber numberWithInt:stat.renderFrameRate] forKey:@"renderFrameRate"];
  [map setObject:[NSNumber numberWithBool:stat.dropBwStrategyEnabled]
          forKey:@"dropBwStrategyEnabled"];
  return map;
}

@end
