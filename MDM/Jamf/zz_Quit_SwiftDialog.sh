#!/bin/zsh --no-rcs

# MARK: Arguments/Parameters

# Parameter 4: SwiftDialog command file path (`/var/tmp/dialog.log`)
dialog_command_file=${4:-"/var/tmp/dialog.log"}

# Parameter 5: Jamf recon (if value is `1`) done as part of this script, so the user gets the progress in the dialog window (default `0`) Will be skipped if Installomator did not install anything.
jamf_recon=${5:-"0"}


# MARK: Constants
dialogBinary="/usr/local/bin/dialog"

dialogUpdate() {
    # $1: dialog command
    local dcommand="$1"

    if [[ -n $dialog_command_file ]]; then
        echo "$dcommand" >> "$dialog_command_file"
        echo "Dialog: $dcommand"
    fi
}


# MARK: sanity checks
echo "$(date +%F\ %T) : Installomator finishing off SwiftDialog"

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
if [[ ! -x $dialogBinary ]]; then
    echo "Cannot find dialog at $dialogBinary"
    exit 95
fi


# MARK: Script

# Go through dialog_command_file to figure out if it did not install anything
if grep "Latest version already installed" "$dialog_command_file"; then
	echo "$(date +%F\ %T) : No Installomator installation happened. No Jamf recon"
    jamf_recon=0
fi

# doing jamf recon in script
if [[ $jamf_recon -eq 1 ]]; then
    echo "$(date +%F\ %T) : Doing Jamf recon"
    dialogUpdate "progress: 0"
    dialogUpdate "progresstext: Reporting …"
    jamf recon
fi

# close and quit dialog
echo "$(date +%F\ %T) : Ending SwiftDialog"
dialogUpdate "progress: complete"
dialogUpdate "progresstext: Done"

# pause a moment
sleep 0.5

dialogUpdate "quit:"

# let everything catch up
sleep 0.5

# just to be safe
killall "Dialog"

echo "$(date +%F\ %T) : SwiftDialog stopped!"

# we don't want script to register as a failure in Jamf,  so always exit 0
exit 0
