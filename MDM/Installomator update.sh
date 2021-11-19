#!/bin/bash
# Updating Installomator
# Usefull to push out after deployment if earlier version was deployed in DEP profile
# Currently script uses valuesfromarguments as a label is not included before next release, so this can be used to install to version 0.7

what="installomator" # enter the software to install

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

${destFile} valuesfromarguments\
            name=Installomator \
            type=pkg \
            packageID=com.scriptingosx.Installomator \
            downloadURL=https://github.com/Installomator/Installomator/releases/download/v0.7release/Installomator-0.7.0.pkg \
            appNewVersion=0.7 \
            expectedTeamID=JME5BW3F3R \
            BLOCKING_PROCESS_ACTION=ignore \
            NOTIFY=silent

# ${destFile} ${what} BLOCKING_PROCESS_ACTION=ignore NOTIFY=silent
if [ $? != 0 ]; then
# This is currently not working in Mosyle, that will ignore script errors. Please request support for this from Mosyle!
    echo "Error installing ${what}. Exit code $?"
    caffexit $?
fi

echo "[$(DATE)][LOG-END]"
caffexit 0
