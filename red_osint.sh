#!/bin/bash
###############################################################################
# Red OSINT – Universal Phone Intelligence
# Author: Efaj Tahamid Rifat
# LEGAL USE ONLY – For educational & ethical research.
###############################################################################

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

clear
echo -e "${RED}"
figlet -f slant "RED OSINT"
echo -e "${NC}${YELLOW}Universal Phone OSINT Framework${NC}"
echo -e "${RED}⚠️  LEGAL USE ONLY | Get permission before scanning targets${NC}\n"

#──────────────────── Environment Detection ─────────────────────#
if command -v termux-info >/dev/null 2>&1; then
    ENV="termux"
elif grep -qi "colab" /proc/version 2>/dev/null; then
    ENV="colab"
else
    ENV="linux"
fi
echo -e "${YELLOW}[+] Detected environment:${NC} $ENV\n"

#──────────────────── Tool Installation ─────────────────────────#
install_tools() {
    echo -e "${YELLOW}[*] Installing requirements...${NC}"
    if [ "$ENV" = "termux" ]; then
        pkg update -y
        pkg install -y python python-pip git nmap whois dnsutils \
            exiftool curl wget figlet toilet
    else
        sudo apt-get update -y
        sudo apt-get install -y python3 python3-pip git nmap whois \
            dnsutils exiftool curl wget figlet toilet
    fi

    pip3 install --upgrade pip
    pip3 install phonenumbers requests beautifulsoup4 pdfkit --quiet

    if [ "$ENV" != "termux" ]; then
        sudo apt-get install -y wkhtmltopdf || echo "[!] wkhtmltopdf optional"
    fi
    echo -e "${GREEN}[+] Installation complete!${NC}\n"
}

#──────────────────── Input Validation ──────────────────────────#
is_digits() { [[ "$1" =~ ^[0-9]{4,15}$ ]]; }

#──────────────────── Main Scanner ──────────────────────────────#
run_scan() {
    OUT="RedOSINT_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$OUT"

    while true; do
        read -p "Enter country code (no +, e.g. 880 for BD): " CC
        is_digits "$CC" && break || echo -e "${RED}[!] Digits only.${NC}"
    done

    while true; do
        read -p "Enter phone number (without country code): " NUM
        is_digits "$NUM" && break || echo -e "${RED}[!] Digits only.${NC}"
    done

    TARGET="+$CC$NUM"
    echo -e "${YELLOW}[*] Target:${NC} $TARGET\n"

    echo -e "${YELLOW}[*] Analyzing phone number...${NC}"
    cat > "$OUT/phone_check.py" <<'PY'
import sys,phonenumbers
from phonenumbers import geocoder,carrier,timezone
num=sys.argv[1]
p=phonenumbers.parse(num,None)
print("Target:",num)
print("Valid:",phonenumbers.is_valid_number(p))
print("Possible:",phonenumbers.is_possible_number(p))
print("Location:",geocoder.description_for_number(p,"en"))
print("Carrier:",carrier.name_for_number(p,"en"))
print("Timezones:",timezone.time_zones_for_number(p))
print("International:",phonenumbers.format_number(p,phonenumbers.PhoneNumberFormat.INTERNATIONAL))
print("E164:",phonenumbers.format_number(p,phonenumbers.PhoneNumberFormat.E164))
PY
    python3 "$OUT/phone_check.py" "$TARGET" > "$OUT/phone_info.txt"

    echo -e "${YELLOW}[*] Generating HTML report...${NC}"
    cat > "$OUT/report.html" <<EOF
<!DOCTYPE html><html><head>
<meta charset="UTF-8"><title>Red OSINT Report</title>
<style>
body{font-family:Arial;background:#f5f5f5;padding:20px;}
.container{background:#fff;padding:20px;border-radius:8px;}
h1{color:#d32f2f;}pre{background:#eee;padding:10px;border-radius:6px;}
</style></head><body><div class="container">
<h1>Red OSINT Report</h1>
<p><b>Date:</b> $(date)</p>
<h2>Phone Analysis</h2><pre>$(cat "$OUT/phone_info.txt")</pre>
</div></body></html>
EOF

    if command -v wkhtmltopdf >/dev/null 2>&1; then
        wkhtmltopdf --enable-local-file-access "$OUT/report.html" "$OUT/report.pdf" >/dev/null 2>&1
        echo -e "${GREEN}[+] PDF saved as $OUT/report.pdf${NC}"
    else
        echo -e "${RED}[!] wkhtmltopdf not found. PDF not generated.${NC}"
    fi

    cp "$OUT/phone_info.txt" "$OUT/RedOSINT_${TARGET}.txt"
    echo -e "${GREEN}[+] Reports saved in folder: $OUT${NC}\n"
    ls -lh "$OUT"

    #────────── Google Drive Auto Save (Colab only) ──────────#
    if [ "$ENV" = "colab" ]; then
        echo -e "${YELLOW}[*] Attempting to copy report to Google Drive...${NC}"
        if [ -d "/content/drive/MyDrive" ]; then
            cp "$OUT/report.pdf" "/content/drive/MyDrive/" 2>/dev/null \
                && echo -e "${GREEN}[+] Copied report.pdf to MyDrive${NC}" \
                || echo -e "${RED}[!] Drive copy failed. Check if Drive is mounted.${NC}"
        else
            echo -e "${RED}[!] Google Drive not mounted. Use 'from google.colab import drive; drive.mount(\"/content/drive\")' in a Colab cell first.${NC}"
        fi
    fi
}

#──────────────────── Execute ────────────────────────────────#
install_tools
run_scan
