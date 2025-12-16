// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:ffi' as ffi;

/// Bindings for `src/nertc_wrapper.h`.
///
/// Regenerate bindings with `flutter pub run ffigen --config ffigen.yaml`.
///
class NERtcBinding {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NERtcBinding(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NERtcBinding.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int InvokeMethod(
    ffi.Pointer<ffi.Char> params,
  ) {
    return _InvokeMethod(
      params,
    );
  }

  late final _InvokeMethodPtr =
      _lookup<ffi.NativeFunction<ffi.Int64 Function(ffi.Pointer<ffi.Char>)>>(
          'InvokeMethod');
  late final _InvokeMethod =
      _InvokeMethodPtr.asFunction<int Function(ffi.Pointer<ffi.Char>)>();

  ffi.Pointer<ffi.Char> InvokeStrMethod(
    ffi.Pointer<ffi.Char> params,
  ) {
    return _InvokeStrMethod(
      params,
    );
  }

  late final _InvokeStrMethodPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ffi.Char>)>>('InvokeStrMethod');
  late final _InvokeStrMethod = _InvokeStrMethodPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>();

  int PushVideoFrame(
    ffi.Pointer<ffi.Char> params,
    ffi.Pointer<ffi.Uint8> data,
    ffi.Pointer<ffi.Double> matrix,
  ) {
    return _PushVideoFrame(
      params,
      data,
      matrix,
    );
  }

  late final _PushVideoFramePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int64 Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Uint8>,
              ffi.Pointer<ffi.Double>)>>('PushVideoFrame');
  late final _PushVideoFrame = _PushVideoFramePtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Uint8>,
          ffi.Pointer<ffi.Double>)>();

  int PushDataFrame(
    ffi.Pointer<ffi.Char> params,
    ffi.Pointer<ffi.Uint8> data,
  ) {
    return _PushDataFrame(
      params,
      data,
    );
  }

  late final _PushDataFramePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int64 Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Uint8>)>>('PushDataFrame');
  late final _PushDataFrame = _PushDataFramePtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Uint8>)>();

  int PushAudioFrame(
    ffi.Pointer<ffi.Char> params,
    ffi.Pointer<ffi.Uint8> data,
  ) {
    return _PushAudioFrame(
      params,
      data,
    );
  }

  late final _PushAudioFramePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int64 Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Uint8>)>>('PushAudioFrame');
  late final _PushAudioFrame = _PushAudioFramePtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Uint8>)>();

  void CallDartMethod(
    DartCallback callback,
  ) {
    return _CallDartMethod(
      callback,
    );
  }

  late final _CallDartMethodPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartCallback)>>(
          'CallDartMethod');
  late final _CallDartMethod =
      _CallDartMethodPtr.asFunction<void Function(DartCallback)>();

  /// async callback.
  int InitDartApiDL(
    ffi.Pointer<ffi.Void> data,
  ) {
    return _InitDartApiDL(
      data,
    );
  }

  late final _InitDartApiDLPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'InitDartApiDL');
  late final _InitDartApiDL =
      _InitDartApiDLPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void RegisterNativePort(
    int port,
  ) {
    return _RegisterNativePort(
      port,
    );
  }

  late final _RegisterNativePortPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(Dart_Port)>>(
          'RegisterNativePort');
  late final _RegisterNativePort =
      _RegisterNativePortPtr.asFunction<void Function(int)>();
}

/// sync callback.
typedef DartCallback = ffi.Pointer<
    ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char> message)>>;

/// A port is used to send or receive inter-isolate messages
typedef Dart_Port = ffi.Int64;
