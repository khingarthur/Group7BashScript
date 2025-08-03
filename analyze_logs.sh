#!/bin/bash

# Environment variables
REPORT=~/myproject/docs/log_report.txt
LOG=~/myproject/logs/analyze.log
EMAIL="khingarthur01@gmail.com"
DATE=$(date '+%Y-%m-%d')
HOST=$(hostname)

# Initialize logs
init() {
    echo "$DATE - Starting log analysis" >> "$LOG"
    echo "Log Report - $DATE" > "$REPORT"
    echo "==============================" >> "$REPORT"
    echo "" >> "$REPORT"
}

# check for failed Login attepts today
failed_logins() {
    echo "[Failed Login Attempts]" >> "$REPORT"
    grep -i "failed password" /var/log/auth.log | grep "$DATE" >> "$REPORT"
    echo "" >> "$REPORT"
}

# Check for system errors today
system_errors() {
    echo "[System Errors]" >> "$REPORT"
    grep -i "error" /var/log/syslog | grep "$DATE" >> "$REPORT"
    echo "" >> "$REPORT"
}

# Send email if errors are found
send_email() {
    local count
    count=$(grep -iE "error|failed|unauthorized|denied" "$REPORT" | grep "$DATE" | wc -l)

    if [ "$count" -gt 0 ]; then
        echo "$DATE - Issues found. Sending email to $EMAIL" >> "$LOG"
        mail -s "Log Alert on $HOST" "$EMAIL" < "$REPORT"

    else
        echo "$DATE - No critical issues found." >> "$LOG"
    fi
}

# Function to initialize environment
run_analysis() {
    init
    failed_logins
    system_errors
    send_email
    echo "$DATE - Log analysis complete" >> "$LOG"
    echo "" >> "$LOG"
}

# RUN SCRIPT 
run_analysis
