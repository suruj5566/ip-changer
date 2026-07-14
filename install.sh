#!/data/data/com.termux/files/usr/bin/bash

# Define ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

# ============================================================
#  DETECT ENVIRONMENT
# ============================================================
echo -e "${CYAN}🔍 Checking environment...${NC}"

if [ -d "/data/data/com.termux/files/usr" ]; then
    echo -e "${GREEN}✅ Termux environment detected${NC}"
    PREFIX="/data/data/com.termux/files/usr"
    IPCHANGER="$PREFIX/share/ip-changer"
    LAUNCHER_SCRIPT="$PREFIX/bin/ip-changer"
    MAIN_SCRIPT="ip-changer.sh"
    PACKAGES=("git" "curl" "tor" "privoxy" "netcat-openbsd" "tmux" "python3" "jq")
    PKG_MANAGER="pkg"
    USE_SUDO=false
else
    echo -e "${GREEN}✅ Linux environment detected${NC}"
    PREFIX="/usr"
    IPCHANGER="$PREFIX/share/ip-changer"
    LAUNCHER_SCRIPT="$PREFIX/bin/ip-changer"
    MAIN_SCRIPT="ip-changer-linux.sh"
    PACKAGES=("git" "curl" "tor" "netcat-openbsd" "tmux" "python3" "jq")
    PKG_MANAGER="apt-get"
    USE_SUDO=true
fi

echo -e "${CYAN}📁 Installation path: $IPCHANGER${NC}"
echo -e "${CYAN}📁 Launcher path: $LAUNCHER_SCRIPT${NC}"

# ============================================================
#  FUNCTION: Run commands with or without sudo
# ============================================================
run_command() {
    if [ "$USE_SUDO" = true ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# ============================================================
#  FUNCTION: Install packages
# ============================================================
install_packages() {
    echo -e "${CYAN}🛠️ Checking and installing required packages...${NC}"
    
    if [ "$USE_SUDO" = true ]; then
        echo -e "${YELLOW}🔄 Updating package lists...${NC}"
        run_command $PKG_MANAGER update -y
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Failed to update package lists!${NC}"
            exit 1
        fi
        echo -e "${GREEN}✅ Package lists updated${NC}"
    fi
    
    for pkg in "${PACKAGES[@]}"; do
        if ! dpkg -s $pkg &>/dev/null 2>&1; then
            echo -e "${YELLOW}🚀 Installing $pkg...${NC}"
            if [ "$USE_SUDO" = true ]; then
                run_command $PKG_MANAGER install -y $pkg
            else
                run_command $PKG_MANAGER install $pkg -y
            fi
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ $pkg installed successfully!${NC}"
            else
                echo -e "${RED}❌ Failed to install $pkg${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}✅ $pkg is already installed.${NC}"
        fi
    done
}

# ============================================================
#  FUNCTION: Setup repository
# ============================================================
setup_repository() {
    echo -e "${CYAN}📦 Setting up Ip-Changer repository...${NC}"
    
    if [ -d "$IPCHANGER" ]; then
        echo -e "${YELLOW}📂 Directory exists. Updating repository...${NC}"
        cd "$IPCHANGER" || exit
        
        if [ -d ".git" ]; then
            git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Repository updated successfully!${NC}"
            else
                echo -e "${YELLOW}⚠️ Could not pull. Re-cloning...${NC}"
                cd ..
                rm -rf "$IPCHANGER"
                setup_repository
                return
            fi
        else
            echo -e "${YELLOW}⚠️ Not a git repo. Re-cloning...${NC}"
            cd ..
            rm -rf "$IPCHANGER"
            setup_repository
            return
        fi
    else
        echo -e "${YELLOW}📥 Cloning repository...${NC}"
        run_command mkdir -p "$IPCHANGER"
        git clone https://github.com/anonymousproofficial/Anonymousproofficial-YTB-Mobile.git "$IPCHANGER" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Repository cloned successfully!${NC}"
            if [ "$USE_SUDO" = true ]; then
                run_command chown -R $(whoami) "$IPCHANGER"
            fi
        else
            echo -e "${RED}❌ Failed to clone repository!${NC}"
            exit 1
        fi
    fi
    
    if [ -f "$IPCHANGER/$MAIN_SCRIPT" ]; then
        echo -e "${GREEN}✅ Main script found: $MAIN_SCRIPT${NC}"
    else
        echo -e "${RED}❌ Main script not found: $IPCHANGER/$MAIN_SCRIPT${NC}"
        echo -e "${YELLOW}📋 Available files:${NC}"
        ls -la "$IPCHANGER/"
        exit 1
    fi
}

# ============================================================
#  FUNCTION: Create launcher script
# ============================================================
create_launcher() {
    echo -e "${CYAN}📝 Creating launcher script at $LAUNCHER_SCRIPT...${NC}"
    
    run_command mkdir -p "$(dirname "$LAUNCHER_SCRIPT")"
    
    run_command bash -c "cat > \"$LAUNCHER_SCRIPT\"" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd /data/data/com.termux/files/usr/share/ip-changer
bash ip-changer.sh "$@"
EOF

    if [ $? -eq 0 ]; then
        run_command chmod +x "$LAUNCHER_SCRIPT"
        echo -e "${GREEN}✅ Launcher script created and made executable!${NC}"
    else
        echo -e "${RED}❌ Failed to create launcher script!${NC}"
        exit 1
    fi
}

# ============================================================
#  MAIN INSTALLATION
# ============================================================
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   SURUJ IP Changer Installer v4.1${NC}"
echo -e "${BLUE}========================================${NC}"

install_packages
setup_repository
create_launcher

# ============================================================
#  FINAL MESSAGE
# ============================================================
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo -e "${CYAN}🚀 You can now run: ${GREEN}ip-changer${NC}"
echo -e "${CYAN}📂 Installed at: $IPCHANGER${NC}"
echo -e "${BLUE}========================================${NC}"