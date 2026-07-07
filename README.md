# ChromeBook_HP_Stress_Toolkit

[繁體中文](README_zh.md)

# About

The ChromeBook HP Stress Toolkit is an automated diagnostic utility for DQA engineering. It streamlines validation with integrated menus for LinuxPCT stress execution, multimedia testing, and system telemetry monitoring. It also simplifies network configuration, log extraction, and rootfs verification removal during hardware testing.

## Prerequisites

This toolkit requires the official HP LinuxPCT tool to function. Due to NDA and licensing restrictions, the LinuxPCT binaries are excluded from this repository. Please reach out to HP TPM support or the original author to acquire the required files.

License
This project is for internal validation and development purposes. Third-party tools used alongside this toolkit remain the property of their respective owners.

## Features

* **LinuxPCT Stress Execution**: Integrated automated workflows for hardware stress testing.
* **System Telemetry Monitoring**: Real-time status tracking during validation cycles.
* **Automated Environment Setup**: Simplifies rootfs verification removal and network configuration.
* **Log Management**: Automated log extraction and diagnostics.

## Getting Started

1. Clone this repository to your local machine.
2. Place the required HP LinuxPCT binaries into the designated directory (ensure it matches your `.gitignore` configuration).
3. Make the main script executable:
   ```bash
   chmod +x ChromeBook_HP_Stress_Toolkit.sh
