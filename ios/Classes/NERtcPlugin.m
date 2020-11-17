#import "NERtcPlugin.h"
#import "messages.h"
#import <NERtcSDK/NERtcSDK.h>
#import <FlutterVideoRenderer.h>


@interface NERtcPlugin () <FLTEngineApi, FLTDeviceManagerApi, FLTAudioMixingApi, FLTAudioEffectApi, FLTVideoRendererApi, NERtcEngineDelegateEx, NERtcEngineMediaStatsObserver>
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, FlutterVideoRenderer *> *renderers;
@end


@implementation NERtcPlugin {
    FlutterMethodChannel* _channel;
    id _registry;
    id _messenger;
    id _textures;
    BOOL _audioMixingCallbackEnabled;
    BOOL _deviceCallbackEnabled;
    BOOL _audioEffetCallbackEnabled;
}

#pragma mark - FlutterPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    NERtcPlugin* instance = [[NERtcPlugin alloc] initWithRegistrar:registrar];
    [registrar publish:instance];
    FLTEngineApiSetup(registrar.messenger, instance);
    FLTDeviceManagerApiSetup(registrar.messenger, instance);
    FLTAudioEffectApiSetup(registrar.messenger, instance);
    FLTAudioMixingApiSetup(registrar.messenger, instance);
    FLTVideoRendererApiSetup(registrar.messenger, instance);
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    _channel = nil;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    _registry = [registrar textures];
    _messenger = [registrar messenger];
    _textures = [registrar textures];
    self.renderers = [[NSMutableDictionary alloc] init];
    
    _channel = [FlutterMethodChannel methodChannelWithName:@"nertc_flutter" binaryMessenger:[registrar messenger]];
    _audioMixingCallbackEnabled = NO;
    _audioEffetCallbackEnabled = NO;
    _deviceCallbackEnabled = NO;
    return self;
}


#pragma mark - FLTEngineApi

- (nullable FLTIntValue *)create:(nonnull FLTCreateEngineRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#create");
#endif

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // Audio
    if(input.autoSubscribeAudio != nil) {
        [params setObject:input.autoSubscribeAudio forKey:kNERtcKeyAutoSubscribeAudio];
    }
    
    // Server Record
    if(input.serverRecordSpeaker != nil) {
        [params setObject:input.serverRecordSpeaker forKey:kNERtcKeyRecordHostEnabled];
    }
    if(input.serverRecordAudio != nil) {
        [params setObject:input.serverRecordAudio forKey:kNERtcKeyRecordAudioEnabled];
    }
    if(input.serverRecordVideo != nil) {
        [params setObject:input.serverRecordVideo forKey:kNERtcKeyRecordVideoEnabled];
    }
    if(input.serverRecordMode != nil) {
        [params setObject:input.serverRecordMode forKey:kNERtcKeyRecordType];
    }
    
    //Video
    if(input.videoEncodeMode != nil) {
        [params setObject:input.videoEncodeMode == 0 ? @(YES) : @(NO) forKey:kNERtcKeyVideoPreferHWEncode];
    }
    if(input.videoDecodeMode != nil) {
        [params setObject:input.videoDecodeMode == 0 ? @(YES) : @(NO) forKey:kNERtcKeyVideoPreferHWDecode];
    }
    if(input.videoSendMode != nil) {
        [params setObject:input.videoSendMode forKey:kNERtcKeyVideoSendOnPubType];
    }

    [params setObject:@(YES) forKey:kNERtcKeyVideoPreferMetalRender];
    
    [[NERtcEngine sharedEngine] setParameters: params];

    NERtcEngineContext *context = [[NERtcEngineContext alloc] init];
    context.appKey = input.appKey;
    context.logSetting = [[NERtcLogSetting alloc] init];
    if(input.logDir != nil) {
         context.logSetting.logDir = input.logDir;
    }
    if(input.logLevel != nil) {
         context.logSetting.logLevel = input.logLevel.intValue;
    }
    context.engineDelegate = self;
    int ret = [[NERtcEngine sharedEngine] setupEngineWithContext:context];
    
    FLTIntValue* result = [[FLTIntValue alloc] init];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)joinChannel:(nonnull FLTJoinChannelRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#joinChannel");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] joinChannelWithToken:input.token channelName:input.channelName myUid:input.uid.unsignedLongLongValue completion:^(NSError * _Nullable error, uint64_t channelId, uint64_t elapesd) {
        long code;
        if(error) {
            code = error.code;
        } else {
            code = 0;
        }
        [self onJoinChannel:code channelId:channelId elapsed:elapesd];
    }];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)leaveChannel:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#leaveChannel");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] leaveChannel];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)enableLocalAudio:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableLocalAudio");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableLocalAudio: input.value.boolValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)enableLocalVideo:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableLocalVideo");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableLocalVideo: input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)setLocalVideoConfig:(nonnull FLTSetLocalVideoConfigRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setLocalVideoConfig");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:input.frontCamera.boolValue ? @(NO) : @(YES) forKey:kNERtcKeyVideoStartWithBackCamera];
    [[NERtcEngine sharedEngine]setParameters:params];
    
    NERtcVideoEncodeConfiguration * config = [[NERtcVideoEncodeConfiguration alloc] init];
    config.maxProfile = input.videoProfile.intValue;
    config.cropMode = input.videoCropMode.intValue;
    config.bitrate = input.bitrate.intValue;
    config.minBitrate = input.minBitrate.intValue;
    config.frameRate = input.frameRate.intValue;
    config.minFrameRate = input.minBitrate.intValue;
    config.degradationPreference = input.degradationPrefer.intValue;
    int ret = [[NERtcEngine  sharedEngine] setLocalVideoConfig:config];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)setAudioProfile:(nonnull FLTSetAudioProfileRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setAudioProfile");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioProfile: (NERtcAudioProfileType)input.profile.intValue scenario:(NERtcAudioScenarioType)input.scenario.intValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)muteLocalAudioStream:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#muteLocalAudioStream");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] muteLocalAudio: input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)subscribeRemoteAudioStream:(nonnull FLTSubscribeRemoteAudioStreamRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeRemoteAudioStream");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] subscribeRemoteAudio:input.subscribe.boolValue forUserID:input.uid.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)subscribeAllRemoteAudioStreams:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeAllRemoteAudioStreams");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] subscribeAllRemoteAudio:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)subscribeRemoteVideoStream:(nonnull FLTSubscribeRemoteVideoStreamRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeRemoteVideoStream");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] subscribeRemoteVideo:input.subscribe.boolValue forUserID:input.uid.unsignedLongLongValue streamType:input.streamType.intValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)startVideoPreview:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#startVideoPreview");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] startPreview];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)stopVideoPreview:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#stopVideoPreview");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopPreview];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)muteLocalVideoStream:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#muteLocalVideoStream");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] muteLocalVideo: input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)startAudioDump:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#startAudioDump");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] startAudioDump];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)stopAudioDump:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#stopAudioDump");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] stopAudioDump];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)enableAudioVolumeIndication:(nonnull FLTEnableAudioVolumeIndicationRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableAudioVolumeIndication");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableAudioVolumeIndication: input.enable.boolValue interval:input.interval.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)adjustRecordingSignalVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#adjustRecordingSignalVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] adjustRecordingSignalVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)adjustPlaybackSignalVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#adjustPlaybackSignalVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] adjustPlaybackSignalVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)setStatsEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setStatsEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] addEngineMediaStatsObserver:self];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)clearStatsEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#clearStatsEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] cleanupEngineMediaStatsObserver];
    result.value = @(ret);
    return result;
}


//TODO:
- (nullable FLTIntValue *)startScreenCapture:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#startScreenCapture");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    result.value = @(-1);
    return result;
}


//TODO:
- (nullable FLTIntValue *)stopScreenCapture:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#stopScreenCapture");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    result.value = @(-1);
    return result;
}


- (void)release:(FlutterError * _Nullable __autoreleasing * _Nonnull)error withCompletion:(nonnull void (^)(void))completion {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#release");
#endif
    [[NERtcEngine sharedEngine] cleanupEngineMediaStatsObserver];
    _audioMixingCallbackEnabled = NO;
    _deviceCallbackEnabled = NO;
    _audioEffetCallbackEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NERtcEngine destroyEngine];
        dispatch_async(dispatch_get_main_queue(), ^{ 
            if(completion) {
                completion();
            }
        }); 
    });
}

- (nullable FLTIntValue *)enableDualStreamMode:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableDualStreamMode");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableDualStreamMode:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)setChannelProfile:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setChannelProfile");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setChannelProfile:input.value.intValue];
    result.value = @(ret);
    return result;
}


#pragma mark - FLTVideoRendererApi

- (nullable FLTIntValue *)createVideoRenderer:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#createVideoRenderer");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    FlutterVideoRenderer* renderer = [self createWithTextureRegistry:_textures messenger:_messenger];
    self.renderers[@(renderer.textureId)] = renderer;
    result.value = @(renderer.textureId);
    return result;
}

- (void)disposeVideoRenderer:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#disposeVideoRenderer");
#endif
    FlutterVideoRenderer *renderer = self.renderers[input.value];
    [renderer dispose];
    [self.renderers removeObjectForKey:input.value];
}

- (nullable FLTIntValue *)setupLocalVideoRenderer:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setupLocalVideoRenderer");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.value];
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.useExternalRender = YES;
    canvas.externalVideoRender = renderer;
    int ret = [[NERtcEngine sharedEngine] setupLocalVideoCanvas:canvas];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setupRemoteVideoRenderer:(nonnull FLTSetupRemoteVideoRendererRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setupRemoteVideoRenderer");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.textureId];
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.useExternalRender = YES;
    canvas.externalVideoRender = renderer;
    int ret = [[NERtcEngine sharedEngine] setupRemoteVideoCanvas:canvas forUserID:input.uid.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}

#pragma mark - FLTDeviceManagerApi

- (nullable FLTIntValue *)setDeviceEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setupRemoteVideoRenderer");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    _deviceCallbackEnabled = YES;
    result.value = @(0);
    return result;
}

- (nullable FLTIntValue *)clearDeviceEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#clearDeviceEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    _deviceCallbackEnabled = NO;
    result.value = @(0);
    return result;
}


- (nullable FLTBoolValue *)isSpeakerphoneOn:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#isSpeakerphoneOn");
#endif
    FLTBoolValue* result = [[FLTBoolValue alloc] init];
    bool enabled = false;
    [[NERtcEngine  sharedEngine] getLoudspeakerMode:&enabled];
    result.value = [NSNumber numberWithBool:enabled];
    return result;
}

- (nullable FLTIntValue *)setSpeakerphoneOn:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setSpeakerphoneOn");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setLoudspeakerMode:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)enableEarback:(nonnull FLTEnableEarbackRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#enableEarback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] enableEarback:input.enabled.boolValue volume:input.volume.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setEarbackVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setEarbackVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setEarbackVolume:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setCameraTorchOn:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setCameraTorchOn");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setCameraTorchOn:input.value.boolValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setCameraZoomFactor:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setCameraZoomFactor");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setCameraZoomFactor:input.value.floatValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTDoubleValue *)getCameraMaxZoom:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#getCameraMaxZoom");
#endif
    FLTDoubleValue* result = [[FLTDoubleValue alloc] init];
    float ret = [[NERtcEngine sharedEngine] maxCameraZoomScale];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setCameraFocusPosition:(nonnull FLTSetCameraFocusPositionRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setCameraFocusPosition");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setCameraFocusPositionX:input.x.floatValue Y:input.y.floatValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setPlayoutDeviceMute:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setPlayoutDeviceMute");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setPlayoutDeviceMute:input.value.boolValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTBoolValue *)isPlayoutDeviceMute:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#isPlayoutDeviceMute");
#endif
    FLTBoolValue* result = [[FLTBoolValue alloc] init];
    bool muted = false;
    [[NERtcEngine  sharedEngine] getPlayoutDeviceMute:&muted];
    result.value = [NSNumber numberWithBool:muted];
    return result;
}

- (nullable FLTIntValue *)setRecordDeviceMute:(nonnull FLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setRecordDeviceMute");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setRecordDeviceMute:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTBoolValue *)isRecordDeviceMute:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#isRecordDeviceMute");
#endif
    FLTBoolValue* result = [[FLTBoolValue alloc] init];
    bool muted = false;
    [[NERtcEngine  sharedEngine] getRecordDeviceMute:&muted];
    result.value = [NSNumber numberWithBool:muted];
    return result;
}

- (nullable FLTIntValue *)switchCamera:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#switchCamera");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] switchCamera];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setAudioFocusMode:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    //ignore
    FLTIntValue* result = [[FLTIntValue alloc] init];
    result.value = @(-1L);
    return result;
}



#pragma mark - FLTAudioMixingApi

- (nullable FLTIntValue *)setAudioMixingEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    _audioMixingCallbackEnabled = YES;
    result.value = @(0);
    return result;
}

- (nullable FLTIntValue *)clearAudioMixingEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#clearAudioMixingEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    _audioMixingCallbackEnabled = NO;
    result.value = @(0);
    return result;
}

- (nullable FLTIntValue *)startAudioMixing:(nonnull FLTStartAudioMixingRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#startAudioMixing");
#endif
    NERtcCreateAudioMixingOption* option = [[NERtcCreateAudioMixingOption alloc] init];
    if(input.path != nil) {
        option.path = input.path;
    }
    if(input.loopCount != nil) {
        option.loopCount = input.loopCount.intValue;
    }
    if(input.sendEnabled != nil) {
        option.sendEnabled = input.sendEnabled.boolValue;
    }
    if(input.sendVolume != nil) {
        option.sendVolume = input.sendVolume.unsignedIntValue;
    }
    if(input.playbackEnabled != nil) {
        option.playbackEnabled = input.playbackEnabled.boolValue;
    }
    if(input.playbackVolume != nil) {
        option.playbackVolume = input.playbackVolume.unsignedIntValue;
    }
    int ret = [[NERtcEngine  sharedEngine] startAudioMixingWithOption:option];
    FLTIntValue* result = [[FLTIntValue alloc] init];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)stopAudioMixing:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#stopAudioMixing");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] stopAudioMixing];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)pauseAudioMixing:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#pauseAudioMixing");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] pauseAudioMixing];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)resumeAudioMixing:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#resumeAudioMixing");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] resumeAudioMixing];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setAudioMixingSendVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingSendVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioMixingSendVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)getAudioMixingSendVolume:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingSendVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingSendVolume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}

- (nullable FLTIntValue *)setAudioMixingPlaybackVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPlaybackVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioMixingPlaybackVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)getAudioMixingPlaybackVolume:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingPlaybackVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingPlaybackVolume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}


- (nullable FLTIntValue *)setAudioMixingPosition:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPosition");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioMixingPosition:input.value.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)getAudioMixingCurrentPosition:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingCurrentPosition");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    uint64_t position = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingCurrentPosition:&position];
    if(ret == 0) {
        result.value = @(position);
    } else {
        result.value = @(-1);
    }
    return result;
}

- (nullable FLTIntValue *)getAudioMixingDuration:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingDuration");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    uint64_t position = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingCurrentPosition:&position];
    if(ret == 0) {
        result.value = @(position);
    } else {
        result.value = @(-1);
    }
    return result;
}


#pragma mark - FLTAudioEffectApi

- (nullable FLTIntValue *)setAudioEffectEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#setAudioEffectEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    _audioEffetCallbackEnabled = YES;
    result.value = @(0);
    return result;
}

- (nullable FLTIntValue *)clearAudioEffectEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#clearAudioEffectEventCallback");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    _audioEffetCallbackEnabled = NO;
    result.value = @(0);
    return result;
}

- (nullable FLTIntValue *)playEffect:(nonnull FLTPlayEffectRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#playEffect");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    NERtcCreateAudioEffectOption* option = [[NERtcCreateAudioEffectOption alloc] init];
    if(input.path != nil) {
        option.path = input.path;
    }
    if(input.loopCount != nil) {
        option.loopCount = input.loopCount.intValue;
    }
    if(input.sendEnabled != nil) {
        option.sendEnabled = input.sendEnabled.boolValue;
    }
    if(input.sendVolume != nil) {
        option.sendVolume = input.sendVolume.unsignedIntValue;
    }
    if(input.playbackEnabled != nil) {
        option.playbackEnabled = input.playbackEnabled.boolValue;
    }
    if(input.playbackVolume != nil) {
        option.playbackVolume = input.playbackVolume.unsignedIntValue;
    }
    int ret = [[NERtcEngine  sharedEngine] playEffectWitdId:input.effectId.intValue effectOption:option];
    result.value = @(ret);
    return result;
}


- (nullable FLTIntValue *)stopEffect:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#stopEffect");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopEffectWitdId:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)stopAllEffects:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#stopAllEffects");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopAllEffects];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)pauseEffect:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#pauseEffect");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] pauseEffectWitdId:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)pauseAllEffects:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#pauseAllEffects");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] pauseAllEffects];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)resumeEffect:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#resumeEffect");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] resumeEffectWitdId:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)resumeAllEffects:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#resumeAllEffects");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] resumeAllEffects];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)setEffectSendVolume:(nonnull FLTSetEffectSendVolumeRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#setEffectSendVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setEffectSendVolumeWithId:input.effectId.unsignedIntValue volume:input.volume.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)getEffectSendVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#getEffectSendVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getEffectSendVolumeWithId:input.value.unsignedIntValue volume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}


- (nullable FLTIntValue *)setEffectPlaybackVolume:(nonnull FLTSetEffectPlaybackVolumeRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#setEffectPlaybackVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setEffectPlaybackVolumeWithId:input.effectId.unsignedIntValue volume:input.volume.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable FLTIntValue *)getEffectPlaybackVolume:(nonnull FLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#getEffectPlaybackVolume");
#endif
    FLTIntValue* result = [[FLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getEffectPlaybackVolumeWithId:input.value.unsignedIntValue volume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}


#pragma mark - NERtcEngineDelegate

- (void)onNERtcEngineDidError:(NERtcError)errCode {
    [_channel invokeMethod:@"onError" arguments:@{@"code":@(errCode)}];
}

- (void)onJoinChannel:(long)result channelId:(uint64_t)channelId elapsed:(uint64_t)elapesd {
    [_channel invokeMethod:@"onJoinChannel" arguments:@{@"result": @(result), @"channelId": @(channelId), @"elapesd":@(elapesd)}];
}

- (void)onNERtcEngineDidLeaveChannelWithResult:(NERtcError)result {
    [_channel invokeMethod:@"onLeaveChannel" arguments:@{@"result": @(result)}];
}

- (void)onNERtcEngineDidDisconnectWithReason:(NERtcError)reason {
    [_channel invokeMethod:@"onDisconnect" arguments:@{@"reason": @(reason)}];
}

- (void)onNERtcEngineReconnectingStart {
    [_channel invokeMethod:@"onReconnectingStart" arguments:nil];
}

- (void)onNERtcEngineRejoinChannel:(NERtcError)result {
    [_channel invokeMethod:@"onReJoinChannel" arguments:@{@"result": @(result)}];
}

- (void)onNERtcEngineUserAudioDidStart:(uint64_t)userID {
    [_channel invokeMethod:@"onUserAudioStart" arguments:@{@"uid":@(userID)}];
}

- (void)onNERtcEngineUserAudioDidStop:(uint64_t)userID {
    [_channel invokeMethod:@"onUserAudioStop" arguments:@{@"uid":@(userID)}];
}

- (void)onNERtcEngineUserDidJoinWithUserID:(uint64_t)userID userName:(nonnull NSString *)userName {
    [_channel invokeMethod:@"onUserJoined" arguments:@{@"uid": @(userID), @"userName": userName}];
}

- (void)onNERtcEngineUserDidLeaveWithUserID:(uint64_t)userID reason:(NERtcSessionLeaveReason)reason {
    [_channel invokeMethod:@"onUserLeave" arguments:@{@"uid": @(userID), @"reason":@(reason)}];
}

- (void)onNERtcEngineUserVideoDidStartWithUserID:(uint64_t)userID videoProfile:(NERtcVideoProfileType)profile {
    [_channel invokeMethod:@"onUserVideoStart" arguments:@{@"uid":@(userID), @"maxProfile":@(profile)}];
}

- (void)onNERtcEngineUserVideoDidStop:(uint64_t)userID {
    [_channel invokeMethod:@"onUserVideoStop" arguments:@{@"uid":@(userID)}];
}





#pragma mark - AudioEffectDelegate

- (void)onAudioEffectFinished:(uint32_t)effectId {
    if(_audioEffetCallbackEnabled == NO) return;
    [_channel invokeMethod:@"onAudioEffectFinished" arguments:@{@"effectId":@(effectId)}];
}


#pragma mark - AudioMixingDelegate

- (void)onAudioMixingStateChanged:(NERtcAudioMixingState)state errorCode:(NERtcAudioMixingErrorCode)errorCode {
    if(_audioMixingCallbackEnabled == NO) return;
    [_channel invokeMethod:@"onAudioMixingStateChanged" arguments:@{@"state":@(state), @"errorCode":@(errorCode)}];
}

- (void)onAudioMixingTimestampUpdate:(uint64_t)timeStampMS {
    if(_audioMixingCallbackEnabled == NO) return;
    [_channel invokeMethod:@"onAudioMixingTimestampUpdate" arguments:@{@"timestampMs":@(timeStampMS)}];
}


#pragma mark - DeviceDelegate

- (void)onNERtcEngineAudioDeviceStateChangeWithDeviceID:(nonnull NSString *)deviceID deviceType:(NERtcAudioDeviceType)deviceType deviceState:(NERtcAudioDeviceState)deviceState {
    if(_deviceCallbackEnabled == NO) return;
    int type = 0;
    switch (deviceType) {
        case kNERtcAudioDeviceTypeUnknown:
            type = 0;
            break;
        case kNERtcAudioDeviceTypeRecord:
            type = 1;
            break;
        case kNERtcAudioDeviceTypePlayout:
            type = 2;
            break;
        default:
            break;
    }
    int state = 0;
    switch (deviceState) {
        case kNERtcAudioDeviceStateInitialized:
            state = 0;
            break;
        case kNERtcAudioDeviceStateStarted:
            state = 1;
            break;
        case kNERtcAudioDeviceStateStoped:
            state = 2;
            break;
        case kNERtcAudioDeviceStateUnInitialized:
            state = 6;
            break;
        default:
            break;
    }
    [_channel invokeMethod:@"onAudioDeviceStateChange" arguments:@{@"deviceId":deviceID, @"deviceType":@(type), @"deviceState":@(state)}];
}


- (void)onNERtcEngineVideoDeviceStateChangeWithDeviceID:(nonnull NSString *)deviceID deviceType:(NERtcVideoDeviceType)deviceType deviceState:(NERtcVideoDeviceState)deviceState {
    if(_deviceCallbackEnabled == NO) return;
    int state = 0;
    switch (deviceState) {
        case kNERtcAudioDeviceStateInitialized:
            state = 0;
            break;
        case kNERtcAudioDeviceStateStarted:
            state = 1;
            break;
        case kNERtcAudioDeviceStateStoped:
            state = 2;
            break;
        case kNERtcAudioDeviceStateUnInitialized:
            state = 6;
            break;
        default:
            break;
    }
    [_channel invokeMethod:@"onVideoDeviceStateChange" arguments:@{@"deviceId":deviceID, @"deviceState":@(state)}];
}

#pragma mark - NERtcEngineDelegateEx

- (void)onEngineFirstAudioFrameDecoded:(uint64_t)userID {
    [_channel invokeMethod:@"onEngineFirstAudioFrameDecoded" arguments:@{@"uid":@(userID)}];
}

- (void)onEngineFirstVideoFrameDecoded:(uint64_t)userID width:(uint32_t)width height:(uint32_t)height {
    [_channel invokeMethod:@"onEngineFirstVideoFrameDecoded" arguments:@{@"uid":@(userID), @"width":@(width), @"height":@(height)}];
}

- (void)onLocalAudioVolumeIndication:(int)volume {
    [_channel invokeMethod:@"onLocalAudioVolumeIndication" arguments:@{@"volume":@(volume)}];
}


- (void)onNERtcEngineFirstAudioDataDidReceiveWithUserID:(uint64_t)userID {
    [_channel invokeMethod:@"onFirstAudioDataReceived" arguments:@{@"uid":@(userID)}];
}

- (void)onNERtcEngineFirstVideoDataDidReceiveWithUserID:(uint64_t)userID {
    [_channel invokeMethod:@"onFirstVideoDataReceived" arguments:@{@"uid":@(userID)}];
}

- (void)onNERtcEngineHardwareResourceReleased:(NERtcError)result {
    // ignore
}

- (void)onNERtcEngineNetworkConnectionTypeChanged:(NERtcNetworkConnectionType)newConnectionType {
    int type = 0;
    switch (newConnectionType) {
        case kNERtcNetworkConnectionTypeNone:
            type = 9;
            break;
        case kNERtcNetworkConnectionTypeUnknown:
            type = 0;
            break;
        case kNERtcNetworkConnectionType2G:
            type = 5;
            break;
        case kNERtcNetworkConnectionType3G:
            type = 4;
            break;
        case kNERtcNetworkConnectionType4G:
            type = 3;
            break;
        case kNERtcNetworkConnectionTypeWiFi:
            type = 2;
            break;
        case kNERtcNetworkConnectionTypeWWAN:
            type = 6;
            break;
        default:
            break;
    }
    [_channel invokeMethod:@"onConnectionTypeChanged" arguments:@{@"newConnectionType": @(type)}];
}

- (void)onNERtcEngineUser:(uint64_t)userID audioMuted:(BOOL)muted {
    [_channel invokeMethod:@"onUserAudioMute" arguments:@{@"uid":@(userID), @"muted":@(muted)}];
}

- (void)onNERtcEngineUser:(uint64_t)userID videoMuted:(BOOL)muted {
    [_channel invokeMethod:@"onUserVideoMute" arguments:@{@"uid":@(userID), @"muted":@(muted)}];
}

- (void)onNERtcEngineUserVideoProfileDidUpdate:(uint64_t)userID maxProfile:(NERtcVideoProfileType)maxProfile {
    [_channel invokeMethod:@"onUserVideoProfileUpdate" arguments:@{@"uid":@(userID), @"maxProfile":@(maxProfile)}];
}

- (void)onRemoteAudioVolumeIndication:(nullable NSArray<NERtcAudioVolumeInfo *> *)speakers totalVolume:(int)totalVolume {
    if([speakers isKindOfClass:[NSArray class]] && speakers.count > 0) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for(NERtcAudioVolumeInfo* info in speakers) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:[NSNumber numberWithUnsignedLongLong:info.uid] forKey:@"uid"];
            [dictionary setValue:[NSNumber numberWithInt:info.volume] forKey:@"volume"];
            [array addObject:dictionary];
        }
        [_channel invokeMethod:@"onRemoteAudioVolumeIndication" arguments:@{@"volumeList":array, @"totalVolume":@(totalVolume)}];
    }
}


#pragma mark - NERtcEngineMediaStatsObserver


- (void)onLocalAudioStat:(nonnull NERtcAudioSendStats *)stat { 
    if(!stat) return;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithLongLong:stat.sentBitrate] forKey:@"kbps"];
    [dictionary setValue:[NSNumber numberWithInt:stat.lossRate] forKey:@"lossRate"];
    [dictionary setValue:[NSNumber numberWithLongLong:stat.rtt] forKey:@"rtt"];
    [dictionary setValue:[NSNumber numberWithInt:stat.volume] forKey:@"volume"];
    [dictionary setValue:[NSNumber numberWithInt:stat.numChannels] forKey:@"numChannels"];
    [dictionary setValue:[NSNumber numberWithInt:stat.sentSampleRate] forKey:@"sentSampleRate"];
    [_channel invokeMethod:@"onLocalAudioStats" arguments:dictionary];
}


- (void)onLocalVideoStat:(nonnull NERtcVideoSendStats *)stat { 
    if(!stat) return;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithInt:stat.encodedFrameWidth] forKey:@"width"];
    [dictionary setValue:[NSNumber numberWithInt:stat.encodedFrameHeight] forKey:@"height"];
    [dictionary setValue:[NSNumber numberWithLongLong:stat.bitRate] forKey:@"sendBitrate"];
    [dictionary setValue:[NSNumber numberWithInt:stat.encoderOutputFrameRate] forKey:@"encoderOutputFrameRate"];
    [dictionary setValue:[NSNumber numberWithInt:stat.captureFrameRate] forKey:@"captureFrameRate"];
    [dictionary setValue:[NSNumber numberWithInt:stat.targetBitrate] forKey:@"targetBitrate"];
    [dictionary setValue:[NSNumber numberWithInt:stat.sentFrameRate] forKey:@"sentFrameRate"];
    [_channel invokeMethod:@"onLocalVideoStats" arguments:dictionary];
}

- (void)onNetworkQuality:(nonnull NSArray<NERtcNetworkQualityStats *> *)stats { 
    if([stats isKindOfClass:[NSArray class]] && stats.count > 0) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for(NERtcNetworkQualityStats* stat in stats) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.userId] forKey:@"uid"];
            [dictionary setValue:[NSNumber numberWithInt:stat.txQuality] forKey:@"txQuality"];
            [dictionary setValue:[NSNumber numberWithInt:stat.rxQuality] forKey:@"rxQuality"];
            [array addObject:dictionary];
        }
        [_channel invokeMethod:@"onNetworkQuality" arguments:array];
    }
}


- (void)onRemoteAudioStats:(nonnull NSArray<NERtcAudioRecvStats *> *)stats { 
    if([stats isKindOfClass:[NSArray class]] && stats.count > 0) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for(NERtcAudioRecvStats* stat in stats) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.uid] forKey:@"uid"];
            [dictionary setValue:[NSNumber numberWithLongLong:stat.receivedBitrate] forKey:@"kbps"];
            [dictionary setValue:[NSNumber numberWithInt:stat.audioLossRate] forKey:@"lossRate"];
            [dictionary setValue:[NSNumber numberWithInt:stat.volume] forKey:@"volume"];
            [dictionary setValue:[NSNumber numberWithLongLong:stat.totalFrozenTime] forKey:@"totalFrozenTime"];
            [dictionary setValue:[NSNumber numberWithInt:stat.frozenRate] forKey:@"frozenRate"];
            [array addObject:dictionary];
        }
        [_channel invokeMethod:@"onRemoteAudioStats" arguments:array];
    }
}


- (void)onRemoteVideoStats:(nonnull NSArray<NERtcVideoRecvStats *> *)stats { 
    if([stats isKindOfClass:[NSArray class]] && stats.count > 0) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for(NERtcVideoRecvStats* stat in stats) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.uid] forKey:@"uid"];
            [dictionary setValue:[NSNumber numberWithInt:stat.width] forKey:@"width"];
            [dictionary setValue:[NSNumber numberWithInt:stat.height] forKey:@"height"];
            [dictionary setValue:[NSNumber numberWithLongLong:stat.receivedBitrate] forKey:@"receivedBitrate"];
            [dictionary setValue:[NSNumber numberWithInt:stat.packetLossRate] forKey:@"packetLossRate"];
            [dictionary setValue:[NSNumber numberWithInt:stat.decoderOutputFrameRate] forKey:@"decoderOutputFrameRate"];
            [dictionary setValue:[NSNumber numberWithInt:stat.rendererOutputFrameRate] forKey:@"rendererOutputFrameRate"];
            [dictionary setValue:[NSNumber numberWithLongLong:stat.totalFrozenTime] forKey:@"totalFrozenTime"];
            [dictionary setValue:[NSNumber numberWithInt:stat.frozenRate] forKey:@"frozenRate"];
            [array addObject:dictionary];
        }
        [_channel invokeMethod:@"onRemoteVideoStats" arguments:array];
    }
    
}

- (void)onRtcStats:(nonnull NERtcStats *)stat { 
    if(!stat) return;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithLongLong:stat.txBytes] forKey:@"txBytes"];
    [dictionary setValue:[NSNumber numberWithLongLong:stat.rxBytes] forKey:@"rxBytes"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.cpuAppUsage] forKey:@"cpuAppUsage"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.cpuTotalUsage] forKey:@"cpuTotalUsage"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.memoryAppUsageInKBytes] forKey:@"memoryAppUsageInKBytes"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.totalDuration] forKey:@"totalDuration"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.txAudioBytes] forKey:@"txAudioBytes"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.txVideoBytes] forKey:@"txVideoBytes"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.rxAudioBytes] forKey:@"rxAudioBytes"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.rxVideoBytes] forKey:@"rxVideoBytes"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.rxAudioKBitRate] forKey:@"rxAudioKBitRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.rxVideoKBitRate] forKey:@"rxVideoKBitRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.txAudioKBitRate] forKey:@"txAudioKBitRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.txVideoKBitRate] forKey:@"txVideoKBitRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.upRtt] forKey:@"upRtt"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.txAudioPacketLossRate] forKey:@"txAudioPacketLossRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.txVideoPacketLossRate] forKey:@"txVideoPacketLossRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.txAudioPacketLossSum] forKey:@"txAudioPacketLossSum"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.txVideoPacketLossSum] forKey:@"txVideoPacketLossSum"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.txAudioJitter] forKey:@"txAudioJitter"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.txVideoJitter] forKey:@"txVideoJitter"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.rxAudioPacketLossRate] forKey:@"rxAudioPacketLossRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.rxVideoPacketLossRate] forKey:@"rxVideoPacketLossRate"];
    [dictionary setValue:[NSNumber numberWithUnsignedLongLong:stat.rxAudioPacketLossSum] forKey:@"rxAudioPacketLossSum"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.rxVideoPacketLossSum] forKey:@"rxVideoPacketLossSum"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.rxAudioJitter] forKey:@"rxAudioJitter"];
    [dictionary setValue:[NSNumber numberWithUnsignedInt:stat.rxVideoJitter] forKey:@"rxVideoJitter"];
    [_channel invokeMethod:@"onRtcStats" arguments:dictionary];
}



@end

