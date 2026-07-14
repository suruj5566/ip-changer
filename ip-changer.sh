#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  SURUJ IP CHANGER - MAIN SCRIPT v4.1
# ============================================================

# Define ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m'

# ============================================================
#  BANNER
# ============================================================
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
echo '    ║              🔄 IP CHANGER PRO v4.1                         ║'
echo '    ║                   SURUJ EDITION                             ║'
echo '    ║                                                              ║'
echo '    ║             ✦ ═══════════════════════ ✦                      ║'
echo '    ║                 🦅  EAGLE EYE  🦅                           ║'
echo '    ║             ✦ ═══════════════════════ ✦                      ║'
echo '    ║                                                              ║'
echo '    ╚══════════════════════════════════════════════════════════════╝'
echo -e "${NC}"

# ============================================================
#  CONFIG
# ============================================================
CONFIG_FILE="$HOME/.ip_changer_config.json"
DEFAULT_INTERVAL=60
DEFAULT_COUNTRY="random"

# ============================================================
#  COUNTRY LIST (100+)
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
    else
        INTERVAL=$DEFAULT_INTERVAL
        COUNTRY=$DEFAULT_COUNTRY
    fi
}

save_config() {
    echo "{\"interval\": $INTERVAL, \"country\": \"$COUNTRY\"}" > "$CONFIG_FILE"
}

check_tor() {
    if pgrep -x "tor" >/dev/null; then
        return 0
    else
        echo -e "${RED}❌ Tor is not running!${NC}"
        echo -e "${YELLOW}🔧 Starting Tor...${NC}"
        tor --runasdaemon 1 &
        sleep 3
        if pgrep -x "tor" >/dev/null; then
            echo -e "${GREEN}✅ Tor started!${NC}"
            return 0
        else
            echo -e "${RED}❌ Failed to start Tor!${NC}"
            return 1
        fi
    fi
}

get_current_ip() {
    curl -s --socks5-hostname 127.0.0.1:9050 https://api.ipify.org 2>/dev/null
}

change_ip() {
    echo -e "${YELLOW}🔄 Changing IP...${NC}"
    (
        echo "AUTHENTICATE"
        echo "SIGNAL NEWNYM"
        echo "QUIT"
    ) | nc -w 2 127.0.0.1 9051 >/dev/null 2>&1
    sleep 2
    NEW_IP=$(get_current_ip)
    if [ -n "$NEW_IP" ]; then
        echo -e "${GREEN}✅ New IP: $NEW_IP${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to get new IP!${NC}"
        return 1
    fi
}

show_menu() {
    clear
    echo -e "${PURPLE}"
    echo '    ╔══════════════════════════════════════════════════════════════╗'
    echo '    ║              🔄 IP CHANGER PRO v4.1                         ║'
    echo '    ║                   SURUJ EDITION                             ║'
    echo '    ║                                                              ║'
    echo '    ╚══════════════════════════════════════════════════════════════╝'
    echo -e "${NC}"
    echo -e "${CYAN}📅 Time: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}🌐 Current IP: ${GREEN}$(get_current_ip)${NC}"
    echo -e "${CYAN}🔄 Changes: ${GREEN}$CHANGE_COUNT${NC}"
    echo -e "${CYAN}⏱ Interval: ${GREEN}${INTERVAL}s${NC}"
    echo -e "${CYAN}🌍 Country: ${GREEN}${COUNTRIES[$COUNTRY]:-$COUNTRY}${NC}"
    echo -e "${CYAN}📡 Tor: ${GREEN}✅ Active${NC}"
    echo ""
    echo -e "${YELLOW}[1] Set Interval${NC}"
    echo -e "${YELLOW}[2] Set Country${NC}"
    echo -e "${YELLOW}[3] Manual Renew${NC}"
    echo -e "${YELLOW}[4] Show History${NC}"
    echo -e "${YELLOW}[5] Run in BG${NC}"
    echo -e "${YELLOW}[Q] Quit${NC}"
    echo ""
}

# ============================================================
#  MAIN LOOP
# ============================================================
load_config
CHANGE_COUNT=0

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
            echo -e "${CYAN}🌍 Available countries:${NC}"
            select c in "${!COUNTRIES[@]}"; do
                if [ -n "$c" ]; then
                    COUNTRY=$c
                    save_config
                    echo -e "${GREEN}✅ Country set to ${COUNTRIES[$c]}${NC}"
                    break
                fi
            done
            sleep 1
            ;;
        3)
            change_ip && ((CHANGE_COUNT++))
            sleep 2
            ;;
        4)
            echo -e "${CYAN}📜 IP History:${NC}"
            tail -5 ~/.ip_history 2>/dev/null || echo "No history yet."
            read -p "Press Enter to continue..."
            ;;
        5)
            echo -e "${CYAN}🔄 Running in background...${NC}"
            while true; do
                sleep $INTERVAL
                change_ip && ((CHANGE_COUNT++))
                echo "$(date '+%H:%M:%S') - $(get_current_ip)" >> ~/.ip_history
            done &
            echo -e "${GREEN}✅ Background mode started!${NC}"
            echo -e "${YELLOW}⚠️ To stop: pkill -f ip-changer.sh${NC}"
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