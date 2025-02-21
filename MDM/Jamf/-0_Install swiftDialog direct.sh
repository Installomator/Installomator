#!/bin/sh
# shellcheck disable=SC3010,SC2005,SC2086,SC2116,SC2143,SC3006,SC3018 #,SC1112,SC2143,SC2145,SC2089,SC2090

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# MARK: Arguments/Parameters

# Parameter 4: Custom icon for swiftDialog. Value can be a path on the client or a URL. If no icon is provided Self Service icon will be used.
icon=${4}

# Parameter 5: Remove old icon (if value is `1`) or not (default `0`). Removing the icon forces a new install of swiftDialog regardless of installed version.
removeOldIcon=${5:-0}

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

# MARK: Script

# MARK: Handling icon for swiftDialog
dialogIconLocation="/Library/Application Support/Dialog/Dialog.png"
# Should old icon be removed?
if [[ $removeOldIcon -eq 1 ]]; then
    echo "Removing old icon first"
    rm "$dialogIconLocation" || true
fi
# Check Dialog installation folder
if [ ! -d "/Library/Application Support/Dialog" ]; then
    echo "Dialog folder not existing or is a file, so fixing that."
    echo "$(rm -rv "/Library/Application Support/Dialog")"
    echo "$(mkdir -p "/Library/Application Support/Dialog")"
fi
echo "$(file "/Library/Application Support/Dialog")"
# Checking icon before installation
if [[ -n $icon ]]; then
    echo "icon defined, so investigating that for Dialog!"
    # NOTE: Checking various icon scenarios
    if [[ -n "$(file "$dialogIconLocation" | cut -d: -f2 | grep -o "PNG image data")" ]]; then
        echo "$(file "${dialogIconLocation}")"
        echo "swiftDialog icon already exists as PNG file, so continuing..."
    elif [[ "$( echo $icon | cut -d/ -f1 | cut -c 1-4 )" = "http" ]]; then
        echo "icon is web-link, downloading..."
        if ! curl -fs "$icon" -o "$dialogIconLocation"; then
            echo "ERROR : Downloading $icon failed."
            echo "No icon logo for swiftDialog has been set."
        else
            echo "Icon for Dialog downloaded/created."
            echo "$(file "${dialogIconLocation}")"
            INSTALL=force
        fi
    elif [[ -n "$(file "$icon" | cut -d: -f2 | grep -o "PNG image data")" ]]; then
        echo "icon is PNG, can be used directly."
        if cp "${icon}" "$dialogIconLocation"; then
            echo "PNG Icon for Dialog copied."
            echo "$(file "${dialogIconLocation}")"
            INSTALL=force
        else
            echo "ERROR : Copying $icon failed."
            echo "No icon logo for swiftDialog has been set."
        fi
    elif [[ -f "$icon" && -n "$(echo $icon | rev | cut -d. -f1 | rev | grep -oE "(icns|tif|tiff|gif|jpg|jpeg|heic)")" ]]; then
        echo "icon is $(echo $icon | rev | cut -d. -f1 | rev), converting..."
        echo "$(file "${icon}")"
        if ! sips -s format png "${icon}" --out "$dialogIconLocation"; then
            echo "ERROR : Converting $icon failed."
            echo "No icon logo for swiftDialog has been set."
        else
            echo "Icon for Dialog converted."
            echo "$(file "${dialogIconLocation}")"
            INSTALL=force
        fi
    else
        echo "Icon situation not handled."
        echo "No icon logo for swiftDialog has been set."
    fi
# NOTE: Special Jamf Pro case
elif [[ -z "$(file "$dialogIconLocation" | cut -d: -f2 | grep -o "PNG image data")" ]]; then
    # No icon specified, trying to use Self Service icon
    # Create `overlayicon` from Jamf Self Service’s custom icon (thanks, @meschwartz!)
    selfserviceicon="/private/var/tmp/overlayicon.icns"
    if xxd -p -s 260 "$(defaults read /Library/Preferences/com.jamfsoftware.jamf self_service_app_path)"/Icon$'\r'/..namedfork/rsrc | xxd -r -p > "$selfserviceicon" ; then
        if ! sips -s format png "${selfserviceicon}" --out "$dialogIconLocation"; then
            icon="$dialogIconLocation"
        else
            echo "ERROR : Failed converting .icns file to png"
        fi
    else
        echo "ERROR : Failed generating .icns file from Self Service settings"
    fi
else
    echo "icon not defined."
fi
echo "INSTALL=${INSTALL}"

# MARK: Install Swift Dialog
name="Dialog"
echo "$name check for installation"
# download URL, version and Expected Team ID
# Method for GitHub pkg w. app version check
gitusername="swiftDialog"
gitreponame="swiftDialog"
#echo "$gitusername $gitreponame"
filetype="pkg"
downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
if [[ "$(echo $downloadURL | grep -ioE "https.*.$filetype")" == "" ]]; then
    echo "WARN  : GitHub API failed, trying failover."
    #downloadURL="https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
    downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
fi
#echo "$downloadURL"
appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
#echo "$appNewVersion"
expectedTeamID="PWA5E9TQ59"
destFile="/Library/Application Support/Dialog/Dialog.app"
versionKey="CFBundleShortVersionString" #CFBundleVersion
currentInstalledVersion="$(/usr/libexec/PlistBuddy -c "Print :$versionKey" "${destFile}/Contents/Info.plist" | tr -d "[:special:]" || true)"
echo "${name} version installed: $currentInstalledVersion"

destFile2="/usr/local/bin/dialog"
# NOTE: Condition for installation
if [[ ! -d "${destFile}" || ! -x "${destFile2}" || "$currentInstalledVersion" != "$appNewVersion" || "$INSTALL" == "force" ]]; then
    echo "$name not found, version not latest, icon for Dialog was changed."
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
            echo "ERROR : Error downloading $downloadURL, with status $curlDownloadStatus"
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
                    echo "ERROR : $name package installation failed."
                    echo "${pkgInstall}"
                    exitCode=2
                else
                    echo "Installing $name package succes."
                    exitCode=0
                fi
            else
                echo "ERROR : Package verification failed for $name before package installation could start. Download link may be invalid."
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
        echo "ERROR : Installation of $name failed. Aborting."
        caffexit $exitCode
    else
        echo "$name version $appNewVersion installed!"
    fi
else
    echo "$name version $appNewVersion already found. Perfect!"
fi
