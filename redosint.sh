#!/bin/bash

# Red OSINT Framework - Full Linux/Termux/Codespaces Version
# Author: Efaj Tahamid Rifat

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${RED}██████╗ ███████╗██████╗ ██╗███╗   ██╗████████╗"
echo "██╔═══██╗██╔════╝██╔══██╗██║████╗  ██║╚══██╔══╝"
echo "██║   ██║█████╗  ██║  ██║██║██╔██╗ ██║   ██║   "
echo "██║   ██║██╔══╝  ██║  ██║██║██║╚██╗██║   ██║   "
echo "╚██████╔╝███████╗██████╔╝██║██║ ╚████║   ██║   "
echo " ╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝   ╚═╝   ${NC}"
echo -e "${YELLOW}⚠️  Legal Use Only! Only scan numbers you own or have permission for.${NC}\n"

# Function: Install dependencies
install_tools() {
    echo -e "${YELLOW}[*] Installing required tools...${NC}"
    apt-get update -y >/dev/null 2>&1
    apt-get install -y python3 python3-pip curl wget figlet toilet wkhtmltopdf nmap whois dnsutils >/dev/null 2>&1
    pip3 install phonenumbers beautifulsoup4 requests pdfkit >/dev/null 2>&1
    echo -e "${GREEN}[+] All tools installed successfully!${NC}\n"
}

# Function: Validate phone number
validate_phone_number() {
    local phone=$1
    if [[ ! "$phone" =~ ^\+[0-9]{7,15}$ ]]; then
        return 1
    fi
    return 0
}

# Main function
main() {
    echo -e "${BLUE}Enter phone number with country code (e.g., +8801234567890)${NC}"
    
    while true; do
        read -p "Target phone number: " PHONE
        if validate_phone_number "$PHONE"; then
            break
        else
            echo -e "${RED}[!] Invalid format. Include + and country code (e.g., +8801234567890)${NC}"
        fi
    done

    RESULTS_DIR="osint_results_$(date +%s)"
    mkdir -p "$RESULTS_DIR"

    echo -e "${YELLOW}[*] Performing OSINT for $PHONE ...${NC}"

    # Phone number analysis (Python)
    cat > "$RESULTS_DIR/validate.py" << 'PYEOF'
import phonenumbers
from phonenumbers import geocoder, carrier, timezone
import sys

phone_number = sys.argv[1]
try:
    parsed = phonenumbers.parse(phone_number, None)
    valid = phonenumbers.is_valid_number(parsed)
    possible = phonenumbers.is_possible_number(parsed)
    location = geocoder.description_for_number(parsed, "en")
    carrier_name = carrier.name_for_number(parsed, "en")
    tz = timezone.time_zones_for_number(parsed)
    national = phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.NATIONAL)
    international = phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.INTERNATIONAL)
    e164 = phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.E164)
    result = f"""
Valid: {valid}
Possible: {possible}
Location: {location}
Carrier: {carrier_name}
Timezones: {', '.join(tz) if tz else 'N/A'}
National Format: {national}
International Format: {international}
E164 Format: {e164}
"""
    print(result)
except Exception as e:
    print(f"Error: {e}")
PYEOF

    python3 "$RESULTS_DIR/validate.py" "$PHONE" > "$RESULTS_DIR/phone_analysis.txt"

    # Additional OSINT recommendations
    echo -e "${BLUE}[*] Creating additional checks recommendations...${NC}"
    cat > "$RESULTS_DIR/additional_checks.txt" << EOF
WHOIS: Typically for domains/IPs only
Social Media Check:
- Facebook: https://facebook.com
- Twitter: https://twitter.com
- LinkedIn: https://linkedin.com
- Instagram: https://instagram.com
- Truecaller: https://www.truecaller.com
- Whitepages: https://www.whitepages.com
EOF

    # Generate HTML report
    cat > "$RESULTS_DIR/report.html" << EOF
<!DOCTYPE html>
<html>
<head>
<title>OSINT Report - $PHONE</title>
<style>
body {font-family: Arial; background: #f5f5f5; margin:20px;}
.container {background:white; padding:20px; border-radius:8px; max-width:1000px; margin:auto; box-shadow:0 0 10px rgba(0,0,0,0.1);}
h1, h2 {color:#d32f2f;}
.section {margin:20px 0; padding:15px; border-left:3px solid #d32f2f; background:#fafafa;}
.result {background:#f0f0f0; padding:10px; border-radius:4px; overflow-x:auto;}
.footer {text-align:center; margin-top:20px; padding-top:15px; border-top:1px solid #eee; color:#666;}
.warning {background:#fff3cd; border-left:4px solid #ffc107; padding:15px; margin:15px 0; border-radius:4px;}
pre {white-space:pre-wrap; font-family:Courier, monospace;}
</style>
</head>
<body>
<div class="container">
<h1>OSINT Report - $PHONE</h1>
<p><strong>Generated:</strong> $(date)</p>
<div class="warning">
<h3>⚠️ Legal Disclaimer</h3>
<p>Educational purposes only. Use with permission. Author not responsible for misuse.</p>
</div>
<div class="section">
<h2>Phone Number Analysis</h2>
<div class="result"><pre>$(cat "$RESULTS_DIR/phone_analysis.txt")</pre></div>
</div>
<div class="section">
<h2>Additional Recommendations</h2>
<div class="result"><pre>$(cat "$RESULTS_DIR/additional_checks.txt")</pre></div>
</div>
<div class="footer"><p>Red OSINT Framework</p></div>
</div>
</body>
</html>
EOF

    # Convert HTML to PDF
    if command -v wkhtmltopdf >/dev/null 2>&1; then
        wkhtmltopdf --enable-local-file-access "$RESULTS_DIR/report.html" "$RESULTS_DIR/report.pdf" >/dev/null 2>&1
        echo -e "${GREEN}[+] PDF report generated: $RESULTS_DIR/report.pdf${NC}"
    else
        echo -e "${RED}[!] wkhtmltopdf not installed. HTML report only.${NC}"
    fi

    echo -e "${GREEN}[+] OSINT complete! Results saved in: $RESULTS_DIR${NC}"
    ls -la "$RESULTS_DIR"
}

# Run
install_tools
main
