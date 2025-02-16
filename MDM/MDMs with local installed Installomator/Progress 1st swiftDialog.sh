#!/bin/sh

# Progress 1st with swiftDialog (auto installation at enrollment)
instance="e" # Name of used instance

LOGO="appstore" # "appstore", "jamf", "mosyleb", "mosylem", "addigy", "microsoft", "ws1", "kandji", "filewave"

apps=(
    "swiftDialog,/usr/local/bin/dialog"
    "dockutil,/usr/local/bin/dockutil"
    "desktoppr,/usr/local/bin/desktoppr"
    "Apple NewYork Font,/Library/Fonts/NewYork.ttf"
    "Apple SF Pro Font,/Library/Fonts/SF-Pro.ttf"
    "Apple SF Mono Font,/Library/Fonts/SF-Mono-Bold.otf"
    "Apple SF Compact Font,/Library/Fonts/SF-Compact.ttf"
    "Zoho WorkDrive TrueSync,/Applications/Zoho WorkDrive TrueSync.app"
    "TextMate,/Applications/TextMate.app"
    "1Password,/Applications/1Password 7.app"
    "Mactracker,/Applications/Mactracker.app"
    "WWDC,/Applications/WWDC.app"
    "The Unarchiver,/Applications/The Unarchiver.app"
    "Keka,/Applications/Keka.app"
    "Brave,/Applications/Brave Browser.app"
    "Firefox,/Applications/Firefox.app"
    "Microsoft AutoUpdate,/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app"
    "Microsoft Edge,/Applications/Microsoft Edge.app"
    "Microsoft Teams,/Applications/Microsoft Teams.app"
    "Microsoft Excel,/Applications/Microsoft Excel.app"
    "Microsoft OneNote,/Applications/Microsoft OneNote.app"
    "Microsoft Outlook,/Applications/Microsoft Outlook.app"
    "Microsoft PowerPoint,/Applications/Microsoft PowerPoint.app"
    "Microsoft Word,/Applications/Microsoft Word.app"
    "Microsoft OneDrive,/Applications/OneDrive.app"
)

# Dialog display settings, change as desired
title="Installing Apps and other software"
message="Please wait while we download and install the needed software."
endMessage="Installation complete! Please reboot to activate FileVault."
displayEndMessageDialog=1 # Should endMessage be shown as a dialog? (0|1)
errorMessage="A problem was encountered setting up this Mac. Please contact IT."

######################################################################
# Progress 1st Dialog
#
# Showing installation progress using swiftDialog
# No customization below…
######################################################################
# Complete script meant for running via MDM on device enrollment. This will download
# and install Dialog on the fly before opening Dialog.
#
# Log: /private/var/log/InstallationProgress.log
# This file prevents script from running again on Addigy and Microsoft Endpoint (Intune):
# "/var/db/.Progress1stDone"
#
# Display a Dialog with a list of applications and indicate when they’ve been installed
# Useful when apps are deployed at random, perhaps without local logging.
# Applies to Mosyle App Catalog installs, VPP app installs, Installomator installs etc.
# The script watches the existence of files in the file system, so that is used to show progress.
#
# Requires Dialog v2 or later (will be installed) https://github.com/swiftDialog/swiftDialog
#
# NOTE about MDM solutions:
# This script might not be usefull for the following solutions as they
# have their own solution for deployment progress:
# - mosyleb,mosylem  Mosyle has Embark
# - kandji           Kandji has LiftOff
#
######################################################################
#
#  This script made by Søren Theilgaard
#  https://github.com/Theile
#  Twitter and MacAdmins Slack: @theilgaard
#
#  Based on the work by Adam Codega:
#  https://github.com/acodega/dialog-scripts
#
#  Some functions and code from Installomator:
#  https://github.com/Installomator/Installomator
#
######################################################################
# List of apps/installs to process in “apps” array.
# Provide the display name as you prefer and the path to the app/file. ex:
#       "Google Chrome,/Applications/Google Chrome.app"
# A comma separates the display name from the path. Do not use commas in your display name text.
#
# Tip: Check for something like print drivers using the pkg receipt, like:
#       "Konica-Minolta drivers,/var/db/receipts/jp.konicaminolta.print.package.C759.plist"
#      Or fonts, like:
#       "Apple SF Pro Font,/Library/Fonts/SF-Pro.ttf"
######################################################################
scriptVersion="9.8"
# v.  9.8   : 2023-10-06 : Support for FileWave, and previously Kandji. Update Progress 1st swiftDialog.sh to use native checkmark #1220
# v.  9.7   : 2022-12-19 : Fix for LOGO_PATH for ws1
# v.  9.6   : 2022-11-15 : GitHub API call is first, only try alternative if that fails.
# v.  9.5   : 2022-09-21 : change of GitHub download
# v.  9.4   : 2022-09-14 : downloadURL can fall back on GitHub API
# v.  9.3   : 2022-08-29 : Logging changed for current version. Improved installation with looping if it fails, so it can try again. Improved GitHub handling.
# v.  9.2.2 : 2022-06-17 : Improved Dialog installation. Check 1.1.1.1 for internet connection.
# v.  9.2   : 2022-05-19 : Not using GitHub api for download of Dialog, show a dialog when finished to make message more important. Now universal script for all supported MDMs based on LOGO variable.
# v.  9.0   : 2022-05-16 : Based on acodega’s work, I have added progress bar, changed logging and use another log-location, a bit more error handling for Dialog download, added some "|| true"-endings to some lines to not make them fail in Addigy, and some more.
######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Check before running
case $LOGO in
    addigy|microsoft)
        conditionFile="/var/db/.Progress1stDone"
        # Addigy and Microsoft Endpoint Manager (Intune) need a check for a touched file
        if [ -e "$conditionFile" ]; then
            echo "$LOGO setup detected"
            echo "$conditionFile exists, so we exit."
            exit 0
        else
            echo "$conditionFile not found, so we continue…"
        fi
        ;;
esac

# Mark: Constants and logging
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

log_message="$instance: Progress 1st with Dialog, v$scriptVersion"
label="P1st-v$scriptVersion"

log_location="/private/var/log/Installomator.log"
function printlog(){
    timestamp=$(date +%F\ %T)
    if [[ "$(whoami)" == "root" ]]; then
        echo "$timestamp :: $label : $1" | tee -a $log_location
    else
        echo "$timestamp :: $label : $1"
    fi
}
printlog "[LOG-BEGIN] ${log_message}"

# Internet check
if [[ "$(nc -z -v -G 10 1.1.1.1 53 2>&1 | grep -io "succeeded")" != "succeeded" ]]; then
    printlog "ERROR. No internet connection, we cannot continue."
    exit 90
fi

# Location of dialog and dialog command file
dialogApp="/usr/local/bin/dialog"
dialog_command_file="/var/tmp/dialog.log"
counterFile="/var/tmp/Progress1st.plist"

# Counters
progress_index=0
step_progress=0
defaults write $counterFile step -int 0
progress_total=${#apps[@]}
printlog "Total watched installations: $progress_total"

# Using LOGO variable to specify MDM and shown logo
case $LOGO in
    appstore)
        # Apple App Store on Mac
        if [[ $(sw_vers -buildVersion) > "19" ]]; then
            LOGO_PATH="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
        else
            LOGO_PATH="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
        fi
        ;;
    jamf)
        # Jamf Pro
        LOGO_PATH="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"
        ;;
    mosyleb)
        # Mosyle Business
        LOGO_PATH="/Applications/Self-Service.app/Contents/Resources/AppIcon.icns"
        ;;
    mosylem)
        # Mosyle Manager (education)
        LOGO_PATH="/Applications/Manager.app/Contents/Resources/AppIcon.icns"
        ;;
    addigy)
        # Addigy
        LOGO_PATH="/Library/Addigy/macmanage/MacManage.app/Contents/Resources/atom.icns"
        ;;
    microsoft)
        # Microsoft Endpoint Manager (Intune)
        LOGO_PATH="/Library/Intune/Microsoft Intune Agent.app/Contents/Resources/AppIcon.icns"
        ;;
    ws1)
        # Workspace ONE (AirWatch)
        LOGO_PATH="/Applications/Workspace ONE Intelligent Hub.app/Contents/Resources/AppIcon.icns"
        ;;
    kandji)
        # Kandji
        LOGO="/Applications/Kandji Self Service.app/Contents/Resources/AppIcon.icns"
        ;;
    filewave)
        # FileWave
        LOGO="/usr/local/sbin/FileWave.app/Contents/Resources/fwGUI.app/Contents/Resources/kiosk.icns"
        ;;
esac
if [[ ! -a "${LOGO_PATH}" ]]; then
    printlog "ERROR in LOGO_PATH '${LOGO_PATH}', setting Mac App Store."
    if [[ $(/usr/bin/sw_vers -buildVersion) > "19" ]]; then
        LOGO_PATH="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    else
        LOGO_PATH="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    fi
fi
printlog "LOGO: $LOGO – LOGO_PATH: $LOGO_PATH"

# Mark: Functions
# execute a dialog command
echo "" > $dialog_command_file || true
function dialog_command(){
    printlog "Dialog-command: $1"
    echo "$1" >> $dialog_command_file || true
}

function appCheck(){
    dialog_command "listitem: $(echo "$app" | cut -d ',' -f1): wait"
    while [ ! -e "$(echo "$app" | cut -d ',' -f2)" ]; do
        sleep 2
    done
    dialog_command "progresstext: Install of “$(echo "$app" | cut -d ',' -f1)” complete"
    dialog_command "listitem: $(echo "$app" | cut -d ',' -f1): success"
    progress_index=$(defaults read $counterFile step)
    progress_index=$(( progress_index + 1 ))
    defaults write $counterFile step -int $progress_index
    dialog_command "progress: $progress_index"
    printlog "at item number $progress_index"
}

# Notify the user using AppleScript
function displayDialog(){
    if [[ "$currentUser" != "" ]]; then
        launchctl asuser $currentUserID sudo -u $currentUser osascript -e "button returned of (display dialog \"$message\" buttons {\"OK\"} default button \"OK\" with icon POSIX file \"$LOGO_PATH\")" || true
    fi
}

# Mark: Code
name="Dialog"
printlog "$name check for installation"
# download URL, version and Expected Team ID
# Method for GitHub pkg w. app version check
gitusername="swiftDialog"
gitreponame="swiftDialog"
#printlog "$gitusername $gitreponame"
filetype="pkg"
downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
if [[ "$(echo $downloadURL | grep -ioE "https.*.$filetype")" == "" ]]; then
    printlog "GitHub API failed, trying failover."
    #downloadURL="https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
    downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
fi
#printlog "$downloadURL"
appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
#printlog "$appNewVersion"
expectedTeamID="PWA5E9TQ59"
destFile="/Library/Application Support/Dialog/Dialog.app"
versionKey="CFBundleShortVersionString" #CFBundleVersion

currentInstalledVersion="$(defaults read "${destFile}/Contents/Info.plist" $versionKey || true)"
printlog "${name} version: $currentInstalledVersion"
destFile="/usr/local/bin/dialog"
if [[ ! -e "${destFile}" || "$currentInstalledVersion" != "$appNewVersion" ]]; then
    printlog "$name not found or version not latest."
    printlog "${destFile}"
    printlog "Installing version ${appNewVersion}…"
    # Create temporary working directory
    tmpDir="$(mktemp -d || true)"
    printlog "Created working directory '$tmpDir'"
    # Download the installer package
    printlog "Downloading $name package version $appNewVersion from: $downloadURL"
    installationCount=0
    exitCode=9
    while [[ $installationCount -lt 3 && $exitCode -gt 0 ]]; do
        curlDownload=$(curl -Ls "$downloadURL" -o "$tmpDir/$name.pkg" || true)
        curlDownloadStatus=$(echo $?)
        if [[ $curlDownloadStatus -ne 0 ]]; then
            printlog "error downloading $downloadURL, with status $curlDownloadStatus"
            printlog "${curlDownload}"
            exitCode=1
        else
            printlog "Download $name succes."
            # Verify the download
            teamID=$(spctl -a -vv -t install "$tmpDir/$name.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' || true)
            printlog "Team ID for downloaded package: $teamID"
            # Install the package if Team ID validates
            if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
                printlog "$name package verified. Installing package '$tmpDir/$name.pkg'."
                pkgInstall=$(installer -verbose -dumplog -pkg "$tmpDir/$name.pkg" -target "/" 2>&1)
                pkgInstallStatus=$(echo $?)
                if [[ $pkgInstallStatus -ne 0 ]]; then
                    printlog "ERROR. $name package installation failed."
                    printlog "${pkgInstall}"
                    exitCode=2
                else
                    printlog "Installing $name package succes."
                    exitCode=0
                fi
            else
                printlog "ERROR. Package verification failed for $name before package installation could start. Download link may be invalid."
                exitCode=3
            fi
        fi
        ((installationCount++))
        printlog "$installationCount time(s), exitCode $exitCode"
        if [[ $installationCount -lt 3 ]]; then
            if [[ $exitCode -gt 0 ]]; then
                printlog "Sleep a bit before trying download and install again. $installationCount time(s)."
                printlog "Remove $(rm -fv "$tmpDir/$name.pkg" || true)"
                sleep 2
            fi
        else
            printlog "Download and install of $name succes."
        fi
    done
    # Remove the temporary working directory
    printlog "Deleting working directory '$tmpDir' and its contents."
    printlog "Remove $(rm -Rfv "${tmpDir}" || true)"
    # Handle installation errors
    if [[ $exitCode != 0 ]]; then
        printlog "ERROR. Installation of $name failed. Aborting."
        caffexit $exitCode
    else
        printlog "$name version $appNewVersion installed!"
    fi
else
    printlog "$name version $appNewVersion already found. Perfect!"
fi


while [ "$(pgrep -l "Setup Assistant")" != "" ]; do
    printlog "Setup Assistant Still Running. PID $setupAssistantProcess."
    sleep 1
done
printlog "Out of Setup Assistant."

while [ "$(pgrep -l "Finder")" = "" ]; do
    printlog "Finder process not found. Assuming device is at login screen. PID $finderProcess"
    sleep 1
done
printlog "Finder is running…"

currentUser=$(stat -f "%Su" /dev/console)
currentUserID=$(id -u "$currentUser")
printlog "Logged in user is $currentUser with ID $currentUserID"

# set icon based on whether computer is a desktop or laptop
#hwType=$(system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book" || true)
#if [ "$hwType" != "" ]; then
#    LOGO_PATH="SF=laptopcomputer.and.arrow.down,weight=thin,colour1=#51a3ef,colour2=#5154ef"
#else
#    LOGO_PATH="SF=desktopcomputer.and.arrow.down,weight=thin,colour1=#51a3ef,colour2=#5154ef"
#fi

dialogCMD="$dialogApp -p --title \"$title\" \
--message \"$message\" \
--icon \"$LOGO_PATH\" \
--progress $progress_total \
--button1text \"Please Wait\" \
--button1disabled"

# create the list of apps
listitems=""
for app in "${apps[@]}"; do
  listitems="$listitems --listitem '$(echo "$app" | cut -d ',' -f1)'"
done

# final command to execute
dialogCMD="$dialogCMD $listitems"

printlog "$dialogCMD"

# Launch dialog and run it in the background sleep for a second to let thing initialise
printlog "About to launch Dialog."
eval "$dialogCMD" &
sleep 2

(for app in "${apps[@]}"; do
    #step_progress=$(( 1 + progress_index ))
    #dialog_command "progress: $step_progress"
    sleep 0.5
    appCheck &
done

wait)

# Mark: Finishing

# Prevent re-run of script if conditionFile is set
if [[ ! -z "$conditionFile" ]]; then
    printlog "Touching condition file so script will not run again"
    touch "$conditionFile" || true
    printlog "$(ls -al "$conditionFile" || true)"
fi

# all done. close off processing and enable the "Done" button
printlog "Finalizing."
dialog_command "progresstext: $endMessage"
dialog_command "progress: complete"
dialog_command "button1text: Done"
dialog_command "button1: enable"

if [[ $displayEndMessageDialog -eq 1 ]]; then
    message="$endMessage"
    displayDialog &
fi

sleep 1
printlog $(rm -fv $dialog_command_file || true)
printlog $(rm -fv $counterFile || true)

printlog "Ending"
