#!/bin/sh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# MARK: Arguments/Parameters

# Parameter 4: Custom icon for swiftDialog. Value can be a path on the client or a URL.
icon=${4}

# Parameter 5: Remove old icon (if value is `1`) or not (default `0`). Removing the icon forces a new install of swiftDialog regardless of installed version.
removeOldIcon=${5:-0}

# MARK: sanity checks

# check minimal macOS requirement
if [[ $(sw_vers -buildVersion ) < "20A" ]]; then
    echo "This script requires at least macOS 11 Big Sur."
    exit 98
fi

# check we are running as root
if [[ $DEBUG -eq 0 && $(id -u) -ne 0 ]]; then
    echo "This script should be run as root"
    exit 97
fi

# MARK: Script

# Download icon for swiftDialog
if [[ -n $icon ]]; then
    echo "icon defined, so downloading that for Dialog!"
    dialogIconLocation="/Library/Application Support/Dialog/Dialog.png"
    if [[ $removeOldIcon -eq 1 ]]; then
        echo "Removing old icon first"
        rm "$dialogIconLocation"
    fi
    echo "$(mkdir -p "/Library/Application Support/Dialog")"
    echo "$(ls -l "/Library/Application Support/Dialog")"
    if [ -f "$dialogIconLocation" ]; then
        echo "swiftDialog icon already exists, so skipping this."
    elif ! curl -fs "$icon" -o "$dialogIconLocation"; then
        echo "ERROR downloading $icon"
        echo "No icon logo for swiftDialog has been set."
    else
        echo "Icon for Dialog downloaded."
        echo "$(ls -l "${dialogIconLocation}")"
        INSTALL=force
    fi
fi
