#!/bin/zsh

# Specific settings in Addigy to configure Custom Software for installomator.
# Addigy has 3 parts to fill out for this, Installation script, Condition, and Removal steps (see RemoveInstallomator.sh).

# Mark: Installation script
# Just click “Add” to autogenerate the installer script line by clicking the “Add”-button next to the Installer PKG, replace with first line below
/usr/sbin/installer -pkg "/Library/Addigy/ansible/packages/Installomator (9.1.0)/Installomator-9.1.pkg" -target /

# Installation using Installomator
whatList="supportapp xink textmate microsoftedge wwdc keka vlc " # enter the software to installed  separated with spaces

# To be used as a script sent out from a MDM.
# Fill the variable "whatList" above with labels separated by space " ".
# Script will loop through these labels and exit with number of errors.
######################################################################
# Parameters for reinstall/initial install (owner root:wheel):
#   "BLOCKING_PROCESS_ACTION=quit_kill INSTALL=force IGNORE_APP_STORE_APPS=yes SYSTEMOWNER=1"
# Parameters for Self Service installed app:
#   "BLOCKING_PROCESS_ACTION=prompt_user NOTIFY=all"
# Parameters for security important apps, like browsers (run automaticaly every day):
#   "BLOCKING_PROCESS_ACTION=tell_user_then_kill"
# Update of service apps (run automatically):
#   "BLOCKING_PROCESS_ACTION=quit_kill NOTIFY=silent"
parameters="BLOCKING_PROCESS_ACTION=quit_kill INSTALL=force IGNORE_APP_STORE_APPS=yes"
######################################################################

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

# Count errors
errorCount=0

for what in $whatList; do
    #echo $what
    # Install software using Installomator
    cmdOutput="$(${destFile} ${what} LOGO=addigy $parameters || true)"
    # Check result
    exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
    if [[ ${exitStatus} -ne 0 ]] ; then
        echo -e "Error installing ${what}. Exit code ${exitStatus}"
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

# Mark: Conditions
# Install on success
# Remember to fill out the correct “TARGET_VERSION” and “PKG_ID”, and click "Install on succes".
PKG_ID="com.scriptingosx.Installomator"
TARGET_VERSION="9.1"

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
