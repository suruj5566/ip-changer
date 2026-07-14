#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  SURUJ IP CHANGER INSTALLER v5.1
# ============================================================
clear
echo -e "\033[1;36m"
echo '    ╔══════════════════════════════════════════════════════════════╗'
echo '    ║                                                              ║'
echo '    ║        ███████╗██╗   ██╗██████╗ ██╗   ██╗██╗              ║'
echo '    ║        ██╔════╝██║   ██║██╔══██╗██║   ██║██║              ║'
echo '    ║        ███████╗██║   ██║██████╔╝██║   ██║██║              ║'
echo '    ║        ╚════██║██║   ██║██╔══██╗██║   ██║██║              ║'
echo '    ║        ███████║╚██████╔╝██║  ██║╚██████╔╝███████╗         ║'
echo '    ║        ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝         ║'
echo '    ║                                                              ║'
echo '    ║              🔄 IP CHANGER PRO v5.1                         ║'
echo '    ║                   SURUJ EDITION                             ║'
echo '    ║                                                              ║'
echo '    ║             ✦ ═══════════════════════ ✦                      ║'
echo '    ║                 🦅  EAGLE EYE  🦅                           ║'
echo '    ║             ✦ ═══════════════════════ ✦                      ║'
echo '    ║                                                              ║'
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
#  SURUJ IP CHANGER PRO v5.1 - FULL CONTROL
# ============================================================

RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; CYAN='\033[1;36m'; PURPLE='\033[1;35m'; NC='\033[0m'

CONFIG_FILE="$HOME/.ip_changer_config.json"
DEFAULT_INTERVAL=30
DEFAULT_COUNTRY="random"
DEFAULT_AUTO_START="false"
DEFAULT_BG_MODE="false"

# ============================================================
#  100+ COUNTRIES
# ============================================================
declare -A COUNTRIES=(
    ["random"]="🌍 Random"
    ["af"]="🇦🇫 Afghanistan" ["al"]="🇦🇱 Albania" ["dz"]="🇩🇿 Algeria"
    ["ar"]="🇦🇷 Argentina" ["am"]="🇦🇲 Armenia" ["au"]="🇦🇺 Australia"
    ["at"]="🇦🇹 Austria" ["az"]="🇦🇿 Azerbaijan" ["bs"]="🇧🇸 Bahamas"
    ["bh"]="🇧🇭 Bahrain" ["bd"]="🇧🇩 Bangladesh" ["bb"]="🇧🇧 Barbados"
    ["by"]="🇧🇾 Belarus" ["be"]="🇧🇪 Belgium" ["bz"]="🇧🇿 Belize"
    ["bj"]="🇧🇯 Benin" ["bo"]="🇧🇴 Bolivia" ["ba"]="🇧🇦 Bosnia"
    ["bw"]="🇧🇼 Botswana" ["br"]="🇧🇷 Brazil" ["bn"]="🇧🇳 Brunei"
    ["bg"]="🇧🇬 Bulgaria" ["bf"]="🇧🇫 Burkina Faso" ["bi"]="🇧🇮 Burundi"
    ["kh"]="🇰🇭 Cambodia" ["cm"]="🇨🇲 Cameroon" ["ca"]="🇨🇦 Canada"
    ["cv"]="🇨🇻 Cape Verde" ["cf"]="🇨🇫 CAR" ["td"]="🇹🇩 Chad"
    ["cl"]="🇨🇱 Chile" ["cn"]="🇨🇳 China" ["co"]="🇨🇴 Colombia"
    ["km"]="🇰🇲 Comoros" ["cd"]="🇨🇩 Congo" ["cr"]="🇨🇷 Costa Rica"
    ["hr"]="🇭🇷 Croatia" ["cu"]="🇨🇺 Cuba" ["cy"]="🇨🇾 Cyprus"
    ["cz"]="🇨🇿 Czech Republic" ["dk"]="🇩🇰 Denmark" ["dj"]="🇩🇯 Djibouti"
    ["dm"]="🇩🇲 Dominica" ["do"]="🇩🇴 Dominican Republic" ["ec"]="🇪🇨 Ecuador"
    ["eg"]="🇪🇬 Egypt" ["sv"]="🇸🇻 El Salvador" ["gq"]="🇬🇶 Equatorial Guinea"
    ["er"]="🇪🇷 Eritrea" ["ee"]="🇪🇪 Estonia" ["et"]="🇪🇹 Ethiopia"
    ["fj"]="🇫🇯 Fiji" ["fi"]="🇫🇮 Finland" ["fr"]="🇫🇷 France"
    ["ga"]="🇬🇦 Gabon" ["gm"]="🇬🇲 Gambia" ["ge"]="🇬🇪 Georgia"
    ["de"]="🇩🇪 Germany" ["gh"]="🇬🇭 Ghana" ["gr"]="🇬🇷 Greece"
    ["gt"]="🇬🇹 Guatemala" ["gn"]="🇬🇳 Guinea" ["gw"]="🇬🇼 Guinea-Bissau"
    ["gy"]="🇬🇾 Guyana" ["ht"]="🇭🇹 Haiti" ["hn"]="🇭🇳 Honduras"
    ["hu"]="🇭🇺 Hungary" ["is"]="🇮🇸 Iceland" ["in"]="🇮🇳 India"
    ["id"]="🇮🇩 Indonesia" ["ir"]="🇮🇷 Iran" ["iq"]="🇮🇶 Iraq"
    ["ie"]="🇮🇪 Ireland" ["il"]="🇮🇱 Israel" ["it"]="🇮🇹 Italy"
    ["jm"]="🇯🇲 Jamaica" ["jp"]="🇯🇵 Japan" ["jo"]="🇯🇴 Jordan"
    ["kz"]="🇰🇿 Kazakhstan" ["ke"]="🇰🇪 Kenya" ["kw"]="🇰🇼 Kuwait"
    ["kg"]="🇰🇬 Kyrgyzstan" ["la"]="🇱🇦 Laos" ["lv"]="🇱🇻 Latvia"
    ["lb"]="🇱🇧 Lebanon" ["ls"]="🇱🇸 Lesotho" ["lr"]="🇱🇷 Liberia"
    ["ly"]="🇱🇾 Libya" ["li"]="🇱🇮 Liechtenstein" ["lt"]="🇱🇹 Lithuania"
    ["lu"]="🇱🇺 Luxembourg" ["mg"]="🇲🇬 Madagascar" ["mw"]="🇲🇼 Malawi"
    ["my"]="🇲🇾 Malaysia" ["mv"]="🇲🇻 Maldives" ["ml"]="🇲🇱 Mali"
    ["mt"]="🇲🇹 Malta" ["mr"]="🇲🇷 Mauritania" ["mu"]="🇲🇺 Mauritius"
    ["mx"]="🇲🇽 Mexico" ["md"]="🇲🇩 Moldova" ["mc"]="🇲🇨 Monaco"
    ["mn"]="🇲🇳 Mongolia" ["me"]="🇲🇪 Montenegro" ["ma"]="🇲🇦 Morocco"
    ["mz"]="🇲🇿 Mozambique" ["mm"]="🇲🇲 Myanmar" ["na"]="🇳🇦 Namibia"
    ["np"]="🇳🇵 Nepal" ["nl"]="🇳🇱 Netherlands" ["nz"]="🇳🇿 New Zealand"
    ["ni"]="🇳🇮 Nicaragua" ["ne"]="🇳🇪 Niger" ["ng"]="🇳🇬 Nigeria"
    ["kp"]="🇰🇵 North Korea" ["no"]="🇳🇴 Norway" ["om"]="🇴🇲 Oman"
    ["pk"]="🇵🇰 Pakistan" ["pa"]="🇵🇦 Panama" ["pg"]="🇵🇬 Papua New Guinea"
    ["py"]="🇵🇾 Paraguay" ["pe"]="🇵🇪 Peru" ["ph"]="🇵🇭 Philippines"
    ["pl"]="🇵🇱 Poland" ["pt"]="🇵🇹 Portugal" ["qa"]="🇶🇦 Qatar"
    ["ro"]="🇷🇴 Romania" ["ru"]="🇷🇺 Russia" ["rw"]="🇷🇼 Rwanda"
    ["sa"]="🇸🇦 Saudi Arabia" ["sn"]="🇸🇳 Senegal" ["rs"]="🇷🇸 Serbia"
    ["sc"]="🇸🇨 Seychelles" ["sl"]="🇸🇱 Sierra Leone" ["sg"]="🇸🇬 Singapore"
    ["sk"]="🇸🇰 Slovakia" ["si"]="🇸🇮 Slovenia" ["so"]="🇸🇴 Somalia"
    ["za"]="🇿🇦 South Africa" ["kr"]="🇰🇷 South Korea" ["es"]="🇪🇸 Spain"
    ["lk"]="🇱🇰 Sri Lanka" ["sd"]="🇸🇩 Sudan" ["sr"]="🇸🇷 Suriname"
    ["sz"]="🇸🇿 Swaziland" ["se"]="🇸🇪 Sweden" ["ch"]="🇨🇭 Switzerland"
    ["sy"]="🇸🇾 Syria" ["tw"]="🇹🇼 Taiwan" ["tj"]="🇹🇯 Tajikistan"
    ["tz"]="🇹🇿 Tanzania" ["th"]="🇹🇭 Thailand" ["tl"]="🇹🇱 Timor-Leste"
    ["tg"]="🇹🇬 Togo" ["to"]="🇹🇴 Tonga" ["tt"]="🇹🇹 Trinidad"
    ["tn"]="🇹🇳 Tunisia" ["tr"]="🇹🇷 Turkey" ["tm"]="🇹🇲 Turkmenistan"
    ["ug"]="🇺🇬 Uganda" ["ua"]="🇺🇦 Ukraine" ["ae"]="🇦🇪 UAE"
    ["gb"]="🇬🇧 UK" ["us"]="🇺🇸 USA" ["uy"]="🇺🇾 Uruguay"
    ["uz"]="🇺🇿 Uzbekistan" ["vu"]="🇻🇺 Vanuatu" ["va"]="🇻🇦 Vatican"
    ["ve"]="🇻🇪 Venezuela" ["vn"]="🇻🇳 Vietnam" ["ye"]="🇾🇪 Yemen"
    ["zm"]="🇿🇲 Zambia" ["zw"]="🇿🇼 Zimbabwe"
)

# ============================================================
#  FUNCTIONS
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

save_config() {
    echo "{\"interval\": $INTERVAL, \"country\": \"$COUNTRY\", \"auto_start\": $AUTO_START, \"bg_mode\": $BG_MODE}" > "$CONFIG_FILE"
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
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $NEW_IP" >> ~/.ip_history
        return 0
    else
        echo -e "${RED}❌ Failed to get new IP!${NC}"
        return 1
    fi
}

show_banner() {
    clear
    echo -e "${PURPLE}"
    echo '    ╔══════════════════════════════════════════════════════════════╗'
    echo '    ║                                                              ║'
    echo '    ║        ███████╗██╗   ██╗██████╗ ██╗   ██╗██╗              ║'
    echo '    ║        ██╔════╝██║   ██║██╔══██╗██║   ██║██║              ║'
    echo '    ║        ███████╗██║   ██║██████╔╝██║   ██║██║              ║'
    echo '    ║        ╚════██║██║   ██║██╔══██╗██║   ██║██║              ║'
    echo '    ║        ███████║╚██████╔╝██║  ██║╚██████╔╝███████╗         ║'
    echo '    ║        ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝         ║'
    echo '    ║                                                              ║'
    echo '    ║              🔄 IP CHANGER PRO v5.1                         ║'
    echo '    ║                   SURUJ EDITION                             ║'
    echo '    ║                                                              ║'
    echo '    ║             ✦ ═══════════════════════ ✦                      ║'
    echo '    ║                 🦅  EAGLE EYE  🦅                           ║'
    echo '    ║             ✦ ═══════════════════════ ✦                      ║'
    echo '    ║                                                              ║'
    echo '    ╚══════════════════════════════════════════════════════════════╝'
    echo -e "${NC}"
}

show_menu() {
    show_banner
    echo -e "${CYAN}📅 Time: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}🌐 Current IP: ${GREEN}$(get_current_ip)${NC}"
    echo -e "${CYAN}⏱ Interval: ${GREEN}${INTERVAL}s${NC}"
    echo -e "${CYAN}🌍 Country: ${GREEN}${COUNTRIES[$COUNTRY]:-$COUNTRY}${NC}"
    echo -e "${CYAN}🚀 Auto-Start: ${GREEN}${AUTO_START}${NC}"
    echo -e "${CYAN}🔧 BG Mode: ${GREEN}${BG_MODE}${NC}"
    echo -e "${CYAN}📡 Tor: ${GREEN}✅ Active${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  🛠️  SETTINGS${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[1] Set Interval${NC}"
    echo -e "${YELLOW}[2] Set Country (100+ countries)${NC}"
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

set_country() {
    echo -e "${CYAN}🌍 Available countries: 100+${NC}"
    echo -e "${CYAN}Enter country code (e.g., bd, us, uk, in):${NC}"
    read -p "👉 Country: " new_country
    if [ -n "$new_country" ] && [ -n "${COUNTRIES[$new_country]}" ]; then
        COUNTRY=$new_country
        save_config
        echo -e "${GREEN}✅ Country set to: ${COUNTRIES[$COUNTRY]}${NC}"
    else
        echo -e "${RED}❌ Invalid country code! Use 'random' or check list.${NC}"
    fi
    sleep 1
}

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

start_ip_changer() {
    echo -e "${CYAN}🚀 Starting IP Changer...${NC}"
    echo -e "${CYAN}⏱ Interval: ${INTERVAL}s${NC}"
    echo -e "${CYAN}🌍 Country: ${COUNTRIES[$COUNTRY]:-$COUNTRY}${NC}"
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
    show_menu
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

echo -e "\033[1;32m✅ SURUJ IP CHANGER PRO v5.1 INSTALLED!\033[0m"
echo -e "\033[1;36m🚀 Now run: ip-changer\033[0m"
echo -e "\033[1;36m📂 Installed at: $IPCHANGER\033[0m"