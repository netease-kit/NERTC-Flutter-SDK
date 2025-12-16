// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

/// 视频水印类型
typedef NS_ENUM(NSUInteger, NEFLTNERtcVideoWatermarkType) {
  /// 图片
  NEFLTNERtcVideoWatermarkTypeKNERtcVideoWatermarkTypeImage = 0,
  /// 文字
  NEFLTNERtcVideoWatermarkTypeKNERtcVideoWatermarkTypeText = 1,
  /// 时间戳
  NEFLTNERtcVideoWatermarkTypeKNERtcVideoWatermarkTypeTimeStamp = 2,
};

/// 摄像头额外旋转信息
typedef NS_ENUM(NSUInteger, NEFLTNERtcCaptureExtraRotation) {
  /// （默认）没有额外的旋转信息，直接使用系统旋转参数处理
  NEFLTNERtcCaptureExtraRotationKNERtcCaptureExtraRotationDefault = 0,
  /// 在系统旋转信息的基础上，额外顺时针旋转90度
  NEFLTNERtcCaptureExtraRotationKNERtcCaptureExtraRotationClockWise90 = 1,
  /// 在系统旋转信息的基础上，额外旋转180度
  NEFLTNERtcCaptureExtraRotationKNERtcCaptureExtraRotation180 = 2,
  /// 在系统旋转信息的基础上，额外逆时针旋转90度
  NEFLTNERtcCaptureExtraRotationKNERtcCaptureExtraRotationAntiClockWise90 = 3,
};

@class NEFLTNERtcUserJoinExtraInfo;
@class NEFLTNERtcUserLeaveExtraInfo;
@class NEFLTUserJoinedEvent;
@class NEFLTUserLeaveEvent;
@class NEFLTUserVideoMuteEvent;
@class NEFLTFirstVideoDataReceivedEvent;
@class NEFLTFirstVideoFrameDecodedEvent;
@class NEFLTVirtualBackgroundSourceEnabledEvent;
@class NEFLTAudioVolumeInfo;
@class NEFLTRemoteAudioVolumeIndicationEvent;
@class NEFLTRectangle;
@class NEFLTScreenCaptureSourceData;
@class NEFLTNERtcLastmileProbeResult;
@class NEFLTNERtcLastmileProbeOneWayResult;
@class NEFLTRtcServerAddresses;
@class NEFLTCreateEngineRequest;
@class NEFLTJoinChannelOptions;
@class NEFLTJoinChannelRequest;
@class NEFLTSubscribeRemoteAudioRequest;
@class NEFLTEnableLocalVideoRequest;
@class NEFLTSetAudioProfileRequest;
@class NEFLTSetLocalVideoConfigRequest;
@class NEFLTSetCameraCaptureConfigRequest;
@class NEFLTStartorStopVideoPreviewRequest;
@class NEFLTStartScreenCaptureRequest;
@class NEFLTSubscribeRemoteVideoStreamRequest;
@class NEFLTSubscribeRemoteSubStreamVideoRequest;
@class NEFLTEnableAudioVolumeIndicationRequest;
@class NEFLTSubscribeRemoteSubStreamAudioRequest;
@class NEFLTSetAudioSubscribeOnlyByRequest;
@class NEFLTStartAudioMixingRequest;
@class NEFLTPlayEffectRequest;
@class NEFLTSetCameraPositionRequest;
@class NEFLTAddOrUpdateLiveStreamTaskRequest;
@class NEFLTDeleteLiveStreamTaskRequest;
@class NEFLTSendSEIMsgRequest;
@class NEFLTSetLocalVoiceEqualizationRequest;
@class NEFLTSwitchChannelRequest;
@class NEFLTStartAudioRecordingRequest;
@class NEFLTAudioRecordingConfigurationRequest;
@class NEFLTSetLocalMediaPriorityRequest;
@class NEFLTStartOrUpdateChannelMediaRelayRequest;
@class NEFLTAdjustUserPlaybackSignalVolumeRequest;
@class NEFLTEnableEncryptionRequest;
@class NEFLTSetLocalVoiceReverbParamRequest;
@class NEFLTReportCustomEventRequest;
@class NEFLTStartLastmileProbeTestRequest;
@class NEFLTCGPoint;
@class NEFLTSetVideoCorrectionConfigRequest;
@class NEFLTEnableVirtualBackgroundRequest;
@class NEFLTSetRemoteHighPriorityAudioStreamRequest;
@class NEFLTVideoWatermarkImageConfig;
@class NEFLTVideoWatermarkTextConfig;
@class NEFLTVideoWatermarkTimestampConfig;
@class NEFLTVideoWatermarkConfig;
@class NEFLTSetLocalVideoWatermarkConfigsRequest;
@class NEFLTPositionInfo;
@class NEFLTSpatializerRoomProperty;
@class NEFLTLocalRecordingConfig;
@class NEFLTLocalRecordingLayoutConfig;
@class NEFLTLocalRecordingStreamInfo;
@class NEFLTNERtcVersion;
@class NEFLTVideoFrame;
@class NEFLTDataExternalFrame;
@class NEFLTAudioExternalFrame;
@class NEFLTStreamingRoomInfo;
@class NEFLTStartPushStreamingRequest;
@class NEFLTStartPlayStreamingRequest;
@class NEFLTStartASRCaptionRequest;
@class NEFLTSetMultiPathOptionRequest;

/// onUserJoined 回调的一些可选信息
@interface NEFLTNERtcUserJoinExtraInfo : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithCustomInfo:(NSString *)customInfo;
/// 自定义信息， 来源于远端用户joinChannel时填的
/// [NERtcJoinChannelOptions.customInfo]参数，默认为空字符串。
@property(nonatomic, copy) NSString *customInfo;
@end

/// onUserLeave 回调的一些可选信息
@interface NEFLTNERtcUserLeaveExtraInfo : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithCustomInfo:(NSString *)customInfo;
/// 自定义信息, 来源于远端用户joinChannel时填的
/// [NERtcJoinChannelOptions.customInfo]参数，默认为空字符串。
@property(nonatomic, copy) NSString *customInfo;
@end

@interface NEFLTUserJoinedEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid
              joinExtraInfo:(nullable NEFLTNERtcUserJoinExtraInfo *)joinExtraInfo;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong, nullable) NEFLTNERtcUserJoinExtraInfo *joinExtraInfo;
@end

@interface NEFLTUserLeaveEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid
                     reason:(NSNumber *)reason
             leaveExtraInfo:(nullable NEFLTNERtcUserLeaveExtraInfo *)leaveExtraInfo;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSNumber *reason;
@property(nonatomic, strong, nullable) NEFLTNERtcUserLeaveExtraInfo *leaveExtraInfo;
@end

@interface NEFLTUserVideoMuteEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid
                      muted:(NSNumber *)muted
                 streamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSNumber *muted;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTFirstVideoDataReceivedEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid streamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTFirstVideoFrameDecodedEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid
                      width:(NSNumber *)width
                     height:(NSNumber *)height
                 streamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSNumber *width;
@property(nonatomic, strong) NSNumber *height;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTVirtualBackgroundSourceEnabledEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithEnabled:(NSNumber *)enabled reason:(NSNumber *)reason;
@property(nonatomic, strong) NSNumber *enabled;
@property(nonatomic, strong) NSNumber *reason;
@end

@interface NEFLTAudioVolumeInfo : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid
                     volume:(NSNumber *)volume
            subStreamVolume:(NSNumber *)subStreamVolume;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSNumber *volume;
@property(nonatomic, strong) NSNumber *subStreamVolume;
@end

@interface NEFLTRemoteAudioVolumeIndicationEvent : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithVolumeList:(nullable NSArray<NEFLTAudioVolumeInfo *> *)volumeList
                       totalVolume:(NSNumber *)totalVolume;
@property(nonatomic, strong, nullable) NSArray<NEFLTAudioVolumeInfo *> *volumeList;
@property(nonatomic, strong) NSNumber *totalVolume;
@end

@interface NEFLTRectangle : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithX:(NSNumber *)x
                        y:(NSNumber *)y
                    width:(NSNumber *)width
                   height:(NSNumber *)height;
@property(nonatomic, strong) NSNumber *x;
@property(nonatomic, strong) NSNumber *y;
@property(nonatomic, strong) NSNumber *width;
@property(nonatomic, strong) NSNumber *height;
@end

@interface NEFLTScreenCaptureSourceData : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithType:(NSNumber *)type
                    sourceId:(NSNumber *)sourceId
                      status:(NSNumber *)status
                      action:(NSNumber *)action
                 captureRect:(NEFLTRectangle *)captureRect
                       level:(NSNumber *)level;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSNumber *sourceId;
@property(nonatomic, strong) NSNumber *status;
@property(nonatomic, strong) NSNumber *action;
@property(nonatomic, strong) NEFLTRectangle *captureRect;
@property(nonatomic, strong) NSNumber *level;
@end

/// 上下行 Last mile 网络质量探测结果
@interface NEFLTNERtcLastmileProbeResult : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithState:(NSNumber *)state
                          rtt:(NSNumber *)rtt
                 uplinkReport:(NEFLTNERtcLastmileProbeOneWayResult *)uplinkReport
               downlinkReport:(NEFLTNERtcLastmileProbeOneWayResult *)downlinkReport;
/// Last mile 质量探测结果的状态, 详细参数见 [NERtcLastmileProbeResultState]
@property(nonatomic, strong) NSNumber *state;
/// 往返时延，单位为毫秒(ms)
@property(nonatomic, strong) NSNumber *rtt;
/// 上行网络质量报告
@property(nonatomic, strong) NEFLTNERtcLastmileProbeOneWayResult *uplinkReport;
/// 下行网络质量报告
@property(nonatomic, strong) NEFLTNERtcLastmileProbeOneWayResult *downlinkReport;
@end

/// 单向 Last mile 网络质量探测结果报告
@interface NEFLTNERtcLastmileProbeOneWayResult : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithPacketLossRate:(NSNumber *)packetLossRate
                                jitter:(NSNumber *)jitter
                    availableBandwidth:(NSNumber *)availableBandwidth;
/// 丢包率
@property(nonatomic, strong) NSNumber *packetLossRate;
/// 网络抖动，单位为毫秒 (ms)
@property(nonatomic, strong) NSNumber *jitter;
/// 可用网络带宽预估，单位为 bps
@property(nonatomic, strong) NSNumber *availableBandwidth;
@end

@interface NEFLTRtcServerAddresses : NSObject
+ (instancetype)makeWithValid:(nullable NSNumber *)valid
                channelServer:(nullable NSString *)channelServer
             statisticsServer:(nullable NSString *)statisticsServer
                   roomServer:(nullable NSString *)roomServer
                 compatServer:(nullable NSString *)compatServer
                 nosLbsServer:(nullable NSString *)nosLbsServer
               nosUploadSever:(nullable NSString *)nosUploadSever
               nosTokenServer:(nullable NSString *)nosTokenServer
              sdkConfigServer:(nullable NSString *)sdkConfigServer
             cloudProxyServer:(nullable NSString *)cloudProxyServer
         webSocketProxyServer:(nullable NSString *)webSocketProxyServer
              quicProxyServer:(nullable NSString *)quicProxyServer
             mediaProxyServer:(nullable NSString *)mediaProxyServer
     statisticsDispatchServer:(nullable NSString *)statisticsDispatchServer
       statisticsBackupServer:(nullable NSString *)statisticsBackupServer
                      useIPv6:(nullable NSNumber *)useIPv6;
@property(nonatomic, strong, nullable) NSNumber *valid;
@property(nonatomic, copy, nullable) NSString *channelServer;
@property(nonatomic, copy, nullable) NSString *statisticsServer;
@property(nonatomic, copy, nullable) NSString *roomServer;
@property(nonatomic, copy, nullable) NSString *compatServer;
@property(nonatomic, copy, nullable) NSString *nosLbsServer;
@property(nonatomic, copy, nullable) NSString *nosUploadSever;
@property(nonatomic, copy, nullable) NSString *nosTokenServer;
@property(nonatomic, copy, nullable) NSString *sdkConfigServer;
@property(nonatomic, copy, nullable) NSString *cloudProxyServer;
@property(nonatomic, copy, nullable) NSString *webSocketProxyServer;
@property(nonatomic, copy, nullable) NSString *quicProxyServer;
@property(nonatomic, copy, nullable) NSString *mediaProxyServer;
@property(nonatomic, copy, nullable) NSString *statisticsDispatchServer;
@property(nonatomic, copy, nullable) NSString *statisticsBackupServer;
@property(nonatomic, strong, nullable) NSNumber *useIPv6;
@end

@interface NEFLTCreateEngineRequest : NSObject
+ (instancetype)makeWithAppKey:(nullable NSString *)appKey
                                   logDir:(nullable NSString *)logDir
                          serverAddresses:(nullable NEFLTRtcServerAddresses *)serverAddresses
                                 logLevel:(nullable NSNumber *)logLevel
                       audioAutoSubscribe:(nullable NSNumber *)audioAutoSubscribe
                       videoAutoSubscribe:(nullable NSNumber *)videoAutoSubscribe
        disableFirstJoinUserCreateChannel:(nullable NSNumber *)disableFirstJoinUserCreateChannel
    audioDisableOverrideSpeakerOnReceiver:(nullable NSNumber *)audioDisableOverrideSpeakerOnReceiver
               audioDisableSWAECOnHeadset:(nullable NSNumber *)audioDisableSWAECOnHeadset
                         audioAINSEnabled:(nullable NSNumber *)audioAINSEnabled
                        serverRecordAudio:(nullable NSNumber *)serverRecordAudio
                        serverRecordVideo:(nullable NSNumber *)serverRecordVideo
                         serverRecordMode:(nullable NSNumber *)serverRecordMode
                      serverRecordSpeaker:(nullable NSNumber *)serverRecordSpeaker
                        publishSelfStream:(nullable NSNumber *)publishSelfStream
              videoCaptureObserverEnabled:(nullable NSNumber *)videoCaptureObserverEnabled
                          videoEncodeMode:(nullable NSNumber *)videoEncodeMode
                          videoDecodeMode:(nullable NSNumber *)videoDecodeMode
                            videoSendMode:(nullable NSNumber *)videoSendMode
                         videoH265Enabled:(nullable NSNumber *)videoH265Enabled
                           mode1v1Enabled:(nullable NSNumber *)mode1v1Enabled
                                 appGroup:(nullable NSString *)appGroup;
@property(nonatomic, copy, nullable) NSString *appKey;
@property(nonatomic, copy, nullable) NSString *logDir;
@property(nonatomic, strong, nullable) NEFLTRtcServerAddresses *serverAddresses;
@property(nonatomic, strong, nullable) NSNumber *logLevel;
@property(nonatomic, strong, nullable) NSNumber *audioAutoSubscribe;
@property(nonatomic, strong, nullable) NSNumber *videoAutoSubscribe;
@property(nonatomic, strong, nullable) NSNumber *disableFirstJoinUserCreateChannel;
@property(nonatomic, strong, nullable) NSNumber *audioDisableOverrideSpeakerOnReceiver;
@property(nonatomic, strong, nullable) NSNumber *audioDisableSWAECOnHeadset;
@property(nonatomic, strong, nullable) NSNumber *audioAINSEnabled;
@property(nonatomic, strong, nullable) NSNumber *serverRecordAudio;
@property(nonatomic, strong, nullable) NSNumber *serverRecordVideo;
@property(nonatomic, strong, nullable) NSNumber *serverRecordMode;
@property(nonatomic, strong, nullable) NSNumber *serverRecordSpeaker;
@property(nonatomic, strong, nullable) NSNumber *publishSelfStream;
@property(nonatomic, strong, nullable) NSNumber *videoCaptureObserverEnabled;
@property(nonatomic, strong, nullable) NSNumber *videoEncodeMode;
@property(nonatomic, strong, nullable) NSNumber *videoDecodeMode;
@property(nonatomic, strong, nullable) NSNumber *videoSendMode;
@property(nonatomic, strong, nullable) NSNumber *videoH265Enabled;
@property(nonatomic, strong, nullable) NSNumber *mode1v1Enabled;
@property(nonatomic, copy, nullable) NSString *appGroup;
@end

@interface NEFLTJoinChannelOptions : NSObject
+ (instancetype)makeWithCustomInfo:(nullable NSString *)customInfo
                     permissionKey:(nullable NSString *)permissionKey;
@property(nonatomic, copy, nullable) NSString *customInfo;
@property(nonatomic, copy, nullable) NSString *permissionKey;
@end

@interface NEFLTJoinChannelRequest : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithToken:(nullable NSString *)token
                  channelName:(NSString *)channelName
                          uid:(NSNumber *)uid
               channelOptions:(nullable NEFLTJoinChannelOptions *)channelOptions;
@property(nonatomic, copy, nullable) NSString *token;
@property(nonatomic, copy) NSString *channelName;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong, nullable) NEFLTJoinChannelOptions *channelOptions;
@end

@interface NEFLTSubscribeRemoteAudioRequest : NSObject
+ (instancetype)makeWithUid:(nullable NSNumber *)uid subscribe:(nullable NSNumber *)subscribe;
@property(nonatomic, strong, nullable) NSNumber *uid;
@property(nonatomic, strong, nullable) NSNumber *subscribe;
@end

@interface NEFLTEnableLocalVideoRequest : NSObject
+ (instancetype)makeWithEnable:(nullable NSNumber *)enable
                    streamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong, nullable) NSNumber *enable;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTSetAudioProfileRequest : NSObject
+ (instancetype)makeWithProfile:(nullable NSNumber *)profile scenario:(nullable NSNumber *)scenario;
@property(nonatomic, strong, nullable) NSNumber *profile;
@property(nonatomic, strong, nullable) NSNumber *scenario;
@end

@interface NEFLTSetLocalVideoConfigRequest : NSObject
+ (instancetype)makeWithVideoProfile:(nullable NSNumber *)videoProfile
                       videoCropMode:(nullable NSNumber *)videoCropMode
                         frontCamera:(nullable NSNumber *)frontCamera
                           frameRate:(nullable NSNumber *)frameRate
                        minFrameRate:(nullable NSNumber *)minFrameRate
                             bitrate:(nullable NSNumber *)bitrate
                          minBitrate:(nullable NSNumber *)minBitrate
                   degradationPrefer:(nullable NSNumber *)degradationPrefer
                               width:(nullable NSNumber *)width
                              height:(nullable NSNumber *)height
                          cameraType:(nullable NSNumber *)cameraType
                          mirrorMode:(nullable NSNumber *)mirrorMode
                     orientationMode:(nullable NSNumber *)orientationMode
                          streamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong, nullable) NSNumber *videoProfile;
@property(nonatomic, strong, nullable) NSNumber *videoCropMode;
@property(nonatomic, strong, nullable) NSNumber *frontCamera;
@property(nonatomic, strong, nullable) NSNumber *frameRate;
@property(nonatomic, strong, nullable) NSNumber *minFrameRate;
@property(nonatomic, strong, nullable) NSNumber *bitrate;
@property(nonatomic, strong, nullable) NSNumber *minBitrate;
@property(nonatomic, strong, nullable) NSNumber *degradationPrefer;
@property(nonatomic, strong, nullable) NSNumber *width;
@property(nonatomic, strong, nullable) NSNumber *height;
@property(nonatomic, strong, nullable) NSNumber *cameraType;
@property(nonatomic, strong, nullable) NSNumber *mirrorMode;
@property(nonatomic, strong, nullable) NSNumber *orientationMode;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

/// 摄像头采集配置
@interface NEFLTSetCameraCaptureConfigRequest : NSObject
+ (instancetype)makeWithExtraRotation:(NEFLTNERtcCaptureExtraRotation)extraRotation
                         captureWidth:(nullable NSNumber *)captureWidth
                        captureHeight:(nullable NSNumber *)captureHeight
                           streamType:(nullable NSNumber *)streamType;
/// 设置摄像头的额外旋转信息
@property(nonatomic, assign) NEFLTNERtcCaptureExtraRotation extraRotation;
/// 本地采集的视频宽度，单位为 px。
///
/// 视频编码分辨率以宽 x 高表示，用于设置视频编码分辨率，以衡量编码质量。
///
/// captureWidth 表示视频帧在横轴上的像素，即自定义宽。
@property(nonatomic, strong, nullable) NSNumber *captureWidth;
/// 本地采集的视频宽度，单位为 px。
///
/// 视频编码分辨率以宽 x 高表示，用于设置视频编码分辨率，以衡量编码质量。
///
/// captureHeight 表示视频帧在横轴上的像素，即自定义高。
@property(nonatomic, strong, nullable) NSNumber *captureHeight;
/// 视频流类型
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTStartorStopVideoPreviewRequest : NSObject
+ (instancetype)makeWithStreamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTStartScreenCaptureRequest : NSObject
+ (instancetype)makeWithContentPrefer:(nullable NSNumber *)contentPrefer
                         videoProfile:(nullable NSNumber *)videoProfile
                            frameRate:(nullable NSNumber *)frameRate
                         minFrameRate:(nullable NSNumber *)minFrameRate
                              bitrate:(nullable NSNumber *)bitrate
                           minBitrate:(nullable NSNumber *)minBitrate
                                 dict:(nullable NSDictionary<NSString *, id> *)dict;
@property(nonatomic, strong, nullable) NSNumber *contentPrefer;
@property(nonatomic, strong, nullable) NSNumber *videoProfile;
@property(nonatomic, strong, nullable) NSNumber *frameRate;
@property(nonatomic, strong, nullable) NSNumber *minFrameRate;
@property(nonatomic, strong, nullable) NSNumber *bitrate;
@property(nonatomic, strong, nullable) NSNumber *minBitrate;
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id> *dict;
@end

@interface NEFLTSubscribeRemoteVideoStreamRequest : NSObject
+ (instancetype)makeWithUid:(nullable NSNumber *)uid
                 streamType:(nullable NSNumber *)streamType
                  subscribe:(nullable NSNumber *)subscribe;
@property(nonatomic, strong, nullable) NSNumber *uid;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@property(nonatomic, strong, nullable) NSNumber *subscribe;
@end

@interface NEFLTSubscribeRemoteSubStreamVideoRequest : NSObject
+ (instancetype)makeWithUid:(nullable NSNumber *)uid subscribe:(nullable NSNumber *)subscribe;
@property(nonatomic, strong, nullable) NSNumber *uid;
@property(nonatomic, strong, nullable) NSNumber *subscribe;
@end

@interface NEFLTEnableAudioVolumeIndicationRequest : NSObject
+ (instancetype)makeWithEnable:(nullable NSNumber *)enable
                      interval:(nullable NSNumber *)interval
                           vad:(nullable NSNumber *)vad;
@property(nonatomic, strong, nullable) NSNumber *enable;
@property(nonatomic, strong, nullable) NSNumber *interval;
@property(nonatomic, strong, nullable) NSNumber *vad;
@end

@interface NEFLTSubscribeRemoteSubStreamAudioRequest : NSObject
+ (instancetype)makeWithSubscribe:(nullable NSNumber *)subscribe uid:(nullable NSNumber *)uid;
@property(nonatomic, strong, nullable) NSNumber *subscribe;
@property(nonatomic, strong, nullable) NSNumber *uid;
@end

@interface NEFLTSetAudioSubscribeOnlyByRequest : NSObject
+ (instancetype)makeWithUidArray:(nullable NSArray<NSNumber *> *)uidArray;
@property(nonatomic, strong, nullable) NSArray<NSNumber *> *uidArray;
@end

@interface NEFLTStartAudioMixingRequest : NSObject
+ (instancetype)makeWithPath:(nullable NSString *)path
                   loopCount:(nullable NSNumber *)loopCount
                 sendEnabled:(nullable NSNumber *)sendEnabled
                  sendVolume:(nullable NSNumber *)sendVolume
             playbackEnabled:(nullable NSNumber *)playbackEnabled
              playbackVolume:(nullable NSNumber *)playbackVolume
              startTimeStamp:(nullable NSNumber *)startTimeStamp
           sendWithAudioType:(nullable NSNumber *)sendWithAudioType
            progressInterval:(nullable NSNumber *)progressInterval;
@property(nonatomic, copy, nullable) NSString *path;
@property(nonatomic, strong, nullable) NSNumber *loopCount;
@property(nonatomic, strong, nullable) NSNumber *sendEnabled;
@property(nonatomic, strong, nullable) NSNumber *sendVolume;
@property(nonatomic, strong, nullable) NSNumber *playbackEnabled;
@property(nonatomic, strong, nullable) NSNumber *playbackVolume;
@property(nonatomic, strong, nullable) NSNumber *startTimeStamp;
@property(nonatomic, strong, nullable) NSNumber *sendWithAudioType;
@property(nonatomic, strong, nullable) NSNumber *progressInterval;
@end

@interface NEFLTPlayEffectRequest : NSObject
+ (instancetype)makeWithEffectId:(nullable NSNumber *)effectId
                            path:(nullable NSString *)path
                       loopCount:(nullable NSNumber *)loopCount
                     sendEnabled:(nullable NSNumber *)sendEnabled
                      sendVolume:(nullable NSNumber *)sendVolume
                 playbackEnabled:(nullable NSNumber *)playbackEnabled
                  playbackVolume:(nullable NSNumber *)playbackVolume
                  startTimestamp:(nullable NSNumber *)startTimestamp
               sendWithAudioType:(nullable NSNumber *)sendWithAudioType
                progressInterval:(nullable NSNumber *)progressInterval;
@property(nonatomic, strong, nullable) NSNumber *effectId;
@property(nonatomic, copy, nullable) NSString *path;
@property(nonatomic, strong, nullable) NSNumber *loopCount;
@property(nonatomic, strong, nullable) NSNumber *sendEnabled;
@property(nonatomic, strong, nullable) NSNumber *sendVolume;
@property(nonatomic, strong, nullable) NSNumber *playbackEnabled;
@property(nonatomic, strong, nullable) NSNumber *playbackVolume;
@property(nonatomic, strong, nullable) NSNumber *startTimestamp;
@property(nonatomic, strong, nullable) NSNumber *sendWithAudioType;
@property(nonatomic, strong, nullable) NSNumber *progressInterval;
@end

@interface NEFLTSetCameraPositionRequest : NSObject
+ (instancetype)makeWithX:(nullable NSNumber *)x y:(nullable NSNumber *)y;
@property(nonatomic, strong, nullable) NSNumber *x;
@property(nonatomic, strong, nullable) NSNumber *y;
@end

@interface NEFLTAddOrUpdateLiveStreamTaskRequest : NSObject
+ (instancetype)makeWithSerial:(nullable NSNumber *)serial
                        taskId:(nullable NSString *)taskId
                           url:(nullable NSString *)url
           serverRecordEnabled:(nullable NSNumber *)serverRecordEnabled
                      liveMode:(nullable NSNumber *)liveMode
                   layoutWidth:(nullable NSNumber *)layoutWidth
                  layoutHeight:(nullable NSNumber *)layoutHeight
         layoutBackgroundColor:(nullable NSNumber *)layoutBackgroundColor
                layoutImageUrl:(nullable NSString *)layoutImageUrl
                  layoutImageX:(nullable NSNumber *)layoutImageX
                  layoutImageY:(nullable NSNumber *)layoutImageY
              layoutImageWidth:(nullable NSNumber *)layoutImageWidth
             layoutImageHeight:(nullable NSNumber *)layoutImageHeight
     layoutUserTranscodingList:(nullable NSArray *)layoutUserTranscodingList;
@property(nonatomic, strong, nullable) NSNumber *serial;
@property(nonatomic, copy, nullable) NSString *taskId;
@property(nonatomic, copy, nullable) NSString *url;
@property(nonatomic, strong, nullable) NSNumber *serverRecordEnabled;
@property(nonatomic, strong, nullable) NSNumber *liveMode;
@property(nonatomic, strong, nullable) NSNumber *layoutWidth;
@property(nonatomic, strong, nullable) NSNumber *layoutHeight;
@property(nonatomic, strong, nullable) NSNumber *layoutBackgroundColor;
@property(nonatomic, copy, nullable) NSString *layoutImageUrl;
@property(nonatomic, strong, nullable) NSNumber *layoutImageX;
@property(nonatomic, strong, nullable) NSNumber *layoutImageY;
@property(nonatomic, strong, nullable) NSNumber *layoutImageWidth;
@property(nonatomic, strong, nullable) NSNumber *layoutImageHeight;
@property(nonatomic, strong, nullable) NSArray *layoutUserTranscodingList;
@end

@interface NEFLTDeleteLiveStreamTaskRequest : NSObject
+ (instancetype)makeWithSerial:(nullable NSNumber *)serial taskId:(nullable NSString *)taskId;
@property(nonatomic, strong, nullable) NSNumber *serial;
@property(nonatomic, copy, nullable) NSString *taskId;
@end

@interface NEFLTSendSEIMsgRequest : NSObject
+ (instancetype)makeWithSeiMsg:(nullable NSString *)seiMsg
                    streamType:(nullable NSNumber *)streamType;
@property(nonatomic, copy, nullable) NSString *seiMsg;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTSetLocalVoiceEqualizationRequest : NSObject
+ (instancetype)makeWithBandFrequency:(nullable NSNumber *)bandFrequency
                             bandGain:(nullable NSNumber *)bandGain;
@property(nonatomic, strong, nullable) NSNumber *bandFrequency;
@property(nonatomic, strong, nullable) NSNumber *bandGain;
@end

@interface NEFLTSwitchChannelRequest : NSObject
+ (instancetype)makeWithToken:(nullable NSString *)token
                  channelName:(nullable NSString *)channelName
               channelOptions:(nullable NEFLTJoinChannelOptions *)channelOptions;
@property(nonatomic, copy, nullable) NSString *token;
@property(nonatomic, copy, nullable) NSString *channelName;
@property(nonatomic, strong, nullable) NEFLTJoinChannelOptions *channelOptions;
@end

@interface NEFLTStartAudioRecordingRequest : NSObject
+ (instancetype)makeWithFilePath:(nullable NSString *)filePath
                      sampleRate:(nullable NSNumber *)sampleRate
                         quality:(nullable NSNumber *)quality;
@property(nonatomic, copy, nullable) NSString *filePath;
@property(nonatomic, strong, nullable) NSNumber *sampleRate;
@property(nonatomic, strong, nullable) NSNumber *quality;
@end

@interface NEFLTAudioRecordingConfigurationRequest : NSObject
+ (instancetype)makeWithFilePath:(nullable NSString *)filePath
                      sampleRate:(nullable NSNumber *)sampleRate
                         quality:(nullable NSNumber *)quality
                        position:(nullable NSNumber *)position
                       cycleTime:(nullable NSNumber *)cycleTime;
@property(nonatomic, copy, nullable) NSString *filePath;
@property(nonatomic, strong, nullable) NSNumber *sampleRate;
@property(nonatomic, strong, nullable) NSNumber *quality;
@property(nonatomic, strong, nullable) NSNumber *position;
@property(nonatomic, strong, nullable) NSNumber *cycleTime;
@end

@interface NEFLTSetLocalMediaPriorityRequest : NSObject
+ (instancetype)makeWithPriority:(nullable NSNumber *)priority
                    isPreemptive:(nullable NSNumber *)isPreemptive;
@property(nonatomic, strong, nullable) NSNumber *priority;
@property(nonatomic, strong, nullable) NSNumber *isPreemptive;
@end

@interface NEFLTStartOrUpdateChannelMediaRelayRequest : NSObject
+ (instancetype)makeWithSourceMediaInfo:(nullable NSDictionary<id, id> *)sourceMediaInfo
                          destMediaInfo:
                              (nullable NSDictionary<id, NSDictionary<id, id> *> *)destMediaInfo;
@property(nonatomic, strong, nullable) NSDictionary<id, id> *sourceMediaInfo;
@property(nonatomic, strong, nullable) NSDictionary<id, NSDictionary<id, id> *> *destMediaInfo;
@end

@interface NEFLTAdjustUserPlaybackSignalVolumeRequest : NSObject
+ (instancetype)makeWithUid:(nullable NSNumber *)uid volume:(nullable NSNumber *)volume;
@property(nonatomic, strong, nullable) NSNumber *uid;
@property(nonatomic, strong, nullable) NSNumber *volume;
@end

@interface NEFLTEnableEncryptionRequest : NSObject
+ (instancetype)makeWithKey:(nullable NSString *)key
                       mode:(nullable NSNumber *)mode
                     enable:(nullable NSNumber *)enable;
@property(nonatomic, copy, nullable) NSString *key;
@property(nonatomic, strong, nullable) NSNumber *mode;
@property(nonatomic, strong, nullable) NSNumber *enable;
@end

@interface NEFLTSetLocalVoiceReverbParamRequest : NSObject
+ (instancetype)makeWithWetGain:(nullable NSNumber *)wetGain
                        dryGain:(nullable NSNumber *)dryGain
                        damping:(nullable NSNumber *)damping
                       roomSize:(nullable NSNumber *)roomSize
                      decayTime:(nullable NSNumber *)decayTime
                       preDelay:(nullable NSNumber *)preDelay;
@property(nonatomic, strong, nullable) NSNumber *wetGain;
@property(nonatomic, strong, nullable) NSNumber *dryGain;
@property(nonatomic, strong, nullable) NSNumber *damping;
@property(nonatomic, strong, nullable) NSNumber *roomSize;
@property(nonatomic, strong, nullable) NSNumber *decayTime;
@property(nonatomic, strong, nullable) NSNumber *preDelay;
@end

@interface NEFLTReportCustomEventRequest : NSObject
+ (instancetype)makeWithEventName:(nullable NSString *)eventName
                   customIdentify:(nullable NSString *)customIdentify
                            param:(nullable NSDictionary<NSString *, id> *)param;
@property(nonatomic, copy, nullable) NSString *eventName;
@property(nonatomic, copy, nullable) NSString *customIdentify;
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id> *param;
@end

@interface NEFLTStartLastmileProbeTestRequest : NSObject
+ (instancetype)makeWithProbeUplink:(nullable NSNumber *)probeUplink
                      probeDownlink:(nullable NSNumber *)probeDownlink
              expectedUplinkBitrate:(nullable NSNumber *)expectedUplinkBitrate
            expectedDownlinkBitrate:(nullable NSNumber *)expectedDownlinkBitrate;
@property(nonatomic, strong, nullable) NSNumber *probeUplink;
@property(nonatomic, strong, nullable) NSNumber *probeDownlink;
@property(nonatomic, strong, nullable) NSNumber *expectedUplinkBitrate;
@property(nonatomic, strong, nullable) NSNumber *expectedDownlinkBitrate;
@end

/// 顶点坐标
@interface NEFLTCGPoint : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithX:(NSNumber *)x y:(NSNumber *)y;
/// x 的 取值范围是 &#91; 0-1 &#93;
@property(nonatomic, strong) NSNumber *x;
/// y 的 取值范围是 &#91; 0-1 &#93;
@property(nonatomic, strong) NSNumber *y;
@end

@interface NEFLTSetVideoCorrectionConfigRequest : NSObject
+ (instancetype)makeWithTopLeft:(nullable NEFLTCGPoint *)topLeft
                       topRight:(nullable NEFLTCGPoint *)topRight
                     bottomLeft:(nullable NEFLTCGPoint *)bottomLeft
                    bottomRight:(nullable NEFLTCGPoint *)bottomRight
                    canvasWidth:(nullable NSNumber *)canvasWidth
                   canvasHeight:(nullable NSNumber *)canvasHeight
                   enableMirror:(nullable NSNumber *)enableMirror;
@property(nonatomic, strong, nullable) NEFLTCGPoint *topLeft;
@property(nonatomic, strong, nullable) NEFLTCGPoint *topRight;
@property(nonatomic, strong, nullable) NEFLTCGPoint *bottomLeft;
@property(nonatomic, strong, nullable) NEFLTCGPoint *bottomRight;
@property(nonatomic, strong, nullable) NSNumber *canvasWidth;
@property(nonatomic, strong, nullable) NSNumber *canvasHeight;
@property(nonatomic, strong, nullable) NSNumber *enableMirror;
@end

@interface NEFLTEnableVirtualBackgroundRequest : NSObject
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
           backgroundSourceType:(nullable NSNumber *)backgroundSourceType
                          color:(nullable NSNumber *)color
                         source:(nullable NSString *)source
                    blur_degree:(nullable NSNumber *)blur_degree;
@property(nonatomic, strong, nullable) NSNumber *enabled;
@property(nonatomic, strong, nullable) NSNumber *backgroundSourceType;
@property(nonatomic, strong, nullable) NSNumber *color;
@property(nonatomic, copy, nullable) NSString *source;
@property(nonatomic, strong, nullable) NSNumber *blur_degree;
@end

@interface NEFLTSetRemoteHighPriorityAudioStreamRequest : NSObject
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
                            uid:(nullable NSNumber *)uid
                     streamType:(nullable NSNumber *)streamType;
@property(nonatomic, strong, nullable) NSNumber *enabled;
@property(nonatomic, strong, nullable) NSNumber *uid;
@property(nonatomic, strong, nullable) NSNumber *streamType;
@end

@interface NEFLTVideoWatermarkImageConfig : NSObject
+ (instancetype)makeWithWmAlpha:(nullable NSNumber *)wmAlpha
                        wmWidth:(nullable NSNumber *)wmWidth
                       wmHeight:(nullable NSNumber *)wmHeight
                        offsetX:(nullable NSNumber *)offsetX
                        offsetY:(nullable NSNumber *)offsetY
                     imagePaths:(nullable NSArray<NSString *> *)imagePaths
                            fps:(nullable NSNumber *)fps
                           loop:(nullable NSNumber *)loop;
@property(nonatomic, strong, nullable) NSNumber *wmAlpha;
@property(nonatomic, strong, nullable) NSNumber *wmWidth;
@property(nonatomic, strong, nullable) NSNumber *wmHeight;
@property(nonatomic, strong, nullable) NSNumber *offsetX;
@property(nonatomic, strong, nullable) NSNumber *offsetY;
@property(nonatomic, strong, nullable) NSArray<NSString *> *imagePaths;
@property(nonatomic, strong, nullable) NSNumber *fps;
@property(nonatomic, strong, nullable) NSNumber *loop;
@end

@interface NEFLTVideoWatermarkTextConfig : NSObject
+ (instancetype)makeWithWmAlpha:(nullable NSNumber *)wmAlpha
                        wmWidth:(nullable NSNumber *)wmWidth
                       wmHeight:(nullable NSNumber *)wmHeight
                        offsetX:(nullable NSNumber *)offsetX
                        offsetY:(nullable NSNumber *)offsetY
                        wmColor:(nullable NSNumber *)wmColor
                       fontSize:(nullable NSNumber *)fontSize
                      fontColor:(nullable NSNumber *)fontColor
                 fontNameOrPath:(nullable NSString *)fontNameOrPath
                        content:(nullable NSString *)content;
@property(nonatomic, strong, nullable) NSNumber *wmAlpha;
@property(nonatomic, strong, nullable) NSNumber *wmWidth;
@property(nonatomic, strong, nullable) NSNumber *wmHeight;
@property(nonatomic, strong, nullable) NSNumber *offsetX;
@property(nonatomic, strong, nullable) NSNumber *offsetY;
@property(nonatomic, strong, nullable) NSNumber *wmColor;
@property(nonatomic, strong, nullable) NSNumber *fontSize;
@property(nonatomic, strong, nullable) NSNumber *fontColor;
@property(nonatomic, copy, nullable) NSString *fontNameOrPath;
@property(nonatomic, copy, nullable) NSString *content;
@end

@interface NEFLTVideoWatermarkTimestampConfig : NSObject
+ (instancetype)makeWithWmAlpha:(nullable NSNumber *)wmAlpha
                        wmWidth:(nullable NSNumber *)wmWidth
                       wmHeight:(nullable NSNumber *)wmHeight
                        offsetX:(nullable NSNumber *)offsetX
                        offsetY:(nullable NSNumber *)offsetY
                        wmColor:(nullable NSNumber *)wmColor
                       fontSize:(nullable NSNumber *)fontSize
                      fontColor:(nullable NSNumber *)fontColor
                 fontNameOrPath:(nullable NSString *)fontNameOrPath;
@property(nonatomic, strong, nullable) NSNumber *wmAlpha;
@property(nonatomic, strong, nullable) NSNumber *wmWidth;
@property(nonatomic, strong, nullable) NSNumber *wmHeight;
@property(nonatomic, strong, nullable) NSNumber *offsetX;
@property(nonatomic, strong, nullable) NSNumber *offsetY;
@property(nonatomic, strong, nullable) NSNumber *wmColor;
@property(nonatomic, strong, nullable) NSNumber *fontSize;
@property(nonatomic, strong, nullable) NSNumber *fontColor;
@property(nonatomic, copy, nullable) NSString *fontNameOrPath;
@end

/// 视频水印设置，目前支持三种类型的水印，但只能其中选择一种水印生效
@interface NEFLTVideoWatermarkConfig : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithWatermarkType:(NEFLTNERtcVideoWatermarkType)WatermarkType
                       imageWatermark:(nullable NEFLTVideoWatermarkImageConfig *)imageWatermark
                        textWatermark:(nullable NEFLTVideoWatermarkTextConfig *)textWatermark
                   timestampWatermark:
                       (nullable NEFLTVideoWatermarkTimestampConfig *)timestampWatermark;
@property(nonatomic, assign) NEFLTNERtcVideoWatermarkType WatermarkType;
@property(nonatomic, strong, nullable) NEFLTVideoWatermarkImageConfig *imageWatermark;
@property(nonatomic, strong, nullable) NEFLTVideoWatermarkTextConfig *textWatermark;
@property(nonatomic, strong, nullable) NEFLTVideoWatermarkTimestampConfig *timestampWatermark;
@end

@interface NEFLTSetLocalVideoWatermarkConfigsRequest : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithType:(NSNumber *)type config:(nullable NEFLTVideoWatermarkConfig *)config;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong, nullable) NEFLTVideoWatermarkConfig *config;
@end

@interface NEFLTPositionInfo : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithMSpeakerPosition:(NSArray<NSNumber *> *)mSpeakerPosition
                      mSpeakerQuaternion:(NSArray<NSNumber *> *)mSpeakerQuaternion
                           mHeadPosition:(NSArray<NSNumber *> *)mHeadPosition
                         mHeadQuaternion:(NSArray<NSNumber *> *)mHeadQuaternion;
@property(nonatomic, strong) NSArray<NSNumber *> *mSpeakerPosition;
@property(nonatomic, strong) NSArray<NSNumber *> *mSpeakerQuaternion;
@property(nonatomic, strong) NSArray<NSNumber *> *mHeadPosition;
@property(nonatomic, strong) NSArray<NSNumber *> *mHeadQuaternion;
@end

@interface NEFLTSpatializerRoomProperty : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithRoomCapacity:(NSNumber *)roomCapacity
                            material:(NSNumber *)material
                    reflectionScalar:(NSNumber *)reflectionScalar
                          reverbGain:(NSNumber *)reverbGain
                          reverbTime:(NSNumber *)reverbTime
                    reverbBrightness:(NSNumber *)reverbBrightness;
@property(nonatomic, strong) NSNumber *roomCapacity;
@property(nonatomic, strong) NSNumber *material;
@property(nonatomic, strong) NSNumber *reflectionScalar;
@property(nonatomic, strong) NSNumber *reverbGain;
@property(nonatomic, strong) NSNumber *reverbTime;
@property(nonatomic, strong) NSNumber *reverbBrightness;
@end

@interface NEFLTLocalRecordingConfig : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithFilePath:(NSString *)filePath
                        fileName:(NSString *)fileName
                           width:(NSNumber *)width
                          height:(NSNumber *)height
                       framerate:(NSNumber *)framerate
                  recordFileType:(NSNumber *)recordFileType
                      remuxToMp4:(NSNumber *)remuxToMp4
                      videoMerge:(NSNumber *)videoMerge
                     recordAudio:(NSNumber *)recordAudio
                     audioFormat:(NSNumber *)audioFormat
                     recordVideo:(NSNumber *)recordVideo
                 videoRecordMode:(NSNumber *)videoRecordMode
                   watermarkList:(nullable NSArray<NEFLTVideoWatermarkConfig *> *)watermarkList
                   coverFilePath:(nullable NSString *)coverFilePath
              coverWatermarkList:(nullable NSArray<NEFLTVideoWatermarkConfig *> *)coverWatermarkList
            defaultCoverFilePath:(nullable NSString *)defaultCoverFilePath;
@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, copy) NSString *fileName;
@property(nonatomic, strong) NSNumber *width;
@property(nonatomic, strong) NSNumber *height;
@property(nonatomic, strong) NSNumber *framerate;
@property(nonatomic, strong) NSNumber *recordFileType;
@property(nonatomic, strong) NSNumber *remuxToMp4;
@property(nonatomic, strong) NSNumber *videoMerge;
@property(nonatomic, strong) NSNumber *recordAudio;
@property(nonatomic, strong) NSNumber *audioFormat;
@property(nonatomic, strong) NSNumber *recordVideo;
@property(nonatomic, strong) NSNumber *videoRecordMode;
@property(nonatomic, strong, nullable) NSArray<NEFLTVideoWatermarkConfig *> *watermarkList;
@property(nonatomic, copy, nullable) NSString *coverFilePath;
@property(nonatomic, strong, nullable) NSArray<NEFLTVideoWatermarkConfig *> *coverWatermarkList;
@property(nonatomic, copy, nullable) NSString *defaultCoverFilePath;
@end

@interface NEFLTLocalRecordingLayoutConfig : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithOffsetX:(NSNumber *)offsetX
                        offsetY:(NSNumber *)offsetY
                          width:(NSNumber *)width
                         height:(NSNumber *)height
                    scalingMode:(NSNumber *)scalingMode
                  watermarkList:(nullable NSArray<NEFLTVideoWatermarkConfig *> *)watermarkList
                  isScreenShare:(NSNumber *)isScreenShare
                        bgColor:(NSNumber *)bgColor;
@property(nonatomic, strong) NSNumber *offsetX;
@property(nonatomic, strong) NSNumber *offsetY;
@property(nonatomic, strong) NSNumber *width;
@property(nonatomic, strong) NSNumber *height;
@property(nonatomic, strong) NSNumber *scalingMode;
@property(nonatomic, strong, nullable) NSArray<NEFLTVideoWatermarkConfig *> *watermarkList;
@property(nonatomic, strong) NSNumber *isScreenShare;
@property(nonatomic, strong) NSNumber *bgColor;
@end

@interface NEFLTLocalRecordingStreamInfo : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUid:(NSNumber *)uid
                 streamType:(NSNumber *)streamType
                streamLayer:(NSNumber *)streamLayer
               layoutConfig:(NEFLTLocalRecordingLayoutConfig *)layoutConfig;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSNumber *streamType;
@property(nonatomic, strong) NSNumber *streamLayer;
@property(nonatomic, strong) NEFLTLocalRecordingLayoutConfig *layoutConfig;
@end

/// NERtc 版本信息
@interface NEFLTNERtcVersion : NSObject
+ (instancetype)makeWithVersionName:(nullable NSString *)versionName
                        versionCode:(nullable NSNumber *)versionCode
                          buildType:(nullable NSString *)buildType
                          buildDate:(nullable NSString *)buildDate
                      buildRevision:(nullable NSString *)buildRevision
                          buildHost:(nullable NSString *)buildHost
                          serverEnv:(nullable NSString *)serverEnv
                        buildBranch:(nullable NSString *)buildBranch
                     engineRevision:(nullable NSString *)engineRevision;
@property(nonatomic, copy, nullable) NSString *versionName;
@property(nonatomic, strong, nullable) NSNumber *versionCode;
@property(nonatomic, copy, nullable) NSString *buildType;
@property(nonatomic, copy, nullable) NSString *buildDate;
@property(nonatomic, copy, nullable) NSString *buildRevision;
@property(nonatomic, copy, nullable) NSString *buildHost;
@property(nonatomic, copy, nullable) NSString *serverEnv;
@property(nonatomic, copy, nullable) NSString *buildBranch;
@property(nonatomic, copy, nullable) NSString *engineRevision;
@end

@interface NEFLTVideoFrame : NSObject
+ (instancetype)makeWithWidth:(nullable NSNumber *)width
                       height:(nullable NSNumber *)height
                     rotation:(nullable NSNumber *)rotation
                       format:(nullable NSNumber *)format
                    timeStamp:(nullable NSNumber *)timeStamp
                         data:(nullable FlutterStandardTypedData *)data
                      strideY:(nullable NSNumber *)strideY
                      strideU:(nullable NSNumber *)strideU
                      strideV:(nullable NSNumber *)strideV
                    textureId:(nullable NSNumber *)textureId
              transformMatrix:(nullable NSArray<NSNumber *> *)transformMatrix;
@property(nonatomic, strong, nullable) NSNumber *width;
@property(nonatomic, strong, nullable) NSNumber *height;
@property(nonatomic, strong, nullable) NSNumber *rotation;
@property(nonatomic, strong, nullable) NSNumber *format;
@property(nonatomic, strong, nullable) NSNumber *timeStamp;
@property(nonatomic, strong, nullable) FlutterStandardTypedData *data;
@property(nonatomic, strong, nullable) NSNumber *strideY;
@property(nonatomic, strong, nullable) NSNumber *strideU;
@property(nonatomic, strong, nullable) NSNumber *strideV;
@property(nonatomic, strong, nullable) NSNumber *textureId;
@property(nonatomic, strong, nullable) NSArray<NSNumber *> *transformMatrix;
@end

@interface NEFLTDataExternalFrame : NSObject
+ (instancetype)makeWithData:(nullable FlutterStandardTypedData *)data
                    dataSize:(nullable NSNumber *)dataSize;
@property(nonatomic, strong, nullable) FlutterStandardTypedData *data;
@property(nonatomic, strong, nullable) NSNumber *dataSize;
@end

@interface NEFLTAudioExternalFrame : NSObject
+ (instancetype)makeWithData:(nullable FlutterStandardTypedData *)data
                  sampleRate:(nullable NSNumber *)sampleRate
            numberOfChannels:(nullable NSNumber *)numberOfChannels
           samplesPerChannel:(nullable NSNumber *)samplesPerChannel
               syncTimestamp:(nullable NSNumber *)syncTimestamp;
@property(nonatomic, strong, nullable) FlutterStandardTypedData *data;
@property(nonatomic, strong, nullable) NSNumber *sampleRate;
@property(nonatomic, strong, nullable) NSNumber *numberOfChannels;
@property(nonatomic, strong, nullable) NSNumber *samplesPerChannel;
@property(nonatomic, strong, nullable) NSNumber *syncTimestamp;
@end

@interface NEFLTStreamingRoomInfo : NSObject
+ (instancetype)makeWithUid:(nullable NSNumber *)uid
                channelName:(nullable NSString *)channelName
                      token:(nullable NSString *)token;
@property(nonatomic, strong, nullable) NSNumber *uid;
@property(nonatomic, copy, nullable) NSString *channelName;
@property(nonatomic, copy, nullable) NSString *token;
@end

@interface NEFLTStartPushStreamingRequest : NSObject
+ (instancetype)makeWithStreamingUrl:(nullable NSString *)streamingUrl
                   streamingRoomInfo:(nullable NEFLTStreamingRoomInfo *)streamingRoomInfo;
@property(nonatomic, copy, nullable) NSString *streamingUrl;
@property(nonatomic, strong, nullable) NEFLTStreamingRoomInfo *streamingRoomInfo;
@end

@interface NEFLTStartPlayStreamingRequest : NSObject
+ (instancetype)makeWithStreamId:(nullable NSString *)streamId
                    streamingUrl:(nullable NSString *)streamingUrl
                    playOutDelay:(nullable NSNumber *)playOutDelay
                reconnectTimeout:(nullable NSNumber *)reconnectTimeout
                       muteAudio:(nullable NSNumber *)muteAudio
                       muteVideo:(nullable NSNumber *)muteVideo
                 pausePullStream:(nullable NSNumber *)pausePullStream;
@property(nonatomic, copy, nullable) NSString *streamId;
@property(nonatomic, copy, nullable) NSString *streamingUrl;
@property(nonatomic, strong, nullable) NSNumber *playOutDelay;
@property(nonatomic, strong, nullable) NSNumber *reconnectTimeout;
@property(nonatomic, strong, nullable) NSNumber *muteAudio;
@property(nonatomic, strong, nullable) NSNumber *muteVideo;
@property(nonatomic, strong, nullable) NSNumber *pausePullStream;
@end

@interface NEFLTStartASRCaptionRequest : NSObject
+ (instancetype)makeWithSrcLanguage:(nullable NSString *)srcLanguage
                     srcLanguageArr:(nullable NSArray<NSString *> *)srcLanguageArr
                     dstLanguageArr:(nullable NSArray<NSString *> *)dstLanguageArr
          needTranslateSameLanguage:(nullable NSNumber *)needTranslateSameLanguage;
@property(nonatomic, copy, nullable) NSString *srcLanguage;
@property(nonatomic, strong, nullable) NSArray<NSString *> *srcLanguageArr;
@property(nonatomic, strong, nullable) NSArray<NSString *> *dstLanguageArr;
@property(nonatomic, strong, nullable) NSNumber *needTranslateSameLanguage;
@end

@interface NEFLTSetMultiPathOptionRequest : NSObject
+ (instancetype)makeWithEnableMediaMultiPath:(nullable NSNumber *)enableMediaMultiPath
                                   mediaMode:(nullable NSNumber *)mediaMode
                             badRttThreshold:(nullable NSNumber *)badRttThreshold
                              redAudioPacket:(nullable NSNumber *)redAudioPacket
                           redAudioRtxPacket:(nullable NSNumber *)redAudioRtxPacket
                              redVideoPacket:(nullable NSNumber *)redVideoPacket
                           redVideoRtxPacket:(nullable NSNumber *)redVideoRtxPacket;
@property(nonatomic, strong, nullable) NSNumber *enableMediaMultiPath;
@property(nonatomic, strong, nullable) NSNumber *mediaMode;
@property(nonatomic, strong, nullable) NSNumber *badRttThreshold;
@property(nonatomic, strong, nullable) NSNumber *redAudioPacket;
@property(nonatomic, strong, nullable) NSNumber *redAudioRtxPacket;
@property(nonatomic, strong, nullable) NSNumber *redVideoPacket;
@property(nonatomic, strong, nullable) NSNumber *redVideoRtxPacket;
@end

/// The codec used by NEFLTNERtcSubChannelEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcSubChannelEventSinkGetCodec(void);

@interface NEFLTNERtcSubChannelEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onJoinChannelChannelTag:(NSString *)channelTag
                         result:(NSNumber *)result
                      channelId:(NSNumber *)channelId
                        elapsed:(NSNumber *)elapsed
                            uid:(NSNumber *)uid
                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLeaveChannelChannelTag:(NSString *)channelTag
                          result:(NSNumber *)result
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserJoinedChannelTag:(NSString *)channelTag
                         event:(NEFLTUserJoinedEvent *)event
                    completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserLeaveChannelTag:(NSString *)channelTag
                        event:(NEFLTUserLeaveEvent *)event
                   completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserAudioStartChannelTag:(NSString *)channelTag
                               uid:(NSNumber *)uid
                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamAudioStartChannelTag:(NSString *)channelTag
                                        uid:(NSNumber *)uid
                                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserAudioStopChannelTag:(NSString *)channelTag
                              uid:(NSNumber *)uid
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamAudioStopChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoStartChannelTag:(NSString *)channelTag
                               uid:(NSNumber *)uid
                        maxProfile:(NSNumber *)maxProfile
                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoStopChannelTag:(NSString *)channelTag
                              uid:(NSNumber *)uid
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onDisconnectChannelTag:(NSString *)channelTag
                        reason:(NSNumber *)reason
                    completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserAudioMuteChannelTag:(NSString *)channelTag
                              uid:(NSNumber *)uid
                            muted:(NSNumber *)muted
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoMuteChannelTag:(NSString *)channelTag
                            event:(NEFLTUserVideoMuteEvent *)event
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamAudioMuteChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                     muted:(NSNumber *)muted
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstAudioDataReceivedChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstVideoDataReceivedChannelTag:(NSString *)channelTag
                                     event:(NEFLTFirstVideoDataReceivedEvent *)event
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstAudioFrameDecodedChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstVideoFrameDecodedChannelTag:(NSString *)channelTag
                                     event:(NEFLTFirstVideoFrameDecodedEvent *)event
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onVirtualBackgroundSourceEnabledChannelTag:(NSString *)channelTag
                                             event:(NEFLTVirtualBackgroundSourceEnabledEvent *)event
                                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onConnectionTypeChangedChannelTag:(NSString *)channelTag
                        newConnectionType:(NSNumber *)newConnectionType
                               completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onReconnectingStartChannelTag:(NSString *)channelTag
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onReJoinChannelChannelTag:(NSString *)channelTag
                           result:(NSNumber *)result
                        channelId:(NSNumber *)channelId
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onConnectionStateChangedChannelTag:(NSString *)channelTag
                                     state:(NSNumber *)state
                                    reason:(NSNumber *)reason
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalAudioVolumeIndicationChannelTag:(NSString *)channelTag
                                        volume:(NSNumber *)volume
                                       vadFlag:(NSNumber *)vadFlag
                                    completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteAudioVolumeIndicationChannelTag:(NSString *)channelTag
                                          event:(NEFLTRemoteAudioVolumeIndicationEvent *)event
                                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLiveStreamStateChannelTag:(NSString *)channelTag
                             taskId:(NSString *)taskId
                            pushUrl:(NSString *)pushUrl
                          liveState:(NSNumber *)liveState
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onClientRoleChangeChannelTag:(NSString *)channelTag
                             oldRole:(NSNumber *)oldRole
                             newRole:(NSNumber *)newRole
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onErrorChannelTag:(NSString *)channelTag
                     code:(NSNumber *)code
               completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onWarningChannelTag:(NSString *)channelTag
                       code:(NSNumber *)code
                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamVideoStartChannelTag:(NSString *)channelTag
                                        uid:(NSNumber *)uid
                                 maxProfile:(NSNumber *)maxProfile
                                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamVideoStopChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioHasHowlingChannelTag:(NSString *)channelTag
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRecvSEIMsgChannelTag:(NSString *)channelTag
                        userID:(NSNumber *)userID
                        seiMsg:(NSString *)seiMsg
                    completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioRecordingChannelTag:(NSString *)channelTag
                              code:(NSNumber *)code
                          filePath:(NSString *)filePath
                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onMediaRightChangeChannelTag:(NSString *)channelTag
               isAudioBannedByServer:(NSNumber *)isAudioBannedByServer
               isVideoBannedByServer:(NSNumber *)isVideoBannedByServer
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onMediaRelayStatesChangeChannelTag:(NSString *)channelTag
                                     state:(NSNumber *)state
                               channelName:(NSString *)channelName
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onMediaRelayReceiveEventChannelTag:(NSString *)channelTag
                                     event:(NSNumber *)event
                                      code:(NSNumber *)code
                               channelName:(NSString *)channelName
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalPublishFallbackToAudioOnlyChannelTag:(NSString *)channelTag
                                         isFallback:(NSNumber *)isFallback
                                         streamType:(NSNumber *)streamType
                                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteSubscribeFallbackToAudioOnlyChannelTag:(NSString *)channelTag
                                                   uid:(NSNumber *)uid
                                            isFallback:(NSNumber *)isFallback
                                            streamType:(NSNumber *)streamType
                                            completion:
                                                (void (^)(FlutterError *_Nullable))completion;
- (void)onLocalVideoWatermarkStateChannelTag:(NSString *)channelTag
                             videoStreamType:(NSNumber *)videoStreamType
                                       state:(NSNumber *)state
                                  completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLastmileQualityChannelTag:(NSString *)channelTag
                            quality:(NSNumber *)quality
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLastmileProbeResultChannelTag:(NSString *)channelTag
                                 result:(NEFLTNERtcLastmileProbeResult *)result
                             completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onTakeSnapshotResultChannelTag:(NSString *)channelTag
                                  code:(NSNumber *)code
                                  path:(NSString *)path
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPermissionKeyWillExpireChannelTag:(NSString *)channelTag
                                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUpdatePermissionKeyChannelTag:(NSString *)channelTag
                                    key:(NSString *)key
                                  error:(NSNumber *)error
                                timeout:(NSNumber *)timeout
                             completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAsrCaptionStateChangedChannelTag:(NSString *)channelTag
                                  asrState:(NSNumber *)asrState
                                      code:(NSNumber *)code
                                   message:(NSString *)message
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAsrCaptionResultChannelTag:(NSString *)channelTag
                              result:(NSArray<NSDictionary<id, id> *> *)result
                         resultCount:(NSNumber *)resultCount
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingStateChangeChannelTag:(NSString *)channelTag
                                    streamId:(NSString *)streamId
                                       state:(NSNumber *)state
                                      reason:(NSNumber *)reason
                                  completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingReceiveSeiMessageChannelTag:(NSString *)channelTag
                                          streamId:(NSString *)streamId
                                           message:(NSString *)message
                                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingFirstAudioFramePlayedChannelTag:(NSString *)channelTag
                                              streamId:(NSString *)streamId
                                                timeMs:(NSNumber *)timeMs
                                            completion:
                                                (void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingFirstVideoFrameRenderChannelTag:(NSString *)channelTag
                                              streamId:(NSString *)streamId
                                                timeMs:(NSNumber *)timeMs
                                                 width:(NSNumber *)width
                                                height:(NSNumber *)height
                                            completion:
                                                (void (^)(FlutterError *_Nullable))completion;
- (void)onLocalAudioFirstPacketSentChannelTag:(NSString *)channelTag
                              audioStreamType:(NSNumber *)audioStreamType
                                   completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstVideoFrameRenderChannelTag:(NSString *)channelTag
                                   userID:(NSNumber *)userID
                               streamType:(NSNumber *)streamType
                                    width:(NSNumber *)width
                                   height:(NSNumber *)height
                              elapsedTime:(NSNumber *)elapsedTime
                               completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalVideoRenderSizeChangedChannelTag:(NSString *)channelTag
                                      videoType:(NSNumber *)videoType
                                          width:(NSNumber *)width
                                         height:(NSNumber *)height
                                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoProfileUpdateChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                maxProfile:(NSNumber *)maxProfile
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioDeviceChangedChannelTag:(NSString *)channelTag
                              selected:(NSNumber *)selected
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioDeviceStateChangeChannelTag:(NSString *)channelTag
                                deviceType:(NSNumber *)deviceType
                               deviceState:(NSNumber *)deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onApiCallExecutedChannelTag:(NSString *)channelTag
                            apiName:(NSString *)apiName
                             result:(NSNumber *)result
                            message:(NSString *)message
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteVideoSizeChangedChannelTag:(NSString *)channelTag
                                    userId:(NSNumber *)userId
                                 videoType:(NSNumber *)videoType
                                     width:(NSNumber *)width
                                    height:(NSNumber *)height
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataStartChannelTag:(NSString *)channelTag
                              uid:(NSNumber *)uid
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataStopChannelTag:(NSString *)channelTag
                             uid:(NSNumber *)uid
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataReceiveMessageChannelTag:(NSString *)channelTag
                                       uid:(NSNumber *)uid
                                bufferData:(FlutterStandardTypedData *)bufferData
                                bufferSize:(NSNumber *)bufferSize
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataStateChangedChannelTag:(NSString *)channelTag
                                     uid:(NSNumber *)uid
                              completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataBufferedAmountChangedChannelTag:(NSString *)channelTag
                                              uid:(NSNumber *)uid
                                   previousAmount:(NSNumber *)previousAmount
                                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLabFeatureCallbackChannelTag:(NSString *)channelTag
                                   key:(NSString *)key
                                 param:(NSDictionary<id, id> *)param
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAiDataChannelTag:(NSString *)channelTag
                      type:(NSString *)type
                      data:(NSString *)data
                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onStartPushStreamingChannelTag:(NSString *)channelTag
                                result:(NSNumber *)result
                             channelId:(NSNumber *)channelId
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onStopPushStreamingChannelTag:(NSString *)channelTag
                               result:(NSNumber *)result
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPushStreamingReconnectingChannelTag:(NSString *)channelTag
                                       reason:(NSNumber *)reason
                                   completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPushStreamingReconnectedSuccessChannelTag:(NSString *)channelTag
                                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onReleasedHwResourcesChannelTag:(NSString *)channelTag
                                 result:(NSNumber *)result
                             completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onScreenCaptureStatusChannelTag:(NSString *)channelTag
                                 status:(NSNumber *)status
                             completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onScreenCaptureSourceDataUpdateChannelTag:(NSString *)channelTag
                                             data:(NEFLTScreenCaptureSourceData *)data
                                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalRecorderStatusChannelTag:(NSString *)channelTag
                                 status:(NSNumber *)status
                                 taskId:(NSString *)taskId
                             completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalRecorderErrorChannelTag:(NSString *)channelTag
                                 error:(NSNumber *)error
                                taskId:(NSString *)taskId
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onCheckNECastAudioDriverResultChannelTag:(NSString *)channelTag
                                          result:(NSNumber *)result
                                      completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by NEFLTNERtcChannelEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcChannelEventSinkGetCodec(void);

@interface NEFLTNERtcChannelEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onJoinChannelResult:(NSNumber *)result
                  channelId:(NSNumber *)channelId
                    elapsed:(NSNumber *)elapsed
                        uid:(NSNumber *)uid
                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLeaveChannelResult:(NSNumber *)result
                  completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserJoinedEvent:(NEFLTUserJoinedEvent *)event
               completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserLeaveEvent:(NEFLTUserLeaveEvent *)event
              completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserAudioStartUid:(NSNumber *)uid
                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamAudioStartUid:(NSNumber *)uid
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserAudioStopUid:(NSNumber *)uid completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamAudioStopUid:(NSNumber *)uid
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoStartUid:(NSNumber *)uid
                 maxProfile:(NSNumber *)maxProfile
                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoStopUid:(NSNumber *)uid completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onDisconnectReason:(NSNumber *)reason
                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserAudioMuteUid:(NSNumber *)uid
                     muted:(NSNumber *)muted
                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoMuteEvent:(NEFLTUserVideoMuteEvent *)event
                  completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamAudioMuteUid:(NSNumber *)uid
                              muted:(NSNumber *)muted
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstAudioDataReceivedUid:(NSNumber *)uid
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstVideoDataReceivedEvent:(NEFLTFirstVideoDataReceivedEvent *)event
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstAudioFrameDecodedUid:(NSNumber *)uid
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstVideoFrameDecodedEvent:(NEFLTFirstVideoFrameDecodedEvent *)event
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onVirtualBackgroundSourceEnabledEvent:(NEFLTVirtualBackgroundSourceEnabledEvent *)event
                                   completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onConnectionTypeChangedNewConnectionType:(NSNumber *)newConnectionType
                                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onReconnectingStartWithCompletion:(void (^)(FlutterError *_Nullable))completion;
- (void)onReJoinChannelResult:(NSNumber *)result
                    channelId:(NSNumber *)channelId
                   completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onConnectionStateChangedState:(NSNumber *)state
                               reason:(NSNumber *)reason
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalAudioVolumeIndicationVolume:(NSNumber *)volume
                                   vadFlag:(NSNumber *)vadFlag
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteAudioVolumeIndicationEvent:(NEFLTRemoteAudioVolumeIndicationEvent *)event
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLiveStreamStateTaskId:(NSString *)taskId
                        pushUrl:(NSString *)pushUrl
                      liveState:(NSNumber *)liveState
                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onClientRoleChangeOldRole:(NSNumber *)oldRole
                          newRole:(NSNumber *)newRole
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onErrorCode:(NSNumber *)code completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onWarningCode:(NSNumber *)code completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamVideoStartUid:(NSNumber *)uid
                          maxProfile:(NSNumber *)maxProfile
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserSubStreamVideoStopUid:(NSNumber *)uid
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioHasHowlingWithCompletion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRecvSEIMsgUserID:(NSNumber *)userID
                    seiMsg:(NSString *)seiMsg
                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioRecordingCode:(NSNumber *)code
                    filePath:(NSString *)filePath
                  completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onMediaRightChangeIsAudioBannedByServer:(NSNumber *)isAudioBannedByServer
                          isVideoBannedByServer:(NSNumber *)isVideoBannedByServer
                                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onMediaRelayStatesChangeState:(NSNumber *)state
                          channelName:(NSString *)channelName
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onMediaRelayReceiveEventEvent:(NSNumber *)event
                                 code:(NSNumber *)code
                          channelName:(NSString *)channelName
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalPublishFallbackToAudioOnlyIsFallback:(NSNumber *)isFallback
                                         streamType:(NSNumber *)streamType
                                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteSubscribeFallbackToAudioOnlyUid:(NSNumber *)uid
                                     isFallback:(NSNumber *)isFallback
                                     streamType:(NSNumber *)streamType
                                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalVideoWatermarkStateVideoStreamType:(NSNumber *)videoStreamType
                                            state:(NSNumber *)state
                                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLastmileQualityQuality:(NSNumber *)quality
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLastmileProbeResultResult:(NEFLTNERtcLastmileProbeResult *)result
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onTakeSnapshotResultCode:(NSNumber *)code
                            path:(NSString *)path
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPermissionKeyWillExpireWithCompletion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUpdatePermissionKeyKey:(NSString *)key
                           error:(NSNumber *)error
                         timeout:(NSNumber *)timeout
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAsrCaptionStateChangedAsrState:(NSNumber *)asrState
                                    code:(NSNumber *)code
                                 message:(NSString *)message
                              completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAsrCaptionResultResult:(NSArray<NSDictionary<id, id> *> *)result
                     resultCount:(NSNumber *)resultCount
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingStateChangeStreamId:(NSString *)streamId
                                     state:(NSNumber *)state
                                    reason:(NSNumber *)reason
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingReceiveSeiMessageStreamId:(NSString *)streamId
                                         message:(NSString *)message
                                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingFirstAudioFramePlayedStreamId:(NSString *)streamId
                                              timeMs:(NSNumber *)timeMs
                                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPlayStreamingFirstVideoFrameRenderStreamId:(NSString *)streamId
                                              timeMs:(NSNumber *)timeMs
                                               width:(NSNumber *)width
                                              height:(NSNumber *)height
                                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalAudioFirstPacketSentAudioStreamType:(NSNumber *)audioStreamType
                                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onFirstVideoFrameRenderUserID:(NSNumber *)userID
                           streamType:(NSNumber *)streamType
                                width:(NSNumber *)width
                               height:(NSNumber *)height
                          elapsedTime:(NSNumber *)elapsedTime
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalVideoRenderSizeChangedVideoType:(NSNumber *)videoType
                                         width:(NSNumber *)width
                                        height:(NSNumber *)height
                                    completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserVideoProfileUpdateUid:(NSNumber *)uid
                         maxProfile:(NSNumber *)maxProfile
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioDeviceChangedSelected:(NSNumber *)selected
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioDeviceStateChangeDeviceType:(NSNumber *)deviceType
                               deviceState:(NSNumber *)deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onApiCallExecutedApiName:(NSString *)apiName
                          result:(NSNumber *)result
                         message:(NSString *)message
                      completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteVideoSizeChangedUserId:(NSNumber *)userId
                             videoType:(NSNumber *)videoType
                                 width:(NSNumber *)width
                                height:(NSNumber *)height
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataStartUid:(NSNumber *)uid completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataStopUid:(NSNumber *)uid completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataReceiveMessageUid:(NSNumber *)uid
                         bufferData:(FlutterStandardTypedData *)bufferData
                         bufferSize:(NSNumber *)bufferSize
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataStateChangedUid:(NSNumber *)uid
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onUserDataBufferedAmountChangedUid:(NSNumber *)uid
                            previousAmount:(NSNumber *)previousAmount
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLabFeatureCallbackKey:(NSString *)key
                          param:(NSDictionary<id, id> *)param
                     completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAiDataType:(NSString *)type
                data:(NSString *)data
          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onStartPushStreamingResult:(NSNumber *)result
                         channelId:(NSNumber *)channelId
                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onStopPushStreamingResult:(NSNumber *)result
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPushStreamingReconnectingReason:(NSNumber *)reason
                               completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onPushStreamingReconnectedSuccessWithCompletion:
    (void (^)(FlutterError *_Nullable))completion;
- (void)onReleasedHwResourcesResult:(NSNumber *)result
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onScreenCaptureStatusStatus:(NSNumber *)status
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onScreenCaptureSourceDataUpdateData:(NEFLTScreenCaptureSourceData *)data
                                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalRecorderStatusStatus:(NSNumber *)status
                             taskId:(NSString *)taskId
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalRecorderErrorError:(NSNumber *)error
                           taskId:(NSString *)taskId
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onCheckNECastAudioDriverResultResult:(NSNumber *)result
                                  completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by NEFLTChannelApi.
NSObject<FlutterMessageCodec> *NEFLTChannelApiGetCodec(void);

@protocol NEFLTChannelApi
/// @return `nil` only when `error != nil`.
- (nullable NSString *)getChannelNameChannelTag:(NSString *)channelTag
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setStatsEventCallbackChannelTag:(NSString *)channelTag
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)clearStatsEventCallbackChannelTag:(NSString *)channelTag
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setChannelProfileChannelTag:(NSString *)channelTag
                                    channelProfile:(NSNumber *)channelProfile
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableMediaPubChannelTag:(NSString *)channelTag
                                      mediaType:(NSNumber *)mediaType
                                         enable:(NSNumber *)enable
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)joinChannelChannelTag:(NSString *)channelTag
                                     request:(NEFLTJoinChannelRequest *)request
                                       error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)leaveChannelChannelTag:(NSString *)channelTag
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setClientRoleChannelTag:(NSString *)channelTag
                                          role:(NSNumber *)role
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getConnectionStateChannelTag:(NSString *)channelTag
                                              error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)releaseChannelTag:(NSString *)channelTag
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalAudioChannelTag:(NSString *)channelTag
                                           enable:(NSNumber *)enable
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteLocalAudioStreamChannelTag:(NSString *)channelTag
                                                 mute:(NSNumber *)mute
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteAudioChannelTag:(NSString *)channelTag
                                                  uid:(NSNumber *)uid
                                            subscribe:(NSNumber *)subscribe
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteSubAudioChannelTag:(NSString *)channelTag
                                                     uid:(NSNumber *)uid
                                               subscribe:(NSNumber *)subscribe
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalVideoConfigChannelTag:(NSString *)channelTag
                                             request:(NEFLTSetLocalVideoConfigRequest *)request
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalVideoChannelTag:(NSString *)channelTag
                                          request:(NEFLTEnableLocalVideoRequest *)request
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteLocalVideoStreamChannelTag:(NSString *)channelTag
                                                 mute:(NSNumber *)mute
                                           streamType:(NSNumber *)streamType
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)switchCameraChannelTag:(NSString *)channelTag
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    subscribeRemoteVideoStreamChannelTag:(NSString *)channelTag
                                 request:(NEFLTSubscribeRemoteVideoStreamRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteSubVideoStreamChannelTag:(NSString *)channelTag
                                                           uid:(NSNumber *)uid
                                                     subscribe:(NSNumber *)subscribe
                                                         error:(FlutterError *_Nullable *_Nonnull)
                                                                   error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    enableAudioVolumeIndicationChannelTag:(NSString *)channelTag
                                  request:(NEFLTEnableAudioVolumeIndicationRequest *)request
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)takeLocalSnapshotChannelTag:(NSString *)channelTag
                                        streamType:(NSNumber *)streamType
                                              path:(NSString *)path
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)takeRemoteSnapshotChannelTag:(NSString *)channelTag
                                                uid:(NSNumber *)uid
                                         streamType:(NSNumber *)streamType
                                               path:(NSString *)path
                                              error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeAllRemoteAudioChannelTag:(NSString *)channelTag
                                               subscribe:(NSNumber *)subscribe
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCameraCaptureConfigChannelTag:(NSString *)channelTag
                                                request:
                                                    (NEFLTSetCameraCaptureConfigRequest *)request
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setVideoStreamLayerCountChannelTag:(NSString *)channelTag
                                               layerCount:(NSNumber *)layerCount
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getFeatureSupportedTypeChannelTag:(NSString *)channelTag
                                                    type:(NSNumber *)type
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)switchCameraWithPositionChannelTag:(NSString *)channelTag
                                                 position:(NSNumber *)position
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
- (void)startScreenCaptureChannelTag:(NSString *)channelTag
                             request:(NEFLTStartScreenCaptureRequest *)request
                          completion:
                              (void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopScreenCaptureChannelTag:(NSString *)channelTag
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLoopbackRecordingChannelTag:(NSString *)channelTag
                                                  enable:(NSNumber *)enable
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    adjustLoopBackRecordingSignalVolumeChannelTag:(NSString *)channelTag
                                           volume:(NSNumber *)volume
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setExternalVideoSourceChannelTag:(NSString *)channelTag
                                             streamType:(NSNumber *)streamType
                                                 enable:(NSNumber *)enable
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pushExternalVideoFrameChannelTag:(NSString *)channelTag
                                             streamType:(NSNumber *)streamType
                                                  frame:(NEFLTVideoFrame *)frame
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)addLiveStreamTaskChannelTag:(NSString *)channelTag
                                           request:(NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)updateLiveStreamTaskChannelTag:(NSString *)channelTag
                                              request:
                                                  (NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)removeLiveStreamTaskChannelTag:(NSString *)channelTag
                                              request:(NEFLTDeleteLiveStreamTaskRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)sendSEIMsgChannelTag:(NSString *)channelTag
                                    request:(NEFLTSendSEIMsgRequest *)request
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalMediaPriorityChannelTag:(NSString *)channelTag
                                               request:(NEFLTSetLocalMediaPriorityRequest *)request
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    startChannelMediaRelayChannelTag:(NSString *)channelTag
                             request:(NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    updateChannelMediaRelayChannelTag:(NSString *)channelTag
                              request:(NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopChannelMediaRelayChannelTag:(NSString *)channelTag
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    adjustUserPlaybackSignalVolumeChannelTag:(NSString *)channelTag
                                     request:(NEFLTAdjustUserPlaybackSignalVolumeRequest *)request
                                       error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalPublishFallbackOptionChannelTag:(NSString *)channelTag
                                                        option:(NSNumber *)option
                                                         error:(FlutterError *_Nullable *_Nonnull)
                                                                   error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    setRemoteSubscribeFallbackOptionChannelTag:(NSString *)channelTag
                                        option:(NSNumber *)option
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableEncryptionChannelTag:(NSString *)channelTag
                                          request:(NEFLTEnableEncryptionRequest *)request
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    setRemoteHighPriorityAudioStreamChannelTag:(NSString *)channelTag
                                       request:
                                           (NEFLTSetRemoteHighPriorityAudioStreamRequest *)request
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioSubscribeOnlyByChannelTag:(NSString *)channelTag
                                                 request:
                                                     (NEFLTSetAudioSubscribeOnlyByRequest *)request
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalSubStreamAudioChannelTag:(NSString *)channelTag
                                                    enable:(NSNumber *)enable
                                                     error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalDataChannelTag:(NSString *)channelTag
                                         enabled:(NSNumber *)enabled
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteDataChannelTag:(NSString *)channelTag
                                           subscribe:(NSNumber *)subscribe
                                              userID:(NSNumber *)userID
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)sendDataChannelTag:(NSString *)channelTag
                                    frame:(NEFLTDataExternalFrame *)frame
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)reportCustomEventChannelTag:(NSString *)channelTag
                                           request:(NEFLTReportCustomEventRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioRecvRangeChannelTag:(NSString *)channelTag
                                   audibleDistance:(NSNumber *)audibleDistance
                            conversationalDistance:(NSNumber *)conversationalDistance
                                       rollOffMode:(NSNumber *)rollOffMode
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setRangeAudioModeChannelTag:(NSString *)channelTag
                                         audioMode:(NSNumber *)audioMode
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setRangeAudioTeamIDChannelTag:(NSString *)channelTag
                                              teamID:(NSNumber *)teamID
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)updateSelfPositionChannelTag:(NSString *)channelTag
                                       positionInfo:(NEFLTPositionInfo *)positionInfo
                                              error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableSpatializerRoomEffectsChannelTag:(NSString *)channelTag
                                                       enable:(NSNumber *)enable
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSpatializerRoomPropertyChannelTag:(NSString *)channelTag
                                                   property:(NEFLTSpatializerRoomProperty *)property
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSpatializerRenderModeChannelTag:(NSString *)channelTag
                                               renderMode:(NSNumber *)renderMode
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableSpatializerChannelTag:(NSString *)channelTag
                                            enable:(NSNumber *)enable
                                       applyToTeam:(NSNumber *)applyToTeam
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setUpSpatializerChannelTag:(NSString *)channelTag
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSubscribeAudioBlocklistChannelTag:(NSString *)channelTag
                                                   uidArray:(NSArray<NSNumber *> *)uidArray
                                                 streamType:(NSNumber *)streamType
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSubscribeAudioAllowlistChannelTag:(NSString *)channelTag
                                                   uidArray:(NSArray<NSNumber *> *)uidArray
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error;
@end

extern void NEFLTChannelApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                 NSObject<NEFLTChannelApi> *_Nullable api);

/// The codec used by NEFLTEngineApi.
NSObject<FlutterMessageCodec> *NEFLTEngineApiGetCodec(void);

@protocol NEFLTEngineApi
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)createRequest:(NEFLTCreateEngineRequest *)request
                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)createChannelChannelTag:(NSString *)channelTag
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NEFLTNERtcVersion *)versionWithError:(FlutterError *_Nullable *_Nonnull)error;
- (nullable NSArray<NSString *> *)checkPermissionWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setParametersParams:(NSDictionary<NSString *, id> *)params
                                     error:(FlutterError *_Nullable *_Nonnull)error;
- (void)releaseWithCompletion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setStatsEventCallbackWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)clearStatsEventCallbackWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setChannelProfileChannelProfile:(NSNumber *)channelProfile
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)joinChannelRequest:(NEFLTJoinChannelRequest *)request
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)leaveChannelWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)updatePermissionKeyKey:(NSString *)key
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalAudioEnable:(NSNumber *)enable
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteAudioRequest:(NEFLTSubscribeRemoteAudioRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeAllRemoteAudioSubscribe:(NSNumber *)subscribe
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioProfileRequest:(NEFLTSetAudioProfileRequest *)request
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableDualStreamModeEnable:(NSNumber *)enable
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalVideoConfigRequest:(NEFLTSetLocalVideoConfigRequest *)request
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCameraCaptureConfigRequest:(NEFLTSetCameraCaptureConfigRequest *)request
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setVideoRotationModeRotationMode:(NSNumber *)rotationMode
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startVideoPreviewRequest:(NEFLTStartorStopVideoPreviewRequest *)request
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopVideoPreviewRequest:(NEFLTStartorStopVideoPreviewRequest *)request
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalVideoRequest:(NEFLTEnableLocalVideoRequest *)request
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalSubStreamAudioEnable:(NSNumber *)enable
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    subscribeRemoteSubStreamAudioRequest:(NEFLTSubscribeRemoteSubStreamAudioRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteLocalSubStreamAudioMuted:(NSNumber *)muted
                                              error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioSubscribeOnlyByRequest:(NEFLTSetAudioSubscribeOnlyByRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error;
- (void)startScreenCaptureRequest:(NEFLTStartScreenCaptureRequest *)request
                       completion:
                           (void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopScreenCaptureWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLoopbackRecordingEnable:(NSNumber *)enable
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteVideoStreamRequest:
                           (NEFLTSubscribeRemoteVideoStreamRequest *)request
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    subscribeRemoteSubStreamVideoRequest:(NEFLTSubscribeRemoteSubStreamVideoRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteLocalAudioStreamMute:(NSNumber *)mute
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteLocalVideoStreamMute:(NSNumber *)mute
                                     streamType:(NSNumber *)streamType
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startAudioDumpWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startAudioDumpWithTypeDumpType:(NSNumber *)dumpType
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopAudioDumpWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableAudioVolumeIndicationRequest:
                           (NEFLTEnableAudioVolumeIndicationRequest *)request
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)adjustRecordingSignalVolumeVolume:(NSNumber *)volume
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)adjustPlaybackSignalVolumeVolume:(NSNumber *)volume
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)adjustLoopBackRecordingSignalVolumeVolume:(NSNumber *)volume
                                                           error:(FlutterError *_Nullable *_Nonnull)
                                                                     error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)addLiveStreamTaskRequest:(NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)updateLiveStreamTaskRequest:(NEFLTAddOrUpdateLiveStreamTaskRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)removeLiveStreamTaskRequest:(NEFLTDeleteLiveStreamTaskRequest *)request
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setClientRoleRole:(NSNumber *)role
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getConnectionStateWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)uploadSdkInfoWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)sendSEIMsgRequest:(NEFLTSendSEIMsgRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalVoiceReverbParamRequest:
                           (NEFLTSetLocalVoiceReverbParamRequest *)request
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioEffectPresetPreset:(NSNumber *)preset
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setVoiceBeautifierPresetPreset:(NSNumber *)preset
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalVoicePitchPitch:(NSNumber *)pitch
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalVoiceEqualizationRequest:
                           (NEFLTSetLocalVoiceEqualizationRequest *)request
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)switchChannelRequest:(NEFLTSwitchChannelRequest *)request
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startAudioRecordingRequest:(NEFLTStartAudioRecordingRequest *)request
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    startAudioRecordingWithConfigRequest:(NEFLTAudioRecordingConfigurationRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopAudioRecordingWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalMediaPriorityRequest:(NEFLTSetLocalMediaPriorityRequest *)request
                                              error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableMediaPubMediaType:(NSNumber *)mediaType
                                        enable:(NSNumber *)enable
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startChannelMediaRelayRequest:
                           (NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)updateChannelMediaRelayRequest:
                           (NEFLTStartOrUpdateChannelMediaRelayRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopChannelMediaRelayWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    adjustUserPlaybackSignalVolumeRequest:(NEFLTAdjustUserPlaybackSignalVolumeRequest *)request
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setLocalPublishFallbackOptionOption:(NSNumber *)option
                                                     error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setRemoteSubscribeFallbackOptionOption:(NSNumber *)option
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableSuperResolutionEnable:(NSNumber *)enable
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableEncryptionRequest:(NEFLTEnableEncryptionRequest *)request
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioSessionOperationRestrictionOption:(NSNumber *)option
                                                           error:(FlutterError *_Nullable *_Nonnull)
                                                                     error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableVideoCorrectionEnable:(NSNumber *)enable
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)reportCustomEventRequest:(NEFLTReportCustomEventRequest *)request
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEffectDurationEffectId:(NSNumber *)effectId
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startLastmileProbeTestRequest:(NEFLTStartLastmileProbeTestRequest *)request
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopLastmileProbeTestWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setVideoCorrectionConfigRequest:
                           (NEFLTSetVideoCorrectionConfigRequest *)request
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableVirtualBackgroundRequest:(NEFLTEnableVirtualBackgroundRequest *)request
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    setRemoteHighPriorityAudioStreamRequest:(NEFLTSetRemoteHighPriorityAudioStreamRequest *)request
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCloudProxyProxyType:(NSNumber *)proxyType
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startBeautyWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)stopBeautyWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableBeautyEnabled:(NSNumber *)enabled
                                     error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setBeautyEffectLevel:(NSNumber *)level
                                 beautyType:(NSNumber *)beautyType
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)addBeautyFilterPath:(NSString *)path
                                      name:(NSString *)name
                                     error:(FlutterError *_Nullable *_Nonnull)error;
- (void)removeBeautyFilterWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setBeautyFilterLevelLevel:(NSNumber *)level
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    setLocalVideoWatermarkConfigsRequest:(NEFLTSetLocalVideoWatermarkConfigsRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setStreamAlignmentPropertyEnable:(NSNumber *)enable
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getNtpTimeOffsetWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)takeLocalSnapshotStreamType:(NSNumber *)streamType
                                              path:(NSString *)path
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)takeRemoteSnapshotUid:(NSNumber *)uid
                                  streamType:(NSNumber *)streamType
                                        path:(NSString *)path
                                       error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setExternalVideoSourceStreamType:(NSNumber *)streamType
                                                 enable:(NSNumber *)enable
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pushExternalVideoFrameStreamType:(NSNumber *)streamType
                                                  frame:(NEFLTVideoFrame *)frame
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setVideoDumpDumpType:(NSNumber *)dumpType
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSString *)getParameterKey:(NSString *)key
                             extraInfo:(NSString *)extraInfo
                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setVideoStreamLayerCountLayerCount:(NSNumber *)layerCount
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableLocalDataEnabled:(NSNumber *)enabled
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)subscribeRemoteDataSubscribe:(NSNumber *)subscribe
                                             userID:(NSNumber *)userID
                                              error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getFeatureSupportedTypeType:(NSNumber *)type
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isFeatureSupportedType:(NSNumber *)type
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSubscribeAudioBlocklistUidArray:(NSArray<NSNumber *> *)uidArray
                                               streamType:(NSNumber *)streamType
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSubscribeAudioAllowlistUidArray:(NSArray<NSNumber *> *)uidArray
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getNetworkTypeWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startPushStreamingRequest:(NEFLTStartPushStreamingRequest *)request
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startPlayStreamingRequest:(NEFLTStartPlayStreamingRequest *)request
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopPushStreamingWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopPlayStreamingStreamId:(NSString *)streamId
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pausePlayStreamingStreamId:(NSString *)streamId
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)resumePlayStreamingStreamId:(NSString *)streamId
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteVideoForPlayStreamingStreamId:(NSString *)streamId
                                                    mute:(NSNumber *)mute
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)muteAudioForPlayStreamingStreamId:(NSString *)streamId
                                                    mute:(NSNumber *)mute
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startASRCaptionRequest:(NEFLTStartASRCaptionRequest *)request
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopASRCaptionWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setMultiPathOptionRequest:(NEFLTSetMultiPathOptionRequest *)request
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)aiManualInterruptDstUid:(NSNumber *)dstUid
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)AINSModeMode:(NSNumber *)mode error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioScenarioScenario:(NSNumber *)scenario
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setExternalAudioSourceEnabled:(NSNumber *)enabled
                                          sampleRate:(NSNumber *)sampleRate
                                            channels:(NSNumber *)channels
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setExternalSubStreamAudioSourceEnabled:(NSNumber *)enabled
                                                   sampleRate:(NSNumber *)sampleRate
                                                     channels:(NSNumber *)channels
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioRecvRangeAudibleDistance:(NSNumber *)audibleDistance
                                 conversationalDistance:(NSNumber *)conversationalDistance
                                            rollOffMode:(NSNumber *)rollOffMode
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setRangeAudioModeAudioMode:(NSNumber *)audioMode
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setRangeAudioTeamIDTeamID:(NSNumber *)teamID
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)updateSelfPositionPositionInfo:(NEFLTPositionInfo *)positionInfo
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableSpatializerRoomEffectsEnable:(NSNumber *)enable
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSpatializerRoomPropertyProperty:(NEFLTSpatializerRoomProperty *)property
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSpatializerRenderModeRenderMode:(NSNumber *)renderMode
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableSpatializerEnable:(NSNumber *)enable
                                   applyToTeam:(NSNumber *)applyToTeam
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setUpSpatializerWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)addLocalRecordStreamForTaskConfig:(NEFLTLocalRecordingConfig *)config
                                                  taskId:(NSString *)taskId
                                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)removeLocalRecorderStreamForTaskTaskId:(NSString *)taskId
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    addLocalRecorderStreamLayoutForTaskConfig:(NEFLTLocalRecordingLayoutConfig *)config
                                          uid:(NSNumber *)uid
                                   streamType:(NSNumber *)streamType
                                  streamLayer:(NSNumber *)streamLayer
                                       taskId:(NSNumber *)taskId
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)removeLocalRecorderStreamLayoutForTaskUid:(NSNumber *)uid
                                                      streamType:(NSNumber *)streamType
                                                     streamLayer:(NSNumber *)streamLayer
                                                          taskId:(NSString *)taskId
                                                           error:(FlutterError *_Nullable *_Nonnull)
                                                                     error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    updateLocalRecorderStreamLayoutForTaskInfos:(NSArray<NEFLTLocalRecordingStreamInfo *> *)infos
                                         taskId:(NSString *)taskId
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    replaceLocalRecorderStreamLayoutForTaskInfos:(NSArray<NEFLTLocalRecordingStreamInfo *> *)infos
                                          taskId:(NSString *)taskId
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    updateLocalRecorderWaterMarksForTaskWatermarks:
        (NSArray<NEFLTVideoWatermarkConfig *> *)watermarks
                                            taskId:(NSString *)taskId
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pushLocalRecorderVideoFrameForTaskUid:(NSNumber *)uid
                                                  streamType:(NSNumber *)streamType
                                                 streamLayer:(NSNumber *)streamLayer
                                                      taskId:(NSString *)taskId
                                                       frame:(NEFLTVideoFrame *)frame
                                                       error:
                                                           (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)
    showLocalRecorderStreamDefaultCoverForTaskShowEnabled:(NSNumber *)showEnabled
                                                      uid:(NSNumber *)uid
                                               streamType:(NSNumber *)streamType
                                              streamLayer:(NSNumber *)streamLayer
                                                   taskId:(NSString *)taskId
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopLocalRecorderRemuxMp4TaskId:(NSString *)taskId
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)remuxFlvToMp4FlvPath:(NSString *)flvPath
                                    mp4Path:(NSString *)mp4Path
                                    saveOri:(NSNumber *)saveOri
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopRemuxFlvToMp4WithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)sendDataFrame:(NEFLTDataExternalFrame *)frame
                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pushExternalAudioFrameFrame:(NEFLTAudioExternalFrame *)frame
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pushExternalSubAudioFrameFrame:(NEFLTAudioExternalFrame *)frame
                                                error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void NEFLTEngineApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                NSObject<NEFLTEngineApi> *_Nullable api);

/// The codec used by NEFLTVideoRendererApi.
NSObject<FlutterMessageCodec> *NEFLTVideoRendererApiGetCodec(void);

@protocol NEFLTVideoRendererApi
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)createVideoRendererWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setMirrorTextureId:(NSNumber *)textureId
                                   mirror:(NSNumber *)mirror
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setupLocalVideoRendererTextureId:(NSNumber *)textureId
                                             channelTag:(NSString *)channelTag
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setupRemoteVideoRendererUid:(NSNumber *)uid
                                         textureId:(NSNumber *)textureId
                                        channelTag:(NSString *)channelTag
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setupLocalSubStreamVideoRendererTextureId:(NSNumber *)textureId
                                                      channelTag:(NSString *)channelTag
                                                           error:(FlutterError *_Nullable *_Nonnull)
                                                                     error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setupRemoteSubStreamVideoRendererUid:(NSNumber *)uid
                                                  textureId:(NSNumber *)textureId
                                                 channelTag:(NSString *)channelTag
                                                      error:
                                                          (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setupPlayStreamingCanvasStreamId:(NSString *)streamId
                                              textureId:(NSNumber *)textureId
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
- (void)disposeVideoRendererTextureId:(NSNumber *)textureId
                                error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void NEFLTVideoRendererApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                       NSObject<NEFLTVideoRendererApi> *_Nullable api);

/// The codec used by NEFLTNERtcDeviceEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcDeviceEventSinkGetCodec(void);

@interface NEFLTNERtcDeviceEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onAudioDeviceChangedSelected:(NSNumber *)selected
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioDeviceStateChangeDeviceType:(NSNumber *)deviceType
                               deviceState:(NSNumber *)deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onVideoDeviceStateChangeDeviceType:(NSNumber *)deviceType
                               deviceState:(NSNumber *)deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onCameraFocusChangedFocusPoint:(NEFLTCGPoint *)focusPoint
                            completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onCameraExposureChangedExposurePoint:(NEFLTCGPoint *)exposurePoint
                                  completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by NEFLTDeviceManagerApi.
NSObject<FlutterMessageCodec> *NEFLTDeviceManagerApiGetCodec(void);

@protocol NEFLTDeviceManagerApi
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isSpeakerphoneOnWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isCameraZoomSupportedWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isCameraTorchSupportedWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isCameraFocusSupportedWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isCameraExposurePositionSupportedWithError:
    (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setSpeakerphoneOnEnable:(NSNumber *)enable
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)switchCameraWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCameraZoomFactorFactor:(NSNumber *)factor
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getCameraMaxZoomWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCameraTorchOnOn:(NSNumber *)on
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCameraFocusPositionRequest:(NEFLTSetCameraPositionRequest *)request
                                               error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setCameraExposurePositionRequest:(NEFLTSetCameraPositionRequest *)request
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setPlayoutDeviceMuteMute:(NSNumber *)mute
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isPlayoutDeviceMuteWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setRecordDeviceMuteMute:(NSNumber *)mute
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isRecordDeviceMuteWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)enableEarbackEnabled:(NSNumber *)enabled
                                     volume:(NSNumber *)volume
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setEarbackVolumeVolume:(NSNumber *)volume
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioFocusModeFocusMode:(NSNumber *)focusMode
                                            error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getCurrentCameraWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)switchCameraWithPositionPosition:(NSNumber *)position
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getCameraCurrentZoomWithError:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void NEFLTDeviceManagerApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                       NSObject<NEFLTDeviceManagerApi> *_Nullable api);

/// The codec used by NEFLTAudioMixingApi.
NSObject<FlutterMessageCodec> *NEFLTAudioMixingApiGetCodec(void);

@protocol NEFLTAudioMixingApi
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startAudioMixingRequest:(NEFLTStartAudioMixingRequest *)request
                                         error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopAudioMixingWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pauseAudioMixingWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)resumeAudioMixingWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioMixingSendVolumeVolume:(NSNumber *)volume
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getAudioMixingSendVolumeWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioMixingPlaybackVolumeVolume:(NSNumber *)volume
                                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getAudioMixingPlaybackVolumeWithError:
    (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getAudioMixingDurationWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getAudioMixingCurrentPositionWithError:
    (FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioMixingPositionPosition:(NSNumber *)position
                                                error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setAudioMixingPitchPitch:(NSNumber *)pitch
                                          error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getAudioMixingPitchWithError:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void NEFLTAudioMixingApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                     NSObject<NEFLTAudioMixingApi> *_Nullable api);

/// The codec used by NEFLTNERtcAudioMixingEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcAudioMixingEventSinkGetCodec(void);

@interface NEFLTNERtcAudioMixingEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onAudioMixingStateChangedReason:(NSNumber *)reason
                             completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioMixingTimestampUpdateTimestampMs:(NSNumber *)timestampMs
                                     completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by NEFLTAudioEffectApi.
NSObject<FlutterMessageCodec> *NEFLTAudioEffectApiGetCodec(void);

@protocol NEFLTAudioEffectApi
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)playEffectRequest:(NEFLTPlayEffectRequest *)request
                                   error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopEffectEffectId:(NSNumber *)effectId
                                    error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)stopAllEffectsWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pauseEffectEffectId:(NSNumber *)effectId
                                     error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)resumeEffectEffectId:(NSNumber *)effectId
                                      error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)pauseAllEffectsWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)resumeAllEffectsWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setEffectSendVolumeEffectId:(NSNumber *)effectId
                                            volume:(NSNumber *)volume
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEffectSendVolumeEffectId:(NSNumber *)effectId
                                             error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setEffectPlaybackVolumeEffectId:(NSNumber *)effectId
                                                volume:(NSNumber *)volume
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEffectPlaybackVolumeEffectId:(NSNumber *)effectId
                                                 error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEffectDurationEffectId:(NSNumber *)effectId
                                           error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEffectCurrentPositionEffectId:(NSNumber *)effectId
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setEffectPitchEffectId:(NSNumber *)effectId
                                        pitch:(NSNumber *)pitch
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEffectPitchEffectId:(NSNumber *)effectId
                                        error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)setEffectPositionEffectId:(NSNumber *)effectId
                                        position:(NSNumber *)position
                                           error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void NEFLTAudioEffectApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                     NSObject<NEFLTAudioEffectApi> *_Nullable api);

/// The codec used by NEFLTNERtcAudioEffectEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcAudioEffectEventSinkGetCodec(void);

@interface NEFLTNERtcAudioEffectEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onAudioEffectFinishedEffectId:(NSNumber *)effectId
                           completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAudioEffectTimestampUpdateId:(NSNumber *)id
                           timestampMs:(NSNumber *)timestampMs
                            completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by NEFLTNERtcStatsEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcStatsEventSinkGetCodec(void);

@interface NEFLTNERtcStatsEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onRtcStatsArguments:(NSDictionary<id, id> *)arguments
                 channelTag:(NSString *)channelTag
                 completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalAudioStatsArguments:(NSDictionary<id, id> *)arguments
                        channelTag:(NSString *)channelTag
                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteAudioStatsArguments:(NSDictionary<id, id> *)arguments
                         channelTag:(NSString *)channelTag
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onLocalVideoStatsArguments:(NSDictionary<id, id> *)arguments
                        channelTag:(NSString *)channelTag
                        completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onRemoteVideoStatsArguments:(NSDictionary<id, id> *)arguments
                         channelTag:(NSString *)channelTag
                         completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onNetworkQualityArguments:(NSDictionary<id, id> *)arguments
                       channelTag:(NSString *)channelTag
                       completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by NEFLTNERtcLiveStreamEventSink.
NSObject<FlutterMessageCodec> *NEFLTNERtcLiveStreamEventSinkGetCodec(void);

@interface NEFLTNERtcLiveStreamEventSink : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onUpdateLiveStreamTaskTaskId:(NSString *)taskId
                             errCode:(NSNumber *)errCode
                          completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onAddLiveStreamTaskTaskId:(NSString *)taskId
                          errCode:(NSNumber *)errCode
                       completion:(void (^)(FlutterError *_Nullable))completion;
- (void)onDeleteLiveStreamTaskTaskId:(NSString *)taskId
                             errCode:(NSNumber *)errCode
                          completion:(void (^)(FlutterError *_Nullable))completion;
@end

NS_ASSUME_NONNULL_END
