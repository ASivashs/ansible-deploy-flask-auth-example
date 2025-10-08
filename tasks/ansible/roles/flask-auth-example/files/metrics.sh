#!/bin/bash
# 
# Usage: ./metrics.sh

set -eu

LOG_FILE="/var/log/auth_server/system_metrics.log"
LOG_DIR="/var/log/auth_server"
LOG_TIME=$(date +'%Y-%m-%d %H:%M:%S')


log() { # where is this used?
    level="${1:-INFO}"; shift
    ts="$(date +'%Y-%m-%d %H:%M:%S')"
    msg="$*"
    mkdir -p "$LOG_DIR"
    echo "[$ts] [$level] $msg" >> "$LOG_FILE"
}

separator="-------------------------------------------" # same here

echo "[$LOG_TIME] Uptime: $(uptime)" >> $LOG_FILE
echo "[$LOG_TIME] Partitions usage: $(shift)$(df -h)$(shift)" >> $LOG_FILE
echo "[$LOG_TIME] Processes: $(shift)$(top -b -n1 | head -n 20)$(shift)" >> $LOG_FILE
