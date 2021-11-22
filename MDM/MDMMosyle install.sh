PKG_ID="com.scriptingosx.Installomator"
TARGET_VERSION="0.7.0"
URLDOWNLOAD="%MosyleCDNFile:blah-blah-blah%"
######################################################################
# Installation using Installomator (enter the software to install separated with spaces in the "what"-variable)
what="handbrake theunarchiver microsoftoffice365"
# Covered by Mosyle Catalog: "brave firefox googlechrome microsoftedge microsoftteams signal sublimetext vlc webex zoom" among others
######################################################################

## Mark: Code here

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid"
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

for item in $what; do
    #echo $item
    ${destFile} ${item} LOGO=mosyle NOTIFY=all BLOCKING_PROCESS_ACTION=tell_user #NOTIFY=silent BLOCKING_PROCESS_ACTION=quit_kill #INSTALL=force
    if [ $? != 0 ]; then
    # Error handling
        echo "[$(DATE)] Error installing ${item}. Exit code $?"
        let errorCount++
    fi
done

echo
echo "Errors: $errorCount"
echo "[$(DATE)][LOG-END]"

caffexit $errorCount
