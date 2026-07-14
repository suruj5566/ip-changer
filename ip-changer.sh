#!/usr/bin/env bash
set +e

RED='\u001B[1;31m'
GREEN='\u001B[1;32m'
YELLOW='\u001B[1;33m'
CYAN='\u001B[1;36m'
PURPLE='\u001B[1;35m'
NC='\u001B[0m'

CONFIG_FILE="$HOME/.ip_changer_config.json"
HISTORY_FILE="$HOME/.ip_history"

DEFAULT_INTERVAL=30
DEFAULT_COUNTRY="random"
DEFAULT_AUTO_START=false
DEFAULT_BG_MODE=false
DEFAULT_PROXY_MODE="tor"

if [ -d "/data/data/com.termux/files/usr" ]; then
    PREFIX="/data/data/com.termux/files/usr"
else
    PREFIX="/usr"
fi

PRIVOXY_CONFIG="$PREFIX/etc/privoxy/config"

declare -A COUNTRIES=(
["random"]="🌍 Random"
["af"]="🇦🇫 Afghanistan" ["al"]="🇦🇱 Albania" ["dz"]="🇩🇿 Algeria" ["ar"]="🇦🇷 Argentina" ["am"]="🇦🇲 Armenia" ["au"]="🇦🇺 Australia"
["at"]="🇦🇹 Austria" ["az"]="🇦🇿 Azerbaijan" ["bs"]="🇧🇸 Bahamas" ["bh"]="🇧🇭 Bahrain" ["bd"]="🇧🇩 Bangladesh" ["bb"]="🇧🇧 Barbados"
["by"]="🇧🇾 Belarus" ["be"]="🇧🇪 Belgium" ["bz"]="🇧🇿 Belize" ["bj"]="🇧🇯 Benin" ["bo"]="🇧🇴 Bolivia" ["ba"]="🇧🇦 Bosnia"
["bw"]="🇧🇼 Botswana" ["br"]="🇧🇷 Brazil" ["bn"]="🇧🇳 Brunei" ["bg"]="🇧🇬 Bulgaria" ["bf"]="🇧🇫 Burkina Faso" ["bi"]="🇧🇮 Burundi"
["kh"]="🇰🇭 Cambodia" ["cm"]="🇨🇲 Cameroon" ["ca"]="🇨🇦 Canada" ["cv"]="🇨🇻 Cape Verde" ["cf"]="🇨🇫 CAR" ["td"]="🇹🇩 Chad"
["cl"]="🇨🇱 Chile" ["cn"]="🇨🇳 China" ["co"]="🇨🇴 Colombia" ["km"]="🇰🇲 Comoros" ["cd"]="🇨🇩 Congo" ["cr"]="🇨🇷 Costa Rica"
["hr"]="🇭🇷 Croatia" ["cu"]="🇨🇺 Cuba" ["cy"]="🇨🇾 Cyprus" ["cz"]="🇨🇿 Czech Republic" ["dk"]="🇩🇰 Denmark" ["dj"]="🇩🇯 Djibouti"
["dm"]="🇩🇲 Dominica" ["do"]="🇩🇴 Dominican Republic" ["ec"]="🇪🇨 Ecuador" ["eg"]="🇪🇬 Egypt" ["sv"]="🇸🇻 El Salvador" ["gq"]="🇬🇶 Equatorial Guinea"
["er"]="🇪🇷 Eritrea" ["ee"]="🇪🇪 Estonia" ["et"]="🇪🇹 Ethiopia" ["fj"]="🇫🇯 Fiji" ["fi"]="🇫🇮 Finland" ["fr"]="🇫🇷 France"
["ga"]="🇬🇦 Gabon" ["gm"]="🇬🇲 Gambia" ["ge"]="🇬🇪 Georgia" ["de"]="🇩🇪 Germany" ["gh"]="🇬🇭 Ghana" ["gr"]="🇬🇷 Greece"
["gt"]="🇬🇹 Guatemala" ["gn"]="🇬🇳 Guinea" ["gw"]="🇬🇼 Guinea-Bissau" ["gy"]="🇬🇾 Guyana" ["ht"]="🇭🇹 Haiti" ["hn"]="🇭🇳 Honduras"
["hu"]="🇭🇺 Hungary" ["is"]="🇮🇸 Iceland" ["in"]="🇮🇳 India" ["id"]="🇮🇩 Indonesia" ["ir"]="🇮🇷 Iran" ["iq"]="🇮🇶 Iraq"
["ie"]="🇮🇪 Ireland" ["il"]="🇮🇱 Israel" ["it"]="🇮🇹 Italy" ["jm"]="🇯🇲 Jamaica" ["jp"]="🇯🇵 Japan" ["jo"]="🇯🇴 Jordan"
["kz"]="🇰🇿 Kazakhstan" ["ke"]="🇰🇪 Kenya" ["kw"]="🇰🇼 Kuwait" ["kg"]="🇰🇬 Kyrgyzstan" ["la"]="🇱🇦 Laos" ["lv"]="🇱🇻 Latvia"
["lb"]="🇱🇧 Lebanon" ["ls"]="🇱🇸 Lesotho" ["lr"]="🇱🇷 Liberia" ["ly"]="🇱🇾 Libya" ["li"]="🇱🇮 Liechtenstein" ["lt"]="🇱🇹 Lithuania"
["lu"]="🇱🇺 Luxembourg" ["mg"]="🇲🇬 Madagascar" ["mw"]="🇲🇼 Malawi" ["my"]="🇲🇾 Malaysia" ["mv"]="🇲🇻 Maldives" ["ml"]="🇲🇱 Mali"
["mt"]="🇲🇹 Malta" ["mr"]="🇲🇷 Mauritania" ["mu"]="🇲🇺 Mauritius" ["mx"]="🇲🇽 Mexico" ["md"]="🇲🇩 Moldova" ["mc"]="🇲🇨 Monaco"
["mn"]="🇲🇳 Mongolia" ["me"]="🇲🇪 Montenegro" ["ma"]="🇲🇦 Morocco" ["mz"]="🇲🇿 Mozambique" ["mm"]="🇲🇲 Myanmar" ["na"]="🇳🇦 Namibia"
["np"]="🇳🇵 Nepal" ["nl"]="🇳🇱 Netherlands" ["nz"]="🇳🇿 New Zealand" ["ni"]="🇳🇮 Nicaragua" ["ne"]="🇳🇪 Niger" ["ng"]="🇳🇬 Nigeria"
["kp"]="🇰🇵 North Korea" ["no"]="🇳🇴 Norway" ["om"]="🇴🇲 Oman" ["pk"]="🇵🇰 Pakistan" ["pa"]="🇵🇦 Panama" ["pg"]="🇵🇬 Papua New Guinea"
["py"]="🇵🇾 Paraguay" ["pe"]="🇵🇪 Peru" ["ph"]="🇵🇭 Philippines" ["pl"]="🇵🇱 Poland" ["pt"]="🇵🇹 Portugal" ["qa"]="🇶🇦 Qatar"
["ro"]="🇷🇴 Romania" ["ru"]="🇷🇺 Russia" ["rw"]="🇷🇼 Rwanda" ["sa"]="🇸🇦 Saudi Arabia" ["sn"]="🇸🇳 Senegal" ["rs"]="🇷🇸 Serbia"
["sc"]="🇸🇨 Seychelles" ["sl"]="🇸🇱 Sierra Leone" ["sg"]="🇸🇬 Singapore" ["sk"]="🇸🇰 Slovakia" ["si"]="🇸🇮 Slovenia" ["so"]="🇸🇴 Somalia"
["za"]="🇿🇦 South Africa" ["kr"]="🇰🇷 South Korea" ["es"]="🇪🇸 Spain" ["lk"]="🇱🇰 Sri Lanka" ["sd"]="🇸🇩 Sudan" ["sr"]="🇸🇷 Suriname"
["sz"]="🇸🇿 Swaziland" ["se"]="🇸🇪 Sweden" ["ch"]="🇨🇭 Switzerland" ["sy"]="🇸🇾 Syria" ["tw"]="🇹🇼 Taiwan" ["tj"]="🇹🇯 Tajikistan"
["tz"]="🇹🇿 Tanzania" ["th"]="🇹🇭 Thailand" ["tl"]="🇹🇱 Timor-Leste" ["tg"]="🇹🇬 Togo" ["to"]="🇹🇴 Tonga" ["tt"]="🇹🇹 Trinidad"
["tn"]="🇹🇳 Tunisia" ["tr"]="🇹🇷 Turkey" ["tm"]="🇹🇲 Turkmenistan" ["ug"]="🇺🇬 Uganda" ["ua"]="🇺🇦 Ukraine" ["ae"]="🇦🇪 UAE"
["gb"]="🇬🇧 UK" ["us"]="🇺🇸 USA" ["uy"]="🇺🇾 Uruguay" ["uz"]="🇺🇿 Uzbekistan" ["vu"]="🇻🇺 Vanuatu" ["va"]="🇻🇦 Vatican"
["ve"]="🇻🇪 Venezuela" ["vn"]="🇻🇳 Vietnam" ["ye"]="🇾🇪 Yemen" ["zm"]="🇿🇲 Zambia" ["zw"]="🇿🇼 Zimbabwe"
)

load_config() {
    if [ -f "$CONFIG_FILE" ] && command -v jq >/dev/null 2>&1; then
        INTERVAL=$(jq -r '.interval // 30' "$CONFIG_FILE" 2>/dev/null)
        COUNTRY=$(jq -r '.country // "random"' "$CONFIG_FILE" 2>/dev/null)
        AUTO_START=$(jq -r '.auto_start // false' "$CONFIG_FILE" 2>/dev/null)
        BG_MODE=$(jq -r '.bg_mode // false' "$CONFIG_FILE" 2>/dev/null)
        PROXY_MODE=$(jq -r '.proxy_mode // "tor"' "$CONFIG_FILE" 2>/dev/null)
    else
        INTERVAL=$DEFAULT_INTERVAL
        COUNTRY=$DEFAULT_COUNTRY
        AUTO_START=$DEFAULT_AUTO_START
        BG_MODE=$DEFAULT_BG_MODE
        PROXY_MODE=$DEFAULT_PROXY_MODE
    fi
}

save_config() {
    printf '{"interval":%s,"country":"%s","auto_start":%s,"bg_mode":%s,"proxy_mode":"%s"}
' \
        "$INTERVAL" "$COUNTRY" "$AUTO_START" "$BG_MODE" "$PROXY_MODE" > "$CONFIG_FILE"
}

start_privoxy() {
    command -v privoxy >/dev/null 2>&1 || return 0
    pkill privoxy 2>/dev/null || true
    [ -f "$PRIVOXY_CONFIG" ] && privoxy "$PRIVOXY_CONFIG" >/dev/null 2>&1 &
    sleep 2
}

get_current_ip() {
    if [ "$PROXY_MODE" = "privoxy" ]; then
        curl -s --proxy 127.0.0.1:8118 https://api.ipify.org 2>/dev/null || echo "Unknown"
    else
        curl -s --socks5-hostname 127.0.0.1:9050 https://api.ipify.org 2>/dev/null || echo "Unknown"
    fi
}

change_ip() {
    printf "${YELLOW}🔄 Changing IP...${NC}
"
    printf 'AUTHENTICATE
SIGNAL NEWNYM
QUIT
' | nc -w 2 127.0.0.1 9051 >/dev/null 2>&1 || true
    sleep 2
    NEW_IP="$(get_current_ip)"
    if [ -n "$NEW_IP" ] && [ "$NEW_IP" != "Unknown" ]; then
        printf "${GREEN}✅ New IP: %s${NC}
" "$NEW_IP"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $NEW_IP" >> "$HISTORY_FILE"
    else
        printf "${RED}❌ Failed to get new IP!${NC}
"
    fi
}

show_banner() {
    clear
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                               SURUJ IP CHANGER                                ║${NC}"
    echo -e "${PURPLE}║                                   PRO v5.3                                    ║${NC}"
    echo -e "${PURPLE}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║  Proxy Mode : ${GREEN}${PROXY_MODE}${CYAN}                                             ║${NC}"
    if [ "$PROXY_MODE" = "privoxy" ]; then
        echo -e "${CYAN}║  HTTP Proxy : ${GREEN}127.0.0.1:8118${CYAN}                                      ║${NC}"
    else
        echo -e "${CYAN}║  SOCKS5     : ${GREEN}127.0.0.1:9050${CYAN}                                      ║${NC}"
    fi
    echo -e "${CYAN}║  Control    : ${GREEN}127.0.0.1:9051${CYAN}                                      ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
}

show_menu() {
    show_banner
    echo -e "${CYAN}Time        : ${GREEN}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}Current IP  : ${GREEN}$(get_current_ip)${NC}"
    echo -e "${CYAN}Interval    : ${GREEN}${INTERVAL}s${NC}"
    echo -e "${CYAN}Country     : ${GREEN}${COUNTRIES[$COUNTRY]:-$COUNTRY}${NC}"
    echo -e "${CYAN}Auto-Start  : ${GREEN}${AUTO_START}${NC}"
    echo -e "${CYAN}BG Mode     : ${GREEN}${BG_MODE}${NC}"
    echo
    echo "  [1] Set Interval"
    echo "  [2] Set Country"
    echo "  [3] Toggle Auto-Start"
    echo "  [4] Toggle BG Mode"
    echo "  [5] Toggle Proxy Mode"
    echo "  [6] Start IP Changer"
    echo "  [7] Manual Renew"
    echo "  [8] Show History"
    echo "  [Q] Quit"
}

set_interval() { read -r -p "Enter interval (seconds): " new_interval; if [[ "$new_interval" =~ ^[0-9]+$ ]] && [ "$new_interval" -ge 5 ]; then INTERVAL="$new_interval"; save_config; fi; sleep 1; }
set_country() { read -r -p "Enter country code (or random): " new_country; if [ -n "${COUNTRIES[$new_country]:-}" ]; then COUNTRY="$new_country"; save_config; fi; sleep 1; }
toggle_auto_start() { [ "$AUTO_START" = "true" ] && AUTO_START=false || AUTO_START=true; save_config; sleep 1; }
toggle_bg_mode() { [ "$BG_MODE" = "true" ] && BG_MODE=false || BG_MODE=true; save_config; sleep 1; }
toggle_proxy_mode() { if [ "$PROXY_MODE" = "tor" ]; then PROXY_MODE="privoxy"; start_privoxy; else PROXY_MODE="tor"; pkill privoxy 2>/dev/null || true; fi; save_config; sleep 1; }

start_ip_changer() {
    if [ "$BG_MODE" = "true" ]; then
        ( while true; do change_ip; sleep "$INTERVAL"; done ) &
        echo -e "${GREEN}Background started.${NC}"
        sleep 2
    else
        echo -e "${YELLOW}Press Ctrl+C to stop.${NC}"
        while true; do change_ip; sleep "$INTERVAL"; done
    fi
}

show_history() { echo -e "${CYAN}IP History:${NC}"; [ -f "$HISTORY_FILE" ] && tail -10 "$HISTORY_FILE" || echo "No history yet."; read -r -p "Press Enter to continue..."; }

load_config
[ "$PROXY_MODE" = "privoxy" ] && start_privoxy

while true; do
    show_menu
    read -r -p "Choose: " choice
    case "$choice" in
        1) set_interval ;;
        2) set_country ;;
        3) toggle_auto_start ;;
        4) toggle_bg_mode ;;
        5) toggle_proxy_mode ;;
        6) start_ip_changer ;;
        7) change_ip ;;
        8) show_history ;;
        q|Q) exit 0 ;;
        *) printf "${RED}Invalid choice.${NC}
"; sleep 1 ;;
    esac
done