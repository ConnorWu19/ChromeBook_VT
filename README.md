# ChromeBook Validation Toolkit
[繁體中文](README_zh.md)

## About

The ChromeBook Validation Toolkit is an automated diagnostic utility for DQA engineering. It streamlines validation with integrated menus for LinuxPCT stress execution, multimedia testing, and system telemetry monitoring.

## Prerequisites

* ChromeOS device is under **Developer Mode**.
* If you plan to run LinuxPCT stress tests, place the required HP LinuxPCT package in the project directory, other toolkit functions work without LinuxPCT.
Due to NDA and licensing restrictions, the LinuxPCT binaries are excluded from this repository, please reach out to HP TPM support or the original author to acquire the required files.


## Features

* **System Telemetry Monitoring**: Real-time status tracking during validation cycles.
* **Automated Environment Setup**: Simplifies rootfs verification removal and network configuration.
* **LinuxPCT Stress Execution**: Integrated automated workflows for hardware stress testing.
* **Log Management**: Automated log extraction and diagnostics.

## Getting Started

1. Download and extract the latest release to your to your USB drive.
2. (Optional) Place the required HP LinuxPCT binaries into the project directory.
3. Switched to **VT2** (`Ctrl` + `Alt` + `F2`) and logged in as root.
   ```bash
   bash ./ChromeBook_Validation_Toolkit.sh
<img width="860" height="545" alt="1 03" src="https://github.com/user-attachments/assets/c8808a1d-0b89-4899-9b03-59cca20cde9a" />
