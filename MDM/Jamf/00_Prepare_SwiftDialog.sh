#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# MARK: Arguments/Parameters

# Parameter 4: path to the swiftDialog command file
dialog_command_file=${4:-"/var/tmp/dialog.log"}

# Parameter 5: message displayed over the progress bar
message=${5:-"Self Service Progress"}

# Parameter 6: path or URL to an icon
icon=${6:-"/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"}
# see Dan Snelson's advice on how to get a URL to an icon in Self Service
# https://rumble.com/v119x6y-harvesting-self-service-icons.html

# MARK: Constants

dialogBinary="/usr/local/bin/dialog"

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
if [[ ! -d $dialogBinary ]]; then
    echo "Cannot find dialog at $dialogBinary"
    exit 95
fi


# MARK: Configure and display swiftDialog

# Create `overlayicon` from Jamf Self Service's custom icon (thanks, @meschwartz!)
if xxd -p -s 260 "$(defaults read /Library/Preferences/com.jamfsoftware.jamf self_service_app_path)"/Icon$'\r'/..namedfork/rsrc | xxd -r -p > /var/tmp/overlayicon.icns ; then
    overlayicon="/var/tmp/overlayicon.icns"
fi

# display first screen
dialogCMD="$dialogBinary \
           --title none \
           --icon \"$icon\" \
           --overlayicon \"$overlayicon\" \
           --message \"$message\" \
           --mini \
           --progress 100 \
           --position bottomright \
           --moveable \
           --commandfile \"$dialog_command_file\" "

echo "dialogCMD: $(echo $dialogCMD | tr -s '[:blank:]')"

eval "${dialogCMD}"

# give everything a moment to catch up
sleep 0.1
