\*2026/07/14

\*ChromeBook\_Validation\_Toolkit v1.01.sh

###### **Added**

Dual-line System Information Display / 雙行系統資訊顯示

Expanded the main dashboard header to support a multi-line info bar for better readability.

擴充主介面頁首資訊欄為雙行架構，提升數據可讀性。



Real-time GBB Flags Detection / 即時 GBB Flags 偵測

Integrated automatic parsing via futility gbb, displaying the shortened flag value directly on the main UI.

整合 futility gbb 自動解析機制，於主畫面上直接顯示系統目前的 GBB 數值。



USB Vendor Tracking / USB 裝置識別

Added a block device hardware vendor lookup service via /sys/block/ to display the actual brand name of the mounted USB flash drive.

新增透過 /sys/block/ 讀取底層硬體資訊功能，動態識別並顯示掛載隨身碟狀態。



Enhanced Copy Verification / 強化檔案複製防錯機制

Implemented strict checking for the USB mounting status in the deployment routine, preventing empty copy actions if no drive is connected.

於佈署流程加入隨身碟掛載狀態檢查，避免未偵測到裝置時的無效複製行為。



Visual Tab Indicators / 頁籤視覺化標記

Introduced directional pointer tokens to highlight the currently active menu tab.

於作用中的功能頁籤前方加入方向符號，進而增加當前選取狀態識別性。



###### **Changed**

Deployment Workflow / 工具佈署流程調整

Standardized the Copy\_To\_DUT function to clone the entire asset architecture exclusively from the external path.

規範 Copy\_To\_DUT 函式邏輯，限定必須自外部隨身碟路徑複製完整工具包架構。



Menu Boundary Parameters / 選項繪製邊界參數調整

Calibrated the static drawing pointer from line 9 to line 10 to accommodate the newly added system information rows.

將靜態選單繪製起點由第 9 行校準至第 10 行，以適應新增的資訊列並避免畫面錯位。



Interaction Timeout Logic / 互動返回邏輯調整

Modified menu pause triggers by replacing key-length constraints with standard continuous reading parameters.

調整選單執行完畢後的暫停觸發機制，移除特定字元長度限制並改用標準連續讀取參數。



Added HWQA tag in File Copy Test  / 新增HWQA屬性在File Copy Test title



###### **Fixed / 問題修正**

UI Refresh Offsets

Resolved a terminal layout displacement issue where rendering single-row updates would cause text misalignment.

修正資訊欄改為雙行後，執行單行游標移動刷新導致終端機排版錯位的問題。

