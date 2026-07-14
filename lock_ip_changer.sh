#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  SURUJ IP CHANGER - LOCK & ENCRYPT SYSTEM
# ============================================================

PASSWORD="SURUJ@2026"
MAX_ATTEMPTS=3

MAIN_SCRIPT="/data/data/com.termux/files/usr/share/ip-changer/ip-changer.sh"
LOCKED_SCRIPT="/data/data/com.termux/files/usr/share/ip-changer/ip-changer.lock"
LAUNCHER="/data/data/com.termux/files/usr/bin/ip-changer"

if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "\033[1;31m❌ Main script not found! Install IP Changer first.\033[0m"
    exit 1
fi

echo -e "\033[1;36m🔒 Creating encrypted lock system...\033[0m"

cat > "$LOCKED_SCRIPT" << 'LOCKEOF'
#!/data/data/com.termux/files/usr/bin/bash

REAL_PASS="SURUJ@2026"
MAX_ATTEMPTS=3

attempt=0
while [ $attempt -lt $MAX_ATTEMPTS ]; do
    echo -e "\033[1;36m🔐 Enter password to unlock IP Changer:\033[0m"
    read -s user_pass
    echo ""
    
    if [ "$user_pass" == "$REAL_PASS" ]; then
        echo -e "\033[1;32m✅ Access granted! Loading IP Changer...\033[0m"
        break
    else
        attempt=$((attempt + 1))
        left=$((MAX_ATTEMPTS - attempt))
        echo -e "\033[1;31m❌ Wrong password! $left attempts left.\033[0m"
    fi
done

if [ $attempt -ge $MAX_ATTEMPTS ]; then
    echo -e "\033[1;31m🔒 Too many failed attempts! Exiting...\033[0m"
    exit 1
fi

cd /data/data/com.termux/files/usr/share/ip-changer
bash ip-changer.sh "$@"
LOCKEOF

chmod +x "$LOCKED_SCRIPT"

cat > "$LAUNCHER" << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
bash /data/data/com.termux/files/usr/share/ip-changer/ip-changer.lock "$@"
LAUNCHEREOF

chmod +x "$LAUNCHER"

echo -e "\033[1;32m✅ Lock system created successfully!\033[0m"
echo -e "\033[1;36m🔑 Password: SURUJ@2026\033[0m"
echo -e "\033[1;36m📌 To run: ip-changer\033[0m"
echo -e "\033[1;33m⚠️ Keep your password safe!\033[0m"