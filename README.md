RedOSINT Hacker Console

**Author:** Efaj Tahamid Rifat  

---

## Overview

**RedOSINT Hacker Console** is a fully automated OSINT scanner for phone numbers.  
It integrates **PhoneInfoga**, **Sherlock**, and **Holehe** with a **hacker-style console**, animations, progress bars, and generates structured reports.  

The tool produces a detailed TXT report including:

- Phone number  
- Carrier & number type  
- Linked social media accounts  
- Leaks / breaches found  
- Approximate location  
- Timestamp  

It also provides a **manual Truecaller lookup link**.

---

## ⚠️ Legal Warning

This tool is intended for **educational purposes only**.  
You must **only scan phone numbers you own or have explicit permission** to analyze.  

Unauthorized scanning may be illegal and considered a breach of privacy.

---

## Features

- Colored banner and console animations  
- ASCII progress/loading bars for each scan  
- Integration with **PhoneInfoga**, **Sherlock**, **Holehe**  
- Structured TXT report  
- Manual Truecaller lookup link  
- Auto-save/open TXT report in Termux/Linux/Colab  
- Optional API keys: **Numverify, Google CSE, Abstract API**

---

## Installation

### Requirements

- Linux / Termux / bash-compatible environment  
- Python 3  
- Git  
- Go (for PhoneInfoga)  
- pip  

### Clone Repository

```bash
git clone https://github.com/<your-username>/RedOSINT-Hacker-Console.git
cd RedOSINT-Hacker-Console
chmod +x redosint.sh


---

Quick Start

# Run the scanner
./redosint.sh

Step-by-step:

1. Confirm legal use when prompted.


2. Enter the target phone number in international format (e.g., +8801XXXXXXXXX).


3. Optionally provide API keys for enhanced scan results.


4. Watch live console animations and progress bars.


5. Check the generated TXT report (RedOSINT_<number>_<timestamp>.txt).


6. Use the manual Truecaller link provided at the end of the scan.




---

API Integration

Optionally, provide API keys to enhance scan results:

Numverify API Key

Google CSE CX & API Key

Abstract API Key


These keys will automatically integrate into PhoneInfoga scans.


---

Output Example

==============================
      REDOSINT SCANNER REPORT
==============================
Target Phone Number: +8801XXXXXXXXX
Scan Time: YYYY-MM-DD HH:MM:SS
------------------------------
Carrier: +880 Mobile
Number Type: Mobile/VOIP
------------------------------
Linked Social Accounts:
Facebook: fb.com/user123
Instagram: instagram.com/user123
Twitter: twitter.com/user123
------------------------------
Leaks/Breaches Found: 0
Approximate Location: Dhaka, Bangladesh
==============================

Full scan results from PhoneInfoga, Sherlock, Holehe are appended below this summary.


---

Truecaller Lookup

At the end of the scan, a manual Truecaller search link is provided:

https://www.truecaller.com/search/in/<number>


---

License

This project is for educational and ethical purposes only.
Do not use it for illegal activities.


---

Contributions

Feel free to fork, modify, or contribute.
Pull requests and suggestions are welcome.


---

Disclaimer

The author is not responsible for misuse.
Always follow ethical hacking guidelines.
