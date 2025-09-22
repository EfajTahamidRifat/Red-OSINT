# 📱 Red OSINT Framework

A powerful and automated OSINT (Open Source Intelligence) framework for phone number reconnaissance. This tool combines multiple advanced techniques to gather comprehensive information about phone numbers while maintaining ethical standards.

## 🎯 Features

- **Multi-platform Compatibility**: Works on Linux, Termux (Android), and Google Colab
- **Automatic Tool Installation**: Installs all required dependencies automatically
- **Advanced Phone Analysis**: Uses PhoneInfoga and Google's libphonenumber for detailed analysis
- **Comprehensive Reporting**: Generates both HTML and PDF reports with professional formatting
- **Legal Compliance**: Includes clear warnings and disclaimers for ethical use
- **Rich Information Gathering**:
  - Phone number validation and formatting
  - Geographic location identification
  - Carrier and timezone detection
  - Social media footprint analysis
  - Reputation database checks
  - Manual verification recommendations

## 🚀 Installation & Usage

```bash
# Clone the repository
git clone https://github.com/yourusername/red-osint.git
cd red-osint

# Make the script executable
chmod +x advanced_phone_osint.sh

# Run the tool
./advanced_phone_osint.sh
```

The script will automatically:
1. Install all required tools and dependencies
2. Prompt for a phone number (with country code)
3. Perform comprehensive OSINT analysis
4. Generate detailed HTML/PDF reports

## 📋 Requirements

- Linux-based system (Debian/Ubuntu/CentOS/Arch) or Termux on Android
- Internet connection
- Approximately 300MB free disk space
- Sudo privileges (for some installations)

## ⚠️ Legal Disclaimer

This tool is for educational and legitimate security research purposes only. The author (Efaj Tahamid Rifat) does not take any responsibility for illegal or unauthorized use of this tool. Users must ensure they have explicit permission before performing OSINT on any target. Unauthorized reconnaissance may violate privacy laws and terms of service of various platforms.

The author is not liable for any damages or legal consequences resulting from the misuse of this tool. By using this software, you agree to use it ethically and in compliance with all applicable laws and regulations.

## 🛠️ Tools Included

- **PhoneInfoga**: Advanced phone number OSINT framework
- **libphonenumber**: Google's phone number validation library
- **WHOIS**: Domain and number registration information
- **Social Media Checkers**: Recommendations for manual platform searches
- **Reputation Services**: Integration with phone number reputation databases

## 📊 Sample Output

The tool generates a timestamped directory containing:
- `phone_analysis.txt`: Detailed phone number analysis
- `phoneinfoga.txt`: Results from PhoneInfoga scan
- `additional_checks.txt`: Social media and reputation checks
- `report.html`: Comprehensive HTML report with styling
- `report.pdf`: Professional PDF version of the report

## 📖 Author

**Efaj Tahamid Rifat**

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Proper Usage Examples**:
- Personal security research on your own numbers
- Authorized penetration testing with written permission
- Educational purposes in controlled environments
- Recovery of your own information

**Strictly Prohibited Activities**:
- Harassing or stalking individuals
- Corporate espionage
- Identity theft or fraud
- Invasion of privacy
- Any activity that violates local, state, federal, or international laws

Any illegal or unauthorized use is strictly prohibited and entirely at the user's own risk. The author explicitly disclaims any liability for misuse of this tool.
