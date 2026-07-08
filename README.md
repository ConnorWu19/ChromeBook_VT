# ChromeBook Validation Toolkit

[繁體中文](README_zh.md)

# About

The ChromeBook Validation Toolkit is an automated diagnostic utility for DQA engineering. It streamlines validation with integrated menus for LinuxPCT stress execution, multimedia testing, and system telemetry monitoring.

## Prerequisites

This toolkit requires the official HP LinuxPCT tool for related functional tests. Due to NDA and licensing restrictions, the LinuxPCT binaries are excluded from this repository. Please reach out to HP TPM support or the original author to acquire the required files.

License

This project is for internal validation and development purposes. Third-party tools used alongside this toolkit remain the property of their respective owners.

## Features

* **System Telemetry Monitoring**: Real-time status tracking during validation cycles.
* **Automated Environment Setup**: Simplifies rootfs verification removal and network configuration.
* **LinuxPCT Stress Execution**: Integrated automated workflows for hardware stress testing.
* **Log Management**: Automated log extraction and diagnostics.

## Getting Started

1. Clone this repository to your local machine.
2. (Optional) Place the required HP LinuxPCT binaries into the same directory.
3. Make the main script executable:
   ```bash
   bash ./ChromeBook_Validation_Toolkit.sh
