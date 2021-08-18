// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcVideoValue {
  const _NERtcVideoValue({
     this.width = 0,
     this.height = 0,
     this.rotation = 0,
  });

  final int width;
  final int height;
  final int rotation;

  const _NERtcVideoValue.uninitialized()
      : this(
          width: 0,
          height: 0,
          rotation: 0,
        );

  _NERtcVideoValue copyWith({
    int? width,
    int? height,
    int? rotation,
  }) {
    return _NERtcVideoValue(
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
    );
  }

  double get aspectRatio {
    return width * height == 0
        ? 1.0
        : (rotation == 90 || rotation == 270)
            ? height / width
            : width / height;
  }

  @override
  String toString() {
    return 'NERtcVideoValue{width: $width, height: $height, rotation: $rotation}';
  }
}
