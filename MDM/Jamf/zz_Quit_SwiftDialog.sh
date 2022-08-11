#!/bin/zsh

dialog="/usr/local/bin/dialog"
dialog_command_file=${4:-"/var/tmp/dialog.log"}

dialogUpdate() {
    # $1: dialog command
    local dcommand="$1"

    if [[ -n $dialog_command_file ]]; then
        echo "$dcommand" >> "$dialog_command_file"
        echo "Dialog: $dcommand"
    fi
}

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

# check for Swift Dialog
if [[ ! -x $dialog ]]; then
    echo "Cannot find dialog at $dialog"
    exit 95
fi


# close and quit dialog
dialogUpdate "progress: complete"
dialogUpdate "progresstext: Done"

sleep 0.5

dialogUpdate "quit:"

# just to be safe
killall "Dialog"

exit 0
