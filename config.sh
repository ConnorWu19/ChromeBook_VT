#!/usr/bin/env bash

# Shared configuration for ChromeBook Validation Toolkit.

TOOL_NAME="ChromeBook_VT"
TOOL_VERSION="v1.02"
TOOL_DIR_NAME="${TOOL_NAME}_${TOOL_VERSION}"
TOOL_DISPLAY_NAME="ChromeBook Validation Toolkit"

INSTALL_BASE_DIR="/usr/local"
INSTALL_DIR="${INSTALL_BASE_DIR}/${TOOL_DIR_NAME}"

USB_MOUNT_BASE_DIR="/media/removable"
USB_FOLDER_NAME="${TOOL_DIR_NAME}"

SESSION_LOG="/tmp/CBVT_stress.log"
PCT_LOG_DIR="${INSTALL_DIR}/Log"
DOWNLOAD_DIR="/home/chronos/user/Downloads"
DEBUG_LOG_SEARCH_DIRS=("/var/log" "/tmp" "${DOWNLOAD_DIR}")
DEBUG_LOG_FILE_PATTERN="debug-logs_*.tgz"

SSD_DIR="${INSTALL_DIR}/SSD"
SSD_SOURCE_DIR="${SSD_DIR}/ssd"
SSD_WORK_DIR_1="${SSD_DIR}/ssd1"
SSD_WORK_DIR_2="${SSD_DIR}/ssd2"
SSD_LOG_FILE="${SSD_DIR}/ssd_log"
SSD_TEST_FILE="${SSD_SOURCE_DIR}/video.mp4"
