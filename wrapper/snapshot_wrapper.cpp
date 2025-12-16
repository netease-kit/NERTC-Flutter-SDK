// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "engine_wrapper.h"

#ifdef _WIN32

#else
extern "C" bool SaveCGImageToFile(const char* filePath, const char* buffer);
#endif

std::set<NERtcSnapshotCallbackWrapper*>
    NERtcSnapshotCallbackWrapper::snapshot_callback_set_;
std::mutex NERtcSnapshotCallbackWrapper::snapshot_callback_set_mutex_;

NERtcSnapshotCallbackWrapper* NERtcSnapshotCallbackWrapper::Create(
    std::string& path) {
  auto* wrapper = new NERtcSnapshotCallbackWrapper();
  wrapper->path_ = path;
  std::lock_guard<std::mutex> lock(snapshot_callback_set_mutex_);
  snapshot_callback_set_.emplace(wrapper);
  return wrapper;
}

void NERtcSnapshotCallbackWrapper::Delete(
    NERtcSnapshotCallbackWrapper* callback) {
  std::lock_guard<std::mutex> lock(snapshot_callback_set_mutex_);
  auto it = snapshot_callback_set_.find(callback);
  if (it != snapshot_callback_set_.end()) {
    delete *it;
    snapshot_callback_set_.erase(it);
  }
}

void NERtcSnapshotCallbackWrapper::Clear() {
  std::lock_guard<std::mutex> lock(snapshot_callback_set_mutex_);
  for (auto* callback : snapshot_callback_set_) {
    delete callback;
  }
  snapshot_callback_set_.clear();
}

void NERtcSnapshotCallbackWrapper::onTakeSnapshotResult(int errorCode,
                                                        const char* image) {
  if (errorCode != kNERtcNoError) {
    printf("take snapshot failed, errorCode: %d\n", errorCode);
    return;
  }
#ifdef _WIN32
  // TODO 处理图片数据到目标 path_
  if (image && path_.size() > 0) {
    // image is the source file path, path_ is the destination file path
    // Use wide char version to support Chinese paths
    int srcLen = MultiByteToWideChar(CP_UTF8, 0, image, -1, NULL, 0);
    int dstLen = MultiByteToWideChar(CP_UTF8, 0, path_.c_str(), -1, NULL, 0);
    if (srcLen > 0 && dstLen > 0) {
      std::wstring wsrc(srcLen, L'\0');
      std::wstring wdst(dstLen, L'\0');
      MultiByteToWideChar(CP_UTF8, 0, image, -1, &wsrc[0], srcLen);
      MultiByteToWideChar(CP_UTF8, 0, path_.c_str(), -1, &wdst[0], dstLen);
      // Remove the trailing null character for std::wstring
      wsrc.resize(srcLen - 1);
      wdst.resize(dstLen - 1);
      if (!CopyFileW(wsrc.c_str(), wdst.c_str(), FALSE)) {
        printf("Failed to copy snapshot file from %s to %s, error: %lu\n",
               image, path_.c_str(), GetLastError());
      }
    } else {
      printf("Failed to convert file paths to wide char.\n");
    }
  }
#else
  SaveCGImageToFile(path_.c_str(), image);
#endif

  // send to dart result.
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnTakeSnapshot;
  dart_json["code"] = errorCode;
  dart_json["path"] = path_;
  std::string response = dart_json.dump();
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  auto send_port = NERtcDesktopWrapper::ShareInstance()->GetDartSendPort();
  Dart_PostCObject_DL(send_port, &dart_object);

  // delete self.
  Delete(this);
}
