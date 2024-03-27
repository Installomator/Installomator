#!/bin/zsh --no-rcs

# MARK: Arguments/Parameters

# Parameter 4: path to the swiftDialog command file
dialog_command_file=${4:-"/var/tmp/dialog.log"}

# MARK: Constants
dialogApp="/Library/Application Support/Dialog/Dialog.app"

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
if [[ ! -d $dialogApp ]]; then
    echo "Cannot find dialog at $dialogApp"
    exit 95
fi


# close and quit dialog
dialogUpdate "progress: complete"
dialogUpdate "progresstext: Done"

# pause a moment
sleep 0.5

dialogUpdate "quit:"

# let everything catch up
sleep 0.5

# just to be safe
killall "Dialog"

# the killall command above will return error when Dialog is already quit
# but we don't want that to register as a failure in Jamf,  so always exit 0
exit 0
