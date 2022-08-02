#!/bin/zsh

# runs through a list of Installomator items
# and displays status using Swift Dialog
#
# dependencies:
# - Swift Dialog:    https://github.com/bartreardon/swiftDialog
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

# the delay to simulate an install in DEBUG mode
fakeInstallDelay=5

# list of Installomator labels

items=(
    "firefoxpkg|Firefox"
    "googlechromepkg|Google Chrome"
 )

# MARK: Constants

scriptDir=$(dirname ${0:A})
repoDir=$(dirname $scriptDir)

# if [[ $DEBUG -eq 1 ]]; then
    installomator="$repoDir/utils/assemble.sh"
# else
#     installomator="/usr/local/Installomator/Installomator.sh"
# fi

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

dialogActivate() {
    osascript -e 'tell app "Dialog" to activate'
}

progressUpdate() {
    # $1: progress text (optional)
    local text=$1
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

completeItem() {
    local description=$1
    local itemStatus=$2

    dialogUpdate "listitem: $description: $itemStatus"
    echo "completed item $description: $itemStatus"
}

installomator() {
    # $1: label
    # $2: description
    local label=$1
    local description=$2

    startItem $description

    $installomator $label \
                   DIALOG_CMD_FILE=${(q)dialog_command_file} \
                   DIALOG_LIST_ITEM_NAME=${(q)description} \
                   DEBUG=$DEBUG \
                   LOGGING=DEBUG

#     if [[ $DEBUG -eq 0 ]]; then
#         $installomator $label DIALOG_PROGRESS=yes DIALOG_CMD_FILE=$dialog_command_file
#     else
#         echo "DEBUG enabled, this would be 'Installomator $label'"
#         for ((c=0; c<$fakeInstallDelay; c++ )); do
#             p=$((c * 100 / fakeInstallDelay))
#             dialogUpdate "progress: $p"
#             sleep 1
#         done
#     fi

    completeItem $description "success"
}

cleanupAndExit() {
    # kill caffeinate process
    if [[ -n $caffeinatePID ]]; then
        echo "killing caffeinate..."
        kill $caffeinatePID
    fi

    # kill dialog process
#     if [[ -n $dialogPID ]]; then
#         dialogUpdate "quit:"
#         kill $dialogPID
#     fi

    # clean up tmp dir
    if [[ -n $tmpDir && -d $tmpDir ]]; then
        echo "removing tmpDir $tmpDir"
        rm -rf $tmpDir
    fi

#     # remove dialog command file
#     if [[ -e $dialog_command_file ]]; then
#         rm $dialog_command_file
#     fi
}

checkInstallomator() {
    if [[ ! -e $installomator ]]; then
        echo "Installomator not found at path $installomator. Installing"

        installomatorPkg="$tmpDir/Installomator.pkg"

        # download Installomator pkg
        if ! downloadURL=$(curl -L --silent --fail "https://api.github.com/repos/Installomator/Installomator/releases/latest" \
        | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }"); then
            echo "could not get Installomator download url"
            exit 96
        fi

        echo "downloading Installomator from $downloadURL"
        if ! curl --fail --silent -L --show-error "$downloadURL" -o $installomatorPkg; then
            echo "could not download Installomator"
            exit 95
        fi

        echo "verifying Installomator"
        # verify pkg
        if ! spctlout=$(spctl -a -vv -t install "$installomatorPkg" 2>&1 ); then
            echo "Error verifying $installomatorPkg"
            exit 94
        fi
        teamID=$(echo $spctlout | awk -F '(' '/origin=/ {print $2 }' | tr -d '()' )
        if [ "JME5BW3F3R" != "$teamID" ]; then
            echo "Team IDs do not match!"
            exit 93
        fi
        # Install pkg

        echo "Installing Installomator"
        if [[ DEBUG -eq 0 ]]; then
            installer -pkg $installomatorPkg -tgt / -verbose

            # check if Installomator is correctly installed
            if [[ ! -x $installomator ]]; then
                echo "failed to install Installomator"
                exit 92
            fi
        else
            echo "DEBUG enabled, skipping Installomator install"
        fi
    else
        # update installomator
        # installomator installomator
    fi
}

checkSwiftDialog() {
    if [[ ! -x $dialog ]]; then
        installomator swiftdialog "Swift Dialog"
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

# MARK: Setup

# No sleeping
caffeinate -dimsu & caffeinatePID=$!

# trap exit for cleanup
trap cleanupAndExit EXIT

# get a temp
tmpDir=$(mktemp -d)

# setup first list
itemCount=${#items}

listitems=( "--listitem" "Configure Tools" )

for item in $items; do
    label=$(cut -d '|' -f 1 <<< $item)
    description=$(cut -d '|' -f 2 <<< $item)
    listitems+=( "--listitem" ${description} )
done

# download and install Installomator
startItem "Configure Tools"
checkInstallomator

# download and install Swift Dialog
echo "installing Swift Dialog"
checkSwiftDialog

# display first screen
$dialog --title "Configuring your Mac" \
        --icon "SF=gear" \
        --message "Setting up some more things..." \
        --progress 100 \
        "${listitems[@]}" \
        --button1disabled \
        --big \
        --ontop \
        --liststyle compact \
        --messagefont size=16 \
        --commandfile $dialog_command_file & dialogPID=$!
sleep 0.1
dialogActivate

completeItem "Configure Tools" "success"

for item in $items; do
    label=$(cut -d '|' -f 1 <<< $item)
    description=$(cut -d '|' -f 2 <<< $item)
    installomator $label $description
done

dialogUpdate "quit:"
