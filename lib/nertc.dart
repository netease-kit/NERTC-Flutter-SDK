// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

library nertc;

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nertc/src/internal/messages.dart';

part 'src/nertc_base.dart';
part 'src/nertc_engine.dart';
part 'src/nertc_event_callback.dart';
part 'src/nertc_stats.dart';
part 'src/nertc_video_view.dart';
part 'src/nertc_video_renderer.dart';
part 'src/nertc_device.dart';
part 'src/nertc_audio_mixing.dart';
part 'src/nertc_audio_effect.dart';
part 'src/internal/event_handler.dart';
part 'src/internal/utils.dart';
part 'src/internal/stats_event_handler.dart';
part 'src/internal/audio_mixing_event_handler.dart';
part 'src/internal/audio_effect_event_handler.dart';
part 'src/internal/device_event_handler.dart';
part 'src/internal/channel_event_handler.dart';
part 'src/internal/video_renderer_impl.dart';
part 'src/internal/nertc_common.dart';
part 'src/internal/once_event_handler.dart';
