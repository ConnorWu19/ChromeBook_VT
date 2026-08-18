#!/usr/bin/env bash

# Shared configuration for ChromeBook Validation Toolkit.

TOOL_NAME="ChromeBook_VT"
TOOL_VERSION="v1.03"
TOOL_DIR_NAME="${TOOL_NAME}_${TOOL_VERSION}"
TOOL_DISPLAY_NAME="ChromeBook Validation Toolkit"

INSTALL_BASE_DIR="/usr/local"
INSTALL_DIR="${INSTALL_BASE_DIR}/${TOOL_DIR_NAME}"

USB_MOUNT_BASE_DIR="/media/removable"
USB_FOLDER_NAME="${TOOL_DIR_NAME}"

SESSION_LOG="/tmp/CBVT_stress.log"
PCT_LOG_DIR="${INSTALL_DIR}/Log"
DOWNLOAD_DIR="/home/chronos/user/MyFiles/Downloads"
DEBUG_LOG_SEARCH_DIRS=("/tmp")
DEBUG_LOG_FILE_PATTERN="debug-logs_*.tgz"

# External browser test URLs.
TEST_URL_FHD_1="https://www.youtube.com/watch?v=IoGivbPNGps"
TEST_URL_FHD_2="https://www.youtube.com/watch?v=rEKifG2XUZg"
TEST_URL_FHD_3="https://www.youtube.com/watch?v=uZkaJ3e9nfY"
TEST_URL_HTML5_VIDEO="https://legacy.videojs.org/city"
TEST_URL_WEBGL="https://webglsamples.org/aquarium/aquarium.html"
TEST_URL_WEBCAM="https://webcamtests.com/"

# Benchmark test URLs.
# Interactive run keeps the final score visible for the scheduled screenshot.
TEST_URL_WEBXPRT_4="https://www.principledtechnologies.com/benchmarkxprt/webxprt/2021/wx4_build_3_7_3/"
TEST_URL_GOOGLE_OCTANE_2="http://chromium.github.io/octane/"
TEST_URL_SPEEDOMETER_2="https://browserbench.org/Speedometer2.0/"

# Benchmark screenshot settings. The timer starts when each benchmark page opens.
# Delays are configured independently because benchmark run times differ.
BENCHMARK_SCREENSHOT_DELAY_GOOGLE_OCTANE_2_SECONDS=120
BENCHMARK_SCREENSHOT_DELAY_SPEEDOMETER_2_SECONDS=120
BENCHMARK_SCREENSHOT_DELAY_WEBXPRT_4_SECONDS=1000
BENCHMARK_SCREENSHOT_DIR="${DOWNLOAD_DIR}/Benchmark_Screenshots"

# WebXPRT 4 result capture. At the scheduled screenshot time, the toolkit OCRs
# the visible result page for "Test ID: 1234567" and downloads its CSV result.
# OCR is self-contained: lib/tesseract (static ARM64 binary) and
# lib/eng.traineddata are the only required OCR files.
WEBXPRT_RESULT_DOWNLOAD_URL="https://www.principledtechnologies.com/benchmarkxprt/webxprt/2021/wx4_build_3_7_3/resultdownlaod.php"
WEBXPRT_RESULT_DOWNLOAD_DIR="${DOWNLOAD_DIR}/WebXPRT_Results"
WEBXPRT_OCR_COMMAND="${SCRIPT_DIR}/lib/tesseract"
WEBXPRT_OCR_TESSDATA_DIR="${SCRIPT_DIR}/lib"
WEBXPRT_OCR_LANGUAGE="eng"
WEBXPRT_OCR_PAGE_SEGMENT_MODE=11

SSD_DIR="${INSTALL_DIR}/SSD"
SSD_SOURCE_DIR="${SSD_DIR}/ssd"
SSD_WORK_DIR_1="${SSD_DIR}/ssd1"
SSD_WORK_DIR_2="${SSD_DIR}/ssd2"
SSD_LOG_DIR="${SSD_DIR}/logs"
SSD_TEST_FILE="${SSD_SOURCE_DIR}/video.mp4"
