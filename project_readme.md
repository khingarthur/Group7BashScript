👤 Author
Group 7
Date: July 4th 2025



Log Analysis and Alert System

Project Overview

This project provides a lightweight, automated log monitoring system that analyzes system logs for security and error events. The script scans relevant logs such as `/var/log/auth.log` and `/var/log/syslog` for signs of failed login attempts, system errors, and unauthorized access. It generates a report and optionally sends an email alert to the system administrator.

Objectives
- Detect and report failed login attempts and system errors.
- Create a dated, readable log report saved to a defined location.
- Send an email alert  if critical issues are found.
- Automate the entire process using cron to run daily.

 Technologies & Skills Used

| Skill Area     | Description |
|----------------|-------------|
| Text Processing | Uses `grep`, `wc`, and Bash utilities to search and summarize logs. |
| Shell Scripting | Implements functional design in `analyze_logs.sh` with logging, environment setup, and conditionals. |
| Automation | Scheduled daily via `cron` to ensure continuous monitoring. |
| Security | Audits log files for authentication failures and suspicious activities. |

Project Structure
myproject/
├── docs/
│ ├── project_readme.md # ← This documentation
│ └── log_report.txt # ← Generated report from script
├── logs/
│ └── analyze.log # ← Execution and event log
└── scripts/
└── analyze_logs.sh # ← Main log analysis script

How It Works
Script Execution Flow

1. Initialization:
   - Sets up environment variables.
   - Prepares the report and logs the start time.

2. Failed Login Check:
   - Searches `/var/log/auth.log` for "failed password" entries from today.

3. System Error Check:
   - Searches `/var/log/syslog` for "error" messages from today.

4. Alerting:
   - Counts total matching entries.
   - If matches > 0, an email is sent with the report.

5. Log Completion:
   - Logs completion time in `analyze.log`.

Script Breakdown (`analyze_logs.sh`)

```bash
#!/bin/bash

# Variables
REPORT=~/myproject/docs/log_report.txt
LOG=~/myproject/logs/analyze.log
EMAIL="khingarthur01@gmail.com"
DATE=$(date '+%Y-%m-%d')
HOST=$(hostname)

# Initialize files and logs
init() { ... }

# Check for failed login attempts
failed_logins() { ... }

# Check for system errors
system_errors() { ... }

# Send email if any issue is found
send_email() { ... }

# Run all analysis functions
run_analysis() {
    init
    failed_logins
    system_errors
    send_email
    echo "$DATE - Log analysis complete" >> "$LOG"
}

# Start the script
run_analysis
The script uses mail -s to send alerts. Make sure mailutils is installed.
________________________________________

Automation with Cron
To schedule the script to run daily at midnight:
crontab -e
Add the following line:
0 0 * * * /bin/bash ~/myproject/scripts/analyze_logs.sh
________________________________________

Email Configuration
Ensure you have msmtp instaledd:
sudo apt update
sudo apt install msmtp
Then configure your msmpt like below

🔹 Step 1: Create Gmail App Password
1.	Go to: https://myaccount.google.com/apppasswords
2.	Sign in and enable 2-Step Verification (if not already enabled).
3.	Generate a new App Password:
o	Select App: Mail
o	Select Device: Other (custom name) — you can name it "Ubuntu"
o	Click Generate
o	Copy the 16-character password Google gives you.

🔹 Step 2: Install msmtp and configure Gmail SMTP
sudo apt install msmtp
Create your config file:
nano ~/.msmtprc
Paste the following (replace with your actual Gmail address and app password):
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           yourgmail@gmail.com
user           yourgmail@gmail.com
password       your_app_password

account default: gmail
Save and exit (Ctrl + O, then Enter, then Ctrl + X)
Set secure permissions:
chmod 600 ~/.msmtprc

🔹 Step 3: Link mail to use msmtp
Create or edit this file:
nano ~/.mailrc
Add:
set sendmail="/usr/bin/msmtp"
set use_from=yes
set realname="System Alert"
set from="yourgmail@gmail.com"

🔹 Step 4: Test Sending Email
Try this:
echo "System check passed!" | msmtp "✅ Ubuntu Test Email" your-other-email@gmail.com
Check your inbox/spam folder.

________________________________________

Output Samples
View today's report:
cat ~/myproject/docs/log_report.txt
Check execution log:
tail ~/myproject/logs/analyze.log
________________________________________

Requirements
•	A Linux system with /var/log/auth.log and /var/log/syslog
•	Bash shell
•	smstp for sending email alerts
•	Cron service enabled for automation
________________________________________

