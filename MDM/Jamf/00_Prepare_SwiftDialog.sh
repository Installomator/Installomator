#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# MARK: Constants

dialog="/usr/local/bin/dialog"

dialog_command_file=${4:-"/var/tmp/dialog.log"}
message=${5:-"Self Service Progress"}
icon=${6:-"/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"}

# MARK: Functions

dialogUpdate() {
    # $1: dialog command
    local dcommand=$1

    if [[ -n $dialog_command_file ]]; then
        echo "$dcommand" >> $dialog_command_file
        echo "Dialog: $dcommand"
    fi
}

# MARK: sanity checks

# check minimal macOS requirement
if [[ $(sw_vers -buildVersion ) < "20" ]]; then
    echo "This script requires at least macOS 11 Big Sur."
    exit 98
fi

# check we are running as root
if [[ $DEBUG -eq 0 && $(id -u) -ne 0 ]]; then
    echo "This script should be run as root"
    exit 97
fi

# check for Swift Dialog
if [[ ! -x $dialog ]]; then
    echo "Cannot find dialog at $dialog"
    exit 95
fi


# MARK: Setup

# display first screen
open -a /Library/Application\ Support/Dialog/Dialog.app --args \
        --title none \
        --icon "$icon" \
        --message "$message" \
        --mini \
        --progress 100 \
        --position bottomright \
        --ontop \
        --movable \
        --commandfile $dialog_command_file

sleep 0.1
