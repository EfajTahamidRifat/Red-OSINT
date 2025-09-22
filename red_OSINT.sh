#!/bin/bash

# ==============================
# RedOSINT Hacker Console
# Author: Efaj Tahamid Rifat
# Fully Automated Phone Number OSINT Scanner
# ==============================

# Banner
echo "██████╗ ███████╗██████╗  ██████╗ ████████╗██╗   ██╗███████╗"
echo "███╗   ██╗ ██╔══██╗██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║   ██║"
echo "████╗  ██║ ██████╔╝█████╗  ██████╔╝██║   ██║   ██║   ██║   ██║"
echo "██╔██╗ ██║ ██╔═══╝ ██╔══╝  ██╔═══╝ ██║   ██║   ██║   ██║   ██║"
echo "██║ ╚████║ ╚═╝     ███████╗██║     ╚██████╔╝   ██║   ╚██████╔╝"
echo "╚═╝  ╚═══╝          Fully Automated OSINT Scanner"
echo "⚠️ WARNING: Scan only numbers you OWN or have permission to scan!"

read -p "Type 'YES' to continue: " consent
if [ "$consent" != "YES" ]; then
    echo "Exiting..."
    exit 1
fi

read -p "Enter target phone number (+8801XXXXXXXXX): " phone

# API keys
read -p "Numverify API Key (leave blank to skip): " NUMVERIFY_KEY
read -p "Google CSE CX (leave blank to skip): " GOOGLE_CX
read -p "Google API Key (leave blank to skip): " GOOGLE_KEY
read -p "Abstract API Key (leave blank to skip): " ABSTRACT_KEY

# Create output file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT="RedOSINT_${phone}_${TIMESTAMP}.txt"
echo "Generating report: $OUTPUT"

# Update & install dependencies
echo "[*] Installing required packages..."
sudo apt update -y
sudo apt install -y python3 python3-pip git make golang

# Install Python packages
pip3 install --upgrade pip
pip3 install sherlock-project colorama

# Clone PhoneInfoga if not exists
if [ ! -d "phoneinfoga" ]; then
    echo "[*] Cloning PhoneInfoga..."
    git clone https://github.com/sundowndev/phoneinfoga.git
fi

# Build PhoneInfoga
cd phoneinfoga
if [ ! -f "./phoneinfoga" ]; then
    echo "[*] Building PhoneInfoga..."
    go install github.com/swaggo/swag/cmd/swag@latest
    export PATH=$PATH:$(go env GOPATH)/bin
    make build
fi
cd ..

# ==============================
# Run Scans
# ==============================

# PhoneInfoga scan
if [ -f "phoneinfoga/phoneinfoga" ]; then
    echo "[*] Running PhoneInfoga..."
    ./phoneinfoga/phoneinfoga scan -n $phone > "../$OUTPUT"
else
    echo "[!] PhoneInfoga binary not found. Skipping..." >> "../$OUTPUT"
fi

# Sherlock scan (username fallback)
echo "[*] Running Sherlock (optional, requires username)..."
read -p "Enter username for Sherlock scan (or leave blank to skip): " username
if [ ! -z "$username" ]; then
    sherlock $username >> "../$OUTPUT"
fi

# Truecaller manual link
echo "Manual Truecaller lookup: https://www.truecaller.com/search/in/$phone" >> "../$OUTPUT"

echo "[✔] Scan complete! Report saved: $OUTPUT"
