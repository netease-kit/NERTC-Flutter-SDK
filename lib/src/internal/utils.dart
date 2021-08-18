// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _PlatformUtils {
  // Method Channel
  static const MethodChannel _kChannel = MethodChannel('nertc_flutter');

  static MethodChannel get methodChannel => _kChannel;
}
