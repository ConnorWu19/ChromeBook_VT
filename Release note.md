2026/07/17

\*ChromeBook\_Validation\_Toolkit v1.02

🚀 Added

* Added a shared config.sh to centralize the toolkit version, installation directory, USB mount point, log locations, and SSD test paths.
* Added .gitattributes to enforce LF line endings for shell scripts.



🔧 Changed

* Updated the tool title.
* Combined the Remove Verification and Clean Logs actions in the LinuxPCT menu.
* Enhanced the reusable command-execution helper to capture exit codes and record command output in the session log.
* Improved SSD command-level error handling. The stress test now stops and records an error when directory preparation, file copying, or file removal fails.
* Updated the main script and SSD stress-test script to load shared settings from config.sh.
* Replaced hard-coded USB, installation, LinuxPCT log, Downloads, SSD, and session-log paths with centralized configuration variables.
* Updated the SSD stress-test workflow.
* Changed debug-log discovery to use the debug-logs\_\*.tgz pattern instead of a year-specific filename pattern.
* Simplified the SSD infinite loop by replacing legacy control variables with while true.



🐛 Fixed

* Fixed readline support for custom debug-log folder input.
* Fixed Bash compatibility by normalizing shell scripts to LF line endings.
* Added clear feedback for failures during deployment, GBB operations, log export, log cleanup, rootfs verification removal, reboot, and power-off.
* Fixed false-success reporting during USB deployment and log export by validating external command results before continuing.
* Fixed SSD stress-test behavior so failed copy or cleanup operations terminate the test instead of allowing invalid cycles to continue.



