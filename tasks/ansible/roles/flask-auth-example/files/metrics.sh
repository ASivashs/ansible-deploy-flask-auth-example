#!/bin/bash
# 
# Usage: ./metrics.sh

set -eu

LOG_FILE="/var/log/auth_server/system_metrics.log"
LOG_DIR="/var/log/auth_server"
LOG_TIME=$(date +'%Y-%m-%d %H:%M:%S')


log() {
    level="${1:-INFO}"; shift
    ts="$(date +'%Y-%m-%d %H:%M:%S')"
    msg="$*"
    mkdir -p "$LOG_DIR"
    echo "[$ts] [$level] $msg" >> "$LOG_FILE"
}

log "INFO" "Uptime: $(uptime)"
log "INFO" "Partitions usage: $(shift)$(df -h)$(shift)"
log "INFO" "Processes: $(shift)$(top -b -n1 | head -n 20)$(shift)"
