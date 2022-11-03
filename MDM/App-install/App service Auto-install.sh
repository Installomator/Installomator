#!/bin/sh

# Installation using Installomator

LOGO="" # "mosyleb", "mosylem", "addigy", "microsoft", "ws1"

item="dockutil" # enter the software to install
# Examples: applenyfonts, applesfarabic, applesfcompact, applesfmono, applesfpro, applesfsymbols, desktoppr, dialog, dockutil, knockknock, lulu, nomad, nudge, shield, supportapp, wordservice, xcreds, xink

installomatorOptions="BLOCKING_PROCESS_ACTION=ignore NOTIFY=silent" # Separated by space

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
# To be used as a script sent out from a MDM.
# Fill the variable "item" above with a label.
# Script will run this label through Installomator.
######################################################################
# v.  9.2.1 : Better logging handling and installomatorOptions fix.
######################################################################

# Mark: Script
# PATH declaration
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

echo "$(date +%F\ %T) [LOG-BEGIN] $item"

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

# Install software using Installomator
cmdOutput="$(${destFile} ${item} LOGO=$LOGO ${installomatorOptions} || true)"

# Check result
exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
if [[ ${exitStatus} -eq 0 ]] ; then
    echo "${item} succesfully installed."
    warnOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "warn" || true )"
    echo "$warnOutput"
else
    echo "ERROR installing ${item}. Exit code ${exitStatus}"
    echo "$cmdOutput"
    #errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
    #echo "$errorOutput"
fi

echo "[$(DATE)][LOG-END]"

caffexit $exitStatus
