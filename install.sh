#!/data/data/com.termux/files/usr/bin/bash

# SURUJ IP CHANGER INSTALLER v5.0
clear
echo -e "\033[1;36m"
echo '    ╔══════════════════════════════════════════════════════════════╗'
echo '    ║              🔄 IP CHANGER PRO v5.0                         ║'
echo '    ║                   SURUJ EDITION                             ║'
echo '    ║                 🦅  EAGLE EYE  🦅                           ║'
echo '    ╚══════════════════════════════════════════════════════════════╝'
echo -e "\033[0m"

echo -e "\033[1;36m🔍 Installing SURUJ IP Changer...\033[0m"

# Termux check
if [ -d "/data/data/com.termux/files/usr" ]; then
    PREFIX="/data/data/com.termux/files/usr"
    IPCHANGER="$PREFIX/share/ip-changer"
    LAUNCHER="$PREFIX/bin/ip-changer"
    PKG_MANAGER="pkg"
else
    PREFIX="/usr"
    IPCHANGER="$PREFIX/share/ip-changer"
    LAUNCHER="$PREFIX/bin/ip-changer"
    PKG_MANAGER="apt-get"
fi

# Remove old files
rm -rf /data/data/com.termux/files/usr/share/AnonymousPro
rm -f /data/data/com.termux/files/usr/bin/AnonymousPro
pkill -f AnonymousPro 2>/dev/null

# Install packages
echo -e "\033[1;36m🛠️ Installing required packages...\033[0m"
$PKG_MANAGER install tor curl netcat-openbsd jq -y 2>/dev/null

# Create directory
mkdir -p "$IPCHANGER"
cd "$IPCHANGER"

# Create main script
cat > "$IPCHANGER/ip-changer.sh" << 'MAINEOF'
#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  SURUJ IP CHANGER PRO v5.0 - FULL CONTROL
# ============================================================

RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; CYAN='\033[1;36m'; PURPLE='\033[1;35m'; NC='\033[0m'

CONFIG_FILE="$HOME/.ip_changer_config.json"
DEFAULT_INTERVAL=30

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        INTERVAL=$(jq -r '.interval' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_INTERVAL")
    else
        INTERVAL=$DEFAULT_INTERVAL
    fi
}

save_config() {
    echo "{\"interval\": $INTERVAL}" > "$CONFIG_FILE"
}

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
        return 0
    else
        echo -e "${RED}❌ Failed!${NC}"
        return 1
    fi
}

show_menu() {
    clear
    echo -e "${PURPLE}"
    echo '    ╔══════════════════════════════════════════════════════════════╗'
    echo '    ║              🔄 SURUJ IP CHANGER PRO v5.0                  ║'
    echo '    ║                   🦅 EAGLE EYE EDITION                     ║'
    echo '    ╚══════════════════════════════════════════════════════════════╝'
    echo -e "${NC}"
    echo -e "${CYAN}📅 Time: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}🌐 Current IP: ${GREEN}$(get_current_ip)${NC}"
    echo -e "${CYAN}⏱ Current Interval: ${GREEN}${INTERVAL}s${NC}"
    echo -e "${CYAN}📡 Tor: ${GREEN}✅ Active${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  🛠️  SETTINGS${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[1] Set Interval (Change time)${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ▶️  CONTROL${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[2] Start IP Changer${NC}"
    echo -e "${YELLOW}[3] Manual Renew (Change IP now)${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ❌  EXIT${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[Q] Quit${NC}"
    echo ""
}

load_config

while true; do
    show_menu
    read -p "👉 Choose: " choice
    case $choice in
        1)
            read -p "⏱ Enter interval (seconds): " new_interval
            if [[ "$new_interval" -ge 5 ]]; then
                INTERVAL=$new_interval
                save_config
                echo -e "${GREEN}✅ Interval set to ${INTERVAL}s${NC}"
            else
                echo -e "${RED}❌ Minimum 5 seconds!${NC}"
            fi
            sleep 1
            ;;
        2)
            echo -e "${CYAN}🚀 Starting IP Changer...${NC}"
            echo -e "${CYAN}⏱ Interval: ${INTERVAL}s${NC}"
            echo -e "${YELLOW}🔄 Press Ctrl+C to stop${NC}"
            CHANGE_COUNT=0
            while true; do
                sleep $INTERVAL
                change_ip
                ((CHANGE_COUNT++))
            done
            ;;
        3)
            change_ip
            sleep 2
            ;;
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
MAINEOF

chmod +x "$IPCHANGER/ip-changer.sh"

# Create launcher
cat > "$LAUNCHER" << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
bash /data/data/com.termux/files/usr/share/ip-changer/ip-changer.sh "$@"
LAUNCHEREOF

chmod +x "$LAUNCHER"

# Start Tor
tor --runasdaemon 1 2>/dev/null
sleep 3

echo -e "\033[1;32m✅ SURUJ IP CHANGER PRO v5.0 INSTALLED!\033[0m"
echo -e "\033[1;36m🚀 Now run: ip-changer\033[0m"