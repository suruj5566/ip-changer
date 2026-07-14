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
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $NEW_IP" >> ~/.ip