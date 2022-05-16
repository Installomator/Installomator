PKG_ID="com.scriptingosx.Installomator"
TARGET_VERSION="9.1"
URLDOWNLOAD="%MosyleCDNFile:blah-blah-blah%"
######################################################################
# Installation using Installomator (enter the software to install separated with spaces in the "whatList"-variable)
whatList="handbrake theunarchiver microsoftoffice365"
# Covered by Mosyle Catalog: "brave firefox googlechrome microsoftedge microsoftteams signal sublimetext vlc webex zoom" among others
LOGO="mosyleb" # or "mosylem"
######################################################################

## Mark: Code here

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid"
    pkill caffeinate
    exit $1
}

# Mark: Condition for Installomator installation

INSTALLED_VERSION="$(pkgutil --pkg-info $PKG_ID 2>/dev/null | grep -i "^version" | awk '{print $2}')"

echo "Current Version: ${INSTALLED_VERSION}"

if [[ "$TARGET_VERSION" != "$INSTALLED_VERSION" ]]; then
    TMPDIR=$(mktemp -d )
    if ! cd "$TMPDIR"; then
        echo "error changing directory $TMPDIR"
        caffexit 98
    fi
    NAME=$TMPDIR/$(date +%s).pkg
    if ! curl -fsL "$URLDOWNLOAD" -o "$NAME"; then
        echo "error downloading $URLDOWNLOAD to $NAME."
        caffexit 97
    fi
    installer -pkg "$NAME" -target /
    rm -rf "$TMPDIR"
else
    echo "Installomator version $INSTALLED_VERSION already installed!"
fi


# Mark: Start Installomator label(s) installation

# Count errors
errorCount=0

# Verify that Installomator has been installed
destFile="/usr/local/Installomator/Installomator.sh"
if [ ! -e "${destFile}" ]; then
    echo "Installomator not found here:"
    echo "${destFile}"
    echo "Exiting."
    caffexit 99
fi

for what in $whatList; do
    #echo $item
    # Install software using Installomator
    cmdOutput="$(${destFile} ${what} LOGO=$LOGO NOTIFY=all BLOCKING_PROCESS_ACTION=tell_user || true)" # NOTIFY=silent BLOCKING_PROCESS_ACTION=quit_kill INSTALL=force
    # Check result
    exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
    if [[ ${exitStatus} -ne 0 ]] ; then
        echo "Error installing ${what}. Exit code ${exitStatus}"
        #echo "$cmdOutput"
        errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
        echo "$errorOutput"
        let errorCount++
    fi
done

echo
echo "Errors: $errorCount"
echo "[$(DATE)][LOG-END]"

caffexit $errorCount
