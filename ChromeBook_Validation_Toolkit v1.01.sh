#!/bin/bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
CYBER_BLUE='\033[38;5;51m'
BOLD='\033[1m'
INVERSE='\033[7m'
NC='\033[0m'

LOG_FILE="/tmp/CBVT_stress.log"
echo "=== ChromeBook Validation Toolkit Session: $(date) ===" > "$LOG_FILE"

declare -g UI_PRIMARY
declare -g UI_SEL

LAST_SYSINFO_CHECK=0
CACHED_SYSINFO=""
CURRENT_TAB=0
SELECTED=0
NUM_OPTS=0
FORCE_REDRAW=1
THEME_INDEX=0
SCALE_MODE=0
UI_V_PAD=0
UI_LEFT_PAD=""

function apply_theme() {
    case $THEME_INDEX in
        0) UI_PRIMARY='\033[1;36m'; UI_SEL='\033[1;37m' ;;
        1) UI_PRIMARY='\033[1;34m'; UI_SEL='\033[1;37m' ;;
        2) UI_PRIMARY='\033[38;5;208m'; UI_SEL='\033[1;37m' ;;
    esac
}
apply_theme

function apply_scale() {
    case $SCALE_MODE in
        0) UI_V_PAD=0; UI_LEFT_PAD="" ;;
        1) UI_V_PAD=1; UI_LEFT_PAD="     " ;;
    esac
}
apply_scale

trap 'echo -e "\n${RED}[!] Process interrupted. Exiting...${NC}"; stty echo; tput cnorm; exit 1' SIGINT
trap 'FORCE_REDRAW=1' WINCH

tput civis
stty -echo
clear

function startup_fade_in() {
    clear
    local fade_colors=(23 29 30 36 43 50 51)
    
    for c in "${fade_colors[@]}"; do
        echo -ne "\033[H\033[38;5;${c}m${BOLD}"
        echo "╔══════════════════════════════════════════════════════╗"
        echo "║          ChromeBook Validation Toolkit v1.01         ║"
        echo "║               Created by DQA Connor_Wu               ║"
        echo "╚══════════════════════════════════════════════════════╝"
        echo -ne "${NC}"
        sleep 0.06
    done

    sleep 0.5
    echo ""
    
    local spinners=("-" "\\" "|" "/")
    for ((i=0; i<=20; i++)); do
        local percent=$(( i * 5 ))
        local spinner="${spinners[$((i % 4))]}"
        
        if [[ $i -eq 20 ]]; then
            echo -e "\033[K    [${GREEN}OK${NC}]"
        else
            echo -e "\033[K    [${spinner}]"
        fi
        
        echo -ne "\033[K    System initializing... ${percent}%\033[1A\r"
        sleep 0.05
    done
    
    echo -e "\n\033[K    ${GREEN}System Ready${NC}                                      \n"
    sleep 0.5
    clear
}

startup_fade_in

log_info() { echo -e "${CYAN}[$(date +'%H:%M:%S')] [INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[$(date +'%H:%M:%S')] [SUCCESS]${NC} $1" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}[$(date +'%H:%M:%S')] [WARN]${NC} $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[$(date +'%H:%M:%S')] [ERROR]${NC} $1" | tee -a "$LOG_FILE"; }

function draw_progress_bar() {
    local duration=$1
    local prefix=$2
    local step_count=${3:-40}
    local sleep_time=$(awk "BEGIN {print $duration/$step_count}" 2>/dev/null)
    [[ -z "$sleep_time" || "$sleep_time" == "0" ]] && sleep_time=0.05
    
    local spinners=("-" "\\" "|" "/")
    
    for ((i=1; i<=step_count; i++)); do
        local percent=$(( i * 100 / step_count ))
        local spinner="${spinners[$((i % 4))]}"
        
        printf "\r\033[K[*] %-20s [%s] %3d%%" "$prefix" "$spinner" "$percent"
        sleep "$sleep_time" 2>/dev/null || sleep 0.05
    done
    printf "\r\033[K[*] %-20s [${GREEN}OK${NC}] 100%%\n" "$prefix"
}

function print_executing() {
    local task_name=$1
    local duration=${2:-0.4}
    echo "[$(date +'%H:%M:%S')] [EXEC] $task_name" >> "$LOG_FILE"
    draw_progress_bar "$duration" "$task_name"
    echo -e "${GREEN}[+] Execution Completed.${NC}"
}

function open_url() {
    sudo -u chronos dbus-send --system --type=method_call \
      --dest=org.chromium.UrlHandlerService \
      /org/chromium/UrlHandlerService \
      org.chromium.UrlHandlerServiceInterface.OpenUrl \
      string:"$1" > /dev/null 2>&1
    
    log_success "URL Opened Successfully."
    log_warn "Please manually switch to VT1 by pressing CTRL+ALT+F1"
}

function update_sysinfo() {
    local current_time=$(date +%s)
    
    if (( current_time - LAST_SYSINFO_CHECK >= 5 )); then
        local net_type="No internet"
        local net_color="${RED}"
        
        local active_if=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' | head -n 1)
        if [[ -z "$active_if" ]]; then
            active_if=$(ip -o -4 addr show | awk '{print $2}' | grep -Ev '^lo$|^arc|^veth' | head -n 1)
        fi
        
        if [[ -n "$active_if" ]]; then
            net_color="${GREEN}"
            case "$active_if" in
                eth*|en*|usb*) net_type="Ethernet" ;;
                wlan*|wl*|mlan*) net_type="Wi-Fi" ;;
                wwan*|mbimmux*|cdc-wdm*|rmnet*) 
                    local provider=""
                    if command -v mmcli &> /dev/null; then provider=$(mmcli -m 0 2>/dev/null | awk -F ': ' '/operator name/ {print $2}' | tr -d "'" | xargs); fi
                    if [[ -z "$provider" ]]; then provider=$(connectivity show services 2>/dev/null | grep -A 8 -i "cellular" | grep -i "Name:" | head -n 1 | cut -d':' -f2 | xargs | tr -d '"'); fi
                    if [[ -z "$provider" ]]; then provider=$(modem status 2>/dev/null | awk -F': ' '/network-name/ {print $2}' | xargs); fi
                    if [[ -n "$provider" ]]; then net_type="Cellular ($provider)"; else net_type="Cellular"; fi
                    ;;
                *) net_type="$active_if" ;;
            esac
        fi

        local pwr_info="Unknown"
        local ac_mode=0
        local bat_pct=""
        if command -v dump_power_status &> /dev/null; then
            bat_pct=$(dump_power_status | awk '/battery_display_percent/ {print int($2)}')
            if [[ "$(dump_power_status | awk '/line_power_connected/ {print $2}')" == "1" ]]; then ac_mode=1; else ac_mode=0; fi
        fi

        if [[ $ac_mode -eq 1 ]]; then pwr_info="${GREEN}AC mode${NC}"; else pwr_info="${GREEN}DC mode (${bat_pct}%)${NC}"; fi
        
        local os_info="Unknown"
        local os_txt_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/OS.txt"

        if [[ -f /etc/lsb-release ]]; then
            local full_ver=$(grep "CHROMEOS_RELEASE_VERSION" /etc/lsb-release | cut -d'=' -f2 | xargs)
            
            if [[ -f "$os_txt_path" ]] && grep -q "${full_ver}" "$os_txt_path"; then
                local mapped_rev=$(grep "${full_ver}" "$os_txt_path" | awk -F'=' '{print $2}' | xargs)
                os_info="${full_ver} (${mapped_rev})"
            else
                os_info="${full_ver}"
            fi
        fi

        local gbb_val="Unknown"
        if command -v futility &> /dev/null; then
            local raw_gbb=$(sudo futility gbb -g --flash --flags 2>/dev/null | grep "flags:" | awk '{print $2}')
            if [[ -n "$raw_gbb" ]]; then
                gbb_val=$(echo "$raw_gbb" | sed 's/0x0*/0x/')
                [[ "$gbb_val" == "0x" ]] && gbb_val="0x00"
            fi
        fi

        local usb_brand="None"
        local usb_name=$(ls /media/removable/ 2>/dev/null | head -n 1)
        if [[ -n "$usb_name" ]]; then
            local dev_node=$(df /media/removable/"$usb_name" 2>/dev/null | awk 'NR==2 {print $1}')
            if [[ "$dev_node" == /dev/sd* ]]; then
                local base_dev=$(basename "$dev_node" | sed 's/[0-9]*//g')
                usb_brand=$(cat "/sys/block/$base_dev/device/vendor" 2>/dev/null | xargs)
            fi
            [[ -z "$usb_brand" ]] && usb_brand="$usb_name"
        fi
        
        local line1="\033[K${UI_LEFT_PAD}${CYAN}  [Net] ${net_color}${net_type}${NC}  ${CYAN}[Power] ${NC}${pwr_info}  ${CYAN}[OS] ${GREEN}${os_info}${NC}"
        local line2="\033[K${UI_LEFT_PAD}${CYAN}  [GBB] ${GREEN}${gbb_val}${NC}  ${CYAN} [USB] ${GREEN}${usb_brand}${NC}"
        local new_sysinfo="${line1}\n${line2}"
        
        if [[ "$new_sysinfo" != "$CACHED_SYSINFO" ]]; then
            CACHED_SYSINFO="$new_sysinfo"
            FORCE_REDRAW=1
        fi
        LAST_SYSINFO_CHECK=$current_time
    fi
}

function countdown_reboot() {
    draw_progress_bar 0.5 "Rebooting System" 10
    for i in {5..1}; do
        printf "\r\033[KSystem will reboot in %d secs..." "$i"
        sleep 0.5
    done
    echo ""
    tput cnorm
    sudo reboot
}

function countdown_poweroff() {
    draw_progress_bar 0.5 "Powering Off System" 10
    for i in {5..1}; do
        printf "\r\033[KSystem will power off in %d secs..." "$i"
        sleep 0.5
    done
    echo ""
    tput cnorm
    sudo poweroff
}

function Copy_To_DUT() {
    print_executing "Copy Tool to DUT" 1.0
    
    local USB_NAME=$(ls /media/removable/ 2>/dev/null | head -n 1)
    if [[ -z "$USB_NAME" ]]; then
        log_error "No flash drive detected. Please confirm that the device is mounted."
        return 1
    fi
    
    log_info "USB flash drive detected: ${USB_NAME}"
    local USB_TOOL_DIR="/media/removable/${USB_NAME}/ChromeBook_VT_v1.01"
    local TARGET_DIR="/usr/local/ChromeBook_VT_v1.01"
    
    if [[ -d "$USB_TOOL_DIR" ]]; then
        log_info "Copying files to /usr/local/ (This may take a while...)"
        
        sudo rm -rf "$TARGET_DIR" 2>/dev/null
        sudo cp -r "$USB_TOOL_DIR" /usr/local/
        
        if [[ $? -eq 0 ]]; then
            sudo chmod -R 777 "$TARGET_DIR" 2>/dev/null
            log_success "The Toolkit has been successfully copied to /usr/local/"
        else
            log_error "Copy failed. Please check /usr/local storage space or permissions."
        fi
    else
        log_error "The Toolkit folder cannot be found on the USB drive. Please check the path."
    fi
}

function Check_GBB_Value() {
    echo "[$(date +'%H:%M:%S')] [EXEC] Check GBB Value" >> "$LOG_FILE"
    draw_progress_bar 0.5 "Reading GBB Flags" 10
    echo ""
    log_info "Current GBB Flags:"
    sudo futility gbb -g --flash --flags
    
    echo -e "\n${YELLOW}Do you want to change the GBB value?${NC}"
    echo "  1) Change GBB value to 0x39 (For LinuxPCT use)"
    echo "  2) Change GBB value to 0x0"
    echo "  3) Cancel"
    
    while true; do
        echo -ne "Select an option [1/2/3] and press Enter: "
        read -r k
        case "$k" in
            1)
                sudo futility gbb -s --flash --flags 0x39
                log_success "GBB value updated to 0x39"
                break ;;
            2)
                sudo futility gbb -s --flash --flags 0x0
                log_success "GBB value updated to 0x0"
                break ;;
            3|q|Q)
                log_info "Canceled"
                break ;;
            *)
                echo -e "${RED}Invalid option, please try again.${NC}"
                ;;
        esac
    done
}

function Online_FHD_Video_Test() {
    echo "[$(date +'%H:%M:%S')] [EXEC] Online FHD Video" >> "$LOG_FILE"
    
    echo -e "\n${YELLOW}Select an Online Video Test Sample:${NC}"
    echo "  1) Online video test sample [1]"
    echo "  2) Online video test sample [2]"
    echo "  3) Online video test sample [3]"
    echo "  4) Cancel"
    
    while true; do
        echo -ne "Select an option [1/2/3/4] and press Enter: "
        read -r vid_opt
        case "$vid_opt" in
            1)
                print_executing "Online FHD Video Sample 1" 0.4
                open_url "https://www.youtube.com/watch?v=RHUauMcYlX0"
                break ;;
            2)
                print_executing "Online FHD Video Sample 2" 0.4
                open_url "https://www.youtube.com/watch?v=rEKifG2XUZg"
                break ;;
            3)
                print_executing "Online FHD Video Sample 3" 0.4
                open_url "https://www.youtube.com/watch?v=uZkaJ3e9nfY"
                break ;;
            4|q|Q)
                log_info "Canceled"
                break ;;
            *)
                echo -e "${RED}Invalid option, please try again.${NC}"
                ;;
        esac
    done
}

function HTML5_Video_Test() { print_executing "HTML5 Video Test" 0.4; open_url "https://legacy.videojs.org/city"; }
function WebGL_Test() { print_executing "WebGL Test" 0.4; open_url "https://webglsamples.org/aquarium/aquarium.html"; }
function Webcam_Nic_Wlan_Test() { print_executing "Webcam_Nic_or_Wlan" 0.4; open_url "https://webcamtests.com/"; }

function File_Copy_Test_Menu() {
    stty echo
    tput cnorm

    echo "[$(date +'%H:%M:%S')] [EXEC] File Copy Test Menu" >> "$LOG_FILE"
    
    while true; do
        clear
        echo -e "\n${CYAN}=======================================================${NC}"
        echo -e "${YELLOW}💡 Run [1] => [2] before start file copy test${NC}"
        echo -e "${CYAN}=======================================================${NC}"
        echo "  1. Remove Rootfs_Verification"
        echo "  2. Copy Script to DUT"
        echo "  3. Run File Copy Test"
        echo "  4. Cancel"
        echo -e "${CYAN}=======================================================${NC}"
        echo -ne "Select an option [1/2/3/4] and press Enter: "
        
        read -r copy_opt

        case "$copy_opt" in
            1)
                echo ""
                print_executing "Forced Remove Rootfs Verification" 1.0
                sudo /usr/share/vboot/bin/make_dev_ssd.sh --force --remove_rootfs_verification
                log_warn "Verification removed. System must reboot now."
                countdown_reboot
                break ;;
            2)
                echo ""
                Copy_To_DUT
                echo -ne "\n${MAGENTA}Press [Enter] to return to menu...${NC}"
                read -r wait_key
                ;;
            3)
                echo ""
                Run_Internal_SSD_Stress
                break ;;
            4|q|Q)
                echo ""
                log_info "File Copy Test Canceled."
                break ;;
            *)
                echo -e "\n${RED}Invalid option, please try again.${NC}"
                sleep 1
                ;;
        esac
    done

    tput civis
    stty -echo
}

function Run_Internal_SSD_Stress() {
    print_executing "Initializing File Copy Test" 0.5
    
    if [[ -f /usr/local/ChromeBook_VT_v1.01/SSD/ssd.sh ]]; then
        sudo chmod +x /usr/local/ChromeBook_VT_v1.01/SSD/ssd.sh
        sudo /usr/local/ChromeBook_VT_v1.01/SSD/ssd.sh
    else
        log_error "Not found the /usr/local/ChromeBook_VT_v1.01/SSD/ssd.sh. Please execute the option2 first:[2. Copy Script to DUT]。"
    fi
}

function Run_LinuxPCT_Stress() {
    local ini_file=$1
    local task_name=$2
    print_executing "$task_name" 1.0
    log_info "Starting $task_name..."
    local target_dir="/usr/local/ChromeBook_VT_v1.01"
    
    if [[ -d "$target_dir" ]]; then
        cd "$target_dir" || return
        sudo chmod +x LinuxPCT.sh 2>/dev/null
        sudo ./LinuxPCT.sh -ini="$ini_file"
        log_success "$task_name execution finished."
    else
        log_error "LinuxPCT Tool not found in /usr/local."
    fi
}

function Capture_PCT_Logs() {
    print_executing "Capture PCT Logs" 1.0
    log_info "Copying logs to USB disk..."
    
    local log_dir="/usr/local/ChromeBook_VT_v1.01/Log"
    if [[ -d "$log_dir" ]]; then
        local usb_name=$(ls /media/removable/ 2>/dev/null | head -n 1)
        if [[ -n "$usb_name" ]]; then
            sudo cp -a -p --no-preserve=ownership "$log_dir" /media/removable/"$usb_name"/ 2>/dev/null
            log_success "Logs successfully copied to USB disk (${usb_name})."
        else
            log_warn "USB disk not found in /media/removable/, logs only copied to Downloads."
        fi
    else
        log_error "Log directory not found: $log_dir"
    fi
}

function Get_Generate_Logs() {
    echo "[$(date +'%H:%M:%S')] [EXEC] Get Generate Logs" >> "$LOG_FILE"
    log_info "Generating system logs (this may take a while)..."
    
    local start_time=$(date +%s)
    sudo generate_logs > /dev/null 2>&1 &
    local pid=$!
    
    local prefix="Get Generate Logs"
    local percent=0
    local spinners=("-" "\\" "|" "/")
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        if (( percent < 99 )); then ((percent += 1)); fi
        local spinner="${spinners[$((i % 4))]}"
        printf "\r\033[K[*] %-20s [%s] %3d%%" "$prefix" "$spinner" "$percent"
        ((i++))
        sleep 0.5
    done
    
    printf "\r\033[K[*] %-20s [${GREEN}OK${NC}] 100%%\n" "$prefix"
    sleep 2
    
    local latest_log=$(sudo find /var/log /tmp /home/chronos/user/Downloads -name "debug-logs_2026*.tgz" -type f -newermt "@$start_time" 2>/dev/null | head -n 1)
    
    if [[ -n "$latest_log" ]]; then
        sudo cp "$latest_log" /usr/local/ 2>/dev/null
        
        echo ""
        echo -ne "${YELLOW}Enter custom folder name to save log file: ${NC}"
        read -r custom_folder
        
        if [[ -z "$custom_folder" ]]; then
            custom_folder="Debug_Log_$(date +%Y%m%d_%H%M%S)"
            log_warn "No name entered. Using default folder name: $custom_folder"
        fi
        
        local dl_target_dir="/home/chronos/user/Downloads/$custom_folder"
        sudo mkdir -p "$dl_target_dir" 2>/dev/null
        sudo cp -a -p --no-preserve=ownership "$latest_log" "$dl_target_dir/" 2>/dev/null
        sudo chmod -R 777 "$dl_target_dir" 2>/dev/null
        log_success "Logs saved to Downloads: $custom_folder/$(basename "$latest_log")"
        
        local usb_name=$(ls /media/removable/ 2>/dev/null | head -n 1)
        if [[ -n "$usb_name" ]]; then
            local usb_target_dir="/media/removable/$usb_name/$custom_folder"
            sudo mkdir -p "$usb_target_dir" 2>/dev/null
            sudo cp -a -p --no-preserve=ownership "$latest_log" "$usb_target_dir/" 2>/dev/null
            sudo chmod -R 777 "$usb_target_dir" 2>/dev/null
            log_success "Logs successfully copied to USB disk [${usb_name}]: $custom_folder/"
        else
            log_warn "USB disk not found in /media/removable/. Skipped USB backup."
        fi
    else
        log_error "Newly generated log file not found."
    fi
    echo -e "${GREEN}[+] Execution Completed.${NC}"
}

function Clean_Logs_And_Reboot() {
    print_executing "Clean Logs" 1.0
    log_warn "Cleaning system logs..."
    sudo rm -rf /var/log/ /var/log/spool/
    sudo chromeos-cleanup-logs > /dev/null 2>&1
    log_success "Logs cleaned successfully."
    countdown_reboot
}

function Remove_Verification_Unit_will_reboot() {
    print_executing "Remove Verification" 1.0
    sudo /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification --partitions 2 
    sudo /usr/share/vboot/bin/make_dev_ssd.sh --force --remove_rootfs_verification 
    log_warn "Verification removed."
    echo -e "${YELLOW}The system will restart in a few seconds${NC}"
    sleep 0.5
    countdown_reboot
}

function build_menu() {
    MENU_TEXT=(); MENU_CMD=()
    case $CURRENT_TAB in
        0)
            MENU_TEXT+=("    1) Copy Tool to DUT"); MENU_CMD+=("CMD_COPY_DUT")
            MENU_TEXT+=("    2) Get Generate Logs"); MENU_CMD+=("CMD_LOGS")
            MENU_TEXT+=("    3) Clean Logs (Unit will reboot)"); MENU_CMD+=("CMD_CLEAN")
            MENU_TEXT+=("    4) Check GBB Value"); MENU_CMD+=("CMD_CHECK_GBB")
            MENU_TEXT+=("    5) Reboot System"); MENU_CMD+=("CMD_REBOOT")
            MENU_TEXT+=("    6) Power Off System"); MENU_CMD+=("CMD_POWEROFF")
            MENU_TEXT+=("    7) Exit"); MENU_CMD+=("CMD_EXIT")
            ;;
        1)
            MENU_TEXT+=("    1) Online FHD Video Test"); MENU_CMD+=("CMD_FHD")
            MENU_TEXT+=("    2) HTML5 Video Test"); MENU_CMD+=("CMD_HTML5")
            MENU_TEXT+=("    3) WebGL Test"); MENU_CMD+=("CMD_WEBGL")
            MENU_TEXT+=("    4) Webcam w/ NIC or WLAN Test (Cover AC/DC Mode)"); MENU_CMD+=("CMD_WEBCAM")
            MENU_TEXT+=("    5) File Copy Test [HWQA]"); MENU_CMD+=("CMD_FILE_COPY_TEST")
            MENU_TEXT+=("    6) Exit"); MENU_CMD+=("CMD_EXIT")
            ;;
        2)
            MENU_TEXT+=("    1) S3 Stress (1000 cycles)"); MENU_CMD+=("CMD_PCT_S3")
            MENU_TEXT+=("    2) Restart Stress (1000 cycles)"); MENU_CMD+=("CMD_PCT_RESTART")
            MENU_TEXT+=("    3) S5_Chrome Stress (1000 cycles)"); MENU_CMD+=("CMD_PCT_S5")
            MENU_TEXT+=("    4) S3 + S5_Chrome + Restart Stress (1000 cycles)"); MENU_CMD+=("CMD_PCT_MULTI")
            MENU_TEXT+=("    5) Capture Logs to USB Disk"); MENU_CMD+=("CMD_PCT_LOGS")
            MENU_TEXT+=("    6) (Excute me before run PCT) Remove Verification"); MENU_CMD+=("CMD_RM_VERIFY")
            MENU_TEXT+=("    7) Exit"); MENU_CMD+=("CMD_EXIT")
            ;;
    esac
    
    NUM_OPTS=${#MENU_TEXT[@]}
    if [[ $SELECTED -ge $NUM_OPTS ]]; then SELECTED=$((NUM_OPTS - 1)); fi
}

function get_opt_color() {
    if [[ "$1" == *"Exit"* ]]; then echo -n "${RED}"
    elif [[ "$1" == *"Copy Tool to DUT"* || "$1" == *"Copy Tool To DUT"* || "$1" == *"Get Generate Logs"* || "$1" == *"Reboot System"* || "$1" == *"Power Off System"* || "$1" == *"Clean Logs"* || "$1" == *"Check GBB Value"* ]]; then echo -n "${YELLOW}"
    elif [[ "$1" == *"Stress"* || "$1" == *"Remove Verification"* || "$1" == *"Capture Logs"* ]]; then echo -n "${MAGENTA}"
    else echo -n "${GREEN}"; fi
}

function draw_full_menu() {
    build_menu
    local out="\033[H"
    
    local top_border bot_border divider title1 title2 tab_str footer
    
    local t0="General"
    local t1="Multimedia Test"
    local t2="LinuxPCT"

    [[ $CURRENT_TAB -eq 0 ]] && t0="${UI_SEL}▶ General${NC}" || t0="${UI_PRIMARY}General${NC}"
    [[ $CURRENT_TAB -eq 1 ]] && t1="${UI_SEL}▶ Multimedia Test${NC}" || t1="${UI_PRIMARY}Multimedia Test${NC}"
    [[ $CURRENT_TAB -eq 2 ]] && t2="${UI_SEL}▶ LinuxPCT${NC}" || t2="${UI_PRIMARY}LinuxPCT${NC}"

    if [[ $SCALE_MODE -eq 0 ]]; then
        top_border="╔══════════════════════════════════════════════════════╗"
        bot_border="╚══════════════════════════════════════════════════════╝"
        divider="────────────────────────────────────────────────────────"
        title1="║          ChromeBook Validation Toolkit v1.01         ║"
        title2="║               Created by DQA Connor_Wu               ║"
        tab_str="   ${t0}      ${t1}      ${t2}"
        footer="  ↑/↓,←/→:Navigate │ Enter:Select │ T:Theme │ D:Scale"
    elif [[ $SCALE_MODE -eq 1 ]]; then
        top_border="     ╔════════════════════════════════════════════════════════════════╗"
        bot_border="     ╚════════════════════════════════════════════════════════════════╝"
        divider="     ──────────────────────────────────────────────────────────────────"
        title1="     ║               ChromeBook Validation Toolkit v1.01              ║"
        title2="     ║                    Created by DQA Connor_Wu                    ║"
        tab_str="        ${t0}          ${t1}          ${t2}"
        footer="       ↑/↓,←/→:Navigate  │  Enter:Select  │  T:Theme  │  D:Scale       "
    fi

    out+="\033[K${UI_PRIMARY}${BOLD}${top_border}${NC}\n"
    out+="\033[K${UI_PRIMARY}${BOLD}${title1}${NC}\n"
    out+="\033[K${UI_PRIMARY}${BOLD}${title2}${NC}\n"
    out+="\033[K${UI_PRIMARY}${BOLD}${bot_border}${NC}\n"
    out+="${CACHED_SYSINFO}\n"
    out+="\033[K${UI_PRIMARY}${divider}${NC}\n"
    out+="\033[K${UI_LEFT_PAD}${tab_str}\n"
    out+="\033[K${UI_PRIMARY}${divider}${NC}\n"
    
    for i in "${!MENU_TEXT[@]}"; do
        local color=$(get_opt_color "${MENU_TEXT[$i]}")
        if [[ $i -eq $SELECTED ]]; then out+="\033[K${UI_LEFT_PAD}  ${UI_SEL} > ${MENU_TEXT[$i]} ${NC}\n"; else out+="\033[K${UI_LEFT_PAD}     ${color}${MENU_TEXT[$i]}${NC}\n"; fi
        for ((v=0; v<UI_V_PAD; v++)); do out+="\033[K\n"; done
    done
    
    for ((i=NUM_OPTS; i<7; i++)); do 
        out+="\033[K\n"
        for ((v=0; v<UI_V_PAD; v++)); do out+="\033[K\n"; done
    done
    
    out+="\033[K${UI_PRIMARY}${divider}${NC}\n"
    out+="\033[K${UI_PRIMARY}${footer}${NC}\n"
    out+="\033[J" 
    printf "%b" "$out"
}

function draw_selection_only() {
    local old_idx=$1; local new_idx=$2
    local start_line=10
    local old_line=$(( start_line + old_idx * (UI_V_PAD + 1) ))
    local new_line=$(( start_line + new_idx * (UI_V_PAD + 1) ))
    
    printf "\033[%d;1H\033[K${UI_LEFT_PAD}     $(get_opt_color "${MENU_TEXT[$old_idx]}")%s${NC}" "$old_line" "${MENU_TEXT[$old_idx]}"
    printf "\033[%d;1H\033[K${UI_LEFT_PAD}  ${UI_SEL} > %s ${NC}" "$new_line" "${MENU_TEXT[$new_idx]}"
    printf "\033[25;1H"
}

while true; do
    update_sysinfo
    if [[ $FORCE_REDRAW -eq 1 ]]; then draw_full_menu; FORCE_REDRAW=0; fi
    if read -t 1 -rsn1 key; then
        case "$key" in
            't'|'T') 
                THEME_INDEX=$(( (THEME_INDEX + 1) % 3 ))
                apply_theme
                FORCE_REDRAW=1
                read -t 0.1 -rsn5
                ;;
            'd'|'D')
                SCALE_MODE=$(( (SCALE_MODE + 1) % 2 ))
                apply_scale
                LAST_SYSINFO_CHECK=0
                FORCE_REDRAW=1
                read -t 0.1 -rsn5
                ;;
            $'\e')
                read -t 0.1 -rsn2 key2
                case "$key2" in
                    '[A') OLD_SELECTED=$SELECTED; ((SELECTED--)); [[ $SELECTED -lt 0 ]] && SELECTED=$((NUM_OPTS - 1)); draw_selection_only $OLD_SELECTED $SELECTED ;;
                    '[B') OLD_SELECTED=$SELECTED; ((SELECTED++)); [[ $SELECTED -ge $NUM_OPTS ]] && SELECTED=0; draw_selection_only $OLD_SELECTED $SELECTED ;;
                    '[C') CURRENT_TAB=$(( (CURRENT_TAB + 1) % 3 )); SELECTED=0; FORCE_REDRAW=1 ;;
                    '[D') CURRENT_TAB=$(( (CURRENT_TAB - 1 + 3) % 3 )); SELECTED=0; FORCE_REDRAW=1 ;;
                esac ;;
            "")
                cmd="${MENU_CMD[$SELECTED]}"
                stty echo; tput cnorm; clear; PAUSE=0
                case "$cmd" in
                    CMD_COPY_DUT) Copy_To_DUT ; PAUSE=1 ;;
                    CMD_FHD) Online_FHD_Video_Test ; PAUSE=1 ;;
                    CMD_HTML5) HTML5_Video_Test ; PAUSE=1 ;;
                    CMD_WEBGL) WebGL_Test ; PAUSE=1 ;;
                    CMD_WEBCAM) Webcam_Nic_Wlan_Test ; PAUSE=1 ;;
                    CMD_FILE_COPY_TEST) File_Copy_Test_Menu ; PAUSE=1 ;;
                    CMD_PCT_S3) Run_LinuxPCT_Stress "s3.ini" "S3 Stress (1000 cycles)" ; PAUSE=1 ;;
                    CMD_PCT_RESTART) Run_LinuxPCT_Stress "restart.ini" "Restart Stress (1000 cycles)" ; PAUSE=1 ;;
                    CMD_PCT_S5) Run_LinuxPCT_Stress "s5_chrome.ini" "S5 Chrome Stress (1000 cycles)" ; PAUSE=1 ;;
                    CMD_PCT_MULTI) Run_LinuxPCT_Stress "multitest.ini" "S3 + S5_Chrome + Restart Stress" ; PAUSE=1 ;;
                    CMD_PCT_LOGS) Capture_PCT_Logs ; PAUSE=1 ;;
                    CMD_RM_VERIFY) Remove_Verification_Unit_will_reboot ;;
                    CMD_LOGS) Get_Generate_Logs ; PAUSE=1 ;;
                    CMD_CLEAN) Clean_Logs_And_Reboot ;;
                    CMD_CHECK_GBB) Check_GBB_Value ; PAUSE=1 ;;
                    CMD_REBOOT) countdown_reboot ;;
                    CMD_POWEROFF) countdown_poweroff ;;
                    CMD_EXIT) log_info "Exiting ChromeBook Validation Toolkit~Goodbye!"; exit 0 ;;
                esac
                if [[ $PAUSE -eq 1 ]]; then echo -ne "${MAGENTA}Press [Enter] to return to main menu...${NC}"; read -r wait_key; fi
                tput civis; stty -echo; FORCE_REDRAW=1 ;;
        esac
    fi
done