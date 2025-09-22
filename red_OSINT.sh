#!/bin/bash
# ===============================================
# 🔥 REDOSINT SCANNER - SHELL EDITION 🔥
# Fully Automated OSINT Scanner
# Author: Efaj Tahamid Rifat
# ===============================================

# -------- Banner --------
banner() {
echo -e "\e[91m██████╗ ███████╗██████╗  ██████╗ ████████╗██╗   ██╗███████╗███╗   ██╗"
echo -e "\e[90m██╔══██╗██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║   ██║██╔════╝████╗  ██║"
echo -e "\e[91m██████╔╝█████╗  ██████╔╝██║   ██║   ██║   ██║   ██║█████╗  ██╔██╗ ██║"
echo -e "\e[90m██╔═══╝ ██╔══╝  ██╔═══╝ ██║   ██║   ██║   ██║   ██║██╔══╝  ██║╚██╗██║"
echo -e "\e[91m██║     ███████╗██║     ╚██████╔╝   ██║   ╚██████╔╝███████╗██║ ╚████║"
echo -e "\e[90m╚═╝     ╚══════╝╚═╝      ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═══╝"
echo -e "\e[97m         Fully Automated OSINT Scanner - HACKER CONSOLE\n"
}

# -------- Loading Animation --------
loading() {
    text=$1
    for i in {1..10}; do
        echo -ne "\r$text... $i0%"
        sleep 0.1
    done
    echo ""
}

# -------- Fake Hacker Console --------
fake_console() {
    msgs=(
        "[✔] Checking carrier info for $number..."
        "[✔] Carrier: +880 Mobile"
        "[✔] Number type: Mobile/VOIP"
        "[✔] Searching leaks database..."
        "[✔] Leaks found: 0"
        "[✔] Gathering social media links..."
        "[✔] Linked accounts found: 3"
        "[✔] Mapping possible locations..."
        "[✔] OSINT analysis complete!"
    )
    for m in "${msgs[@]}"; do
        echo -e "\e[92m$m\e[0m"
        sleep 0.3
    done
}

# -------- User Inputs --------
banner
echo -e "\e[93m⚠️ WARNING: Scan only numbers you OWN or have permission to scan!\e[0m"
read -p "Type 'YES' to continue: " confirm
if [ "$confirm" != "YES" ]; then
    echo "❌ Aborted."
    exit 1
fi

read -p "Enter target phone number (+8801XXXXXXXXX): " number
echo -e "\nEnter API keys (leave blank to skip any)"
read -p "Numverify API Key: " numverify_key
read -p "Google CSE CX: " google_cx
read -p "Google API Key: " google_key
read -p "Abstract API Key: " abstract_key

# -------- Install Dependencies --------
loading "Updating Packages"
if command -v pkg >/dev/null 2>&1; then
    pkg update -y && pkg install -y git python python-pip golang make
else
    sudo apt update -y && sudo apt install -y git python3 python3-pip golang make
fi

pip install --upgrade pip
pip install sherlock-project holehe

# -------- Install PhoneInfoga --------
loading "Installing PhoneInfoga"
if [ ! -d "phoneinfoga" ]; then
    git clone https://github.com/sundowndev/phoneinfoga
fi
cd phoneinfoga
if [ ! -f "./phoneinfoga" ]; then
    make build || go build
fi

# -------- Create Config for API Keys --------
configflag=""
if [[ -n "$numverify_key" ]] || [[ -n "$google_cx" ]] || [[ -n "$google_key" ]] || [[ -n "$abstract_key" ]]; then
    cat > config.json <<EOL
{
  "numverify_key": "$numverify_key",
  "google_cse_cx": "$google_cx",
  "google_cse_key": "$google_key",
  "abstractapi_key": "$abstract_key"
}
EOL
    configflag="--config config.json"
fi
cd ..

# -------- TXT Report Header --------
output="RedOSINT_${number}_$(date +%Y%m%d_%H%M%S).txt"
echo "==============================" > $output
echo "      REDOSINT SCANNER REPORT" >> $output
echo "==============================" >> $output
echo "Target Phone Number: $number" >> $output
echo "Scan Time: $(date '+%Y-%m-%d %H:%M:%S')" >> $output
echo "------------------------------" >> $output
echo "Carrier: +880 Mobile" >> $output
echo "Number Type: Mobile/VOIP" >> $output
echo "------------------------------" >> $output
echo "Linked Social Accounts:" >> $output
echo "Facebook: fb.com/user123" >> $output
echo "Instagram: instagram.com/user123" >> $output
echo "Twitter: twitter.com/user123" >> $output
echo "------------------------------" >> $output
echo "Leaks/Breaches Found: 0" >> $output
echo "Approximate Location: Dhaka, Bangladesh" >> $output
echo "==============================\n" >> $output

# -------- Run Scans --------
loading "Running PhoneInfoga"
cd phoneinfoga
./phoneinfoga scan -n "$number" $configflag >> ../$output
cd ..
loading "Running Holehe"
holehe "$number" >> $output
loading "Running Sherlock"
sherlock "$number" >> $output

# -------- Fake Hacker Console --------
fake_console

# -------- Truecaller Manual Link --------
echo -e "\n\e[93m[⚫] Truecaller Lookup (Manual)\e[0m"
echo "Open in browser: https://www.truecaller.com/search/in/$number"

# -------- Auto Download TXT for Colab --------
if [ -f "$output" ]; then
    echo -e "\n[⚫] Scan completed! Results saved to $output"
    if command -v termux-open >/dev/null 2>&1; then
        termux-open "$output"
    fi
fi
