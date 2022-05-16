#!/bin/bash
# Updating Installomator
# Usefull to push out after deployment if earlier version was deployed in DEP profile

what="installomator" # enter the software to install
LOGO="appstore" # or "addigy", "microsoft", "mosyleb", "mosylem"

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
cmdOutput="$(${destFile} ${what} LOGO=$LOGO BLOCKING_PROCESS_ACTION=ignore NOTIFY=silent LOGGING=req || true)"

# Check result
exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
if [[ ${exitStatus} -eq 0 ]] ; then
    echo -e "${what} succesfully installed.\n"
else
    echo -e "Error installing ${what}. Exit code ${exitStatus}\n"
    #echo "$cmdOutput"
    errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
    echo "$errorOutput"
   	caffexit $exitStatus
fi

echo "[$(DATE)][LOG-END]"
caffexit 0
