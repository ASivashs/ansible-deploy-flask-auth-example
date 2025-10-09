#!/bin/bash
# Backup file with time and date and time prefix in backed up file name.
# Usage: ./db_backup.sh <file_location> <backup_directory>

set -eu


SCRIPT_NAME="$(basename $0)"
LOG_FILE="/var/log/auth_server/database_backup.log"
LOG_DIR="/var/log/auth_server"

TIMESTAMP=$(date +'%Y%m%d%H%M%S')


if [[ ! $# -eq 2 ]]; then
    exit 1
fi

DATABASE_LOCATION="$1"
BACKUP_LOCATION="$2"


usage(){
    cat <<EOF >&2
Usage: $SCRIPT_NAME <file_location> <backup_directory>
    <file_location>    - location of file for backup.
    [backup_directory] - directory for backup file.
EOF
    exit 1
}


log() {
    level="${1:-INFO}"; shift
    ts="$(date +'%Y-%m-%d %H:%M:%S')"
    msg="$*"
    mkdir -p "$LOG_DIR"
    echo "[$ts] [$level] $msg" >> $LOG_FILE
}


backup_database() {
    file_name="$1"
    new_backup_path="$BACKUP_LOCATION/${TIMESTAMP}_${file_name}"

    if [[ ! -f "$DATABASE_LOCATION" ]]; then
        log "ERROR" "Database not found at \"$DATABASE_LOCATION\"."
        exit 1
    fi

    mkdir -p "$BACKUP_LOCATION"
    cp "$DATABASE_LOCATION" "$new_backup_path"
    log "INFO" "Database backed up to \"$new_backup_path\"."
}


file_name="${DATABASE_LOCATION##*/}"

backup_database $file_name
