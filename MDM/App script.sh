#!/bin/zsh
# Installation using Installomator
what="brave" # enter the software to install

# To be used as a script sent out from a MDM.
# Fill the variable "what" above with a label.
# Script will run this label.
LOGO="appstore" # or "addigy", "microsoft", "mosyleb", "mosylem"
######################################################################
# Parameters for reinstall/initial install (owner root:wheel):
#   "BLOCKING_PROCESS_ACTION=quit_kill INSTALL=force IGNORE_APP_STORE_APPS=yes SYSTEMOWNER=1"
# Parameters for Self Service installed app:
#   "BLOCKING_PROCESS_ACTION=prompt_user NOTIFY=all"
# Parameters for security important apps, like browsers (run automaticaly every day):
#   "BLOCKING_PROCESS_ACTION=tell_user_then_kill"
# Update of service apps (run automatically):
#   "BLOCKING_PROCESS_ACTION=quit_kill NOTIFY=silent"
parameters="BLOCKING_PROCESS_ACTION=tell_user_then_kill NOTIFY=all"
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

cmdOutput="$(${destFile} ${what} LOGO=$LOGO $parameters LOGGING=WARN || true)"
# Check result
exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
if [[ ${exitStatus} -ne 0 ]] ; then
    echo -e "Error installing ${what}. Exit code ${exitStatus}"
    #echo "$cmdOutput"
    errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
    echo "$errorOutput"
    echo "Error installing ${what}. Exit code $?"
    caffexit $?
fi

echo "[$(DATE)][LOG-END]"

caffexit 0

# notify behavior
# NOTIFY=success
# options:
#   - success      notify the user on success
#   - silent       no notifications
#   - all          all notifications (great for Self Service installation)


# behavior when blocking processes are found
# BLOCKING_PROCESS_ACTION=tell_user
# options:
#   - ignore       continue even when blocking processes are found
#   - quit         app will be told to quit nicely, if running
#   - quit_kill    told to quit twice, then it will be killed
#                  Could be great for service apps, if they do not respawn
#   - silent_fail  exit script without prompt or installation
#   - prompt_user  show a user dialog for each blocking process found
#                  abort after three attempts to quit
#                  (only if user accepts to quit the apps, otherwise
#                  the update is cancelled).
#   - prompt_user_then_kill
#                  show a user dialog for each blocking process found,
#                  attempt to quit two times, kill the process finally
#   - prompt_user_loop
#                  Like prompt-user, but clicking "Not Now", will just wait an hour,
#                  and then it will ask again.
#                  WARNING! It might block the MDM agent on the machine, as
#                  the scripts gets stuct in waiting until the hour has passed,
#                  possibly blocking for other management actions in this time.
#   - tell_user    User will be showed a notification about the important update,
#                  but user is only allowed to quit and continue, and then we
#                  ask the app to quit.
#   - tell_user_then_kill
#                  Show dialog 2 times, and if the quitting fails, the
#                  blocking processes will be killed.
#   - kill         kill process without prompting or giving the user a chance to save


# logo-icon used in dialog boxes if app is blocking
# LOGO=appstore
# options:
#   - appstore      Icon is Apple App Store (default)
#   - jamf          JAMF Pro
#   - mosyleb       Mosyle Business
#   - mosylem       Mosyle Manager (Education)
#   - addigy        Addigy
# path can also be set in the command call, and if file exists, it will be used.
# Like 'LOGO="/System/Applications/App\ Store.app/Contents/Resources/AppIcon.icns"'
# (spaces have to be escaped).


# App Store apps handling
# IGNORE_APP_STORE_APPS=no
# options:
#  - no            If installed app is from App Store (which include VPP installed apps)
#                  it will not be touched, no matter it's version (default)
#  - yes           Replace App Store (and VPP) version of app and handle future
#                  updates using Installomator, even if latest version.
#                  Shouldn’t give any problems for the user in most cases.
#                  Known bad example: Slack will loose all settings.


# install behavior
# INSTALL=""
# options:
#  -               When not set, software will only be installed
#                  if it is newer/different in version
#  - force         Install even if it’s the same version


# Re-opening of closed app
# REOPEN="yes"
# options:
#  - yes           App wil be reopened if it was closed
#  - no            App not reopened


########################
# Often used labels:
########################

# firefox
# firefox_intl
# brave
# torbrowser
# googlechrome
# netnewswire

# adobereaderdc
# textmate

# cyberduck
# keka
# theunarchiver

# vlc
# handbrake

# inkscape

# signal
# telegram
# whatsapp

# hazel
# devonthink

# teamviewerqs
# zoom

# malwarebytes
# githubdesktop
# sublimetext
# textmate
# visualstudiocode

# microsoftskypeforbusiness
# microsoftteams
# microsoftyammer
# microsoftedgeenterprisestable
# microsoftedgeconsumerstable
# microsoftsharepointplugin
# microsoftdefenderatp

# googledrivefilestream

# cdef
# desktoppr
# supportapp
# xink
# wwdc
