#!/bin/bash
# Installation using Installomator
# Example of installing software using valuesfromarguments to install a custom software

what="valuesfromarguments" # enter the software to install

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid"
    exit $1
}

# Verify that Installomator has been installed
destFile="/usr/local/Installomator/Installomator.sh"
if [ ! -e "${destFile}" ]; then
    echo "Installomator not found here:"
    echo "${destFile}"
    echo "Exiting."
    caffexit 99
fi

${destFile} valuesfromarguments \
            name=\"Zoho\ WorkDrive\" \
            type=dmg \
            downloadURL=https://files-accl.zohopublic.com/public/wdbin/download/46f971e4fc4a32b68ad5d7dade38a7d2 \
            appNewVersion=2.6.25 \
            expectedTeamID=TZ824L8Y37 \
            BLOCKING_PROCESS_ACTION=quit \
            NOTIFY=all

# ${destFile} ${what} BLOCKING_PROCESS_ACTION=ignore NOTIFY=silent
if [ $? != 0 ]; then
# This is currently not working in Mosyle, that will ignore script errors. Please request support for this from Mosyle!
    echo "Error installing ${what}. Exit code $?"
    caffexit $?
fi

echo "[$(DATE)][LOG-END]"
caffexit 0
