#!/bin/bash
# Check daemons of server and web-proxy
# Usage: ./check_server_availability.sh <name_of_services>

set -eu


LOG_FILE="/var/log/auth_server/app_server_availability.log"
LOG_DIR="/var/log/auth_server"
SERVICES=( "$@" )


log() {
    level="${1:-INFO}"; shift
    ts="$(date +'%Y-%m-%d %H:%M:%S')"
    msg="$*"
    mkdir -p "$LOG_DIR"
    echo "[$ts] [$level] $msg" >> "$LOG_FILE"
}


check_service() {
    service="$1"
    status="$(systemctl is-active "$service" 2>/dev/null)"
    log "INFO" "Service '$service' status: $status" >> $LOG_FILE
}


for srv in "${SERVICES[@]}"; do
    check_service "$srv"
done
log "INFO" "Service check completed."
