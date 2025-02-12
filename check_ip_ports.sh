#!/bin/bash

# Define log file
LOG_FILE="log.txt"

# Get system IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Check if IP was retrieved
if [[ -z "$IP_ADDRESS" ]]; then
    echo "Error: Unable to retrieve IP address" | tee -a "$LOG_FILE"
    exit 1
fi

# Log the IP address
echo "=====================================" >> "$LOG_FILE"
echo "System IP Address: $IP_ADDRESS" | tee -a "$LOG_FILE"
echo "Scanning open ports..." | tee -a "$LOG_FILE"
echo "=====================================" >> "$LOG_FILE"

# Scan for open ports using netstat/ss (alternative if netstat is not available)
if command -v netstat &>/dev/null; then
    netstat -tulnp | grep LISTEN | awk '{print $4, $1}' >> "$LOG_FILE"
elif command -v ss &>/dev/null; then
    ss -tuln | awk 'NR>1 {print $5, $1}' >> "$LOG_FILE"
else
    echo "Error: Neither netstat nor ss command found!" | tee -a "$LOG_FILE"
    exit 1
fi

# Print completion message
echo "Port scan completed. Check $LOG_FILE for details."


