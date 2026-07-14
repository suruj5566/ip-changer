#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  SURUJ IP CHANGER PRO v5.0 - FULL CONTROL
# ============================================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m'

# ============================================================
#  CONFIG FILE
# ============================================================
CONFIG_FILE="$HOME/.ip_changer_config.json"

# ============================================================
#  DEFAULT VALUES
# ============================================================
DEFAULT_INTERVAL=30
DEFAULT_COUNTRY="random"
DEFAULT_AUTO_START="false"
DEFAULT_BG_MODE="false"

# ============================================================
#  LOAD CONFIG
# ============================================================
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        INTERVAL=$(jq -r '.interval' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_INTERVAL")
        COUNTRY=$(jq -r '.country' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_COUNTRY")
        AUTO_START=$(jq -r '.auto_start' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_AUTO_START")
        BG_MODE=$(jq -r '.bg_mode' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_BG_MODE")
    else
        INTERVAL=$DEFAULT_INTERVAL
        COUNTRY=$DEFAULT_COUNTRY
        AUTO_START=$DEFAULT_AUTO_START
        BG_MODE=$DEFAULT_BG_MODE
    fi
}

# ============================================================
#  SAVE CONFIG
# ============================================================
save_config() {
    echo "{\"interval\": $INTERVAL, \"country\": \"$COUNTRY\", \"auto_start\": $AUTO_START, \"bg_mode\": $BG_MODE}" > "$CONFIG_FILE"
}

# ============================================================
#  FUNCTIONS
# ============================================================
get_current_ip() {
    curl -s --socks5-hostname 127.0.0.1:9050 https://api.ipify.org 2>/dev/null
}

change_ip() {
    echo -e "${YELLOW}🔄 Changing IP...${NC}"
    echo -e "AUTHENTICATE\r\nSIGNAL NEWNYM\r\nQUIT\r\n" | nc -w 2 127.0.0.1 9051 >/dev/null 2>&1
    sleep 2
    NEW_IP=$(get_current_ip)
    if [ -n "$NEW_IP" ]; then
        echo -e "${GREEN}✅ New IP: $NEW_IP${NC}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $NEW_IP" >> ~/.ip_history
        return 0
    else
        echo -e "${RED}❌ Failed to get new IP!${NC}"
        return 1
    fi
}

# ============================================================
#  SHOW BANNER
# ============================================================
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo '    ╔══════════════════════════════════════════════════════════════╗'
    echo '    ║                                                              ║'
    echo '    ║           ███████╗██╗   ██╗██████╗ ██╗   ██╗██╗            ║'
    echo '    ║           ██╔════╝██║   ██║██╔══██╗██║   ██║██║            ║'
    echo '    ║           ███████╗██║   ██║██████╔╝██║   ██║██║            ║'
    echo '    ║           ╚════██║██║   ██║██╔══██╗██║   ██║██║            ║'
    echo '    ║           ███████║╚██████╔╝██║  ██║╚██████╔╝███████╗       ║'
    echo '    ║           ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝       ║'
    echo '    ║                                                              ║'
    echo '    ║              🔄 IP CHANGER PRO v5.0                         ║'
    echo '    ║                   SURUJ EDITION                             ║'
    echo '    ║                                                              ║'
    echo '    ║             ✦ ═══════════════════════ ✦                      ║'
    echo '    ║                 🦅  EAGLE EYE  🦅                           ║'
    echo '    ║             ✦ ═══════════════════════ ✦                      ║'
    echo '    ║                                                              ║'
    ╚══════════════════════════════════════════════════════════════╝'
    echo -e "${NC}"
}

# ============================================================
#  SHOW MAIN MENU
# ============================================================
show_main_menu() {
    show_banner
    echo -e "${CYAN}📅 Time: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}🌐 Current IP: ${GREEN}$(get_current_ip)${NC}"
    echo -e "${CYAN}⏱ Interval: ${GREEN}${INTERVAL}s${NC}"
    echo -e "${CYAN}🌍 Country: ${GREEN}${COUNTRY}${NC}"
    echo -e "${CYAN}🚀 Auto-Start: ${GREEN}${AUTO_START}${NC}"
    echo -e "${CYAN}🔧 BG Mode: ${GREEN}${BG_MODE}${NC}"
    echo -e "${CYAN}📡 Tor: ${GREEN}✅ Active${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  🛠️  SETTINGS${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[1] Set Interval${NC}"
    echo -e "${YELLOW}[2] Set Country${NC}"
    echo -e "${YELLOW}[3] Toggle Auto-Start${NC}"
    echo -e "${YELLOW}[4] Toggle BG Mode${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ▶️  CONTROL${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[5] Start IP Changer${NC}"
    echo -e "${YELLOW}[6] Manual Renew${NC}"
    echo -e "${YELLOW}[7] Show History${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ❌  EXIT${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[Q] Quit${NC}"
    echo ""
}

# ============================================================
#  SET INTERVAL
# ============================================================
set_interval() {
    read -p "⏱ Enter interval (seconds): " new_interval
    if [[ "$new_interval" -ge 5 ]]; then
        INTERVAL=$new_interval
        save_config
        echo -e "${GREEN}✅ Interval set to ${INTERVAL}s${NC}"
    else
        echo -e "${RED}❌ Minimum 5 seconds!${NC}"
    fi
    sleep 1
}

# ============================================================
#  SET COUNTRY
# ============================================================
set_country() {
    echo -e "${CYAN}🌍 Enter country code (e.g., us, bd, uk, in):${NC}"
    read -p "👉 Country: " new_country
    if [ -n "$new_country" ]; then
        COUNTRY=$new_country
        save_config
        echo -e "${GREEN}✅ Country set to: $COUNTRY${NC}"
    else
        echo -e "${RED}❌ Invalid country!${NC}"
    fi
    sleep 1
}

# ============================================================
#  TOGGLE AUTO-START
# ============================================================
toggle_auto_start() {
    if [ "$AUTO_START" = "true" ]; then
        AUTO_START="false"
    else
        AUTO_START="true"
    fi
    save_config
    echo -e "${GREEN}✅ Auto-Start set to: $AUTO_START${NC}"
    sleep 1
}

# ============================================================
#  TOGGLE BG MODE
# ============================================================
toggle_bg_mode() {
    if [ "$BG_MODE" = "true" ]; then
        BG_MODE="false"
    else
        BG_MODE="true"
    fi
    save_config
    echo -e "${GREEN}✅ BG Mode set to: $BG_MODE${NC}"
    sleep 1
}

# ============================================================
#  START IP CHANGER
# ============================================================
start_ip_changer() {
    echo -e "${CYAN}🚀 Starting IP Changer...${NC}"
    echo -e "${CYAN}⏱ Interval: ${INTERVAL}s${NC}"
    echo -e "${CYAN}🌍 Country: ${COUNTRY}${NC}"
    echo -e "${CYAN}🔧 BG Mode: ${BG_MODE}${NC}"
    echo ""
    
    if [ "$BG_MODE" = "true" ]; then
        echo -e "${YELLOW}🔄 Running in background...${NC}"
        echo -e "${YELLOW}⚠️ To stop: pkill -f ip-changer.sh${NC}"
        while true; do
            sleep $INTERVAL
            change_ip
            ((CHANGE_COUNT++))
        done &
        echo -e "${GREEN}✅ Background mode started!${NC}"
        sleep 2
    else
        echo -e "${YELLOW}🔄 Press Ctrl+C to stop${NC}"
        CHANGE_COUNT=0
        while true; do
            sleep $INTERVAL
            change_ip
            ((CHANGE_COUNT++))
        done
    fi
}

# ============================================================
#  SHOW HISTORY
# ============================================================
show_history() {
    echo -e "${CYAN}📜 IP History:${NC}"
    if [ -f ~/.ip_history ]; then
        tail -10 ~/.ip_history
    else
        echo -e "${YELLOW}No history yet.${NC}"
    fi
    read -p "Press Enter to continue..."
}

# ============================================================
#  MAIN LOOP
# ============================================================
load_config

while true; do
    show_main_menu
    read -p "👉 Choose: " choice
    case $choice in
        1) set_interval ;;
        2) set_country ;;
        3) toggle_auto_start ;;
        4) toggle_bg_mode ;;
        5) start_ip_changer ;;
        6) change_ip ;;
        7) show_history ;;
        q|Q) 
            echo -e "${GREEN}👋 Goodbye!${NC}"
            exit 0
            ;;
        *) 
            echo -e "${RED}❌ Invalid choice!${NC}"
            sleep 1
            ;;
    esac
done