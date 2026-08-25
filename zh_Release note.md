2026/08/24



\## v1.03 Release Note



🚀 新增

&#x20; - Capture PCT Logs 時，USB 會自動建立 LinuxPCT\_log 資料夾,並儲存至USB/LinuxPCT\_log/Log/FFFFFFFF。

&#x20; - Info Monitor 新增 \[BIOS FW] 欄位，透過 crossystem fwid 顯示機台 BIOS／FW 版號。

&#x20; - Multimedia 新增 Benchmark Test 子選單：

&#x20;     - WebXPRT 4

&#x20;     - Google Octane 2.0

&#x20;     - Speedometer 2.0

&#x20; - 新增 Benchmark 自動截圖與結果處理功能：

&#x20;   各測項開啟後（Google Octane 2.0: 120s / Speedometer 2.0: 120s / WebXPRT 4: 1000s）自動截取 VT1 全螢幕並存至 Downloads/Benchmark\_Screenshots。

&#x20;   支援依 SKU／AC-DC 規則自動命名，並透過 OCR 讀取 WebXPRT 畫面上的 Test ID，再依 Test ID 自動下載測試結果。

&#x20; - 新增 SSD 測試獨立 Log, path: SSD/logs/ssd\_YYYYMMDD\_HHMMSS.log。

&#x20; - Get Generate Logs 選取後新增確認提示：Are you sure you want to run Get Generate logs? \[y/n]；僅輸入 y/Y 才會執行。



🔧 改動



&#x20; - File Copy Test 的 SSD 路徑改為依實際執行中的 ssd.sh 所在目錄判斷。

&#x20; - Capture PCT Logs 成功提示字更新

&#x20; - Debug log 搜尋範圍調整為僅搜尋 /tmp。

&#x20; - File Copy Test 選單提示文字優化。

&#x20; - Benchmark 測試網址集中由 config.sh 管理。

&#x20; - Benchmark 網址開啟後會停留，按 Enter 才返回 Benchmark 子選單。

&#x20; - Benchmark 子測項按下 Enter 返回選單前，增加 0.4 秒緩衝。

&#x20; - Benchmark 網址成功開啟後依序顯示：

&#x20;     - \[+] Execution Completed.

&#x20;     - \[SUCCESS] URL Opened Successfully.

&#x20;     - \[WARN] Please manually switch to VT1 by pressing CTRL+ALT+F1

&#x20; - Info Monitor 欄位間距依實際內容動態調整。

&#x20; - Check GBB Value、File Copy Test、Get Generate Logs 支援游標編輯輸入。

&#x20; - 四處目錄權限由 chmod -R 777 改為 chmod -R 755。

&#x20; - File Copy Test 異常結束時，提示改為指向最新的 SSD 時間戳 log，而非 /tmp/CBVT\_stress.log。

&#x20; - 移除舊的根目錄 ssd.sh，統一使用 SSD/ssd.sh。

&#x20; - 移除舊版 SSD/ssd\_log 測試紀錄。



🐛 修復



&#x20; - 修正未插入 USB 時，Copy Tool to DUT / Copy Script to DUT 不再因 USB 不存在而直接失敗，會略過複製動作並繼續執行的問題。

&#x20; - 修正 File Copy Test 可能使用舊版 ChromeBook\_HP\_Stress\_Toolkit 路徑、並建立空資料夾的問題。

&#x20; - 修正 Benchmark URL 開啟成功提示與 VT1 切換提醒重複顯示問題。

&#x20; - Capture PCT Logs 會先確認來源 Log/FFFFFFFF 存在，避免匯出不完整或空的 PCT log。

&#x20; - File Copy Test 的 Remove Rootfs Verification 成功送出 reboot 後，不再出現「Press Enter to return to main menu」。

&#x20; - SSD log 目錄會在 ssd.sh 開始執行時自動建立，避免找不到 SSD/logs。

&#x20; - 修正自訂輸入時，使用左右方向鍵、Backspace、Caps Lock，以及移動游標至字串開頭／結尾時可能產生亂碼或 ? 的問題。

