#!/bin/zsh

# Specific settings in Addigy to configure Custom Software for installomator.
# Addigy has 3 parts to fill out for this, Installation script, Condition, and Removal steps (see RemoveInstallomator.sh).

# Mark: Installation script
# Just click “Add” to autogenerate the installer script line by clicking the “Add”-button next to the Installer PKG, replace with first line below
/usr/sbin/installer -pkg "/Library/Addigy/ansible/packages/Installomator (0.7.0)/Installomator-0.7.0.pkg" -target /

# Installation using Installomator
what="supportapp xink textmate microsoftedge wwdc keka vlc " # enter the software to installed  separated with spaces

# To be used as a script sent out from a MDM.
# Fill the variable "what" above with labels separated by space " ".
# Script will loop through these labels and exit with number of errors.
######################################################################

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid"
    exit $1
}

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
    ${destFile} ${item} LOGO=addigy NOTIFY=silent BLOCKING_PROCESS_ACTION=quit_kill #INSTALL=force
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

# Mark: Conditions
# Install on success
# Remember to fill out the correct “TARGET_VERSION” and “PKG_ID”, and click "Install on succes".
PKG_ID="com.scriptingosx.Installomator"
TARGET_VERSION="0.7.0"

vercomp () {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

INSTALLED_VERSION="$(pkgutil --pkg-info $PKG_ID | grep -i "^version" | awk '{print $2}')"

echo "Current Version: ${INSTALLED_VERSION}"

vercomp ${TARGET_VERSION} ${INSTALLED_VERSION}
COMP=$? # 0 means the same, 1 means TARGET is newer, 2 means INSTALLED is newer
echo "COMPARISON: ${COMP}"

if [ "${COMP}" -eq 1 ]; then
    echo "Installed version is older than ${TARGET_VERSION}."
    exit 0
else
    echo "Installed version is the same or newer than ${TARGET_VERSION}."
    exit 1
fi
