**2026/10/14**

**ChromeBook\_Validation\_Toolkit v1.04**



**🚀 Added**

* Added Custom Script Cycles to configure the run count for four PCT tests, from 1 to 999,999,999, with confirmation, a first-time .bak backup, and write verification.
* Added Restore All To Default to reset all four PCT settings to 1,000 cycles.
* Pressing Q while entering a Benchmark SKU cancels the input and returns to the submenu.



**🔧 Changed**

* Renamed Copy Tool to DUT to Deploy Tool to DUT and Run Locally; after copying, the local version starts with exec.
* SKU input now accepts only 1-1#02; the program adds the SKU prefix automatically.
* Changed the WebXPRT screenshot and OCR schedule from 1,000 to 1,030 seconds; the prompt now reflects the configured value.
* Changed the WebXPRT CSV output location from Downloads/WebXPRT\_Results to Downloads/Benchmark\_Screenshots.
* Updated the Online FHD Video option to use an input function that supports cursor editing.
* Renamed Check GBB Value to Change GBB Value; the GBB operation itself is unchanged.
* Expanded the LinuxPCT menu from 7 to 8 items, shifting subsequent option numbers and updating the color rules accordingly.



**🐛 Fixed**

* Fixed an issue where PCT Logs reported that logs were saved to Downloads when no USB drive was connected, even though no files had been copied.
* Added Home and End cursor controls to input fields.

