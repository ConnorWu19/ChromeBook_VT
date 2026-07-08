ChromeBook\_HP\_Stress\_Toolkit



\# 關於

ChromeBook HP Stress Toolkit 是專為 DQA 工程設計的自動化診斷工具。它整合了 LinuxPCT stress測試、多媒體測試與系統狀態監控選單，藉此簡化驗證流程。



\# 注意事項

受限於保密協議 (NDA) 與授權規範，本專案檔不包含 LinuxPCT 執行檔，若要執行 LinuxPCT 測試，請聯繫 HP TPM 支援團隊或原作者取得所需檔案。



\# 授權聲明

本專案僅供內部驗證與開發使用。搭配本工具使用的第三方軟體，其產權均歸原所有人所有。



\# 主要功能

系統狀態監控： 在驗證週期內即時追蹤系統狀態。

自動化環境設定： 簡化移除 rootfs 驗證與網路配置流程。

LinuxPCT 壓力測試： 整合硬體壓力測試的自動化工作流程。

日誌管理： 自動化擷取log與執行診斷。



\# 開始使用

1. 將此腳本 Clone 至本機端。

2\. (選用) 將所需的 HP LinuxPCT 執行檔放入同一目錄。

3\. 執行主腳本：

&#x20;  ```bash

&#x20;  bash ./ChromeBook\_HP\_Stress\_Toolkit.sh

