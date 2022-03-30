#!/bin/bash
# Software

# Installation using Installomator
# Example of installing software using valuesfromarguments to install a custom software

LOGO="appstore" # or "addigy", "microsoft", "mosyleb", "mosylem"
###############################################

# Verify that Installomator has been installed
destFile="/usr/local/Installomator/Installomator.sh"
if [ ! -e "${destFile}" ]; then
    echo "Installomator not found here:"
    echo "${destFile}"
    echo "Exiting."
    exit 99
fi

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid"
    pkill caffeinate
    exit $1
}

# Variables to calculate
downloadURL="https://craft-assets.invisionapp.com/CraftManager/production/CraftManager.zip"
appNewVersion=$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath -e '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f2)

# Install software using Installomator
cmdOutput="$(${destFile} valuesfromarguments LOGO=$LOGO \
    name=CraftManager \
    type=zip \
    downloadURL=$downloadURL \
    appNewVersion=$appNewVersion \
    expectedTeamID=VRXQSNCL5W \
    BLOCKING_PROCESS_ACTION=prompt_user \
    LOGGING=REQ \
    NOTIFY=all || true)"

# Check result
exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
if [[ ${exitStatus} -eq 0 ]] ; then
    echo -e "${what} succesfully installed.\n"
else
    echo -e "Error installing ${what}. Exit code ${exitStatus}\n"
    #printlog "$cmdOutput"
    errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
    echo "$errorOutput"
   	caffexit $exitStatus
fi

echo "[$(DATE)][LOG-END]"
caffexit 0
