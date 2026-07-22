# ChromeBook Validation Toolkit
[繁體中文](README_zh.md)

## About

The ChromeBook Validation Toolkit is an automated diagnostic utility for DQA engineering. It streamlines validation with integrated menus for LinuxPCT stress execution, multimedia testing, and system telemetry monitoring.

## Prerequisites

If you plan to run LinuxPCT stress tests, place the required HP LinuxPCT package in the project directory, other toolkit functions work without LinuxPCT.

Due to NDA and licensing restrictions, the LinuxPCT binaries are excluded from this repository, please reach out to HP TPM support or the original author to acquire the required files.


## Features

* **System Telemetry Monitoring**: Real-time status tracking during validation cycles.
* **Automated Environment Setup**: Simplifies rootfs verification removal and network configuration.
* **LinuxPCT Stress Execution**: Integrated automated workflows for hardware stress testing.
* **Log Management**: Automated log extraction and diagnostics.

## Getting Started

1. Download and extract the latest release to your local machine.
2. (Optional) Place the required HP LinuxPCT binaries into the project directory.
3. Make the main script executable in VT2.

   ```bash
   bash ./ChromeBook_Validation_Toolkit.sh
<img width="520" height="333" alt="image" src="https://github.com/user-attachments/assets/173db6c7-1b3c-45e6-8ba1-91f17341ba74" />
