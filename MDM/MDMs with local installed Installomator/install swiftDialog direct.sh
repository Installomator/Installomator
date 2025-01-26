#!/bin/sh

# MARK: Variables
icon="https://mosylebusinessweb.blob.core.windows.net/envoit-public/logo-envoit-macosappicon.png"
icon="/Library/Addigy/macmanage/atom.icns" # Only for Addigy
# Must be a link to a web image or a file system path

removeOldIcon=0 # Set to 1 if you want the old icon to be removed first
# Removing the icon forces a new install of swiftDialog regardless of installed version

# MARK: Instructions
######################################################################
# Installation of swiftDialog
# w. custom icon for Dialog if "icon" is defined.
#
# No customization below…
######################################################################
# This script can be used to install swiftDialog directly from GitHub.
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
scriptVersion="10.2"
# v. 10.2   : 2023-05-19 : Improved PNG icon file handling.
# v. 10.1   : 2023-05-12 : Custom icon can be icns/png file. Plistbuddy used instead of defaults.
# v. 10.0   : 2022-11-22 : Support for custom icon for Dialog.
# v.  9.7   : 2022-12-19 : Only kill the caffeinate process we create
# v.  9.6   : 2022-11-15 : GitHub API call is first, only try alternative if that fails.
# v.  9.5   : 2022-09-21 : change of GitHub download
# v.  9.4   : 2022-09-14 : downloadURL can fall back on GitHub API.
# v.  9.3   : 2022-08-29 : Logging changed for current version. Improved installation with looping if it fails, so it can try again. Improved GitHub handling.
# v.  9.2.2 : 2022-06-17 : Check 1.1.1.1 for internet connection.
# v.  9.2   : 2022-05-19 : Built in installer for Installlomator. Universal script.
######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# MARK: Constants, logging and caffeinate
log_message="Dialog install, v$scriptVersion"
label="Dialog-v$scriptVersion"

log_location="/private/var/log/Installomator.log"
printlog(){
    timestamp=$(date +%F\ %T)
    if [[ "$(whoami)" == "root" ]]; then
        echo "$timestamp :: $label : $1" | tee -a $log_location
    else
        echo "$timestamp :: $label : $1"
    fi
}
printlog "$(date +%F\ %T) : [LOG-BEGIN] ${log_message}"

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid" || true
    printlog "[LOG-END] Status $1"
    exit $1
}

# MARK: Handling icon for swiftDialog
dialogIconLocation="/Library/Application Support/Dialog/Dialog.png"
# Should old icon be removed?
if [[ $removeOldIcon -eq 1 ]]; then
    printlog "Removing old icon first"
    rm "$dialogIconLocation" || true
fi
# Check Dialog installation folder
if [ ! -d "/Library/Application Support/Dialog" ]; then
    printlog "Dialog folder not existing or is a file, so fixing that."
    printlog "$(rm -rv "/Library/Application Support/Dialog")"
    printlog "$(mkdir -p "/Library/Application Support/Dialog")"
fi
printlog "$(file "/Library/Application Support/Dialog")"
# Checking icon before installation
if [[ -n $icon ]]; then
    printlog "icon defined, so investigating that for Dialog!"
    # NOTE: Checking various icon scenarios
    if [[ -n "$(file "$dialogIconLocation" | cut -d: -f2 | grep -o "PNG image data")" ]]; then
        printlog "$(file "${dialogIconLocation}")"
        printlog "swiftDialog icon already exists as PNG file, so continuing..."
    elif [[ "$( echo $icon | cut -d/ -f1 | cut -c 1-4 )" = "http" ]]; then
        printlog "icon is web-link, downloading..."
        if ! curl -fs "$icon" -o "$dialogIconLocation"; then
            printlog "ERROR : Downloading $icon failed."
            printlog "No icon logo for swiftDialog has been set."
        else
            printlog "Icon for Dialog downloaded/created."
            printlog "$(file "${dialogIconLocation}")"
            INSTALL=force
        fi
    elif [[ -n "$(file "$icon" | cut -d: -f2 | grep -o "PNG image data")" ]]; then
        printlog "icon is PNG, can be used directly."
        if cp "${icon}" "$dialogIconLocation"; then
            printlog "PNG Icon for Dialog copied."
            printlog "$(file "${dialogIconLocation}")"
            INSTALL=force
        else
            printlog "ERROR : Copying $icon failed."
            printlog "No icon logo for swiftDialog has been set."
        fi
    elif [[ -f "$icon" && -n "$(echo $icon | rev | cut -d. -f1 | rev | grep -oE "(icns|tif|tiff|gif|jpg|jpeg|heic)")" ]]; then
        printlog "icon is $(echo $icon | rev | cut -d. -f1 | rev), converting..."
        printlog "$(file "${icon}")"
        if ! sips -s format png "${icon}" --out "$dialogIconLocation"; then
            printlog "ERROR : Converting $icon failed."
            printlog "No icon logo for swiftDialog has been set."
        else
            printlog "Icon for Dialog converted."
            printlog "$(file "${dialogIconLocation}")"
            INSTALL=force
        fi
    else
        printlog "Icon situation not handled."
        printlog "No icon logo for swiftDialog has been set."
    fi
else
    printlog "icon not defined."
fi
printlog "INSTALL=${INSTALL}"

# MARK: Install Swift Dialog
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
    printlog "WARN  : GitHub API failed, trying failover."
    #downloadURL="https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
    downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
fi
#printlog "$downloadURL"
appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
#printlog "$appNewVersion"
expectedTeamID="PWA5E9TQ59"
destFile="/Library/Application Support/Dialog/Dialog.app"
versionKey="CFBundleShortVersionString" #CFBundleVersion
currentInstalledVersion="$(/usr/libexec/PlistBuddy -c "Print :$versionKey" "${destFile}/Contents/Info.plist" | tr -d "[:special:]" || true)"
printlog "${name} version installed: $currentInstalledVersion"

destFile2="/usr/local/bin/dialog"
# NOTE: Condition for installation
if [[ ! -d "${destFile}" || ! -x "${destFile2}" || "$currentInstalledVersion" != "$appNewVersion" || "$INSTALL" == "force" ]]; then
    printlog "$name not found, version not latest, icon for Dialog was changed."
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
            printlog "ERROR : Error downloading $downloadURL, with status $curlDownloadStatus"
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
                    printlog "ERROR : $name package installation failed."
                    printlog "${pkgInstall}"
                    exitCode=2
                else
                    printlog "Installing $name package succes."
                    exitCode=0
                fi
            else
                printlog "ERROR : Package verification failed for $name before package installation could start. Download link may be invalid."
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
        printlog "ERROR : Installation of $name failed. Aborting."
        caffexit $exitCode
    else
        printlog "$name version $appNewVersion installed!"
    fi
else
    printlog "$name version $appNewVersion already found. Perfect!"
fi

printlog "$(date +%F\ %T) : [LOG-END] ${log_message}"

caffexit 0
