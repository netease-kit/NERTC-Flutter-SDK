// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "../util/json.hpp"
#if _WIN32
#include <nertc_engine.h>
#else
#include <nertc_sdk_Mac/nertc_engine.h>
#endif
#include <vector>
using namespace nlohmann;
using namespace nertc;

bool JsonConvertEngineContext(const json& body, NERtcEngineContext& context,
                              std::vector<std::string>& auto_mem);
json GeneratorInitialJson(const json& body);
bool JsonConvertJoinChannel(const json& body, std::string& token,
                            std::string& channel_name, nertc::uid_t& uid,
                            NERtcJoinChannelOptions& options,
                            std::vector<std::string>& auto_mem);
bool JsonConvertToSetLocalVideoConfig(const json& body, int& stream_type,
                                      NERtcVideoConfig& config);
bool JsonConvertToVirtualBackground(const json& body, bool& enable, bool& force,
                                    VirtualBackgroundSource& source,
                                    std::vector<std::string>& auto_mem);
bool JsonConvertToSetCameraCaptureConfig(const json& body,
                                         NERtcCameraCaptureConfig& config,
                                         int& stream_type);
std::string JsonConvertToLiteParameters(const json& body);
bool JsonConvertToStartChannelMediaRelay(
    const json& body, NERtcChannelMediaRelayConfiguration& config);
bool JsonConvertToStartLastMileProbeTest(const json& body,
                                         NERtcLastmileProbeConfig& config);
json GeneratorErrorJson(int code, const std::string& error);
bool IsContainsValue(const json& jsonObj, const char* key);
bool JsonConvertToAddLiveStreamTask(const json& body,
                                    NERtcLiveStreamTaskInfo& task);
bool JsonConvertToStartAudioMixing(const json& body,
                                   NERtcCreateAudioMixingOption& config);
bool JsonConvertToPlayEffect(const json& body,
                             NERtcCreateAudioEffectOption& config);
bool JsonConvertToLocalVideoWatermarkConfigs(const json& body,
                                             NERtcVideoWatermarkConfig& config);

bool JsonConvertToLocalRecordingConfig(const json& body,
                                       NERtcLocalRecordingConfig& config);
bool JsonConvertToLocalRecordingLayoutConfig(
    const json& body, NERtcLocalRecordingLayoutConfig& config);
bool JsonConvertToLocalRecordingStreamInfo(
    const json& body, NERtcLocalRecordingStreamInfo& config);
bool JsonConvertToLocalVideoWatermarkConfigsForRecording(
    const json& body, NERtcVideoWatermarkConfig& config);
