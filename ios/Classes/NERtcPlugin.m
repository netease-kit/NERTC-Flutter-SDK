#import "NERtcPlugin.h"
#import "messages.h"
#import <NERtcSDK/NERtcSDK.h>
#import <FlutterVideoRenderer.h>
#import "FLNERtcEngineVideoFrameDelegate.h"

@interface NERtcPlugin () <NEFLTEngineApi, NEFLTDeviceManagerApi, NEFLTAudioMixingApi, NEFLTAudioEffectApi, NEFLTVideoRendererApi, NERtcEngineDelegateEx, NERtcEngineMediaStatsObserver>
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
    NEFLTEngineApiSetup(registrar.messenger, instance);
    NEFLTDeviceManagerApiSetup(registrar.messenger, instance);
    NEFLTAudioEffectApiSetup(registrar.messenger, instance);
    NEFLTAudioMixingApiSetup(registrar.messenger, instance);
    NEFLTVideoRendererApiSetup(registrar.messenger, instance);
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


#pragma mark - NEFLTEngineApi

- (nullable NEFLTIntValue *)create:(nonnull NEFLTCreateEngineRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#create");
#endif
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // Audio
    if(input.audioAutoSubscribe != nil) {
        [params setObject:input.audioAutoSubscribe forKey:kNERtcKeyAutoSubscribeAudio];
    }
    if(input.audioAINSEnabled != nil) {
        [params setObject:input.audioAINSEnabled forKey:KNERtcKeyAudioAINSEnable];
    }
    if(input.audioDisableSWAECOnHeadset != nil) {
        [params setObject:input.audioDisableSWAECOnHeadset forKey:KNERtcKeyDisableSWAECOnHeadset];
    }
    if(input.audioDisableOverrideSpeakerOnReceiver != nil) {
        [params setObject:input.audioDisableOverrideSpeakerOnReceiver forKey:KNERtcKeyDisableOverrideSpeakerOnReceiver];
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
    if(input.videoCaptureObserverEnabled!= nil) {
        [params setObject:input.videoCaptureObserverEnabled forKey:kNERtcKeyVideoCaptureObserverEnabled];
    }
   
    [params setObject:@(YES) forKey:kNERtcKeyVideoPreferMetalRender];
    
    //Live Stream
    if(input.publishSelfStream != nil) {
        [params setObject:input.publishSelfStream forKey:kNERtcKeyPublishSelfStreamEnabled];
    }


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
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)joinChannel:(nonnull NEFLTJoinChannelRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#joinChannel");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
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


- (nullable NEFLTIntValue *)leaveChannel:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#leaveChannel");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] leaveChannel];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)enableLocalAudio:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableLocalAudio");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableLocalAudio: input.value.boolValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)enableLocalVideo:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableLocalVideo");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableLocalVideo: input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)setLocalVideoConfig:(nonnull NEFLTSetLocalVideoConfigRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setLocalVideoConfig");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    
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
    config.width = input.width.intValue;
    config.height = input.height.intValue;
    int ret = [[NERtcEngine  sharedEngine] setLocalVideoConfig:config];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)setAudioProfile:(nonnull NEFLTSetAudioProfileRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setAudioProfile");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioProfile: (NERtcAudioProfileType)input.profile.intValue scenario:(NERtcAudioScenarioType)input.scenario.intValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)muteLocalAudioStream:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#muteLocalAudioStream");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] muteLocalAudio: input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)subscribeRemoteAudio:(nonnull NEFLTSubscribeRemoteAudioRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeRemoteAudio");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] subscribeRemoteAudio:input.subscribe.boolValue forUserID:input.uid.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)subscribeAllRemoteAudio:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeAllRemoteAudio");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] subscribeAllRemoteAudio:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)subscribeRemoteVideo:(nonnull NEFLTSubscribeRemoteVideoRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeRemoteVideo");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] subscribeRemoteVideo:input.subscribe.boolValue forUserID:input.uid.unsignedLongLongValue streamType:input.streamType.intValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)startVideoPreview:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#startVideoPreview");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] startPreview];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)stopVideoPreview:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#stopVideoPreview");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopPreview];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)muteLocalVideoStream:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#muteLocalVideoStream");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] muteLocalVideo: input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)startAudioDump:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#startAudioDump");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] startAudioDump];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)stopAudioDump:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#stopAudioDump");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] stopAudioDump];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)enableAudioVolumeIndication:(nonnull NEFLTEnableAudioVolumeIndicationRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableAudioVolumeIndication");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableAudioVolumeIndication: input.enable.boolValue interval:input.interval.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)adjustRecordingSignalVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#adjustRecordingSignalVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] adjustRecordingSignalVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}


// 在代理方法中对视频数据进行处理
- (void)onNERtcEngineVideoFrameCaptured:(CVPixelBufferRef)bufferRef rotation:(NERtcVideoRotationType)rotation
{
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#onNERtcEngineVideoFrameCaptured");
#endif
    if ([[FLNERtcEngineVideoFrameDelegate sharedCenter].observer respondsToSelector:@selector(onNERtcEngineVideoFrameCaptured:rotation:)]) {
        [[FLNERtcEngineVideoFrameDelegate sharedCenter].observer onNERtcEngineVideoFrameCaptured:bufferRef rotation:(NERtcVideoRotationType)rotation];
    }
}


- (nullable NEFLTIntValue *)adjustPlaybackSignalVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#adjustPlaybackSignalVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] adjustPlaybackSignalVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)setStatsEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setStatsEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] addEngineMediaStatsObserver:self];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)clearStatsEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#clearStatsEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] cleanupEngineMediaStatsObserver];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)startScreenCapture:(NEFLTStartScreenCaptureRequest*)input error:(FlutterError *_Nullable *_Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#startScreenCapture");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    NERtcVideoSubStreamEncodeConfiguration* config = [[NERtcVideoSubStreamEncodeConfiguration alloc] init];
    if(input.contentPrefer != nil) {
        config.contentPrefer = input.contentPrefer.intValue;
    }
    if(input.videoProfile != nil) {
        config.maxProfile = input.videoProfile.intValue;
    }
    if(input.frameRate != nil) {
        config.frameRate = input.frameRate.intValue;
    }
    if(input.minFrameRate != nil) {
        config.minFrameRate = input.minFrameRate.intValue;
    }
    if(input.bitrate != nil) {
        config.bitrate = input.bitrate.intValue;
    }
    if(input.minBitrate != nil) {
        config.minBitrate = input.minBitrate.intValue;
    }
    int ret = [[NERtcEngine sharedEngine] startScreenCapture:config];
    result.value = @(ret);
    return result;
}



- (nullable NEFLTIntValue *)stopScreenCapture:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#stopScreenCapture");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopScreenCapture];
    result.value = @(ret);
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

- (nullable NEFLTIntValue *)enableDualStreamMode:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#enableDualStreamMode");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] enableDualStreamMode:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)setChannelProfile:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setChannelProfile");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setChannelProfile:input.value.intValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)addLiveStreamTask:(nonnull NEFLTAddOrUpdateLiveStreamTaskRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#addLiveStreamTask");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    NERtcLiveStreamTaskInfo* taskInfo = [[NERtcLiveStreamTaskInfo alloc] init];
    NSNumber* serial = input.serial;
    if(input.taskId != nil) {
        taskInfo.taskID = input.taskId;
    }
    if(input.url != nil) {
        taskInfo.streamURL = input.url;
    }
    if(input.serverRecordEnabled != nil) {
        taskInfo.serverRecordEnabled = input.serverRecordEnabled.boolValue;
    }
    if(input.liveMode != nil) {
        taskInfo.lsMode = input.liveMode.intValue;
    }
    NERtcLiveStreamLayout* layout = [[NERtcLiveStreamLayout alloc] init];
    taskInfo.layout = layout;
    if(input.layoutWidth != nil) {
        layout.width = input.layoutWidth.intValue;
    }
    if(input.layoutHeight != nil) {
        layout.height = input.layoutHeight.intValue;
    }
    if(input.layoutBackgroundColor != nil) {
        layout.backgroundColor = input.layoutBackgroundColor.intValue & 0x00FFFFFF;
    }
    NERtcLiveStreamImageInfo* imageInfo = [[NERtcLiveStreamImageInfo alloc] init];
    if(input.layoutImageUrl != nil) {
        imageInfo.url = input.layoutImageUrl;
        //服务器根据Url来判断Image Info 是否合法, 不合法情况下不能有Image节点参数
        layout.bgImage = imageInfo;
    }
    if(input.layoutImageX != nil) {
        imageInfo.x = input.layoutImageX.intValue;
    }
    if(input.layoutImageY != nil) {
        imageInfo.y = input.layoutImageY.intValue;
    }
    if(input.layoutImageWidth != nil) {
        imageInfo.width = input.layoutImageWidth.intValue;
    }
    if(input.layoutImageHeight != nil) {
        imageInfo.height = input.layoutImageHeight.intValue;
    }
    NSMutableArray *userTranscodingArray = [NSMutableArray array];
    layout.users = userTranscodingArray;
    if(input.layoutUserTranscodingList != nil) {
        for(id dict in input.layoutUserTranscodingList) {
            NERtcLiveStreamUserTranscoding* userTranscoding = [[NERtcLiveStreamUserTranscoding alloc] init];
            NSNumber* uid = dict[@"uid"];
            if ((NSNull *)uid != [NSNull null]) {
                userTranscoding.uid = uid.unsignedLongLongValue;
            }
            NSNumber* videoPush = dict[@"videoPush"];
            if ((NSNull *)videoPush != [NSNull null]) {
                userTranscoding.videoPush = videoPush.boolValue;
            }
            NSNumber* audioPush = dict[@"audioPush"];
            if ((NSNull *)audioPush != [NSNull null]) {
                userTranscoding.audioPush = audioPush.boolValue;
            }
            NSNumber* adaption = dict[@"adaption"];
            if ((NSNull *)adaption != [NSNull null]) {
                userTranscoding.adaption = adaption.intValue;
            }
            NSNumber* x = dict[@"x"];
            if ((NSNull *)x != [NSNull null]) {
                userTranscoding.x = x.intValue;
            }
            NSNumber* y = dict[@"y"];
            if ((NSNull *)y != [NSNull null]) {
                userTranscoding.y = y.intValue;
            }
            NSNumber* width = dict[@"width"];
            if ((NSNull *)width != [NSNull null]) {
                userTranscoding.width = width.intValue;
            }
            NSNumber* height = dict[@"height"];
            if ((NSNull *)height != [NSNull null]) {
                userTranscoding.height = height.intValue;
            }
            [userTranscodingArray addObject:userTranscoding];
        }
    }
    
    int ret =  [[NERtcEngine sharedEngine] addLiveStreamTask:taskInfo compeltion:^(NSString * _Nonnull taskId, kNERtcLiveStreamError errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:serial forKey:@"serial"];
            NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
            [arguments setValue:taskId forKey:@"taskId"];
            [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
            [dictionary setValue:arguments forKey:@"arguments"];
            [self->_channel invokeMethod:@"onOnceEvent" arguments:dictionary];
        });
    }];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)removeLiveStreamTask:(nonnull NEFLTDeleteLiveStreamTaskRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#removeLiveStreamTask");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    NSNumber* serial = input.serial;
    int ret = [[NERtcEngine sharedEngine] removeLiveStreamTask:input.taskId compeltion:^(NSString * _Nonnull taskId, kNERtcLiveStreamError errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:serial forKey:@"serial"];
            NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
            [arguments setValue:taskId forKey:@"taskId"];
            [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
            [dictionary setValue:arguments forKey:@"arguments"];
            [self->_channel invokeMethod:@"onOnceEvent" arguments:dictionary];
        });
    }];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)updateLiveStreamTask:(nonnull NEFLTAddOrUpdateLiveStreamTaskRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#updateLiveStreamTask");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    NERtcLiveStreamTaskInfo* taskInfo = [[NERtcLiveStreamTaskInfo alloc] init];
    NSNumber* serial = input.serial;
    if(input.taskId != nil) {
        taskInfo.taskID = input.taskId;
    }
    if(input.url != nil) {
        taskInfo.streamURL = input.url;
    }
    if(input.serverRecordEnabled != nil) {
        taskInfo.serverRecordEnabled = input.serverRecordEnabled.boolValue;
    }
    if(input.liveMode != nil) {
        taskInfo.lsMode = input.liveMode.intValue;
    }
    NERtcLiveStreamLayout* layout = [[NERtcLiveStreamLayout alloc] init];
    taskInfo.layout = layout;
    if(input.layoutWidth != nil) {
        layout.width = input.layoutWidth.intValue;
    }
    if(input.layoutHeight != nil) {
        layout.height = input.layoutHeight.intValue;
    }
    if(input.layoutBackgroundColor != nil) {
        layout.backgroundColor = input.layoutBackgroundColor.intValue & 0x00FFFFFF;
    }
    NERtcLiveStreamImageInfo* imageInfo = [[NERtcLiveStreamImageInfo alloc] init];
    if(input.layoutImageUrl != nil) {
        imageInfo.url = input.layoutImageUrl;
        //服务器根据Url来判断Image Info 是否合法, 不合法情况下不能有Image节点参数
        layout.bgImage = imageInfo;
    }
    if(input.layoutImageX != nil) {
        imageInfo.x = input.layoutImageX.intValue;
    }
    if(input.layoutImageY != nil) {
        imageInfo.y = input.layoutImageY.intValue;
    }
    if(input.layoutImageWidth != nil) {
        imageInfo.width = input.layoutImageWidth.intValue;
    }
    if(input.layoutImageHeight != nil) {
        imageInfo.height = input.layoutImageHeight.intValue;
    }
    NSMutableArray *userTranscodingArray = [NSMutableArray array];
    layout.users = userTranscodingArray;
    if(input.layoutUserTranscodingList != nil) {
        for(id dict in input.layoutUserTranscodingList) {
            NERtcLiveStreamUserTranscoding* userTranscoding = [[NERtcLiveStreamUserTranscoding alloc] init];
            NSNumber* uid = dict[@"uid"];
            if ((NSNull *)uid != [NSNull null]) {
                userTranscoding.uid = uid.unsignedLongLongValue;
            }
            NSNumber* videoPush = dict[@"videoPush"];
            if ((NSNull *)videoPush != [NSNull null]) {
                userTranscoding.videoPush = videoPush.boolValue;
            }
            NSNumber* audioPush = dict[@"audioPush"];
            if ((NSNull *)audioPush != [NSNull null]) {
                userTranscoding.audioPush = audioPush.boolValue;
            }
            NSNumber* adaption = dict[@"adaption"];
            if ((NSNull *)adaption != [NSNull null]) {
                userTranscoding.adaption = adaption.intValue;
            }
            NSNumber* x = dict[@"x"];
            if ((NSNull *)x != [NSNull null]) {
                userTranscoding.x = x.intValue;
            }
            NSNumber* y = dict[@"y"];
            if ((NSNull *)y != [NSNull null]) {
                userTranscoding.y = y.intValue;
            }
            NSNumber* width = dict[@"width"];
            if ((NSNull *)width != [NSNull null]) {
                userTranscoding.width = width.intValue;
            }
            NSNumber* height = dict[@"height"];
            if ((NSNull *)height != [NSNull null]) {
                userTranscoding.height = height.intValue;
            }
            [userTranscodingArray addObject:userTranscoding];
        }
    }
    int ret = [[NERtcEngine sharedEngine] updateLiveStreamTask:taskInfo compeltion:^(NSString * _Nonnull taskId, kNERtcLiveStreamError errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:serial forKey:@"serial"];
            NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
            [arguments setValue:taskId forKey:@"taskId"];
            [arguments setValue:[NSNumber numberWithInt:errorCode] forKey:@"errCode"];
            [dictionary setValue:arguments forKey:@"arguments"];
            [self->_channel invokeMethod:@"onOnceEvent" arguments:dictionary];
        });
    }];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)getConnectionState:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#getConnectionState");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    NERtcConnectionStateType ret = [[NERtcEngine  sharedEngine] connectionState];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)setClientRole:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#setClientRole");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setClientRole:input.value.intValue];
    result.value = @(ret);
    return result;
}



- (nullable NEFLTIntValue *)subscribeRemoteSubStreamVideo:(nonnull NEFLTSubscribeRemoteSubStreamVideoRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#subscribeRemoteSubStreamVideo");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] subscribeRemoteSubStreamVideo:input.subscribe.boolValue forUserID:input.uid.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)uploadSdkInfo:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:EngineApi#uploadSdkInfo");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] uploadSdkInfo];
    result.value = @(ret);
    return result;
}



#pragma mark - NEFLTVideoRendererApi

- (nullable NEFLTIntValue *)createVideoRenderer:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#createVideoRenderer");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    FlutterVideoRenderer* renderer = [self createWithTextureRegistry:_textures messenger:_messenger];
    self.renderers[@(renderer.textureId)] = renderer;
    result.value = @(renderer.textureId);
    return result;
}

- (void)disposeVideoRenderer:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#disposeVideoRenderer");
#endif
    FlutterVideoRenderer *renderer = self.renderers[input.value];
    [renderer dispose];
    [self.renderers removeObjectForKey:input.value];
}

- (nullable NEFLTIntValue *)setupLocalVideoRenderer:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setupLocalVideoRenderer");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.value];
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.useExternalRender = YES;
    canvas.externalVideoRender = renderer;
    int ret = [[NERtcEngine sharedEngine] setupLocalVideoCanvas:canvas];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setupRemoteVideoRenderer:(nonnull NEFLTSetupRemoteVideoRendererRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setupRemoteVideoRenderer");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.textureId];
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.useExternalRender = YES;
    canvas.externalVideoRender = renderer;
    int ret = [[NERtcEngine sharedEngine] setupRemoteVideoCanvas:canvas forUserID:input.uid.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setMirror:(nonnull NEFLTSetVideoRendererMirrorRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setMirror");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.textureId];
    int ret = -1;
    if(renderer) {
        [renderer setMirror:input.mirror.boolValue];
        ret = 0;
    }
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setupLocalSubStreamVideoRenderer:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setupLocalSubStreamVideoRenderer");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.value];
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.useExternalRender = YES;
    canvas.externalVideoRender = renderer;
    int ret = [[NERtcEngine sharedEngine] setupLocalSubStreamVideoCanvas:canvas];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)setupRemoteSubStreamVideoRenderer:(nonnull NEFLTSetupRemoteSubStreamVideoRendererRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:VideoRendererApi#setupRemoteSubStreamVideoRenderer");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    FlutterVideoRenderer *renderer = self.renderers[input.textureId];
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.useExternalRender = YES;
    canvas.externalVideoRender = renderer;
    int ret = [[NERtcEngine sharedEngine] setupRemoteSubStreamVideoCanvas:canvas forUserID:input.uid.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}



#pragma mark - NEFLTDeviceManagerApi

- (nullable NEFLTIntValue *)setDeviceEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setupRemoteVideoRenderer");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    _deviceCallbackEnabled = YES;
    result.value = @(0);
    return result;
}

- (nullable NEFLTIntValue *)clearDeviceEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#clearDeviceEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    _deviceCallbackEnabled = NO;
    result.value = @(0);
    return result;
}


- (nullable NEFLTBoolValue *)isSpeakerphoneOn:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#isSpeakerphoneOn");
#endif
    NEFLTBoolValue* result = [[NEFLTBoolValue alloc] init];
    bool enabled = false;
    [[NERtcEngine  sharedEngine] getLoudspeakerMode:&enabled];
    result.value = [NSNumber numberWithBool:enabled];
    return result;
}

- (nullable NEFLTIntValue *)setSpeakerphoneOn:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setSpeakerphoneOn");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setLoudspeakerMode:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)enableEarback:(nonnull NEFLTEnableEarbackRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#enableEarback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] enableEarback:input.enabled.boolValue volume:input.volume.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setEarbackVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setEarbackVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setEarbackVolume:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setCameraTorchOn:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setCameraTorchOn");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setCameraTorchOn:input.value.boolValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setCameraZoomFactor:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setCameraZoomFactor");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setCameraZoomFactor:input.value.floatValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTDoubleValue *)getCameraMaxZoom:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#getCameraMaxZoom");
#endif
    NEFLTDoubleValue* result = [[NEFLTDoubleValue alloc] init];
    float ret = [[NERtcEngine sharedEngine] maxCameraZoomScale];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setCameraFocusPosition:(nonnull NEFLTSetCameraFocusPositionRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setCameraFocusPosition");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setCameraFocusPositionX:input.x.floatValue Y:input.y.floatValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setPlayoutDeviceMute:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setPlayoutDeviceMute");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setPlayoutDeviceMute:input.value.boolValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTBoolValue *)isPlayoutDeviceMute:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#isPlayoutDeviceMute");
#endif
    NEFLTBoolValue* result = [[NEFLTBoolValue alloc] init];
    bool muted = false;
    [[NERtcEngine  sharedEngine] getPlayoutDeviceMute:&muted];
    result.value = [NSNumber numberWithBool:muted];
    return result;
}

- (nullable NEFLTIntValue *)setRecordDeviceMute:(nonnull NEFLTBoolValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#setRecordDeviceMute");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setRecordDeviceMute:input.value.boolValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTBoolValue *)isRecordDeviceMute:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#isRecordDeviceMute");
#endif
    NEFLTBoolValue* result = [[NEFLTBoolValue alloc] init];
    bool muted = false;
    [[NERtcEngine  sharedEngine] getRecordDeviceMute:&muted];
    result.value = [NSNumber numberWithBool:muted];
    return result;
}

- (nullable NEFLTIntValue *)switchCamera:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:DeviceManagerApi#switchCamera");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] switchCamera];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setAudioFocusMode:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    //ignore
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    result.value = @(-1L);
    return result;
}



#pragma mark - NEFLTAudioMixingApi

- (nullable NEFLTIntValue *)setAudioMixingEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    _audioMixingCallbackEnabled = YES;
    result.value = @(0);
    return result;
}

- (nullable NEFLTIntValue *)clearAudioMixingEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#clearAudioMixingEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    _audioMixingCallbackEnabled = NO;
    result.value = @(0);
    return result;
}

- (nullable NEFLTIntValue *)startAudioMixing:(nonnull NEFLTStartAudioMixingRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
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
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)stopAudioMixing:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#stopAudioMixing");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] stopAudioMixing];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)pauseAudioMixing:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#pauseAudioMixing");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] pauseAudioMixing];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)resumeAudioMixing:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#resumeAudioMixing");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] resumeAudioMixing];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setAudioMixingSendVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingSendVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioMixingSendVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)getAudioMixingSendVolume:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingSendVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingSendVolume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}

- (nullable NEFLTIntValue *)setAudioMixingPlaybackVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPlaybackVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioMixingPlaybackVolume: input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}


- (nullable NEFLTIntValue *)getAudioMixingPlaybackVolume:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingPlaybackVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingPlaybackVolume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}


- (nullable NEFLTIntValue *)setAudioMixingPosition:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#setAudioMixingPosition");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine  sharedEngine] setAudioMixingPosition:input.value.unsignedLongLongValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)getAudioMixingCurrentPosition:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingCurrentPosition");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    uint64_t position = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingCurrentPosition:&position];
    if(ret == 0) {
        result.value = @(position);
    } else {
        result.value = @(-1);
    }
    return result;
}

- (nullable NEFLTIntValue *)getAudioMixingDuration:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioMixingApi#getAudioMixingDuration");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    uint64_t position = 0;
    int ret = [[NERtcEngine sharedEngine] getAudioMixingCurrentPosition:&position];
    if(ret == 0) {
        result.value = @(position);
    } else {
        result.value = @(-1);
    }
    return result;
}


#pragma mark - NEFLTAudioEffectApi

- (nullable NEFLTIntValue *)setAudioEffectEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#setAudioEffectEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    _audioEffetCallbackEnabled = YES;
    result.value = @(0);
    return result;
}

- (nullable NEFLTIntValue *)clearAudioEffectEventCallback:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#clearAudioEffectEventCallback");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    _audioEffetCallbackEnabled = NO;
    result.value = @(0);
    return result;
}

- (nullable NEFLTIntValue *)playEffect:(nonnull NEFLTPlayEffectRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#playEffect");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
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


- (nullable NEFLTIntValue *)stopEffect:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#stopEffect");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopEffectWitdId:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)stopAllEffects:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#stopAllEffects");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] stopAllEffects];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)pauseEffect:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#pauseEffect");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] pauseEffectWitdId:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)pauseAllEffects:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#pauseAllEffects");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] pauseAllEffects];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)resumeEffect:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#resumeEffect");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] resumeEffectWitdId:input.value.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)resumeAllEffects:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#resumeAllEffects");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] resumeAllEffects];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)setEffectSendVolume:(nonnull NEFLTSetEffectSendVolumeRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#setEffectSendVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setEffectSendVolumeWithId:input.effectId.unsignedIntValue volume:input.volume.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)getEffectSendVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#getEffectSendVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    uint32_t volume = 0;
    int ret = [[NERtcEngine sharedEngine] getEffectSendVolumeWithId:input.value.unsignedIntValue volume:&volume];
    if(ret == 0) {
        result.value = @(volume);
    } else {
        result.value = @(-1);
    }
    return result;
}


- (nullable NEFLTIntValue *)setEffectPlaybackVolume:(nonnull NEFLTSetEffectPlaybackVolumeRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#setEffectPlaybackVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
    int ret = [[NERtcEngine sharedEngine] setEffectPlaybackVolumeWithId:input.effectId.unsignedIntValue volume:input.volume.unsignedIntValue];
    result.value = @(ret);
    return result;
}

- (nullable NEFLTIntValue *)getEffectPlaybackVolume:(nonnull NEFLTIntValue *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
#ifdef DEBUG
    NSLog(@"FlutterCalled:AudioEffectApi#getEffectPlaybackVolume");
#endif
    NEFLTIntValue* result = [[NEFLTIntValue alloc] init];
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

- (void)onNERtcEngineConnectionStateChangeWithState:(NERtcConnectionStateType)state
                                             reason:(NERtcReasonConnectionChangedType)reason {
    [_channel invokeMethod:@"onConnectionStateChanged" arguments:@{@"state": @(state), @"reason":@(reason)}];
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

- (void)onNERtcEngineDidClientRoleChanged:(NERtcClientRole)oldRole newRole:(NERtcClientRole)newRole {
    [_channel invokeMethod:@"onClientRoleChange" arguments:@{@"oldRole":@(oldRole), @"newRole":@(newRole)}];
}


- (void)onNERtcEngineUserSubStreamDidStartWithUserID:(uint64_t)userID subStreamProfile:(NERtcVideoProfileType)profile {
    [_channel invokeMethod:@"onUserSubStreamVideoStart" arguments:@{@"uid":@(userID), @"maxProfile":@(profile)}];
}


- (void)onNERtcEngineUserSubStreamDidStop:(uint64_t)userID {
    [_channel invokeMethod:@"onUserSubStreamVideoStop" arguments:@{@"uid":@(userID)}];
}



#pragma mark - LiveStreamDelegate

- (void)onNERTCEngineLiveStreamState:(NERtcLiveStreamStateCode)state taskID:(NSString *)taskID url:(NSString *)url {
    [_channel invokeMethod:@"onLiveStreamState" arguments:@{@"taskId":taskID, @"pushUrl": url, @"liveState":@(state)}];
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

- (void)onNERtcEngineAudioDeviceRoutingDidChange:(NERtcAudioOutputRouting)routing {
    if(_deviceCallbackEnabled == NO) return;
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
    [_channel invokeMethod:@"onAudioDeviceChanged" arguments:@{@"selected":@(selected)}];
}

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
    [_channel invokeMethod:@"onNERtcEngineHardwareResourceReleased" arguments:@{@"result":@(result)}];
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

- (void)onNERtcCameraExposureChanged:(CGPoint)exposurePoint {
    
}


- (void)onNERtcCameraFocusChanged:(CGPoint)focusPoint {

}

- (void)onNERtcEngineAudioHasHowling {
    [_channel invokeMethod:@"onAudioHasHowling" arguments:nil];
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
    if(stat.videoLayers) {
        NSMutableArray* layers = [[NSMutableArray alloc] init];
        for(NERtcVideoLayerSendStats* layerStat in stat.videoLayers) {
            NSMutableDictionary *layer = [[NSMutableDictionary alloc] init];
            [layer setValue:[NSNumber numberWithInt:layerStat.layerType] forKey:@"layerType"];
            [layer setValue:[NSNumber numberWithInt:layerStat.width] forKey:@"width"];
            [layer setValue:[NSNumber numberWithInt:layerStat.height] forKey:@"height"];
            [layer setValue:[NSNumber numberWithLongLong:layerStat.sendBitrate] forKey:@"sendBitrate"];
            [layer setValue:[NSNumber numberWithInt:layerStat.encoderOutputFrameRate] forKey:@"encoderOutputFrameRate"];
            [layer setValue:[NSNumber numberWithInt:layerStat.captureFrameRate] forKey:@"captureFrameRate"];
            [layer setValue:[NSNumber numberWithInt:layerStat.targetBitrate] forKey:@"targetBitrate"];
            [layer setValue:[NSNumber numberWithInt:layerStat.encoderBitrate] forKey:@"encoderBitrate"];
            [layer setValue:[NSNumber numberWithInt:layerStat.sentFrameRate] forKey:@"sentFrameRate"];
            [layer setValue:[NSNumber numberWithInt:layerStat.renderFrameRate] forKey:@"renderFrameRate"];
            [layers addObject:layer];
        }
        [dictionary setValue:layers forKey:@"layers"];
    }
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
            NSMutableArray* layers = [[NSMutableArray alloc] init];
            if(stat.videoLayers) {
                for(NERtcVideoLayerRecvStats* layerStat in stat.videoLayers) {
                    NSMutableDictionary *layer = [[NSMutableDictionary alloc] init];
                    [layer setValue:[NSNumber numberWithInt:layerStat.layerType] forKey:@"layerType"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.width] forKey:@"width"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.height] forKey:@"height"];
                    [layer setValue:[NSNumber numberWithLongLong:layerStat.receivedBitrate] forKey:@"receivedBitrate"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.fps] forKey:@"fps"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.packetLossRate] forKey:@"packetLossRate"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.decoderOutputFrameRate] forKey:@"decoderOutputFrameRate"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.rendererOutputFrameRate] forKey:@"rendererOutputFrameRate"];
                    [layer setValue:[NSNumber numberWithLongLong:layerStat.totalFrozenTime] forKey:@"totalFrozenTime"];
                    [layer setValue:[NSNumber numberWithInt:layerStat.frozenRate] forKey:@"frozenRate"];
                    [layers addObject:layer];
                }
            }
            [dictionary setValue:layers forKey:@"layers"];
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
