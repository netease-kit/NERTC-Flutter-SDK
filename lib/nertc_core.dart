// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library nertc;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nertc_core_platform_interface/nertc_core_platform_interface.dart';
import 'package:nertc_core_platform_interface/pigeon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yunxin_alog/yunxin_alog.dart';
import 'package:crypto/crypto.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'src/ffi/ffi_define.dart';
import 'src/ffi/nertc_render.dart';
import 'src/ffi/nertc_bindings_generated.dart';

export 'package:nertc_core_platform_interface/nertc_core_platform_interface.dart'
    show
        NERtcUserRole,
        NERtcClientRole,
        NERtcLogLevel,
        NERtcServerAddresses,
        NERtcJoinChannelOptions,
        NERtcConnectionType,
        NERtcConnectionState,
        NERtcNetworkQuality,
        NERtcConnectionStateChangeReason,
        NERtcAudioDevice,
        NERtcAudioDeviceState,
        NERtcVideoDeviceState,
        NERtcAudioDeviceType,
        NERtcCameraType,
        NERtcCameraPosition,
        NERtcScreenConfig,
        NERtcScreenProfile,
        NERtcSubStreamContentPrefer,
        NERtcCameraCapturePreference,
        NERtcCameraCaptureConfig,
        NERtcOptions,
        NERtcServerRecordMode,
        NERtcVideoSendMode,
        NERtcMediaCodecMode,
        NERtcAudioSessionOperationRestriction,
        NERtcAudioProfile,
        NERtcAudioScenario,
        NERtcVoiceChangerType,
        NERtcVoiceBeautifierType,
        NERtcVideoConfig,
        NERtcVideoProfile,
        NERtcVideoMirrorMode,
        NERtcLocalVideoWatermarkState,
        NERtcReverbParam,
        LastmileProbeConfig,
        NERtcVideoCorrectionConfiguration,
        NERtcVideoOutputOrientationMode,
        NERtcRemoteVideoStreamType,
        NERtcVideoViewFitType,
        NERtcVideoCropMode,
        NERtcVideoStreamType,
        NERtcAudioVolumeInfo,
        NERtcAudioDumpType,
        NERtcAudioMixingError,
        NERtcAudioRecordingConfiguration,
        NERtcAudioRecordingQuality,
        NERtcAudioRecordingPosition,
        NERtcAudioRecordingCycleTime,
        NERtcMediaPriority,
        NERtcMediaPubType,
        NERtcLastmileProbeResultState,
        NERtcChannelMediaRelayState,
        NERtcChannelMediaRelayEvent,
        NERtcChannelMediaRelayInfo,
        NERtcStreamFallbackOptions,
        NERtcAudioRecordingCode,
        NERtcChannelMediaRelayConfiguration,
        VirtualBackgroundSourceType,
        BlurDegree,
        NERtcVirtualBackgroundSource,
        NERtcVirtualBackgroundSourceStateReason,
        NERtcStreamChannelType,
        NERtcEncryptionConfig,
        NERtcEncryptionMode,
        NERtcTransportType,
        NERtcBeautyEffectType,
        NERtcAudioMixingTaskState,
        NERtcAudioStreamType,
        NERtcLiveStreamErrorCode,
        NERtcLiveStreamLayout,
        NERtcLiveStreamVideoScaleMode,
        NERtcLiveStreamUserTranscoding,
        NERtcLiveStreamImageInfo,
        NERtcLiveStreamTaskInfo,
        NERtcErrorCode,
        NERtcRuntimeError,
        NERtcNetworkStatus,
        NERtcChannelProfile,
        NERtcAudioFocusMode,
        NERtcDegradationPreference,
        NERtcVideoFrameRate,
        NERtcLiveStreamMode,
        NERtcLiveStreamState,
        NERtcAudioMixingOptions,
        NERtcAudioEffectOptions,
        NERtcAudioSendStats,
        NERtcStats,
        NERtcNetworkQualityInfo,
        NERtcAudioRecvStats,
        NERtcVideoSendStats,
        NERtcVideoRecvStats,
        NERtcAudioLayerRecvStats,
        NERtcAudioLayerSendStats,
        NERtcVideoLayerRecvStats,
        NERtcVideoLayerSendStats,
        NERtcVideoWatermarkConfig,
        NERtcVideoWatermarkImageConfig,
        NERtcVideoWatermarkTextConfig,
        NERtcVideoWatermarkTimestampConfig,
        NERtcVideoFrame,
        NERtcVideoFrameFormat,
        NERtcVideoRotationType,
        NERtcVideoDumpType,
        NERtcFeatureType,
        NERtcAudioAINSMode,
        NERtcDistanceRollOffModel,
        NERtcRangeAudioMode,
        NERtcPositionInfo,
        NERtcSpatializerRoomProperty,
        NERtcSpatializerRenderMode,
        NERtcSpatializerRoomCapacity,
        NERtcSpatializerMaterialName,
        NERtcLocalRecordingFileType,
        NERtcWatermarkType,
        NERtcLocalRecordingAudioFormat,
        NERtcLocalRecordingVideoMode,
        NERtcVideoScalingModeEnum,
        NERtcLocalRecordingConfig,
        NERtcLocalRecordingLayoutConfig,
        NERtcLocalRecordingStreamInfo,
        NERtcMultiPathMediaMode,
        NERtcStreamingRoomInfo,
        NERtcPushStreamingConfig,
        NERtcPlayStreamingConfig,
        NERtcASRCaptionConfig,
        NERtcFrameNormalizedRect,
        NERtcMultiPathOption,
        NERtcDataExternalFrame,
        NERtcAudioExternalFrame,
        NERtcScreenCaptureSourceData;

export 'package:nertc_core_platform_interface/pigeon.dart'
    show
        NERtcVersion,
        CGPoint,
        NERtcVideoWatermarkType,
        NERtcUserLeaveExtraInfo,
        NERtcUserJoinExtraInfo,
        NERtcCaptureExtraRotation,
        NERtcLastmileProbeResult,
        NERtcLastmileProbeOneWayResult;

part 'src/api/nertc_event_callback.dart';
part 'src/nertc_video_view.dart';
part 'src/nertc_parameters_key.dart';

part 'src/api/log_service.dart';
part 'src/api/nertc_engine.dart';
part 'src/api/nertc_channel.dart';
part 'src/api/nertc_device.dart';
part 'src/api/nertc_audio_effect.dart';
part 'src/api/nertc_audio_mixing.dart';
part 'src/api/nertc_video_renderer.dart';
part 'src/api/device_collection.dart';
part 'src/api/nertc_desktop_screencapture.dart';

part 'src/impl/nertc_engine_impl.dart';
part 'src/impl/nertc_channel_impl.dart';
part 'src/impl/nertc_device_impl.dart';
part 'src/impl/nertc_audio_effect_impl.dart';
part 'src/impl/nertc_audio_mixing_impl.dart';
part 'src/impl/nertc_video_renderer_impl.dart';
part 'src/impl/device_collection_impl.dart';
part 'src/impl/nertc_desktop_screencapture_impl.dart';
part 'src/ffi/nertc_ffi.dart';
