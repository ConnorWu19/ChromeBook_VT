#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.sh"

if [[ ! -r "$CONFIG_FILE" ]]; then
    echo "Configuration file not found: $CONFIG_FILE" >&2
    exit 1
fi

# shellcheck source=../config.sh
source "$CONFIG_FILE"

# Keep File Copy Test assets alongside the ssd.sh that is actually running.
# This prevents a stale INSTALL_DIR value from creating or using an old toolkit path.
SSD_DIR="${SCRIPT_DIR}/SSD"
SSD_SOURCE_DIR="${SSD_DIR}/ssd"
SSD_WORK_DIR_1="${SSD_DIR}/ssd1"
SSD_WORK_DIR_2="${SSD_DIR}/ssd2"
SSD_LOG_DIR="${SSD_DIR}/logs"
SSD_LOG_FILE="${SSD_LOG_DIR}/ssd_$(date +'%Y%m%d_%H%M%S').log"
SSD_TEST_FILE="${SSD_SOURCE_DIR}/video.mp4"

# Keep one log per SSD stress-test run. Logs are intentionally retained and
# never removed automatically so prior test evidence remains available.
if ! sudo mkdir -p "$SSD_LOG_DIR"; then
    echo "[Error] Unable to create SSD log directory: ${SSD_LOG_DIR}" >&2
    exit 1
fi

echo "=== SSD Stress Test Started: $(date) ===" | tee -a "$SSD_LOG_FILE"

function run_ssd_command() {
    local description=$1
    shift

    if "$@"; then
        return 0
    else
        local exit_code=$?
        echo "[Error] ${description} failed (exit code: ${exit_code})." | tee -a "$SSD_LOG_FILE"
        exit "$exit_code"
    fi
}

if sudo mkdir -p "$SSD_SOURCE_DIR" "$SSD_WORK_DIR_1" "$SSD_WORK_DIR_2"; then
    echo "[Success] SSD test directories are ready."
    run_ssd_command "Set SSD directory permissions" sudo chmod -R 755 "$SSD_DIR"
else
    mkdir_exit_code=$?
    echo "[Error] Unable to prepare SSD test directories (exit code: ${mkdir_exit_code}). Check storage space and permissions." | tee -a "$SSD_LOG_FILE"
    exit "$mkdir_exit_code"
fi

# Verify that the source asset copied by the deployment workflow is available.
if [[ ! -f "$SSD_TEST_FILE" ]]; then
    echo "[Error] SSD test file not found: $SSD_TEST_FILE"
    exit 1
fi

# Reset working directories and seed the first copy.
run_ssd_command "Clear SSD work directory 1" sudo rm -rf "$SSD_WORK_DIR_1"/*
run_ssd_command "Clear SSD work directory 2" sudo rm -rf "$SSD_WORK_DIR_2"/*
run_ssd_command "Seed SSD test file" sudo cp -a "$SSD_TEST_FILE" "$SSD_WORK_DIR_1/"

cycle=1

while true; do
    echo "=== Start Cycle: $cycle ===" | tee -a "$SSD_LOG_FILE"

    run_ssd_command "Copy test file to SSD work directory 2" sudo cp -a "$SSD_WORK_DIR_1/video.mp4" "$SSD_WORK_DIR_2/"
    echo "Copy to ssd2 done $(date)" | tee -a "$SSD_LOG_FILE"

    run_ssd_command "Remove test file from SSD work directory 1" sudo rm -f "$SSD_WORK_DIR_1/video.mp4"
    echo "Remove ssd1 done $(date)" | tee -a "$SSD_LOG_FILE"

    run_ssd_command "Copy test file back to SSD work directory 1" sudo cp -a "$SSD_WORK_DIR_2/video.mp4" "$SSD_WORK_DIR_1/"
    echo "Copy back to ssd1 done $(date)" | tee -a "$SSD_LOG_FILE"

    run_ssd_command "Remove test file from SSD work directory 2" sudo rm -f "$SSD_WORK_DIR_2/video.mp4"
    echo "Remove ssd2 done $(date)" | tee -a "$SSD_LOG_FILE"

    echo "=== End Cycle: $cycle ===" | tee -a "$SSD_LOG_FILE"
    echo "" | tee -a "$SSD_LOG_FILE"

    cycle=$((cycle+1))

    sleep 0.1
done
