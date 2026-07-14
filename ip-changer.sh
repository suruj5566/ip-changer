#!/bin/bash

# ==========================================
# 🔥 IP CHANGER - SURUJ EDITION (ULTIMATE)
# ==========================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m'

show_logo() {
    clear
    echo -e "${CYAN}  ═══════════════════════════════════${NC}"
    echo -e "${CYAN}     🔥 ${MAGENTA}SURUJ EDITION${CYAN} 🔥${NC}"
    echo -e "${CYAN}     ${GREEN}IP CHANGER PRO${NC}"
    echo -e "${CYAN}  ═══════════════════════════════════${NC}"
    echo ""
}

show_logo
echo -e "${CYAN}🎨 Select Theme:${NC}"
echo "1. Dark Theme"
echo "2. Light Theme"
echo "3. Neon Theme"
read -p "👉 Choose (1-3): " theme_choice
echo ""

echo -e "${YELLOW}🌍 Select Country:${NC}"
echo "1. US (USA)"
echo "2. UK (United Kingdom)"
echo "3. DE (Germany)"
echo "4. FR (France)"
echo "5. IN (India)"
echo "6. BD (Bangladesh)"
echo "7. Random (All Countries)"
read -p "👉 Choose (1-7): " country_choice

case $country_choice in
    1) EXIT_NODE="{US}" ; COUNTRY_NAME="US" ;;
    2) EXIT_NODE="{UK}" ; COUNTRY_NAME="UK" ;;
    3) EXIT_NODE="{DE}" ; COUNTRY_NAME="DE" ;;
    4) EXIT_NODE="{FR}" ; COUNTRY_NAME="FR" ;;
    5) EXIT_NODE="{IN}" ; COUNTRY_NAME="IN" ;;
    6) EXIT_NODE="{BD}" ; COUNTRY_NAME="BD" ;;
    7) EXIT_NODE="" ; COUNTRY_NAME="Random" ;;
    *) EXIT_NODE="" ; COUNTRY_NAME="Random" ;;
esac
echo -e "${GREEN}✅ Selected: $COUNTRY_NAME${NC}"
echo ""

echo -e "${YELLOW}🌐 Custom IP Range (optional):${NC}"
echo "1. Default (Random)"
echo "2. 185.220.x.x (Tor exit nodes)"
echo "3. 5.255.x.x (Tor exit nodes)"
echo "4. 193.189.x.x (Tor exit nodes)"
echo "5. Custom (enter manually)"
read -p "👉 Choose (1-5): " range_choice

case $range_choice in
    2) IP_RANGE="185.220." ;;
    3) IP_RANGE="5.255." ;;
    4) IP_RANGE="193.189." ;;
    5) read -p "👉 Enter IP range (e.g., 192.168.): " IP_RANGE ;;
    *) IP_RANGE="" ;;
esac
echo ""

echo -e "${YELLOW}🐢 Select Speed Mode:${NC}"
echo "1. Fast Mode (3s)"
echo "2. Normal Mode (10s)"
echo "3. Slow Mode (25s)"
echo "4. Custom (enter manually)"
read -p "👉 Choose (1-4): " speed_choice

case $speed_choice in
    1) SLEEP_TIME=3 ;;
    2) SLEEP_TIME=10 ;;
    3) SLEEP_TIME=25 ;;
    4) read -p "👉 Enter seconds: " SLEEP_TIME ;;
    *) SLEEP_TIME=10 ;;
esac
echo -e "${GREEN}✅ Speed set to ${SLEEP_TIME}s${NC}"
echo ""

echo -e "${YELLOW}🔢 Auto Stop after how many IP changes? (0=unlimited)${NC}"
read -p "👉 Enter number: " MAX_COUNT
[[ ! "$MAX_COUNT" =~ ^[0-9]+$ ]] && MAX_COUNT=0
echo ""

echo -e "${YELLOW}🚫 Blacklist certain ISPs? (y/n)${NC}"
read -p "👉 " blacklist_choice
if [[ "$blacklist_choice" == "y" ]]; then
    BLACKLIST="DigitalOcean|AWS|Amazon|Microsoft|Google"
else
    BLACKLIST=""
fi
echo ""

echo -e "${YELLOW}📶 Auto-set Wi-Fi Proxy? (y/n)${NC}"
echo "⚠️  Requires Termux-API"
read -p "👉 " wifi_choice
if [[ "$wifi_choice" == "y" ]]; then
    if command -v termux-wifi-connectioninfo &>/dev/null; then
        echo -e "${GREEN}✅ Termux-API found. Setting proxy...${NC}"
        echo -e "${YELLOW}📶 Please set proxy manually in Wi-Fi settings:${NC}"
        echo "   Host: 127.0.0.1"
        echo "   Port: 8118"
    else
        echo -e "${RED}❌ Termux-API not installed!${NC}"
        echo -e "${YELLOW}💡 Install: pkg install termux-api${NC}"
    fi
fi
echo ""

echo -e "${YELLOW}🔄 Multi-Port Mode:${NC}"
echo "1. Single Port (Fast)"
echo "2. Multi Port (5 ports - Stable)"
read -p "👉 Choose (1-2): " port_choice

if [[ "$port_choice" == "2" ]]; then
    MULTI_PORT=true
    PORTS=(9050 9060 9070 9080 9090)
else
    MULTI_PORT=false
    PORTS=(9050)
fi
echo ""

echo -e "${YELLOW}🔄 Starting Tor & Privoxy...${NC}"
pkill tor 2>/dev/null
pkill privoxy 2>/dev/null
sleep 2

mkdir -p ~/.tor ~/.privoxy

cat > ~/.tor/torrc << 'EOT'
SocksPort 9050
ControlPort 9051
DataDirectory /data/data/com.termux/files/home/.tor
CookieAuthentication 0
EOT

if [[ -n "$EXIT_NODE" ]]; then
    echo "ExitNodes $EXIT_NODE" >> ~/.tor/torrc
    echo "StrictNodes 1" >> ~/.tor/torrc
fi

if [[ -n "$IP_RANGE" ]]; then
    echo "ExitNodes $IP_RANGE*" >> ~/.tor/torrc
    echo "StrictNodes 1" >> ~/.tor/torrc
fi

if [[ "$MULTI_PORT" == true ]]; then
    for port in 9060 9070 9080 9090; do
        echo "SocksPort $port" >> ~/.tor/torrc
    done
fi

tor -f ~/.tor/torrc > /dev/null 2>&1 &
sleep 10

cat > ~/.privoxy/config << 'EOT'
listen-address 127.0.0.1:8118
forward-socks5 / 127.0.0.1:9050 .
EOT

if [[ "$MULTI_PORT" == true ]]; then
    for port in 9060 9070 9080 9090; do
        echo "forward-socks5 / 127.0.0.1:$port ." >> ~/.privoxy/config
    done
fi

privoxy ~/.privoxy/config > /dev/null 2>&1 &
sleep 3

echo -e "${GREEN}✅ Tor & Privoxy Started${NC}"
echo ""

COUNT=0
PAUSED=false
RETRY_COUNT=0
START_TIME=$(date +%s)
LOG_FILE="$HOME/ip_changer.log"
echo "===== IP Changer Log - $(date) =====" >> "$LOG_FILE"

echo -e "${BLUE}🌐 IP Changer Running...${NC}"
echo -e "${YELLOW}Press p = Pause | r = Resume | Ctrl+C = Stop${NC}"
echo ""

while true; do
    if [[ "$PAUSED" == true ]]; then
        echo -e "${YELLOW}⏸️ Paused. Press 'r' to resume...${NC}"
        while true; do
            read -t 1 -n 1 key
            if [[ "$key" == "r" ]]; then
                PAUSED=false
                echo -e "${GREEN}▶️ Resumed!${NC}"
                break
            fi
        done
    fi

    read -t 0.1 -n 1 key
    if [[ "$key" == "p" ]]; then
        PAUSED=true
        echo -e "${YELLOW}⏸️ Pausing...${NC}"
        continue
    fi

    echo -e "AUTHENTICATE \"\"\r\nSIGNAL NEWNYM\r\nQUIT" | nc 127.0.0.1 9051 > /dev/null 2>&1
    sleep 3

    IP=""
    for i in {1..3}; do
        IP=$(curl --proxy http://127.0.0.1:8118 -s --max-time 5 https://api64.ipify.org)
        if [[ -n "$IP" ]]; then
            break
        fi
        sleep 2
    done

    if [[ -n "$IP" ]]; then
        COUNT=$((COUNT + 1))
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        
        COUNTRY=$(curl --proxy http://127.0.0.1:8118 -s --max-time 5 https://ipinfo.io/country)
        case "$COUNTRY" in
            "US") FLAG="🇺🇸" ;;
            "GB") FLAG="🇬🇧" ;;
            "DE") FLAG="🇩🇪" ;;
            "FR") FLAG="🇫🇷" ;;
            "IN") FLAG="🇮🇳" ;;
            "BD") FLAG="🇧🇩" ;;
            *) FLAG="🌍" ;;
        esac

        if [[ -n "$BLACKLIST" ]]; then
            ISP=$(curl --proxy http://127.0.0.1:8118 -s --max-time 5 https://ipinfo.io/org)
            if [[ "$ISP" =~ $BLACKLIST ]]; then
                echo -e "${RED}🚫 Blacklisted ISP: $ISP. Rotating again...${NC}"
                continue
            fi
        fi

        echo -e "${GREEN}🌐 #$COUNT New IP: $IP $FLAG ✅${NC}"
        echo -e "${BLUE}🔹 Proxy: 127.0.0.1:8118${NC}"
        
        CURRENT_TIME=$(date +%s)
        UPTIME=$((CURRENT_TIME - START_TIME))
        UPTIME_MIN=$((UPTIME / 60))
        UPTIME_SEC=$((UPTIME % 60))
        echo -e "${CYAN}⏱️ Uptime: ${UPTIME_MIN}m ${UPTIME_SEC}s${NC}"
        echo -e "${CYAN}─────────────────────────────────────────${NC}"

        echo "[$TIMESTAMP] #$COUNT IP: $IP ($COUNTRY)" >> "$LOG_FILE"

        if command -v termux-beep &>/dev/null; then
            termux-beep
        fi

        if command -v termux-notification &>/dev/null; then
            termux-notification -t "IP Changed" -c "New IP: $IP (#$COUNT)" > /dev/null 2>&1
        fi

        if [ "$MAX_COUNT" -gt 0 ] && [ "$COUNT" -ge "$MAX_COUNT" ]; then
            echo -e "${GREEN}✅ Auto stop: $COUNT IP changes completed!${NC}"
            break
        fi
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        echo -e "${RED}⏳ Waiting for Tor... (Attempt $RETRY_COUNT/3)${NC}"
        if [ "$RETRY_COUNT" -ge 3 ]; then
            RETRY_COUNT=0
        fi
    fi

    sleep "$SLEEP_TIME"
done

echo -e "${GREEN}✅ Total IP Changes: $COUNT${NC}"
echo -e "${YELLOW}📁 Log saved at: $LOG_FILE${NC}"
echo -e "${YELLOW}👋 Exiting...${NC}"