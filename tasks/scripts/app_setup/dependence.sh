#!/bin/bash
# Installing distro-specific packages on Debian-based or Red Hat-based distros.
# Usage: ./dependence.sh (with root)

set -eu


SCRIPT_NAME="$(basename \"$0\")"
PACKAGES=( git curl python3 python3-pip wget ufw )

usage() {
    cat <<EOF >&2
Usage: sudo ./$SCRIPT_NAME
EOF
}


detect_os() {
    local os_id 
    if [[ -r /etc/os-release ]]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        os_id="$ID"
    else
        echo "/etc/os-release not found." >&2
        return 0
    fi

    case "$os_id" in 
        ubuntu | debian)
            REPO_UPDATE="apt-get update"
            PACKAGE_INSTALL="apt-get install"
            PACKAGE_CHECK="dpkg -s"
            SPECIFIC_PACKAGES=( python3-venv )
        ;;
        centos | rhel)
            REPO_UPDATE='yum makecache fast'
            PACKAGE_INSTALL='yum install -y'
            PACKAGE_CHECK='rpm -q'
            SPECIFIC_PACKAGES=( python3-virtualenv )
        ;;
        fedora)
            REPO_UPDATE='dnf makecache fast'
            PACKAGE_INSTALL='dnf install -y'
            PACKAGE_CHECK='rpm -q'
            SPECIFIC_PACKAGES=( python3-virtualenv )
        ;;
        *) 
            echo "Unsupported package manager."
            return 0
        ;;
    esac
}


detect_os

$REPO_UPDATE

PACKAGES+=( "${SPECIFIC_PACKAGES[@]}" )

for pkg in "${PACKAGES[@]}"; do
    if ! $PACKAGE_CHECK "$pkg" &> /dev/null; then
        echo "Installing: $pkg"
        $PACKAGE_INSTALL "$pkg"
    else
        echo "$pkg is already installed. Nothing to do."
    fi
done
