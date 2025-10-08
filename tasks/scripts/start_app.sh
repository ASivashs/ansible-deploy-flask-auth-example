#!/bin/bash
# ./start_flask_app.sh - Running Flask app with venv and dependencies.
# Usage: ./start_flask_app.sh <path_to_run_file> [path_to_venv] [path_to_requirements]

set -eu


SCRIPT_NAME="$(basename $0)"
LOG_DIR="."
LOG_FILE="./start_flask_app.log"
DEFAULT_VENV_NAME="venv"
DEFAULT_REQUIREMENTS_NAME="requirements.txt"


usage(){
    cat <<EOF >&2
Usage: $SCRIPT_NAME <path_to_run_file> [path_to_venv]
    <path_to_run_file> - path to python flask app.
    [path_to_venv]     - path to venv for flask app (\"venv\" by default).
    [path_to_requirements] - path to requirements file fir flask app (if not specified looking for \"requirements.txt\").
EOF
    exit 1
}

log(){
    level="${1:-INFO}"; shift
    ts="$(date +'%Y-%m-%d %H:%M:%S')"
    msg="$*"
    mkdir -p $LOG_DIR
    echo "[$ts] [$level] $msg" >> "$LOG_FILE"
}

error(){
    log "ERROR $*"
    exit 1
}


# Arguments
if [[ $# -lt 1 || $# -gt 3 ]]; then
    exit 1
fi

RUNFILE="$1"
VENV_DIR_NAME="${2:-$DEFAULT_VENV_NAME}"
REQUIREMENTS="${3:-0}"


# Checking run file
if [[ ! -f "$RUNFILE" ]]; then
    error "Python flask app running file '$RUNFILE' not found."
else
    log "INFO" "Python flask app running file '$RUNFILE' successfully found." # duplicate info prefix?
fi


# VENV
if [[ ! -f "$VENV_DIR_NAME/bin/activate" ]]; then
    log "INFO" "Venv: '$VENV_DIR_NAME' not found."
    python3 -m venv "$VENV_DIR_NAME"
    log "INFO" "Venv created in '$VENV_DIR_NAME'."
else
    log "INFO" "Venv '$VENV_DIR_NAME' founded."
fi

source "$VENV_DIR_NAME/bin/activate"
log "INFO" "Venv with name '$VENV_DIR_NAME' successfully activated."


# Installing dependencies
if [[ ! -z $REQUIREMENTS && -f $REQUIREMENTS ]]; then
    log "INFO" "Installing dependencies from '$REQUIREMENTS' file."
    pip3 install -r $REQUIREMENTS
    log "INFO" "Dependencies successfully installed"
elif [[ -f $DEFAULT_REQUIREMENTS_NAME ]]; then
    log "INFO" "Requirements file not provided as argument. Trying to install requirements from local file in working directory."
    pip3 install -r $DEFAULT_REQUIREMENTS_NAME
    log "INFO" "Dependencies from local file successfully installed."
else
    log "WARNING" "Dependencies file not found. Trying to run app without it."
fi


# App running
log "INFO" "Running app '$RUNFILE'."
exec python3 "$RUNFILE"
