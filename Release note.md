2026/08/24

ChromeBook_Validation_Toolkit v1.03

🚀 Added

* When capturing PCT Logs, the USB drive automatically creates the LinuxPCT_log folder and saves the logs to USB/LinuxPCT_log/Log/FFFFFFFF.
* Added a [BIOS FW] field to Info Monitor, which displays the machine's BIOS/FW version using crossystem fwid.
* Added a Benchmark Test submenu under Multimedia: WebXPRT 4/Google Octane 2.0/Speedometer 2.0
* Added automatic screenshot capture and result processing for Benchmark tests:
  After each test is launched, a full-screen screenshot of VT1 is automatically captured at the specified time and saved to Downloads/Benchmark_Screenshots.
  1. Google Octane 2.0/Speedometer2.0/WebXPRT 4 : 120s/120s/1000s)
  2. Supports automatic file naming based on SKU and AC/DC conditions.
  3. Uses OCR to read the Test ID displayed on the WebXPRT screen and automatically downloads the test result based on the Test ID.
* Added a dedicated SSD test log. Log path: SSD/logs/ssd_YYYYMMDD_HHMMSS.log.
* Added a confirmation prompt after selecting Get Generate Logs:
  Are you sure you want to run Get Generate logs? [y/n]
  The operation will only proceed when y or Y is entered.

🔧 Changed

* Updated the SSD path used by File Copy Test to be determined based on the directory containing the ssd.sh script currently being executed.
* Updated the success message displayed after Capture PCT Logs completes successfully.
* Changed the Debug Log search scope to /tmp only.
* Improved the prompt text in the File Copy Test menu.
* Centralized Benchmark test URLs in config.sh.
* Benchmark URLs now remain open after launching. Press Enter to return to the Benchmark submenu.
* Added a 0.4-second delay before returning to the Benchmark submenu after pressing Enter in a Benchmark test.
* After a Benchmark URL is opened successfully, the following messages are displayed sequentially:
  [+] Execution Completed.
  [SUCCESS] URL Opened Successfully.
  [WARN] Please manually switch to VT1 by pressing CTRL+ALT+F1
* Adjusted Info Monitor field spacing dynamically based on the actual content length.
* Added cursor-based text editing support to Check GBB Value, File Copy Test, and Get Generate Logs.
* Changed directory permissions in four locations from chmod -R 777 to chmod -R 755.
* When File Copy Test terminates unexpectedly, the prompt now points to the latest timestamped SSD log instead of /tmp/CBVT_stress.log.
* Removed the legacy ssd.sh from the root directory and standardized on SSD/ssd.sh.
* Removed large legacy SSD test logs from SSD/ssd_log.

🐛 Fixed

* When no USB drive is inserted, Copy Tool to DUT / Copy Script to DUT no longer fails directly due to the missing USB drive. The copy operation is skipped and execution continues.
* Fixed an issue where File Copy Test could use an outdated ChromeBook_HP_Stress_Toolkit path and create an empty directory.
* Fixed an issue where the Benchmark URL success message and the VT1 switching reminder were displayed repeatedly.
* Capture PCT Logs now verifies that the source Log/FFFFFFFF directory exists before exporting, preventing incomplete or empty PCT logs from being exported.
* After Remove Rootfs Verification in File Copy Test successfully issues a reboot command, the Press Enter to return to main menu prompt is no longer displayed.
* The SSD log directory is now automatically created when ssd.sh starts, preventing SSD/logs from being unavailable.
* Fixed an issue where custom text input could produce garbled characters or ? when using the Left/Right arrow keys, Backspace, Caps Lock, or moving the cursor to the beginning or end of the input   string.
