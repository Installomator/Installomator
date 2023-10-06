#!/bin/sh

# Installomator 1st installation (auto installation at enrollment)

# MARK: Variables
instance="" # Name of used instance

LOGO="" # "appstore", "jamf", "mosyleb", "mosylem", "addigy", "microsoft", "ws1", "kandji", "filewave"

if [[ $(arch) == "arm64" ]]; then
    items=(dialog dockutil microsoftautoupdate theunarchiver microsoftoffice365 microsoftedge microsoftteams microsoftonedrive microsoftdefender microsoftcompanyportal displaylinkmanager)
    # displaylinkmanager
else
    items=(dialog dockutil microsoftautoupdate theunarchiver microsoftoffice365 microsoftedge microsoftteams microsoftonedrive microsoftdefender microsoftcompanyportal)
fi
# Remember: dialog dockutil desktoppr
# dialog not needed if Progress 1st is used

installomatorOptions="NOTIFY=silent BLOCKING_PROCESS_ACTION=ignore INSTALL=force IGNORE_APP_STORE_APPS=yes LOGGING=REQ"

# Error message to user if any occur
showError="1" # Show error message if 1 (0 if it should not be shown)
errorMessage="A problem was encountered setting up this Mac. Please contact IT."

# MARK: Instructions
######################################################################
# Installomator 1st
#
# Installation using Installomator
# (use separate Progress 1st script to show progress)
# No customization below…
######################################################################
# This script can be used to install software using Installomator.
# Script will display a dialog if any errors happens.
# User is not notified about installations.
#
# NOTE about MDM solutions:
# This script might not be usefull for the following solutions as they
# have their own solution for deployment progress:
# - mosyleb,mosylem  Mosyle has Embark (often “Progress 1st” is
#                    a better option if not using Embark)
# - kandji           Kandji has LiftOff
######################################################################
# Other installomatorOptions:
#   LOGGING=REQ
#   LOGGING=DEBUG
#   LOGGING=WARN
#   BLOCKING_PROCESS_ACTION=ignore
#   BLOCKING_PROCESS_ACTION=tell_user
#   BLOCKING_PROCESS_ACTION=tell_user_then_quit
#   BLOCKING_PROCESS_ACTION=prompt_user
#   BLOCKING_PROCESS_ACTION=prompt_user_loop
#   BLOCKING_PROCESS_ACTION=prompt_user_then_kill
#   BLOCKING_PROCESS_ACTION=quit
#   BLOCKING_PROCESS_ACTION=kill
#   NOTIFY=all
#   NOTIFY=success
#   NOTIFY=silent
#   IGNORE_APP_STORE_APPS=yes
#   INSTALL=force
######################################################################
#
#  This script made by Søren Theilgaard
#  https://github.com/Theile
#  Twitter and MacAdmins Slack: @theilgaard
#
#  Some functions and code from Installomator:
#  https://github.com/Installomator/Installomator
#
######################################################################
scriptVersion="9.11"
# v.  9.11  : 2023-10/06 : Support for FileWave
# v.  9.10  : 2023-09-18 : If LOGO variable is empty, we exit
# v.  9.9   : 2023-08-25 : items varied by architecture
# v.  9.8   : 2023-03-02 : Support for Kandji, but that MDM already have LiftOff that is probably better.
# v.  9.7   : 2022-12-19 : Fix for LOGO_PATH for ws1, and only kill the caffeinate process we create
# v.  9.6   : 2022-11-15 : GitHub API call is first, only try alternative if that fails.
# v.  9.5   : 2022-09-21 : change of GitHub download
# v.  9.4   : 2022-09-14 : Making error message optional. downloadURL can fall back on GitHub API.
# v.  9.3   : 2022-08-29 : installomatorOptions in quotes and ignore blocking processes. Improved installation with looping if it fails, so it can try again. Improved GitHub handling. ws1 support.
# v.  9.2.2 : 2022-06-17 : installomatorOptions introduced. Check 1.1.1.1 for internet connection.
# v.  9.2.1 : 2022-05-30 : Some changes to logging
# v.  9.2   : 2022-05-19 : Built in installer for Installomator, and display dialog if error happens. Now universal script for all supported MDMs based on LOGO variable.
######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Check before running
echo "LOGO: $LOGO"
if [[ -z $LOGO ]]; then
	echo "ERROR: LOGO variable empty. Fatal problem. Exiting."
	exit 1
fi
case $LOGO in
    addigy|microsoft)
        conditionFile="/var/db/.Installomator1stDone"
        # Addigy and Microsoft Endpoint Manager (Intune) need a check for a touched file
        if [ -e "$conditionFile" ]; then
            echo "$conditionFile exists, so we exit."
            exit 0
        else
            echo "$conditionFile not found, so we continue…"
        fi
        ;;
esac

# MARK: Constants, logging and caffeinate
log_message="$instance: Installomator 1st, v$scriptVersion"
label="1st-v$scriptVersion"

log_location="/private/var/log/Installomator.log"
printlog(){
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
    caffexit 90
fi

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid" || true
    printlog "[LOG-END] Status $1"
    exit $1
}

# Counters
errorCount=0
countLabels=${#items[@]}
printlog "Total installations: $countLabels"

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
    *)
    	# Not supported
    	printlog "ERROR: LOGO variable not supported ($LOGO). Fatal problem. Exiting."
    	exit 2
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

# MARK: Functions
# Notify the user using AppleScript
function displayDialog(){
    currentUser="$(stat -f "%Su" /dev/console)"
    currentUserID=$(id -u "$currentUser")
    if [[ "$currentUser" != "" ]]; then
        launchctl asuser $currentUserID sudo -u $currentUser osascript -e "button returned of (display dialog \"$message\" buttons {\"OK\"} default button \"OK\" with icon POSIX file \"$LOGO_PATH\")" || true
    fi
}

# MARK: Script

# MARK: Install Installomator
name="Installomator"
printlog "$name check for installation"
# download URL, version and Expected Team ID
# Method for GitHub pkg
gitusername="Installomator"
gitreponame="Installomator"
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
expectedTeamID="JME5BW3F3R"

destFile="/usr/local/Installomator/Installomator.sh"
currentInstalledVersion="$(${destFile} version 2>/dev/null || true)"
printlog "${destFile} version: $currentInstalledVersion"
if [[ ! -e "${destFile}" || "$currentInstalledVersion" != "$appNewVersion" ]]; then
    printlog "$name not found or version not latest."
    printlog "${destFile}"
    printlog "Installing version ${appNewVersion} ..."
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

# MARK: Installations
errorLabels=""
((countLabels++))
((countLabels--))
printlog "$countLabels labels to install"

for item in "${items[@]}"; do
    printlog "$item"
    cmdOutput="$( ${destFile} ${item} LOGO=$LOGO ${installomatorOptions} || true )"
    exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
    if [[ ${exitStatus} -eq 0 ]] ; then
        printlog "${item} succesfully installed."
        warnOutput="$( echo "${cmdOutput}" | grep --binary-files=text "WARN" || true )"
        printlog "$warnOutput"
    else
        printlog "Error installing ${item}. Exit code ${exitStatus}"
        #printlog "$cmdOutput"
        errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
        printlog "$errorOutput"
        ((errorCount++))
        errorLabels="$errorLabels ${item}"
    fi
    ((countLabels--))
    itemName=""
done

# MARK: Finishing
# Prevent re-run of script if conditionFile is set
if [[ ! -z "$conditionFile" ]]; then
    printlog "Touching condition file so script will not run again"
    touch "$conditionFile" || true
    printlog "$(ls -al "$conditionFile" || true)"
fi

# Show error to user if any
printlog "Errors: $errorCount"
if [[ $errorCount -ne 0 ]]; then
    printlog "ERROR: Display error dialog to user!"
    errorMessage="${errorMessage} Total errors: $errorCount"
    if [[ $showError -eq 1 ]]; then
        message="$errorMessage"
        displayDialog &
    fi
    printlog "errorLabels: $errorLabels"
fi

printlog "Ending"
caffexit $errorCount
