# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "nertc_core")
project(${PROJECT_NAME} LANGUAGES CXX C)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "nertc_core_plugin")

# Set C/C++ standards
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(cmake/DownloadSDK.cmake)

message(STATUS "NATIVE_INCLUDE_DIR: ${NATIVE_INCLUDE_DIR}")
message(STATUS "NATIVE_LIB_DIR: ${NATIVE_LIB_DIR}")
message(STATUS "NATIVE_DLL_DIR: ${NATIVE_DLL_DIR}")

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "nertc_core_plugin.cpp"
  "nertc_core_plugin.h"
  "../wrapper/engine_delegate.cpp"
  "../wrapper/engine_wrapper.cpp"
  "../wrapper/nertc_wrapper.cpp"
  "../wrapper/nertc_wrapper.h"
  "../wrapper/texture_render.cc"
  "../wrapper/video_view_controller.cc"
  "../wrapper/logic/convert.cpp"
  "../wrapper/util/json.hpp"
  "../wrapper/dart/dart_api_dl.c"
  "../wrapper/device_controller.cpp"
  "../wrapper/mediastats_observer.cpp"
  "../wrapper/snapshot_wrapper.cpp"
  "../wrapper/screencapture_wrapper.cpp"
  "../wrapper/channel_wrapper.cpp"
  "../wrapper/channel_delegate.cpp"
  "../wrapper/channel_mediastats_observer.cpp"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  "include/nertc_core/nertc_core_plugin_c_api.h"
  "nertc_core_plugin_c_api.cpp"
  ${PLUGIN_SOURCES}
)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Override /WX (warnings as errors) for this plugin to avoid compilation issues
target_compile_options(${PLUGIN_NAME} PRIVATE /WX-)

# Add specific warning suppressions
target_compile_options(${PLUGIN_NAME} PRIVATE 
  /wd4996  # Disable deprecated function warnings
  /wd4267  # Disable size_t conversion warnings  
  /wd4244  # Disable conversion warnings
  /wd4245  # Disable signed/unsigned mismatch warnings
  /wd4101  # Disable unreferenced local variable warnings
)

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} 
  INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../wrapper"
    "${CMAKE_CURRENT_SOURCE_DIR}/../wrapper/logic"
    "${CMAKE_CURRENT_SOURCE_DIR}/../wrapper/dart"
    "${CMAKE_CURRENT_SOURCE_DIR}/../wrapper/util"
    "${NATIVE_INCLUDE_DIR}"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE 
  flutter 
  flutter_wrapper_plugin
  ${NATIVE_LIB_DIR}/nertc_sdk.lib)

# 配置编译选项 - 使用静态链接C++运行时库
target_compile_options(${PLUGIN_NAME} PRIVATE 
  $<$<COMPILE_LANGUAGE:CXX>:
    $<$<CONFIG:Release>:/MT /O2 /Zi -DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0>
    $<$<CONFIG:Debug>:/MTd /Od /Zi -DDEBUG>
    /MP /Gm- /utf-8 /EHsc
  >
  $<$<COMPILE_LANGUAGE:C>:
    $<$<CONFIG:Release>:/MT /O2 /Zi -DNDEBUG>
    $<$<CONFIG:Debug>:/MTd /Od /Zi -DDEBUG>
    /MP /utf-8
  >
)

# 添加链接器选项以确保生成 PDB 文件
target_link_options(${PLUGIN_NAME} PRIVATE
  $<$<CONFIG:Release>:/DEBUG /OPT:REF /OPT:ICF>
  $<$<CONFIG:Debug>:/DEBUG>
)

# 设置 PDB 文件输出路径
set_target_properties(${PLUGIN_NAME} PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>"
  PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>"
  COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>"
)

file(GLOB NATIVE_DLLS ${NATIVE_DLL_DIR}/*.dll)
foreach (NATIVE_DLL ${NATIVE_DLLS})
    message(STATUS "Add bundled library: ${NATIVE_DLL}")
    list(APPEND BUNDLED_LIBRARIES ${NATIVE_DLL})
endforeach (NATIVE_DLL ${NATIVE_DLLS})

# Set the output directory for the plugin DLL to ensure correct naming
set_target_properties(${PLUGIN_NAME} PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>"
)

# Add the plugin's output DLL and PDB to the bundled libraries list
set(PLUGIN_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/${CMAKE_SHARED_LIBRARY_PREFIX}${PLUGIN_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
set(PLUGIN_PDB_PATH "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/${PLUGIN_NAME}.pdb")

message(STATUS "Plugin output path: ${PLUGIN_OUTPUT_PATH}")
message(STATUS "Plugin PDB path: ${PLUGIN_PDB_PATH}")

list(APPEND BUNDLED_LIBRARIES ${PLUGIN_OUTPUT_PATH})
list(APPEND BUNDLED_LIBRARIES ${PLUGIN_PDB_PATH})

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(nertc_core_bundled_libraries
  ${BUNDLED_LIBRARIES}
  PARENT_SCOPE
)