#!/bin/sh

# Downloads and installs the latest Google Chrome app

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

DEBUG=0 # (set to 0 for production, 1 for debugging)

# URL for the download, use Jamf argument $4 when set
downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"

# app to verify and copy (include .app)
appName="Google Chrome.app"

# 10-digit developer team ID
expectedTeamID="EQHXZ8M8AV"
# obtain this by running 
#
# spctl -a -vv Google\ Chrome.app
#
# the team ID is the ten-digit ID at the end of the line starting with 'origin='

# target directory (remember to _omit_ last / )
targetDir="/Applications"

dmgname="${downloadURL##*/}"

cleanupBeforeExit() {
    if [ "$DEBUG" -eq 0 ]; then
        # remove the temporary working directory when done
        echo "Deleting $tmpDir"
        rm -Rf "$tmpDir"
    else
        open "$tmpDir"
    fi
    
    if [ -n "$dmgmount" ]; then
        # unmount disk image
        echo "Unmounting $dmgmount"
        hdiutil detach "$dmgmount"
    fi
}

# create temporary working directory
tmpDir=$(mktemp -d )
if [ "$DEBUG" -eq 1 ]; then
    # for debugging use script dir as working directory
    tmpDir=$(dirname "$0")
fi

# change directory to temporary working directory
echo "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    echo "error changing directory $tmpDir"
    #rm -Rf "$tmpDir"
    cleanupBeforeExit
    exit 1
fi

if [ -f "$dmgname" ] && [ "$DEBUG" -eq 1 ]; then
    echo "$dmgname exists and DEBUG enabled, skipping download"
else
    # download the dmg
    echo "Downloading $downloadURL"
    if ! curl --location --silent "$downloadURL" -o "$dmgname"; then
        echo "error downloading $downloadURL"
        cleanupBeforeExit 
        exit 2
    fi
    
    if [ ! -f "$tmpDir/$dmgname" ]; then
        echo "could not download $downloadURL"
        cleanupBeforeExit
        exit 2
    fi
fi

# mount the dmg
echo "Mounting $tmpDir/$dmgname"
# set -o pipefail
if ! dmgmount=$(hdiutil attach "$tmpDir/$dmgname" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
    echo "Error mounting $tmpDir/$dmgname"
    cleanupBeforeExit 
    exit 3
fi
echo "Mounted: $dmgmount"

# verify with spctl
echo "Verifying: $dmgmount/$appName"
if ! teamID=$(spctl -a -vv "$dmgmount/$appName" 2>&1 | awk '/origin=/ {print $NF }' ); then
    echo "Error verifying $dmgmount/$appName"
    cleanupBeforeExit 
    exit 4
fi

echo "Comparing Team IDs: ($expectedTeamID) $teamID"

if [ "($expectedTeamID)" != "$teamID" ]; then
    echo "Team IDs do not match!"
    cleanupBeforeExit 
    exit 5
fi

# check for root
if [ "$(whoami)" != "root" ]; then
    # not running as root
    if [ "$DEBUG" -eq 0 ]; then
        echo "not running as root, exiting"
        cleanupBeforeExit 
        exit 6
    fi
    
    echo "DEBUG enabled, skipping copy and chown steps"
    cleanupBeforeExit 
    exit 0
fi

# remove existing application
if [ -e "$targetDir/$appName" ]; then
    echo "Removing existing $targetDir/$appName"
    rm -Rf "$targetDir/$appName"
fi

# copy app to /Applications
echo "Copy $dmgmount/$appName to $targetDir"
if ! cp -R "$dmgmount/$appName" "$targetDir"; then
    echo "Error while copying!"
    cleanupBeforeExit 
    exit 7
fi

# set ownership to current users
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
if [ -n "$currentUser" ]; then
    echo "Changing owner to $currentUser"
    chown -R "$currentUser" "$targetDir/$appName" 
else
    echo "No user logged in, not changing user"
fi

# all done!
cleanupBeforeExit
exit 0
