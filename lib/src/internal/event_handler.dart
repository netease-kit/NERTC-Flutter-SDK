// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

mixin _EventHandler {
  bool handler(String method, Map<dynamic, dynamic> arguments);
}
