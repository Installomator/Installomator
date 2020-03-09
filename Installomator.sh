#!/bin/sh

# Downloads and installs the  app

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

DEBUG=1 # (set to 0 for production, 1 for debugging)
JAMF=0 # if this is set to 1, the argument will be picked up at $4 instead of $1

if [ "$JAMF" -eq 0 ]; then
    identifier=${1:?"no identifier provided"}
else
    identifier=${4:?"argument $4 required"}
fi


# each identifier needs to be listed in the case statement below
# for each identifier these three variables must be set:
#
# - downloadURL: 
#   URL to download the dmg
# 
# - appName:
#   file name of the app bundle in the dmg to verify and copy (include .app)
#
# - expectedTeamID:
#   10-digit developer team ID
#   obtain this by running 
#
#   spctl -a -vv Google\ Chrome.app
#
#   the team ID is the ten-digit ID at the end of the line starting with 'origin='

# target directory (remember to _omit_ last / )
targetDir="/Applications"
# this can be overridden below if you want a different location for a specific identifier

case $identifier in

    GoogleChrome)
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        appName="Google Chrome.app"
        expectedTeamID="EQHXZ8M8AV"
        ;;
    Spotify)
        downloadURL="https://download.scdn.co/Spotify.dmg"
        appName="Spotify.app"
        expectedTeamID="2FNC3A47ZF"
        ;;
    brokenDownloadURL)
        downloadURL="https://broken.com/broken.dmg"
        appName="Google Chrome.app"
        expectedTeamID="EQHXZ8M8AV"
        ;;
    brokenAppName)
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        appName="broken.app"
        expectedTeamID="EQHXZ8M8AV"
        ;;
    brokenTeamID)
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        appName="Google Chrome.app"
        expectedTeamID="broken"
        ;;
    *)
        # unknown identifier
        echo "unknown identifier $identifier"
        exit 1
        ;;
esac

dmgname="${downloadURL##*/}"

cleanupAndExit() { # $1 = exit code
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
    exit $1
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
    cleanupAndExit 1
fi

# TODO: when user is logged in, and app is running, prompt user to quit app

if [ -f "$dmgname" ] && [ "$DEBUG" -eq 1 ]; then
    echo "$dmgname exists and DEBUG enabled, skipping download"
else
    # download the dmg
    echo "Downloading $downloadURL"
    if ! curl --location --fail --silent "$downloadURL" -o "$dmgname"; then
        echo "error downloading $downloadURL"
        cleanupAndExit 2
    fi
fi

# mount the dmg
echo "Mounting $tmpDir/$dmgname"
# set -o pipefail
if ! dmgmount=$(hdiutil attach "$tmpDir/$dmgname" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
    echo "Error mounting $tmpDir/$dmgname"
    cleanupAndExit 3
fi
echo "Mounted: $dmgmount"

# check if app exists
if [ ! -e "$dmgmount/$appName" ]; then
    echo "could not find: $dmgmount/$appName"
    cleanupAndExit 8
fi

# verify with spctl
echo "Verifying: $dmgmount/$appName"
if ! teamID=$(spctl -a -vv "$dmgmount/$appName" 2>&1 | awk '/origin=/ {print $NF }' ); then
    echo "Error verifying $dmgmount/$appName"
    cleanupAndExit 4
fi

echo "Comparing Team IDs: ($expectedTeamID) $teamID"

if [ "($expectedTeamID)" != "$teamID" ]; then
    echo "Team IDs do not match!"
    cleanupAndExit 5
fi

# check for root
if [ "$(whoami)" != "root" ]; then
    # not running as root
    if [ "$DEBUG" -eq 0 ]; then
        echo "not running as root, exiting"
        cleanupAndExit 6
    fi
    
    echo "DEBUG enabled, skipping copy and chown steps"
    cleanupAndExit 0
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
    cleanupAndExit 7
fi


# set ownership to current users
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
if [ -n "$currentUser" ]; then
    echo "Changing owner to $currentUser"
    chown -R "$currentUser" "$targetDir/$appName" 
else
    echo "No user logged in, not changing user"
fi

# TODO: notify when done

# all done!
cleanupAndExit 0
