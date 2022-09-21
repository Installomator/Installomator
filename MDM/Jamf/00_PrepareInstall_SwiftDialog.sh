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

dialogApp="/Library/Application Support/Dialog/Dialog.app"

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

# swiftDialog installation
name="Dialog"
echo "$name check for installation"
# download URL, version and Expected Team ID
# Method for GitHub pkg w. app version check
gitusername="bartreardon"
gitreponame="swiftDialog"
#echo "$gitusername $gitreponame"
filetype="pkg"
#downloadURL="https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
if [[ "$(echo $downloadURL | grep -ioE "https.*.$filetype")" == "" ]]; then
    echo "Trying GitHub API for download URL."
    downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
fi
#echo "$downloadURL"
appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
#echo "$appNewVersion"
expectedTeamID="PWA5E9TQ59"
destFile="/Library/Application Support/Dialog/Dialog.app"
versionKey="CFBundleShortVersionString" #CFBundleVersion

currentInstalledVersion="$(defaults read "${destFile}/Contents/Info.plist" $versionKey || true)"
echo "${name} version: $currentInstalledVersion"
if [[ ! -e "${destFile}" || "$currentInstalledVersion" != "$appNewVersion" ]]; then
    echo "$name not found or version not latest."
    echo "${destFile}"
    echo "Installing version ${appNewVersion}…"
    # Create temporary working directory
    tmpDir="$(mktemp -d || true)"
    echo "Created working directory '$tmpDir'"
    # Download the installer package
    echo "Downloading $name package version $appNewVersion from: $downloadURL"
    installationCount=0
    exitCode=9
    while [[ $installationCount -lt 3 && $exitCode -gt 0 ]]; do
        curlDownload=$(curl -Ls "$downloadURL" -o "$tmpDir/$name.pkg" || true)
        curlDownloadStatus=$(echo $?)
        if [[ $curlDownloadStatus -ne 0 ]]; then
            echo "error downloading $downloadURL, with status $curlDownloadStatus"
            echo "${curlDownload}"
            exitCode=1
        else
            echo "Download $name succes."
            # Verify the download
            teamID=$(spctl -a -vv -t install "$tmpDir/$name.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' || true)
            echo "Team ID for downloaded package: $teamID"
            # Install the package if Team ID validates
            if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
                echo "$name package verified. Installing package '$tmpDir/$name.pkg'."
                pkgInstall=$(installer -verbose -dumplog -pkg "$tmpDir/$name.pkg" -target "/" 2>&1)
                pkgInstallStatus=$(echo $?)
                if [[ $pkgInstallStatus -ne 0 ]]; then
                    echo "ERROR. $name package installation failed."
                    echo "${pkgInstall}"
                    exitCode=2
                else
                    echo "Installing $name package succes."
                    exitCode=0
                fi
            else
                echo "ERROR. Package verification failed for $name before package installation could start. Download link may be invalid."
                exitCode=3
            fi
        fi
        ((installationCount++))
        echo "$installationCount time(s), exitCode $exitCode"
        if [[ $installationCount -lt 3 ]]; then
            if [[ $exitCode -gt 0 ]]; then
                echo "Sleep a bit before trying download and install again. $installationCount time(s)."
                echo "Remove $(rm -fv "$tmpDir/$name.pkg" || true)"
                sleep 2
            fi
        else
            echo "Download and install of $name succes."
        fi
    done
    # Remove the temporary working directory
    echo "Deleting working directory '$tmpDir' and its contents."
    echo "Remove $(rm -Rfv "${tmpDir}" || true)"
    # Handle installation errors
    if [[ $exitCode != 0 ]]; then
        echo "ERROR. Installation of $name failed. Aborting."
        caffexit $exitCode
    else
        echo "$name version $appNewVersion installed!"
    fi
else
    echo "$name version $appNewVersion already found. Perfect!"
fi

# check for Swift Dialog
if [[ ! -d $dialogApp ]]; then
    echo "Cannot find dialog at $dialogApp"
    exit 95
fi


# MARK: Configure and display swiftDialog

# display first screen
open -a "$dialogApp" --args \
        --title none \
        --icon "$icon" \
        --message "$message" \
        --mini \
        --progress 100 \
        --position bottomright \
        --movable \
        --commandfile "$dialog_command_file"

# give everything a moment to catch up
sleep 0.1
