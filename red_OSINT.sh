#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print Enhanced ASCII Art
clear
echo -e "${RED} ██████╗ ███████╗██╗███╗   ██╗████████╗    ██████╗ ███████╗██╗███╗   ██╗████████╗"
echo "██╔═══██╗██╔════╝██║████╗  ██║╚══██╔══╝    ██╔══██╗██╔════╝██║████╗  ██║╚══██╔══╝"
echo "██║   ██║███████╗██║██╔██╗ ██║   ██║       ██████╔╝███████╗██║██╔██╗ ██║   ██║"   
echo "██║   ██║╚════██║██║██║╚██╗██║   ██║       ██╔══██╗╚════██║██║██║╚██╗██║   ██║"   
echo "╚██████╔╝███████║██║██║ ╚████║   ██║       ██║  ██║███████║██║██║ ╚████║   ██║"   
echo " ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝       ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝${NC}"
echo ""
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║  ${BLUE} ██████╗  ██████╗ ███████╗███╗   ██╗████████╗     ██████╗ ██╗███╗   ██╗████████╗ ${YELLOW}║"
echo "║  ${BLUE}██╔═══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝    ██╔════╝ ██║████╗  ██║╚══██╔══╝ ${YELLOW}║"
echo "║  ${BLUE}██║   ██║██║  ███╗█████╗  ██╔██╗ ██║   ██║       ██║  ███╗██║██╔██╗ ██║   ██║    ${YELLOW}║"
echo "║  ${BLUE}██║   ██║██║   ██║██╔══╝  ██║╚██╗██║   ██║       ██║   ██║██║██║╚██╗██║   ██║    ${YELLOW}║"
echo "║  ${BLUE}╚██████╔╝╚██████╔╝███████╗██║ ╚████║   ██║       ╚██████╔╝██║██║ ╚████║   ██║    ${YELLOW}║"
echo "║  ${BLUE} ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝        ╚═════╝ ╚═╝╚═╝  ╚═══╝   ╚═╝    ${YELLOW}║"
echo "║                                                                              ║"
echo -e "║                              ${GREEN}Author: Efaj Tahamid Rifat${YELLOW}                             ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${RED}⚠️  Warning: This tool is for legal and ethical use only.${NC}"
echo -e "${RED}⚠️  Ensure you have explicit permission before performing OSINT on any target.${NC}"
echo ""

# Install required tools
install_tools() {
    echo -e "${YELLOW}[*] Installing required tools...${NC}"
    
    if command -v apt &> /dev/null; then
        # For Debian/Ubuntu/Termux
        pkg update -y
        pkg install -y nmap whois dnsutils python3 python3-pip figlet toilet curl wget
    elif command -v yum &> /dev/null; then
        # For CentOS/RHEL
        yum update -y
        yum install -y nmap whois bind-utils python3 python3-pip curl wget
    elif command -v pacman &> /dev/null; then
        # For Arch Linux
        pacman -Syu --noconfirm nmap whois dnsutils python3 python3-pip curl wget
    fi
    
    # Install Python packages
    pip3 install phonenumbers pdfkit requests beautifulsoup4
    
    # Install wkhtmltopdf for PDF generation
    if ! command -v wkhtmltopdf &> /dev/null; then
        echo -e "${YELLOW}[*] Installing wkhtmltopdf...${NC}"
        if command -v apt &> /dev/null; then
            apt install -y wkhtmltopdf
        elif command -v yum &> /dev/null; then
            yum install -y wkhtmltopdf
        elif command -v pacman &> /dev/null; then
            pacman -S --noconfirm wkhtmltopdf
        fi
    fi
    
    # Install additional OSINT tools
    echo -e "${YELLOW}[*] Installing additional OSINT tools...${NC}"
    
    # Install PhoneInfoga
    if [ ! -f "PhoneInfoga" ]; then
        echo -e "${YELLOW}[*] Installing PhoneInfoga...${NC}"
        wget https://github.com/sundowndev/phoneinfoga/releases/latest/download/phoneinfoga_$(uname -s)_$(uname -m).tar.gz -O phoneinfoga.tar.gz
        tar xzf phoneinfoga.tar.gz
        rm phoneinfoga.tar.gz
        chmod +x PhoneInfoga
    fi
    
    echo -e "${GREEN}[+] All tools installed successfully!${NC}"
}

# Main function
main() {
    # Ask for phone number
    read -p "Enter phone number (with country code): " PHONE_NUMBER
    
    # Validate phone number format
    if [[ ! "$PHONE_NUMBER" =~ ^\+?[0-9]{7,15}$ ]]; then
        echo -e "${RED}[!] Invalid phone number format. Please include country code.${NC}"
        exit 1
    fi
    
    # Create results directory
    RESULTS_DIR="osint_results_$(date +%s)"
    mkdir -p "$RESULTS_DIR"
    
    echo -e "${YELLOW}[*] Starting comprehensive OSINT on phone number: $PHONE_NUMBER${NC}"
    echo -e "${YELLOW}[*] Results will be saved in: $RESULTS_DIR${NC}"
    
    # Phone number validation using Python
    cat > "$RESULTS_DIR/validate.py" << EOF
import phonenumbers
from phonenumbers import geocoder, carrier, timezone
import sys

def analyze_phone_number(phone_number):
    try:
        # Parse phone number
        parsed_number = phonenumbers.parse(phone_number, None)
        
        # Validate number
        is_valid = phonenumbers.is_valid_number(parsed_number)
        is_possible = phonenumbers.is_possible_number(parsed_number)
        
        # Get location
        location = geocoder.description_for_number(parsed_number, "en")
        
        # Get carrier
        carrier_name = carrier.name_for_number(parsed_number, "en")
        
        # Get timezone
        timezones = timezone.time_zones_for_number(parsed_number)
        
        # Format numbers
        national_format = phonenumbers.format_number(parsed_number, phonenumbers.PhoneNumberFormat.NATIONAL)
        international_format = phonenumbers.format_number(parsed_number, phonenumbers.PhoneNumberFormat.INTERNATIONAL)
        e164_format = phonenumbers.format_number(parsed_number, phonenumbers.PhoneNumberFormat.E164)
        
        return {
            "valid": is_valid,
            "possible": is_possible,
            "location": location,
            "carrier": carrier_name,
            "timezones": timezones,
            "national": national_format,
            "international": international_format,
            "e164": e164_format
        }
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 validate.py <phone_number>")
        sys.exit(1)
    
    phone_number = sys.argv[1]
    result = analyze_phone_number(phone_number)
    
    if "error" in result:
        print(f"Error: {result['error']}")
        sys.exit(1)
    
    print("Phone Number Analysis:")
    print(f"Valid: {result['valid']}")
    print(f"Possible: {result['possible']}")
    print(f"Location: {result['location']}")
    print(f"Carrier: {result['carrier']}")
    print(f"Timezones: {', '.join(result['timezones'])}")
    print(f"National Format: {result['national']}")
    print(f"International Format: {result['international']}")
    print(f"E164 Format: {result['e164']}")
EOF

    # Run phone number analysis
    echo -e "${YELLOW}[*] Performing phone number analysis...${NC}"
    python3 "$RESULTS_DIR/validate.py" "$PHONE_NUMBER" > "$RESULTS_DIR/phone_analysis.txt"
    
    # Check if analysis was successful
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Phone number analysis failed. Check the number format and try again.${NC}"
        exit 1
    fi
    
    # Run PhoneInfoga
    echo -e "${YELLOW}[*] Running PhoneInfoga scan...${NC}"
    ./PhoneInfoga -n "$PHONE_NUMBER" --no-ansi > "$RESULTS_DIR/phoneinfoga.txt" 2>&1
    
    # Additional OSINT checks
    echo -e "${YELLOW}[*] Performing additional OSINT checks...${NC}"
    
    # WHOIS lookup (if it's a VoIP number)
    echo -e "${BLUE}[+] WHOIS lookup${NC}" >> "$RESULTS_DIR/additional_checks.txt"
    whois "$PHONE_NUMBER" >> "$RESULTS_DIR/additional_checks.txt" 2>/dev/null || echo "WHOIS not applicable for phone numbers" >> "$RESULTS_DIR/additional_checks.txt"
    
    # Social media search simulation
    echo -e "${BLUE}[+] Social media footprint check${NC}" >> "$RESULTS_DIR/additional_checks.txt"
    echo "Checking social media platforms for mentions..." >> "$RESULTS_DIR/additional_checks.txt"
    echo "Facebook: Manual search recommended at https://facebook.com" >> "$RESULTS_DIR/additional_checks.txt"
    echo "Twitter: Manual search recommended at https://twitter.com" >> "$RESULTS_DIR/additional_checks.txt"
    echo "LinkedIn: Manual search recommended at https://linkedin.com" >> "$RESULTS_DIR/additional_checks.txt"
    echo "Instagram: Manual search recommended at https://instagram.com" >> "$RESULTS_DIR/additional_checks.txt"
    
    # Reputation check simulation
    echo -e "${BLUE}[+] Reputation check${NC}" >> "$RESULTS_DIR/additional_checks.txt"
    echo "Checking phone number reputation databases..." >> "$RESULTS_DIR/additional_checks.txt"
    echo "Truecaller: Manual check recommended" >> "$RESULTS_DIR/additional_checks.txt"
    echo "Whitepages: Manual check recommended" >> "$RESULTS_DIR/additional_checks.txt"
    echo "Spam reporting services: Manual check recommended" >> "$RESULTS_DIR/additional_checks.txt"
    
    # Generate HTML report
    echo -e "${YELLOW}[*] Generating HTML report...${NC}"
    cat > "$RESULTS_DIR/report.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Comprehensive OSINT Report for $PHONE_NUMBER</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 40px; 
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h1, h2 { 
            color: #d32f2f; 
            border-bottom: 2px solid #d32f2f;
            padding-bottom: 10px;
        }
        .section { 
            margin: 30px 0; 
            padding: 20px;
            border-left: 4px solid #d32f2f;
            background-color: #fafafa;
        }
        .result { 
            background: #f0f0f0; 
            padding: 15px; 
            border-radius: 5px;
            overflow-x: auto;
        }
        pre { 
            white-space: pre-wrap; 
            font-family: 'Courier New', Courier, monospace;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: #666;
        }
        .warning {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Comprehensive OSINT Report</h1>
        <p><strong>Target:</strong> $PHONE_NUMBER</p>
        <p><strong>Generated on:</strong> $(date)</p>
        
        <div class="warning">
            <h3>⚠️ Legal Disclaimer</h3>
            <p>This report was generated for educational purposes only. Ensure you have explicit permission before performing OSINT on any target. The author is not responsible for any misuse of this tool.</p>
        </div>
        
        <div class="section">
            <h2>Phone Number Analysis</h2>
            <div class="result">
                <pre>$(cat "$RESULTS_DIR/phone_analysis.txt")</pre>
            </div>
        </div>
        
        <div class="section">
            <h2>PhoneInfoga Scan Results</h2>
            <div class="result">
                <pre>$(cat "$RESULTS_DIR/phoneinfoga.txt")</pre>
            </div>
        </div>
        
        <div class="section">
            <h2>Additional OSINT Checks</h2>
            <div class="result">
                <pre>$(cat "$RESULTS_DIR/additional_checks.txt")</pre>
            </div>
        </div>
        
        <div class="section">
            <h2>Recommended Manual Checks</h2>
            <div class="result">
                <p>For more comprehensive results, manually check these resources:</p>
                <ul>
                    <li>Truecaller: https://www.truecaller.com</li>
                    <li>Whitepages: https://www.whitepages.com</li>
                    <li>Facebook: https://www.facebook.com</li>
                    <li>Twitter: https://www.twitter.com</li>
                    <li>LinkedIn: https://www.linkedin.com</li>
                    <li>Instagram: https://www.instagram.com</li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <p>Report generated by Red OSINT Framework</p>
            <p>Author: Efaj Tahamid Rifat</p>
        </div>
    </div>
</body>
</html>
EOF

    # Convert HTML to PDF
    echo -e "${YELLOW}[*] Generating PDF report...${NC}"
    if command -v wkhtmltopdf &> /dev/null; then
        wkhtmltopdf --enable-local-file-access "$RESULTS_DIR/report.html" "$RESULTS_DIR/report.pdf" >/dev/null 2>&1
        echo -e "${GREEN}[+] PDF report saved as $RESULTS_DIR/report.pdf${NC}"
    else
        echo -e "${RED}[!] wkhtmltopdf not found. Saving report as HTML only.${NC}"
        echo -e "${YELLOW}[*] You can convert it to PDF using: wkhtmltopdf $RESULTS_DIR/report.html report.pdf${NC}"
    fi
    
    echo -e "${GREEN}[+] OSINT process completed!${NC}"
    echo -e "${GREEN}[+] Results saved in: $RESULTS_DIR${NC}"
}

# Install tools and run main function
install_tools
main
