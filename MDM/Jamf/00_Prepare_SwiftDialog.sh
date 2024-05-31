#!/bin/zsh --no-rcs

export PATH=/usr/bin:/bin:/usr/sbin:/sbin


# MARK: Arguments/Parameters

# Parameter 4: SwiftDialog command file path (`/var/tmp/dialog.log`)
dialog_command_file=${4:-"/var/tmp/dialog.log"}

# Parameter 5: Text shown in the swiftDialog window above the progress bar (`Installing Microsoft Office`)
message=${5:-"Installing …"}

# Parameter 6: Icon as Path or URL in swiftDialog, see https://rumble.com/v119x6y-harvesting-self-service-icons.html
icon=${6:-"/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"}
# see Dan Snelson's advice on how to get a URL to an icon in Self Service
# https://rumble.com/v119x6y-harvesting-self-service-icons.html

# Parameter 7: Overlayicon as Path or URL in swiftDialog (like a company logo) (if not configured, custom Dialog icon will be used, or Jamf Self Service icon)
overlayicon=${7}


# MARK: Constants

dialogBinary="/usr/local/bin/dialog"

echo "$(date +%F\ %T) : Installomator starting up SwiftDialog"


# MARK: Functions

dialogUpdate() {
    # $1: dialog command
    local dcommand="$1"

    if [[ -n $dialog_command_file ]]; then
        echo "$dcommand" >> "$dialog_command_file"
        echo "Dialog: $dcommand"
    fi
}


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

# check for Swift Dialog
if [[ ! -x $dialogBinary ]]; then
    echo "Cannot find dialog at $dialogBinary"
    exit 95
fi


# MARK: Configure and display swiftDialog

# Determining overlayicon
if [[ -n $overlayicon ]]; then
    echo "overlayicon defined from script argument."
elif [[ -f "/Library/Application Support/Dialog/Dialog.png" ]]; then
    echo "overlayicon used from Dialog.png"
    overlayicon="/Library/Application Support/Dialog/Dialog.png"
else
    overlayicon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path )
    echo "overlayicon used from Jamf Pro Self Service icon."
fi

echo "dialog_command_file: $dialog_command_file"
echo "message: $message"
echo "icon: $icon"
echo "overlayicon: $overlayicon"

# display first screen
dialogCMD=("$dialogBinary"
           --title none
           --icon "$icon"
           --overlayicon "$overlayicon"
           --message "$message"
           --mini
           --progress 100
           --position bottomright
           --moveable
           --commandfile "$dialog_command_file"
)

echo "dialogCMD: ${dialogCMD[@]}"

"${dialogCMD[@]}" &

echo "$(date +%F\ %T) : SwiftDialog started!"

# give everything a moment to catch up
sleep 0.1
