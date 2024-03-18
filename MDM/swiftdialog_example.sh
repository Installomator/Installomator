#!/bin/zsh --no-rcs

# runs through a list of Installomator items
# and displays status using Swift Dialog
#
# dependencies:
# - Swift Dialog:    https://github.com/swiftDialog/swiftDialog
# - Installomator:   https://github.com/Installomator/Installomator
# this script will install both if they are not yet present

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# MARK: Variables

# set to 1 to not require root and not actually do any changes
# set to 0 for production
if [[ $1 == "NODEBUG" ]]; then
    DEBUG=0
else
    DEBUG=1
fi

# the label to install:
label="googlechromepkg"


# MARK: Constants

scriptDir=$(dirname ${0:A})
repoDir=$(dirname $scriptDir)

if [[ $DEBUG -eq 1 ]]; then
    installomator="$repoDir/utils/assemble.sh"
else
    installomator="/usr/local/Installomator/Installomator.sh"
fi

dialog="/usr/local/bin/dialog"

if [[ DEBUG -eq 0 ]]; then
    dialog_command_file="/var/tmp/dialog.log"
else
    dialog_command_file="$HOME/dialog.log"
fi


# MARK: Functions

dialogUpdate() {
    # $1: dialog command
    local dcommand=$1

    if [[ -n $dialog_command_file ]]; then
        echo "$dcommand" >> $dialog_command_file
        echo "Dialog: $dcommand"
    fi
}

progressUpdate() {
    # $1: progress text (optional)
    local text=$1
    itemCounter=$((itemCounter + 1))
    dialogUpdate "progress: $itemCounter"
    if [[ -n $text ]]; then
        dialogUpdate "progresstext: $text"
    fi
}

startItem() {
    local description=$1

    echo "Starting Item: $description"
    dialogUpdate "listitem: $description: wait"
    progressUpdate $description
}

cleanupAndExit() {
    # kill caffeinate process
    if [[ -n $caffeinatePID ]]; then
        echo "killing caffeinate..."
        kill $caffeinatePID
    fi

    # clean up tmp dir
    if [[ -n $tmpDir && -d $tmpDir ]]; then
        echo "removing tmpDir $tmpDir"
        rm -rf $tmpDir
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

# check for installomator
if [[ ! -x $installomator ]]; then
    echo "Cannot find Installomator at $installomator"
    exit 96
fi

# check for Swift Dialog
if [[ ! -x $dialog ]]; then
    echo "Cannot find dialog at $dialog"
    exit 95
fi


# MARK: Setup

# No sleeping
caffeinate -dimsu & caffeinatePID=$!

# trap exit for cleanup
trap cleanupAndExit EXIT

# display first screen
$dialog --title "Installing $label" \
        --message "" \
        --hideicon \
        --mini \
        --progress 100 \
        --position bottomright \
        --ontop \
        --movable \
        --commandfile $dialog_command_file & dialogPID=$!

sleep 0.1

$installomator $label \
               DIALOG_CMD_FILE="$dialog_command_file" \
               DEBUG=$DEBUG

# clean up UI

dialogUpdate "progress: complete"
dialogUpdate "progresstext: Done"

sleep 0.5

dialogUpdate "quit:"

