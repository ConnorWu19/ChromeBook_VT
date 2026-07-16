#!/bin/bash

# 補上缺失的變數定義
LOCAL_TARGET="/usr/local/ChromeBook_HP_Stress_Toolkit/SSD"

# 確保本地端目錄結構存在
sudo mkdir -p "$LOCAL_TARGET"

if [ $? -eq 0 ]; then
    echo "【Success】Script copy completed！"
    # 確保後續腳本有權限讀寫該資料夾
    sudo chmod -R 777 "$LOCAL_TARGET"
else
    echo "【Error】File copy fail，Please check storage is enough space！"
    exit 1
fi

# =====================================================================
# 2. 自動執行原有的 SSD 壓力測試引擎
# =====================================================================

a=0
b=1
#sudo mount -o remount,rw /

# 核心防錯：驗證剛剛複製過來的原始影片是否存在
if [ ! -f /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd/video.mp4 ]; then
    echo "【Error】File not found in /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd/video.mp4，Please check the file is exist！"
    exit 1
fi

# 清理暫存資料夾 (修正雙斜線問題)
sudo rm -rf /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd1/*
sudo rm -rf /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd2/*

# 複製初始檔案
sudo cp -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd/video.mp4 /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd1/

# 初始化計數器
cycle=1

while [ "$a" != "$b" ]
do
# 輸出目前的 Cycle 數
echo "=== Start Cycle: $cycle ===" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log

sudo cp -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd1/video.mp4 /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd2/
echo "Copy to ssd2 done $(date)" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log

sudo rm -f /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd1/video.mp4
echo "Remove ssd1 done $(date)" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log

sudo cp -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd2/video.mp4 /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd1/
echo "Copy back to ssd1 done $(date)" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log

sudo rm -f /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd2/video.mp4
echo "Remove ssd2 done $(date)" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log

echo "=== End Cycle: $cycle ===" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log
echo "" | tee -a /usr/local/ChromeBook_HP_Stress_Toolkit/SSD/ssd_log

# 計數器自動加 1
cycle=$((cycle+1))

sleep 0.1
done