# ChromeBook Validation Toolkit
[繁體中文](README_zh.md)

## About

The ChromeBook Validation Toolkit is an automated diagnostic utility for DQA engineering. It streamlines validation with integrated menus for LinuxPCT stress execution, multimedia testing, and system telemetry monitoring.

## 🎯 Project Purpose
ChromeBook Validation Toolkit was developed to simplify repetitive Chromebook validation procedures by combining commonly used DQA workflows into a single command-line toolkit.

**The project focuses on:
* Reducing repetitive manual operations
* Improving validation consistency
* Centralizing commonly used DQA utilities
* Simplifying log collection and troubleshooting
* Automating benchmark and stress-test workflows

## Features

* **System Telemetry Monitoring**: Real-time ChromeOS system telemetry monitoring.
* **Automated Environment Setup**: Simplifies rootfs verification removal and network configuration.
* **Benchmark Automation**: Integrated WebXPRT 4, Google Octane 2.0, and Speedometer 2.0 workflows
* **SSD Testing**: Automated file-copy stress testing with dedicated test logs.
* **LinuxPCT Stress Execution**: Integrated automated workflows for hardware stress testing.
* **Log Management**: Automated log extraction and diagnostics.

## Prerequisites

* The device must be in **Developer Mode**.
* Most toolkit functions work independently and do not require LinuxPCT.
* If you plan to run LinuxPCT stress tests, place the required HP LinuxPCT package in the project directory, other toolkit functions work without LinuxPCT.

  Due to NDA and licensing restrictions, the LinuxPCT binaries are excluded from this repository, please reach out to HP TPM support or the original author to acquire the required files.

## Getting Started

1. Download and extract the latest release to your USB drive.
2. (Optional) Place the required HP LinuxPCT binaries into the project directory if you need to run LinuxPCT tests.
3. Switch to **VT2** (`Ctrl` + `Alt` + `F2`) and log in as root.
4. Insert the USB drive, navigate to the toolkit directory, and launch the script:

   ```bash
   bash ./ChromeBook_Validation_Toolkit.sh
   
<img width="810" height="510" alt="1 03" src="https://github.com/user-attachments/assets/c8808a1d-0b89-4899-9b03-59cca20cde9a" />

## 📄 License

This project is licensed under the MIT License.

See the [license](LICENSE) file for details.
