\*2026/07/14

\*ChromeBook\_Validation\_Toolkit v1.01.sh

🚀Added

Dual-line System Information Display : Expanded the main dashboard header to support a multi-line info bar for better readability.

Real-time GBB Flags Detection : Integrated automatic parsing via futility gbb.

USB detect : Added a device hardware vendor lookup service via /sys/block/ to display the mounted USB flash drive.

Visual Tab Indicators : Introduced directional pointer tokens to highlight the currently active menu tab.

🔧Changed

Deployment Workflow : Standardized the Copy\_To\_DUT function to clone the entire tool from the external path.

Interaction Timeout Logic : Modified menu pause triggers by replacing key-length constraints with standard continuous reading parameters.

Enhanced Copy Verification : Implemented strict checking for the USB mounting status in the deployment routine, preventing empty copy actions if no drive is connected.

Added HWQA tag in File Copy Test.

🐛Fixed

UI Refresh Offsets: Fixed a layout displacement issue where rendering single-row updates would cause text misalignment.

Menu Boundary Parameters: Shifted the menu drawing area down by one line to fit the new system info rows.

