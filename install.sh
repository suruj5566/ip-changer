#!/bin/bash

# ==========================================
# 🔥 IP CHANGER - SURUJ EDITION (INSTALLER)
# ==========================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

clear
echo -e "${CYAN}  ═══════════════════════════════════${NC}"
echo -e "${CYAN}     🔥 ${MAGENTA}SURUJ EDITION${CYAN} 🔥${NC}"
echo -e "${CYAN}     ${GREEN}IP CHANGER PRO${NC}"
echo -e "${CYAN}  ═══════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}[+] Updating Termux packages...${NC}"
pkg update && pkg upgrade -y

echo -e "${YELLOW}[+] Installing required packages...${NC}"
pkg install tor privoxy curl netcat-openbsd -y

echo -e "${YELLOW}[+] Making script executable...${NC}"
chmod +x ip-changer.sh

echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${BLUE}🌐 Now run: ${CYAN}./ip-changer.sh${NC}"
echo -e "${CYAN}  ═══════════════════════════════════${NC}"