#!/bin/sh

######################################################################
# Installation of Installomator
#
# No customization below…
######################################################################
# This script can be used to install Installomator directly from GitHub.
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
scriptVersion="9.7"
# v.  9.7   : 2022-12-19 : Only kill the caffeinate process we create
# v.  9.6   : 2022-11-15 : GitHub API call is first, only try alternative if that fails.
# v.  9.5   : 2022-09-21 : change of GitHub download
# v.  9.4   : 2022-09-14 : downloadURL can fall back on GitHub API
# v.  9.3   : 2022-08-29 : Logging changed for current version. Improved installation with looping if it fails, so it can try again. Improved GitHub handling.
# v.  9.2.2 : 2022-06-17 : Check 1.1.1.1 for internet connection.
# v.  9.2   : 2022-05-19 : Built in installer for Installlomator. Universal script.
######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Mark: Constants, logging and caffeinate
log_message="Installomator install, v$scriptVersion"
label="Inst-v$scriptVersion"

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
    exit 90
fi

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid" || true
    printlog "[LOG-END] Status $1"
    exit $1
}

name="Installomator"
printlog "$name check for installation"
# download URL, version and Expected Team ID
# Method for GitHub pkg with destFile
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

caffexit 0
