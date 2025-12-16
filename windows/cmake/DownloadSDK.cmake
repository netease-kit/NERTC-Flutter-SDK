
# native dependencies start
set(NATIVE_SDK_DOWNLOAD_URL "https://yx-web-nosdn.netease.im/package/1761213316/NERTC_Windows_SDK_V5.9.11.zip?download=NERTC_Windows_SDK_V5.9.11.zip")
# native dependencies end

function(download_and_extract URL TARGET_DIR EXTRACTED_DIR)
    message(STATUS "Downloading ${URL} to ${TARGET_DIR}")

    # Escape the URL for the command line
    string(REPLACE "+" "%2B" URL_ESCAPED ${URL})

    # Extract the file name from the URL (handles URLs with query parameters)
    get_filename_component(SOURCE_FILE_NAME "${URL}" NAME)
    string(REGEX REPLACE "\\?.*" "" SOURCE_FILE_NAME "${SOURCE_FILE_NAME}") 
    message(STATUS "Source file name: ${SOURCE_FILE_NAME}")

    # Set the target file path
    set(TARGET_FILE "${TARGET_DIR}/${SOURCE_FILE_NAME}.zip")
    message(STATUS "Target file: ${TARGET_FILE}")

    # Download the file if it doesn't exist
    if(NOT EXISTS "${TARGET_FILE}")
        message(STATUS "TARGET_DIR: ${TARGET_DIR}")
        message(STATUS "Downloading ${URL_ESCAPED} to ${TARGET_FILE}")
        file(MAKE_DIRECTORY "${TARGET_DIR}")
        file(DOWNLOAD ${URL_ESCAPED} ${TARGET_FILE} SHOW_PROGRESS STATUS status)
        list(GET status 0 status_code)
        list(GET status 1 status_string)
        if(NOT status_code EQUAL 0)
          # Remove the file if it exists when the download fails
          if(EXISTS "${TARGET_FILE}")
            file(REMOVE "${TARGET_FILE}")
          endif()
          message(FATAL_ERROR "Download failed: ${STATUS_STRING}")
        endif()
    endif()

    # Remove the extracted directory if it exists
    if(EXISTS "${EXTRACTED_DIR}")
      file(REMOVE_RECURSE "${EXTRACTED_DIR}")
    endif()

    # Create the extracted directory if it doesn't exist
    file(MAKE_DIRECTORY "${EXTRACTED_DIR}")

    # Extract the file
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xzf "${TARGET_FILE}"
        WORKING_DIRECTORY ${EXTRACTED_DIR}
    )
endfunction()

message(STATUS "Start downloading Native SDK from ${NATIVE_SDK_DOWNLOAD_URL}")

set(CONST_EXTRACTED_DIR_NAME "lib")

# Download and extract the Native SDK
set(NATIVE_DOWNLOAD_PATH "${CMAKE_CURRENT_SOURCE_DIR}/third_party/native")
set(NATIVE_EXTRACTED_DIR "${NATIVE_DOWNLOAD_PATH}/${CONST_EXTRACTED_DIR_NAME}")

message(STATUS "NATIVE_DOWNLOAD_PATH: ${NATIVE_DOWNLOAD_PATH}")
message(STATUS "NATIVE_EXTRACTED_DIR: ${NATIVE_EXTRACTED_DIR}")

# Download and extract the Native SDK if the plugin is not in development mode
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.plugin_dev")
    download_and_extract("${NATIVE_SDK_DOWNLOAD_URL}" "${NATIVE_DOWNLOAD_PATH}" "${NATIVE_EXTRACTED_DIR}")
endif()

# Fixed the root directory of Native SDK to */sdk coz sdk has a fixed directory structure
set(NATIVE_SDK_ROOT "")
set(NATIVE_SDK_ROOT_REGEX "sdk")
file(GLOB_RECURSE NATIVE_DIRECTORIES LIST_DIRECTORIES true "${NATIVE_EXTRACTED_DIR}/*")
foreach(SUBDIR ${NATIVE_DIRECTORIES})
  STRING(REGEX MATCH "${NATIVE_SDK_ROOT_REGEX}$" FIND_SDK_ROOT "${SUBDIR}")
  if(FIND_SDK_ROOT)
    set(NATIVE_SDK_ROOT "${SUBDIR}")
    break()
  endif()
endforeach()

# Print and verify the root directory of Native SDK
if(NATIVE_SDK_ROOT STREQUAL "")
  message(WARNING "NATIVE_SDK_ROOT: ${NATIVE_SDK_ROOT}")
  message(FATAL_ERROR "Failed to find root directory of Native SDK")
endif()

set(NATIVE_INCLUDE_DIR "${NATIVE_SDK_ROOT}/api")
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(NATIVE_LIB_DIR "${NATIVE_SDK_ROOT}/libs/x64")
    set(NATIVE_DLL_DIR "${NATIVE_SDK_ROOT}/dll/x64")
else()
    set(NATIVE_LIB_DIR "${NATIVE_SDK_ROOT}/libs/x86")
    set(NATIVE_DLL_DIR "${NATIVE_SDK_ROOT}/dll/x86")
endif()
