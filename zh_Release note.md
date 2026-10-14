**2026/10/14**



**## v1.04 Release note**



**🚀 新增**

* 新增 Custom Script Cycles，可設定四種 PCT 測項的次數，範圍 1～999999999，包含確認、首次 .bak 備份及寫入驗證。
* 新增 Restore All To Default，將四個 PCT 設定全部重設為 1000 次。
* 新增Benchmark menu輸入 SKU 時可按 Q 取消，直接回到子選單。



**🔧 改動**



* 執行Copy Tool to DUT → Deploy Tool to DUT and Run Locally；複製成功後以 exec 啟動本機版本。 
* Benchmark unit命名SKU 改為只輸入 1-1#02，程式自動加上 SKU 前綴。 
* WebXPRT 截圖及 OCR 排程由 1000 → 1030 秒，提示同步讀取設定值。
* WebXPRT CSV 由 Downloads/WebXPRT\_Results 改存 Downloads/Benchmark\_Screenshots。
* Online FHD Video 選項改用支援游標編輯的輸入函式。 
* Check GBB Value → Change GBB Value；實際 GBB 操作未改。 
* LinuxPCT 選單由 7 項變 8 項，後續選項編號順移，配色規則同步調整。 



**🐛 修復**



* 修正無 USB 時，PCT Logs 提示已存 Downloads，實際卻沒有複製的問題。
* 補上輸入欄位的 Home／End 游標控制。 

