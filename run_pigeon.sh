#!/bin/sh

#
# Copyright (c) 2021 NetEase, Inc.  All rights reserved.
# Use of this source code is governed by a MIT license that can be
# found in the LICENSE file.
#

flutter pub run pigeon \
  --input pigeons/message.dart \
  --dart_out lib/src/internal/messages.dart \
  --objc_prefix NEFLT \
  --objc_header_out ios/Classes/messages.h \
  --objc_source_out ios/Classes/messages.m \
  --java_out ./android/src/main/java/com/netease/nertcflutter/Messages.java \
  --java_package "com.netease.nertcflutter"
