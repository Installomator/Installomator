#!/bin/zsh --no-rcs
label="" # if no label is sent to the script, this will be used

# Installomator
#
# Downloads and installs Applications
# 2020-2024 Installomator
#
# inspired by the download scripts from William Smith and Sander Schram
#
# Contributors:
#    Armin Briegel - @scriptingosx
#    Isaac Ordonez - @issacatmann
#    Søren Theilgaard - @Theile
#    Adam Codega - @acodega
#    Trevor Sysock - @BigMacAdmin
#
# with contributions from many others

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# NOTE: adjust these variables:

# set to 0 for production, 1 or 2 for debugging
# while debugging, items will be downloaded to the parent directory of this script
# also no actual installation will be performed
# debug mode 1 will download to the directory the script is run in, but will not check the version
# debug mode 2 will download to the temp directory, check for blocking processes, check the version, but will not install anything or remove the current version
DEBUG=1

# notify behavior
NOTIFY=success
# options:
#   - success      notify the user on success
#   - silent       no notifications
#   - all          all notifications (great for Self Service installation)

# time in seconds to wait for a prompt to be answered before exiting the script
PROMPT_TIMEOUT=86400
# Common times translated into seconds
# 60    =  1 minute
# 300   =  5 minutes
# 600   = 10 minutes
# 3600  =  1 hour
# 86400 = 24 hours (default)

# behavior when blocking processes are found
# BLOCKING_PROCESS_ACTION is ignored if app label uses updateTool
BLOCKING_PROCESS_ACTION=tell_user
# options:
#   - ignore       continue even when blocking processes are found
#   - quit         app will be told to quit nicely if running
#   - quit_kill    told to quit twice, then it will be killed
#                  Could be great for service apps if they do not respawn
#   - silent_fail  exit script without prompt or installation
#   - prompt_user  show a user dialog for each blocking process found,
#                  user can choose "Quit and Update" or "Not Now".
#                  When "Quit and Update" is chosen, blocking process
#                  will be told to quit. Installomator will wait 30 seconds
#                  before checking again in case Save dialogs etc are being responded to.
#                  Installomator will abort if quitting after three tries does not succeed.
#                  "Not Now" will exit Installomator.
#   - prompt_user_then_kill
#                  show a user dialog for each blocking process found,
#                  user can choose "Quit and Update" or "Not Now".
#                  When "Quit and Update" is chosen, blocking process
#                  will be terminated. Installomator will abort if terminating
#                  after two tries does not succeed. "Not Now" will exit Installomator.
#   - prompt_user_loop
#                  Like prompt-user, but clicking "Not Now", will just wait an hour,
#                  and then it will ask again.
#                  WARNING! It might block the MDM agent on the machine, as
#                  the script will not exit, it will pause until the hour has passed,
#                  possibly blocking for other management actions in this time.
#   - tell_user    User will be showed a notification about the important update,
#                  but user is only allowed to Quit and Continue, and then we
#                  ask the app to quit. This is default.
#   - tell_user_then_kill
#                  User will be showed a notification about the important update,
#                  but user is only allowed to Quit and Continue. If the quitting fails,
#                  the blocking processes will be terminated.
#   - kill         kill process without prompting or giving the user a chance to save


# logo-icon used in dialog boxes if app is blocking
LOGO=appstore
# options:
#   - appstore      Icon is Apple App Store (default)
#   - jamf          JAMF Pro
#   - mosyleb       Mosyle Business
#   - mosylem       Mosyle Manager (Education)
#   - addigy        Addigy
#   - microsoft     Microsoft Endpoint Manager (Intune)
#   - ws1           Workspace ONE (AirWatch)
#   - filewave      FileWave
#   - kandji        Kandji
# path can also be set in the command call, and if file exists, it will be used.
# Like 'LOGO="/System/Applications/App\ Store.app/Contents/Resources/AppIcon.icns"'
# (spaces have to be escaped).


# App Store apps handling
IGNORE_APP_STORE_APPS=no
# options:
#  - no            If the installed app is from App Store (which include VPP installed apps)
#                  it will not be touched, no matter its version (default)
#  - yes           Replace App Store (and VPP) version of the app and handle future
#                  updates using Installomator, even if latest version.
#                  Shouldn’t give any problems for the user in most cases.
#                  Known bad example: Slack will lose all settings.

# Owner of copied apps
SYSTEMOWNER=0
# options:
#  - 0             Current user will be owner of copied apps, just like if they
#                  installed it themselves (default).
#  - 1             root:wheel will be set on the copied app.
#                  Useful for shared machines.

# install behavior
INSTALL=""
# options:
#  -               When not set, the software will only be installed
#                  if it is newer/different in version
#  - force         Install even if it’s the same version


# Re-opening of closed app
REOPEN="yes"
# options:
#  - yes           App will be reopened if it was closed
#  - no            App not reopened

# Only let Installomator return the name of the label
# RETURN_LABEL_NAME=0
# options:
#   - 1      Installomator will return the name of the label and exit, so last line of
#            output will be that name. When Installomator is locally installed and we
#            use DEPNotify, then DEPNotify can present a more nice name to the user,
#            instead of just the label name.


# Interrupt Do Not Disturb (DND) full screen apps
INTERRUPT_DND="yes"
# options:
#  - yes           Script will run without checking for DND full screen apps.
#  - no            Script will exit when an active DND full screen app is detected.

# Comma separated list of app names to ignore when evaluating DND
IGNORE_DND_APPS=""
# example that will ignore browsers when evaluating DND:
# IGNORE_DND_APPS="firefox,Google Chrome,Safari,Microsoft Edge,Opera,Amphetamine,caffeinate"


# Use proxy for network access
PROXY=""
# Use this format for proxy: server.network.dns:port
# Configure proxy settings so that curl can work through that if needed.
# Port number is important for the check of access.
# Please note that some proxy configurations allow text download, but block binary downloads.
# So could be a situation where curl works for version, but not for download.
# This error line is then shown: “curl output was: curl: (22) The requested URL returned error: 403”


# Swift Dialog integration

# These variables will allow Installomator to communicate progress with Swift Dialog
# https://github.com/swiftDialog/swiftDialog

# This requires Swift Dialog 2.11.2 or higher.

DIALOG_CMD_FILE=""
# When this variable is set, Installomator will write Swift Dialog commands to this path.
# Installomator will not launch Swift Dialog. The process calling Installomator will have
# launch and configure Swift Dialog to listen to this file.
# See `MDM/swiftdialog_example.sh` for an example.

DIALOG_LIST_ITEM_NAME=""
# When this variable is set, progress for downloads and installs will be sent to this
# listitem.
# When the variable is unset, progress will be sent to Swift Dialog's main progress bar.

NOTIFY_DIALOG=0
# If this variable is set to 1, then we will check for installed Swift Dialog v. 2 or later, and use that for notification


# NOTE: How labels work

# Each workflow label needs to be listed in the case statement below.
# for each label these variables can be set:
#
# - name: (required)
#   Name of the installed app.
#   This is used to derive many of the other variables.
#
# - type: (required)
#   The type of the installation. Possible values:
#     - dmg
#     - pkg
#     - zip
#     - tbz
#     - pkgInDmg
#     - pkgInZip
#     - appInDmgInZip
#     - updateronly     This last one is for labels that should only run an updateTool (see below)
#
# - packageID: (optional)
#   The package ID of a pkg
#   If given, will be used to find the version of installed software, instead of searching for an app.
#   Usefull if a pkg does not install an app.
#   See label installomator_st
#
# - downloadURL: (required)
#   URL to download the dmg.
#   Can be generated with a series of commands (see BBEdit for an example).
#
# - curlOptions: (array, optional)
#   Options to the curl command, needed for curl to be able to download the software.
#   Usually used for adding extra headers that some servers need in order to serve the file.
#   curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
#   (See “mocha”-labels, for examples on labels, and buildLabel.sh for header-examples.)
#
# - appNewVersion: (optional)
#   Version of the downloaded software.
#   If given, it will be compared to the installed version, to see if the download is different.
#   It does not check for newer or not, only different.
#
# - versionKey: (optional)
#   How we get version number from app. Possible values:
#     - CFBundleShortVersionString
#     - CFBundleVersion
#   Not all software titles uses fields the same.
#   See Opera label.
#
# - appCustomVersion(){}: (optional function)
#   This function can be added to your label, if a specific custom
#   mechanism hs to be used for getting the installed version.
#   See labels zulujdk11, zulujdk13, zulujdk15
#
# - expectedTeamID: (required)
#   10-digit developer team ID.
#   Obtain the team ID by running:
#
#   - Applications (in dmgs or zips)
#     spctl -a -vv /Applications/BBEdit.app
#
#   - Pkgs
#     spctl -a -vv -t install ~/Downloads/desktoppr-0.2.pkg
#
#   The team ID is the ten-digit ID at the end of the line starting with 'origin='
#
# - archiveName: (optional)
#   The name of the downloaded file.
#   When not given the archiveName is derived from the $name.
#   Note: This has to be defined BEFORE calling downloadURLFromGit or
#   versionFromGit functions in the label.
#
# - appName: (optional)
#   File name of the app bundle in the dmg to verify and copy (include .app).
#   When not given, the appName is derived from the $name.
#
# - targetDir: (optional)
#   dmg or zip:
#     Applications will be copied to this directory.
#     Default value is '/Applications' for dmg and zip installations.
#   pkg:
#     targetDir is used as the install-location. Default is '/'.
#
# - blockingProcesses: (optional)
#   Array of process names that will block the installation or update.
#   If no blockingProcesses array is given the default will be:
#     blockingProcesses=( $name )
#   When a package contains multiple applications, _all_ should be listed, e.g:
#     blockingProcesses=( "Keynote" "Pages" "Numbers" )
#   When a workflow has no blocking processes, use
#     blockingProcesses=( NONE )
#
# - pkgName: (optional, only used for pkgInDmg, dmgInZip, and appInDmgInZip)
#   File name or path to the pkg/dmg file _inside_ the dmg or zip.
#   When not given the pkgName is derived from the $name
#
# - updateTool:
# - updateToolArguments:
#   When Installomator detects an existing installation of the application,
#   and the updateTool variable is set
#       $updateTool $updateArguments
#   Will be run instead of of downloading and installing a complete new version.
#   Use this when the updateTool does differential and optimized downloads.
#   e.g. msupdate on various Microsoft labels
#
# - updateToolRunAsCurrentUser:
#   When this variable is set (any value), $updateTool will be run as the current user.
#
# - CLIInstaller:
# - CLIArguments:
#   If the downloaded dmg is an installer that we can call using CLI, we can
#   use these two variables for what to call.
#   We need to define `name` for the installed app (to be version checked), as well as
#   `installerTool` for the installer app (if named differently than `name`. Installomator
#   will add the path to the folder/disk image with the binary, and it will be called like this:
#       $CLIInstaller $CLIArguments
#   For most installations `CLIInstaller` should contain the `installerTool` for the CLI call
#   (if it’s the same).
#   We can support a whole range of other software titles by implementing this.
#   See label adobecreativeclouddesktop
#
# - installerTool:
#   Introduced as part of `CLIInstaller`. If the installer in the DMG or ZIP is named
#   differently than the installed app, then this variable can be used to name the
#   installer that should be located after mounting/expanding the downloaded archive.
#   See label adobecreativeclouddesktop
#
### Logging
# Logging behavior
LOGGING="INFO"
# options:
#   - DEBUG     Everything is logged
#   - INFO      (default) normal logging level
#   - WARN      only warning
#   - ERROR     only errors
#   - REQ       ????

# MDM profile name
MDMProfileName=""
# options:
#   - MDM Profile               Addigy has this name on the profile
#   - Mosyle Corporation MDM    Mosyle uses this name on the profile
# From the LOGO variable we can know if Addigy og Mosyle is used, so if that variable
# is either of these, and this variable is empty, then we will auto detect this.

# Datadog logging used
datadogAPI=""
# Simply add your own API key for this in order to have logs sent to Datadog
# See more here: https://www.datadoghq.com/product/log-management/

# Log Date format used when parsing logs for debugging, this is the default used by
# install.log, override this in the case statements if you need something custom per
# application (See adobeillustrator).  Using stadard GNU Date formatting.
LogDateFormat="%Y-%m-%d %H:%M:%S"

# Get the start time for parsing install.log if we fail.
starttime=$(date "+$LogDateFormat")

# Check if we have rosetta installed
if [[ $(/usr/bin/arch) == "arm64" ]]; then
    if ! arch -x86_64 /usr/bin/true >/dev/null 2>&1; then # pgrep oahd >/dev/null 2>&1
        rosetta2=no
    fi
fi
VERSION="10.8"
VERSIONDATE="2025-03-31"

# MARK: Functions

cleanupAndExit() { # $1 = exit code, $2 message, $3 level
    if [ -n "$dmgmount" ]; then
        # unmount disk image
        printlog "Unmounting $dmgmount" DEBUG
        unmountingOut=$(hdiutil detach "$dmgmount" 2>&1)
        printlog "Debugging enabled, Unmounting output was:\n$unmountingOut" DEBUG
    fi
    if [ "$DEBUG" -ne 1 ]; then
        # remove the temporary working directory when done (only if DEBUG is not used)
        printlog "Deleting $tmpDir" DEBUG
        deleteTmpOut=$(rm -Rfv "$tmpDir")
        printlog "Debugging enabled, Deleting tmpDir output was:\n$deleteTmpOut" DEBUG
    fi

    # If we closed any processes, reopen the app again
    reopenClosedProcess
    if [[ -n $2 && $1 -ne 0 ]]; then
        printlog "ERROR: $2" $3
        updateDialog "fail" "Error ($1; $2)"
    else
        printlog "$2" $3
        updateDialog "success" ""
    fi
    printlog "################## End Installomator, exit code $1 \n" REQ

    # if label is wrong and we wanted name of the label, then return ##################
    if [[ $RETURN_LABEL_NAME -eq 1 ]]; then
        1=0 # If only label name should be returned we exit without any errors
        echo "#"
    fi
    exit "$1"
}

runAsUser() {
    if [[ $currentUser != "loginwindow" ]]; then
        uid=$(id -u "$currentUser")
        launchctl asuser $uid sudo -u $currentUser "$@"
    fi
}

reloadAsUser() {
    if [[ $currentUser != "loginwindow" ]]; then
        uid=$(id -u "$currentUser")
        su - $currentUser -c "${@}"
    fi
}

displaydialog() { # $1: message $2: title
    message=${1:-"Message"}
    title=${2:-"Installomator"}
    runAsUser osascript -e "button returned of (display dialog \"$message\" with  title \"$title\" buttons {\"Not Now\", \"Quit and Update\"} default button \"Quit and Update\" with icon POSIX file \"$LOGO\" giving up after $PROMPT_TIMEOUT)"
}

displaydialogContinue() { # $1: message $2: title
    message=${1:-"Message"}
    title=${2:-"Installomator"}
    runAsUser osascript -e "button returned of (display dialog \"$message\" with  title \"$title\" buttons {\"Quit and Update\"} default button \"Quit and Update\" with icon POSIX file \"$LOGO\")"
}

displaynotification() { # $1: message $2: title
    message=${1:-"Message"}
    title=${2:-"Notification"}
    manageaction="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"
    hubcli="/usr/local/bin/hubcli"
    swiftdialog="/usr/local/bin/dialog"

    if [[ "$($swiftdialog --version | cut -d "." -f1)" -ge 2 && "$NOTIFY_DIALOG" -eq 1 ]]; then
        "$swiftdialog" --notification --title "$title" --message "$message"
    elif [[ -x "$manageaction" ]]; then
         "$manageaction" -message "$message" -title "$title" &
    elif [[ -x "$hubcli" ]]; then
         "$hubcli" notify -t "$title" -i "$message" -c "Dismiss"
    else
        runAsUser osascript -e "display notification \"$message\" with title \"$title\""
    fi
}

printlog(){
    [ -z "$2" ] && 2=INFO
    log_message=$1
    log_priority=$2
    timestamp=$(date +%F\ %T)

    # Check to make sure that the log isn't the same as the last, if it is then don't log and increment a timer.
    if [[ ${log_message} == ${previous_log_message} ]]; then
        let logrepeat=$logrepeat+1
        return
    fi
    previous_log_message=$log_message

    # Extra spaces for log_priority alignment
    space_char=""
    if [[ ${#log_priority} -eq 3 ]]; then
        space_char="  "
    elif [[ ${#log_priority} -eq 4 ]]; then
        space_char=" "
    fi

    # Once we finally stop getting duplicate logs output the number of times we got a duplicate.
    if [[ $logrepeat -gt 1 ]];then
        echo "$timestamp" : "${log_priority}${space_char} : $label : Last Log repeated ${logrepeat} times" | tee -a $log_location

        if [[ ! -z $datadogAPI ]]; then
            curl -s -X POST https://http-intake.logs.datadoghq.com/v1/input -H "Content-Type: text/plain" -H "DD-API-KEY: $datadogAPI" -d "${log_priority} : $mdmURL : $APPLICATION : $VERSION : $SESSION : Last Log repeated ${logrepeat} times" > /dev/null
        fi
        logrepeat=0
    fi

    # If the datadogAPI key value is set and our logging level is greater than or equal to our set level
    # then post to Datadog's HTTPs endpoint.
    if [[ -n $datadogAPI && ${levels[$log_priority]} -ge ${levels[$datadogLoggingLevel]} ]]; then
        while IFS= read -r logmessage; do
            curl -s -X POST https://http-intake.logs.datadoghq.com/v1/input -H "Content-Type: text/plain" -H "DD-API-KEY: $datadogAPI" -d "${log_priority} : $mdmURL : Installomator-${label} : ${VERSIONDATE//-/} : $SESSION : ${logmessage}" > /dev/null
        done <<< "$log_message"
    fi

    # If our logging level is greaterthan or equal to our set level then output locally.
    if [[ ${levels[$log_priority]} -ge ${levels[$LOGGING]} ]]; then
        while IFS= read -r logmessage; do
            if [[ "$(whoami)" == "root" ]]; then
                echo "$timestamp" : "${log_priority}${space_char} : $label : ${logmessage}" | tee -a $log_location
            else
                echo "$timestamp" : "${log_priority}${space_char} : $label : ${logmessage}"
            fi
        done <<< "$log_message"
    fi
}

# Used to remove dupplicate lines in large log output,
# for example from msupdate command after it finishes running.
deduplicatelogs() {
    loginput=${1:-"Log"}
    logoutput=""
    # Read each line of the incoming log individually, match it with the previous.
    # If it matches increment logrepeate then skip to the next line.
    while read log; do
        if [[ $log == $previous_log ]];then
            let logrepeat=$logrepeat+1
            continue
        fi

        previous_log="$log"
        if [[ $logrepeat -gt 1 ]];then
            logoutput+="Last Log repeated ${logrepeat} times\n"
            logrepeat=0
        fi

        logoutput+="$log\n"
    done <<< "$loginput"
}

# will get the latest release download from a github repo
downloadURLFromGit() { # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}

    if [[ $type == "pkgInDmg" ]]; then
        filetype="dmg"
    elif [[ $type == "pkgInZip" ]]; then
        filetype="zip"
    else
        filetype=$type
    fi

    if [ -n "$archiveName" ]; then
        downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$archiveName\"/ { print \$4; exit }")
        if [[ "$(echo $downloadURL | grep -ioE "https.*$archiveName")" == "" ]]; then
            #downloadURL=https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*$archiveName" | head -1)
            downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*$archiveName" | head -1)"
        fi
    else
        downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
        if [[ "$(echo $downloadURL | grep -ioE "https.*.$filetype")" == "" ]]; then
            #downloadURL=https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)
            downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
        fi
    fi
    if [ -z "$downloadURL" ]; then
        cleanupAndExit 14 "could not retrieve download URL for $gitusername/$gitreponame" ERROR
    else
        echo "$downloadURL"
        return 0
    fi
}

versionFromGit() {
    # credit: Søren Theilgaard (@theilgaard)
    # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}

    #appNewVersion=$(curl -L --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | grep tag_name | cut -d '"' -f 4 | sed 's/[^0-9\.]//g')
    appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
    if [ -z "$appNewVersion" ]; then
        printlog "could not retrieve version number for $gitusername/$gitreponame" WARN
        appNewVersion=""
    else
        echo "$appNewVersion"
        return 0
    fi
}


# Handling of differences in xpath between Catalina and Big Sur
xpath() {
	# the xpath tool changes in Big Sur and now requires the `-e` option
	if [[ $(sw_vers -buildVersion) > "20A" ]]; then
		/usr/bin/xpath -q -e $@
		# alternative: switch to xmllint (which is not perl)
		#xmllint --xpath $@ -
	else
		/usr/bin/xpath -q $@
	fi
}

# from @Pico: https://macadmins.slack.com/archives/CGXNNJXJ9/p1652222365989229?thread_ts=1651786411.413349&cid=CGXNNJXJ9
getJSONValue() {
	# $1: JSON string OR file path to parse (tested to work with up to 1GB string and 2GB file).
	# $2: JSON key path to look up (using dot or bracket notation).
	printf '%s' "$1" | /usr/bin/osascript -l 'JavaScript' \
		-e "let json = $.NSString.alloc.initWithDataEncoding($.NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile$(/usr/bin/uname -r | /usr/bin/awk -F '.' '($1 > 18) { print "AndReturnError(ObjC.wrap())" }'), $.NSUTF8StringEncoding)" \
		-e 'if ($.NSFileManager.defaultManager.fileExistsAtPath(json)) json = $.NSString.stringWithContentsOfFileEncodingError(json, $.NSUTF8StringEncoding, ObjC.wrap())' \
		-e "const value = JSON.parse(json.js)$([ -n "${2%%[.[]*}" ] && echo '.')$2" \
		-e 'if (typeof value === "object") { JSON.stringify(value, null, 4) } else { value }'
}

getAppVersion() {
    # modified by: Søren Theilgaard (@theilgaard) and Isaac Ordonez

    # If label contain function appCustomVersion, we use that and return
    if type 'appCustomVersion' 2>/dev/null | grep -q 'function'; then
        appversion=$(appCustomVersion)
        printlog "Custom App Version detection is used, found $appversion"
        return
    fi

    # pkgs contains a version number, then we don't have to search for an app
    if [[ $packageID != "" ]]; then
        appversion="$(pkgutil --pkg-info-plist ${packageID} 2>/dev/null | grep -A 1 pkg-version | tail -1 | sed -E 's/.*>([0-9.]*)<.*/\1/g')"
        if [[ $appversion != "" ]]; then
            printlog "found packageID $packageID installed, version $appversion"
            updateDetected="YES"
            return
        else
            printlog "No version found using packageID $packageID"
        fi
    fi

    # get app in targetDir, /Applications, or /Applications/Utilities
    if [[ -d "$targetDir/$appName" ]]; then
        applist="$targetDir/$appName"
    elif [[ -d "/Applications/$appName" ]]; then
        applist="/Applications/$appName"
#        if [[ $type =~ '^(dmg|zip|tbz|app.*)$' ]]; then
#            targetDir="/Applications"
#        fi
    elif [[ -d "/Applications/Utilities/$appName" ]]; then
        applist="/Applications/Utilities/$appName"
#        if [[ $type =~ '^(dmg|zip|tbz|app.*)$' ]]; then
#            targetDir="/Applications/Utilities"
#        fi
    else
        printlog "name: $name, appName: $appName"
        # mdfind now handling if kind is either Application or App
        applist=$(mdfind "kMDItemContentType:com.apple.application AND kMDItemFSName:\"$name\"" -0 2>/dev/null)
#        applist=$(mdfind "kMDItemContentType:com.apple.application AND kMDItemFSName:\"$appName\"" -0 2>/dev/null)
#        printlog "App(s) found: ${applist}" DEBUG
    fi
    if [[ -z $applist ]]; then
        printlog "No previous app found" WARN
    else
        printlog "App(s) found: ${applist}" INFO
    fi
#    if [[ $type =~ '^(dmg|zip|tbz|app.*)$' ]]; then
#        printlog "targetDir for installation: $targetDir" INFO
#    fi

    appPathArray=( ${(0)applist} )

    if [[ ${#appPathArray} -gt 0 ]]; then
        filteredAppPaths=( ${(M)appPathArray:#${targetDir}*} )
        if [[ ${#filteredAppPaths} -eq 1 ]]; then
            installedAppPath=$filteredAppPaths[1]
            #appversion=$(mdls -name kMDItemVersion -raw $installedAppPath )
            appversion=$(defaults read $installedAppPath/Contents/Info.plist $versionKey) #Not dependant on Spotlight indexing
            printlog "found app at $installedAppPath, version $appversion, on versionKey $versionKey"
            updateDetected="YES"
            # Is current app from App Store
            if [[ -d "$installedAppPath"/Contents/_MASReceipt ]];then
                printlog "Installed $appName is from App Store, use “IGNORE_APP_STORE_APPS=yes” to replace."
                if [[ $IGNORE_APP_STORE_APPS == "yes" ]]; then
                    printlog "Replacing App Store apps, no matter the version" WARN
                    appversion=0
                else
                    if [[ $DIALOG_CMD_FILE != "" ]]; then
                        updateDialog "wait" "Already installed from App Store. Not replaced."
                        sleep 4
                    fi
                    cleanupAndExit 23 "App previously installed from App Store, and we respect that" ERROR
                fi
            fi
        else
            printlog "could not determine location of $appName" WARN
        fi
    else
        printlog "could not find $appName" WARN
    fi
}

checkRunningProcesses() {
    # don't check in DEBUG mode 1
    if [[ $DEBUG -eq 1 ]]; then
        printlog "DEBUG mode 1, not checking for blocking processes" DEBUG
        return
    fi

    # try at most 3 times
    for i in {1..4}; do
        countedProcesses=0
        for x in ${blockingProcesses}; do
            if pgrep -xq "$x"; then
                printlog "found blocking process $x"
                appClosed=1

                case $BLOCKING_PROCESS_ACTION in
                    quit|quit_kill)
                        printlog "telling app $x to quit"
                        runAsUser osascript -e "tell app \"$x\" to quit"
                        if [[ $i > 2 && $BLOCKING_PROCESS_ACTION = "quit_kill" ]]; then
                          printlog "Changing BLOCKING_PROCESS_ACTION to kill"
                          BLOCKING_PROCESS_ACTION=kill
                        else
                            # give the user a bit of time to quit apps
                            printlog "waiting 30 seconds for processes to quit"
                            sleep 30
                        fi
                        ;;
                    kill)
                      printlog "killing process $x"
                      pkill $x
                      sleep 5
                      ;;
                    prompt_user|prompt_user_then_kill)
                      button=$(displaydialog "Quit “$x” to continue updating? $([[ -n $appNewVersion ]] && echo "Version $appversion is installed, but version $appNewVersion is available.") (Leave this dialogue if you want to activate this update later)." "The application “$x” needs to be updated.")
                      if [[ $button = "Not Now" ]]; then
                        appClosed=0
                        cleanupAndExit 10 "user aborted update" ERROR
                      elif [[ $button = "" ]]; then
                        appClosed=0
                        cleanupAndExit 25 "timed out waiting for user response" ERROR
                      else
                        if [[ $BLOCKING_PROCESS_ACTION = "prompt_user_then_kill" ]]; then
                          # try to quit, then set to kill
                          printlog "telling app $x to quit"
                          runAsUser osascript -e "tell app \"$x\" to quit"
                          # give the user a bit of time to quit apps
                          printlog "waiting 30 seconds for processes to quit"
                          sleep 30
                          printlog "Changing BLOCKING_PROCESS_ACTION to kill"
                          BLOCKING_PROCESS_ACTION=kill
                        else
                          printlog "telling app $x to quit"
                          runAsUser osascript -e "tell app \"$x\" to quit"
                          # give the user a bit of time to quit apps
                          printlog "waiting 30 seconds for processes to quit"
                          sleep 30
                        fi
                      fi
                      ;;
                    prompt_user_loop)
                      button=$(displaydialog "Quit “$x” to continue updating? $([[ -n $appNewVersion ]] && echo "Version $appversion is installed, but version $appNewVersion is available.") (Click “Not Now” to be asked in 1 hour, or leave this open until you are ready)." "The application “$x” needs to be updated.")
                      if [[ $button = "Not Now" ]]; then
                        if [[ $i < 2 ]]; then
                          printlog "user wants to wait an hour"
                          sleep 3600 # 3600 seconds is an hour
                        else
                          printlog "change of BLOCKING_PROCESS_ACTION to tell_user"
                          BLOCKING_PROCESS_ACTION=tell_user
                        fi
                      else
                        printlog "telling app $x to quit"
                        runAsUser osascript -e "tell app \"$x\" to quit"
                        # give the user a bit of time to quit apps
                        printlog "waiting 30 seconds for processes to quit"
                        sleep 30
                      fi
                      ;;
                    tell_user|tell_user_then_kill)
                      button=$(displaydialogContinue "Quit “$x” to continue updating? (This is an important update). Wait for notification of update before launching app again." "The application “$x” needs to be updated.")
                      printlog "telling app $x to quit"
                      runAsUser osascript -e "tell app \"$x\" to quit"
                      # give the user a bit of time to quit apps
                      printlog "waiting 30 seconds for processes to quit"
                      sleep 30
                      if [[ $i > 1 && $BLOCKING_PROCESS_ACTION = tell_user_then_kill ]]; then
                          printlog "Changing BLOCKING_PROCESS_ACTION to kill"
                          BLOCKING_PROCESS_ACTION=kill
                      fi
                      ;;
                    silent_fail)
                      appClosed=0
                      cleanupAndExit 12 "blocking process '$x' found, aborting" ERROR
                      ;;
                esac

                countedProcesses=$((countedProcesses + 1))
            fi
        done

    done

    if [[ $countedProcesses -ne 0 ]]; then
        cleanupAndExit 11 "could not quit all processes, aborting..." ERROR
    fi

    printlog "no more blocking processes, continue with update" REQ
}

reopenClosedProcess() {
    # If Installomator closed any processes, let's get the app opened again
    # credit: Søren Theilgaard (@theilgaard)

    # don't reopen if REOPEN is not "yes"
    if [[ $REOPEN != yes ]]; then
        printlog "REOPEN=no, not reopening anything"
        return
    fi

    # don't reopen in DEBUG mode 1
    if [[ $DEBUG -eq 1 ]]; then
        printlog "DEBUG mode 1, not reopening anything" DEBUG
        return
    fi

    if [[ $appClosed == 1 ]]; then
        printlog "Telling app $appName to open"
        #runAsUser osascript -e "tell app \"$appName\" to open"
        #runAsUser open -a "${appName}"
        reloadAsUser "open -a \"${appName}\""
        #reloadAsUser "open \"${(0)applist}\""
        processuser=$(ps aux | grep -i "${appName}" | grep -vi "grep" | awk '{print $1}')
        printlog "Reopened ${appName} as $processuser"
    else
        printlog "Installomator did not close any apps, so no need to reopen any apps." INFO
    fi
}

installAppWithPath() { # $1: path to app to install in $targetDir $2: path to folder (with app inside) to copy to $targetDir
    # modified by: Søren Theilgaard (@theilgaard)
    appPath=${1?:"no path to app"}
    # If $2 ends in "/" then a folderName has not been specified so don't set it.
    if [[ ! "${2}" == */ ]]; then
        folderPath="${2}"
    fi

    # check if app exists
    if [ ! -e "$appPath" ]; then
        cleanupAndExit 8 "could not find: $appPath" ERROR
    fi

    # check if folder path exists if it is set
    if [[ -n "$folderPath" ]] && [[ ! -e "$folderPath" ]]; then
        cleanupAndExit 8 "could not find folder: $folderPath" ERROR
    fi

    # verify with spctl
    printlog "Verifying: $appPath" INFO
    updateDialog "wait" "Verifying..."
    printlog "App size: $(du -sh "$appPath")" DEBUG
    appVerify=$(spctl -a -vv "$appPath" 2>&1 )
    appVerifyStatus=$(echo $?)
    teamID=$(echo $appVerify | awk '/origin=/ {print $NF }' | tr -d '()' )
    deduplicatelogs "$appVerify"

    if [[ $appVerifyStatus -ne 0 ]] ; then
    #if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' ); then
        cleanupAndExit 4 "Error verifying $appPath error:\n$logoutput" ERROR
    fi
    printlog "Debugging enabled, App Verification output was:\n$logoutput" DEBUG
    printlog "Team ID matching: $teamID (expected: $expectedTeamID )" INFO

    if [ "$expectedTeamID" != "$teamID" ]; then
        cleanupAndExit 5 "Team IDs do not match" ERROR
    fi

    # app versioncheck
    appNewVersion=$(defaults read $appPath/Contents/Info.plist $versionKey)
    if [[ -n $appNewVersion && $appversion == $appNewVersion ]]; then
        printlog "Downloaded version of $name is $appNewVersion on versionKey $versionKey, same as installed."
        if [[ $INSTALL != "force" ]]; then
            message="$name, version $appNewVersion, is the latest version."
            if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                printlog "notifying"
                displaynotification "$message" "No update for $name!"
            fi
            if [[ $DIALOG_CMD_FILE != "" ]]; then
                updateDialog "wait" "Latest version already installed..."
                sleep 2
            fi
            cleanupAndExit 0 "No new version to install" REG
        else
            printlog "Using force to install anyway."
        fi
    elif [[ -z $appversion ]]; then
        printlog "Installing $name version $appNewVersion on versionKey $versionKey."
    else
        printlog "Downloaded version of $name is $appNewVersion on versionKey $versionKey (replacing version $appversion)."
    fi

    # macOS versioncheck
    minimumOSversion=$(defaults read $appPath/Contents/Info.plist LSMinimumSystemVersion 2>/dev/null )
    if [[ -n $minimumOSversion && $minimumOSversion =~ '[0-9.]*' ]]; then
        printlog "App has LSMinimumSystemVersion: $minimumOSversion"
        if ! is-at-least $minimumOSversion $installedOSversion; then
            printlog "App requires higher System Version than installed: $installedOSversion"
            message="Cannot install $name, version $appNewVersion, as it is not compatible with the running system version."
            if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                printlog "notifying"
                displaynotification "$message" "Error updating $name!"
            fi
            cleanupAndExit 15 "Installed macOS is too old for this app." ERROR
        fi
    fi

    # skip install for DEBUG 1
    if [ "$DEBUG" -eq 1 ]; then
        printlog "DEBUG mode 1 enabled, skipping remove, copy and chown steps" DEBUG
        return 0
    fi

    # skip install for DEBUG 2
    if [ "$DEBUG" -eq 2 ]; then
        printlog "DEBUG mode 2 enabled, not installing anything, exiting" DEBUG
        cleanupAndExit 0
    fi

    # Test if variable CLIInstaller is set
    if [[ -z $CLIInstaller ]]; then

        # remove existing application
        if [ -e "$targetDir/$appName" ]; then
            printlog "Removing existing $targetDir/$appName" WARN
            deleteAppOut=$(rm -Rfv "$targetDir/$appName" 2>&1)
            tempName="$targetDir/$appName"
            tempNameLength=$((${#tempName} + 10))
            deleteAppOut=$(echo $deleteAppOut | cut -c 1-$tempNameLength)
            deduplicatelogs "$deleteAppOut"
            printlog "Debugging enabled, App removing output was:\n$logoutput" DEBUG
        fi

        # copy app to /Applications
        printlog "Copy $appPath to $targetDir"
        if [[ -n $folderPath ]]; then
            copyAppOut=$(ditto -v "$folderPath" "$targetDir/$folderName" 2>&1)
        else
            copyAppOut=$(ditto -v "$appPath" "$targetDir/$appName" 2>&1)
        fi
        copyAppStatus=$(echo $?)
        deduplicatelogs "$copyAppOut"
        printlog "Debugging enabled, App copy output was:\n$logoutput" DEBUG
        if [[ $copyAppStatus -ne 0 ]] ; then
        #if ! ditto "$appPath" "$targetDir/$appName"; then
            cleanupAndExit 7 "Error while copying:\n$logoutput" ERROR
        fi

        # set ownership to current user
        if [[ "$currentUser" != "loginwindow" && $SYSTEMOWNER -ne 1 ]]; then
            printlog "Changing owner to $currentUser" WARN
            chown -R "$currentUser" "$targetDir/$appName"
        else
            printlog "No user logged in or SYSTEMOWNER=1, setting owner to root:wheel" WARN
            chown -R root:wheel "$targetDir/$appName"
        fi

    elif [[ ! -z $CLIInstaller ]]; then
        mountname=$(dirname $appPath)
        printlog "CLIInstaller exists, running installer command $mountname/$CLIInstaller $CLIArguments" INFO

        CLIoutput=$("$mountname/$CLIInstaller" "${CLIArguments[@]}" 2>&1)
        CLIstatus=$(echo $?)
        deduplicatelogs "$CLIoutput"

        if [ $CLIstatus -ne 0 ] ; then
            cleanupAndExit 16 "Error installing $mountname/$CLIInstaller $CLIArguments error:\n$logoutput" ERROR
        else
            printlog "Succesfully ran $mountname/$CLIInstaller $CLIArguments" INFO
        fi
        printlog "Debugging enabled, update tool output was:\n$logoutput" DEBUG
    fi

}

mountDMG() {
    # mount the dmg
    printlog "Mounting $tmpDir/$archiveName"
    # always pipe 'Y\n' in case the dmg requires an agreement
    dmgmountOut=$(echo 'Y'$'\n' | hdiutil attach "$tmpDir/$archiveName" -nobrowse -readonly )
    dmgmountStatus=$(echo $?)
    dmgmount=$(echo $dmgmountOut | tail -n 1 | cut -c 54- )
    deduplicatelogs "$dmgmountOut"

    if [[ $dmgmountStatus -ne 0 ]] ; then
    #if ! dmgmount=$(echo 'Y'$'\n' | hdiutil attach "$tmpDir/$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        cleanupAndExit 3 "Error mounting $tmpDir/$archiveName error:\n$logoutput" ERROR
    fi
    if [[ ! -e $dmgmount ]]; then
        cleanupAndExit 3 "Error accessing mountpoint for $tmpDir/$archiveName error:\n$logoutput" ERROR
    fi
    printlog "Debugging enabled, dmgmount output was:\n$logoutput" DEBUG

    printlog "Mounted: $dmgmount" INFO
}

installFromDMG() {
    mountDMG
    installAppWithPath "$dmgmount/$appName" "$dmgmount/$folderName"
}

installFromPKG() {
    # verify with spctl
    printlog "Verifying: $archiveName"
    updateDialog "wait" "Verifying..."
    printlog "File list: $(ls -lh "$archiveName")" DEBUG
    printlog "File type: $(file "$archiveName")" DEBUG
    spctlOut=$(spctl -a -vv -t install "$archiveName" 2>&1 )
    spctlStatus=$(echo $?)
    printlog "spctlOut is $spctlOut" DEBUG

    teamID=$(echo $spctlOut | awk -F '(' '/origin=/ {print $2 }' | tr -d '()' )
    # Apple signed software has no teamID, grab entire origin instead
    if [[ -z $teamID ]]; then
        teamID=$(echo $spctlOut | awk -F '=' '/origin=/ {print $NF }')
    fi

    deduplicatelogs "$spctlOut"

    if [[ $spctlStatus -ne 0 ]] ; then
    #if ! spctlout=$(spctl -a -vv -t install "$archiveName" 2>&1 ); then
        cleanupAndExit 4 "Error verifying $archiveName error:\n$logoutput" ERROR
    fi

    # Apple signed software has no teamID, grab entire origin instead
    if [[ -z $teamID ]]; then
        teamID=$(echo $spctlout | awk -F '=' '/origin=/ {print $NF }')
    fi

    printlog "Team ID: $teamID (expected: $expectedTeamID )"

    if [ "$expectedTeamID" != "$teamID" ]; then
        cleanupAndExit 5 "Team IDs do not match!" ERROR
    fi

    # Check version of pkg to be installed if packageID is set
    if [[ $packageID != "" && $appversion != "" ]]; then
        printlog "Checking package version."
        baseArchiveName=$(basename $archiveName)
        expandedPkg="$tmpDir/${baseArchiveName}_pkg"
        pkgutil --expand "$archiveName" "$expandedPkg"
        appNewVersion=$(cat "$expandedPkg"/Distribution | xpath "string(//installer-gui-script/pkg-ref[@id='$packageID'][@version]/@version)" 2>/dev/null )
        rm -r "$expandedPkg"
        printlog "Downloaded package $packageID version $appNewVersion"
        if [[ $appversion == $appNewVersion ]]; then
            printlog "Downloaded version of $name is the same as installed."
            if [[ $INSTALL != "force" ]]; then
                message="$name, version $appNewVersion, is the latest version."
                if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                    printlog "notifying"
                    displaynotification "$message" "No update for $name!"
                fi
                if [[ $DIALOG_CMD_FILE != "" ]]; then
                    updateDialog "wait" "Latest version already installed..."
                    sleep 2
                fi
                cleanupAndExit 0 "No new version to install" REQ
            else
                printlog "Using force to install anyway."
            fi
        fi
    fi

    # skip install for DEBUG 1
    if [ "$DEBUG" -eq 1 ]; then
        printlog "DEBUG enabled, skipping installation" DEBUG
        return 0
    fi

    # skip install for DEBUG 2
    if [ "$DEBUG" -eq 2 ]; then
        cleanupAndExit 0 "DEBUG mode 2 enabled, exiting" DEBUG
    fi

    # install pkg
    printlog "Installing $archiveName to $targetDir"

    if [[ $DIALOG_CMD_FILE != "" ]]; then
        # pipe
        pipe="$tmpDir/installpipe"
        # initialise named pipe for installer output
        initNamedPipe create $pipe

        # run the pipe read in the background
        readPKGInstallPipe $pipe "$DIALOG_CMD_FILE" & installPipePID=$!
        printlog "listening to output of installer with pipe $pipe and command file $DIALOG_CMD_FILE on PID $installPipePID" DEBUG

        pkgInstall=$(installer -verboseR -pkg "$archiveName" -tgt "$targetDir" 2>&1 | tee $pipe)
        pkgInstallStatus=$pipestatus[1]
            # because we are tee-ing the output, we want the pipe status of the first command in the chain, not the most recent one
        killProcess $installPipePID

    else
        pkgInstall=$(installer -verbose -dumplog -pkg "$archiveName" -tgt "$targetDir" 2>&1)
        pkgInstallStatus=$(echo $?)
    fi



    sleep 1
    pkgEndTime=$(date "+$LogDateFormat")
    pkgInstall+=$(echo "\nOutput of /var/log/install.log below this line.\n")
    pkgInstall+=$(echo "----------------------------------------------------------\n")
    pkgInstall+=$(awk -v "b=$starttime" -v "e=$pkgEndTime" -F ',' '$1 >= b && $1 <= e' /var/log/install.log)
    deduplicatelogs "$pkgInstall"

    if [[ $pkgInstallStatus -ne 0 ]] && [[ $logoutput == *"requires Rosetta 2"* ]] && [[ $rosetta2 == no ]]; then
        printlog "Package requires Rosetta 2, Installing Rosetta 2 and Installing Package" INFO
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        rosetta2=yes
        installFromPKG
    fi

    if [[ $pkginstallstatus -ne 0 ]] ; then
    #if ! installer -pkg "$archiveName" -tgt "$targetDir" ; then
        cleanupAndExit 9 "Error installing $archiveName error:\n$logoutput" ERROR
    fi
    printlog "Debugging enabled, installer output was:\n$logoutput" DEBUG
}

installFromZIP() {
    # unzip the archive
    printlog "Unzipping $archiveName"

    # tar -xf "$archiveName"

    # note: when you expand a zip using tar in Mojave the expanded
    # app will never pass the spctl check

    # unzip -o -qq "$archiveName"

    # note: githubdesktop fails spctl verification when expanded
    # with unzip

    ditto -x -k "$archiveName" "$tmpDir"
    installAppWithPath "$tmpDir/$appName"
}

installFromTBZ() {
    # unzip the archive
    printlog "Unzipping $archiveName"
    tar -xf "$archiveName"
    installAppWithPath "$tmpDir/$appName"
}

installPkgInDmg() {
    mountDMG
    # locate pkg in dmg
    if [[ -z $pkgName ]]; then
        # find first file ending with 'pkg'
        findfiles=$(find "$dmgmount" -iname "*.pkg" -type f -maxdepth 1  )
        printlog "Found pkg(s):\n$findfiles" DEBUG
        filearray=( ${(f)findfiles} )
        if [[ ${#filearray} -eq 0 ]]; then
            cleanupAndExit 20 "couldn't find pkg in dmg $archiveName" ERROR
        fi
        archiveName="${filearray[1]}"
    else
        if [[ -s "$dmgmount/$pkgName" ]] ; then # was: $tmpDir
            archiveName="$dmgmount/$pkgName"
        else
            # try searching for pkg
            findfiles=$(find "$dmgmount" -iname "$pkgName") # was: $tmpDir
            printlog "Found pkg(s):\n$findfiles" DEBUG
            filearray=( ${(f)findfiles} )
            if [[ ${#filearray} -eq 0 ]]; then
                cleanupAndExit 20 "couldn't find pkg “$pkgName” in dmg $archiveName" ERROR
            fi
            # it is now safe to overwrite archiveName for installFromPKG
            archiveName="${filearray[1]}"
        fi
    fi
    printlog "found pkg: $archiveName"

    # installFromPkgs
    installFromPKG
}

installPkgInZip() {
    # unzip the archive
    printlog "Unzipping $archiveName"
    tar -xf "$archiveName"

    # locate pkg in zip
    if [[ -z $pkgName ]]; then
        # find first file ending with 'pkg'
        findfiles=$(find "$tmpDir" -iname "*.pkg" -type f -maxdepth 2  )
        printlog "Found pkg(s):\n$findfiles" DEBUG
        filearray=( ${(f)findfiles} )
        if [[ ${#filearray} -eq 0 ]]; then
            cleanupAndExit 21 "couldn't find pkg in zip $archiveName" ERROR
        fi
        # it is now safe to overwrite archiveName for installFromPKG
        archiveName="${filearray[1]}"
        printlog "found pkg: $archiveName"
    else
        if [[ -s "$tmpDir/$pkgName" ]]; then
            archiveName="$tmpDir/$pkgName"
        else
            # try searching for pkg
            findfiles=$(find "$tmpDir" -iname "$pkgName")
            filearray=( ${(f)findfiles} )
            if [[ ${#filearray} -eq 0 ]]; then
                cleanupAndExit 21 "couldn't find pkg “$pkgName” in zip $archiveName" ERROR
            fi
            # it is now safe to overwrite archiveName for installFromPKG
            archiveName="${filearray[1]}"
            printlog "found pkg: $archiveName"
        fi
    fi

    # installFromPkgs
    installFromPKG
}

installAppInDmgInZip() {
    # unzip the archive
    printlog "Unzipping $archiveName"
    tar -xf "$archiveName"

    # locate dmg in zip
    if [[ -z $pkgName ]]; then
        # find first file ending with 'dmg'
        findfiles=$(find "$tmpDir" -iname "*.dmg" -maxdepth 2  )
        filearray=( ${(f)findfiles} )
        if [[ ${#filearray} -eq 0 ]]; then
            cleanupAndExit 22 "couldn't find dmg in zip $archiveName" ERROR
        fi
        archiveName="$(basename ${filearray[1]})"
        # it is now safe to overwrite archiveName for installFromDMG
        printlog "found dmg: $tmpDir/$archiveName"
    else
        # it is now safe to overwrite archiveName for installFromDMG
        archiveName="$pkgName"
    fi

    # installFromDMG, DMG expected to include an app (will not work with pkg)
    installFromDMG
}

runUpdateTool() {
    printlog "Function called: runUpdateTool"
    if [[ -x $updateTool ]]; then
        printlog "running $updateTool $updateToolArguments"
        if [[ -n $updateToolRunAsCurrentUser ]]; then
            updateOutput=$(runAsUser $updateTool ${updateToolArguments} 2>&1)
            updateStatus=$(echo $?)
        else
            updateOutput=$($updateTool ${updateToolArguments} 2>&1)
            updateStatus=$(echo $?)
        fi
        sleep 1
        updateEndTime=$(date "+$updateToolLogDateFormat")
        deduplicatelogs $updateOutput
        if [[ -n $updateToolLog ]]; then
            updateOutput+=$(echo "Output of Installer log of $updateToolLog below this line.\n")
            updateOutput+=$(echo "----------------------------------------------------------\n")
            updateOutput+=$(awk -v "b=$updatestarttime" -v "e=$updateEndTime" -F ',' '$1 >= b && $1 <= e' $updateToolLog)
        fi

        if [[ $updateStatus -ne 0 ]]; then
            printlog "Error running $updateTool, Procceding with normal installation. Exit Status: $updateStatus Error:\n$logoutput" WARN
            return 1
            if [[ $type == updateronly ]]; then
                cleanupAndExit 77 "No Download URL Set, this is an update only application and the updater failed" ERROR
            fi
        elif [[ $updateStatus -eq 0 ]]; then
            printlog "Debugging enabled, update tool output was:\n$logoutput" DEBUG
        fi
    else
        printlog "couldn't find $updateTool, continuing normally" WARN
        return 1
    fi
    return 0
}

finishing() {
    printlog "Finishing..."

    sleep 3 # wait a moment to let spotlight catch up
    getAppVersion

    if [[ -z $appNewVersion ]]; then
        message="Installed $name"
    else
        message="Installed $name, version $appNewVersion"
    fi

    printlog "$message" REQ

    if [[ $currentUser != "loginwindow" && ( $NOTIFY == "success" || $NOTIFY == "all" ) ]]; then
        printlog "notifying"
        if [[ $updateDetected == "YES" ]]; then
            displaynotification "$message" "$name update complete!"
        else
            displaynotification "$message" "$name installation complete!"
        fi
    fi
}

# Detect if there is an app actively making a display sleep assertion, e.g.
# KeyNote, PowerPoint, Zoom, or Webex.
# See: https://developer.apple.com/documentation/iokit/iopmlib_h/iopmassertiontypes
hasDisplaySleepAssertion() {
    # Get the names of all apps with active display sleep assertions
    local apps="$(/usr/bin/pmset -g assertions | /usr/bin/awk '/NoDisplaySleepAssertion | PreventUserIdleDisplaySleep/ && match($0,/\(.+\)/) && ! /coreaudiod/ {gsub(/^.*\(/,"",$0); gsub(/\).*$/,"",$0); print};')"

    if [[ ! "${apps}" ]]; then
        # No display sleep assertions detected
        return 1
    fi

    # Create an array of apps that need to be ignored
    local ignore_array=("${(@s/,/)IGNORE_DND_APPS}")

    for app in ${(f)apps}; do
        if (( ! ${ignore_array[(Ie)${app}]} )); then
            # Relevant app with display sleep assertion detected
            printlog "Display sleep assertion detected by ${app}."
            return 0
        fi
    done

    # No relevant display sleep assertion detected
    return 1
}


initNamedPipe() {
    # create or delete a named pipe
    # commands are "create" or "delete"

    local cmd=$1
    local pipe=$2
    case $cmd in
        "create")
            if [[ -e $pipe ]]; then
                rm $pipe
            fi
            # make named pipe
            mkfifo -m 644 $pipe
            ;;
        "delete")
            # clean up
            rm $pipe
            ;;
        *)
            ;;
    esac
}

readDownloadPipe() {
    # reads from a previously created named pipe
    # output from curl with --progress-bar. % downloaded is read in and then sent to the specified log file
    local pipe=$1
    local log=${2:-$DIALOG_CMD_FILE}
    # set up read from pipe
    while IFS= read -k 1 -u 0 char; do
        if [[ $char =~ [0-9] ]]; then
            keep=1
        fi

        if [[ $char == % ]]; then
            updateDialog $progress "Downloading..."
            progress=""
            keep=0
        fi

        if [[ $keep == 1 ]]; then
            progress="$progress$char"
        fi
    done < $pipe
}

readPKGInstallPipe() {
    # reads from a previously created named pipe
    # output from installer with -verboseR. % install status is read in and then sent to the specified log file
    local pipe=$1
    local log=${2:-$DIALOG_CMD_FILE}
    local appname=${3:-$name}

    while read -k 1 -u 0 char; do
        if [[ $char == % ]]; then
            keep=1
        fi
        if [[ $char =~ [0-9] && $keep == 1 ]]; then
            progress="$progress$char"
        fi
        if [[ $char == . && $keep == 1 ]]; then
            updateDialog $progress "Installing..."
            progress=""
            keep=0
        fi
    done < $pipe
}

killProcess() {
    # will silently kill the specified PID
    builtin kill $1 2>/dev/null
}

updateDialog() {
    local state=$1
    local message=$2
    local listitem=${3:-$DIALOG_LIST_ITEM_NAME}
    local cmd_file=${4:-$DIALOG_CMD_FILE}
    local progress=""

    if [[ $state =~ '^[0-9]' \
       || $state == "reset" \
       || $state == "increment" \
       || $state == "complete" \
       || $state == "indeterminate" ]]; then
        progress=$state
    fi

    # when to cmdfile is set, do nothing
    if [[ $cmd_file == "" ]]; then
        return
    fi

    if [[ $listitem == "" ]]; then
        # no listitem set, update main progress bar and progress text
        if [[ $progress != "" ]]; then
            echo "progress: $progress" >> $cmd_file
        fi
        if [[ $message != "" ]]; then
            echo "progresstext: $message" >> $cmd_file
        fi
    else
        # list item has a value, so we update the progress and text in the list
        if [[ $progress != "" ]]; then
            echo "listitem: title: $listitem, statustext: $message, progress: $progress" >> $cmd_file
        else
            echo "listitem: title: $listitem, statustext: $message, status: $state" >> $cmd_file
        fi
    fi
}

# NOTE: check minimal macOS requirement
autoload is-at-least

installedOSversion=$(sw_vers -productVersion)
if ! is-at-least 10.14 $installedOSversion; then
    printlog "Installomator requires at least macOS 10.14 Mojave." ERROR
    exit 98
fi


# MARK: argument parsing
if [[ $# -eq 0 ]]; then
    if [[ -z $label ]]; then # check if label is set inside script
        printlog "no label provided, printing labels" REQ
        grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "$0" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        #grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "${labelFile}" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        exit 0
    fi
elif [[ $1 == "/" ]]; then
    # jamf uses sends '/' as the first argument
    printlog "shifting arguments for Jamf" REQ
    shift 3
fi

# first argument is the label
label=$1

# MARK: reading rest of the arguments
argumentsArray=()
while [[ -n $1 ]]; do
    if [[ $1 =~ ".*\=.*" ]]; then
        # if an argument contains an = character, send it to eval
        printlog "setting variable from argument $1" INFO
        argumentsArray+=( $1 )
        eval $1
    fi
    # shift to next argument
    shift 1
done
printlog "Total items in argumentsArray: ${#argumentsArray[@]}" INFO
printlog "argumentsArray: ${argumentsArray[*]}" INFO

# lowercase the label
label=${label:l}

# separate check for 'version' in order to print plain version number without any other information
if [[ $label == "version" ]]; then
    echo "$VERSION"
    exit 0
fi

# NOTE: Use proxy for network access if defined
if [[ -n $PROXY ]]; then
    printlog "Proxy defined: $PROXY, testing access to it" REQ
    proxyAddress=$(echo $PROXY | cut -d ":" -f1)
    portNumber=$(echo $PROXY | cut -d ":" -f2)
    printlog "Proxy: $proxyAddress, Port: $portNumber"
    if cmdOutput=$(! nc -z -v -G 10 ${proxyAddress} ${portNumber} 2>&1) ; then
        printlog "$cmdOutput" REQ
        printlog "ERROR : No proxy connection, skipping this." REQ
    else
        printlog "Proxy access detected, so using that." REQ
        export ALL_PROXY="$PROXY"
    fi
fi

# MARK: Logging
log_location="/private/var/log/Installomator.log"

# Check if we're in debug mode, if so then set logging to DEBUG, otherwise default to INFO
# if no log level is specified.
if [[ $DEBUG -ne 0 ]]; then
    LOGGING=DEBUG
elif [[ -z $LOGGING ]]; then
    LOGGING=INFO
    datadogLoggingLevel=INFO
fi

# Associate logging levels with a numerical value so that we are able to identify what
# should be removed. For example if the LOGGING=ERROR only printlog statements with the
# level REQ and ERROR will be displayed. LOGGING=DEBUG will show all printlog statements.
# If a printlog statement has no level set it's automatically assigned INFO.

declare -A levels=(DEBUG 0 INFO 1 WARN 2 ERROR 3 REQ 4)

# If we are able to detect an MDM URL (Jamf Pro) or another identifier for a customer/instance we grab it here, this is useful if we're centrally logging multiple MDM instances.
if [[ -f /Library/Preferences/com.jamfsoftware.jamf.plist ]]; then
    mdmURL=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url)
elif [[ -n "$MDMProfileName" ]]; then
    mdmURL=$(sudo profiles show | grep -A3 "$MDMProfileName" | sed -n -e 's/^.*organization: //p')
else
    mdmURL="Unknown"
fi

# Generate a session key for this run, this is useful to idenify streams when we're centrally logging.
SESSION=$RANDOM

# MARK: START
printlog "################## Start Installomator v. $VERSION, date $VERSIONDATE" REQ
printlog "################## Version: $VERSION" INFO
printlog "################## Date: $VERSIONDATE" INFO
printlog "################## $label" INFO

# Check for DEBUG mode
if [[ $DEBUG -gt 0 ]]; then
    printlog "DEBUG mode $DEBUG enabled." DEBUG
fi

# How we get version number from app
if [[ -z $versionKey ]]; then
    versionKey="CFBundleShortVersionString"
fi

# get current user
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')

# NOTE: check for root
if [[ "$(whoami)" != "root" && "$DEBUG" -eq 0 ]]; then
    # not running as root
    cleanupAndExit 6 "not running as root, exiting" ERROR
fi

# check Swift Dialog presence and version
DIALOG_CMD="/usr/local/bin/dialog"

if [[ ! -x $DIALOG_CMD ]]; then
    # Swift Dialog is not installed, clear cmd file variable to ignore
    printlog "SwiftDialog is not installed, clear cmd file var"
    DIALOG_CMD_FILE=""
fi

# MARK: labels in case statement
case $label in
longversion)
    # print the script version
    printlog "Installomater: version $VERSION ($VERSIONDATE)" REQ
    exit 0
    ;;
valuesfromarguments)
    # no action necessary, all values should be provided in arguments
    ;;

# label descriptions start here
1password7)
    name="1Password 7"
    type="pkg"
    downloadURL="https://app-updates.agilebits.com/download/OPM7"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[0-9a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password (Safari)" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    #forcefulQuit=YES
    ;;
1password8)
    name="1Password"
    type="pkg"
    packageID="com.1password.1password"
    downloadURL="https://downloads.1password.com/mac/1Password.pkg"
    appNewVersion=$(curl -s https://releases.1password.com/mac/ | grep "1Password for Mac" | head -n 1 | grep -o ">Updated to.*on<" | grep -oE "[0-9].*[0-9]" | cut -d - -f 1)
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password 8" "1Password" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    #forcefulQuit=YES
    ;;
1passwordcli)
    name="1Password CLI"
    type="pkg"
    #packageID="com.1password.op"
    downloadURL=$(curl -fs https://app-updates.agilebits.com/product_history/CLI2 | grep -m 1 -i op_apple_universal | cut -d'"' -f 2)
    appNewVersion=$(echo $downloadURL | sed -E 's/.*\/[a-zA-Z_]*([0-9.]*)\..*/\1/g')
    appCustomVersion(){ /usr/local/bin/op -v }
    expectedTeamID="2BUA8C4S2C"
    ;;
4kvideodownloader)
    name="4K Video Downloader"
    type="dmg"
    downloadURL="$(curl -fsL "https://www.4kdownload.com/products/product-videodownloader" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloader_.*?.dmg\?source=website" | head -1)"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[0-9a-zA-Z]*_([0-9.]*)\.dmg.*/\1/g')
	versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
4kvideodownloaderplus)
    name="4K Video Downloader+"
    type="dmg"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then 
        downloadURL="$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" -fsL "https://www.4kdownload.com/downloads/34" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloaderplus.*arm64.*?.dmg\?source=website" | head -1)"
    else
        downloadURL="$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" -fsL "https://www.4kdownload.com/downloads/34" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloaderplus.*x64.*?.dmg\?source=website" | head -1)"
    fi
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[0-9a-zA-Z]*_([0-9.]*)_arm64\.dmg.*/\1/g')
	versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
8x8)
    # credit: #D-A-James from MacAdmins Slack and Isaac Ordonez, Mann consulting (@mannconsulting)
    name="8x8 Work"
    type="dmg"
    downloadURL=$(curl -fs -L https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}')
    # As for appNewVersion, it needs to be checked for newer version than 7.2.4
    appNewVersion=$(curl -fs -L https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}' | sed -E 's/.*-v([0-9\.]*)[-\.]*.*/\1/' )
    expectedTeamID="FC967L3QRG"
    ;;
ape)
    name="ApE"
    type="dmg"
    downloadURL="https://jorgensen.biology.utah.edu/wayned/ape/Download/Mac/ApE_OSX_modern_current.dmg"
    appNewVersion="$(curl -fsL "https://jorgensen.biology.utah.edu/wayned/ape/" | grep -Eo 'ApE \(v[0-9]+\.[0-9]+\.[0-9]+' | sed -E 's/ApE \(v//')"
    expectedTeamID="F5459JB4SG"
    appName="ApE.app"
    blockingProcesses=( "ApE" )
    ;;
dcp-o-matic|dcpomatic|dcp-o-matic2|dcpomatic2)
    name="DCP-o-matic 2"
    type="dmg"
    appNewVersion=$(curl -fs https://dcpomatic.com/download | grep "Stable release: " | awk -F '</p>' '{print $1}' | grep -o -e "[0-9.]*")
    downloadURL="https://dcpomatic.com/dl.php?id=osx-10.10-main&version=$appNewVersion&paid=0"
	versionKey="CFBundleVersion"
    expectedTeamID="R82DXSR997"
    ;;
hudlsportscode)
    name="Hudl Sportscode"
    type="appInDmgInZip"
    appNewVersion=$(curl -fs https://www.hudl.com/downloads/elite | grep -A 1 "Download Hudl Sportscode" | grep -o -e "[0-9.]*")
    downloadURL="https://sportscode64-updates.s3.amazonaws.com/PublicReleaseDmgs/HudlSportscode-$appNewVersion.dmg.zip"
	versionKey="CFBundleVersion"
    expectedTeamID="4M6T2C723P"
    ;;
hudlstudio)
    name="Studio"
    type="dmg"
    appNewVersion=$(curl -fs https://www.hudl.com/downloads/elite | grep -A 1 "Download Studio" | grep -o -e "[0-9.]*")
    downloadURL="https://studio-releases.s3.amazonaws.com/Studio-$appNewVersion.dmg"
	versionKey="CFBundleVersion"
    expectedTeamID="2YLQ7PASUE"
    ;;
synergybaseball)
    name="Synergy Baseball"
    type="dmg"
    downloadURL="$( echo https://www.synergysportstech.com/baseballclient/MacOS/$(curl -s https://www.synergysportstech.com/baseballclient/MacOS/default.htm | grep dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}') )"
    appNewVersion=$(curl -fs https://www.synergysportstech.com/baseballclient/MacOS/default.htm | grep Version: | grep -o -e "[0-9.]*")
	versionKey="CFBundleVersion"
    expectedTeamID="BATB6XS52B"
    ;;

synergybasketball)
    name="Synergy Basketball"
    type="dmg"
    downloadURL="$( echo https://www.synergysportstech.com/Apps/Basketball/production/macOS/$(curl -s https://www.synergysportstech.com/Apps/Basketball/production/macOS/default.htm | grep dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}') )"
    appNewVersion=$(curl -fs https://www.synergysportstech.com/Apps/Basketball/production/macOS/default.htm | grep Version: | grep -o -e "[0-9.]*")
	versionKey="CFBundleVersion"
    expectedTeamID="BATB6XS52B"
    ;;
synergyeditor|synergyeditorbasketball)
    name="Synergy Editor"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$( echo https://www.synergysportstech.com/apps/editor/basketball/macos/$(curl -s https://www.synergysportstech.com/apps/editor/basketball/macos/ | grep arm64.dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}' ))
    else
        downloadURL=$( echo https://www.synergysportstech.com/apps/editor/basketball/macos/$(curl -s https://www.synergysportstech.com/apps/editor/basketball/macos/ | grep x64.dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}' ))
    fi
    appNewVersion=$(curl -fs https://www.synergysportstech.com/apps/editor/basketball/macos/default.html | grep Version: | grep -o -e "[0-9.]*")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="BATB6XS52B"
    ;;
synergyvideoexpress)
    name="Synergy Video Express"
    type="dmg"
    relativeDownloadURL="$(curl -fsL https://www.synergysportstech.com/apps/videoexpress/production/macOS/default.htm | grep -Eo 'Synergy_Video_Express_[^"]+\.dmg' | head -1)"
    downloadURL="https://www.synergysportstech.com/apps/videoexpress/production/macOS/${relativeDownloadURL}"
    appNewVersion=$(echo "$relativeDownloadURL" | sed -E 's/.*_([0-9]+_[0-9]+_[0-9]+_[0-9]+)\.dmg/\1/' | tr '_' '.')
    expectedTeamID="BATB6XS52B"
    appName="Synergy Video Express.app"
    blockingProcesses=( "Synergy Video Express" )
    ;;
abetterfinderrename11)
    name="A Better Finder Rename 11"
    type="dmg"
    downloadURL="https://www.publicspace.net/download/ABFRX11.dmg"
    appNewVersion=$(curl -fs "https://www.publicspace.net/app/signed_abfr11.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="7Y9KW4ND8W"
    ;;
abletonlive12intro)
    name="Ableton Live 12 Intro"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.ableton.com/en/release-notes/live-12/" | grep -A 1 "class=\"release-notes\" id=\"live-" | sed 's/.*-\([0-9\.][0-9\.]*\).*/\1/' | grep -o "[0-9.].[0-9.].[0-9.].[0-9.]*" | head -1 | xargs)
    appCustomVersion(){ defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion | cut -d" " -f1 | xargs }
    downloadURL="https://cdn-downloads.ableton.com/channels/${appNewVersion}/ableton_live_intro_${appNewVersion}_universal.dmg"
    blockingProcesses=("Live")
    expectedTeamID="MWR434WD94"
    ;;
abletonlive12lite)
    name="Ableton Live 12 Lite"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.ableton.com/en/release-notes/live-12/" | grep -A 1 "class=\"release-notes\" id=\"live-" | sed 's/.*-\([0-9\.][0-9\.]*\).*/\1/' | grep -o "[0-9.].[0-9.].[0-9.].[0-9.]*" | head -1 | xargs)
    appCustomVersion(){ defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion | cut -d" " -f1 | xargs }
    downloadURL="https://cdn-downloads.ableton.com/channels/${appNewVersion}/ableton_live_lite_${appNewVersion}_universal.dmg"
    blockingProcesses=("Live")
    expectedTeamID="MWR434WD94"
    ;;
abletonlive12standard)
    name="Ableton Live 12 Standard"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.ableton.com/en/release-notes/live-12/" | grep -A 1 "class=\"release-notes\" id=\"live-" | sed 's/.*-\([0-9\.][0-9\.]*\).*/\1/' | grep -o "[0-9.].[0-9.].[0-9.].[0-9.]*" | head -1 | xargs)
    appCustomVersion(){ defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion | cut -d" " -f1 | xargs }
    downloadURL="https://cdn-downloads.ableton.com/channels/${appNewVersion}/ableton_live_standard_${appNewVersion}_universal.dmg"
    blockingProcesses=("Live")
    expectedTeamID="MWR434WD94"
    ;;
abletonlive12suite)
    name="Ableton Live 12 Suite"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.ableton.com/en/release-notes/live-12/" | grep -A 1 "class=\"release-notes\" id=\"live-" | sed 's/.*-\([0-9\.][0-9\.]*\).*/\1/' | grep -o "[0-9.].[0-9.].[0-9.].[0-9.]*" | head -1 | xargs)
    appCustomVersion(){ defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion | cut -d" " -f1 | xargs }
    downloadURL="https://cdn-downloads.ableton.com/channels/${appNewVersion}/ableton_live_suite_${appNewVersion}_universal.dmg"
    blockingProcesses=("Live")
    expectedTeamID="MWR434WD94"
    ;;
abletonlive12trial)
    name="Ableton Live 12 Trial"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.ableton.com/en/release-notes/live-12/" | grep -A 1 "class=\"release-notes\" id=\"live-" | sed 's/.*-\([0-9\.][0-9\.]*\).*/\1/' | grep -o "[0-9.].[0-9.].[0-9.].[0-9.]*" | head -1 | xargs)
    appCustomVersion(){ defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion | cut -d" " -f1 | xargs }
    downloadURL="https://cdn-downloads.ableton.com/channels/${appNewVersion}/ableton_live_trial_${appNewVersion}_universal.dmg"
    blockingProcesses=("Live")
    expectedTeamID="MWR434WD94"
    ;;
abstract)
    name="Abstract"
    type="zip"
    downloadURL="https://api.goabstract.com/releases/latest/download"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="77MZLZE47D"
    ;;
acorn)
    name="Acorn"
    type="zip"
    downloadURL="https://flyingmeat.com/download/Acorn.zip"
    appNewVersion="$(curl -sL https://flyingmeat.com/acorn/releasenotes.html | grep -i 'class="releaseTitleT"' | head -n1 | sed -n 's:.*<div\(.*\)>\(.*\)</div>.*:\2:p' | awk '{print $NF}')"
    expectedTeamID="WZCN9HJ4VP"
    ;;
acroniscyberprotectconnect|\
remotix)
    name="Acronis Cyber Protect Connect"
    type="dmg"
    downloadURL="https://go.acronis.com/AcronisCyberProtectConnect_ForMac"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-[0-9.]*-([0-9.]*)\.dmg/\1/g')
    expectedTeamID="ZU2TV78AA6"
    ;;
acroniscyberprotectconnectagent|\
remotixagent)
    name="Acronis Cyber Protect Connect Agent"
    type="pkg"
    #packageID="com.nulana.rxagentmac"
    downloadURL="https://go.acronis.com/AcronisCyberProtectConnect_AgentForMac"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-[0-9.]*-([0-9.]*)\.pkg/\1/g')
    expectedTeamID="ZU2TV78AA6"
    blockingProcesses=( NONE )
    ;;
adium)
    name="Adium"
    type="dmg"
    appNewVersion="$(curl -sL "https://adium.im" | grep -i 'class="downloadlink"' | sed -r 's/.*href="([^"]+).*/\1/g' | sed -n 's:.*Adium_\(.*\).dmg.*:\1:p')"
    downloadURL="https://adiumx.cachefly.net/Adium_${appNewVersion}.dmg"
    expectedTeamID="VQ6ZEL8UD3"
    ;;
adobeacrobatprodc)
    name="Adobe Acrobat Pro DC"
    appName="Acrobat Distiller.app"
    type="pkgInDmg"
    pkgName="Acrobat/Acrobat DC Installer.pkg"
    packageID="com.adobe.acrobat.DC.viewer.app.pkg.MUI"
    downloadURL="https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/osx10/Acrobat_DC_Web_WWMUI.dmg"
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Acrobat Pro DC" )
    Company="Adobe"
    ;;
adobeconnect)
    # credit: Oh4sh0 https://github.com/Oh4sh0
    # Comment by Søren: I do not know this software.
    # Looks like it's an Adobe installer in an app, so it will probably not work
    name="AdobeConnectInstaller"
    type="dmg"
    downloadURL="http://www.adobe.com/go/ConnectSetupMac"
    appNewVersion=$(curl -fs https://helpx.adobe.com/adobe-connect/connect-downloads-updates.html | grep "Mac" | grep version | head -1 | sed -E 's/.*\(version ([0-9\.]*),.*/\1/g')
    expectedTeamID="JQ525L2MZD"
    ;;
adobecreativeclouddesktop)
    name="Adobe Creative Cloud"
    appName="Creative Cloud.app"
    type="dmg"
    if pgrep -q "Adobe Installer"; then
        printlog "Adobe Installer is running, not a good time to update." WARN
        printlog "################## End $APPLICATION \n\n" INFO
        exit 75
    fi
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fs "https://helpx.adobe.com/download-install/kb/creative-cloud-desktop-app-download.html" | grep -o 'https.*macarm64.*dmg' | head -1 | cut -d '"' -f1)
    else
        downloadURL=$(curl -fs "https://helpx.adobe.com/download-install/kb/creative-cloud-desktop-app-download.html" | grep -o 'https.*osx10.*dmg' | head -1 | cut -d '"' -f1)
    fi
    #appNewVersion=$(curl -fs "https://helpx.adobe.com/creative-cloud/release-note/cc-release-notes.html" | grep "mandatory" | head -1 | grep -o "Version *.* released" | cut -d " " -f2)
    appNewVersion=$(echo $downloadURL | grep -o '[^x]*$' | cut -d '.' -f 1 | sed 's/_/\./g')
    targetDir="/Applications/Utilities/Adobe Creative Cloud/ACC/"
    installerTool="Install.app"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(--mode=silent)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Creative Cloud" )
    Company="Adobe"
    ;;
adobedigitaleditions)
    name="Adobe Digital Editions"
    type="pkgInDmg"
    downloadURL=$(curl -fs https://www.adobe.com/solutions/ebook/digital-editions/download.html | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p')
    appNewVersion=$(curl -fs https://www.adobe.com/solutions/ebook/digital-editions/download.html | grep -o 'Adobe Digital Editions.*Installers' | awk -F' ' '{ print $4 }')
    expectedTeamID="JQ525L2MZD"
    ;;
adobereaderdc|\
adobereaderdc-install|\
adobereaderdc-update)
    name="Adobe Acrobat Reader"
    type="pkgInDmg"
    if [[ -d "/Applications/Adobe Acrobat Reader DC.app" ]]; then
      printlog "Found /Applications/Adobe Acrobat Reader DC.app - Setting readerPath" INFO
      readerPath="/Applications/Adobe Acrobat Reader DC.app"
      name="Adobe Acrobat Reader DC"
    elif [[ -d "/Applications/Adobe Acrobat Reader.app" ]]; then
      printlog "Found /Applications/Adobe Acrobat Reader.app - Setting readerPath" INFO
      readerPath="/Applications/Adobe Acrobat Reader.app"
    fi
    if ! [[ `defaults read "$readerPath/Contents/Resources/AcroLocale.plist"` ]]; then
      printlog "Missing locale data, this will cause the updater to fail.  Deleting Adobe Acrobat Reader DC.app and installing fresh." INFO
      rm -Rf "$readerPath"
      unset $readerPath
    fi
    if [[ -n $readerPath ]]; then
      mkdir -p "/Library/Application Support/Adobe/Acrobat/11.0"
      defaults write "/Library/Application Support/Adobe/Acrobat/11.0/com.adobe.Acrobat.InstallerOverrides.plist" ReaderAppPath "$readerPath"
      defaults write "/Library/Application Support/Adobe/Acrobat/11.0/com.adobe.Acrobat.InstallerOverrides.plist" BreakIfAppPathInvalid -bool false
      printlog "Adobe Reader Installed, running updater." INFO
      adobecurrent=$(curl -sL https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt)
      adobecurrentmod="${adobecurrent//.}"
      if [[ "${adobecurrentmod}" != <-> ]]; then
        printlog "Got an invalid response for the Adobe Reader Current Version: ${adobecurrent}" ERROR
        printlog "################## End $APPLICATION \n\n" INFO
        exit 50
      fi
      if pgrep -q "Acrobat Updater"; then
        printlog "Adobe Acrobat Updater Running, killing it to avoid any conflicts" INFO
        killall "Acrobat Updater"
      fi
      downloadURL=$(echo https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/"$adobecurrentmod"/AcroRdrDCUpd"$adobecurrentmod"_MUI.dmg)
      appNewVersion="${adobecurrent}"
    else
      printlog "Changing IFS for Adobe Reader" INFO
      SAVEIFS=$IFS
      IFS=$'\n'
      versions=( $( curl -s https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+"| head -n 30) )
      local version
      for version in $versions; do
        version="${version//.}"
        printlog "trying version: $version" INFO
        local httpstatus=$(curl -X HEAD -s "https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${version}/AcroRdrDC_${version}_MUI.dmg" --write-out "%{http_code}")
        printlog "HTTP status for Adobe Reader full installer URL https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${version}/AcroRdrDC_${version}_MUI.dmg is $httpstatus" DEBUG
        if [[ "${httpstatus}" == "200" ]]; then
          downloadURL="https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${version}/AcroRdrDC_${version}_MUI.dmg"
          unset httpstatus
          break
        fi
      done
      unset version
      IFS=$SAVEIFS
    fi
    updateTool="/usr/local/bin/RemoteUpdateManager"
    updateToolArguments=( --productVersions=RDR )
    updateToolLog="/Users/$currentUser/Library/Logs/RemoteUpdateManager.log"
    updateToolLogDateFormat="%m/%d/%y %H:%M:%S"
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Acrobat Pro DC" "AdobeAcrobat" "AdobeReader" "Distiller" )
    Company="Adobe"
    ;;
affinitydesigner2)
    name="Affinity Designer 2"
    type="dmg"
    downloadURL=$(curl -fs "https://store.serif.com/en-gb/update/macos/designer/2/" | grep -i -o -E "https.*\.dmg.*\"" | sort | tail -n1 | sed 's/.$//' | sed 's/&amp;/\&/g')
    appNewVersion=$(curl -fs "https://store.serif.com/en-gb/update/macos/designer/2/" | grep -i -o -E "https.*\.dmg" | sort | tail -n1 | tr "-" "\n" | grep dmg | sed -E 's/([0-9.]*)\.dmg/\1/g')
    expectedTeamID="6LVTQB9699"
    ;;
affinityphoto2)
    name="Affinity Photo 2"
    type="dmg"
    downloadURL=$(curl -fs "https://store.serif.com/en-gb/update/macos/photo/2/" | grep -i -o -E "https.*\.dmg.*\"" | sort | tail -n1 | sed 's/.$//' | sed 's/&amp;/\&/g')
    appNewVersion=$(curl -fs "https://store.serif.com/en-gb/update/macos/photo/2/" | grep -i -o -E "https.*\.dmg" | sort | tail -n1 | tr "-" "\n" | grep dmg | sed -E 's/([0-9.]*)\.dmg/\1/g')
    expectedTeamID="6LVTQB9699"
    ;;
affinitypublisher2)
    name="Affinity Publisher 2"
    type="dmg"
    downloadURL=$(curl -fs "https://store.serif.com/en-gb/update/macos/publisher/2/" | grep -i -o -E "https.*\.dmg.*\"" | sort | tail -n1 | sed 's/.$//' | sed 's/&amp;/\&/g')
    appNewVersion=$(curl -fs "https://store.serif.com/en-gb/update/macos/publisher/2/" | grep -i -o -E "https.*\.dmg" | sort | tail -n1 | tr "-" "\n" | grep dmg | sed -E 's/([0-9.]*)\.dmg/\1/g')
    expectedTeamID="6LVTQB9699"
    ;;
aftermath)
    name="Aftermath"
    type="pkg"
    packageID="com.jamf.aftermath"
    downloadURL="$(downloadURLFromGit jamf aftermath)"
    appNewVersion="$(versionFromGit jamf aftermath)"
    expectedTeamID="C793NB2B2B"
    ;;
aircall)
    name="Aircall"
    type="zip"
    aircallUpdate=$(curl -fsL "https://electron.aircall.io/update/osx/1.0.0?channel=stable")
    downloadURL=$(echo "${aircallUpdate}" | sed -n 's/.*"url":"\([^"]*\)".*/\1/p')
    appNewVersion=$(echo "${aircallUpdate}" | sed -n 's/.*"name":"\([^"]*\)".*/\1/p')
    expectedTeamID="3ML357Q795"
    ;;
airflow)
    name="Air"
    type="dmg"
    downloadURL="$(downloadURLFromGit AirLabsTeam desktop-releases)"
    appNewVersion="$(versionFromGit AirLabsTeam desktop-releases)"
    expectedTeamID="8RBYE8TY7T"
    ;;
airserver)
    # credit: AP Orlebeke (@apizz)
    name="AirServer"
    type="dmg"
    downloadURL="https://www.airserver.com/download/mac/latest"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "location" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="6C755KS5W3"
    ;;
airtable)
    name="Airtable"
    type="dmg"
    downloadURL="https://static.airtable.com/download/AirtableInstaller.dmg"
    expectedTeamID="E22RZMX62E"
    ;;
airtame)
    name="Airtame"
    type="dmg"
    downloadURL="$(curl -fs https://airtame.com/download/ | grep -i platform=mac | head -1 | grep -o -i -E "https.*" | cut -d '"' -f1)"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^location | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')"
    expectedTeamID="4TPSP88HN2"
    ;;
airtamepkg)
    name="Airtame"
    type="pkg"
    packageID="com.airtame.airtame-application"
    appNewVersion="$(curl -fs https://airtame.com/download/ | grep -i platform=mac | head -1 | grep -o -i -E "https.*" | cut -d '"' -f1 | xargs curl -fsIL | grep -i ^location | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')"
    downloadURL="https://airtame-app.b-cdn.net/app/latest/mac/Airtame-${appNewVersion}.pkg"
    expectedTeamID="4TPSP88HN2"
    ;;
aldente)
    name="AlDente"
    type="dmg"
    downloadURL=$(downloadURLFromGit davidwernhart AlDente)
    appNewVersion=$(versionFromGit davidwernhart AlDente)
    expectedTeamID="3WVC84GB99"
    ;;
alephone)
    name="Aleph One"
    type="dmg"
    downloadURL=$(downloadURLFromGit Aleph-One-Marathon alephone)
    appNewVersion=$(versionFromGit Aleph-One-Marathon alephone)
    expectedTeamID="E8K89CXZE7"
    ;;
alfred)
    # credit: AP Orlebeke (@apizz)
    name="Alfred"
    type="dmg"
    downloadURL=$(curl -fs https://www.alfredapp.com | awk -F '"' "/dmg/ {print \$2}" | head -1)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*Alfred_([0-9.]*)_.*/\1/')
    appName="Alfred 5.app"
    expectedTeamID="XZZXE9SED4"
    ;;
altserver)
    name="AltServer"
    type="zip"
    downloadURL="https://cdn.altstore.io/file/altstore/altserver.zip"
    appNewVersion=""
    expectedTeamID="6XVY5G3U44"
    ;;
alttab)
    name="AltTab"
    type="zip"
    downloadURL=$(downloadURLFromGit lwouis alt-tab-macos)
    appNewVersion=$(versionFromGit lwouis alt-tab-macos)
    expectedTeamID="QXD7GW8FHY"
    ;;
amadeuspro2)
	# A powerful audio editing tool for macOS, offering multi-track editing, batch processing, and a variety of sound analysis feature
    name="Amadeus Pro"
    type="zip"
    downloadURL="https://s3.amazonaws.com/AmadeusPro2/AmadeusPro.zip"
    expectedTeamID="FWDH9W45C2"
    ;;
amazonchime)
    # credit: @dvsjr macadmins slack
    name="Amazon Chime"
    type="dmg"
    downloadURL="https://clients.chime.aws/mac/latest"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z.\-]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="94KV3E626L"
    ;;
amazoncorretto11jdk)
    name="Amazon Corretto 11 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-11-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-11/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
amazoncorretto17jdk)
    name="Amazon Corretto 17 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-17-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-17/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
amazoncorretto21jdk)
    name="Amazon Corretto 21 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-21-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-21/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
amazoncorretto22jdk)
    name="Amazon Corretto 22 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-22-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-22/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-22.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-22.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
amazoncorretto23jdk)
    name="Amazon Corretto 23 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-23-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-23/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-23.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-23.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
amazoncorretto8jdk)
    name="Amazon Corretto 8 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-8-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-8/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
amazonworkspaces)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Workspaces"
    type="pkg"
    downloadURL="https://d2td7dqidlhjx7.cloudfront.net/prod/global/osx/WorkSpaces.pkg"
    appNewVersion=$(curl -fs https://d2td7dqidlhjx7.cloudfront.net/prod/iad/osx/WorkSpacesAppCast_macOS_20171023.xml | grep -o "Version*.*<" | head -1 | cut -d " " -f2 | cut -d "<" -f1)
    expectedTeamID="94KV3E626L"
    ;;
anaconda)
    name="Anaconda-Navigator"
    packageID="com.anaconda.io"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName=$( curl -sf https://repo.anaconda.com/archive/ | awk '/href=".*Anaconda.*MacOSX.*arm64.*\.pkg"/{gsub(/.*href="|".*/, ""); gsub(/.*\//, ""); print; exit}' )
    else
        archiveName=$( curl -sf https://repo.anaconda.com/archive/ | awk '/href=".*Anaconda.*MacOSX.*x86_64.*\.pkg"/{gsub(/.*href="|".*/, ""); gsub(/.*\//, ""); print; exit}' )
    fi
    downloadURL="https://repo.anaconda.com/archive/$archiveName"
    appNewVersion=$( awk -F'-' '{print $2}' <<< "$archiveName" )
    expectedTeamID="Z5788K4JT7"
    blockingProcesses=( "Anaconda-Navigator.app" )
    appCustomVersion() {
        if [ -e "/Users/$currentUser/opt/anaconda3/bin/conda" ]; then
            "/Users/$currentUser/opt/anaconda3/bin/conda" list -f ^anaconda$ | awk '/anaconda /{print $2}'
        fi
    }
    updateTool="/Users/$currentUser/opt/anaconda3/bin/conda"
    updateToolArguments=( install -y anaconda=$appNewVersion )
    updateToolRunAsCurrentUser=1
    ;;
anastasiysextensionmanager)
    name="ExtensionManager"
    type="zip"
    downloadURL="https://f000.backblazeb2.com/file/anastasiy-downloads/EM/ExtensionManager.zip"
    expectedTeamID="D3SBBNFWTC"
    ;;
androidfiletransfer)
    name="Android File Transfer"
    type="dmg"
    downloadURL="https://dl.google.com/dl/androidjumper/mtp/current/AndroidFileTransfer.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
androidstudio)
    name="Android Studio"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
	 downloadURL=$(curl -fsL "https://developer.android.com/studio#downloads" | grep -i arm.dmg | head -2 | grep -o -i -E "https.*" | cut -d '"' -f1)
	 appNewVersion=$( echo "${downloadURL}" | head -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )
    elif [[ $(arch) == i386 ]]; then
     downloadURL=$(curl -fsL "https://developer.android.com/studio#downloads" | grep -i mac.dmg | head -2 | grep -o -i -E "https.*" | cut -d '"' -f1)
	 appNewVersion=$( echo "${downloadURL}" | head -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )
	fi
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( androidstudio )
    ;;
anydesk)
    name="AnyDesk"
    type="dmg"
    downloadURL="https://download.anydesk.com/anydesk.dmg"
    appNewVersion="$(curl -fs https://anydesk.com/en/downloads/mac-os | grep -i "d-block" | grep -E -o ">v[0-9.]* .*MB" | sed -E 's/.*v([0-9.]*) .*/\1/g')"
    expectedTeamID="KHRWM533LU"
    ;;
apachedirectorystudio)
    name="ApacheDirectoryStudio"
    type="dmg"
    downloadURL=$( curl -fs https://directory.apache.org/studio/download/download-macosx.html | grep -o 'http[^"]*downloads[^"]*ApacheDirectoryStudio[^"]*.dmg' | head -1 )
    appNewVersion=$( curl -fs https://directory.apache.org/studio/download/download-macosx.html  | grep -o 'studio/\([^/]*\)/ApacheDirectoryStudio' | cut -d'/' -f2 | head -1)
    versionKey="CFBundleVersion"
    expectedTeamID="2GLGAFWEQD"
    ;;
apachenetbeans)
    name="Apache NetBeans"
    type="pkg"
    appNewVersion=$( curl -fs "https://netbeans.apache.org/front/main/download/index.html" | grep -o 'Apache NetBeans [0-9]\+' | sed 's/Apache NetBeans //' | head -n 1 )
    downloadURL="https://dlcdn.apache.org/netbeans/netbeans-installers/"${appNewVersion}"/Apache-NetBeans-"${appNewVersion}".pkg"
    expectedTeamID="2GLGAFWEQD"
    ;;
apparency)
    name="Apparency"
    type="dmg"
    downloadURL="https://www.mothersruin.com/software/downloads/Apparency.dmg"
    appNewVersion=$(curl -fs https://mothersruin.com/software/Apparency/data/ApparencyVersionInfo.plist | grep -A1 CFBundleShortVersionString | tail -1 | sed -E 's/.*>([0-9.]*)<.*/\1/g')
    expectedTeamID="936EB786NH"
    ;;
appcleaner)
    name="AppCleaner"
    type="zip"
    downloadURL=$(curl -fs https://freemacsoft.net/appcleaner/Updates.xml | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    appNewVersion=$(curl -fsL "https://freemacsoft.net/appcleaner/Updates.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="X85ZX835W9"
    ;;
applenyfonts)
    name="Apple New York Font Collection"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/NY.dmg"
    packageID="com.apple.pkg.NYFonts"
    expectedTeamID="Software Update"
    ;;
applesfarabic)
    name="San Francisco Arabic"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg"
    packageID="com.apple.pkg.SFArabicFonts"
    expectedTeamID="Software Update"
    ;;
applesfcompact)
    name="San Francisco Compact"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg"
    packageID="com.apple.pkg.SanFranciscoCompact"
    expectedTeamID="Software Update"
    ;;
applesfmono)
    name="San Francisco Mono"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"
    packageID="com.apple.pkg.SFMonoFonts"
    expectedTeamID="Software Update"
    ;;
applesfpro)
    name="San Francisco Pro"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
    packageID="com.apple.pkg.SanFranciscoPro"
    expectedTeamID="Software Update"
    ;;
applesfsymbols|\
sfsymbols)
    name="SF Symbols"
    type="pkgInDmg"
    downloadURL=$( curl -fs "https://developer.apple.com/sf-symbols/" | grep -oe "https.*Symbols.*\.dmg" | head -1 )
    appNewVersion=$( echo "$downloadURL" | sed -E 's/.*SF-Symbols-([0-9.]*)\..*/\1/g')
    expectedTeamID="Software Update"
    ;;
aquamacs)
    name="Aquamacs"
    type="dmg"
    downloadURL="$(downloadURLFromGit aquamacs-emacs aquamacs-emacs)"
    appNewVersion="$(versionFromGit aquamacs-emacs aquamacs-emacs)"
    expectedTeamID="DTBC5BX3L9"
    ;;
aquaskk)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="aquaskk"
    type="pkg"
    downloadURL=$(downloadURLFromGit codefirst aquaskk)
    appNewVersion=$(versionFromGit codefirst aquaskk)
    expectedTeamID="FPZK4WRGW7"
    ;;
arcbrowser)
name="Arc"
type="dmg"
downloadURL="https://releases.arc.net/release/Arc-latest.dmg"
appNewVersion="$(curl -fsIL https://releases.arc.net/release/Arc-latest.dmg | grep -i ^location | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+-[0-9]+).*/\1/')"
expectedTeamID="S6N382Y83G"
    ;;
archimate)
    name="Archi"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
      downloadURL="https://www.archimatetool.com"
      downloadURL+=$(curl -s https://www.archimatetool.com/download/ | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | awk 'NR==2')
    elif [[ $(arch) == "i386" ]]; then
      downloadURL="https://www.archimatetool.com"
      downloadURL+=$(curl -s https://www.archimatetool.com/download/ | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | awk 'NR==1')
    fi
    appNewVersion=$(echo "${downloadURL}" | sed 's/.*\/downloads\/index.php?\/downloads\/archi\/\([^\/]*\)\/Archi-.*/\1/')
    expectedTeamID="375WT5T296"
    ;;
archiwareb2go)
    name="P5 Workstation"
    type="pkgInDmg"
    packageID="com.archiware.presstore"
    appNewVersion=$(curl -sf https://www.archiware.com/download-p5 | grep -m 1 "ARCHIWARE P5 Version" | sed "s|.*Version \(.*\) -.*|\\1|")
    downloadURL=$(appNrVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo https://p5-downloads.s3.amazonaws.com/awpst"$appNrVersion"-darwin.dmg)
    pkgName=$(appNrVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo P5-Workstation-"$appNrVersion"-Install.pkg)
    expectedTeamID="5H5EU6F965"
    # blockingProcesses=( nsd )
    ;;
archiwarepst)
    name="P5"
    type="pkgInDmg"
    packageID="com.archiware.presstore"
    appNewVersion=$(curl -sf https://www.archiware.com/download-p5 | grep -m 1 "ARCHIWARE P5 Version" | sed "s|.*Version \(.*\) -.*|\\1|")
    downloadURL=$(appNrVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo https://p5-downloads.s3.amazonaws.com/awpst"$appNrVersion"-darwin.dmg)
    pkgName=$(appNrVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo P5-"$appNrVersion"-Install.pkg)
    expectedTeamID="5H5EU6F965"
    # blockingProcesses=( nsd )
    ;;
arduinoide)
    name="Arduino IDE"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="arduino-ide_[0-9.]*_macOS_arm64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="arduino-ide_[0-9.]*_macOS_64bit.dmg"
    fi
    downloadURL="$(downloadURLFromGit arduino arduino-ide)"
    appNewVersion="$(versionFromGit arduino arduino-ide)"
    expectedTeamID="7KT7ZWMCJT"
    ;;

arq7)
    name="Arq7"
    type="pkg"
    packageID="com.haystacksoftware.Arq"
    downloadURL="https://arqbackup.com/download/arqbackup/Arq7.pkg"
    appNewVersion="$(curl -fs "https://arqbackup.com" | grep -io "version .*[0-9.]*.* for macOS" | cut -d ">" -f2 | cut -d "<" -f1)"
    expectedTeamID="48ZCSDVL96"
    ;;
arturiasoftwarecenter)
    name="Arturia Software Center"
    type="pkg"
    packageID="com.Arturia.ArturiaSoftwareCenter.resources"
    versionKey="CFBundleVersion"
    arturiaDetails="$(curl -fsL 'https://www.arturia.com/api/resources?slugs=asc&types=soft')"
    arturiaCount=0
    while [[ -z $arturiaMatch ]]
    do
        arturiaPlatform=$(getJSONValue "$arturiaDetails" "[$arturiaCount].platform_type" 2>/dev/null)
        if [ $? -eq 1 ]; then
         downloadURL=""
            appNewVersion=""
            break
        elif [[ $arturiaPlatform == "mac" ]]; then
            downloadURL=$(getJSONValue "$arturiaDetails" "[$arturiaCount].permalink")
            appNewVersion="$(getJSONValue "$arturiaDetails" "[$arturiaCount].version")"
            break
        fi
        arturiaCount=$(( $arturiaCount + 1 ))
    done
    expectedTeamID="T53ZHSF36C"
    ;;
asana)
    name="Asana"
    type="dmg"
    downloadURL="https://desktop-downloads.asana.com/darwin_universal/prod/latest/Asana.dmg"
    expectedTeamID="A679L395M8"
    ;;
asperaconnect)
    name="Aspera Connect"
    type="pkg"
    downloadURL="https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/$(curl -fs 'https://www.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~Other%20software&product=ibm/Other+software/IBM+Aspera+Connect' --data-raw 'showStatus=false' | egrep -o "ibm-aspera-connect_[0-9.]+_macOS" | head -n1)_x86_64.pkg"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*ibm-aspera-connect_([0-9]+(\.[0-9]+)*)_macOS.*\.pkg/\1/')
    expectedTeamID="PETKK2G752"
    ;;
atext)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="aText"
    type="dmg"
    downloadURL="https://trankynam.com/atext/downloads/aText.dmg"
    expectedTeamID="KHEMQ2FD9E"
    ;;
atextlegacy)
     # credit: Gabe Marchan (gabemarchan.com - @darklink87)
     name="aText"
     type="dmg"
     downloadURL="https://trankynam.com/atext/downloads/aTextLegacy.dmg"
     expectedTeamID="KHEMQ2FD9E"
     ;;
atlassiancompanion)
    name="Atlassian Companion"
    type="dmg"
    downloadURL=$(curl -fsL https://confluence.atlassian.com/display/DOC/Install+Atlassian+Companion | sed -nE 's/.*(https:.*\.dmg)\".*/\1/p')
    appNewVersion=$(getJSONValue "$(curl -fsL https://update-nucleus.atlassian.com/Atlassian-Companion/291cb34fe2296e5fb82b83a04704c9b4/darwin/x64/RELEASES.json)" "currentRelease" )
    expectedTeamID="UPXU4CQZ5P"
    ;;

audacity)
    name="Audacity"
    type="dmg"
    archiveName="audacity-macOS-[0-9.]*-universal.dmg"
    downloadURL=$(downloadURLFromGit audacity audacity)
    appNewVersion=$(versionFromGit audacity audacity)
    appCustomVersion(){ defaults read "/Applications/Audacity.app/Contents/Info.plist" CFBundleVersion | cut -d '.' -f 1-3 }
    expectedTeamID="AWEYX923UX"
    ;;
authydesktop)
    name="Authy Desktop"
    type="dmg"
    downloadURL=$(curl -s -w '%{redirect_url}' -o /dev/null "https://electron.authy.com/download?channel=stable&arch=x64&platform=darwin&version=latest&product=authy" | sed 's/\ /%20/g')
    appNewVersion="$(curl -sfL --output /dev/null -r 0-0 "${downloadURL}" --remote-header-name --remote-name -w "%{url_effective}\n" | grep -o -E '([a-zA-Z0-9\_.%-]*)\.(dmg|pkg|zip|tbz)$' | sed -E 's/.*-([0-9.]*)\.dmg/\1/g')"
    expectedTeamID="9EVH78F4V4"
    ;;
autodeskfusion360admininstall)
    name="Autodesk Fusion 360 Admin Install"
    type="pkg"
    packageID="com.autodesk.edu.fusion360"
    downloadURL="https://dl.appstreaming.autodesk.com/production/installers/Autodesk%20Fusion%20Admin%20Install.pkg"
    appNewVersion=$(curl -fs "https://dl.appstreaming.autodesk.com/production/97e6dd95735340d6ad6e222a520454db/73e72ada57b7480280f7a6f4a289729f/full.json" | sed -nE 's/.*"build-version": "([^"]+)".*/\1/p')
    expectedTeamID="XXKJ396S2Y"
    appName="Autodesk Fusion 360.app"
    blockingProcesses=( "Autodesk Fusion 360" "Fusion 360" )
    ;;
autodmg)
    # credit: Mischa van der Bent (@mischavdbent)
    name="AutoDMG"
    type="dmg"
    downloadURL=$(downloadURLFromGit MagerValp AutoDMG)
    appNewVersion=$(versionFromGit MagerValp AutoDMG)
    expectedTeamID="5KQ3D3FG5H"
    ;;
automounter)
    name="AutoMounter"
    type="dmg"
    downloadURL="https://www.pixeleyes.co.nz/automounter/AutoMounter.dmg"
    appNewVersion="$( curl -fs https://www.pixeleyes.co.nz/automounter/version )"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="UKWABN4MGL"
    ;;
autopkgr)
    name="AutoPkgr"
    type="dmg"
    downloadURL=$(downloadURLFromGit lindegroup autopkgr)
    appNewVersion=$(versionFromGit lindegroup autopkgr)
    expectedTeamID="JVY2ZR6SEF"
    ;;
avertouch)
    name="AverTouch"
    type="zip"
    appNewVersion="$(curl -s "https://www.averusa.com/education/support/avertouch" | xmllint --html --xpath 'substring-after(string(//a[@class="dl-avertouch-mac"]/@href), "AVerTouch_mac_v")' - 2> /dev/null | sed 's/\.zip$//')"
    downloadURL="https://www.averusa.com/education/downloads/AVerTouch_mac_v${appNewVersion}.zip"
    expectedTeamID="B6T3WCD59Q"
    versionKey="CFBundleVersion"
    ;;
aviatrix)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Aviatrix VPN Client"
    type="pkg"
    downloadURL="https://s3-us-west-2.amazonaws.com/aviatrix-download/AviatrixVPNClient/AVPNC_mac.pkg"
    expectedTeamID="32953Z7NBN"
    ;;
awscli2)
    # credit: Bilal Habib (@Pro4TLZZ)
    name="AWSCLI"
    type="pkg"
    packageID="com.amazon.aws.cli2"
    downloadURL="https://awscli.amazonaws.com/AWSCLIV2.pkg"
    appNewVersion=$( curl -fs "https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst" | grep -i "CHANGELOG" -a4 | grep "[0-9.]" )
    expectedTeamID="94KV3E626L"
    ;;
awsvpnclient)
    name="AWS VPN Client"
    type="pkg"
    baseURL="https://d20adtppz83p9s.cloudfront.net/OSX"
    appNewVersion=$(curl -s "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-guide.rss" | grep -o 'AWS provided client ([0-9]*\.[0-9]*\.[0-9]*) for macOS' | head -1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
    downloadURL="${baseURL}/${appNewVersion}/AWS_VPN_Client.pkg"
    expectedTeamID="94KV3E626L"
    ;;
axurerp10)
    name="Axure RP 10"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -s https://www.axure.com/release-history/rp10 | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | sed 's/ *$//' | grep arm64)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -s https://www.axure.com/release-history/rp10 | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | sed 's/ *$//' | grep -v arm64)
    fi
    appNewVersion=$( curl -sL https://www.axure.com/release-history/rp10 | grep -Eo '[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}' -m 1 )
    expectedTeamID="HUMW6UU796"
    versionKey="CFBundleVersion"
    ;;
backgroundmusic)
    name="BackgroundMusic"
    type="pkg"
    packageID="com.bearisdriving.BGM"
    downloadURL="$(downloadURLFromGit kyleneideck BackgroundMusic)"
    appNewVersion="$(versionFromGit kyleneideck BackgroundMusic)"
    expectedTeamID="PR7PXC66S5"
    ;;
backgrounds)
    name="Backgrounds"
    type="zip"
    downloadURL="$(downloadURLFromGit SAP backgrounds)"
    appNewVersion="$(versionFromGit SAP backgrounds)"
    expectedTeamID="7R5ZEU67FQ"
    ;;

balenaetcher)
    name="balenaEtcher"
    type="dmg"
    downloadURL=$(downloadURLFromGit balena-io etcher )
    appNewVersion=$(versionFromGit balena-io etcher )
    expectedTeamID="66H43P8FRG"
    ;;
balsamiqwireframes)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Balsamiq Wireframes"
    type="dmg"
    downloadURL=https://builds.balsamiq.com/bwd/$(curl -fs "https://builds.balsamiq.com" | awk -F "<Key>bwd/" "/dmg/ {print \$3}" | awk -F "</Key>" "{print \$1}" | sed "s/ /%20/g")
    expectedTeamID="3DPKD72KQ7"
    ;;
bambustudio)
    name="BambuStudio"
    type="dmg"
    downloadURL=$(downloadURLFromGit "bambulab" "BambuStudio")
    appNewVersion=$(versionFromGit "bambulab" "BambuStudio")
    expectedTeamID="T3UBR9Y3B2"
    ;;
bartender)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Bartender 4"
    type="dmg"
    downloadURL="https://www.macbartender.com/B2/updates/B4Latest/Bartender%204.dmg"
    expectedTeamID="8DD663WDX4"
    ;;
basecamp3)
    name="Basecamp 3"
    type="dmg"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then
        downloadURL="https://bc3-desktop.s3.amazonaws.com/mac_arm64/basecamp3_arm64.dmg"
    else
        downloadURL="https://bc3-desktop.s3.amazonaws.com/mac/basecamp3.dmg"
    fi
    expectedTeamID="2WNYUYRS7G"
    appName="Basecamp.app"
    ;;
baseline-nodaemon)
    #Baseline by @BigMacAdmin and Second Son Consulting
    #Use this label if you DO NOT want Baseline to run immediately upon install
    name="Baseline"
    type="pkg"
    archiveName="Baseline_NoDaemon_v[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit secondsonconsulting Baseline )
    expectedTeamID="7Q6XP5698G"
    ;;
baseline)
    #Baseline by @BigMacAdmin and Second Son Consulting
    #Use this label if you want Baseline to run immediately upon install
    name="Baseline"
    type="pkg"
    archiveName="Baseline_v[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit secondsonconsulting Baseline )
    expectedTeamID="7Q6XP5698G"
    ;;
basictex)
    # Small LaTeX alternative to mactex
    name="BasicTeX"
    type="pkg"
    downloadURL="https://mirror.ctan.org/systems/mac/mactex/BasicTeX.pkg"
    expectedTeamID="RBGCY5RJWM"
    ;;
bbedit)
    name="BBEdit"
    type="dmg"
    downloadURL=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort | tail -n1 | cut -d">" -f2 | cut -d"<" -f1)
    appNewVersion=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort  | tail -n1 | sed -E 's/.*BBEdit_([0-9 .]*)\.dmg.*/\1/')
    expectedTeamID="W52GZAXT98"
    ;;
bbeditpkg)
    name="BBEdit"
    type="pkg"
    downloadURL=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort | tail -n1 | cut -d">" -f2 | cut -d"<" -f1 | sed 's/dmg/pkg/')
    appNewVersion=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort  | tail -n1 | sed -E 's/.*BBEdit_([0-9 .]*)\.dmg.*/\1/')
    expectedTeamID="W52GZAXT98"
    ;;
beamstudio)
    name="Beam Studio"
    type="dmg"
    expectedTeamID="4Y92JWKV94"
    downloadURL="$( curl -s "https://id.flux3dp.com/api/check-update?key=beamstudio-stable" | tr '"' '\n' | grep -m1 dmg )"
    appNewVersion="$( echo "$downloadURL" | cut -d '+' -f 3 | cut -d '.' -f 1-3 )"
    ;;
betterdisplay)
    name="BetterDisplay"
    type="dmg"
    downloadURL=$(downloadURLFromGit waydabber BetterDisplay)
    appNewVersion=$(versionFromGit waydabber BetterDisplay)
    expectedTeamID="299YSU96J7"
    ;;
bettertouchtool)
    # credit: Søren Theilgaard (@theilgaard)
    name="BetterTouchTool"
    type="zip"
    downloadURL="https://folivora.ai/releases/BetterTouchTool.zip"
    appNewVersion=$(curl -fs https://updates.folivora.ai/bettertouchtool_release_notes.html | grep BetterTouchTool | head -n 2 | tail -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g')
    expectedTeamID="DAFVSXZ82P"
    ;;
beyondcomparepro)
    name="Beyond Compare"
    type="zip"
    downloadURL="https://www.scootersoftware.com"$(curl -fsL 'https://www.scootersoftware.com/download' | sed -nE 's/.*"(.*OSX-[^"]*)".*/\1/p')
    appNewVersion=$( grep -oE '(\d+\.){2}(\d+)' <<< $downloadURL )
    expectedTeamID="BS29TEJF86"
    ;;
bibdesk)
    name="BibDesk"
    type="dmg"
    html_page_source=$(curl -sL https://bibdesk.sourceforge.io)
    downloadURL="$(echo $html_page_source | grep -i "current version" | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}')"
    appNewVersion="$(echo $html_page_source | grep -i "current version" | sed -n 's:.*BibDesk-\(.*\).dmg.*:\1:p')"
    expectedTeamID="J33JTA7SY9"
    ;;
bitrix24)
     name="Bitrix24"
     type="dmg"
     archiveName="bitrix24_desktop.dmg"
     downloadURL="https://dl.bitrix24.com/b24/bitrix24_desktop.dmg"
     expectedTeamID="5B3T3A994N"
     ;;
bitwarden)
    name="Bitwarden"
    type="dmg"
    appNewVersion=$(curl -s "https://github.com/bitwarden/clients/releases?q\=desktop" | xmllint --html --xpath 'substring-after(string(//h2[starts-with(text(),"Desktop v")]), " v")' - 2>/dev/null)
    downloadURL="https://github.com/bitwarden/clients/releases/download/desktop-v${appNewVersion}/Bitwarden-${appNewVersion}-universal.dmg"
    expectedTeamID="LTZ2PFU5D6"
    ;;
bitwigstudio)
    name="Bitwig Studio"
    type="dmg"
    appNewVersion="$(curl -fs "https://www.bitwig.com/download/" | grep 'changelog' | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')"
    downloadURL="https://www.bitwig.com/dl/Bitwig%20Studio/${appNewVersion}/installer_mac/"
    expectedTeamID="2B6K987585"
    ;;
blender)
    name="Blender"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    baseVersion=$(curl -sf https://ftp.nluug.nl/pub/graphics/blender/release/ | grep -o 'Blender[0-9]\+\.[0-9]\+' | cut -d 'r' -f 2 | sort -V | tail -1)
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(curl -sf https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/ | grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-arm64\.dmg' | sort -V | tail -1 | sed -E 's/[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/' )
        archiveName=$(curl -sf "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/"| grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-arm64\.dmg' | sort -V | tail -1)
        downloadURL="https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/$archiveName"
    elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$(curl -sf https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/ | grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-x64\.dmg' | sort -V | tail -1 | sed -E 's/[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/' )
        archiveName=$(curl -sf "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/" | grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-x64\.dmg' | sort -V | tail -1)
        downloadURL="https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/$archiveName"
    fi
    expectedTeamID="68UA947AUU"
    ;;
bluejeans)
    name="BlueJeans"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeans.*Installer.*arm.*.pkg" )
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeansInstaller.*x86.*.dmg" | sed 's/dmg/pkg/g')
    fi
    appNewVersion=$(echo $downloadURL | cut -d '/' -f6)
    expectedTeamID="HE4P42JBGN"
    ;;
bluejeanswithaudiodriver)
    name="BlueJeans"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeans.*Installer.*arm.*.pkg" )
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeansInstaller.*x86.*.dmg" | sed 's/dmg/pkg/g')
    fi
    appNewVersion=$(echo $downloadURL | cut -d '/' -f6)
    choiceChangesXML='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><array><dict><key>attributeSetting</key><integer>1</integer><key>choiceAttribute</key><string>selected</string><key>choiceIdentifier</key><string>com.tatvikmohit.BlueJeans-Audio</string></dict></array></plist>'
    expectedTeamID="HE4P42JBGN"
    ;;
boop)
    name="Boop"
    type="zip"
    downloadURL=$(downloadURLFromGit IvanMathy Boop)
    appNewVersion=$(versionFromGit IvanMathy Boop)
    expectedTeamID="RLZ8XBTX7G"
    ;;
boxdrive)
    name="Box"
    type="pkg"
    downloadURL="https://e3.boxcdn.net/desktop/releases/mac/BoxDrive.pkg"
    expectedTeamID="M683GB7CPW"
    ;;
boxsync)
    name="Box Sync"
    type="dmg"
    downloadURL="https://e3.boxcdn.net/box-installers/sync/Sync+4+External/Box%20Sync%20Installer.dmg"
    expectedTeamID="M683GB7CPW"
    ;;
boxtools)
    name="Box Tools"
    type="pkg"
    downloadURL="https://box-installers.s3.amazonaws.com/boxedit/mac/currentrelease/BoxToolsInstaller.pkg"
    packageID="com.box.boxtools.installer.boxedit"
    expectedTeamID="M683GB7CPW"
    ;;
adobebrackets|\
bracketsio)
    name="Brackets"
    type="dmg"
    downloadURL=$(downloadURLFromGit brackets-cont brackets )
    appNewVersion=$(versionFromGit brackets-cont brackets )
    expectedTeamID="JQ525L2MZD"
    ;;
brave)
    name="Brave Browser"
    type="dmg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL=$(curl -fsIL https://laptop-updates.brave.com/latest/osxarm64/release | grep -i "^location" | sed -E 's/.*(https.*\.dmg).*/\1/g')
        appNewVersion="$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable-arm64/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null  | cut -d '"' -f 2)"
        #appNewVersion="96.$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable-arm64/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString' 2>/dev/null  | cut -d '"' -f 2 | cut -d "." -f1-3)"
    else
        printlog "Architecture: i386"
        downloadURL=$(curl -fsIL https://laptop-updates.brave.com/latest/osx/release | grep -i "^location" | sed -E 's/.*(https.*\.dmg).*/\1/g')
        appNewVersion="$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null  | cut -d '"' -f 2)"
        #appNewVersion="96.$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString' 2>/dev/null  | cut -d '"' -f 2 | cut -d "." -f1-3)"
    fi
    versionKey="CFBundleVersion"
#    downloadURL=$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="KL8N8XSYF4"
    ;;
bravepkg)
    name="Brave Browser"
    type="pkg"
    downloadURL="https://referrals.brave.com/latest/Brave-Browser.pkg" # Universal
        # https://referrals.brave.com/latest/Brave-Browser-arm64.pkg - ARM64
    appNewVersion="$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null  | cut -d '"' -f 2)"
    versionKey="CFBundleVersion"
    expectedTeamID="KL8N8XSYF4"
    ;;
brosix)
    name="Brosix"
    type="pkg"
    downloadURL="https://www.brosix.com/downloads/builds/official/Brosix.pkg"
    appNewVersion=""
    expectedTeamID="TA6P23NW8H"
    ;;
bruno)
    # https://github.com/usebruno/bruno; https://www.usebruno.com/
    name="Bruno"
    type="dmg"
    if [[ $(arch) == “arm64” ]]; then
        archiveName="bruno_[0-9.]*_arm64_mac.dmg"
    elif [[ $(arch) == “i386” ]]; then
        archiveName="bruno_[0-9.]*_x64_mac.dmg"
    fi
    downloadURL="$(downloadURLFromGit usebruno bruno)"
    appNewVersion="$(versionFromGit usebruno bruno)"
    expectedTeamID="W7LPPWA48L"
    ;;
bugdom)
    name="Bugdom"
    type="dmg"
    downloadURL=$(downloadURLFromGit jorio Bugdom)
    appNewVersion=$(versionFromGit jorio Bugdom)
    expectedTeamID="RVNL7XC27G"
    ;;
burpsuitecommunityedition)
    name="Burp Suite Community Edition"
    type="dmg"
    appNewVersion=$(curl -s https://portswigger.net/burp/releases | grep 'releases/professional-community' | head -n 1 | sed 's/.*href="//' | sed 's/".*//' | cut -d '/' -f4 | cut -d '-' -f3-6 | sed -r 's/-/./g')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://portswigger.net/burp/releases/startdownload/?product=community&version&="$appNewVersion"&type=macosarm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://portswigger.net/burp/releases/startdownload/?product=community&version&="$appNewVersion"&type=macosx"
    fi
    expectedTeamID="N82YM748DZ"
    ;;
burpsuiteprofessional)
    name="Burp Suite Professional"
    type="dmg"
    appNewVersion=$(curl -s https://portswigger.net/burp/releases | grep 'releases/professional-community' | head -n 1 | sed 's/.*href="//' | sed 's/".*//' | cut -d '/' -f4 | cut -d '-' -f3-6 | sed -r 's/-/./g')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://portswigger.net/burp/releases/startdownload/?product=pro&version&="$appNewVersion"&type=macosarm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://portswigger.net/burp/releases/startdownload/?product=pro&version&="$appNewVersion"&type=macosx"
    fi
    expectedTeamID="N82YM748DZ"
    ;;
busycontacts)
    name="BusyContacts"
    type="dmg"
    downloadURL="https://www.busymac.com/download/BusyContacts.dmg"
    appNewVersion=$( curl -ILs "https://www.busymac.com/download/BusyContacts.dmg" | grep -m 1 -i '^location' | sed 's/.*bct-//' | sed 's/.dmg//' )
    expectedTeamID="N4RA379GBW"
    appName="BusyContacts.app"
    blockingProcesses=( "BusyContacts" )
    ;;
buttercup)
    name="Buttercup"
    type="zip"
	archiveName="Buttercup-[0-9.]*-mac.zip"
	downloadURL=$(downloadURLFromGit buttercup buttercup-desktop)
    appNewVersion=$(versionFromGit buttercup buttercup-desktop)
    expectedTeamID="9D8F4J769D"
    ;;
caffeine)
    name="Caffeine"
    type="dmg"
    downloadURL=$(downloadURLFromGit IntelliScape caffeine)
    appNewVersion=$(versionFromGit IntelliScape caffeine)
    expectedTeamID="YD6LEYT6WZ"
    ;;
cakebrew)
    name="Cakebrew"
    type="zip"
    downloadURL=$(curl -fsL "https://www.cakebrew.com/appcast/profileInfo.php" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$( curl -fsL "https://www.cakebrew.com/appcast/profileInfo.php" | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="R85D3K8ATT"
    ;;
calcservice)
    name="CalcService"
    type="zip"
    downloadURL="$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" "https://www.devontechnologies.com/support/download" | tr '"' "\n" | grep -o "http.*download.*.zip" | grep -i calcservice | head -1)"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')"
    expectedTeamID="679S2QUWR8"
    ;;
calibre)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="calibre"
    type="dmg"
    downloadURL="https://calibre-ebook.com/dist/osx"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    #Maybe change to GitHub for this title. Looks like 5.28.0 release is the first to also release a binary, so maybe see what the next release will be to decide if we should switch.
    #downloadURL=$(downloadURLFromGit kovidgoyal calibre )
    #appNewVersion=$(versionFromGit kovidgoyal calibre )
    #archiveName="OS X dmg"
    expectedTeamID="NTY7FVCEKP"
    ;;
calibriteprofiler)
    name="calibrite PROFILER"
    type="dmg"
    downloadURL="$(downloadURLFromGit LUMESCA calibrite-profiler-releases)"
    appNewVersion="$(versionFromGit LUMESCA calibrite-profiler-releases)"
    expectedTeamID="5C392763F5"
    ;;
camostudio)
    name="Camo Studio"
    type="zip"
    downloadURL="https://reincubate.com/res/labs/camo/camo-macos-latest.zip"
    #appNewVersion=$(curl -s -L  https://reincubate.com/support/camo/release-notes/ | grep -m2 "has-m-t-0" | head -1 | cut -d ">" -f2 | cut -d " " -f1)
    appNewVersion=$( curl -fs "https://uds.reincubate.com/release-notes/camo/" | head -1 | cut -d "," -f3 | grep -o -e "[0-9.]*" )
    # Camo Studio will ask for admin permissions to install som plug-ins. that has not been handled.
    expectedTeamID="Q248YREB53"
    ;;
camtasia2019)
    name="Camtasia 2019"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Camtasia (Mac) 2019" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Camtasia (Mac) 2019" | sed -e 's/.*Camtasia (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
camtasia2020)
    name="Camtasia 2020"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Camtasia (Mac) 2020" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Camtasia (Mac) 2020" | sed -e 's/.*Camtasia (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
camtasia2021)
    name="Camtasia 2021"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Camtasia (Mac) 2021" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Camtasia (Mac) 2021" | sed -e 's/.*Camtasia (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
camtasia2022)
    name="Camtasia 2022"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Camtasia (Mac) 2022" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Camtasia (Mac) 2022" | sed -e 's/.*Camtasia (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
camtasia2023)
    name="Camtasia 2023"
    type="dmg"
    sparkleData=$(curl -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=23.0.0&utm_source=product&utm_medium=cmac&utm_campaign=cm23&ipc_item_name=cmac&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
camtasia2024)
    name="Camtasia 2024"
    type="dmg"
    sparkleData=$(curl -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=24.0.0&utm_source=product&utm_medium=cmac&utm_campaign=cm24&ipc_item_name=cmac&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item[last()]/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item[last()]/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
camtasia|\
camtasia2025)
    name="Camtasia"
    type="dmg"
    sparkleData=$(curl -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=25.0.0&utm_source=product&utm_medium=cmac&utm_campaign=cm25&ipc_item_name=cmac&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item[last()]/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item[last()]/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
camunda)
    name="Camunda Modeler"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs https://camunda.com/download/modeler/ |  sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep arm64.dmg)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs https://camunda.com/download/modeler/ |  sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep x64.dmg)
    fi
    appNewVersion=$(echo "${downloadURL}" | sed 's/.*release\/camunda-modeler\/\([^\/]*\)\/camunda-modeler-.*/\1/')
    expectedTeamID="3JVGD57JQZ"
    ;;
canva)
    name="Canva"
    type="dmg"
        downloadURL=https://desktop-release.canva.com/Canva-latest.dmg
        appNewVersion=$( curl -fsLI -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -H "accept-encoding: gzip, deflate, br" -H "Referrer Policy: strict-origin-when-cross-origin" -H "upgrade-insecure-requests: 1" -H "sec-fetch-dest: document" -H "sec-gpc: 1" -H "sec-fetch-user: ?1" -H "accept-language: en-US,en;q=0.9" -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "sec-fetch-mode: navigate" "https://www.canva.com/download/mac/intel/canva-desktop/" | grep -i "^location" | cut -d " " -f2 | tr -d '\r' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-*.*\.dmg/\1/g' )

    expectedTeamID="5HD2ARTBFS"
    ;;
carboncopycloner)
    name="Carbon Copy Cloner"
    type="zip"
    downloadURL=$(curl -fsIL "https://api.bombich.com/download/ccc?v=latest" | grep -i ^location | sed -E 's/.*(https.*\.zip).*/\1/g')
    appNewVersion=$(sed -E 's/.*-([0-9.]*)\.zip/\1/g' <<< $downloadURL | sed 's/\.[^.]*$//')
    expectedTeamID="L4F2DED5Q7"
    ;;
catoclient)
    name="CatoClient"
    type="pkg"
    downloadURL="https://clientdownload.catonetworks.com/public/clients/CatoClient.pkg"
    appNewVersion=$(curl -Ls -o /dev/null -w %{url_effective} "${downloadURL}" | sed -E 's/.*\/([0-9.]*)\/.*/\1/g' | awk -F '.' '{print $1 "." $2 "." $3}')
    expectedTeamID="CKGSB8CH43"
    blockingProcesses=( "CatoClient" "CatoClientExtension" )
    ;;
charles)
    name="Charles"
    type="dmg"
    appNewVersion=$(curl -fs https://www.charlesproxy.com/download/latest-release/ | sed -nE 's/.*version.*value="([^"]*).*/\1/p')
    downloadURL="https://www.charlesproxy.com/assets/release/$appNewVersion/charles-proxy-$appNewVersion.dmg"
    expectedTeamID="9A5PCU4FSD"
    ;;
chatgpt)
    name="ChatGPT"
    type="dmg"
    downloadURL="https://persistent.oaistatic.com/sidekick/public/ChatGPT_Desktop_public_latest.dmg"
    appNewVersion="$(curl -fs "https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml" | xpath '(//rss/channel/item/title)[1]/text()' 2>/dev/null)"
    expectedTeamID="2DC432GLL2"
    ;;
chatwork)
     name="Chatwork"
     type="dmg"
     downloadURL="https://desktop-app.chatwork.com/installer/Chatwork.dmg"
     expectedTeamID="H34A3H2Y54"
     ;;
chemdoodle|\
chemdoodle2d)
    name="ChemDoodle"
    type="dmg"
    [[ $(arch) == "arm64" ]] && cpu_arch="aarch64" || cpu_arch="x64"
    downloadURL="https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | grep -oE '[^"]*Doodle-[^"]*'$cpu_arch'[^"]*\.dmg' | head -1)"
    expectedTeamID="9XP397UW95"
    folderName="ChemDoodle"
    appName="${folderName}/ChemDoodle.app"
    appNewVersion=$(sed -E 's/.*-(.*).dmg/\1/g' <<< $downloadURL )
    versionKey="CFBundleVersion"
    ;;
chemdoodle3d)
    name="ChemDoodle3D"
    type="dmg"
    [[ $(arch) == "arm64" ]] && cpu_arch="aarch64" || cpu_arch="x64"
    downloadURL="https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | grep -oE '[^"]*Doodle3D-[^"]*'$cpu_arch'[^"]*\.dmg' | head -1)"
    expectedTeamID="9XP397UW95"
    folderName="ChemDoodle3D"
    appName="${folderName}/ChemDoodle3D.app"
    appNewVersion=$(sed -E 's/.*-(.*).dmg/\1/g' <<< $downloadURL )
    versionKey="CFBundleVersion"
    ;;
cherryaudioatomika)
    name="Atomika"
    type="pkg"
    packageID="com.cherryaudio.pkg.AtomikaPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/atomika-synthesizer/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/atomika-synthesizer-macos-installer?file=Atomika-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioblue3)
    name="Blue3 Organ"
    type="pkg"
    packageID="com.cherryaudio.pkg.Blue3Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/blue3-tonewheel-organ/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/blue3-tonewheel-organ-macos-installer?file=Blue3-Organ-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioca2600)
    name="CA2600"
    type="pkg"
    packageID="com.cherryaudio.pkg.CA2600Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/ca2600/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/ca2600-macos-installer?file=CA2600-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiochroma)
    name="Chroma"
    type="pkg"
    packageID="com.cherryaudio.pkg.ChromaPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/chroma/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/chroma-macos-installer?file=Chroma-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiocr78)
    name="CR-78"
    type="pkg"
    packageID="com.cherryaudio.pkg.CR-78Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/cr-78/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/cr-78-macos-installer?file=CR-78-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiodco106)
    name="DCO-106"
    type="pkg"
    packageID="com.cherryaudio.pkg.DCO106Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/dco-106/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/dco-106-macos-installer?file=DCO-106-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiodreamsynth)
    name="Dreamsynth"
    type="pkg"
    packageID="com.cherryaudio.pkg.DreamsynthPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/dreamsynth/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/dreamsynth-macos-installer?file=Dreamsynth-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioeightvoice)
    name="Eight Voice"
    type="pkg"
    packageID="com.cherryaudio.pkg.EightVoicePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/eight-voice/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/eight-voice-macos-installer?file=Eight-Voice-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioelkax)
    name="Elka-X"
    type="pkg"
    packageID="com.cherryaudio.pkg.Elka-XPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/elka-x/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/elka-x-macos-installer?file=Elka-X-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiogalacticreverb)
    name="Galactic Reverb"
    type="pkg"
    packageID="com.cherryaudio.pkg.GalacticPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/galactic-reverb/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/galactic-reverb-macos-installer?file=Galactic-Reverb-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiogx80)
    name="GX-80"
    type="pkg"
    packageID="com.cherryaudio.pkg.GX-80Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/gx-80/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/gx-80-macos-installer?file=GX-80-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioharmonia)
    name="Harmonia"
    type="pkg"
    packageID="com.cherryaudio.pkg.HarmoniaPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/harmonia/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/harmonia-macos-installer?file=Harmonia-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiolowdown)
    name="Lowdown"
    type="pkg"
    packageID="com.cherryaudio.pkg.LowdownPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/lowdown/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/lowdown-macos-installer?file=Lowdown-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiomemorymode)
    name="Memorymode"
    type="pkg"
    packageID="com.cherryaudio.pkg.MemorymodePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/memorymode/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/memorymode-macos-installer?file=Memorymode-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiomercury4)
    name="Mercury-4"
    type="pkg"
    packageID="com.cherryaudio.pkg.Mercury-4Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/mercury-4/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/mercury-4-macos-installer?file=Mercury-4-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiomercury6)
    name="Mercury-6"
    type="pkg"
    packageID="com.cherryaudio.pkg.Mercury-6Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/mercury-6/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/mercury-6-macos-installer?file=Mercury-6-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiominiverse)
    name="Miniverse"
    type="pkg"
    packageID="com.cherryaudio.pkg.MiniversePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/miniverse/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/miniverse-macos-installer?file=Miniverse-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiomoduledesigner)
    name="Voltage Module Designer"
    type="pkg"
    packageID="com.cherryaudio.pkg.VoltageModuleDesigner"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/voltage-module-designer/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/module-designer-mac/download?file=Voltage-Module-Designer-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudionovachord)
    name="Novachord"
    type="pkg"
    packageID="com.cherryaudio.pkg.NovachordPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/novachord-solovox/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/novachord-macos-installer?file=Novachord-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiooctavecat)
    name="Octave Cat"
    type="pkg"
    packageID="com.cherryaudio.pkg.OctaveCatPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/octave-cat/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/octave-cat-macos-installer?file=Octave-Cat-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiopolymode)
    name="Polymode Synthesizer"
    type="pkg"
    packageID="com.cherryaudio.pkg.PolymodePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/polymode-synthesizer/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/polymode-synthesizer-macos-installer?file=Polymode-Synthesizer-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioprosoloist)
    name="Pro Soloist"
    type="pkg"
    packageID="com.cherryaudio.pkg.ProSoloistPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/pro-soloist/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/pro-soloist-macos-installer?file=Pro-Soloist-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiops20)
    name="PS-20"
    type="pkg"
    packageID="com.cherryaudio.pkg.PS-20Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/ps-20/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/ps-20-macos-installer?file=PS-20-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiops3300)
    name="PS-3300"
    type="pkg"
    packageID="com.cherryaudio.pkg.PS-3300Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/ps-3300/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/ps-3300-macos-installer?file=PS-3300-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudioquadra)
    name="Quadra"
    type="pkg"
    packageID="com.cherryaudio.pkg.QuadraPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/quadra/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/quadra-macos-installer?file=Quadra-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiorackmode)
    name="Rackmode"
    type="pkg"
    packageID="com.cherryaudio.pkg.RackmodePackage-StandAlone"
    blockingProcesses=( "Rackmode Frequency Shifter" "Rackmode Graphic EQ" "Rackmode Parametric EQ" "Rackmode Phaser" "Rackmode Ring Modulator" "Rackmode String Filter" "Rackmode Vocoder" "Rackmode Vocoder FX" )
    appNewVersion="$(curl -fs https://cherryaudio.com/products/rackmode/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/rackmode-macos-installer?file=Rackmode-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiosines)
    name="Sines"
    type="pkg"
    packageID="com.cherryaudio.pkg.SinesPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/sines/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/sines-macos-installer?file=Sines-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiosolovox)
    name="Solovox"
    type="pkg"
    packageID="com.cherryaudio.pkg.SolovoxPackage-StandAlone"
    appNewVersion="$(curl -fs curl -fs https://cherryaudio.com/products/novachord-solovox/version-history | grep -E -o ".<h4>Solovox</h4>.{0,40}" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/solovox-macos-installer?file=Solovox-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiostardust201)
    name="Stardust 201 Tape Echo"
    type="pkg"
    packageID="com.cherryaudio.pkg.Stardust201Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/stardust-201/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/stardust-201-macos-installer?file=Stardust-201-Tape-Echo-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiosurrealisticmg1plus)
    name="Surrealistic MG-1 Plus"
    type="pkg"
    packageID="com.cherryaudio.pkg.MG-1PlusPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/surrealistic-mg-1-plus/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/surrealistic-mg-1-plus-macos-installer?file=Surrealistic-MG-1-Plus-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiosync)
    name="Cherry Audio Sync"
    type="pkg"
    packageID="com.cherryaudio.pkg.SyncPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/sync/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/sync-macos-installer?file=Cherry-Audio-Sync-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiosynthesizerexpander)
    name="Synthesizer Expander Module"
    type="pkg"
    packageID="com.cherryaudio.pkg.SynthesizerExpanderModulePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/synthesizer-expander-module/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/synthesizer-expander-module-macos-installer?file=Synthesizer-Expander-Module-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiovoltagemodular)
    name="Voltage Modular"
    type="pkg"
    packageID="com.cherryaudio.pkg.VoltageModularPackageUniversal-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/voltage-modular/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/voltage-mac/download?file=Voltage-Modular-Installer-macOS-Universal.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
cherryaudiowurlybird140b)
    name="Wurlybird 140B"
    type="pkg"
    packageID="com.cherryaudio.pkg.Wurlybird140bPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/wurlybird140b/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/wurlybird140b-macos-installer?file=Wurlybird140B.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
chromeremotedesktop)
    name="chromeremotedesktop"
    type="pkgInDmg"
    packageID="com.google.pkg.ChromeRemoteDesktopHost"
    downloadURL="https://dl.google.com/chrome-remote-desktop/chromeremotedesktop.dmg"
    appNewVersion=""
    expectedTeamID="EQHXZ8M8AV"
    ;;
chronoagent)
    name="ChronoAgent"
    type="pkgInDmg"
    # packageID="com.econtechnologies.preference.chronoagent"
    # versionKey="CFBundleVersion"
    # None of the above can read out the installed version
    releaseURL="https://www.econtechnologies.com/UC/updatecheck.php?prod=ChronoAgent&lang=en&plat=mac&os=10.14.1&hw=i64&req=1&vers=#"
    appNewVersion=$(curl -sf $releaseURL | sed -r 's/.*VERSION=([^<]+).*/\1/')
    downloadURL="https://downloads.econtechnologies.com/CA_Mac_Download.dmg"
    expectedTeamID="9U697UM7YX"
    ;;
chronosync)
    name="ChronoSync"
    type="pkgInDmg"
    releaseURL="https://www.econtechnologies.com/UC/updatecheck.php?prod=ChronoSync&lang=en&plat=mac&os=10.14.1&hw=i64&req=1&vers=#"
    appNewVersion=$(curl -sf $releaseURL | sed -r 's/.*VERSION=([^<]+).*/\1/')
    downloadURL="https://downloads.econtechnologies.com/CS4_Download.dmg"
    expectedTeamID="9U697UM7YX"
    ;;
cinema4d)
    name="Cinema 4D"
    type="dmg"
    productDownloadsPage=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*downloads/cinema-4d[^"]*' | head -1)
    downloadURL=$(curl -fsL $productDownloadsPage | grep -oE 'https://[^"]*\.dmg' | head -1)
    appNewVersion=$(sed -E 's/.*_([0-9.]*)_Mac\.dmg/\1/g' <<< $downloadURL)
    targetDir="/Applications/Maxon Cinema 4D ${appNewVersion:0:4}"
    appCustomVersion(){
      defaults read "$targetDir/Cinema 4D.app/Contents/Info.plist" CFBundleGetInfoString | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+"
    }
    installerTool="Maxon Cinema 4D Installer.app"
    CLIInstaller="Maxon Cinema 4D Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --unattendedmodeui none )
    expectedTeamID="4ZY22YGXQG"
    ;;

cinema4d2023)
    name="Cinema 4D"
    type="dmg"
    appCustomVersion(){
      defaults read "/Applications/Maxon Cinema 4D 2023/Cinema 4D.app/Contents/Info.plist" CFBundleGetInfoString | grep -Eo "2023+\.[0-9]+\.[0-9]+"
    }
    productDownloadsPage=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*downloads/cinema-4d-2023[^"]*' | head -1)
    downloadURL=$(curl -fsL $productDownloadsPage | grep -oE 'https://[^"]*\.dmg' | head -1)
    appNewVersion=$(sed -E 's/.*_([0-9.]*)_Mac\.dmg/\1/g' <<< $downloadURL)
    targetDir="/Applications/Maxon Cinema 4D 2023"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/maxon/cinema4d/releases/${appNewVersion}/Cinema4D_2023_${appNewVersion}_Mac.dmg"
    installerTool="Maxon Cinema 4D Installer.app"
    CLIInstaller="Maxon Cinema 4D Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
cinema4d2024)
    name="Cinema 4D"
    type="dmg"
    appCustomVersion(){
      defaults read "/Applications/Maxon Cinema 4D 2024/Cinema 4D.app/Contents/Info.plist" CFBundleGetInfoString | grep -Eo "2024+\.[0-9]+\.[0-9]+"
    }
    productDownloadsPage=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*downloads/cinema-4d-2024[^"]*' | head -1)
    downloadURL=$(curl -fsL $productDownloadsPage | grep -oE 'https://[^"]*\.dmg' | head -1)
    appNewVersion=$(sed -E 's/.*_([0-9.]*)_Mac\.dmg/\1/g' <<< $downloadURL)
    targetDir="/Applications/Maxon Cinema 4D 2024"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/maxon/cinema4d/releases/${appNewVersion}/Cinema4D_2024_${appNewVersion}_Mac.dmg"
    installerTool="Maxon Cinema 4D Installer.app"
    CLIInstaller="Maxon Cinema 4D Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
cinema4d2025)
    name="Cinema 4D"
    type="dmg"
    appCustomVersion(){
      defaults read "/Applications/Maxon Cinema 4D 2025/Cinema 4D.app/Contents/Info.plist" CFBundleGetInfoString | grep -Eo "2025+\.[0-9]+\.[0-9]+"
    }
    productDownloadsPage=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*downloads/cinema-4d-2025[^"]*' | head -1)
    downloadURL=$(curl -fsL $productDownloadsPage | grep -oE 'https://[^"]*\.dmg' | head -1)
    appNewVersion=$(sed -E 's/.*_([0-9.]*)_Mac\.dmg/\1/g' <<< $downloadURL)
    targetDir="/Applications/Maxon Cinema 4D 2025"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/maxon/cinema4d/releases/${appNewVersion}/Cinema4D_2025_${appNewVersion}_Mac.dmg"
    installerTool="Maxon Cinema 4D Installer.app"
    CLIInstaller="Maxon Cinema 4D Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
cisdem-documentreader)
    name="cisdem-documentreader"
    type="dmg"
    downloadURL="https://download.cisdem.com/cisdem-documentreader.dmg"
    expectedTeamID="5HGV8EX6BQ"
    appName="Cisdem Document Reader.app"
    ;;
citrixworkspace)
    #credit: Erik Stam (@erikstam) and #Philipp on MacAdmins Slack
    name="Citrix Workspace"
    type="pkgInDmg"
    curlOptions=( --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36")
    parseURL() {
        urlToParse='https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html#ctx-dl-eula-external'
        htmlDocument=$(curl -s -L $urlToParse $curlOptions)
        xmllint --html --xpath "string(//a[contains(@rel, 'downloads.citrix.com')]/@rel)" 2> /dev/null <(print $htmlDocument)
    }
    downloadURL="https:$(parseURL)"
    newVersionString() {
        urlToParse='https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html'
        htmlDocument=$(curl -fs $urlToParse $curlOptions)
        xmllint --html --xpath 'string(//p[contains(., "Version")])' 2> /dev/null <(print $htmlDocument)
    }
    appNewVersion=$(newVersionString | cut -d ' ' -f2 | cut -d '(' -f1)
    versionKey="CitrixVersionString"
    expectedTeamID="S272Y5R93J"
    ;;
cleartouchcollage)
    name="Collage"
    type="pkgInZip"
    packageID="com.cvte.cleartouch.mac"
    downloadURL=$(curl -fs https://www.getcleartouch.com/download/collage-for-mac/ | xmllint --html --xpath 'string(//*[@id="wpdm-filelist-412"]/tbody/tr[1]/td[2]/a/@href)' - 2> /dev/null | sed 's/ /%20/g')
    expectedTeamID="P76M9BE8DQ"
    ;;
clevershare2)
    name="Clevershare"
    type="dmg"
    printlog "Label for $name broken in test" ERROR
    downloadURL=$(curl -fs https://www.clevertouch.com/eu/clevershare2g | grep -i -o -E "https.*notarized.*\.dmg")
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/([0-9.]*)\/[0-9]*\/.*\.dmg$/\1/')
    expectedTeamID="P76M9BE8DQ"
    ;;
clickshare)
    name="ClickShare"
    type="zip"
    json_feed=$(curl -fsL "https://assets.cloud.barco.com/clickshare/release/release.mac")
    appNewVersion=$(getJSONValue "${json_feed}" 'version')
    file_name=$(getJSONValue "${json_feed}" 'name')
    downloadURL="https://assets.cloud.barco.com/clickshare/release/${file_name}"
    expectedTeamID="P6CDJZR997"
    ;;
clickup)
	name="ClickUp"
	type="dmg"
	if [[ $(arch) == "arm64" ]]; then
		appNewVersion=$(curl -sD /dev/stdout https://desktop.clickup.com/mac/dmg/arm64 | grep filename | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
		downloadURL="https://desktop.clickup.com/mac/dmg/arm64"
	elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$(curl -sD /dev/stdout https://desktop.clickup.com/mac | grep filename | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
        downloadURL="https://desktop.clickup.com/mac"
	fi
	expectedTeamID="5RJWFAUGXQ"
	;;
clipgrab)
    name="ClipGrab"
    type="dmg"
    expectedTeamID="E8BJ3ZV5W8"
    downloadURL="$( curl -s 'https://clipgrab.org' | tr '"' '\n' | grep dmg )"
    appNewVersion="$( echo "$downloadURL" | sed -E 's/.*-([0-9.]*).dmg/\1/' )"
    ;;
clipy)
	name="Clipy"
	type="dmg"
    downloadURL=$(downloadURLFromGit Clipy Clipy)
    appNewVersion=$(versionFromGit Clipy Clipy)
    expectedTeamID="BBCHAJ584H"
    ;;
closeio)
    name="Close.io"
    type="dmg"
    downloadURL=$(downloadURLFromGit closeio closeio-desktop-releases)
    appNewVersion=$(versionFromGit closeio closeio-desktop-releases)
    expectedTeamID="WTNQ6773UC"
    ;;
cloudflarewarp)
    name="Cloudflare_WARP"
    type="pkg"
    packageID="com.cloudflare.1dot1dot1dot1.macos"
    downloadURL="https://1111-releases.cloudflareclient.com/mac/latest"
    appNewVersion="$(curl -SLI ${downloadURL} | grep -i "^location.*version" | awk -F "version/" '{print$2}' | awk -F "." '{print$1"."$2"."$3}')"
    expectedTeamID="68WVV388M8"
    ;;
cloudya)
    name="Cloudya"
    type="appInDmgInZip"
    downloadURL="$(curl -fs https://www.nfon.com/de/service/downloads | grep -i -E -o "https://cdn.cloudya.com/Cloudya-[.0-9]+-mac.zip")"
    appNewVersion="$(curl -fs https://www.nfon.com/de/service/downloads | grep -i -E -o "Cloudya Desktop App MAC [0-9.]*" | sed 's/^.*\ \([^ ]\{0,7\}\)$/\1/g')"
    expectedTeamID="X26F74J8TH"
    ;;
clue)
    #For personal use and students
    name="Clue"
    type="dmg"
    downloadURL=$(curl -fsL https://clue.no/en/download | grep "For personal use and students:" | sed 's/.*href="//' | sed 's/".*//')
    appNewVersion="$(echo "${downloadURL}" | sed -E 's/.*Clue*([0-9.]*)\..*/\1/g')"
    versionKey="CFBundleVersion"
    expectedTeamID="3NX6B9TB2F"
    ;;
cluefull)
    #For companies and schools
    name="Clue"
    type="dmg"
    downloadURL=$(curl -fsL https://clue.no/en/download | grep "For companies and schools:" | sed 's/.*href="//' | sed 's/".*//')
    appNewVersion="$(echo "${downloadURL}" | sed -E 's/.*Clue*([0-9.]*)\F.*/\1/g')"
    versionKey="CFBundleVersion"
    expectedTeamID="3NX6B9TB2F"
    ;;
cmake)
    name="CMake"
    type="dmg"
    downloadURL=$(downloadURLFromGit Kitware CMake)
    appNewVersion=$(versionFromGit Kitware CMake)
    expectedTeamID="W38PE5Y733"
    ;;
cocoapods)
    name="CocoaPods"
    type="bz2"
    downloadURL="$(downloadURLFromGit CocoaPods CocoaPods-app)"
    appNewVersion="$(versionFromGit CocoaPods CocoaPods-app)"
    expectedTeamID="AX2Q2BH2XR"
    ;;
coconutbattery)
    name="coconutBattery"
    type="zip"
    downloadURL="https://www.coconut-flavour.com/downloads/coconutBattery_4_latest.zip"
    appNewVersion=$(curl -fs https://www.coconut-flavour.com/coconutbattery/ | grep "<body" | sed -E 's/.*Download v([0-9+\.?]+).*/\1/')
    expectedTeamID="R5SC3K86L5"
    ;;
code42)
    name="Code42"
    type="pkgInDmg"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://download-preservation.code42.com/installs/agent/latest-mac.dmg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://download-preservation.code42.com/installs/agent/latest-mac-arm64.dmg"
    fi
    expectedTeamID="9YV9435DHD"
    blockingProcesses=( NONE )
    ;;
codemeter)
    name="CodeMeter"
    type="pkgInDmg"
    archiveName="CmInstall.pkg"
    appCustomVersion(){ defaults read "/Applications/Codemeter.app/Contents/Info.plist" CFBundleVersion | cut -d '.' -f 1-2 }
    html_page_source="https://www.wibu.com/de/support/anwendersoftware/anwendersoftware.html"
    macos_value=$(curl -fs $html_page_source | xmllint --html --format - 2>/dev/null | grep -Eo -m1 ' 12"> <option value=".*?"' | cut -d '"' -f3)
    downloadHTML="https://www.wibu.com/de/support/anwendersoftware/anwendersoftware/file/download/$macos_value.html"
    downloadURL="https://www.wibu.com"$(curl -fs $downloadHTML | xmllint --html --format - 2>/dev/null | grep -Eo 'rel="nofollow" href=".*?"' | cut -d '"' -f4)
    appNewVersion=$(curl -fs $html_page_source | xmllint --html --format - 2>/dev/null | grep -Eo "option value=\"$macos_value\" style=\"\">Version .*?\"" | sed -E 's/.*Version (.*) \| 2.*/\1/g')
    expectedTeamID="2SE7W37452"
    ;;
coderunner)
    name="CodeRunner"
    type="zip"
    downloadURL="https://coderunnerapp.com/download"
    appNewVersion=$(curl -fsIL ${downloadURL} | grep -i "^location" | cut -d " " -f2 | sed -E 's/.*CodeRunner-([0-9.]*).zip/\1/')
    expectedTeamID="R4GD98AJF9"
    ;;
colourcontrastanalyser)
    name="Colour Contrast Analyser"
    type="dmg"
    downloadURL=$(downloadURLFromGit ThePacielloGroup CCAe)
    appNewVersion=$(versionFromGit ThePacielloGroup CCAe)
    expectedTeamID="34RS4UC3M6"
    blockingProcesses=( NONE )
    ;;
connectfonts)
    name="Connect Fonts"
    type="dmg"
    downloadURL="https://links.extensis.com/connect_fonts/cf_latest?language=en&platform=mac"
    appNewVersion=$( curl -is "$downloadURL" | grep "location:" | grep -o "[[:digit:]]\+-[[:digit:]]\+-[[:digit:]]\+" | sed -e 's/-/./g' )
    expectedTeamID="J6MMHGD9D6"
    ;;
cormorant)
    # credit: Søren Theilgaard (@theilgaard)
    name="Cormorant"
    type="zip"
    downloadURL=$(curl -fs https://eclecticlight.co/downloads/ | grep -i $name | grep zip | sed -E 's/.*href=\"(https.*)\">.*/\1/g')
    appNewVersion=$(curl -fs https://eclecticlight.co/downloads/ | grep zip | grep -o -E "$name [0-9.]*" | awk '{print $2}')
    expectedTeamID="QWY4LRW926"
    ;;
craftmanager)
    name="CraftManager"
    type="zip"
    #downloadURL="https://craft-assets.invisionapp.com/CraftManager/production/CraftManager.zip"
    downloadURL="$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    expectedTeamID="VRXQSNCL5W"
    ;;
craftmanagerforsketch)
    name="CraftManager"
    type="zip"
    downloadURL="https://craft-assets.invisionapp.com/CraftManager/production/CraftManager.zip"
    appNewVersion=$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="VRXQSNCL5W"
    ;;
crashplan)
    name="CrashPlan"
    type="pkgInDmg"
    downloadURL="https://download.crashplan.com/installs/agent/latest-mac.dmg"
    appNewVersion=$( curl -sfI https://download.crashplan.com/installs/agent/latest-mac.dmg | awk -F'/' '/Location: /{print $7}' )
    archiveName=$( curl -sfI https://download.crashplan.com/installs/agent/latest-mac.dmg | awk -F'/' '/Location: /{print $NF}' )
    expectedTeamID="UGHXR79U6M"
    pkgName="Install CrashPlan.pkg"
    packageID="com.crashplan.app.pkg"
    ;;
crashplansmb)
    name="CrashPlan"
    type="pkgInDmg"
    pkgName="Install Crashplan.pkg"
    downloadURL="https://download.crashplan.com/installs/agent/latest-smb-mac.dmg"
    appNewVersion=$( curl https://download.crashplan.com/installs/agent/latest-smb-mac.dmg  -s -L -I -o /dev/null -w '%{url_effective}' | cut -d "/" -f7 )
    expectedTeamID="UGHXR79U6M"
    blockingProcesses=( NONE )
    ;;
cricutdesignspace)
    name="Cricut Design Space"
    type="dmg"
    cricutVersionURL=$(getJSONValue $(curl -fsL "https://apis.cricut.com/desktopdownload/UpdateJson?operatingSystem=osxnative&shard=a") "result")
    cricutVersionJSON=$(curl -fs "$cricutVersionURL")
    appNewVersion=$(getJSONValue "$cricutVersionJSON" "rolloutVersion")
    downloadURL=$(getJSONValue $(curl  -fsL "https://apis.cricut.com/desktopdownload/InstallerFile?shard=a&operatingSystem=osxnative&fileName=CricutDesignSpace-Install-v${appNewVersion}.dmg") "result")
    expectedTeamID="25627ZFVT7"
    ;;

cryptomator)
    name="Cryptomator"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(curl -fs "https://cryptomator.org/downloads/mac-arm64/thanks/" | grep -oE "href=https:\/\/github\.com\/cryptomator\/cryptomator\/releases\/download\/[0-9.]+\/.*?-arm64\.dmg " | awk -F '=' '{ print $2 }' | sed 's/[[:space:]]*$//')"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="$(curl -fs "https://cryptomator.org/downloads/mac/thanks/" | grep -oE "href=https:\/\/github.com\/cryptomator\/cryptomator\/releases\/download\/[0-9.]+/.*?-x64\.dmg " | awk -F '=' '{ print $2 }' | sed 's/[[:space:]]*$//')"
    fi
    appNewVersion=$(echo "${downloadURL}" | awk -F'/' '{ print $(NF-1) }')
    expectedTeamID="YZQJQUHA3L"
    ;;
crystalfetch)
	name="CrystalFetch"
	type="dmg"
    downloadURL=$(downloadURLFromGit TuringSoftware CrystalFetch)
    appNewVersion=$(versionFromGit TuringSoftware CrystalFetch)
    expectedTeamID="WDNLXAD4W8"
    ;;
cursorai)
    name="Cursor"
    type="dmg"
    appNewVersion=$(curl -sL "https://www.cursor.com/changelog" | xmllint --html -xpath "//article[1]" - 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)
    downloadURL=$(curl -fsL "https://www.cursor.com/api/download?platform=darwin-universal&releaseTrack=stable" | grep -o '"downloadUrl":"[^"]*"' | sed 's/"downloadUrl":"\([^"]*\)"/\1/')
    expectedTeamID="VDXQ22DGB9"
    blockingProcesses=( "Cursor" )
    ;;
cyberduck)
    name="Cyberduck"
    type="zip"
    downloadURL=$(curl -fs https://version.cyberduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
    appNewVersion=$(curl -fs https://version.cyberduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="G69SCX94XU"
    ;;
cycling74max)
    name="Max"
    type="dmg"
    downloadURL="$( curl -s "https://cycling74.com/downloads" $curlOptions | tr '"' '\n' | grep -m1 "Max.*dmg" )"
    appNewVersion=$(curl -s https://cycling74.com/downloads | grep -oE '9\.\d+\.\d+' | head -n 1)
    versionKey="CFBundleVersion"
    expectedTeamID="GBXXCFCVW5"
    ;;
cytoscape)
    name="Cytoscape"
    #appName="Cytoscape Installer.app"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Cytoscape_[0-9._]*_macos_aarch64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="Cytoscape_[0-9._]*_macos_x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit cytoscape cytoscape)"
    appNewVersion="$(versionFromGit cytoscape cytoscape)"
    installerTool="Cytoscape Installer.app"
    CLIInstaller="Cytoscape Installer.app/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q)
    expectedTeamID="35LDCJ33QT"
    ;;
daisydisk)
    name="DaisyDisk"
    type="zip"
    downloadURL="https://daisydiskapp.com/downloads/DaisyDisk.zip"
    appNewVersion=$( curl -fs 'https://daisydiskapp.com/downloads/appcastReleaseNotes.php?appEdition=Standard' | grep Version | head -1 | sed -E 's/.*Version ([0-9.]*).*/\1/g' )
    expectedTeamID="4CBU3JHV97"
    ;;
dangerzone)
    name="Dangerzone"
    type="dmg"
    downloadURL="$(downloadURLFromGit freedomofpress dangerzone)"
    appNewVersion="$(versionFromGit freedomofpress dangerzone)"
    expectedTeamID="N9B95FDWH4"
    ;;
darktable)
    # credit: Søren Theilgaard (@theilgaard)
    name="darktable"
    type="dmg"
    downloadURL=$(downloadURLFromGit darktable-org darktable)
    appNewVersion=$(versionFromGit darktable-org darktable)
    expectedTeamID="85Q3K4KQRY"
    ;;
daylite)
    name="Daylite"
    type="zip"
    downloadURL="https://www.marketcircle.com/downloads/latest-daylite"
    appNewVersion="$(curl -fs https://www.marketcircle.com/appcasts/daylite.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)"
    expectedTeamID="GR26KTJYTV"
    ;;
dbeaverce)
    name="DBeaver"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dbeaver.io/files/dbeaver-ce-latest-macos-aarch64.dmg"
        appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^location | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' | head -1)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dbeaver.io/files/dbeaver-ce-latest-macos.dmg"
        appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^location | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' | head -1)"
    fi
    expectedTeamID="42B6MDKMW8"
    blockingProcesses=( dbeaver )
    ;;
debookee)
    name="Debookee"
    type="zip"
    downloadURL=$(curl --location --fail --silent "https://www.iwaxx.com/debookee/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="AATLWWB4MZ"
    ;;
dedoose)
    name="Dedoose"
    type="dmg"
    downloadURL=$(curl https://www.dedoose.com/resources/articledetail/dedoose-desktop-app | grep "Dedoose-.*[0-9.].*[0-9.].*[0-9.]dmg" | cut -d'/' -f3- | cut -f1 -d'"' | cut -c2-)
    appNewVersion=$(curl https://www.dedoose.com/resources/articledetail/dedoose-desktop-app | grep -o "Dedoose-.*[0-9.].*[0-9.].*[0-9.]" | cut -d'>' -f2- | tail -1)
    expectedTeamID="9U74Q6K62X"
    ;;

deepl)
    name="DeepL"
    type="dmg"
    downloadURL="https://appdownload.deepl.com/macos/$(curl -fs https://appdownload.deepl.com/macos/ | grep -o "[0-9]\+\.[0-9]\+/[0-9]\+/DeepL\.dmg" | sort -t'/' -k1,1V -k2,2n | tail -n 1)"
    appNewVersion="$(curl -fs https://appdownload.deepl.com/macos/ | grep -o "[0-9]\+\.[0-9]\+/[0-9]\+/DeepL\.dmg" | sort -t'/' -k1,1V -k2,2n | tail -n 1 | awk -F'/' '{print $1 "." $2}')"
    expectedTeamID="4N8BGCG336"
    ;;
deezer)
    name="Deezer"
    type="dmg"
    # There is no arm/universal binary. Need rosetta2 to run it on apple silicon
    downloadURL="https://www.deezer.com/desktop/download?platform=darwin&architecture=x64"
    appNewVersion=$(curl -fsLI "$downloadURL" | grep -o "DeezerDesktop_[0-9]*\.[0-9]*\.[0-9]*" | cut -d'_' -f2)
    expectedTeamID="7QLUP2K45C"
    ;;
defaultfolderx)
    name="Default Folder X"
    type="dmg"
    sparkleFeed="$(curl -fsL "https://www.stclairsoft.com/cgi-bin/sparkle.cgi?DX5")"
    downloadURL="$(echo $sparkleFeed | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo $sparkleFeed | xpath 'string(//rss/channel/item/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="7HK42V8R9D"
    ;;
deon-cloud)
    name="Deon"
    type="zip"
    feedURL="https://download.deon.de/index.php?action=1&product=Mac&channel=cloud"
    downloadURL=$(curl -fs $feedURL | jq -r '.uris[1]')
    appNewVersion=$(curl -fs $feedURL | jq -r '.version')
    expectedTeamID="EW9H238RWQ"
    ;;
deon-onprem)
    name="Deon"
    type="zip"
    # beta channel for download is correct
    feedURL="https://download.deon.de/index.php?action=1&product=Mac&channel=beta"
    downloadURL=$(curl -fs $feedURL | jq -r '.uris[1]')
    appNewVersion=$(curl -fs $feedURL | jq -r '.version')
    expectedTeamID="EW9H238RWQ"
    ;;
depnotify)
    name="DEPNotify"
    type="pkg"
    downloadURL="https://files.jamfconnect.com/DEPNotify.pkg"
    expectedTeamID="VRPY9KHGX6"
    ;;
desktoppr)
    name="desktoppr"
    type="pkg"
    packageID="com.scriptingosx.desktoppr"
    downloadURL=$(downloadURLFromGit "scriptingosx" "desktoppr")
    appNewVersion=$(versionFromGit "scriptingosx" "desktoppr")
    expectedTeamID="JME5BW3F3R"
    blockingProcesses=( NONE )
    ;;
detectxswift)
    # credit: AP Orlebeke (@apizz)
    name="DetectX Swift"
    type="zip"
    downloadURL="https://s3.amazonaws.com/sqwarq.com/PublicZips/DetectX_Swift.app.zip"
    appNewVersion=$(curl -fs https://s3.amazonaws.com/sqwarq.com/AppCasts/dtxswift_release_notes.html | grep Version | head -1 | sed -E 's/.*Version ([0-9.]*)\<.*/\1/')
    expectedTeamID="MAJ5XBJSG3"
    ;;
devonthink)
    # It's a zipped dmg file, needs function installAppInDmgInZip
    # credit: Søren Theilgaard (@theilgaard)
    name="DEVONthink 3"
    type="appInDmgInZip"
    downloadURL=$( curl -fs https://www.devontechnologies.com/apps/devonthink | grep -i "download.devon" | tr '"' '\n' | tr "'" '\n' | grep -e '^https://' )
    appNewVersion=$( echo ${downloadURL} | tr '/' '\n' | grep "[0-9]" | grep "[.]" | head -1 )
    expectedTeamID="679S2QUWR8"
    ;;
dialog|\
swiftdialog)
    name="Dialog"
    type="pkg"
    packageID="au.csiro.dialogcli"
    downloadURL="$(downloadURLFromGit swiftDialog swiftDialog)"
    appNewVersion="$(versionFromGit swiftDialog swiftDialog)"
    expectedTeamID="PWA5E9TQ59"
    ;;
dialpad)
    # credit: @ehosaka
    name="Dialpad"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://storage.googleapis.com/dialpad_native/osx/arm64/Dialpad.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://storage.googleapis.com/dialpad_native/osx/x64/Dialpad.dmg"
    fi
    expectedTeamID="9V29MQSZ9M"
    ;;
digiexam)
	name="Digiexam"
	type="dmg"
	downloadURL="https://www.digiexam.com/hubfs/client/Digiexam_Mac.dmg"
    appNewVersion=$( curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs https://support.digiexam.se/hc/en-us/articles/7119593625628-Client-updates | perl -ne 'print if /Version(?!.*Only(?!.*Mac))(?=.*Mac)?/' | head -1 | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p' )
	expectedTeamID="73T9H7VE4P"
	;;
discord)
    name="Discord"
    type="dmg"
    downloadURL="https://discordapp.com/api/download?platform=osx"
    appNewVersion="$(curl -fsL -o /dev/null -w %{url_effective} "${downloadURL}" | awk -F'/' '{print $(NF-1)}')"
    expectedTeamID="53Q6R32WPB"
    ;;
diskdrill)
    name="Disk Drill"
    type="dmg"
    appname="Disk Drill.app"
    downloadURL="https://dl.cleverfiles.com/diskdrill.dmg"
    appNewVersion=$( curl -fsL "https://www.cleverfiles.com/releases/auto-update/dd5-newestr.xml" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)
    expectedTeamID="A3W62KZY8Z"
    ;;
diskspace)
    name="diskspace"
    type="pkg"
    packageID="com.scriptingosx.diskspace"
    downloadURL="$(downloadURLFromGit scriptingosx diskspace)"
    appNewVersion="$(versionFromGit scriptingosx diskspace)"
    expectedTeamID="JME5BW3F3R"
    ;;
displaylinkmanager)
    name="DisplayLink Manager"
    type="pkg"
    #packageID="com.displaylink.displaylinkmanagerapp"
    downloadURL=https://www.synaptics.com$(redirect=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep -m 1 'class="download-link">Download' | sed 's/.*href="//' | sed 's/".*//') && curl -sfL "https://www.synaptics.com$redirect" | grep 'class="no-link"' | awk -F 'href="' '{print $2}' | awk -F '"' '{print $1}')
    appNewVersion=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep -m 1 "Release:" | cut -d ' ' -f2)
    expectedTeamID="73YQY62QM3"
    ;;
displaylinkmanagergraphicsconnectivity)
    name="DisplayLink Manager Graphics Connectivity"
    type="pkg"
    packageID="com.displaylink.displaylinkmanagerapp"
    downloadURL=https://www.synaptics.com$(curl -fLs "https://www.synaptics.com$(curl -fLs https://www.synaptics.com/products/displaylink-graphics/downloads/macos | xmllint --html --format - 2>/dev/null | grep "download-link" | head -n1 | cut -d'"' -f2)" | xmllint --html --format - 2>/dev/null | grep -oE "/.+\.pkg")
    appNewVersion=$(echo "${downloadURL}" | grep -Eo '[0-9]\.[0-9]+(\.[0-9])?')
    expectedTeamID="73YQY62QM3"
    ;;
    displaynote)
    name="displaynote"
    type="pkg"
    packageID="com.displaynote.DisplayNoteApp"
    downloadURL="https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla/released/last?app_name=displaynote-mac"
    appNewVersion="$(curl -fsIL "https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla/released/last?app_name=displaynote-mac" | grep -i ^Content-Disposition | sed -n 's/.*displaynote-mac-\([0-9.]*\)-released\.pkg.*/\1/p')"
    expectedTeamID="Q3ML87W6WF"
    ;;
docker)
    name="Docker"
    type="dmg"
    if [[ "$(arch)" == arm64 ]]; then
        downloadURL="https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
        appNewVersion=$( curl -fs "https://desktop.docker.com/mac/main/arm64/appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[last()]' 2>/dev/null | cut -d '"' -f2 )
    elif [[ "$(arch)" == i386 ]]; then
        downloadURL="https://desktop.docker.com/mac/stable/amd64/Docker.dmg"
        appNewVersion=$( curl -fs "https://desktop.docker.com/mac/main/amd64/appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[last()]' 2>/dev/null | cut -d '"' -f2 )
    fi
    CLIInstaller="Docker.app/Contents/MacOS/install"
    CLIArguments=(--accept-license)
    if [[ "${currentUser}" != "loginwindow" ]];then
        CLIArguments+=(--user "${currentUser}")
    fi
    expectedTeamID="9BNSXJN65R"
    blockingProcesses=( "Docker Desktop" )
    ;;
dockutil)
    name="dockutil"
    type="pkg"
    packageID="dockutil.cli.tool"
    downloadURL=$(downloadURLFromGit "kcrawford" "dockutil")
    appNewVersion=$(versionFromGit "kcrawford" "dockutil")
    expectedTeamID="Z5J8CJBUWC"
    blockingProcesses=( NONE )
    ;;
dragonframe5)
    name="DragonFrame 5"
    type="pkg"
    packageID="com.dzed.Dragonframe5"
    expectedTeamID="PG7SM8SD8M"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    downloadURL="$( curl -s "https://www.dragonframe.com/downloads/" $curlOptions | tr '"' '\n' | grep -m1 "_5.*pkg" )"
    appNewVersion="$( echo "$downloadURL" | cut -d '_' -f 2 | cut -d '.' -f 1-3 )"
    ;;
drawio)
    name="draw.io"
    type="dmg"
    archiveName="draw.io-universal-[0-9.]*.dmg"
    downloadURL="$(downloadURLFromGit jgraph drawio-desktop)"
    appNewVersion="$(versionFromGit jgraph drawio-desktop)"
    expectedTeamID="UZEUFB4N53"
    blockingProcesses=( draw.io )
    ;;
drift)
    # credit Elena Ackley (@elenaelago)
    name="Drift"
    type="dmg"
    downloadURL="https://drift-prod-desktop-installers.s3.amazonaws.com/mac/Drift-latest.dmg"
    expectedTeamID="78559WUUR9"
    ;;
dropbox)
    name="Dropbox"
    type="dmg"
    # Handling differens on Apple Silicon and Intel arch
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        downloadURL="https://www.dropbox.com/download?plat=mac&full=1&arch=arm64"
    else
        printlog "Architecture: i386 (not arm64)"
        downloadURL="https://www.dropbox.com/download?plat=mac&full=1"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*%20([0-9.]*)\.[arm64.]*dmg/\1/g' | tr -d '[:cntrl:]' )
    expectedTeamID="G7HH3F8CAK"
    ;;
droplr)
    name="Droplr"
    type="dmg"
    downloadURL="$(downloadURLFromGit Droplr droplr-desktop-releases)"
    appNewVersion="$(versionFromGit Droplr droplr-desktop-releases)"
    expectedTeamID="MZ25PHMY7Y"
    ;;
druvainsync)
    name="Druva inSync"
    type="pkgInDmg"
    appNewVersion=$(getJSONValue "$(curl -fsL curl -fs https://downloads.druva.com/insync/js/data.json)" "[1].supportedVersions[0]")
    downloadURL=$(getJSONValue "$(curl -fsL curl -fs https://downloads.druva.com/insync/js/data.json)" "[1].installerDetails[0].downloadURL")
    expectedTeamID="JN6HK3RMAP"
    ;;
dstny)
    name="Dstny"
    type="dmg"
    downloadURL="https://soft.dstny.se/dstny_mac.dmg"
    # appNewVersion=""
    expectedTeamID="5RLWBLKGL2"
    versionKey="CFBundleVersion"
    ;;
duckduckgo)
    name="DuckDuckGo"
    type="dmg"
    #downloadURL="https://staticcdn.duckduckgo.com/macos-desktop-browser/duckduckgo.dmg"
    downloadURL=$(curl -fs https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast.xml | xpath '(//rss/channel/item/enclosure/@url)[last()]' 2>/dev/null | cut -d '"' -f2)
    #downloadURL=$(curl -fs https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast.xml | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    appNewVersion=$(curl -fs https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast.xml | xpath '(//rss/channel/item/enclosure/@sparkle:version)[last()]' 2>/dev/null | cut -d '"' -f2)
    #appNewVersion=$(curl -fs https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast.xml | xpath '(//rss/channel/item/sparkle:shortVersionString)[1]' 2>/dev/null | cut -d ">" -f2 | cut -d "<" -f1)
    expectedTeamID="HKE973VLUW"
    ;;
duet)
    name="Duet"
    type="zip"
    downloadURL="https://updates.duetdisplay.com/AppleSilicon"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f6 | sed 's/duet-//' | sed 's/.zip//' | sed 's/-/./g')"
    expectedTeamID="J6L96W8A86"
    blockingProcesses=( "duet" "duet Networking" )
    ;;
duodevicehealth|\
duodesktop)
    name="Duo Desktop"
    type="pkg"
    downloadURL="https://dl.duosecurity.com/DuoDesktop-latest.pkg"
    appNewVersion=$(curl -fsLIXGET "https://dl.duosecurity.com/DuoDesktop-latest.pkg" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"DuoDesktop\-\(.*\)\.pkg\".*/\1/')
    expectedTeamID="FNN8Z5JMFP"
    ;;
dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    appNewVersion=$(curl -s https://formulae.brew.sh/cask/dymo-connect | grep -o 'Current version:.*[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    archiveName="DCDMac${appNewVersion}.pkg"
    downloadURL="https://download.dymo.com/dymo/Software/Mac/DCDMac${appNewVersion}.pkg"
    expectedTeamID="N3S6676K3E"
    ;;
dynalist)
    name="Dynalist"
    type="dmg"
    downloadURL="https://dynalist.io/standalone/download?file=Dynalist.dmg"
    appNewVersion=""
    expectedTeamID="6JSW4SJWN9"
    ;;
easeusdatarecoverywizard)
    # credit: Søren Theilgaard (@theilgaard)
    name="EaseUS Data Recovery Wizard"
    type="dmg"
    downloadURL=$( curl -fsIL https://down.easeus.com/product/mac_drw_free_setup | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' )
    #appNewVersion=""
    expectedTeamID="DLLVW95FSM"
    ;;
eastwestinstallationcenter)
    name="EW Installation Center"
    type="pkgInZip"
    packageID="com.eastwest.pkg.installationcenter"
    downloadXML="$(curl -fs 'http://s3.amazonaws.com/ic-resources/products/IC.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath '(//product/files/file[@platform="mac"]/url/text())' 2>/dev/null)"
    appNewVersion="$(echo "${downloadXML}" | xpath '(//product/version/text())' 2>/dev/null)"
    expectedTeamID="TWK4WE76V9"
    ;;
eastwestopus)
    name="Opus"
    type="pkgInZip"
    packageID="com.eastwest.pkg.OpusInstaller"
    downloadXML="$(curl -fs 'http://s3.amazonaws.com/ic-resources/products/OPUS.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath '(//product/files/file[@platform="mac"]/url/text())' 2>/dev/null)"
    appNewVersion="$(echo "${downloadXML}" | xpath '(//product/version/text())' 2>/dev/null)"
    expectedTeamID="TWK4WE76V9"
    ;;
eastwestplay)
    name="Play"
    type="pkgInZip"
    downloadXML="$(curl -fs 'http://s3.amazonaws.com/ic-resources/products/PLAY.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath '(//product/files/file[@platform="mac"]/url/text())' 2>/dev/null)"
    appNewVersion="$(echo "${downloadXML}" | xpath '(//product/version/text())' 2>/dev/null)"
    appCustomVersion(){ /usr/bin/defaults read "/Library/Application Support/East West/Play.app/Contents/Info.plist" CFBundleShortVersionString }
    pkgName="Play Installer ${appNewVersion}.pkg"
    expectedTeamID="TWK4WE76V9"
    ;;
easyfind)
    name="EasyFind"
    type="zip"
    downloadURL="$(curl -fs "https://www.devontechnologies.com/apps/freeware" | grep -o "http.*download.*.zip" | grep -i easyfind)"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')"
    expectedTeamID="679S2QUWR8"
    ;;
eclipsetemurin11)
    name="Temurin 11"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="OpenJDK11U-jdk_aarch64_mac_hotspot_[0-9._]+\.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="OpenJDK11U-jdk_x64_mac_hotspot_[0-9._]+\.pkg"
    fi
    downloadURL="$(downloadURLFromGit adoptium temurin11-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin11-binaries | grep -oE 'jdk-11(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //'; fi }
    ;;
eclipsetemurin17)
    name="Temurin 17"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="OpenJDK17U-jdk_aarch64_mac_hotspot_[0-9._]+\.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="OpenJDK17U-jdk_x64_mac_hotspot_[0-9._]+\.pkg"
    fi
    downloadURL="$(downloadURLFromGit adoptium temurin17-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin17-binaries | grep -oE 'jdk-17(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //'; fi }
    ;;
eclipsetemurin21)
    name="Temurin 21"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="OpenJDK21U-jdk_aarch64_mac_hotspot_[0-9._]+\.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="OpenJDK21U-jdk_x64_mac_hotspot_[0-9._]+\.pkg"
    fi
    downloadURL="$(downloadURLFromGit adoptium temurin21-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin21-binaries | grep -oE 'jdk-21(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //; s/-LTS//'; fi }
    ;;

eclipsetemurin8)
    name="Temurin 8"
    type="pkg"
    downloadURL="$(downloadURLFromGit adoptium temurin8-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin8-binaries | grep -oE 'jdk8u[0-9]+-b[0-9]+' | sed 's/jdk//')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Info.plist" ]; then echo "8u$(/usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/Eclipse Temurin 1.8.0_//')"; fi }
    ;;
ecosiabrowser)
    name="Ecosia Browser"
    type="dmg"
 	downloadURL=$(getJSONValue "$(curl -fsL 'https://ams.ecosia-browser.net/api/getLatest/144548e4-670e-46ef-be30-8d14ad305f19/mac/?update=false&channelprofilename=PROD&arch=x64')" '.LocationUri')
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://ams.ecosia-browser.net/api/getLatest/144548e4-670e-46ef-be30-8d14ad305f19/mac/?update=false&channelprofilename=PROD&arch=x64')" '.Version')
    expectedTeamID="33YMRSYD2L"
    ;;
egnyte)
    # credit: #MoeMunyoki from MacAdmins Slack
    name="Egnyte Connect"
    type="pkg"
    downloadURL="https://egnyte-cdn.egnyte.com/egnytedrive/mac/en-us/latest/EgnyteConnectMac.pkg"
    appNewVersion=$(curl -fs "https://egnyte-cdn.egnyte.com/egnytedrive/mac/en-us/versions/default.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' | cut -d '"' -f 2)
    expectedTeamID="FELUD555VC"
    blockingProcesses=( NONE )
    ;;
egnytecore)
    name="Egnyte Core"
    appName="Egnyte.app"
    type="dmg"
    downloadURL=$(curl -fs "https://egnyte-cdn.egnyte.com/desktopapp/mac/en-us/versions/default.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://egnyte-cdn.egnyte.com/desktopapp/mac/en-us/versions/default.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="FELUD555VC"
    blockingProcesses=( Egnyte )
    ;;
egnytewebedit)
    name="EgnyteWebEdit"
    type="pkg"
    downloadURL="https://egnyte-cdn.egnyte.com/webedit/mac/en-us/latest/EgnyteWebEdit.pkg"
    expectedTeamID="FELUD555VC"
    appName="Egnyte WebEdit.app"
    blockingProcesses=( NONE )
    ;;
    
elasticvue)
    name="elasticvue"
    type="dmg"
    downloadURL="$(downloadURLFromGit cars10 elasticvue)"
    appNewVersion="$(versionFromGit cars10 elasticvue)"
    expectedTeamID="9L4YGY6JVY"
    ;;
element)
    name="Element"
    type="dmg"
    downloadURL="https://packages.riot.im/desktop/install/macos/Element.dmg"
    appNewVersion=$(versionFromGit vector-im element-desktop)
    expectedTeamID="7J4U792NQT"
    ;;
elgatocamerahub)
    name="Elgato Camera Hub"
    type="pkg"
    # packageID="com.elgato.CameraHub.Installer"
    downloadURL="https://gc-updates.elgato.com/mac/echm-update/final/download-website.php"
    appNewVersion=$(curl -fsI "https://gc-updates.elgato.com/mac/echm-update/final/download-website.php" | grep -i ^location | sed -E 's/.*Camera_Hub_([0-9.]*).pkg/\1/g' | sed 's/\.[^.]*//3')
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Camera Hub" )
    ;;
elgatostreamdeck)
    name="Elgato Stream Deck"
    type="pkg"
    # packageID="com.elgato.StreamDeck"
	downloadURL="https://gc-updates.elgato.com/mac/sd-update/final/download-website.php"
    appNewVersion=$(curl -fsI "https://gc-updates.elgato.com/mac/sd-update/final/download-website.php" | grep -i ^location | sed -E 's/.*Stream_Deck_([0-9.]*).pkg/\1/g' | sed 's/\.[^.]*//3')
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Stream Deck" )
    ;;
emacs)
    name="Emacs"
    type="dmg"
    downloadURL="$(curl -fsL "https://emacsformacosx.com/atom/release" | xpath '//feed/entry[1]/content/div/p/a' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(echo "${downloadURL}" | sed -n 's/.*Emacs-\([0-9.-]*\)-universal.dmg/\1/p')"
    expectedTeamID="5BRAQAFB8B"
    ;;
enteauth)
    name="Ente Auth"
    type="dmg"
    appNewVersion="$(curl -sfL https://ente.io/release-info/auth-independent.json | grep '"name": ' | awk '{print $2}' | awk -F\" '{print $2}' | sed 's/^v//')"
    downloadURL="https://github.com/ente-io/ente/releases/download/auth-v${appNewVersion}/ente-auth-v${appNewVersion}.dmg"
# | sed 's/\ /%20/g')
    expectedTeamID="6Z68YJY9Q2"
    ;;
epicgameslauncher)
	name="Epic Games Launcher"
	type="dmg"
	downloadURL="https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher.dmg"
	appNewVersion=$( curl -s "https://trello.com/b/GXLc34hk.json" | jq -r '.cards[] | select(.name | test("Epic Games Launcher [0-9]+\\.[0-9]+(\\.[0-9]+)?")) | .name' | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | sort -V | tail -n 1 )
	versionKey="CFBundleShortVersionString"
	expectedTeamID="96DBZ92D3Y"
	;;
eposconnect)
    name="EPOS Connect"
    type="pkg"
    #packageID="com.DSEA.pkg.DSEASDKM1"
    #downloadURL="https://www.eposaudio.com/globalassets/___image-library/_enterprise/files/english/epos-connect/epos-connect-7.7.0/eposconnect_7.7.0.44457.pkg"
    downloadURL=$(curl -fs "https://www.eposaudio.com/en/dk/software/epos-connect" | tr '"' "\n" | grep -o "^https://www.eposaudio.*.pkg$")
    versionKey="CFBundleVersion"
    # 2024-02-06: appNewVersion commented out as the latest version is 7.8.1 but above page only shows 7.7.0
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*_([0-9.]*).pkg/\1/' | cut -d "." -f4)
    expectedTeamID="8956A7Y69J"
    ;;
escrowbuddy)
    name="Escrow Buddy"
    type="pkg"
    archiveName="Escrow.Buddy-[0-9.]*.pkg"
    packageID="com.netflix.Escrow-Buddy"
    appNewVersion=$(versionFromGit macadmins escrow-buddy )
    downloadURL=$(downloadURLFromGit macadmins escrow-buddy )
    expectedTeamID="T4SK8ZXCXG"
    ;;
eshareosx)
    name="e-Share"
    type="pkg"
    #packageID="com.ncryptedcloud.e-Share.pkg"
    downloadURL=https://www.ncryptedcloud.com/static/downloads/osx/$(curl -fs https://www.ncryptedcloud.com/static/downloads/osx/ | grep -o -i "href.*\".*\"" | cut -d '"' -f2)
    versionKey="CFBundleVersion"
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z\-]*_([0-9.]*)\.pkg/\1/g' )
    expectedTeamID="X9MBQS7DDC"
    ;;
espanso)
    name="Espanso"
    type="zip"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="Espanso-Mac-M1.zip"
    else
        archiveName="Espanso-Mac-Intel.zip"
    fi
    downloadURL="$(downloadURLFromGit espanso espanso)"
    appNewVersion="$(versionFromGit espanso espanso)"
    blockingProcesses=( "Espanso" "espanso" )
    expectedTeamID="K839T4T5BY"
    ;;
etrecheck)
    # credit: @dvsjr macadmins slack
    name="EtreCheckPro"
    type="zip"
    downloadURL="https://cdn.etrecheck.com/EtreCheckPro.zip"
    expectedTeamID="U87NE528LC"
    ;;
etssecurebrowser)
    name="ETS Secure Browser"
    type="dmg"
    downloadURL="https://ibtprod-rp.ets.org/SoftwareDistribution/rp/PROD/mac/ETS-RP-PROD.dmg"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="WGC236CZU9"
    ;;
eul)
    name="eul"
    type="zip"
    downloadURL="$(downloadURLFromGit gao-sun eul)"
    appNewVersion="$(versionFromGit gao-sun eul)"
    expectedTeamID="M8G2RFZVFV"
    ;;
evercast)
    name="Evercast"
    type="pkg"
    downloadURL="https://s3.amazonaws.com/files.evercast.us/Evercast.pkg"
    expectedTeamID="H2J9VR2HM2"
    ;;
evernote)
    name="Evernote"
    type="dmg"
    downloadURL="https://mac.desktop.evernote.com/builds/Evernote-latest.dmg"
    appNewVersion=$(curl -s https://evernote.com/release-notes | grep Latest | awk -F '<!-- -->' '{print $2}')
    expectedTeamID="Q79WDW8YH9"
    ;;
everweb)
    name="EverWeb"
    type="dmg"
    downloadURL="https://www.ragesw.com/downloads/everweb/everweb.dmg"
    appNewVersion=$(curl -fs https://www.everwebapp.com/change-log/index.html | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)
    expectedTeamID="A95T4TFRZ2"
    ;;
exelbanstats)
    # credit: Søren Theilgaard (@theilgaard)
    name="Stats"
    type="dmg"
    downloadURL=$(downloadURLFromGit exelban stats)
    appNewVersion=$(versionFromGit exelban stats)
    expectedTeamID="RP2S87B72W"
    ;;
exifrenamer)
    name="ExifRenamer"
    type="dmg"
    downloadURL="https://www.qdev.de/"$(curl -fs "https://www.qdev.de/download.php?file=ExifRenamer.dmg" | grep -o -e "URL=[a-zA-Z/]*.dmg" | cut -d "=" -f2)
    appNewVersion=$(curl -fs "https://www.qdev.de/?location=downloads" | grep -A1 -m1 "ExifRenamer" | tail -1 | cut -d ">" -f2 | cut -d " " -f1)
    expectedTeamID="MLF9FE35AM"
    ;;
expressvpn)
    name="ExpressVPN"
    type="pkg"
    packageID="com.expressvpn.ExpressVPN"
    downloadURL="https://www.expressvpn.com/clients/latest/mac"
    appNewVersion="$(curl -fsIL https://www.expressvpn.com/clients/latest/mac | grep -i ^location | sed -n -e 's/^\(.*\)\(_release\)\(.*\)$/\3\2\1/p' | sed -n -e 's/^.*mac_//p')"
    expectedTeamID="VMES9GFUQJ"
    ;;
facebookmessenger)
    name="Messenger"
    type="dmg"
    downloadURL="https://www.messenger.com/messenger/desktop/downloadV2/?platform=mac"
    appNewVersion=$(curl -I "${downloadURL}" | awk -F': ' '/^location/ {print $2}' | grep -oE 'Messenger.*\.dmg' | sed 's/Messenger\.//;s/\.dmg//')
    expectedTeamID="V9WTTPBFK9"
    ;;
fantastical)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="Fantastical"
    type="zip"
    downloadURL="https://flexibits.com/fantastical/download"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    expectedTeamID="85C27NK92C"
    ;;
fastscripts)
    name="FastScripts"
    type="zip"
    downloadURL=$( curl -fs "https://redsweater.com/fastscripts/appcast3.php" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2 )
    appNewVersion=$( curl -fs "https://redsweater.com/fastscripts/appcast3.php" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2 )
    expectedTeamID="493CVA9A35"
    ;;
favro)
    name="Favro"
    type="dmg"
    downloadURL="https://download.favro.com/FavroDesktop/macOS/x64/$(curl -fs https://download.favro.com/FavroDesktop/macOS/x64/Latest.html | cut -d ">" -f1 | cut -d "=" -f 4 | cut -d '"' -f1)"
    appNewVersion="$(curl -fs https://download.favro.com/FavroDesktop/macOS/x64/Latest.html | cut -d ">" -f1 | cut -d "=" -f 4 | cut -d '"' -f1 | sed -E 's/.*-([0-9.]*)\.dmg/\1/g')"
    expectedTeamID="PUA8Q354ZF"
    ;;
fellow)
    name="Fellow"
    type="dmg"
    downloadURL="https://fellow.app/desktop/download/darwin/latest/"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^location | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' | head -1)"
    expectedTeamID="2NF46HY8D8"
    ;;
figma)
    name="Figma"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.figma.com/mac-arm/Figma.zip"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.figma.com/mac/Figma.zip"
    fi
    appNewVersion="$(getJSONValue "$(curl -fs https://desktop.figma.com/mac/RELEASE.json)" "version")"
    expectedTeamID="T8RA8NE3B7"
    ;;
filemakerpro)
    name="FileMaker Pro"
    type="dmg"
    versionKey="BuildVersion"
    downloadURL=$(curl -fs https://www.filemaker.com/redirects/ss.txt | grep '\"PRO..MAC\"' | tail -1 | sed "s|.*url\":\"\(.*\)\".*|\\1|")
    appNewVersion=$(curl -fs https://www.filemaker.com/redirects/ss.txt | grep '\"PRO..MAC\"' | tail -1 | sed "s|.*fmp_\(.*\).dmg.*|\\1|")
    expectedTeamID="J6K4T76U7W"
    ;;
filezilla)
    name="FileZilla"
    type="bz2"
    packageID="org.filezilla-project.filezilla"
    if [[ $(arch) == "arm64" ]]; then
        cpu_arch="arm64"
    elif [[ $(arch) == "i386" ]]; then
        cpu_arch="x86"
    fi
    downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15" -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macos-$cpu_arch | head -n 1 | awk -F '"' '{print $2}' )
    appNewVersion=$( curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15" -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macos-$cpu_arch | head -n 1 | awk -F '_' '{print $2}' )
    expectedTeamID="5VPGKXL75N"
    blockingProcesses=( NONE )
    ;;
    
finaldraft11)
    name="Final Draft 11"
    type="pkgInZip"
    downloadURL="https://www.finaldraft.com"
    downloadURL+=$(curl -fs "https://www.finaldraft.com/support/install-final-draft/install-final-draft-11-macintosh/" | xmllint --html --format - 2>/dev/null | grep -o "/downloads/finaldraft.*.zip")
    appNewVersion=$(echo $downloadURL | cut -d 't' -f5 | cut -f1 -d "M")
    expectedTeamID="7XUZ8R5736"
    ;;
finaldraft12)
    name="Final Draft 12"
    type="appInDmgInZip"
    downloadURL="https://www.finaldraft.com"
    downloadURL+=$(curl -fs "https://www.finaldraft.com/support/install-final-draft/install-final-draft-12-macintosh/" | xmllint --html --format - 2>/dev/null | grep -o "/downloads/finaldraft.*.zip")
    appNewVersion=$(echo $downloadURL | cut -d 't' -f5 | cut -f1 -d "M")
    expectedTeamID="7XUZ8R5736"
    ;;
finaldraft13)
    #credit to @adamcodega on Slack for helping to fix the curl
    name="Final Draft 13"
    type="appInDmgInZip"
    downloadURL="https://www.finaldraft.com$(curl -fs "https://www.finaldraft.com/support/install-final-draft/install-final-draft-13-macintosh/" | xmllint --html --format - 2>/dev/null | grep -o "/downloads/finaldraft.*.zip" | head -n 1)"
    appNewVersion=$(echo $downloadURL | cut -d 't' -f5 | cut -f1 -d "M")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="7XUZ8R5736"
    ;;
findanyfile)
    name="Find Any File"
    type="zip"
    downloadURL=$(curl -fs "https://findanyfile.app/appcast2.php" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    appNewVersion=$(curl -fs "https://findanyfile.app/appcast2.php" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="25856V4B4X"
    ;;
firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    printlog "WARNING for ERROR: Label firefox and firefox_intl should not be used. Instead use firefoxpkg and firefoxpkg_intl as per recommendations from Firefox. It's not fully certain that the app actually gets updated here. firefoxpkg and firefoxpkg_intl will have built in updates and make sure the client is updated in the future." REQ
    ;;
firefox_da)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=da"
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    printlog "WARNING for ERROR: Label firefox, firefox_da and firefox_intl should not be used. Instead use firefoxpkg and firefoxpkg_intl as per recommendations from Firefox. It's not fully certain that the app actually gets updated here. firefoxpkg and firefoxpkg_intl will have built in updates and make sure the client is updated in the future." REQ
    ;;
firefox_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Firefox
    name="Firefox"
    type="dmg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-')
    printlog "Found language $userLanguage to be used for $name."
    releaseURL="https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    downloadURL="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
        printlog "Download not found for '$userLanguage', using default ('en-US')."
        downloadURL="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx"
    fi
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    printlog "WARNING for ERROR: Label firefox and firefox_intl should not be used. Instead use firefoxpkg and firefoxpkg_intl as per recommendations from Firefox. It's not fully certain that the app actually gets updated here. firefoxpkg and firefoxpkg_intl will have built in updates and make sure the client is updated in the future." REQ
    ;;
firefoxdeveloperedition)
    name="Firefox Developer Edition"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=osx&lang=en-US"
    appNewVersion=$(curl -fsIL "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=osx&lang=en-US&_gl=1*1g4sufp*_ga*OTAwNTc3MjE4LjE2NTM2MDIwODM.*_ga_MQ7767QQQW*MTY1NDcyNTYyNy40LjEuMTY1NDcyNzA2MS4w" | grep -i ^location | cut -d "/" -f7)
    expectedTeamID="43AQ936H96"
    ;;
firefoxesr|\
firefoxesrpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-esr-pkg-latest-ssl&os=osx"
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "FIREFOX_ESR")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefoxesr_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Firefox ESR
    name="Firefox"
    type="dmg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-')
    printlog "Found language $userLanguage to be used for $name."
    releaseURL="https://ftp.mozilla.org/pub/firefox/releases/latest-esr/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    downloadURL="https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=osx&lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
        printlog "Download not found for '$userLanguage', using default ('en-US')."
        downloadURL="https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=osx"
    fi
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    printlog "WARNING for ERROR: Label firefox and firefox_intl should not be used. Instead use firefoxpkg and firefoxpkg_intl as per recommendations from Firefox. It's not fully certain that the app actually gets updated here. firefoxpkg and firefoxpkg_intl will have built in updates and make sure the client is updated in the future." REQ
    ;;
firefoxpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=en-US"
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefoxpkg_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Firefox ESR
    name="Firefox"
    type="pkg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-' | cut -f1 -d"@")
    # userLanguage="sv-SE" #for tests without international language setup
    printlog "Found language $userLanguage to be used for Firefox." WARN
    releaseURL="https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language $userLanguage for download." WARN
    downloadURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=$userLanguage"
    # https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=en-US
    if ! curl -sfL --output /dev/null -r 0-0 "$downloadURL" ; then
        printlog "Download not found for that language. Using en-US" WARN
        downloadURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=en-US"
    fi
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
flexoptixapp)
    name="FLEXOPTIX App"
    type="dmg"
    downloadURL="https://flexbox.reconfigure.me/download/electron/mac/x64/current"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | sed -E 's/.*App-(.*)\.dmg/\1/g')
    expectedTeamID="C5JETSFPHL"
    ;;
flowjo)
    name="FlowJo"
    type="dmg"
    downloadURL="$(curl -fs "https://www.flowjo.com/solutions/flowjo/downloads" | grep -i -o -E "https.*\.dmg")"
    appNewVersion=$(echo "${downloadURL}" | tr "-" "\n" | grep dmg | sed -E 's/([0-9.]*)\.dmg/\1/g')
    expectedTeamID="C79HU5AD9V"
    ;;
flstudiomac)
    name="flstudiomac"
    type="pkgInDmg"
    packageID="com.Image-Line.pkg.flcloud.plugins
com.Image-Line.pkg.24ONLINE"
    downloadURL="https://support.image-line.com/redirect/flstudio_mac_installer"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15" )
    appNewVersion=$(curl -fsL "https://support.image-line.com/api.php?call=get_version_info&callback=il_get_version_info_cb&prod_type=undefined" | \
        sed 's/var get_version_info_res;get_version_info_res = il_get_version_info_cb(//;s/);$//' | \
        sed 's/\\//g' | \
        grep -o '"os":"mac","version":"[0-9.]*"' | \
        sed 's/.*"version":"\([0-9.]*\)".*/\1/')
    expectedTeamID="N68WEP5ZZZ"
    ;;
    
flux)
    name="Flux"
    type="zip"
    appNewVersion=$(curl -fsL "https://justgetflux.com/mac/macflux.xml" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)
    downloadURL="https://justgetflux.com/mac/Flux.zip"
    expectedTeamID="VZKSA7H9J9"
    ;;
flycut)
    name="Flycut"
    type="zip"
    archiveName="Flycut.[0-9.]*.zip"
    downloadURL="$(downloadURLFromGit TermiT Flycut)"
    appNewVersion=$(versionFromGit TermiT Flycut )
    expectedTeamID="S8JLSG5ES7"
;;
fontbase)
    name="FontBase"
    type="dmg"
    appNewVersion=$(curl -s https://releases.fontba.se/mac/latest-mac.yml | grep version: | awk -F ':' '{print $2}' | sed -e 's/^ *//' -e 's/ *$//')
    downloadURL="https://releases.fontba.se/mac/FontBase-$appNewVersion.dmg"
    expectedTeamID="457B89RFCZ"
    ;;
fontexplorer)
    name="FontExplorer X Pro"
    type="dmg"
    packageID="com.linotype.FontExplorerX"
    downloadURL="http://www.fontexplorerx.com/download/free-trial/Mac/"
    appNewVersion=$( curl -fsL http://fex.linotype.com/update/client/mac/pro/version.plist | grep string | tail -n 1 | sed 's/[^0-9.]//g' )
    expectedTeamID="2V7G2B7WG4"
    ;;

fork)
    name="Fork"
    type="dmg"
    downloadURL="$(curl -fs "https://git-fork.com/update/feed.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs "https://git-fork.com/update/feed.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)"
    expectedTeamID="Q6M7LEEA66"
    ;;
franz)
    name="Franz"
    type="dmg"
    if [[ $(arch) = "arm64" ]]; then
        archiveName="Franz-[0-9.]*-arm64.dmg" 
    else 
        archiveName="Franz-[0-9.]*.dmg" 
    fi
    downloadURL="$(downloadURLFromGit meetfranz franz)"
    appNewVersion="$(versionFromGit meetfranz franz)"
    expectedTeamID="TAC9P63ANZ"
    ;;

freeplane)
    name="Freeplane"
    type="dmg"
    appNewVersion=$(curl -fsL "https://sourceforge.net/projects/freeplane/rss?path=/freeplane%20stable/archive" | xpath '//rss/channel/item[1]/title' 2>/dev/null | awk -F'/' '{ print $(NF-2) }')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/freeplane/rss?path=/freeplane%20stable/archive/${appNewVersion}" | grep -oE '<link>(.*-apple.dmg/download)</link>' | tail -1 | sed 's/<link>//;s/<\/link>//')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/freeplane/rss?path=/freeplane%20stable/archive/${appNewVersion}" | grep -oE '<link>(.*-intel.dmg/download)</link>' | tail -1 | sed 's/<link>//;s/<\/link>//')
    fi
    expectedTeamID="CSHVD99Y7K"
    ;;
front)
    name="Front"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.frontapp.com/macos/Front-arm64.dmg"
        appNewVersion=$(curl -fs "https://dl.frontapp.com/desktop/updates/latest/mac-arm64/latest-mac.yml" | grep -i version | cut -d " " -f2)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dl.frontapp.com/macos/Front.dmg"
        appNewVersion=$(curl -fs "https://dl.frontapp.com/desktop/updates/latest/mac/latest-mac.yml" | grep -i version | cut -d " " -f2)
    fi
    expectedTeamID="X549L7572J"
    Company="FrontApp. Inc."
    ;;
fsmonitor)
    name="FSMonitor"
    type="zip"
    downloadURL=$(curl -fsL "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath 'string(//rss/channel/item[last()]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(curl -fsL "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="V85GBYB7B9"
    ;;
fujifilmwebcam)
     name="FUJIFILM X Webcam 2"
     type="pkg"
     downloadURL=$(curl -fs "https://fujifilm-x.com/en-us/support/download/software/x-webcam/" | grep "https.*pkg" | sed -E 's/.*(https:\/\/dl.fujifilm-x\.com\/support\/software\/.*\.pkg[^\<]).*/\1/g' | sed -e 's/^"//' -e 's/"$//')
     appNewVersion=$( echo “${downloadURL}” | sed -E 's/.*XWebcamIns([0-9]*).*/\1/g' | sed -E 's/([0-9])([0-9]).*/\1\.\2/g')
     expectedTeamID="34LRP8AV2M"
     ;;
garminexpress)
    name="Garmin Express"
    blockingProcesses=( "Garmin Express" "Garmin Express Service" )
    type="pkgInDmg"
    downloadURL="https://download.garmin.com/omt/express/GarminExpress.dmg"
    garminfaqURL=$(curl -sf https://support.garmin.com/capi/content/en-US/\?productID\=168768\&tab\=software\&topicTag\=region_softwareproduct\&productTagName\=topic_express0\&ct\=content\&mr\=5\&locale\=en-US\&si\=0\&tags\=topic_express0%2Cregion_softwareproduct%2C%2C | tr "{" "\n" | grep "Garmin Express" | tr "," "\n" | grep "contentURL" | awk -F "\"" '{print$4}')
    appNewVersion="$(curl -sfL $garminfaqURL | tr '><' "\n" | grep "Garmin Express for Mac" | head -1 | awk 'sub(/.*Mac: */,""){f=1} f{if ( sub(/ *as of.*/,"") ) f=0; print}').0"
    expectedTeamID="72ES32VZUA"
    ;;
gather|\
gathertown)
    name="Gather"
    type="dmg"
    appNewVersion="$(versionFromGit gathertown gather-town-desktop-releases)"
    downloadURL="$(downloadURLFromGit gathertown gather-town-desktop-releases)"
    archiveName="Gather-${appNewVersion}-universal.dmg"
    expectedTeamID="69MCJ5CRDW"
    ;;

gdevelop)
    name="GDevelop 5"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="GDevelop-5-[0-9.]*-arm64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="GDevelop-5-[0-9.]*.dmg" 
    fi
    appNewVersion="$(versionFromGit 4ian GDevelop)"
    downloadURL="$(downloadURLFromGit 4ian GDevelop)"
    expectedTeamID="5CG65LEVUK"
    ;;
geneiousprime)
    name="Geneious Prime"
    type="dmg"
    downloadURL="https://assets.geneious.com/installers/geneious/release/latest/Geneious_Prime_mac64_with_jre.dmg"
    appNewVersion=""
    expectedTeamID="3BTDDQD3L6"
    ;;
gephi)
	# An open-source software that visualizes and manipulates large graphs with ease, featuring a user-friendly interface and powerful real-time capabilities
    name="Gephi"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="gephi-[0-9.]*-macos-aarch64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="gephi-[0-9.]*-macos-x64.dmg"
    fi
    appNewVersion="$(versionFromGit gephi gephi)"
    downloadURL="$(downloadURLFromGit gephi gephi)"
    expectedTeamID="3D8H75J8UL"
    ;;
gfxcardstatus)
    name="gfxCardStatus"
    type="zip"
    downloadURL="$(downloadURLFromGit codykrieger gfxCardStatus)"
    appNewVersion="$(versionFromGit codykrieger gfxCardStatus)"
    expectedTeamID="LF22FTQC25"
    ;;
gimp)
    name="GIMP"
    type="dmg"
    gimpDetails="$(curl -fs "https://www.gimp.org/gimp_versions.json")"
    appNewVersion="$(getJSONValue "$gimpDetails" "STABLE[0].version")"
    dlVersion="$(echo "${appNewVersion}" | cut -d'.' -f1-2)"
    [[ "$(getJSONValue "$gimpDetails" "STABLE[0].macos[0].filename")" == *"x86_64"* ]] && gimpDmgx86_64="$(getJSONValue "$gimpDetails" "STABLE[0].macos[0].filename")" && gimpDmgArm64="$(getJSONValue "$gimpDetails" "STABLE[0].macos[1].filename")"
    [[ "$(getJSONValue "$gimpDetails" "STABLE[0].macos[0].filename")" == *"arm64"* ]] && gimpDmgArm64="$(getJSONValue "$gimpDetails" "STABLE[0].macos[0].filename")" && gimpDmgx86_64="$(getJSONValue "$gimpDetails" "STABLE[0].macos[1].filename")"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.gimp.org/gimp/v${dlVersion}/macos/${gimpDmgArm64}"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.gimp.org/gimp/v${dlVersion}/macos/${gimpDmgx86_64}"
    fi
    expectedTeamID="T25BQ8HSJF"
    ;;
gimpdev)
    name="GIMP"
    type="dmg"
    gimpDetails="$(curl -fs "https://www.gimp.org/gimp_versions.json")"
    appNewVersion="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].version")"
    dlVersion="$(echo "${appNewVersion}" | cut -d'.' -f1-2)"
    [[ "$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" == *"x86_64"* ]] && gimpDmgx86_64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" && gimpDmgArm64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[1].filename")"
    [[ "$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" == *"arm64"* ]] && gimpDmgArm64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" && gimpDmgx86_64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[1].filename")"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.gimp.org/gimp/v${dlVersion}/macos/${gimpDmgArm64}"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.gimp.org/gimp/v${dlVersion}/macos/${gimpDmgx86_64}"
    fi
    expectedTeamID="T25BQ8HSJF"
    ;;
githubcopilotforxcode)
    name="GitHub Copilot for Xcode"
    type="dmg"
    downloadURL="$(downloadURLFromGit github CopilotForXcode)"
    appNewVersion="$(versionFromGit github CopilotForXcode)"
    expectedTeamID="VEKTX9H2N7"
    blockingProcesses=( "GitHub Copilot for Xcode" "GitHub Copilot for Xcode Extension" "Copilot" )
    ;;
githubdesktop)
    name="GitHub Desktop"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://central.github.com/deployments/desktop/desktop/latest/darwin-arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://central.github.com/deployments/desktop/desktop/latest/darwin"
    fi
    appNewVersion=$(curl -fsL https://central.github.com/deployments/desktop/desktop/changelog.json | awk -F '{' '/"version"/ { print $2 }' | sed -E 's/.*,\"version\":\"([0-9.]*)\".*/\1/g')
    expectedTeamID="VEKTX9H2N7"
    ;;
gitkraken)
    name="gitkraken"
    type="dmg"
    appNewVersion=$( curl -sfL https://www.gitkraken.com/download | grep -o 'Latest release: [0-9.]*' | grep -o '[0-9.]*' )
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://release.gitkraken.com/darwin-arm64/installGitKraken.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://release.gitkraken.com/darwin/installGitKraken.dmg"
    fi
    expectedTeamID="T7QVVUTZQ8"
    blockingProcesses=( "GitKraken" )
    ;;
glpiagent)
    name="GLPI-agent"
    type="pkg"
    packageID="com.teclib.glpi-agent"
    appNewVersion="$(versionFromGit glpi-project glpi-agent)"
    downloadURL="https://github.com/glpi-project/glpi-agent/releases/download/${appNewVersion}/GLPI-Agent-${appNewVersion}_"$(uname -m)".pkg"
    versionKey="CFBundleShortVersionString"  
    expectedTeamID="H7XJV96LX2"
    blockingProcesses=( NONE )
    ;;
glyphs3)
    name="Glyphs 3"
    type="zip"
    downloadURL="https://updates.glyphsapp.com/latest3.php"
    appNewVersion=$(curl -fsIL $downloadURL | sed -nE 's/content-disp.*Glyphs([^-]*).*/\1/p')
    versionKey="CFBundleShortVersionString"
    expectedTeamID="X2L8375ZQ7"
    ;;
golang)
    name="GoLang"
    type="pkg"
    packageID="org.golang.go"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "darwin-arm" | tr '"' '\n' | grep "pkg")"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "darwin-amd" | tr '"' '\n' | grep "pkg")"
    fi
    appNewVersion="$( echo "${downloadURL}" | sed -E 's/.*\/(go[0-9.]*)\..*/\1/g' )" # Version includes letters "go" in the beginning
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( NONE )
    ;;
googleadseditor)
    name="Google Ads Editor"
    type="dmg"
    downloadURL="https://dl.google.com/adwords_editor/google_ads_editor.dmg"
    appNewVersion="$(curl -s "https://support.google.com/google-ads/editor/topic/13728" | grep -E -o "Google Ads Editor version.{1,4}" | head -1 | tail -c 4)"
    appCustomVersion(){cat /Applications/Google\ Ads\ Editor.app/Contents/Versions/*/Google\ Ads\ Editor.app/Contents/locale/content/welcome1/welcome1-en-US.htm | grep -o -E " about version.{0,4}" | tail -c 4}
    expectedTeamID="EQHXZ8M8AV"
    ;;
googlechrome)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
    appNewVersion=$(getJSONValue "$(curl -s "https://chromiumdash.appspot.com/fetch_releases?platform=Mac&channel=Stable&num=1")" "[0].version")
    expectedTeamID="EQHXZ8M8AV"
    printlog "WARNING for ERROR: Label googlechrome should not be used. Instead use googlechromepkg as per recommendations from Google. It's not fully certain that the app actually gets updated here. googlechromepkg will have built in updates and make sure the client is updated in the future." REQ
    ;;
googlechromeenterprise)
    name="Google Chrome"
    type="pkg"
    downloadURL="https://dl.google.com/dl/chrome/mac/universal/stable/gcem/GoogleChrome.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=fraction>0.01,endtime=none&order_by=version%20desc" )" "releases[0].version" )
    expectedTeamID="EQHXZ8M8AV"
    updateTool="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent"
    updateToolArguments=( -runMode oneshot -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;
googlechromepkg)
    name="Google Chrome"
    type="pkg"
    #
    # Note: this url acknowledges that you accept the terms of service
    # https://support.google.com/chrome/a/answer/9915669
    #
    downloadURL="https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=fraction%3E0.01,endtime=none&order_by=version%20desc" )" "releases[0].version" )
    expectedTeamID="EQHXZ8M8AV"
    updateTool="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent"
    updateToolArguments=( -runMode oneshot -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;
googledrive|\
googledrivefilestream)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Google Drive File Stream"
    type="pkgInDmg"
    if [[ $(arch) == "arm64" ]]; then
       packageID="com.google.drivefs.arm64"
    elif [[ $(arch) == "i386" ]]; then
       packageID="com.google.drivefs.x86_64"
    fi
    appNewVersion=$(curl -s "https://community.chocolatey.org/packages/googledrive" | xmllint --html --xpath 'substring-after(string(//h1[@class="mb-0 text-center"]), "Google Drive")' - 2> /dev/null)
    downloadURL="https://dl.google.com/drive-file-stream/GoogleDriveFileStream.dmg" # downloadURL="https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
    blockingProcesses=( "Google Docs" "Google Drive" "Google Sheets" "Google Slides" )
    appName="Google Drive.app"
    expectedTeamID="EQHXZ8M8AV"
    ;;
googledrivebackupandsync)
    name="Backup and Sync"
    type="dmg"
    downloadURL="https://dl.google.com/drive/InstallBackupAndSync.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
googleearth)
    name="Google Earth Pro"
    type="pkgInDmg"
    downloadURL="https://dl.google.com/earth/client/advanced/current/GoogleEarthProMac-Intel.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
googlejapaneseinput)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="GoogleJapaneseInput"
    type="pkgInDmg"
    pkgName="GoogleJapaneseInput.pkg"
    downloadURL="https://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg"
    blockingProcesses=( NONE )
    expectedTeamID="EQHXZ8M8AV"
    ;;
googlesoftwareupdate)
    name="Install Google Software Update"
    type="pkgInDmg"
    pkgName="Install Google Software Update.app/Contents/Resources/GSUInstall.pkg"
    downloadURL="https://dl.google.com/mac/install/googlesoftwareupdate.dmg"
    blockingProcesses=( NONE )
    expectedTeamID="EQHXZ8M8AV"
    ;;
gosign)
    name="GoSign-Desktop"
    type="dmg"
    downloadURL="https://rinnovofirma.infocert.it/gosign/download/darwin/latest/"
    expectedTeamID="QC25859FX9"
    ;;
gotiengviet)
    name="GoTiengViet"
    type="dmg"
    downloadURL="https://www.trankynam.com/gotv/downloads/GoTiengViet.dmg"
    appNewVersion=""
    expectedTeamID="KHEMQ2FD9E"
    ;;
gotomeeting)
    # credit: @matins
    name="GoToMeeting"
    type="dmg"
    downloadURL="https://link.gotomeeting.com/latest-dmg"
    expectedTeamID="GFNFVT632V"
    ;;
gotowebinar)
    name="GoTo"
    type="dmg"
    downloadURL="https://goto-desktop.goto.com/GoTo-arm64.dmg"
    appNewVersion=""
    expectedTeamID="GFNFVT632V"
    ;;
gpgsuite)
    # credit: Micah Lee (@micahflee)
    name="GPG Suite"
    type="pkgInDmg"
    pkgName="Install.pkg"
    downloadURL=$(curl -s https://gpgtools.com/ | grep https://releases.gpgtools.com/GPG_Suite- | grep Download | cut -d'"' -f4)
    appNewVersion=$(echo $downloadURL | cut -d "-" -f 2 | cut -d "." -f 1-2)
    expectedTeamID="PKV8ZPD836"
    blockingProcesses=( "GPG Keychain" )
    appCustomVersion(){ defaults read /Library/Application\ Support/GPGTools/version.plist CFBundleShortVersionString }
    ;;
gpgsync)
    name="GPG Sync"
    type="pkg"
    packageID="org.firstlook.gpgsync"
    downloadURL="$(downloadURLFromGit firstlookmedia gpgsync)"
    appNewVersion="$(versionFromGit firstlookmedia gpgsync)"
    expectedTeamID="P24U45L8P5"
    ;;
grammarly)
     name="Grammarly Desktop"
     type="dmg"
     packageID="com.grammarly.ProjectLlama"
     downloadURL="https://download-mac.grammarly.com/Grammarly.dmg"
     expectedTeamID="W8F64X92K3"
     # appName="Grammarly Installer.app"
     installerTool="Grammarly Installer.app"
     CLIInstaller="Grammarly Installer.app/Contents/MacOS/Grammarly Desktop"
;;
grandperspective)
    name="GrandPerspective"
    type="dmg"
    downloadURL="https://sourceforge.net/projects/grandperspectiv/files/latest/download"
    appNewVersion=$(curl -fs https://sourceforge.net/projects/grandperspectiv/files/grandperspective/ | grep -B 2 'Download Latest Version' | grep -oE '\/(\d|\.)+\/' | sed 's/\///g')
    expectedTeamID="3Z75QZGN66"
    ;;
graphicconverter10)
    name="GraphicConverter 10"
    type="zip"
    downloadURL=$(curl -fs "https://www.lemkesoft.info/sparkle/graphicconverter/graphicconverter10.xml" | grep -i 'enclosure url=' | grep -m 1 ".zip" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.lemkesoft.info/sparkle/graphicconverter/graphicconverter10.xml" | grep -i 'enclosure url=' | grep -m 1 ".zip" | cut -d '"' -f 6 | sed 's/.*"\(.*\)".*/\1/')
    expectedTeamID="FAVZJT8J4U"
    versionKey="CFBundleShortVersionString"
    ;;
grasshopper)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Grasshopper"
    type="dmg"
    downloadURL="https://dl.grasshopper.com/Grasshopper.dmg"
    pkgName="Grasshopper.dmg"
    expectedTeamID="KD6L2PTK2Q"
    ;;
grooveomnidialerenterpriseedition)
	name="Groove Omnidialer Enterprise Edition"
	type="zip"
	appNewVersion=$( curl -fs 'https://groove-dialer.s3.us-west-2.amazonaws.com/electron/enterprise/latest-mac.yml' | grep ^version: | cut -c 10-21 ) 
	downloadURL="https://groove-dialer.s3.us-west-2.amazonaws.com/electron/enterprise/Groove+OmniDialer+Enterprise+Edition-"$appNewVersion"-universal-mac.zip" 
	expectedTeamID="ZDYDJ5XPF3"
;;
guardianbrowser)
	# A privacy-focused web browser designed to enhance security with built-in ad blocking, tracker protection, and encrypted browsing
    name="Guardian Browser"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://production-archimedes-secure-browser-artifacts.s3.amazonaws.com/latest/mac-x64/guardian-browser-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://production-archimedes-secure-browser-artifacts.s3.amazonaws.com/latest/mac-arm64/guardian-browser-arm64.dmg"
    fi
    expectedTeamID="7TCATJSU2Y"
    ;;
gyazo)
    # credit: @matins
    name="Gyazo"
    type="dmg"
    appNewVersion=$(curl -is "https://formulae.brew.sh/cask/gyazo" | grep 'Current version:' | grep -o "Gyazo.*dmg" | cut -d "-" -f 2 | awk -F ".dmg" '{print $1}')
    downloadURL="https://files.gyazo.com/setup/Gyazo-${appNewVersion}.dmg"
    expectedTeamID="9647Y3B7A4"
    ;;
gyazogif)
    # credit: @matins
    # This is identical to gyazo, but the download contains two apps on the DMG
    name="Gyazo GIF"
    type="dmg"
    appNewVersion=$(curl -is "https://formulae.brew.sh/cask/gyazo" | grep 'Current version:' | grep -o "Gyazo.*dmg" | cut -d "-" -f 2 | awk -F ".dmg" '{print $1}')
    downloadURL="https://files.gyazo.com/setup/Gyazo-${appNewVersion}.dmg"
    expectedTeamID="9647Y3B7A4"
    ;;
hancock)
    # Credit: Bilal Habib @Pro4TLZZZ
    name="Hancock"
    type="dmg"
    downloadURL=$(downloadURLFromGit JeremyAgost Hancock )
    appNewVersion=$(versionFromGit JeremyAgost Hancock )
    expectedTeamID="SWD2B88S58"
    ;;
handbrake)
    name="HandBrake"
    type="dmg"
    downloadURL=$(downloadURLFromGit HandBrake HandBrake )
    appNewVersion=$(versionFromGit HandBrake HandBrake )
    expectedTeamID="5X9DE89KYV"
    ;;
perimeter81|\
harmonysase)
    name="Harmony SASE"
    #name="Perimeter 81"
    type="pkg"
    pkgURL=$(curl -sL https://support.perimeter81.com/docs/downloading-the-agent | grep -o 'Harmony[^"]*.pkg')
    downloadURL="https://static.perimeter81.com/agents/mac/$pkgURL"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^x-amz-meta-version | sed -E 's/x-amz-meta-version: //' | cut -d"." -f1-3)"
    expectedTeamID="924635PD62"
    ;;
hazel)
    # credit: Søren Theilgaard (@theilgaard)
    name="Hazel"
    type="dmg"
    downloadURL=$(curl -fsI https://www.noodlesoft.com/Products/Hazel/download | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')
    appNewVersion=$(curl -fsI https://www.noodlesoft.com/Products/Hazel/download | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="86Z3GCJ4MF"
    ;;
hmavpn)
name="HMA-VPN"
type="pkgInDmg"
packageID="com.privax.osx.provpn"
downloadURL="https://s-mac-sl.avcdn.net/macosx/privax/HMA-VPN.dmg"
appNewVersion=""
expectedTeamID="96HLSU34RN"
;;
homebrew)
    name="Homebrew"
    type="pkg"
    packageID="sh.brew.homebrew"
    downloadURL="$(downloadURLFromGit Homebrew brew)"
    appNewVersion="$(versionFromGit Homebrew brew)"
    expectedTeamID="927JGANW46"
    archiveName="Homebrew.pkg"
    ;;
hoppscotch)
    name="Hoppscotch"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="Hoppscotch_mac_aarch64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="Hoppscotch_mac_x64.dmg" 
    fi
    downloadURL="$(downloadURLFromGit hoppscotch releases)"
    appNewVersion="$(versionFromGit hoppscotch releases)"
    expectedTeamID="XBK86CMQGZ"
    ;;
horos)
    name="Horos"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    if [[ $(arch) == "arm64" ]]; then
    	imageName=$(curl -fs https://horosproject.org/horos-content/ | grep "arm64" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|")
        downloadURL="https://horosproject.org/horos-content/"$imageName""
        appNewVersion=$(curl -fs https://horosproject.org/horos-content/ | grep "arm64" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|" | sed -e 's/.*_\(.*\)_.*/\1/')
    elif [[ $(arch) == "i386" ]]; then
    	imageName=$(curl -fs https://horosproject.org/horos-content/ | grep -v -e "Apple" -e "arm64" -e "Nightly" | grep ".dmg" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|")
        downloadURL="https://horosproject.org/horos-content/"$imageName""
        appNewVersion=$(curl -fs https://horosproject.org/horos-content/ | grep -v -e "Apple" -e "arm64" -e "Nightly" | grep ".dmg" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|" | sed -e 's/.*Horos\(.*\).dmg.*/\1/')
    fi
    expectedTeamID="TPT6TVH8UY"
    ;;
hot)
    name="Hot"
    type="zip"
    downloadURL="$(downloadURLFromGit macmade Hot)"
    appNewVersion="$(versionFromGit macmade Hot)"
    expectedTeamID="326Y53CJMD"
    ;;
houdahspot)
    name="HoudahSpot"
    type="zip"
    downloadURL="$(curl -fs https://www.houdah.com/houdahSpot/updates/cast6.php | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs https://www.houdah.com/houdahSpot/updates/cast6.php | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    expectedTeamID="DKGQD8H8ZY"
    ;;
hpeasyadmin)
    # credit: Søren Theilgaard (@theilgaard)
    name="HP Easy Admin"
    type="zip"
    downloadURL="https://ftp.hp.com/pub/softlib/software12/HP_Quick_Start/osx/Applications/HP_Easy_Admin.app.zip"
    expectedTeamID="6HB5Y2QTA3"
    ;;
hpeasystart)
    name="HP Easy Start"
    type="zip"
    downloadURL="https://ftp.hp.com/pub/softlib/software12/HP_Quick_Start/osx/HP_Easy_Start/HP_Easy_Start.app.zip"
    expectedTeamID="6HB5Y2QTA3"
    ;;
hubstaff)
    name="Hubstaff"
    type="dmg"
    downloadURL="https://app.hubstaff.com/download/osx"
    appNewVersion=""
    expectedTeamID="24BCJT3JW2"
    ;;
huddly)
    name="Huddly"
    type="dmg"
    downloadURL="https://app.huddly.com/download/latest/osx"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i '^content-disposition' | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/g')"
    expectedTeamID="J659R47HZT"
    ;;
hype)
    name="Hype4"
    type="dmg"
    packageID="com.tumult.Hype4"
    downloadURL="https://static.tumult.com/hype/download/Hype.dmg"
    appNewVersion=$( curl -fsL https://tumult.com/hype/download/all/ | grep Ongoing | awk -F '<' '{print $4}' | sed 's/[^0-9.]//g' )
    expectedTeamID="8J356DM772"
    blockingProcesses=( NONE )
    ;;
hyper)
    name="Hyper"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      archiveName="mac-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
      archiveName="mac-arm64.dmg"
    fi
    downloadURL=$(downloadURLFromGit vercel hyper )
    appNewVersion=$(versionFromGit vercel hyper)
    expectedTeamID="JW6Y669B67"
    ;;
i1profiler)
    name="i1Profiler"
    type="pkgInZip"
    downloadURL=$(curl -fs "https://downloads.xrite.com/downloads/autoupdate/i1profiler_mac_appcast.xml" | xmllint --xpath '//rss/channel/item[1]/enclosure/@url' - | sed -E 's/.*url="([^"]+)".*/\1/')
    appNewVersion=$(curl -fs "https://downloads.xrite.com/downloads/autoupdate/i1profiler_mac_appcast.xml" | xmllint --xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' - | sed -E 's/.*shortVersionString="([^"]+)".*/\1/')
    expectedTeamID="2K7GT73B4R"
    ;;
ibarcoder)
    name="iBarcoder"
    type="dmg"
    downloadURL="https://cristallight.com/Downloads/mac/ibarcoder.dmg"
    appNewVersion="$(curl -fs "https://cristallight.com/iBarcoder/" | grep -i version: | head -1 | awk '{print $2}')"
    expectedTeamID="JAXVB9AH9M"
    ;;
ibmnotifier)
    name="IBM Notifier"
    type="zip"
    downloadURL="$(downloadURLFromGit IBM mac-ibm-notifications)"
    #appNewVersion="$(versionFromGit IBM mac-ibm-notifications)"
    appNewVersion="$(curl -sLI "https://github.com/IBM/mac-ibm-notifications/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | cut -d "-" -f2 | sed 's/[^0-9\.]//g')"
    expectedTeamID="PETKK2G752"
    ;;
ice)
	# A versatile macOS menu bar management tool that allows users to hide, show, and rearrange menu bar items
    name="Ice"
    type="zip"
    downloadURL="$(downloadURLFromGit jordanbaird Ice)"
    appNewVersion="$(versionFromGit jordanbaird Ice)"
    expectedTeamID="K2ATHQPJDP"
    ;;
icons)
    name="Icons"
    type="pkg"
    downloadURL=$(downloadURLFromGit SAP macOS-icon-generator )
    appNewVersion=$(versionFromGit SAP macOS-icon-generator )
    expectedTeamID="7R5ZEU67FQ"
    ;;
idrive)
    name="IDrive"
    type="pkgInDmg"
    pkgName="IDrive.pkg"
    downloadURL=$(curl -fs https://static.idriveonlinebackup.com/downloads/version_mac.js | tr -d '\n\t' | sed -E 's/.*(https.*dmg).*/\1/g')
    appNewVersion=$(curl -fs https://static.idriveonlinebackup.com/downloads/version_mac.js | tr -d '\n\t' | sed -E 's/.*mac_vernum\=\"Version\ ([0-9.]*).*/\1/g')
    versionKey="CFBundleVersion"
    expectedTeamID="JWDCNYZ922"
    blockingProcesses=( NONE )
    ;;
idrivethin)
    name="IDrive"
    type="pkgInDmg"
    pkgName="IDriveThin.pkg"
    downloadURL=$(curl -fs https://static.idriveonlinebackup.com/downloads/idrivethin/thin_version.js | tr -d '\n\t' | sed -E 's/.*thinclient-mac([^;]*).*/\1/g' | sed -E 's/.*(https.*dmg).*/\1/g')
    appNewVersion=$(curl -fs https://static.idriveonlinebackup.com/downloads/idrivethin/thin_version.js | tr -d '\n\t' | sed -E 's/.*thin\_mac\_ver\=\"Version\ ([0-9.]*).*/\1/g')
    versionKey="CFBundleVersion"
    expectedTeamID="JWDCNYZ922"
    blockingProcesses=( NONE )
    ;;
igv)
    name="IGV"
    type="zip"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="$(curl -fs "https://igv.org/doc/desktop/DownloadPage/" | grep -m1 -oE "https://data.broadinstitute.org/igv/projects/downloads/.*/IGV_MacApp_.*_WithJava\.zip")"
        appNewVersion="$(echo $downloadURL | sed -E 's/.*IGV_MacApp_([0-9]+(\.[0-9]+)*).*/\1/')"
    else
        downloadURL="$(curl -fs "https://igv.org/doc/desktop/DownloadPage/" | grep -m1 -oE "https://data.broadinstitute.org/igv/projects/downloads/.*/IGV_MacAppIntel_.*_WithJava\.zip")"
        appNewVersion="$(echo $downloadURL | sed -E 's/.*IGV_MacAppIntel_([0-9]+(\.[0-9]+)*).*/\1/')"
    fi
    appName="${name}_${appNewVersion}.app"
    expectedTeamID="R787A9V6VV"
    ;;

iina)
    name="IINA"
    type="dmg"
    downloadURL=$(downloadURLFromGit iina iina )
    appNewVersion=$(versionFromGit iina iina )
    expectedTeamID="67CQ77V27R"
    ;;
ikproductmanager)
    name="IK Product Manager"
    type="pkgInDmg"
    curlOptions=( -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Referer: https://www.ikmultimedia.com/" -H "Sec-Fetch-Dest: document" )
    appNewVersion=$(curl -s 'https://www.ikmultimedia.com/am2/?' -H 'Host: www.ikmultimedia.com'| grep client_latest_version | cut -d\" -f2 | head -1)
    downloadURL="https://g1.ikmultimedia.com/plugins/ProductManager/ik_product_manager_${appNewVersion}.dmg"
    expectedTeamID="S78FW55573"
    ;;
imageoptim)
    name="imageoptim"
    type="tbz"
    packageID="net.pornel.ImageOptim"
    downloadURL="https://imageoptim.com/ImageOptim.tbz2"
    appNewVersion=$( curl -fsL https://imageoptim.com/appcast.xml | grep "title" | tail -n 1 | sed 's/[^0-9.]//g' )
    expectedTeamID="59KZTZA4XR"
    blockingProcesses=( NONE )
    ;;
imazingprofileeditor)
    # Credit: Bilal Habib @Pro4TLZZ
    name="iMazing Profile Editor"
    type="dmg"
    downloadURL="https://downloads.imazing.com/mac/iMazing-Profile-Editor/iMazingProfileEditorMac.dmg"
    appNewVersion=$(curl -s https://imazing.com/profile-editor/download | grep -2 'Version' | head -4 | sed -nE 's/.*<b>([0-9\.]+)<\/b>.*/\1/p' )
    expectedTeamID="J5PR93692Y"
    ;;
inetclearreportsdesigner)
    name="i-Net Clear Reports Designer"
    type="appindmg"
    appNewVersion=$(curl -s https://www.inetsoftware.de/products/clear-reports/designer | grep "Latest release:" | cut -d ">" -f 4 | cut -d \  -f 2)
    downloadURL=$(curl -s https://www.inetsoftware.de/products/clear-reports/designer | grep $appNewVersion | grep dmg | cut -d ">" -f 12 | cut -d \" -f 2)
    expectedTeamID="9S2Y97K3D9"
    blockingProcesses=( "clear-reports-designer" )
    #forcefulQuit=YES
    ;;
inkscape)
    name="Inkscape"
    type="dmg"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    appNewVersion=$(curl -fsL https://inkscape.org/release/  | grep "<title>" | grep -o -e "[0-9.]*")
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://media.inkscape.org/dl/resources/file/$(curl -fsL https://inkscape.org/release/inkscape-{$appNewVersion}/mac-os-x/dmg-arm64/dl/ | grep -o -m1 "Inkscape-.*.dmg")"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://media.inkscape.org/dl/resources/file/$(curl -fsL https://inkscape.org/release/inkscape-{$appNewVersion}/mac-os-x/dmg/dl/ | grep -o -m1 "Inkscape-.*.dmg")"
    fi
    expectedTeamID="SW3D6BB6A6"
    ;;
inmusicsoftwarecenter)
    name="inMusic Software Center"
    type="zip"
    appNewVersion="$(curl -fs https://imb-software-center.s3.amazonaws.com/release/darwin/version.json | grep currentRelease | cut -d: -f2 | cut -d\" -f2 | xargs)"
    downloadURL="https://inmusic.to/ISCMAC"
    expectedTeamID="NDEA34327T"
    ;;
insomnia)
    name="Insomnia"
    type="dmg"
    #downloadURL=$(downloadURLFromGit kong insomnia)
    downloadURL=$(curl -fs "https://updates.insomnia.rest/downloads/mac/latest?app=com.insomnia.app&source=website" | grep -o "https.*\.dmg")
    #appNewVersion=$(versionFromGit kong insomnia)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\/Insomnia.Core.([0-9.]*)\.dmg/\1/')
    expectedTeamID="FX44YY62GV"
    ;;
installomator|\
installomator_theile)
    name="Installomator"
    type="pkg"
    packageID="com.scriptingosx.Installomator"
    downloadURL=$(downloadURLFromGit Installomator Installomator )
    appNewVersion=$(versionFromGit Installomator Installomator )
    expectedTeamID="JME5BW3F3R"
    blockingProcesses=( NONE )
    ;;
installomatormate)
	name="InstallomatorMate"
	type="zip"
	downloadURL="https://hennig.nu/repo/installomatormate/InstallomatorMate.zip"
    appNewVersion=$( curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs https://hennig.nu/repo/installomatormate/appcast.xml | sed -n 's/.*<sparkle:shortVersionString>\(.*\)<\/sparkle:shortVersionString>.*/\1/p' | head -1 )
	expectedTeamID="AGXG97HK25"
	;;
ipswupdater)
    name="IPSW Updater"
    type="zip"
    ipswupdaterVersions=$(curl -fs "https://ipsw.app/download/updates.php?current_version=0.9.16")
    downloadURL=$(getJSONValue "$ipswupdaterVersions" "[0].url")
    appNewVersion=$(getJSONValue "$ipswupdaterVersions" "[0].version")
    expectedTeamID="YRW6NUGA63"
    ;;
ipvisionconnect)
    name="ipvision Connect"
    type="dmg"
    # Description: A softphone client from ipvision.dk
    downloadStore="https://my.ipvision.dk/connect/"
    downloadURL="${downloadStore}$(curl -fs "https://my.ipvision.dk/connect/" | grep osx | sort | tail -1 | cut -d '"' -f2)"
    appNewVersion="$(curl -fs "${downloadStore}" | grep osx | sort | tail -1 | sed -E 's/.*ipvision_connect_([0-9_]*)_osx.*/\1/' | tr "_" ".")"
    expectedTeamID="5RLWBLKGL2"
    ;;
iriunwebcam)
    name="IriunWebcam"
    type="pkg"
    packageID="com.iriun.pkg.multicam"
    downloadURL="$(curl -sf "https://iriun.com" | grep "Webcam for Mac" | awk -F '"' '{ print $4; }')"
    appNewVersion="$( echo "$downloadURL" | cut -d '-' -f 2 | sed -e 's/.pkg//' )"
    expectedTeamID="R84MX49LQY"
    ;;
isadora)
    name="Isadora"
    type="pkgInDmg"
    packageID="com.troikatronix.isadora-fat-std-installer"
    expectedTeamID="Q5V96MD6S6"
    siteURL="https://troikatronix.com"
    downloadURL="$siteURL/$(curl -s "$siteURL/get-it/" | tr '"' '\n' | grep -m1 dmg)"
    # This will have issues if they go past 9 in any part of the version, but hopefully
    #   by then they might have provided a better way to collect the current version.
    URLversion="$( echo "$downloadURL" | cut -d '-' -f 2 | cut -d 'f' -f 1 )"
    appNewVersion="${URLversion[1]}.${URLversion[2]}.${URLversion[3]}"
    ;;
island)
    name="Island"
    type="dmg"
    downloadURL="https://d3qqq7lqx3rf23.internal.island.io/E5QCaudFDx5FE5OX4INk/stable/latest/mac/IslandX64.dmg"
    appCustomVersion() { echo "$(defaults read /Applications/Island.app/Contents/Info.plist CFBundleShortVersionString | sed 's/[^.]*.//' | sed -e 's/*\.//')" }
    appNewVersion=$(curl -fsLIXGET "https://d3qqq7lqx3rf23.internal.island.io/E5QCaudFDx5FE5OX4INk/stable/latest/mac/IslandX64.dmg" | grep -i "^x-amz-meta-version" | sed -e 's/x-amz-meta-version\: //' | tr -d '\r')
    expectedTeamID="38ZC4T8AWY"
    ;;
istatmenus)
    # credit: AP Orlebeke (@apizz)
    name="iStat Menus"
    type="zip"
    downloadURL="https://download.bjango.com/istatmenus/"
    expectedTeamID="Y93TK974AT"
    appNewVersion=$(curl -fs https://bjango.com/mac/istatmenus/versionhistory/ | grep "<h3>" | head -1 | sed -E 's/<h3>([0-9.]*)<\/h3>/\1/')
    blockingProcesses=( "iStat Menus" "iStatMenusAgent" "iStat Menus Status" )
    ;;
iterm2)
    name="iTerm"
    type="zip"
    downloadURL="https://iterm2.com/downloads/stable/latest"
    appNewVersion=$(curl -is https://iterm2.com/downloads/stable/latest | grep location: | grep -o "iTerm2.*zip" | cut -d "-" -f 2 | cut -d '.' -f1 | sed 's/_/./g')
    expectedTeamID="H7V7XYVQ7D"
    ;;
itsycal|\
mowgliiitsycal)
    name="Itsycal"
    type="zip"
    downloadURL=$(curl -fs https://s3.amazonaws.com/itsycal/itsycal.xml | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://s3.amazonaws.com/itsycal/itsycal.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    expectedTeamID="HFT3T55WND"
    ;;
izotopeproductportal)
    name="iZotope Product Portal"
    type="dmg"
    izotopeDetails="$(curl -fs 'https://productportal.izotope.com/api/productupdate' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 14_6_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.72 ProductPortal/1.4.8/b28/macOS-x86_64 Safari/537.36')"
    appNewVersion=$(getJSONValue "${izotopeDetails}" "[0].Version")
    downloadURL=$(getJSONValue "${izotopeDetails}" "[0].OSXDownloadURL")
    installerTool="Install Product Portal.app"
    CLIInstaller="Install Product Portal.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --disable-components launch_after_install )
    expectedTeamID="QGULMAPEB2"
    ;;
jabradirect)
    name="Jabra Direct"
    type="pkgInDmg"
    # packageID="com.jabra.directonline"
    versionKey="CFBundleVersion"
    downloadURL="https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.dmg"
    #appNewVersion=$(curl -fs https://www.jabra.com/Support/release-notes/release-note-jabra-direct | grep -oe "Release version:.*[0-9.]*<" | head -1 | cut -d ">" -f2 | cut -d "<" -f1 | sed 's/ //g')
    appNewVersion=$(curl -fs "https://jabraexpressonlinejdo.jabra.com/jdo/jdo.json" | grep -i MacVersion | cut -d '"' -f4)
    expectedTeamID="55LV32M29R"
    ;;
jamfcheck)
    name="jamfcheck"
    type="dmg"
    downloadURL="$(downloadURLFromGit txhaflaire JamfCheck)"
    appNewVersion="$(versionFromGit txhaflaire JamfCheck)"
    expectedTeamID="CLQKFNPCCP"
    ;;
jamfconnect)
    name="Jamf Connect"
    type="pkgInDmg"
    packageID="com.jamf.connect"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep "x-amz-meta-version" | grep -o "[0-9.].*[0-9.].*[0-9]")
    expectedTeamID="483DWKW443"
    ;;
jamfconnectconfiguration)
    name="Jamf Connect Configuration"
    type="dmg"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep "x-amz-meta-version" | grep -o "[0-9.].*[0-9.].*[0-9]")
    expectedTeamID="483DWKW443"
    ;;
jamfconnectlaunchagent)
    name="Jamf Connect Launch Agent"
    type="pkgInDmg"
    pkgName="JamfConnectLaunchAgent.pkg"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep "x-amz-meta-version" | grep -o "[0-9.].*[0-9.].*[0-9]")
    expectedTeamID="483DWKW443"
    ;;
jamfcpr)
    name="jamfcpr"
    type="zip"
    downloadURL="$(downloadURLFromGit BIG-RAT jamfcpr)"
    appNewVersion="$(versionFromGit BIG-RAT jamfcpr)"
    expectedTeamID="PS2F6S478M"
    ;;
jamfmigrator)
    name="jamf-migrator"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf JamfMigrator)
    appNewVersion=$(versionFromGit jamf JamfMigrator)
    expectedTeamID="PS2F6S478M"
    ;;
jamfpppcutility)
    # credit: Mischa van der Bent
    name="PPPC Utility"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf PPPC-Utility)
    appNewVersion=$(versionFromGit jamf PPPC-Utility)
    expectedTeamID="483DWKW443"
    ;;
jamfprintermanager)
    name="Jamf Printer Manager"
    type="zip"
    downloadURL="$(downloadURLFromGit jamf jamf-printer-manager)"
    appNewVersion="$(versionFromGit jamf jamf-printer-manager)"
    expectedTeamID="483DWKW443"
    ;;
jamfreenroller)
    # credit: Mischa van der Bent
    name="ReEnroller"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf ReEnroller)
    #appNewVersion=$(versionFromGit jamf ReEnroller)
    expectedTeamID="PS2F6S478M"
    ;;
jamovi)
    name="jamovi"
    type="dmg"
    downloadURL="http://www.jamovi.org"
    if [[ -n $jamoviLatest ]]; then
        downloadURL="${downloadURL}$(curl -s "$downloadURL/download.html" | grep macos | grep "download-button" | head -1 | cut -d '"' -f 4)"
    else
        downloadURL="${downloadURL}$(curl -s "$downloadURL/download.html" | grep macos | grep "download-button" | tail -1 | cut -d '"' -f 4)"
    fi
    # The above is a cheat, they list both the "Latest" version and the "Solid" version twice on the page, but in opposing order.
    #     I'm also assuming they mean Latest = beta, and Solid = Stable.
    appNewVersion="$(echo $downloadPATH | cut -d '-' -f 2)"
    expectedTeamID="9NCBP559AB"
    ;;
jasp)
    name="JASP"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="JASP-[0-9.]*-macOS-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="JASP-[0-9.]*-macOS-x86_64.dmg"
    fi
    downloadURL=$(downloadURLFromGit jasp-stats jasp-desktop )
    appNewVersion=$(versionFromGit jasp-stats jasp-desktop )
    expectedTeamID="AWJJ3YVK9B"
    ;;
jdk17)
    name="Java SE Development Kit 17"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -sf https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html | grep -m 1 "Java SE Development Kit" | sed "s|.*Kit \(.*\)\<.*|\\1|")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.oracle.com/java/17/archive/jdk-"$appNewVersion"_macos-aarch64_bin.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.oracle.com/java/17/archive/jdk-"$appNewVersion"_macos-x64_bin.dmg"
    fi
    appCustomVersion(){ java --version | grep java | awk '{print $2}' }
    expectedTeamID="VB5E2TV963"
    ;;
jdk18)
    name="Java SE Development Kit 18"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -sf https://www.oracle.com/java/technologies/javase/jdk18-archive-downloads.html | grep -m 1 "Java SE Development Kit" | sed "s|.*Kit \(.*\)\<.*|\\1|")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.oracle.com/java/18/archive/jdk-"$appNewVersion"_macos-aarch64_bin.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.oracle.com/java/18/archive/jdk-"$appNewVersion"_macos-x64_bin.dmg"
    fi
    appCustomVersion(){ java --version | grep java | awk '{print $2}' }
    expectedTeamID="VB5E2TV963"
    ;;
jdk19)
    name="Java SE Development Kit 19"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -sf https://www.oracle.com/java/technologies/javase/jdk19-archive-downloads.html | grep -m 1 "Java SE Development Kit" | sed "s|.*Kit \(.*\)\<.*|\\1|")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.oracle.com/java/19/archive/jdk-"$appNewVersion"_macos-aarch64_bin.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.oracle.com/java/19/archive/jdk-"$appNewVersion"_macos-x64_bin.dmg"
    fi
    appCustomVersion(){ java --version | grep java | awk '{print $2}' }
    expectedTeamID="VB5E2TV963"
    ;;
jdk20)
    name="Java SE Development Kit 20"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.oracle.com/java/20/latest/jdk-20_macos-aarch64_bin.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.oracle.com/java/20/latest/jdk-20_macos-x64_bin.dmg"
    fi
    appCustomVersion(){ java --version | grep java | awk '{print $2}' }
    expectedTeamID="VB5E2TV963"
    ;;
jetbrainsclion)
    name="CLion"
    type="dmg"
    jetbrainscode="CL"
    jetbrainsdistribution="mac"
    if [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsdatagrip)
    name="DataGrip"
    type="dmg"
    jetbrainscode="DG"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsdataspell)
    name="DataSpell"
    type="dmg"
    jetbrainscode="DS"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsgateway)
    name="JetBrains Gateway"
    type="dmg"
    jetbrainscode="GW"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsgoland)
    name="GoLand"
    type="dmg"
    jetbrainscode="GO"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsintellijidea)
    name="IntelliJ IDEA"
    type="dmg"
    jetbrainscode="II"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsintellijideace|\
intellijideace)
    name="IntelliJ IDEA CE"
    type="dmg"
    jetbrainscode="IIC"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsphpstorm)
    name="PHPStorm"
    type="dmg"
    jetbrainscode="PS"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainspycharm)
    # This is the Pro version of PyCharm. Do not confuse with PyCharm CE.
    name="PyCharm"
    type="dmg"
    jetbrainscode="PCP"
    jetbrainsdistribution="mac"
    if [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    blockingProcesses=( pycharm )
    ;;
jetbrainspycharmce|\
pycharmce)
    name="PyCharm CE"
    type="dmg"
    jetbrainscode="PCC"
    jetbrainsdistribution="mac"
    if [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    blockingProcesses=( pycharm )
    ;;
jetbrainsrider)
    name="Rider"
    type="dmg"
    jetbrainscode="RD"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsrubymine)
     name="RubyMine"
     type="dmg"
     jetbrainscode="RM"
     if [[ $(arch) == i386 ]]; then
         jetbrainsdistribution="mac"
     elif [[ $(arch) == arm64 ]]; then
         jetbrainsdistribution="macM1"
     fi
     downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
     expectedTeamID="2ZEFAR8TH3"
     ;;
jetbrainstoolbox)
    name="JetBrains Toolbox"
    type="dmg"
    jetbrainscode="TBA"
    jetbrainsdistribution="mac"
    if [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainswebstorm)
    name="Webstorm"
    type="dmg"
    jetbrainscode="WS"
    jetbrainsdistribution="mac"
    if [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
jitsimeet)
    name="Jitsi Meet"
    type="dmg"
    downloadURL=$(downloadURLFromGit Jitsi jitsi-meet-electron)
    appNewVersion=$(versionFromGit Jitsi jitsi-meet-electron)
    expectedTeamID="FC967L3QRG"
    ;;
joplin)
    name="Joplin"
    type="dmg"
	if [[ $(arch) == “arm64” ]]; then
        archiveName="Joplin-[0-9.]*-arm64.DMG"
    elif [[ $(arch) == “i386” ]]; then
        archiveName="Joplin-[0-9.]*.dmg"
    fi
    downloadURL="$(downloadURLFromGit laurent22 joplin)"
    appNewVersion="$(versionFromGit laurent22 joplin)"
    expectedTeamID="A9BXAFS6CT"
    ;;
jre8)
    name="Java Runtime Environment 8"
    type="pkgInDmg"
    versionKey="CFBundleVersion"
    versionURL=$(curl -fs "https://javadl-esd-secure.oracle.com/update/mac/map-mac-1.8.0.xml" | xpath '( //java-update-map/mapping/url)[last()]' 2>/dev/null | cut -d\> -f2 | cut -d\< -f1)
    appNewVersion=$(curl -fs "${versionURL}" | xpath '(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null | cut -d '"' -f 2)
    appBuildVersion=$(echo $appNewVersion | cut -d. -f3)
    downloadURL="$(curl -fs "${versionURL}" | xpath '(//rss/channel/item/enclosure/@url)[last()]' 2>/dev/null | cut -d '"' -f 2)"
    pkgName="Java 8 Update ${appBuildVersion}.app/Contents/Resources/JavaAppletPlugin.pkg"
    appCustomVersion(){ defaults read "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Info.plist" "${versionKey}" 2>/dev/null }
    expectedTeamID="VB5E2TV963"
    ;;
jumpcloudpasswordmanager|\
jcpswdmgr)
    name="JumpCloud Password Manager"
    type="dmg"
    downloadURL="https://cdn.pwm.jumpcloud.com/DA/release/JumpCloud-Password-Manager-latest.dmg"
    expectedTeamID="N985MXSH85"
    ;;
jumpdesktop)
    name="Jump Desktop"
    type="zip"
    downloadURL=$(curl -fsL "https://mirror.jumpdesktop.com/downloads/jdm/jdmac-web-appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://mirror.jumpdesktop.com/downloads/jdm/jdmac-web-appcast.xml" | grep sparkle:shortVersionString | tr ',' '\n' | grep sparkle:shortVersionString | cut -d '"' -f 2)
    expectedTeamID="2HCKV38EEC"
    ;;
jupyterlab)
    name="JupyterLab"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="JupyterLab-Setup-macOS-arm64.dmg"
		downloadURL="$(downloadURLFromGit jupyterlab jupyterlab-desktop)"
		appNewVersion="$(versionFromGit jupyterlab jupyterlab-desktop)"
	elif [[ $(arch) == i386 ]]; then
		archiveName="JupyterLab-Setup-macOS-x64.dmg"
		downloadURL="$(downloadURLFromGit jupyterlab jupyterlab-desktop)"
		appNewVersion="$(versionFromGit jupyterlab jupyterlab-desktop)"
 	fi
    expectedTeamID="2YJ64GUAVW"
    ;;
kap)
    # credit: Lance Stephens (@pythoninthegrass on MacAdmins Slack)
    name="Kap"
    type="dmg"
    if [[ $(arch) = "i386" ]]; then
        archiveName="${name}-[0-9.]*-x64.${type}"
        downloadURL=$(downloadURLFromGit wulkano kap | grep -i x64)
    else
        archiveName="${name}-[0-9.]*-arm64.${type}"
        downloadURL=$(downloadURLFromGit wulkano kap | grep -i arm64)
    fi
    appNewVersion=$(versionFromGit wulkano Kap)
    expectedTeamID="2KEEHXF6R6"
    ;;
karabinerelements)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Karabiner-Elements"
    type="pkgInDmg"
    downloadURL=$(downloadURLFromGit pqrs-org Karabiner-Elements)
    appNewVersion=$(versionFromGit pqrs-org Karabiner-Elements)
    expectedTeamID="G43BCU2T37"
    ;;
kdrive)
    name="kDrive"
    type="pkg"
    packageID="com.infomaniak.drive.desktopclient"
    jsonData=$(curl -sf https://www.infomaniak.com/drive/latest)
    downloadURL=$(getJSONValue "$jsonData" "macos.downloadurl")
    appNewVersion=$(getJSONValue "$jsonData" "macos.version")
    expectedTeamID="864VDCS2QY"
    ;;
keepassxc)
    name="KeePassXC"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      archiveName="x86_64.dmg"
    elif [[ $(arch) == arm64 ]]; then
      archiveName="arm64.dmg"
    fi
    downloadURL=$(downloadURLFromGit keepassxreboot keepassxc)
    appNewVersion=$(versionFromGit keepassxreboot keepassxc)
    expectedTeamID="G2S7P7J672"
    ;;
keeperpasswordmanager)
    name="Keeper Password Manager"
    type="dmg"
    downloadURL="https://www.keepersecurity.com/desktop_electron/Darwin/KeeperSetup.dmg"
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://keepersecurity.com/desktop_electron/desktop_electron_version.txt')" "version" )
    expectedTeamID="234QNB7GCA"
    blockingProcess=( "Keeper Password Manager" )
    ;;
keepingyouawake)
    name="KeepingYouAwake"
    type="zip"
    downloadURL=$(downloadURLFromGit newmarcel KeepingYouAwake)
    appNewVersion=$(versionFromGit newmarcel KeepingYouAwake)
    expectedTeamID="5KESHV9W85"
    ;;
keka)
    name="Keka"
    type="dmg"
    downloadURL=$(downloadURLFromGit aonez Keka)
    appNewVersion=$(versionFromGit aonez Keka)
    expectedTeamID="4FG648TM2A"
    ;;
keybase)
    name="Keybase"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2 | grep arm64 )
        appNewVersion=$( curl -sfL https://prerelease.keybase.io/update-darwin-arm64-prod-v2.json | grep '"version": '  | awk '{print $2}' | awk -F\" '{print $2}' )
    elif [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2 | grep -v arm64 )
        appNewVersion=$( curl -sfL https://prerelease.keybase.io/update-darwin-prod-v2.json | grep '"version": '  | awk '{print $2}' | awk -F\" '{print $2}' )
    fi
    expectedTeamID="99229SGT5K"
    ;; 
keyboardmaestro)
    # credit: Søren Theilgaard (@theilgaard)
    name="Keyboard Maestro"
    type="zip"
    downloadURL="https://download.keyboardmaestro.com/"
    #appNewVersion=$( curl -fs https://www.stairways.com/press/ | grep -i "releases Keyboard Maestro" | head -1 | sed -E 's/.*releases Keyboard Maestro ([0-9.]*)<.*/\1/g' ) # Text based from web site
    appNewVersion=$( curl -fs "https://www.stairways.com/press/rss.xml" | xpath '//rss/channel/item/title[contains(text(), "releases Keyboard Maestro")]' 2>/dev/null | head -1 | sed -E 's/.*releases Keyboard Maestro ([0-9.]*)<.*/\1/g' ) # uses XML, so might be a little more precise/future proof
    expectedTeamID="QMHRBA4LGH"
    blockingProcesses=( "Keyboard Maestro Engine" "Keyboard Maestro" )
    ;;
keyshot12)
    name="KeyShot12"
    type="pkg"
    packageID="com.luxion.pkg.keyshot12.app"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://www.keyshot.com/download/357619/"
    appNewVersion="$( curl -v "$downloadURL" 2>&1 | grep location | cut -d '_' -f 4 | cut -d '.' -f 1-2 )"
    ;;
keyshot|\
keyshot2024)
    name="KeyShot"
    type="pkg"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://www.keyshot.com/download/370762/"
    appNewVersion="$( curl -v "$downloadURL" 2>&1 | grep location | cut -d '_' -f 4 | cut -d '.' -f 1-2 )"
    ;;
keystoreexplorer)
    name="KeyStore Explorer"
    type="dmg"
    downloadURL="$(downloadURLFromGit kaikramer keystore-explorer)"
    appNewVersion="$(versionFromGit kaikramer keystore-explorer)"
    expectedTeamID="BKXPBP395L"
    ;;
kimplusclientmodul)
    name="KIMplus Clientmodul"
    # appName="KIMplus Clientmodul.app"
    type="dmg"
    downloadName=$(curl -fs "https://cm.kimplus.de/download/current/" | grep "macos" | sed "s|.*href=\"\(.*\)\">kimplus-clientmodul.*|\\1|")
    appNewVersion=$(curl -fs "https://cm.kimplus.de/download/current/" | grep "macos" | sed "s|.*kimplus-clientmodul_\(.*\)_macos.dmg.*|\\1|" | sed s/_/./g)
    downloadURL=https://cm.kimplus.de/download/current/$downloadName
    expectedTeamID="7QZS8E98SZ"
    blockingProcesses=( "JavaApplicationStub" )
    ;;
klokki)
    # credit: Søren Theilgaard (@theilgaard)
    name="Klokki"
    type="dmg"
    downloadURL="https://storage.yandexcloud.net/klokki/Klokki.dmg"
    expectedTeamID="Q9SATZMHPG"
    ;;
knockknock)
    name="KnockKnock"
    type="zip"
    downloadURL="$(downloadURLFromGit objective-see KnockKnock)"
    appNewVersion="$(versionFromGit objective-see KnockKnock)"
    expectedTeamID="VBG97UB4TA"
    ;;
korgsoftwarepass)
    name="Korg Software Pass"
    type="pkgInDmg"
    packageID="jp.co.korg.pkg.korgsoftwarepass"
    downloadVersion="$(curl -fs "https://id.korg.com/static_pages/3" | grep -E ".KORG_Software_Pass_([0-9]+(_[0-9]+)+)\.dmg" | cut -d\" -f4 | cut -d_ -f5-7 | cut -d. -f1 | xargs)"
    appNewVersion="$(echo "$downloadVersion" | tr '_' '.')"
    downloadURL="https://storage.korg.com/korgms/korg_collection/mac/KORG_Software_Pass_${downloadVersion}.dmg"
    expectedTeamID="9H3HFX7NG2"
    ;;
krisp)
    name="Krisp"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.krisp.ai/mac?package=package_arm"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.krisp.ai/mac?package=package_64"
    fi
    appNewVersion="$(curl -fsIL $downloadURL | grep -i "^location" | tail -1 | awk -F'/' '{ print $(NF-2) }')"
    expectedTeamID="U5R26XM5Z2"
    ;;
krita)
    # credit: Søren Theilgaard (@theilgaard)
    name="krita"
    type="dmg"
    downloadURL=$( curl -fs "https://krita.org/en/download/krita-desktop/" | grep ".*https.*stable.*dmg.*" | head -1 | sed -E 's/.*(https.*dmg).*/\1/g' )
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="5433B4KXM8"
    ;;
lastpass)
    name="LastPass"
    type="dmg"
    downloadURL="https://download.cloud.lastpass.com/mac/LastPass.dmg"
    appNewVersion="$(curl -fs "https://download.cloud.lastpass.com/mac/AppCast.xml" | xpath 'string(//rss/channel/item/title)' 2>/dev/null)"
    expectedTeamID="N24REP3BMN"
    ;;
latexit)
    name="LaTeXiT"
    type="dmg"
    downloadURL="$(curl -fs "https://pierre.chachatelier.fr/latexit/downloads/latexit-sparkle-en.rss" | xpath '(//rss/channel/item/enclosure/@url)[last()]' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs "https://pierre.chachatelier.fr/latexit/downloads/latexit-sparkle-en.rss" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[last()]' 2>/dev/null | cut -d '"' -f 2)"
    expectedTeamID="7SFX84GNR7"
    ;;
launchbar)
    name="LaunchBar"
    type="dmg"
    downloadURL=$(curl -fs "https://obdev.at/products/launchbar/download.html" | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*.dmg")
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="MLZF7K7B5R"
    ;;
launchcontrol)
	# A macOS GUI application for managing and configuring system services and launch daemons
    name="LaunchControl"
    type="tbz"
    appNewVersion="$(curl -Ls https://www.soma-zone.com/download/files/ | grep -oE 'LaunchControl-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.xz' | grep -vE 'DP|_update' | sed -E 's/LaunchControl-([0-9]+\.[0-9]+(\.[0-9]+)?)\.tar\.xz/\1/' | sort -V | tail -n 1)"
	downloadURL="https://www.soma-zone.com/download/files/LaunchControl-$appNewVersion.tar.xz"
    expectedTeamID="H665B6EEXC"
    ;;
lcadvancedvpnclient)
    name="LANCOM Advanced VPN Client"
    type="pkgInDmg"
    archiveName="LANCOM Advanced VPN Client.pkg"
    appShortVersion=$(curl -fs https://ftp.lancom.de/LANCOM-Releases/LC-VPN-Client/ | grep "macOS"| tail -1 | sed  "s|.*macOS-\(.*\)-Rel.*|\\1|")
    appNewVersion=(`sed 's/./&./1' <<< $appShortVersion`)
    downloadURL=(https://ftp.lancom.de/LANCOM-Releases/LC-VPN-Client/LC-Advanced-VPN-Client-macOS-"${appShortVersion}"-Rel-x86-64.dmg)
    blockingProcesses=( "LANCOM Advanced VPN Client" "ncprwsmac" )
    expectedTeamID="LL3KBL2M3A"
    ;;
lexarrecoverytool)
    name="Lexar Recovery Tool"
    type="appInDmgInZip"
    downloadURL="https://www.lexar.com/wp-content/uploads/product_images/Lexar-Recovery-Tool-Mac.zip"
    expectedTeamID="Y8HM6WR2DV"
    ;;
lgcalibrationstudio)
    name="LG Calibration Studio"
    type="pkgInZip"
    packageID="LGSI.TrueColorPro"
    releaseURL="https://www.lg.com/de/support/software-select-category-result?csSalesCode=34WK95U-W.AEU"
    appNewVersion=$(curl -sf $releaseURL | grep -m 1 "Mac_LCS_" | sed -E 's/.*LCS_([0-9.]*).zip.*/\1/g')
    downloadURL=$(curl -sf $releaseURL | grep -m 1 "Mac_LCS_" | sed "s|.*href=\"\(.*\)\" title.*|\\1|")
    expectedTeamID="5SKT5H4CPQ"
    ;;
libericajdk11ltsfull)
    name="Liberica JDK 11 LTS Full"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="arm"
        ;;
        "i386")
            cpu_arch="x86"
        ;;
    esac
    appNewVersion="$(curl "https://api.bell-sw.com/v1/liberica/releases?version-modifier=latest&version-feature=11&bitness=64&release-type=lts&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full" | sed 's/.*"version":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    downloadURL=$(curl "https://api.bell-sw.com/v1/liberica/releases?version=${appNewVersion}&bitness=64&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full&output=text&fields=downloadUrl")
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/liberica-jdk-11-full.jdk/Contents/Info.plist" ] ; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    expectedTeamID="8LBATW8FZA"
    ;;
libericajdk17ltsfull)
    name="Liberica JDK 17 Full LTS"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="arm"
        ;;
        "i386")
            cpu_arch="x86"
        ;;
    esac
    appNewVersion="$(curl "https://api.bell-sw.com/v1/liberica/releases?version-modifier=latest&version-feature=17&bitness=64&release-type=lts&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full" | sed 's/.*"version":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    downloadURL=$(curl "https://api.bell-sw.com/v1/liberica/releases?version=${appNewVersion}&bitness=64&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full&output=text&fields=downloadUrl")
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/liberica-jdk-17-full.jdk/Contents/Info.plist" ] ; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    expectedTeamID="8LBATW8FZA"
    ;;
libericajdk8ltsfull)
    name="Liberica JDK 8 Full LTS"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="arm"
        ;;
        "i386")
            cpu_arch="x86"
        ;;
    esac
    # Liberica lumps all versions in one GitHub repo but provide an API to query latest version details that we can parse
    latestVersionJSON=$(curl "https://api.bell-sw.com/v1/liberica/releases?version-modifier=latest&version-feature=8&bitness=64&release-type=lts&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full")
	# The release version of their JDK8 package (which are used in the download URLs) are formatted differently from the CFBundleVersion 1.8.0_382-b06 and 8u382+6 in pkg name
    pkgNewVersion="$(echo ${latestVersionJSON} | sed 's/.*"version":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    # We take the CFBundleIdentifier from the installed version (if found) and snag what they call the "Update Version"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" ] ; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" "CFBundleVersion" | sed -n 's:.*_\(.*\)\-.*:\1:p' ; fi }
    appNewVersion="$(echo ${latestVersionJSON} | sed 's/.*"updateVersion":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    # As long as we have the latest PKG version, we can get a direct download URL without further JSON parsing
    downloadURL=$(curl "https://api.bell-sw.com/v1/liberica/releases?version=${pkgNewVersion}&bitness=64&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full&output=text&fields=downloadUrl")
	expectedTeamID="8LBATW8FZA"
    ;;
libreoffice)
    name="LibreOffice"
    type="dmg"
    appMajorVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appMajorVersion"/mac/aarch64/LibreOffice_"$appMajorVersion"_MacOS_aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appMajorVersion"/mac/x86_64/LibreOffice_"$appMajorVersion"_MacOS_x86-64.dmg"
    fi
    appNewVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep -m 1 ".tar.xz" | sed "s|.*libreoffice-\(.*\).tar.xz?.*|\\1|")"
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
libreofficelanguagepack_intl)
    name="LibreOffice Language Pack"
    # appName="LibreOffice.app"
    #
    # Reads the primary language of the system and installs the appropriate language pack for the latest LibreOffice STABLE version
    # There is no language pack for the US English language and no installation is required other than the LibreOffice software itself.
    # Use in combination and after installing Libre Office (STABLE Version)
    # This label requires user interaction to complete the installation
    #
    type="dmg"
    packageID="org.libreoffice.script.langpack"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLanguages | head -2 | tail -1 | tr -dc "[:alnum:]\-")
    if [[ "$userLanguage" == "en-US" ]]; then
        cleanupAndExit 0 "No installation of a language pack is necessary for the US-English language."
    fi
    appNewVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)"
    releaseURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/aarch64/"
    until curl -fs $releaseURL | grep -q "_$userLanguage.dmg"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    # downloadURL="https://downloadarchive.documentfoundation.org/libreoffice/old/latest/mac/aarch64/"
    # if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
    #     printlog "Download not found for '$userLanguage', exiting."
    #     exit
    # fi
    # appNewVersion=$(curl -sf $releaseURL | grep -m 1 "_langpack_$userLanguage.dmg" | sed "s|.*LibreOffice_\(.*\)_MacOS.*|\\1|")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/aarch64/LibreOffice_"$appNewVersion"_MacOS_aarch64_langpack_"$userLanguage".dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/x86_64/LibreOffice_"$appNewVersion"_MacOS_x86-64_langpack_"$userLanguage".dmg"
    fi
    installerTool="LibreOffice Language Pack.app"
    CLIInstaller="LibreOffice Language Pack.app/Contents/LibreOffice Language Pack"
    expectedTeamID="7P5S3ZLCN7"
    # blockingProcesses=( soffice )
    ;;
lifesize)
    name="Lifesize"
    type="dmg"
    downloadURL="https://download.lifesizecloud.com/$(curl -fsL "https://download.lifesizecloud.com/" | xpath '//ListBucketResult/Contents/Key' 2>/dev/null | grep -oE '<Key>(.*\.dmg)</Key>' | sed 's/<Key>\(.*\)<\/Key>/\1/' | tail -1)"
    appNewVersion="$(echo "$downloadURL" | sed 's~https://download\.lifesizecloud\.com/~~;s/Lifesize-//;s/\.dmg//')"
    expectedTeamID="L57M4NT7Y7"
    ;;
lightburn)
    name="LightBurn"
    type="dmg"
    downloadURL="$(downloadURLFromGit LightBurnSoftware deployment)"
    appNewVersion="$(versionFromGit LightBurnSoftware deployment)"
    expectedTeamID="UWZQ3LL82C"
    ;;
linear)
    name="Linear"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.linear.app/mac/dmg/arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.linear.app/mac/dmg"
    fi
    appNewVersion=$(curl -sIkL $downloadURL | sed -r '/filename=/!d;s/.*filename=(.*)$/\1/' | awk '{print $2}')
    expectedTeamID="7VZ2S3V9RV"
    versionKey="CFBundleShortVersionString"
    appName="Linear.app"
    blockingProcesses=( "Linear" )
    ;;
    
linearmouse)
    name="LinearMouse"
    type="dmg"
    downloadURL="$(downloadURLFromGit linearmouse linearmouse)"
    appNewVersion="$(versionFromGit linearmouse linearmouse)"
    expectedTeamID="C5686NKYJ7"
    ;;
livereplayer)
    name="LiveReplayer"
    type="pkg"
    downloadURL=$(curl -fsL https://fsm-livereplayer.s3.amazonaws.com/update/stable/latest.json | grep package-url | grep -o "https:.*.pkg")
    appNewVersion=$(echo ${downloadURL} | grep -o "LiveReplayer-.*" | grep -o "[0-9].*[0-9]")
    expectedTeamID="2H7P9E934F"
    ;;
logioptions|\
logitechoptions)
    name="Logi Options"
    type="pkgInZip"
    #downloadURL=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr "," "\n" | grep -A 10 "macOS" | grep -oie "https.*/.*/options/.*\.zip" | head -1)
    downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/options/options_installer.zip"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/options/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    #pkgName="LogiMgr Installer "*".app/Contents/Resources/LogiMgr.pkg"
    pkgName=LogiMgr.pkg
    expectedTeamID="QED4VVPZWA"
    ;;
logitechoptionsplus)
    name="Logi Options+"
    appName="logioptionsplus.app"
    archiveName="logioptionsplus_installer.zip"
    installerTool="logioptionsplus_installer.app"
    type="zip"
    downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip"
    # Latest version of Logi Options+ requires macOS 12+
    # If older macOS is specified in the url for appNewVersion, it will never correspond to the installed version
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-12.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/optionsplus/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    CLIInstaller="logioptionsplus_installer.app/Contents/MacOS/logioptionsplus_installer"
    CLIArguments=(--quiet)
    expectedTeamID="QED4VVPZWA"
    ;;
logitune)
    name="LogiTune"
    archiveName="LogiTuneInstaller.dmg"
    appName="LogiTuneInstaller.app"
    type="dmg"
    downloadURL="https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/optionsplus/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    CLIInstaller="LogiTuneInstaller.app/Contents/MacOS/LogiTuneInstaller"
    CLIArguments=(-silent)
    expectedTeamID="QED4VVPZWA"
    ;;
logseq)
    name="Logseq"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="darwin-arm64-[0-9.]*.dmg"
        downloadURL=$(downloadURLFromGit logseq logseq)
    elif [[ $(arch) == "i386" ]]; then
        archiveName="darwin-x64-[0-9.]*.dmg"
        downloadURL=$(downloadURLFromGit logseq logseq)
    fi
    appNewVersion=$(versionFromGit logseq logseq)
    expectedTeamID="3K44EUN829"
    ;;
loom)
    name="Loom"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=https://cdn.loom.com/desktop-packages/$(curl -fs https://packages.loom.com/desktop-packages/latest-mac.yml | awk '/url/ && /arm64/ && /dmg/ {print $3}')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=https://cdn.loom.com/desktop-packages/$(curl -fs https://packages.loom.com/desktop-packages/latest-mac.yml | awk '/url/ && ! /arm64/ && /dmg/ {print $3}')
    fi
    appNewVersion=$(curl -fs https://packages.loom.com/desktop-packages/latest-mac.yml | awk '/version/ {print $2}' )
    expectedTeamID="QGD2ZPXZZG"
    ;;
loopcloud)
    name="Loopcloud"
    type="pkgInZip"
    downloadXML="$(curl -fs 'https://www.loopmasters.com/cloud/autoupdate/mac/release/appcast.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null | sed 's/ /%20/g' )"
    appNewVersion="$(echo "${downloadXML}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="6J526HR25E"
    ;;
loupedeck)
    name="Loupedeck"
    type="pkgInDmg"
    #downloadURL="https://5145542.fs1.hubspotusercontent-na1.net/hubfs/5145542/Knowledge%20Base/LD%20Software%20Downloads/5.8.1/LoupedeckInstaller_5.8.1.18057.dmg"
    downloadURL=$(curl -fs "https://loupedeck.com/downloads/" | xmllint --html --format - 2>/dev/null | grep -oE "https.*.dmg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*_([0-9.]*).dmg/\1/')
    expectedTeamID="M24R8BN5BK"
    ;;
lowprofile)
    name="Low Profile"
    type="dmg"
    downloadURL="$(downloadURLFromGit ninxsoft LowProfile)"
    appNewVersion="$(versionFromGit ninxsoft LowProfile)"
    expectedTeamID="7K3HVCLV7Z"
    ;;
lsagent)
    name="LsAgent-osx"
    #Description: Lansweeper is an IT Asset Management solution. This label installs the latest version. 
    #Download: https://www.lansweeper.com/download/lsagent/
    #Icon: https://www.lansweeper.com/wp-content/uploads/2018/08/LsAgent-Scanning-Agent.png
    #Usage:
    #  --help                                      Display the list of valid options
    #  --version                                   Display product information
    #  --unattendedmodeui <unattendedmodeui>       Unattended Mode UI
    #                                              Default: none
    #                                              Allowed: none minimal minimalWithDialogs
    #  --optionfile <optionfile>                   Installation option file
    #                                              Default: 
    #  --debuglevel <debuglevel>                   Debug information level of verbosity
    #                                              Default: 2
    #                                              Allowed: 0 1 2 3 4
    #  --mode <mode>                               Installation mode
    #                                              Default: osx
    #                                              Allowed: osx text unattended
    #  --debugtrace <debugtrace>                   Debug filename
    #                                              Default: 
    #  --installer-language <installer-language>   Language selection
    #                                              Default: en
    #                                              Allowed: sq ar es_AR az eu pt_BR bg ca hr cs da nl en et fi fr de el he hu id it ja kk ko lv lt no fa pl pt ro ru sr zh_CN sk sl es sv th zh_TW tr tk uk va vi cy
    #  --prefix <prefix>                           Installation Directory
    #                                              Default: /Applications/LansweeperAgent
    #  --server <server>                           FQDN, NetBios or IP of the Scanning Server
    #                                              Default: 
    #  --port <port>                               Listening Port on the Scanning Server
    #                                              Default: 9524
    #  --agentkey <agentkey>                       Cloud Relay Authentication Key (Optional)
    #                                              Default: 
    type="dmg"
    downloadURL="https://content.lansweeper.com/lsagent-mac/"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i "location" | cut -w -f2 | cut -d "/" -f5-6 | tr "/" ".")"
    installerTool="LsAgent-osx.app"
    CLIInstaller="LsAgent-osx.app/Contents/MacOS/installbuilder.sh"
    if [[ -z $lsagentPort ]]; then
        lsagentPort=9524
    fi
    if [[ -z $lsagentMode ]]; then
        lsagentMode="osx"
    fi
    if [[ -z $lsagentLanguage ]]; then
        lsagentLanguage="en"
    fi
    if [[ -z $lsagentServer && -z $lsagentKey ]]; then
        cleanupAndExit 89 "This label requires more parameters: lsagentServer and/or lsagentKey is required. Optional parameters include: lsagentPort, lsagentMode, and lsagentLanguage\nSee /Volumes/LsAgent/LsAgent-osx.app/Contents/MacOS/installbuilder.sh --help" ERROR
    fi
    CLIArguments=( --mode $lsagentMode --installer-language $lsagentLanguage )
    if [[ -n $lsagentServer ]]; then
        CLIArguments+=( --server $lsagentServer --port $lsagentPort )
    fi
    if [[ -n $lsagentKey ]]; then
        CLIArguments+=( --agentkey $lsagentKey )
    fi
    expectedTeamID="65LX6K7CBA"
    ;;
lucidlink)
    name="Lucid"
    # https://www.lucidlink.com/download
    type="pkg"
    downloadURL="https://www.lucidlink.com/download/latest/osx/stable/"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="Y4KMJPU2B4"
    ;;
lucifer)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="Lucifer"
    type="zip"
    downloadURL="https://www.hexedbits.com/downloads/lucifer.zip"
    appNewVersion=$( curl -fs "https://www.hexedbits.com/lucifer/" | grep "Latest version" | sed -E 's/.*Latest version ([0-9.]*),.*/\1/g' )
    expectedTeamID="5VRJU68BZ5"
    ;;
lulu)
    name="LuLu"
    type="dmg"
    #downloadURL=$( curl -fs "https://objective-see.com/products/lulu.html" | grep https | grep "$type" | head -1 | tr '"' "\n" | grep "^http" )
    #appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    downloadURL=$(downloadURLFromGit objective-see LuLu)
    appNewVersion=$(versionFromGit objective-see LuLu)
    expectedTeamID="VBG97UB4TA"
    ;;
lunadisplay)
    name="Luna Display"
    type="dmg"
    downloadURL="https://downloads.astropad.com/luna/mac/latest"
    appNewVersion=$(curl -sI "${downloadURL}" | grep -o -E 'location:.*$' | grep -o -E '\d+\.\d+\.\d+\.\d+')
    appCustomVersion(){
        if [ -f "/Applications/Luna Display.app/Contents/Info.plist" ]; then
            firstPart=$(/usr/bin/defaults read "/Applications/Luna Display.app/Contents/Info.plist" "CFBundleShortVersionString")
            secondPart=$(/usr/bin/defaults read "/Applications/Luna Display.app/Contents/Info.plist" "CFBundleVersion")
            echo "$firstPart.$secondPart"
        fi
    }
    expectedTeamID="8356ZZ8Y5K"
    ;;
macadminspython)
    name="MacAdmins Python"
    type="pkg"
    packageID="org.macadmins.python.recommended"
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/macadmins/python/releases/latest" | awk -F '"' "/browser_download_url/ && /python_recommended_signed/ { print \$4; exit }")
    appNewVersion=$(grep -o -E '\d+\.\d+\.\d+\.\d+' <<< $downloadURL | head -n 1)
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( NONE )
    ;;
maccyapp)
    name="Maccy"
    type="zip"
    downloadURL="$(downloadURLFromGit p0deje Maccy)"
    appNewVersion="$(versionFromGit p0deje Maccy)"
    expectedTeamID="MN3X4648SC"
    ;;
macfuse)
    name="FUSE for macOS"
    type="pkgInDmg"
    pkgName="Install macFUSE.pkg"
    downloadURL=$(downloadURLFromGit osxfuse osxfuse)
    appNewVersion=$(versionFromGit osxfuse osxfuse)
    expectedTeamID="3T5GSNBU6W"
    ;;
masterfader)
#credit: @sintichn macadmins slack
name="MasterFader"
type="dmg"
appNewVersion="$(curl -sf https://mackie.com/en/products/mixers/master-fader/master_fader.html | grep -m 1 "macOS" | sed -n 's/.*Fader \([0-9]\)\.\([0-9]\).*/\1_\2_/p')"
downloadURL="https://mackie.com/img/file_resources/Master_Fader_v"$appNewVersion"Setup.dmg"
expectedTeamID="6X5AC85L48"
;;
macoslaps)
    name="macOSLAPS"
    type="pkg"
    packageID="edu.psu.macOSLAPS"
    downloadURL="$(downloadURLFromGit joshua-d-miller macOSLAPS)"
    appNewVersion="$(versionFromGit joshua-d-miller macOSLAPS)"
    expectedTeamID="9UYK4F9BSM"
    ;;
macpass)
    name="MacPass"
    type="zip"
    downloadURL=$(downloadURLFromGit MacPass MacPass)
    appNewVersion=$(versionFromGit MacPass MacPass)
    expectedTeamID="55SM4L4Z97"
    ;;

macports)
    name="MacPorts"
    type="pkg"
    #buildVersion=$(uname -r | cut -d '.' -f 1)
    case $(uname -r | cut -d '.' -f 1) in
        23)
            archiveName="Sonoma.pkg"
            ;;
        22)
            archiveName="Ventura.pkg"
            ;;
        21)
            archiveName="Monterey.pkg"
            ;;
        20)
            archiveName="BigSur.pkg"
            ;;
        19)
            archiveName="Catalina.pkg"
            ;;
        *)
            cleanupAndExit 98 "macOS 10.14 or earlier not supported by Installomator."
            ;;
    esac
    downloadURL=$(downloadURLFromGit macports macports-base)
    appNewVersion=$(versionFromGit macports macports-base)
    appCustomVersion(){ if [ -x /opt/local/bin/port ]; then /opt/local/bin/port version | awk '{print $2}'; else "0"; fi }
    updateTool="/opt/local/bin/port"
    updateToolArguments="selfupdate"
    expectedTeamID="QTA3A3B7F3"
    ;;
mactex)
    # Big LaTeX distribution. Small alternative is basictex
    # Includes these apps (maybe in older version): texshop (texshop-alternative), texliveutility, latexit, bibdesk
    # You might want to run those labels after this one to update apps fully
    name="MacTeX"
    type="pkg"
    downloadURL="https://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg"
    expectedTeamID="RBGCY5RJWM"
    ;;
mactracker)
    name="Mactracker"
    type="zip"
    #downloadURL=$(curl -fs "https://mactracker.ca/releasenotes-mac.html" | grep "Mactracker_" | sed "s|.*href=\"\(.*\)\">Download for macOS.*|\\1|")
    downloadURL=$(curl -fs "https://update.mactracker.ca/appcast-b.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://update.mactracker.ca/appcast-b.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="63TP32R3AB"
    ;;
magicbullet)
    name="Magic Bullet Suite"
    type="zip"
    appCustomVersion(){
    	ls "/Users/Shared/Red Giant/uninstall" | grep bullet | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | head -n 30 | sort -gru
    }
    for i in {1..5}; do
        appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0" -fs "https://support.maxon.net/hc/en-us/sections/13336955539228-Red-Giant" | grep -i "Magic Bullet" | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | sort -gru | head -n 1)
        if [[ -n $appNewVersion ]]; then break; else sleep 1; fi
    done
    if [[ "$appNewVersion" =~ ^[^.]*\.[^.]*$ ]]; then
        appNewVersion=$(sed 's/\([0-9]*\.[0-9]*\)/\1.0/' <<<"$appNewVersion")
    fi
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/magicbullet/releases/$appNewVersion/MagicBulletSuite-${appNewVersion}_Mac.zip"
    magicbulletResponse=$(curl -s -I -L "$downloadURL")
    magicbulletHttpStatus=$(echo "$magicbulletResponse" | head -n 1 | cut -d ' ' -f 2)
    if [[ "$magicbulletHttpStatus" == "200" ]]; then
	    printlog "DownloadURL HTTP status code: $magicbulletHttpStatus" INFO
    elif [[ "$magicbulletHttpStatus" == "404" ]]; then
	    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/magicbullet/releases/$appNewVersion/MagicBulletSuite-${appNewVersion}_mac.zip"
	    printlog "Had to change DownloadURL due HTTP Status." INFO
    else
	    printlog "Unexpected HTTP status code: $magicbulletHttpStatus" ERROR
    fi
    installerTool="Magic Bullet Suite Installer.app"
    CLIInstaller="Magic Bullet Suite Installer.app/Contents/Scripts/install.sh"
    CLIArguments=()
    expectedTeamID="4ZY22YGXQG"
    ;;
mailmate)
    # info: It is now recommended for new users to use the latest beta release of MailMate instead of the public release, see https://freron.com/download/
    name="MailMate"
    type="tbz"
    versionKey="CFBundleVersion"
    downloadURL="https://updates.mailmate-app.com/archives/MailMateBeta.tbz"
    appNewVersion="$(curl -fs https://updates.mailmate-app.com/beta_release_notes | grep Revision | head -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g')"
    expectedTeamID="VP8UL4YCJC"
    ;;
mailtooutlook)
    name="MailToOutlook"
    type="pkg"
    downloadURL=https://macadmins.software/tools/MailToOutlook_2.1.pkg
    expectedTeamID="QGS93ZLCU7"
    ;;
malwarebytes)
    name="Malwarebytes"
    type="pkg"
    downloadURL="https://downloads.malwarebytes.com/file/mb-mac"
    appNewVersion=$(curl -Ifs https://downloads.malwarebytes.com/file/mb-mac | grep "location" | sed -E 's/.*-Mac-([0-9\.]*)\.pkg/\1/g')
    expectedTeamID="GVZRY6KDKR"
    ;;
mamp)
    name="MAMP"
    type="pkg"
    downloadURL="$(curl -fsL 'https://www.mamp.info/en/downloads/' | grep -o 'https://downloads.mamp.info/MAMP-PRO/macOS/MAMP-PRO/MAMP-MAMP-PRO-[^"]*.pkg' | head -1)"
    appNewVersion="$(echo "${downloadURL}" | grep -o 'MAMP-MAMP-PRO-[0-9]*\.[0-9]*' | sed 's/MAMP-MAMP-PRO-//')"
    expectedTeamID="5KCB5KHK77"
    ;;
marathon)
    name="Classic Marathon"
    type="dmg"
    archiveName="Marathon-[0-9.]*-Mac.dmg"
    versionKey="CFBundleVersion"
    downloadURL="$(downloadURLFromGit Aleph-One-Marathon alephone)"
    appNewVersion="$(versionFromGit Aleph-One-Marathon alephone)"
    expectedTeamID="E8K89CXZE7"
    ;;
marathon2)
    name="Classic Marathon 2"
    type="dmg"
    archiveName="Marathon2-[0-9.]*-Mac.dmg"
    versionKey="CFBundleVersion"
    downloadURL="$(downloadURLFromGit Aleph-One-Marathon alephone)"
    appNewVersion="$(versionFromGit Aleph-One-Marathon alephone)"
    expectedTeamID="E8K89CXZE7"
    ;;
marathoninfinity)
    name="Classic Marathon Infinity"
    type="dmg"
    archiveName="MarathonInfinity-[0-9.]*-Mac.dmg"
    versionKey="CFBundleVersion"
    downloadURL="$(downloadURLFromGit Aleph-One-Marathon alephone)"
    appNewVersion="$(versionFromGit Aleph-One-Marathon alephone)"
    expectedTeamID="E8K89CXZE7"
    ;;
masv)
    name="MASV"
    type="dmg"
    downloadURL="https://dl.massive.io/MASV.dmg"
    appNewVersion=$(curl -fsL 'https://dl.massive.io/latest-mac.yml' | grep 'version:' | awk '{print $NF }')
    expectedTeamID="VHKX7RCAY7"
    ;;
mattermost)
    name="Mattermost"
    type="dmg"
    archiveName="mac-universal.dmg"
    downloadURL=$(downloadURLFromGit mattermost desktop)
    appNewVersion=$(versionFromGit mattermost desktop)
    expectedTeamID="UQ8HT4Q2XM"
    ;;
maxonapp)
    name="Maxon"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion="$(curl -s "https://packages.maxon.net/manifests?platform=macos&org=maxon&type=products&family=fuse" | tr '{' '\n' | tr ',' '\n' | tr '}' '\n' | grep "version" | awk -F'"' '{print $4}' | sort -gr | head -n 1)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/website/macos/maxon/maxonapp/releases/${appNewVersion}/Maxon_App_${appNewVersion}_Mac.dmg"
    installerTool="Maxon App Installer.app"
    CLIInstaller="Maxon App Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
mdmwatchdog)
    name="Addigy MDM Watchdog"
    type="pkg"
    packageID="com.addigy.mdm-watchdog"
    downloadURL="https://agents.addigy.com/tools/mdm-watchdog/latest/mdm-watchdog.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i location | cut -d '/' -f 6)"
    expectedTeamID="R5LEJ8Y242"
    blockingProcesses=( "NONE" )
    ;;
meetingbar)
    name="Meetingbar"
    type="dmg"
    downloadURL=$(downloadURLFromGit leits MeetingBar)
    appNewVersion=$(versionFromGit leits MeetingBar)
    expectedTeamID="KGH289N6T8"
    ;;
meistertask)
    name="MeisterTask"
    type="dmg"
    downloadURL="https://www.meistertask.com/files/MeisterTask_osx.dmg"
    appNewVersion=""
    expectedTeamID="4MX957DLH9"
    ;;
mendeleyreferencemanager)
    name="Mendeley Reference Manager"
    type="dmg"
    downloadURL=$(curl -fs "https://www.mendeley.com/download-reference-manager/macOS" | grep -oE "https://static.mendeley.com/bin/desktop/.*?.dmg")
    appNewVersion=$(curl -fs "https://www.mendeley.com/download-reference-manager/macOS" | grep -oE "https://static.mendeley.com/bin/desktop/.*?.dmg" | sed -n 's/.*mendeley-reference-manager-\([0-9.-]*\)-x64.dmg/\1/p')
    expectedTeamID="45K89Y5X9B"
    #Company="Elsevier Inc."
    ;;
menumeters)
    name="MenuMeters"
    type="zip"
    downloadURL=$(downloadURLFromGit yujitach MenuMeters )
    appNewVersion=$(versionFromGit yujitach MenuMeters )
    expectedTeamID="95AQ7YKR5A"
    ;;
merlinproject)
    name="Merlin Project"
    type="zip"
    downloadURL="https://www.projectwizards.net/downloads/MerlinProject.zip"
    appNewVersion="$(curl -fs "https://www.projectwizards.net/de/support/release-notes"  | grep Version | head -n 6 | tail -n 1 | sed 's/[^0-9.]*//g')"
    expectedTeamID="9R6P9VZV27"
    ;;
mestrenova)
    name="MestReNova"
    type="dmg"
    mestrenovaDownloadVersion=$(curl -fs "https://mestrelab.com/download" | grep -Ei '([0-9]+.){2}[0-9]-[0-9]{5}' | head -n 1 | sed -E 's/.*-([0-9]+.[0-9]+.[0-9]+-[0-9]{5}).*/\1/g')
    downloadURL="https://mestrelab.com/downloads/mnova/mac/MestReNova-$mestrenovaDownloadVersion.dmg"
    appNewVersion=$(echo "$mestrenovaDownloadVersion" | cut -d '-' -f1)
    expectedTeamID="DH5EKRR34H"
    ;;
microsoftautoupdate)
    name="Microsoft AutoUpdate"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=830196"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "Microsoft_AutoUpdate.*pkg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_.*/\1/g')
    expectedTeamID="UBF8T346G9"
    # commented the updatetool for MSAutoupdate, because when Autoupdate is really
    # old or broken, you want to force a new install
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps MSau04 )
    ;;
microsoftazuredatastudio|\
azuredatastudio)
    name="Azure Data Studio"
    type="zip"
    downloadURL=$( curl -sL https://github.com/microsoft/azuredatastudio/releases/latest | grep 'Universal' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | head -1 )
    appNewVersion=$(versionFromGit microsoft azuredatastudio )
    expectedTeamID="UBF8T346G9"
    ;;
microsoftazurestorageexplorer)
    name="Microsoft Azure Storage Explorer"
    type="zip"
    if [[ $(arch) == arm64 ]]; then
        archiveName="StorageExplorer-darwin-arm64.zip"
    elif [[ $(arch) == i386 ]]; then
        archiveName="StorageExplorer-darwin-x64.zip" 
    fi
    downloadURL=$(downloadURLFromGit microsoft AzureStorageExplorer )
    appNewVersion=$(versionFromGit microsoft AzureStorageExplorer )
    expectedTeamID="UBF8T346G9"
    ;;
microsoftcompanyportal)
    name="Company Portal"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=853070"
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps IMCP01 )
    ;;
microsoftdefender|\
microsoftdefenderatp)
    name="Microsoft Defender"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2097502"
    appNewVersion=$(curl -fs https://raw.githubusercontent.com/MicrosoftDocs/defender-docs/public/defender-endpoint/mac-whatsnew.md | grep -m 1 -o "Build: [0-9\.]*" | awk '{print $2}')
    # No version number in download url
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps WDAV00 )
    ;;
microsoftedge|\
microsoftedgeconsumerstable|\
microsoftedgeenterprisestable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2093504"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdge.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    ;;
microsoftexcel)
    name="Microsoft Excel"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525135"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.excel.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps XCEL2019 )
    ;;
microsoftexcelreset)
    name="Microsoft Excel Reset"
    type="pkg"
    packageID="com.microsoft.reset.Excel"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Excel_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftlicenseremovaltool)
    # credit: Isaac Ordonez (@isaac) macadmins slack
    name="Microsoft License Removal Tool"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=849815"
    expectedTeamID="QGS93ZLCU7"
    appNewVersion=$(curl -is "$downloadURL" | grep ocation: | grep -o "Microsoft_.*pkg" | cut -d "_" -f 5 | cut -d "." -f1-2)
    Company="Microsoft"
    ;;
microsoftlicensereset)
    name="Microsoft License Reset"
    type="pkg"
    packageID="com.microsoft.reset.Credentials"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*License_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftoffice365)
    name="MicrosoftOffice365"
    type="pkg"
    packageID="com.microsoft.pkg.licensing"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525133"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 5)
    expectedTeamID="UBF8T346G9"
    # using MS PowerPoint as the 'stand-in' for the entire suite
    #appName="Microsoft PowerPoint.app"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "OneDrive" )
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install )
    ;;
microsoftofficebusinesspro)
    name="MicrosoftOfficeBusinessPro"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2009112"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3)
    expectedTeamID="UBF8T346G9"
    # using MS PowerPoint as the 'stand-in' for the entire suite
    appName="Microsoft PowerPoint.app"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "OneDrive" "Teams")
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install )
    ;;
microsoftofficefactoryreset)
    name="Microsoft Office Factory Reset"
    type="pkg"
    packageID="com.microsoft.reset.Factory"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Factory_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftofficeremoval)
    name="Microsoft Office Removal"
    type="pkg"
    packageID="com.microsoft.remove.Office"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Office_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftonedrive-deferred)
    # This version should match the Enterprise (Deferred) version setting of OneDrive update channel. So only use this label if that is the channel you use for OneDrive. For default update settings use label “microsoftonedrive”.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=861009"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onedrive.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONDR18 )
    ;;
microsoftonedrive-rollingout)
    # This version is the Rolling out version of OneDrive. Not sure what channel in OneDrive update it matches, maybe Insiders.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=861011"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onedrive.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    #if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
    #    printlog "Running msupdate --list"
    #    "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    #fi
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps ONDR18 )
    ;;
microsoftonedrive-rollingoutdeferred)
    # This version is the Rolling out Deferred version of OneDrive. Not sure what channel in OneDrive update it matches.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=861010"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onedrive.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    #if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
    #    printlog "Running msupdate --list"
    #    "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    #fi
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps ONDR18 )
    ;;
microsoftonedrive)
    # This version match the Last Released Production version setting of OneDrive update channel. It’s default if no update channel setting for OneDrive updates has been specified. Enterprise (Deferred) is also supported with label “microsoftonedrive-deferred”.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=823060"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onedrive.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONDR18 )
    ;;
microsoftonedrivereset)
    name="Microsoft OneDrive Reset"
    type="pkg"
    packageID="com.microsoft.reset.OneDrive"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*OneDrive_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftonedrivesuinsiders)
    # This label uses the same XML feed that the OneDrive StandaloneUpdater tool uses to find the Insiders version of OneDrive updates.
    # Microsoft OneDrive StandaloneUpdater Insiders
    name="OneDrive"
    type="pkg"
    onedriveFeed="https://g.live.com/0USSDMC_W5T/MacODSUInsiders"
    downloadURL="$(curl -fsL "${onedriveFeed}" | grep -A1 "UniversalPkgBinaryURL" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    appNewVersion="$(curl -fsL "${onedriveFeed}" | grep -A1 "CFBundleShortVersionString" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    expectedTeamID="UBF8T346G9"
    ;;
microsoftonedrivesuprod)
    # This label uses the same XML feed that the OneDrive StandaloneUpdater tool uses to find the production version of OneDrive updates.
    # Microsoft OneDrive StandaloneUpdater Production
    name="OneDrive"
    type="pkg"
    onedriveFeed="https://g.live.com/0USSDMC_W5T/MacODSUProduction"
    downloadURL="$(curl -fsL "${onedriveFeed}" | grep -A1 "UniversalPkgBinaryURL" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    appNewVersion="$(curl -fsL "${onedriveFeed}" | grep -A1 "CFBundleShortVersionString" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    expectedTeamID="UBF8T346G9"
    ;;
microsoftonenote)
    name="Microsoft OneNote"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=820886"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onenote.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONMC2019 )
    ;;
microsoftonenotereset)
    name="Microsoft OneNote Reset"
    type="pkg"
    packageID="com.microsoft.reset.OneNote"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*OneNote_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftoutlook-monthly)
    name="Microsoft Outlook"
    # As macadmin.software has provided a link to a monthly edition of Outlook, I have created this label.
    # Not sure about the requirements for this label, nor if the call to msupdate should be there or not.
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2228510"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.outlook.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps OPIM2019 )
    ;;
microsoftoutlook)
    name="Microsoft Outlook"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525137"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.outlook.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps OPIM2019 )
    ;;
microsoftoutlookdataremoval)
    name="Microsoft Outlook Data Removal"
    type="pkg"
    packageID="com.microsoft.remove.Outlook.Data"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Outlook_Data_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftoutlookreset)
    name="Microsoft Outlook Reset"
    type="pkg"
    packageID="com.microsoft.reset.Outlook"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Outlook_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftpowerpoint)
    name="Microsoft PowerPoint"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525136"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.powerpoint.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps PPT32019 )
    ;;
microsoftpowerpointreset)
    name="Microsoft PowerPoint Reset"
    type="pkg"
    packageID="com.microsoft.reset.PowerPoint"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*PowerPoint_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftremotedesktop)
    name="Microsoft Remote Desktop"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=868963"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.remotedesktop.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_Remote_Desktop.*pkg" | cut -d "_" -f 4)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSRD10 )
    ;;
microsoftremotehelp)
    name="Microsoft Remote Help"
    type="pkg"
    downloadURL="https://aka.ms/downloadremotehelpmacos"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i location: | grep -o "Microsoft_Remote_Help.*pkg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_.*/\1/g')
    expectedTeamID="UBF8T346G9"
    ;;
microsoftsharepointplugin)
    # Microsoft has marked this "oldpackage", should probably not be used anymore
    name="MicrosoftSharePointPlugin"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=800050"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/oldpackage[id="com.microsoft.sharepointplugin.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    expectedTeamID="UBF8T346G9"
    # TODO: determine blockingProcesses for SharePointPlugin
    ;;
microsoftskypeforbusiness)
    name="Skype for Business"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=832978"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.skypeforbusiness.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSFB16 )
    ;;
microsoftskypeforbusinessremovaltool)
    name="Skype for Business Removal"
    type="pkg"
    packageID="com.microsoft.remove.SkypeForBusiness"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*SkypeForBusiness_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftteams-rollingout)
    name="Microsoft Teams"
    type="pkg"
    packageID="com.microsoft.teams2"
    # Fetch the latest version number from the Microsoft documentation page
    appNewVersion=$(curl -s https://learn.microsoft.com/en-us/officeupdates/teams-app-versioning | awk '/<h4 id="mac-version-history">Mac version history<\/h4>/,/<\/table>/' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    downloadURL="https://statics.teams.cdn.office.net/production-osx/${appNewVersion}/MicrosoftTeams.pkg"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams MSTeams "Microsoft Teams" "Microsoft Teams WebView" "Microsoft Teams WebView Helper" "Microsoft Teams Launcher" "Microsoft Teams (work preview)" "Microsoft Teams classic Helper" "com.microsoft.teams2.respawn")
    # msupdate requires a PPPC profile pushed out from Jamf to work, https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS21 ) # --wait 600
    ;;
microsoftteamsclassic|\
microsoftteams)
    name="Microsoft Teams classic"
    type="pkg"
    #packageID="com.microsoft.teams"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869428"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | tail -1 | cut -d "/" -f5)
    versionKey="CFBundleGetInfoString"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams "Microsoft Teams classic Helper" )
    # msupdate requires a PPPC profile pushed out from Jamf to work, https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS10 ) # --wait 600 #TEAM01
    ;;
microsoftteamsnew)
    name="Microsoft Teams (work or school)"
    type="pkg"
    #packageID="com.microsoft.teams2"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2249065"
    #appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | tail -1 | cut -d "/" -f5)
    # No version in download path, so grab it from homepage
    appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.teams2.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    #versionKey="CFBundleGetInfoString"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( MSTeams "Microsoft Teams" "Microsoft Teams WebView" "Microsoft Teams Launcher" "Microsoft Teams (work preview)")
    # msupdate requires a PPPC profile pushed out from Jamf to work, https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS21 ) # --wait 600 # TEAM01
    ;;
microsoftteamsreset)
    name="Microsoft Teams Reset"
    type="pkg"
    packageID="com.microsoft.reset.Teams"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Teams_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
microsoftvisualstudiocode|\
visualstudiocode)
    name="Visual Studio Code"
    type="zip"
    appNewVersion=$(curl -fsL -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Safari/605.1.15' "https://code.visualstudio.com/Updates" | grep "/darwin" | grep -oiE ".com/([^>]+)([^<]+)/darwin" | cut -d "/" -f 2 | sed $'s/[^[:print:]	]//g' | head -1 )
    downloadURL="https://update.code.visualstudio.com/${appNewVersion}/darwin-universal/stable" # Universal
    expectedTeamID="UBF8T346G9"
    appName="Visual Studio Code.app"
    blockingProcesses=( Code )
    ;;
microsoftwindowsapp)
    name="Windows App"
    type="pkg"
    packageID="com.microsoft.rdc.macos"
    blockingProcesses=( "Windows App" "Microsoft Remote Desktop" )
    downloadURL="https://go.microsoft.com/fwlink/?linkid=868963"
    appNewVersion="$(curl -is "${downloadURL}" | grep "Location" | grep -o '[0-9][0-9]\.[0-9]*\.[0-9]*')"
    expectedTeamID="UBF8T346G9"
    ;;
microsoftword)
    name="Microsoft Word"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525134"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.word.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSWD2019 )
    ;;
microsoftwordreset)
    name="Microsoft Word Reset"
    type="pkg"
    packageID="com.microsoft.reset.Word"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Word_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
midimonitor)
    name="MIDI Monitor"
    type="dmg"
    downloadURL="https://www.snoize.com/MIDIMonitor/MIDIMonitor.dmg"
    appNewVersion=$(curl -fs "https://www.snoize.com/MIDIMonitor/MIDIMonitor.xml" | xpath 'string(//rss/channel/item[1]/sparkle:version)' 2>/dev/null)
    expectedTeamID="YDJAW5GX9U"
    ;;
mightymike)
    name="Mighty Mike"
    type="dmg"
    downloadURL=$(downloadURLFromGit jorio MightyMike)
    appNewVersion=$(versionFromGit jorio MightyMike)
    expectedTeamID="RVNL7XC27G"
    ;;
mindmanager)
    name="MindManager"
    type="dmg"
    downloadURL="https://www.mindmanager.com/mm-mac-dmg"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*_Mac_*([0-9.]*)\..*/\1/g')"
    expectedTeamID="ZF6ZZ779N5"
    ;;
miniconda)
    type="pkg"
	packageID="io.continuum.pkg.prepare_installation io.continuum.pkg.run_installation io.continuum.pkg.pathupdate"
    if [[ $(arch) == arm64 ]]; then
		name="Miniconda3-latest-MacOSX-arm64"
		downloadURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.pkg"
	elif [[ $(arch) == i386 ]]; then
		name="Miniconda3-latest-MacOSX-x86_64"
		downloadURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.pkg"
	fi
    expectedTeamID="Z5788K4JT7"
    ;;
minisim)
    name="Minisim"
    type="zip"
    downloadURL="$(downloadURLFromGit okwasniewski MiniSim)"
    appNewVersion="$(versionFromGit okwasniewski MiniSim)"
    expectedTeamID="Z3M9P6G4WY"
    ;;
miro)
    # credit: @matins
    name="Miro"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://desktop.miro.com/platforms/darwin-arm64/Install-Miro.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://desktop.miro.com/platforms/darwin/Install-Miro.dmg"
    fi
    expectedTeamID="M3GM7MFY7U"
    ;;
mist-cli)
    name="Mist-CLI"
    type="pkg"
    packageID="com.ninxsoft.pkg.mist-cli"
    downloadURL=$(downloadURLFromGit "ninxsoft" "mist-cli")
    appNewVersion=$(versionFromGit "ninxsoft" "mist-cli")
    expectedTeamID="7K3HVCLV7Z"
    blockingProcesses=( NONE )
    ;;
mist)
    name="Mist"
    type="pkg"
    packageID="com.ninxsoft.pkg.mist"
    downloadURL=$(downloadURLFromGit "ninxsoft" "mist")
    appNewVersion=$(versionFromGit "ninxsoft" "mist")
    expectedTeamID="7K3HVCLV7Z"
    blockingProcesses=( NONE )
    ;;
mkuser)
    name="mkuser"
    type="pkg"
    packageID="org.freegeek.pkg.mkuser"
    downloadURL="$(downloadURLFromGit freegeek-pdx mkuser)"
    # appNewVersion="$(versionFromGit freegeek-pdx mkuser unfiltered)"
    # mkuser does not adhere to numbers and dots only for version numbers.
    # Pull request submitted to add an unfiltered option to versionFromGit
    appNewVersion="$(osascript -l 'JavaScript' -e 'run = argv => JSON.parse(argv[0]).tag_name' -- "$(curl -m 5 -sfL 'https://update.mkuser.sh' 2> /dev/null)" 2> /dev/null)"
    appCustomVersion(){
        if [ -e /usr/local/bin/mkuser ]; then
            awk -F " |=|'" '($2 == "MKUSER_VERSION") { print $(NF-1); exit }' /usr/local/bin/mkuser
        fi
    }
    expectedTeamID="YRW6NUGA63"
    ;;
mmhmm-studio)
    name="mmhmm Studio"
    type="pkg"
    downloadURL="https://updates.mmhmm.app/mac/mmhmmStudio.pkg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Safari/605.1.15" )
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Safari/605.1.15" -fs "https://help.mmhmm.app/hc/en-us/articles/4420969712151-mmhmm-Studio-Mac-only-" | grep 'The latest version of mmhmm Studio is <strong>*' | sed -e 's/.*\<strong\>\(.*\)\.\<\/strong\>.*/\1/')
    expectedTeamID="M3KUT44L48"
    ;;
mmhmm|\
mmhmm-desktop)
    name="mmhmm"
    type="pkg"
    downloadURL="https://updates.mmhmm.app/mac/hybrid/mmhmm.pkg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Safari/605.1.15" )
    appNewVersion=""
    expectedTeamID="M3KUT44L48"
    ;;
mobikinassistantforandroid)
    name="MobiKin Assistant for Android"
    type="dmg"
    downloadURL="https://www.mobikin.com/downloads/mobikin-android-assistant.dmg"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fs https://www.mobikin.com/assistant-for-android-mac/ | grep -i "version:" | sed -E 's/.*Version: ([0-9.]*)<.*/\1/g')
    expectedTeamID="YNL42PA5C4"
    ;;
mobiletolocal)
    name="Mobile to Local"
    type="zip"
    downloadURL="$(downloadURLFromGit BIG-RAT mobile_to_local)"
    appNewVersion="$(versionFromGit BIG-RAT mobile_to_local)"
    expectedTeamID="PS2F6S478M"
    ;;
mobirise)
    name="mobirise"
    type="dmg"
    downloadURL="https://download.mobirise.com/MobiriseSetup.dmg"
    expectedTeamID="UD4494E573"
    ;;
mochakeyboard)
    name="Mocha Keyboard"
    type="appInDmgInZip"
    downloadURL="https://mochasoft.dk/mochakeyboard.dmg.zip"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
-H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
-H "accept-encoding: gzip, deflate, br"
-H "accept-language: en-US,en;q=0.9"
-H "sec-fetch-dest: document"
-H "sec-fetch-mode: navigate"
-H "sec-fetch-user: ?1"
-H "sec-gpc: 1"
-H "upgrade-insecure-requests: 1" )
    appNewVersion=""
    expectedTeamID="RR9F5EPNVW"
    ;;
mochatelnet)
    name="Telnet"
    type="appInDmgInZip"
    downloadURL="https://mochasoft.dk/telnet.dmg.zip"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
-H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
-H "accept-encoding: gzip, deflate, br"
-H "accept-language: en-US,en;q=0.9"
-H "sec-fetch-dest: document"
-H "sec-fetch-mode: navigate"
-H "sec-fetch-user: ?1"
-H "sec-gpc: 1"
-H "upgrade-insecure-requests: 1" )
    appNewVersion=""
    expectedTeamID="RR9F5EPNVW"
    ;;
mochatn3270)
    name="TN3270"
    type="appInDmgInZip"
    downloadURL="https://mochasoft.dk/tn3270.dmg.zip"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
-H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
-H "accept-encoding: gzip, deflate, br"
-H "accept-language: en-US,en;q=0.9"
-H "sec-fetch-dest: document"
-H "sec-fetch-mode: navigate"
-H "sec-fetch-user: ?1"
-H "sec-gpc: 1"
-H "upgrade-insecure-requests: 1" )
    appNewVersion=""
    expectedTeamID="RR9F5EPNVW"
    ;;
mochatn3812)
    name="TN3812"
    type="appInDmgInZip"
    downloadURL="https://mochasoft.dk/tn3812.dmg.zip"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
-H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
-H "accept-encoding: gzip, deflate, br"
-H "accept-language: en-US,en;q=0.9"
-H "sec-fetch-dest: document"
-H "sec-fetch-mode: navigate"
-H "sec-fetch-user: ?1"
-H "sec-gpc: 1"
-H "upgrade-insecure-requests: 1" )
    appNewVersion=""
    expectedTeamID="Frydendal"
    ;;
mochatn5250)
    name="TN5250"
    type="appInDmgInZip"
    downloadURL="https://mochasoft.dk/tn5250.dmg.zip"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
-H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
-H "accept-encoding: gzip, deflate, br"
-H "accept-language: en-US,en;q=0.9"
-H "sec-fetch-dest: document"
-H "sec-fetch-mode: navigate"
-H "sec-fetch-user: ?1"
-H "sec-gpc: 1"
-H "upgrade-insecure-requests: 1" )
    appNewVersion=""
    expectedTeamID="RR9F5EPNVW"
    ;;
mockoon)
    name="Mockoon"
    type="dmg"
    archiveName="mockoon.setup[0-9.]*universal.dmg"
    downloadURL="$(downloadURLFromGit mockoon mockoon)"
    appNewVersion="$(versionFromGit mockoon mockoon)"
    expectedTeamID="8443RQQKK6"
    ;;
moderncsv)
    name="Modern CSV"
    type="dmg"
    downloadURL="https://moderncsv.com/release/$(curl https://www.moderncsv.com/release/ | grep -o ModernCSV-Mac-v\[0-9\]\*.\[0-9\]\*.\[0-9\]\*.dmg | tail -1)"
    appNewVersion=$(curl https://www.moderncsv.com/release/ | grep -o moderncsv-mac-v\[0-9\]\*.\[0-9\]\*.\[0-9\]\*.dmg | tail -1 | grep -Eo '([0-9]+)(\.?[0-9]+)*' | head -1)
    expectedTeamID="HV2WS8735K"
    ;;
mongodbcompass)
    name="MongoDB Compass"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="mongodb-compass-[0-9.]*-darwin-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="mongodb-compass-[0-9.]*-darwin-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit mongodb-js compass)"
    appNewVersion="$(versionFromGit mongodb-js compass)"
    expectedTeamID="4XWMY46275"
    ;;
monitorcontrol)
    name="MonitorControl"
    type="dmg"
    downloadURL="$(downloadURLFromGit MonitorControl MonitorControl)"
    appNewVersion="$(versionFromGit MonitorControl MonitorControl)"
    expectedTeamID="299YSU96J7"
    ;;
montereyblocker)
    name="montereyblocker"
    type="pkg"
    packageID="dk.envo-it.montereyblocker"
    downloadURL=$(downloadURLFromGit Theile montereyblocker )
    appNewVersion=$(versionFromGit Theile montereyblocker )
    expectedTeamID="FXW6QXBFW5"
    ;;
morisawadesktopmanager)
    name="Morisawa Desktop Manager"
    type="pkgInDmg"
    packageID="jp.co.morisawa.MorisawaDesktopManager.Installer"
    morisawadesktopmanagerVersions=$(curl -fsL https://morisawafonts.com/resources/dm/mf_updates.mac.json)
    downloadURL=$(getJSONValue "${morisawadesktopmanagerVersions}" "latest_url")
    appNewVersion=$(getJSONValue "${morisawadesktopmanagerVersions}" "latest_version")
    expectedTeamID="662PVPVA3N"
    ;;
mountainduck)
    name="Mountain Duck"
    type="zip"
    downloadURL=$(curl -fs https://version.mountainduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://version.mountainduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="G69SCX94XU"
    ;;
multipass)
    name="multipass"
    type="pkg"
    downloadURL="$(downloadURLFromGit canonical multipass)"
    appNewVersion="$(versionFromGit canonical multipass)"
    expectedTeamID="X4QN7LTP59"
    ;;
munki)
    name="Munki"
    type="pkg"
    packageID="com.googlecode.munki.core"
    downloadURL=$(downloadURLFromGit "macadmins" "munki-builds")
    appNewVersion=$(versionFromGit "macadmins" "munki-builds")
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( NONE )
    ;;
munkiadmin)
    name="MunkiAdmin"
    type="dmg"
    downloadURL=$(downloadURLFromGit hjuutilainen munkiadmin )
    appNewVersion=$(versionFromGit hjuutilainen munkiadmin )
    expectedTeamID="8XXWJ76X9Y"
    ;;
mural)
    name="Mural"
    type="dmg"
    downloadURL=$(curl -fs "https://www.mural.co/apps" | grep -o 'https://download.mural.co/mac-app/Mural-[0-9.]*\.dmg' | sort -V | tail -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/^.*Mural-([0-9.]+)\.dmg$/\1/')
    expectedTeamID="823N8XU8B8"
    ;;
musescore)
    name="MuseScore 4"
    type="dmg"
    downloadURL=$(downloadURLFromGit musescore MuseScore)
    appNewVersion=$(versionFromGit musescore MuseScore)
    expectedTeamID="6EPAF2X3PR"
    ;;
muzzle)
    name="Muzzle"
    type="zip"
    downloadURL="https://muzzleapp.com/binaries/muzzle.zip"
    appNewVersion=$(curl -fs https://muzzleapp.com/updates/  | grep -io 'h2.*Version.* [0-9.]*.*h2' | head -1 | sed -E 's/.*ersion *([0-9.]*).*/\1/g')
    expectedTeamID="49EYHPJ4Q3"
    ;;
mysqlworkbenchce)
    name="MySQLWorkbench"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/$(curl -fsL "https://dev.mysql.com/downloads/workbench/?os=33" | grep -o "mysql-workbench-community-.*-macos-arm64.dmg" | head -1)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/$(curl -fsL "https://dev.mysql.com/downloads/workbench/?os=33" | grep -o "mysql-workbench-community-.*-macos-x86_64.dmg" | head -1)"
    fi
    appNewVersion="$(curl -fsL 'http://workbench.mysql.com/current-release' | grep fullversion | cut -d\" -f4).CE"
    expectedTeamID="VB5E2TV963"
    ;;
namiral)
    name="Namirial Sign"
    type="dmg"
    downloadURL="https://sign-be.namirial.app/download/macos"
    expectedTeamID="V7PV54FASQ"
    ;;
nanosaur)
    name="Nanosaur"
    type="dmg"
    downloadURL=$(downloadURLFromGit jorio Nanosaur)
    appNewVersion=$(versionFromGit jorio Nanosaur)
    expectedTeamID="RVNL7XC27G"
    ;;
nativeaccess)
    name="Native Access"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        naDetails="$(curl -fs "https://na-update.native-instruments.com/arm64/latest-mac.yml")"
        naItem="arm64/$(echo "$naDetails" | grep "path" | awk '{print $2}' | xargs)"
    elif [[ $(arch) == "i386" ]]; then
        naDetails="$(curl -fs "https://na-update.native-instruments.com/latest-mac.yml")"
        naItem="$(echo "$naDetails" | grep "path" | awk '{print $2}' | xargs)"
    fi
    downloadURL="https://na-update.native-instruments.com/${naItem}"
    appNewVersion="$(echo "$naDetails" | grep "version" | awk '{print $2}' | xargs)"
    expectedTeamID="83K5EG6Z9V"
    ;;
nessusagent)
    name="Nessus Agent"
    type="pkgInDmg"
    downloadURL="https://www.tenable.com/downloads/api/v2/pages/nessus-agents/files/NessusAgent-latest.dmg"
    appCustomVersion() { /Library/NessusAgent/run/bin/nasl -v | grep Agent | cut -d' ' -f3 }
    appNewVersion=$(curl -I -s  'https://www.tenable.com/downloads/api/v2/pages/nessus-agents/files/NessusAgent-latest.dmg' | grep 'filename=' | cut -d- -f3 | cut -f 1-3 -d '.')
    expectedTeamID="4B8J598M7U"
    ;;
netiquette)
    name="Netiquette"
    type="zip"
    downloadURL="$(downloadURLFromGit objective-see Netiquette)"
    appNewVersion="$(versionFromGit objective-see Netiquette)"
    expectedTeamID="VBG97UB4TA"
    ;;
netnewswire)
    name="NetNewsWire"
    type="zip"
    downloadURL="$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml | xmllint --xpath 'string(//item[1]/enclosure/@url)' -)"
    appNewVersion="$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml | xmllint --xpath 'string(//*[local-name()="item"][1]/*[local-name()="enclosure"]/@*[local-name()="shortVersionString"])' -)"
    expectedTeamID="M8L2WTLA8W"
    ;;
netspot)
    name="NetSpot"
    type="dmg"
    downloadURL="https://cdn.netspotapp.com/download/NetSpot.dmg"
    appNewVersion=$(curl -fs "https://www.netspotapp.com/updates/netspot2-appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="5QLDY8TU83"
    ;;
networksharemounter)
    name="NetworkShareMounter"
    type="pkg"
    packageID="de.fau.rrze.NetworkShareMounter"
    appNewVersion=$(curl -sfL https://gitlab.rrze.fau.de/api/v4/projects/506/releases | grep -o 'release-[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n 1)
    downloadURL=$(curl -sfL "https://gitlab.rrze.fau.de/api/v4/projects/506/releases/release-$appNewVersion/assets/links/" | grep -Eo '(http|https)://[a-zA-Z0-9./?=_%:-]*.pkg' | head -n 1)
    expectedTeamID="C8F68RFW4L"
    ;;
nextcloud)
    name="nextcloud"
    type="pkg"
    #packageID="com.nextcloud.desktopclient"
    downloadURL=$(downloadURLFromGit nextcloud-releases desktop)
    appNewVersion=$(versionFromGit nextcloud-releases desktop)
    # The version of the app is not equal to the version listed on GitHub.
    # App version something like "3.1.3git (build 4850)" but web page lists as "3.1.3"
    # Also it does not math packageID version "3.1.34850"
    appCustomVersion(){defaults read /Applications/nextcloud.app/Contents/Info.plist CFBundleShortVersionString | sed -E 's/^([0-9.]*)git.*/\1/g'}
    expectedTeamID="NKUJUXUJ3B"
    ;;
nodejs)
    name="nodejs"
    type="pkg"
    appNewVersion=$(curl -s -L https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')
    appCustomVersion(){/usr/local/bin/node -v}
    downloadURL="https://nodejs.org/dist/latest/node-$(curl -s -L https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p').pkg"
    expectedTeamID="HX7739G8FX"
    ;;
nodejslts)
    name="nodejs"
    type="pkg"
    appNewVersion=$(curl -fsL https://nodejs.org/en | xmllint --html --xpath '//a[contains(text(),"LTS")]/@href' - 2>/dev/null | grep -oE 'v[0-9]+(\.[0-9]+)*' | head -1)
    downloadURL="https://nodejs.org/dist/$appNewVersion/node-$appNewVersion.pkg"
    appCustomVersion(){/usr/local/bin/node -v}
    expectedTeamID="HX7739G8FX"
    ;;
nomachine)
    name="NoMachine"
    type="pkgInDmg"
    downloadURL=$(curl -i -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" https://www.nomachine.com/dwl_nm_bann.php | grep -i location | cut -w -f2 | tr -d '[:cntrl:]')
    appNewVersion=$(echo $downloadURL | grep -Eo "\d+.\d+.\d+")
    expectedTeamID="493C5JZAGR"
    ;;
nomad)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="NoMAD"
    type="pkg"
    downloadURL="https://files.jamfconnect.com/NoMAD.pkg"
    expectedTeamID="VRPY9KHGX6"
    ;;
nomadlogin)
    # credit: Søren Theilgaard (@theilgaard)
    name="NoMAD Login"
    type="pkg"
    downloadURL="https://files.nomad.menu/NoMAD-Login-AD.pkg"
    appNewVersion=$(curl -fs https://nomad.menu/support/ | grep "NoMAD Login AD Downloads" | sed -E 's/.*Current Version ([0-9\.]*)<.*/\1/g')
    expectedTeamID="AAPZK3CB24"
    ;;
nordlayer)
    # credit: Taboc741 (https://github.com/taboc741)
    name="NordLayer"
    type="pkg"
    downloadURL="https://downloads.nordlayer.com/mac/latest/NordLayer.pkg"
    expectedTeamID="W5W395V82Y"
    ;;
nordvpn)
    name="NordVPN"
    type="pkg"
    packageID="com.nordvpn.macos"
    downloadURL="https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/latest/NordVPN.pkg"
    appNewVersion=$( curl -s https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/latest/update_pkg.xml | xpath '(//sparkle:shortVersionString/text())[1]' 2>/dev/null )
    versionKey="CFBundleShortVersionString"
    expectedTeamID="W5W395V82Y"
    ;;
notion)
    name="Notion"
    type="dmg"
    downloadURL="https://www.notion.so/desktop/mac/download"
    appNewVersion=$(curl -fsIL "https://www.notion.so/desktop/mac/download" | grep -i "^location" | awk '{print $2}' | sed -e 's/.*Notion-\(.*\).dmg.*/\1/' | cut -d '-' -f 1)
    expectedTeamID="LBQJ96FQ8D"
    ;;
nova)
    name="Nova"
    type="zip"
    downloadURL="https://download.panic.com/nova/Nova-Latest.zip"
    appNewVersion="$(curl -fsIL https://download.panic.com/nova/Nova-Latest.zip | grep -i ^location | tail -1 | sed -E 's/^.*http.*\%20([0-9.]*)\.zip/\1/g')"
    expectedTeamID="VE8FC488U5"
    ;;
nps-santa)
    name="Santa"
    type="pkg"
    packageID="com.northpolesec.santa"
    downloadURL=$(downloadURLFromGit northpolesec santa)
    appNewVersion=$(versionFromGit northpolesec santa)
    expectedTeamID="ZMCG7MLDV9"
    ;;
nudge)
    name="Nudge"
    type="pkg"
    archiveName="Nudge-[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    appNewVersion=$(versionFromGit macadmins Nudge )
    expectedTeamID="T4SK8ZXCXG"
    ;;
nudgesuite)
    name="Nudge Suite"
    appName="Nudge.app"
    type="pkg"
    archiveName="Nudge_Suite-[0-9.]*.pkg"
    appNewVersion=$(versionFromGit macadmins Nudge )
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( "Nudge" )
    ;;
nvivo13)
    name="NVivo"
    type="dmg"
    downloadURL="https://download.qsrinternational.com/Software/NVivoforMac/NVivo.dmg"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr '/' '\n' | grep "[0-9]" | cut -d "." -f1-3 )
    expectedTeamID="A66L57342X"
    blockingProcesses=( NVivo NVivoHelper )
    ;;
nvivo14)
    name="NVivo 14"
    type="dmg"
    downloadURL="https://download.qsrinternational.com/Software/NVivo14forMac/NVivo.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | awk -F'/' '{ print $6 }' | cut -d "." -f1-3)
    expectedTeamID="8F4S7H8S59"
    blockingProcesses=( NVivo NVivoHelper "Nvivo 14" )
    ;;
nvivo|\
nvivo15)
    name="NVivo 15"
    type="dmg"
    downloadURL="https://download.qsrinternational.com/Software/NVivo15forMac/NVivo15.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | awk -F'/' '{ print $6 }' | cut -d "." -f1-3)
    expectedTeamID="8F4S7H8S59"
    blockingProcesses=( NVivo NVivoHelper "Nvivo 15" )
    ;;
nweasecuretestingbrowser)
    name="NWEA Secure Testing Browser"
    type="dmg"
    downloadURL="https://cdn.nwea.org/docs/NWEA-Secure-Testing-Browser-Mac.dmg"
    appNewVersion=""
    expectedTeamID="SRTXZJ7SQ3"
    ;;

obs)
    name="OBS"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        SUFeedURL="https://obsproject.com/osx_update/updates_arm64_v2.xml"
    elif [[ $(arch) == "i386" ]]; then
        SUFeedURL="https://obsproject.com/osx_update/updates_x86_64_v2.xml"
    fi
    appNewVersion=$(curl -fs "$SUFeedURL" | xpath '(//rss/channel/item[sparkle:channel="stable"]/sparkle:shortVersionString/text())[1]' 2>/dev/null)
    downloadURL=$(curl -fs "$SUFeedURL" | xpath 'string(//rss/channel/item[sparkle:channel="stable"]/enclosure/@url[1])' 2>/dev/null)
    archiveName=$(basename "$downloadURL")   
    versionKey="CFBundleShortVersionString"
    blockingProcesses=( "OBS Studio" )
    expectedTeamID="2MMRE5MTB8"
    ;;
obsbotcenter|\
obsbotwebcam)
    name="OBSBOT_Center"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.obsbot.com/download/obsbot-tiny-series" | xmllint --html --xpath 'string(//a[contains(@href,"Obsbot_Center_OA_E_MacOS")]/@href)' - 2> /dev/null)
    appNewVersion=$(curl -fsL "https://www.obsbot.com/download/obsbot-tiny-series" | xmllint --html --xpath 'substring-after(substring-before(string(//a[contains(@href,"Obsbot_Center_OA_E_MacOS")]/@href),"_release"),"MacOS_")' - 2> /dev/null)
    expectedTeamID="7GJANK3822"
    ;;
obsidian)
    # credit: Søren Theilgaard (@theilgaard)
    name="Obsidian"
    type="dmg"
    downloadURL=$( downloadURLFromGit obsidianmd obsidian-releases )
    appNewVersion=$(versionFromGit obsidianmd obsidian-releases)
    expectedTeamID="6JSW4SJWN9"
    ;;
odrive)
    # credit: Søren Theilgaard (@theilgaard)
    name="odrive"
    type="pkg"
    packageID="com.oxygen.odrive.installer-prod.pkg"
    # https://docs.odrive.com/docs/odrive-usage-guide#install-desktop-sync
    downloadURL="https://www.odrive.com/downloaddesktop?platform=mac"
    expectedTeamID="N887K88VYZ"
    ;;
oktaverify)
    name="Okta Verify"
    type="pkg"
    downloadURL="https://okta.okta.com/api/v1/artifacts/OKTA_VERIFY_MACOS/download?releaseChannel=GA&packageType=PKG"
    appNewVersion=$(curl -fsLIXGET "$downloadURL" | grep -i "^location" | sed -e 's/location\: //' | sed -e 's/.*OktaVerify-\(.*\).pkg/\1/' | sed -e 's/-.*$//')
    expectedTeamID="B7F62B65BN"
    ;;
ollama)
    name="Ollama"
    type="zip"
    downloadURL="$(downloadURLFromGit ollama ollama)"
    appNewVersion="$(versionFromGit ollama ollama)"
    expectedTeamID="3MU9H2V9Y9"
    ;;
omnidisksweeper)
    name="OmniDiskSweeper"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniDiskSweeper" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omnifocus3)
    name="OmniFocus"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniFocus3" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omnifocus4)
    name="OmniFocus"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniFocus4" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omnigraffle6)
    name="OmniGraffle"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniGraffle6" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omnigraffle7)
    name="OmniGraffle"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniGraffle7" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omnioutliner5)
    name="OmniOutliner"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniOutliner5" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omniplan3)
    name="OmniPlan"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniPlan3" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omniplan4)
    name="OmniPlan"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniPlan4" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
omnipresence)
    name="OmniPresence"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniPresence" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="34YW5XSRB7"
    ;;
onionshare)
    # credit: Søren Theilgaard (@theilgaard)
    name="OnionShare"
    type="dmg"
    downloadURL="https://onionshare.org$(curl -fs https://onionshare.org | grep "button.*dmg" | tr '"' '\n' | grep ".dmg")"
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="N9B95FDWH4"
    ;;
onlyofficedesktop)
    name="ONLYOFFICE"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
    downloadURL="https://download.onlyoffice.com/install/desktop/editors/mac/arm/distrib/ONLYOFFICE.dmg"
    elif [[ $(arch) == "i386" ]]; then
    downloadURL="https://download.onlyoffice.com/install/desktop/editors/mac/x86_64/distrib/ONLYOFFICE.dmg"
    fi
    appNewVersion=$(versionFromGit ONLYOFFICE DesktopEditors)
    expectedTeamID="2WH24U26GJ"
    ;;
onscreencontrol)
    name="OnScreen Control"
    type="pkgInZip"
    packageID="com.LGSI.OnScreen-Control"
    downloadFile=$(curl -sf https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/OnScreenControlLatestVersion.txt)
    appNewVersion=$(echo $downloadFile | grep -o '[0-9].[0-9][0-9]')
    downloadURL="https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/${downloadFile}"
    expectedTeamID="5SKT5H4CPQ"
    ;;
onyx)
    name="OnyX"
    type="dmg"
    osVersion=$( sw_vers -productVersion | cut -f1 -d'.' )
    downloadURL="https://www.titanium-software.fr/download/$osVersion/OnyX.dmg"
    appNewVersion=$( curl -fs https://www.titanium-software.fr/en/onyx.html | grep -Eo "OnyX [0-9]+\.[0-9]+\.[0-9]+ for macOS [^ ]+ $osVersion" | awk '{print $2}' | sort -Vr | head -1 )
    versionKey="CFBundleShortVersionString"
    expectedTeamID="T49MRBL8UL"
    ;;
openeid)
    name="Open-EID"
    type="pkgInDmg"
    archiveName="Open-EID.pkg"
    downloadURL=$(curl -fs "https://www.id.ee/en/article/install-id-software/" | grep -oe "https://installer.id.ee/media/osx/.*\.dmg")
    appNewVersion=$(echo $downloadURL | sed -E 's/.*EID_|.dmg//g')
    expectedTeamID="ET847QJV9F"
    blockingProcesses=( "EstEIDTokenApp" "EstEIDTokenNotify" "web-eid" )
    appCustomVersion(){ if [[ -d /Applications/Utilities/EstEIDTokenApp.app ]] && [[ -d /Applications/Utilities/web-eid.app ]];then /usr/sbin/pkgutil --pkg-info ee.ria.open-eid | grep "version" | awk '{print$2}';fi }
    ;;
openrefine)
    name="OpenRefine"
    type="dmg"
    downloadURL=$(downloadURLFromGit OpenRefine OpenRefine)
    appNewVersion=$(versionFromGit OpenRefine OpenRefine)
    expectedTeamID="P7W52F7J7L"
    ;;
openvpnconnect)
    # credit: Erik Stam (@erikstam)
    name="OpenVPN"
    type="pkgInDmg"
    pkgName="OpenVPN_Connect_Installer_signed.pkg"
    downloadURL="https://openvpn.net/downloads/openvpn-connect-v2-macos.dmg"
    expectedTeamID="ACV7L3WCD8"
    ;;
openvpnconnectv3)
    # credit: @lotnix
    name="OpenVPN Connect"
    type="pkgInDmg"
    if [[ $(arch) == "arm64" ]]; then
        pkgName="OpenVPN_Connect_[0-9_()]*_arm64_Installer_signed.pkg"
    elif [[ $(arch) == "i386" ]]; then
        pkgName="OpenVPN_Connect_[0-9_()]*_x86_64_Installer_signed.pkg"
    fi
    appNewVersion=$(curl -fs "https://openvpn.net/vpn-server-resources/openvpn-connect-for-macos-change-log/" | grep -i ">Release notes for " | grep -v beta | head -n 1 | sed "s|.*for \(.*\) .*|\\1|")
    downloadURL="https://openvpn.net/downloads/openvpn-connect-v3-macos.dmg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    expectedTeamID="ACV7L3WCD8"
    ;;
opera)
    name="Opera"
    type="dmg"
    downloadURL="$(curl -fsIL $(curl -fsL $(curl -fsI "https://download.opera.com/download/get/?partner=www&opsys=MacOS" | grep -i "^location" | awk '{print $2}' | tr -d '\r') | grep -oE "https:\/\/download\.opera\.com\/[^\"]*" | sed 's/\&amp\;/\&/g') | grep -i "^location" | awk '{print $2}' | tr -d '\r')"
    appNewVersion="$(printf "$downloadURL" | sed -E 's/https.*\/([0-9.]*)\/mac\/.*/\1/')"
	versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
orbstack)
    name="OrbStack"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://orbstack.dev/download/stable/latest/arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=https://orbstack.dev/download/stable/latest/amd64
    fi
    appNewVersion=$( curl --fail --silent --head $downloadURL | grep "location:" | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )
    expectedTeamID="HUAQ24HBR6"
    ;;
orcaslicer)
    name="OrcaSlicer"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
       downloadURL="$(downloadURLFromGit SoftFever OrcaSlicer)"
       appNewVersion="$(versionFromGit SoftFever OrcaSlicer)"
       archiveName="OrcaSlicer_Mac_arm64_*.dmg"
    elif [[ $(arch) == "i386" ]]; then
      downloadURL="$(downloadURLFromGit SoftFever OrcaSlicer)"
      appNewVersion="$(versionFromGit SoftFever OrcaSlicer)"
      archiveName="OrcaSlicer_Mac_x86_64_*.dmg"
    fi
    expectedTeamID="XQK7C38HH5"
    ;;
    
origin)
     name="Origin"
     type="dmg"
     downloadURL="https://www.dm.origin.com/mac/download/Origin.dmg"
     appNewVersion=$(curl -fsL 'https://api1.origin.com/autopatch/2/upgradeFrom/9.0.000.00000/en_US/PROD?platform=MAC&osVersion=10.16.0' | xpath 'string(//version)' 2>/dev/null)
     expectedTeamID="TSTV75T6Q5"
     ;;
orion)
    name="Orion"
    type="dmg"
    downloadURL="https://cdn.kagi.com/downloads/OrionInstaller.dmg"
    expectedTeamID="TFVG979488"
    ;;
osquery)
    name="osquery-*"
    type="pkg"
    packageID="io.osquery.agent"
    downloadURL="$(downloadURLFromGit osquery osquery)"
    appNewVersion="$(versionFromGit osquery osquery)"
    expectedTeamID="3522FA9PXF"
    ;;
ottomatic)
    name="Otto Matic"
    type="dmg"
    downloadURL=$(downloadURLFromGit jorio OttoMatic)
    appNewVersion=$(versionFromGit jorio OttoMatic)
    expectedTeamID="RVNL7XC27G"
    ;;
outputarcade)
    name="Arcade"
    type="pkg"
    arcadeVersion="$(curl -fs "https://api.output.com/v1/arcade_version")"
    if [[ -d "/Applications/Arcade.app" ]]; then
        downloadURL=$(getJSONValue "$arcadeVersion" packages.mac.url)
    else
        downloadUpgrade=$(getJSONValue "$arcadeVersion" packages.mac.url)
        downloadURL=$(echo "${downloadUpgrade}" | sed "s/Update/Install/")
    fi
    appNewVersion=$(getJSONValue "$arcadeVersion" version)
    expectedTeamID="M4BQRFQ23V"
    ;;
outputhub)
    name="Output Hub"
    type="dmg"
    downloadURL="$(curl -fsL "https://output.com/hub"| grep "Mac Download" | cut -d\" -f4)"
    appNewVersion=$( curl -fsL "https://output-hub-builds.s3.amazonaws.com/latest-mac.yml" | grep "^version:" | cut -d" " -f2 )
    expectedTeamID="M4BQRFQ23V"
    ;;
outset)
    name="Outset"
    type="pkg"
    packageID="io.macadmins.Outset"
    downloadURL=$(downloadURLFromGit "macadmins" "outset")
    appNewVersion=$(versionFromGit "macadmins" "outset")
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( NONE )
    ;;
overflow)
    name="Overflow"
    type="dmg"
    downloadURL="$(curl -sL 'https://overflow.io/download/' | awk -F '"' '/app-updates.overflow.io\/packages\/updates\/osx_64/ { print $8; exit }')"
    appNewVersion=$(echo "$downloadURL" | awk -F '-|[.]dmg' '{ print $(NF-1) }')
    expectedTeamID="7TK7YSGJFF"
    versionKey="CFBundleShortVersionString"
    ;;
owncloud)
    name="ownCloud"
    type="pkg"
    downloadPage="https://download.owncloud.com/desktop/ownCloud/stable/latest/mac/"
    appNewVersion=$(curl -fsL "$downloadPage" | grep -oE 'ownCloud-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-(arm64|x86_64)\.pkg' | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="${downloadPage}ownCloud-${appNewVersion}-arm64.pkg"
    else
        downloadURL="${downloadPage}ownCloud-${appNewVersion}-x86_64.pkg"
    fi
    expectedTeamID="4AP2STM4H5"
    ;;
pacifist)
    name="Pacifist"
    type="dmg"
    downloadURL="https://charlessoft.com/cgi-bin/pacifist_download.cgi?type=dmg"
    appNewVersion="$(curl -fsL "https://www.charlessoft.com/cgi-bin/pacifist_sparkle.cgi" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="HRLUCP7QP4"
    ;;
packages)
    name="Packages"
    type="pkgInDmg"
    pkgName="Install Packages.pkg"
    pkgsDetails="$(curl -fs "http://s.sudre.free.fr/Software/documentation/RemoteVersion.plist")"
    appNewVersion=$(echo "${pkgsDetails}"| xpath 'string(//dict/string[1])' 2>/dev/null)
    downloadURL=$(echo "${pkgsDetails}"| xpath 'string(//dict/string[2])' 2>/dev/null)
    expectedTeamID="NL5M9E394P"
   ;;
pandoc)
    name="Pandoc"
    type="pkg"
    packageID="net.johnmacfarlane.pandoc"
    downloadURL=$(downloadURLFromGit jgm pandoc )
    appNewVersion=$(versionFromGit jgm pandoc )
    archiveName="mac.pkg"
    expectedTeamID="5U2WKE6DES"
    ;;
parallelsrasclient)
    name="Parallels Client"
    type="pkg"
    appMajorVersion=$(curl -sf "https://download.parallels.com/website_links/ras/index.json" | head -2 | tail -1 | tr -dc "[:alnum:]")
	appFirstCommaVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) (.*|\\1|" | cut -d. -f-2)
    # appSecondCommaVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) (.*|\\1|")
    appRealVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*(\(.*\)).*|\\1|")
    # appDownloadVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) -.*|\\1|" | sed 's/ /./g' | sed 's/[^0-9.]//g')
    appNewVersion=$appFirstCommaVersion.$appRealVersion
    # downloadURL=https://download.parallels.com/ras/v"$appMajorVersion"/"$appSecondCommaVersion"."$appRealVersion"/RasClient-Mac-Notarized-"$appSecondCommaVersion"-"$appRealVersion".pkg
    downloadURL=$(curl -fs https://download.parallels.com/website_links/ras/$appMajorVersion/builds-en_US.json | grep '"Mac Client":' | cut -d ":" -f2- | cut -d '"' -f2)
    expectedTeamID="4C6364ACXT"
    ;;
paretosecurity)
    name="Pareto Security"
    type="dmg"
    downloadURL=$(downloadURLFromGit ParetoSecurity pareto-mac)
    appNewVersion=$(versionFromGit ParetoSecurity pareto-mac)
    expectedTeamID="PM784W7B8X"
    ;;
parsec)
    name="Parsec"
    type="pkg"
    downloadURL="https://builds.parsecgaming.com/package/parsec-macos.pkg"
    expectedTeamID="Y9MY52XZDB"
    ;;
particulars)
    name="Particulars"
    type="pkg"
    packageID="net.glencode.Particulars"
    downloadURL="https://particulars.app/_downloads/Particulars-latest.pkg"
    appNewVersion=$(curl -fsI "${downloadURL}" | grep -i location | grep -oE "[0-9]+\.[0-9]+")
    expectedTeamID="2Z25XDNP2X"
    blockingProcesses=( NONE )
    ;;
patchomator)
    name="patchomator"
    type="pkg"
    packageID="com.option8.patchomator"
    downloadURL="$(downloadURLFromGit Mac-Nerd patchomator)"
    appNewVersion="$(versionFromGit Mac-Nerd patchomator)"
    expectedTeamID="4VAAB6AM7X"
    ;;
pcoipclient)
    # Note that the sed match removes 'pcoip-client_' and '.dmg' 
    name="PCoIPClient"
    type="dmg"
    downloadURL="https://dl.teradici.com/DeAdBCiUYInHcSTy/pcoip-client/raw/names/pcoip-client-dmg/versions/latest/pcoip-client_latest.dmg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^content-disposition | sed -e 's/.*pcoip-client_//' -e 's/.dmg"//')"
    expectedTeamID="RU4LW7W32C"
    blockingProcesses=( "Teradici PCoIP Client" )
    ;;
pdfexpert)
    # PDF Expert
    name="PDF Expert"
    type="zip"
    downloadURL=$(curl -fs "https://downloads.pdfexpert.com/pem3/release/appcast.xml" | grep -o 'https://downloads.pdfexpert.com/[^"]*.zip' | tail -n 1)
    appNewVersion=$(curl -fs "https://downloads.pdfexpert.com/pem3/release/appcast.xml" | grep -o 'sparkle:shortVersionString="[^"]*"' | sed -E 's/sparkle:shortVersionString="([^"]*)"/\1/' | tail -n 1)
    expectedTeamID="3L68KQB4HG"
    ;;
pdfsam)
    name="PDFsam Basic"
    type="dmg"
    downloadURL=$(downloadURLFromGit torakiki pdfsam)
    appNewVersion=$(versionFromGit torakiki pdfsam)
    expectedTeamID="8XM3GHX436"
    ;;
pgadmin4)
    name="pgAdmin 4"
    type="dmg"
    downloadParent="https://www.postgresql.org/ftp/pgadmin/pgadmin4/"
    appNewVersion=$(curl -fs "${downloadParent}" | grep -oE 'v[0-9]+.[0-9]+' | sort -V | tail -n 1 | sed 's/v//g')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$appNewVersion/macos/pgadmin4-$appNewVersion-arm64.dmg"
    else
        downloadURL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$appNewVersion/macos/pgadmin4-$appNewVersion-x86_64.dmg"
    fi
    expectedTeamID="TCHGL2R7C5"
    ;;
pika)
    name="Pika"
    type="dmg"
    packageID="com.superhighfives.Pika"
    downloadURL=$(downloadURLFromGit "superhighfives" "pika")
    appNewVersion=$(versionFromGit "superhighfives" "pika")
    expectedTeamID="TGHU37N6EX"
    blockingProcesses=( NONE )
    ;;
pingplotter)
    name="PingPlotter"
    type="zip"
    downloadURL="https://www.pingplotter.com/downloads/pingplotter_osx.zip"
    appNewVersion=""
    expectedTeamID="JXB6F3JSYT"
    ;;
pitch)
    name="Pitch"
    type="dmg"
    downloadURL="https://desktop.pitch.com/mac/Pitch.dmg"
    expectedTeamID="KUCN8NUU6Z"
    ;;
plantronicshub)
    name="Plantronics Hub"
    type="pkgInDmg"
    downloadURL="https://www.poly.com/content/dam/www/software/PlantronicsHubInstaller.dmg"
    expectedTeamID="SKWK2Q7JJV"
    appNewVersion=$(curl -fs "https://www.poly.com/in/en/support/knowledge-base/kb-article-page?lang=en_US&urlName=Hub-Release-Notes&type=Product_Information__kav" | grep -o "(*.*<span>)" | head -1 | cut -d "(" -f2 | sed 's/\<\/span\>//g' | cut -d "<" -f1)
    ;;
platypus)
    name="Platypus"
    type="zip"
    downloadURL=$(downloadURLFromGit sveinbjornt Platypus)
    appNewVersion=$(versionFromGit sveinbjornt Platypus)
    expectedTeamID="55GP2M789L"
    ;;
plexmediaserver)
    name="Plex Media Server"
    type="zip"
    plexDetails="$(curl -fs "https://plex.tv/api/downloads/5.json")"
    appNewVersion="$(cut -d'-' -f1 <<< "$(getJSONValue "$plexDetails" "computer.MacOS.version")")"
    downloadURL=$(getJSONValue "$plexDetails" "computer.MacOS.releases[0].url")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="K4QJ56KR4A"
    ;;
plisteditpro)
    name="PlistEdit Pro"
    type="zip"
    downloadURL="https://www.fatcatsoftware.com/plisteditpro/PlistEditPro.zip"
    appNewVersion="$(curl -fs "https://www.fatcatsoftware.com/plisteditpro/downloads/appcast.xml" | xpath 'string(//rss/channel/item/sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="8NQ43ND65V"
    ;;
podman)
    name="Podman"
    type="pkg"
    downloadURL=$(downloadURLFromGit containers podman)
    appNewVersion=$(versionFromGit containers podman)
    archiveName="podman-installer-macos-universal.pkg"
    expectedTeamID="HYSCB8KRL2"
    ;;
podmandesktop)
    name="Podman Desktop"
    type="dmg"
    downloadURL=$(downloadURLFromGit containers podman-desktop)
    appNewVersion=$(versionFromGit containers podman-desktop)
    archiveName=" podman-desktop-$appNewVersion-universal.dmg"
    expectedTeamID="HYSCB8KRL2"
    ;;
podmandesktopairgap)
    name="Podman Desktop"
    type="dmg"
    downloadURL=$(downloadURLFromGit containers podman-desktop)
    appNewVersion=$(versionFromGit containers podman-desktop)
    if [[ $(arch) == "arm64" ]]; then
        archiveName="podman-desktop-airgap-$appNewVersion-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="podman-desktop-airgap-$appNewVersion-x64.dmg"
    fi
    expectedTeamID="HYSCB8KRL2"
    ;;
polleverywhere)
    name="Poll Everywhere"
    type="dmg"
    downloadURL="https://www.polleverywhere.com/app.dmg"
    appNewVersion=""
    expectedTeamID="W48F3X5M8W"
    ;;
polylens)
    name="Poly Lens"
    type="dmg"
    polyDetails="$(curl -fs 'https://api.silica-prod01.io.lens.poly.com/graphql' -X POST -H 'Content-Type: application/json' --data-raw '{"operationName":"LensSoftwareUpdateAvailable","variables":{"productId":"lens-desktop-mac","releaseChannel":null},"query":"query LensSoftwareUpdateAvailable($productId: ID!, $releaseChannel: String) {availableProductSoftwareByPid(pid: $productId, releaseChannel: $releaseChannel) {version productBuild {build archiveUrl __typename} __typename}}"}')"
    appNewVersion=$(getJSONValue "$polyDetails" "data.availableProductSoftwareByPid.version")
    downloadURL=$(getJSONValue "$polyDetails" "data.availableProductSoftwareByPid.productBuild.archiveUrl")
    expectedTeamID="SKWK2Q7JJV"
    ;;
popsql)
     name="PopSQL"
     type="dmg"
     appNewVersion=$(curl -s 'https://popsql-releases.s3.amazonaws.com/mac/latest-mac.yml' | grep version: | cut -d' ' -f2)
     curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    if [[ $(arch) == "arm64" ]]; then
     	downloadURL="https://get.popsql.com/download/dmg_arm64"
    elif [[ $(arch) == "i386" ]]; then
     	downloadURL="https://get.popsql.com/download/dmg"
    fi
     expectedTeamID="4TFVQY839W"
     ;;
portingkit)
    name="Porting Kit"
    type="dmg"
    downloadURL="https://www.portingkit.com/pub/portingkit/download_latest.php?format=dmg"
    appNewVersion=""
    expectedTeamID="45WEPZ3433"
    ;;
postgresapp)
	#  A full-featured PostgreSQL installation for macOS that includes PostGIS, a user-friendly interface, a convenient menu bar item, and automatic updates
    name="Postgres"
    type="dmg"
    downloadURL=$(downloadURLFromGit PostgresApp PostgresApp)
    appNewVersion=$(versionFromGit PostgresApp PostgresApp)
    archiveName="Postgres-$appNewVersion.dmg"
    expectedTeamID="ZF84SJ5A3G"
    ;;
postman)
    name="Postman"
    type="zip"
    curlOptions=( -H "accept-encoding: gzip, deflate, br")
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://dl.pstmn.io/download/latest/osx_arm64"
	elif [[ $(arch) == "i386" ]]; then
		downloadURL="https://dl.pstmn.io/download/latest/osx_64"
	fi
	appNewVersion=$(getJSONValue "$(curl -fsL 'https://www.postman.com/mkapi/release.json?t=')" 'notes[0].version')
    expectedTeamID="H7H8Q7M5CK"
    ;;
powermonitor)
    name="Power Monitor"
    type="pkg"
    downloadURL=$(downloadURLFromGit sap power-monitoring-tool-for-macos )
    appNewVersion=$(versionFromGit sap power-monitoring-tool-for-macos )
    expectedTeamID="7R5ZEU67FQ"
    ;;
prism10)
    name="Prism 10"
    type="dmg"
    downloadURL="https://cdn.graphpad.com/downloads/prism/10/InstallPrism10.dmg"
    appNewVersion=$(curl -fs "https://www.graphpad.com/updates" | grep -Eio 'The latest Prism version is.*' | cut -d "(" -f 1 | awk -F '<!-- --> <!-- -->' '{print $2}' | cut -d "<" -f 1)
    expectedTeamID="YQ2D36NS9M"
    ;;
prism9)
    name="Prism 9"
    type="dmg"
    downloadURL="https://cdn.graphpad.com/downloads/prism/9/InstallPrism9.dmg"
    appNewVersion="9.5.1"
    expectedTeamID="YQ2D36NS9M"
    ;;
pritunl)
    name="Pritunl"
    type="pkgInZip"
    packageID="com.pritunl.pkg.Pritunl"
    archiveName="Pritunl.pkg.zip"
    downloadURL=$(downloadURLFromGit pritunl pritunl-client-electron)
    appNewVersion=$(versionFromGit pritunl pritunl-client-electron)
    expectedTeamID="U22BLATN63"
    ;;
privileges)
    # Locking label to v1.5.4 because of changes in v2, see privileges2 label if needed
    name="Privileges"
    type="zip"
    downloadURL=https://github.com/SAP/macOS-enterprise-privileges/releases/download/1.5.4/Privileges.zip
    appNewVersion=1.5.4
    expectedTeamID="7R5ZEU67FQ"
    ;;
privileges2)
    # credit: Matt Adams (@d3xbot)
    name="Privileges"
    type="pkg"
    packageID="corp.sap.privileges.pkg"
    downloadURL="$(downloadURLFromGit SAP macOS-enterprise-privileges)"
    appNewVersion="$(versionFromGit SAP macOS-enterprise-privileges)"
    expectedTeamID="7R5ZEU67FQ"
    ;;
processing3)
    name="Processing"
    type="zip"
    downloadURL=$(downloadURLFromGit processing processing)
    appNewVersion=$(versionFromGit processing processing)
    expectedTeamID="8SBRM6J77J"
    # Github returned version number resulves in build and version numbers being combined, so this provides the best match.
    # if you are manually replicating the label with valuesfromarguements use 'appNewVersion="3.$(versionFromGit processing processing | cut -d "." -f 2-)"' instead.
    appCustomVersion(){ echo "$(defaults read /Applications/Processing.app/Contents/Info.plist CFBundleVersion )$( defaults read /Applications/Processing.app/Contents/Info.plist CFBundleShortVersionString )" }
    ;;
processing4)
    name="Processing"
    type="zip"
    archiveName="Processing-[0-9.]*-macOS-$( if [ "$( arch )" = "arm64" ]; then echo "aarch64" ; else echo "x64" ; fi ).zip"
    downloadURL=$(downloadURLFromGit processing processing4)
    appNewVersion=$(versionFromGit processing processing4)
    expectedTeamID="8SBRM6J77J"
    appCustomVersion(){ echo "$(defaults read /Applications/Processing.app/Contents/Info.plist CFBundleVersion )$( defaults read /Applications/Processing.app/Contents/Info.plist CFBundleShortVersionString )" }
    ;;
proctortrack)
    #credit: Jeff F. (@jefff on MacAdmins Slack)
    name="Proctortrack"
    type="zip"
    downloadURL="https://storage.googleapis.com/verificientstatic/ProctortrackApp/Production/Proctortrack.zip"
    expectedTeamID="SNHZD6TJE6"
    ;;
projectplace)
    name="Projectplace"
    type="dmg"
    downloadURL="https://service.projectplace.com/client_apps/desktop/Projectplace-for-mac.dmg"
    expectedTeamID="8333HW99E8"
    ;;
promiseutility|\
promiseutilityr)
    name="Promise Utility"
    type="pkgInDmg"
    packageID="com.promise.utilinstaller"
    downloadURL="https://www.promise.com/DownloadFile.aspx?DownloadFileUID=6533"
    expectedTeamID="268CCUR4WN"
    ;;
proofpointautoupdater)
    name="Proofpoint Auto Updater"
    type="pkgInZip"
    downloadURL=$(curl -fs https://app.us-east-1-op1.op.analyze.proofpoint.com/downloads/default/ | grep -o -i "href.*\".*\"*observeit-autoupdater-OSX-.*.tar.gz" | sed -n '1p' | cut -c 9-)
    expectedTeamID="DJR63QYCGL"
    ;;
propresenter7)
    name="ProPresenter 7"
    appName="ProPresenter.app"
    type="zip"
    blockingProcesses="ProPresenter"
    downloadURL=$(curl -s "https://api.renewedvision.com/v1/pro/upgrade?platform=macos&osVersion=12&appVersion=771&buildNumber=117899527&includeNotes=false" | grep -Eo '"downloadUrl":.*?[^\]",' | head -n 1 | cut -d \" -f 4 | sed -e 's/\\//g')
    appNewVersion=$(curl -s "https://api.renewedvision.com/v1/pro/upgrade?platform=macos&osVersion=12&appVersion=771&buildNumber=117899527&includeNotes=false" | grep -Eo '"version":.*?[^\]",' | head -n 1 | cut -d \" -f 4)
    expectedTeamID="97GAAZ6CPX"
    ;;
protonvpn)
    name="ProtonVPN"
    type="dmg"
    downloadURL=$(curl -s "https://protonvpn.com/download/macos-update3.xml" | xmllint --xpath 'string(//enclosure/@url)' -)
    appNewVersion=$(echo $downloadURL | sed -e 's/^.*\/Proton.*_v\([0-9.]*\)\.dmg/\1/g')
    expectedTeamID="J6S6Q257EK"
    ;;
proxyman)
    name="Proxyman"
    type="dmg"
    #downloadURL="https://proxyman.io/release/osx/Proxyman_latest.dmg"
    downloadURL="$(downloadURLFromGit ProxymanApp Proxyman)"
    appNewVersion="$(versionFromGit ProxymanApp Proxyman)"
    expectedTeamID="3X57WP8E8V"
    ;;
prune)
    name="Prune"
    type="zip"
    downloadURL=$(downloadURLFromGit BIG-RAT Prune)
    appNewVersion=$(versionFromGit BIG-RAT Prune)
    expectedTeamID="PS2F6S478M"
;;
prusaslicer)
    name="PrusaSlicer"
    type="dmg"
    archiveName="PrusaSlicer-[0-9.]*+MacOS-universal-[0-9.]*.dmg"
    downloadURL="$(downloadURLFromGit prusa3d PrusaSlicer)"
    appNewVersion="$(versionFromGit prusa3d PrusaSlicer)"
    expectedTeamID="DKPB65N43Z"
    ;;
pulsar)
    name="Pulsar"
    type="zip"
    appNewVersion=$(versionFromGit pulsar-edit pulsar)
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        archiveName="Silicon.Mac.Pulsar-${appNewVersion}-arm64-mac.zip"
    else
        printlog "Architecture: i386 (not arm64)"
        archiveName="Intel.Mac.Pulsar-${appNewVersion}-mac.zip"
    fi
    downloadURL=$(downloadURLFromGit pulsar-edit pulsar)
    expectedTeamID="D3KV2P2CZ8"
    ;;

pymol)
    name="PyMOL"
    type="dmg"
    downloadURL=$(curl -s -L "https://pymol.org/" | grep -m 1 -Eio 'href="https://pymol.org/installers/PyMOL-(.*)-MacOS(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    expectedTeamID="26SDDJ756N"
    ;;
python)
    name="Python"
    type="pkg"
    appNewVersion="$( curl --compressed -s "https://www.python.org/downloads/macos/" | awk '/Latest Python 3 Release - Python/{gsub(/<\/?[^>]+(>|$)/, ""); print $NF}' )"
    archiveName="$( curl -s "https://www.python.org/ftp/python/$appNewVersion/" | grep -om 1 "\"python.*macos.*\.pkg\"" | tr -d \" )"
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/$archiveName"
    shortVersion=$( cut -d '.' -f1,2 <<< $appNewVersion )
    packageID="org.python.Python.PythonFramework-$shortVersion"
    expectedTeamID="BMM5U3QVKW"
    blockingProcesses=( "IDLE" "Python Launcher" )
    versionKey="CFBundleVersion"
    appCustomVersion() {
        if [ -d "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/" ]; then
            /usr/bin/defaults read "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/Contents/Info" CFBundleVersion
        fi
    }
    ;;
qgis-pr)
    name="QGIS"
    type="dmg"
    downloadURL="https://download.qgis.org/downloads/macos/qgis-macos-pr.dmg"
    appNewVersion="$(curl -fs "https://www.qgis.org/da/_static/documentation_options.js" | grep -i version | cut -d "'" -f2)"
    expectedTeamID="4F7N4UDA22"
    ;;
qlab)
    name="QLab"
    type="dmg"
    downloadURL="https://qlab.app/downloads/QLab.dmg"
    appNewVersion=$(curl -fs "https://qlab.app/appcast/v5/" | xpath 'string(//rss/channel[1]/item/enclosure/@sparkle:shortVersionString)')
    expectedTeamID="7672N4CCJM"
    ;;
r)
    name="R"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://cloud.r-project.org/bin/macosx/$( curl -fsL https://cloud.r-project.org/bin/macosx/ | grep -m 1 -o '<a href=".*arm64\.pkg">' | sed -E 's/.+"(.+)".+/\1/g' )"
        appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*\..*/\1/g')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://cloud.r-project.org/bin/macosx/$( curl -fsL https://cloud.r-project.org/bin/macosx/ | grep -o '<a href=".*pkg">' | grep -m 1 -v "arm64" | sed -E 's/.+"(.+)".+/\1/g' )"
        appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    fi
    expectedTeamID="VZLD955F6P"
    appCustomVersion() { defaults read /Applications/r.app/Contents/Info.plist CFBundleShortVersionString | awk '{print $2}' }
    ;;
raindropio)
    name="Raindrop.io"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        archiveName="Raindrop-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
        archiveName="Raindrop-arm64.dmg"
    fi

    downloadURL=$(downloadURLFromGit raindropio desktop )
    appNewVersion=$(versionFromGit raindropio desktop )
    expectedTeamID="7459JWM5TY"
    ;;
rancherdesktop)
    name="Rancher Desktop"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
      archiveName="Rancher.Desktop-[0-9.]*-mac.aarch64.zip"
      downloadURL="$(downloadURLFromGit rancher-sandbox rancher-desktop)"
    elif [[ $(arch) == "i386" ]]; then
      archiveName="Rancher.Desktop-[0-9.]*-mac.x86_64.zip"
      downloadURL="$(downloadURLFromGit rancher-sandbox rancher-desktop)"
    fi
    appNewVersion="$(versionFromGit rancher-sandbox rancher-desktop)"
    expectedTeamID="2Q6FHJR3H3"
    ;;
rapidapi)
    name="RapidAPI"
    type="zip"
    downloadURL="https://paw.cloud/download"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d '/' -f5 | awk -F '-' '{ print $2 }')"
    expectedTeamID="84599RL58A"
    ;;
rawtherapee)
    name="RawTherapee"
    type="appInDmgInZip"
    downloadURL=$(curl -fs "https://rawtherapee.com/downloads/" | grep -oE "https.*/builds/mac/.*\.zip")
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*mac.*Universal_([0-9.]*).zip/\1/')
    expectedTeamID="5SJ86G6Q2R"
    ;;
raycast)
    name="Raycast"
    type="dmg"
    downloadURL="https://www.raycast.com/download"
    appNewVersion="$( curl -fsIL "https://www.raycast.com/download" | grep -i ^location | grep Raycast_ | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )"
    expectedTeamID="SY64MV22J9"
    ;;
realvncondemandassist)
    name="On-Demand-Assist-$(curl -sL "https://www.realvnc.help/" | awk -F'"' '/Mac/ && /\.zip/{print $2}' | sed -n 's:.*generic/\(.*\)/.*:\1:p')-MacOSX-universal"
    type="zip"
    downloadURL=$(curl -sL "https://www.realvnc.help/" | awk -F'"' '/Mac/ && /\.zip/{print $2}')
    appNewVersion="$(echo $downloadURL | sed -n 's:.*generic/\(.*\)/.*:\1:p')"
    expectedTeamID="ZNCQ8JEH7X"
    blockingProcesses=( "On-Demand Assist" "$name" )
    appCustomVersion() { echo "$(defaults read "/Applications/On-Demand-Assist-$(curl -sL "https://www.realvnc.help/" | awk -F'"' '/Mac/ && /\.zip/{print $2}' | sed -n 's:.*generic/\(.*\)/.*:\1:p')-MacOSX-universal.app/Contents/Info.plist" CFBundleShortVersionString)" | sed 's/ ([^)]*)//' ; }
    ;;

vncconnect|\
realvncserver)
    name="Real VNC Server"
    appName="VNC Server.app"
    type="pkg"
    packageID="com.realvnc.vncserver.pkg"
    downloadURL="$(curl -sL https://www.realvnc.com/en/connect/download/vnc/ | grep -i 'download-link-path-macos' | sed -r 's/.*href="([^"]+).*/\1/g')"
    appNewVersion="$(echo ${downloadURL} | sed -n 's:.*VNC-Server-\(.*\)-MacOSX.*:\1:p')"
    expectedTeamID="ZNCQ8JEH7X"
    ;;
realvncviewer)
    name="Real VNC Viewer"
    appName="VNC Viewer.app"
    type="dmg"
    downloadURL="$(curl -sL https://www.realvnc.com/en/connect/download/viewer/ | grep -i 'download-link-path-macos' | sed -r 's/.*href="([^"]+).*/\1/g')"
    appNewVersion="$(echo $downloadURL | sed -n 's:.*VNC-Viewer-\(.*\)-MacOSX.*:\1:p')"
    expectedTeamID="ZNCQ8JEH7X"
    ;;
reaper)
    name="REAPER"
    type="dmg"
    appNewVersion="$(curl "https://www.reaper.fm/download.php" | grep -a1 "DOWNLOAD REAPER" | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,4\}[0-9][^.]\).*/\1/p')"
    downloadURL="https://www.reaper.fm/files/7.x/reaper$(echo $appNewVersion | tr -d '.')_universal.dmg"
    appCustomVersion(){ /usr/bin/defaults read "/Applications/REAPER.app/Contents/Info.plist" CFBundleShortVersionString | cut -d'.' -f1-2 }
    expectedTeamID="Y3T58622SG"
    ;;
rectangle)
    name="Rectangle"
    type="dmg"
    downloadURL=$(downloadURLFromGit rxhanson Rectangle)
    appNewVersion=$(versionFromGit rxhanson Rectangle)
    expectedTeamID="XSYZ3E4B7D"
    ;;
redcanarymacmonitor)
    name="Red Canary Mac Monitor"
    # Red Canary Mac Monitor is an advanced, stand-alone system monitoring tool tailor-made for macOS security research, malware triage, and system troubleshooting
    type="pkg"
    packageID="com.redcanary.agent"
    downloadURL="$(downloadURLFromGit redcanaryco mac-monitor)"
    appNewVersion="$(versionFromGit redcanaryco mac-monitor)"
    expectedTeamID="UA6JCQGF3F"
    ;;
redgiant)
    name="Red Giant"
    type="dmg"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redgiant/releases[^"]*\.dmg' | head -1)
    appNewVersion=$(sed -E 's/.*-([0-9.]*)-Mac\.dmg/\1/g' <<< "${downloadURL}")
    expectedTeamID="4ZY22YGXQG"
    appCustomVersion(){
        infoPlist="/Applications/Red Giant/Red Giant/uninstall.app/Contents/Info.plist"
        if [ -f "${infoPlist}" ];then
            defaults read "${infoPlist}" CFBundleVersion
        fi
    }
    installerTool="Red Giant Installer.app"
    CLIInstaller="Red Giant Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --unattendedmodeui none )
    ;;
redshift)
    name="redshift"
    blockingProcesses=( "Cinema 4D" )
    type="pkg"
    packageID="com.redshift3d.redshift"
    expectedTeamID="4ZY22YGXQG"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redshift[^"]*\.pkg' | head -1)
    appNewVersion=$(sed -n 's/.*redshift_\([^_]*\).*/\1/p' <<< "${downloadURL}")
    ;;
redshiftlite)
    name="redshift"
    blockingProcesses=( "Cinema 4D" )
    type="pkg"
    packageID="com.redshift3d.redshift"
    expectedTeamID="4ZY22YGXQG"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redshift[^"]*min\.pkg' | head -1)
    appNewVersion=$(sed -n 's/.*redshift_\([^_]*\).*/\1/p' <<< "${downloadURL}")
    ;;
reflector4)
    name="Reflector 4"
    type="dmg"
    downloadURL=$(curl -fs https://www.airsquirrels.com/reflector/try | grep -i dmg | grep -o -i -E "https.*" | cut -d '"' -f1)
    appNewVersion=$(echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="67X2M9MT5G"
    ;;
relatel)
    name="Relatel"
    type="dmg"
    downloadURL="https://cdn.rela.tel/www/public/junotron/Relatel.dmg"
    appNewVersion="$(curl -fs "https://cdn.firmafon.dk/www/public/junotron/latest-mac.yml" | grep -i "version" | cut -w -f2)"
    expectedTeamID="B9358QF55B"
    ;;
remotedesktopmanagerenterprise)
    name="Remote Desktop Manager"
    type="dmg"
    downloadURL=$(curl -fsL https://devolutions.net/remote-desktop-manager/download/thank-you/ | sed -n 's/.*"RDMMacbin\.Url":"\([^"]*\)".*/\1/p' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\.Mac\.([0-9.]*)\.dmg/\1/g')
    expectedTeamID="N592S9ASDB"
    blockingProcesses=( "$name" )
    ;;
remotedesktopmanagerfree)
    name="Remote Desktop Manager"
    type="dmg"
    downloadURL=$(curl -fsL https://devolutions.net/remote-desktop-manager/home/thankyou/rdmmacbin/ | grep -oe "http.*\.dmg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\.Mac\.([0-9.]*)\.dmg/\1/g')
    expectedTeamID="N592S9ASDB"
    ;;
renew-noagent)
    #Renew by @BigMacAdmin and Second Son Consulting
    name="Renew-NoAgent"
    type="pkg"
    archiveName="Renew_NoAgent_v[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit secondsonconsulting Renew )
    appNewVersion=$(versionFromGit secondsonconsulting Renew )
    appCustomVersion() { grep -i "scriptVersion=" /usr/local/Renew.sh | cut -d '"' -f2 }
    expectedTeamID="7Q6XP5698G"
    ;;
renew)
    #Renew by @BigMacAdmin and Second Son Consulting
    name="Renew"
    type="pkg"
    archiveName="Renew_v[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit secondsonconsulting Renew )
    appNewVersion=$(versionFromGit secondsonconsulting Renew )
    appCustomVersion() { grep -i "scriptVersion=" /usr/local/Renew.sh | cut -d '"' -f2 }
    expectedTeamID="7Q6XP5698G"
    ;;
resiliosynchome)
    name="Resilio Sync"
    type="dmg"
    downloadURL="https://download-cdn.resilio.com/stable/osx/Resilio-Sync.dmg"
    expectedTeamID="2953Z5SZSK"
    ;;
retrobatch)
    name="Retrobatch"
    type="zip"
    downloadURL="https://flyingmeat.com/download/Retrobatch.zip"
    appNewVersion=$(curl -fs "https://flyingmeat.com/retrobatch/" | grep -i download | grep -i zip | grep -iv Documentation | sed -E 's/.*Download.*href.*https.*zip.*Retrobatch ([0-9.]*)<.*/\1/g')
    expectedTeamID="WZCN9HJ4VP"
    ;;
rhino7)
    name="Rhino 7"
    type="dmg"
    sparkleFeed=$(curl -fs "https://files.mcneel.com/rhino/7/mac/updates/commercialUpdates.xml")
    appNewVersion=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString[1]' 2>/dev/null | cut -d '"' -f 2 | cut -d ' ' -f 1)
    downloadURL=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="D6XDM4N99E"
    ;;
rhino8)
    name="Rhino 8"
    type="dmg"
    sparkleFeed=$(curl -fs "https://files.mcneel.com/rhino/8/mac/updates/commercialUpdates.xml")
    appNewVersion=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2 | cut -d ' ' -f 1)
    downloadURL=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="D6XDM4N99E"
    ;;
ricohpsprinters)
    name="Ricoh Printers"
    type="pkgInDmg"
    packageID="com.RICOH.print.PS_Printers_Vol4_EXP.ppds.pkg"
    downloadURL=$(curl -fs https://support.ricoh.com//bb/html/dr_ut_e/rc3/model/mpc3004ex/mpc3004exen.htm | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*.dmg" | cut -d '"' -f 1)
    expectedTeamID="5KACUT3YX8"
    ;;
ringcentralapp)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="RingCentral"
    appNewVersion=$(curl -fs https://support.ringcentral.com/gb/en/release-notes/ringex/desktop.html | grep -i -m1 "<div>Version" | sed 's/[^0-9\.]//g')
    appCustomVersion() { defaults read /Applications/RingCentral.app/Contents/Info.plist CFBundleShortVersionString  | cut -c-7 }
    type="pkg"
    if [[ $(arch) != "i386" ]]; then
        downloadURL="https://app.ringcentral.com/download/RingCentral-arm64.pkg"
    else
        downloadURL="https://app.ringcentral.com/download/RingCentral.pkg"
    fi
    expectedTeamID="M932RC5J66"
    ;;
ringcentralclassicapp)
    name="Glip"
    type="dmg"
    downloadURL="https://downloads.ringcentral.com/glip/rc/GlipForMac"
    expectedTeamID="M932RC5J66"
    ;;
ringcentralmeetings)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Ring Central Meetings"
    type="pkg"
    downloadURL="http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsClientSetup.pkg"
    expectedTeamID="M932RC5J66"
    blockingProcesses=( "RingCentral Meetings" )
    ;;
ringcentralphone)
    # credit: Eric Gjerde, When I Work (@ericgjerde)
    name="RingCentral for Mac"
    type="dmg"
    downloadURL="https://downloads.ringcentral.com/sp/RingCentralForMac"
    expectedTeamID="M932RC5J66"
    blockingProcesses=( "RingCentral Phone" )
    ;;
rocket)
    name="Rocket"
    type="dmg"
    rocketFeed=$(curl -fsL "https://macrelease.matthewpalmer.net/distribution/appcasts/rocket.xml")
    appNewVersion=$(echo "${rocketFeed}" | xpath 'string(//rss/channel/item[last()]/title)' 2>/dev/null)
    downloadURL=$(echo "${rocketFeed}" | xpath 'string(//rss/channel/item[last()]/enclosure/@url)' 2>/dev/null)
    expectedTeamID="Z4JV2M65MH"
    ;;
rocketchat)
    name="Rocket.Chat"
    type="dmg"
    downloadURL=$(downloadURLFromGit RocketChat Rocket.Chat.Electron)
    appNewVersion=$(versionFromGit RocketChat Rocket.Chat.Electron)
    expectedTeamID="S6UPZG7ZR3"
    blockingProcesses=( Rocket.Chat )
    ;;
rodecentral)
    name="RODE Central"
    type="pkgInZip"
    #packageID="com.rodecentral.installer"
    downloadURL="https://update.rode.com/central/RODE_Central_MACOS.zip"
    appNewVersion=$(curl -fs https://rode.com/en/release-notes/rode-central | xmllint --html --format - 2>/dev/null | tr '"' '\n' | sed 's/\&quot\;/\n/g' | grep -i -o "Version .*" | cut -w -f2 | tail -n +2 | head -1)
    expectedTeamID="Z9T72PWTJA"
    ;;
rodeconnect)
    name="RODE Connect"
    type="pkgInZip"
    #packageID="com.rodeconnect.installer" #Versioned wrong as 0 in 1.1.0 pkg
    downloadURL="https://update.rode.com/connect/RODE_Connect_MACOS.zip"
    appNewVersion=$(curl -fs https://rode.com/en/release-notes/rode-connect | xmllint --html --format - 2>/dev/null | tr '"' '\n' | sed 's/\&quot\;/\n/g' | grep -i -o "Version .*" | head -1 | cut -w -f2)
    expectedTeamID="Z9T72PWTJA"
    ;;
rodeunify)
    name="RODE UNIFY"
    type="pkgInZip"
    #packageID="com.rodecentral.installer"
    downloadURL="https://update.rode.com/unify_new/macos/RODE_UNIFY_MACOS.zip"
    appNewVersion=$(curl -fs https://rode.com/en/release-notes/unify | xmllint --html --format - 2>/dev/null | tr '"' '\n' | sed 's/\&quot\;/\n/g' | grep -i -o "Version .*" | head -1 | cut -w -f2)
    expectedTeamID="Z9T72PWTJA"
    ;;
rogueamoebaaudiohijack4)
    name="Audio Hijack"
    type="zip"
    raSysVer="$(sw_vers -productVersion | sed 's/\.//g')"
    raVerDetails="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.audiohijack&system=${raSysVer}&version=40000000")"
    downloadURL="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;
rogueamoebafission2)
    name="Fission"
    type="zip"
    raSysVer="$(sw_vers -productVersion | sed 's/\.//g')"
    raVerDetails="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.Fission&system=${raSysVer}&version=20000000")"
    downloadURL="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;
rogueamoebaloopback2)
    name="Loopback"
    type="zip"
    raSysVer="$(sw_vers -productVersion | sed 's/\.//g')"
    raVerDetails="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.Loopback&system=${raSysVer}&version=20000000")"
    downloadURL="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;
rogueamoebasoundsource5)
    name="SoundSource"
    type="zip"
    raSysVer="$(sw_vers -productVersion | sed 's/\.//g')"
    raVerDetails="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.soundsource&system=${raSysVer}&version=5000000")"
    downloadURL="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;
royaltsx)
    name="Royal TSX"
    type="dmg"
    downloadURL=$(curl -fs https://royaltsx-v6.royalapps.com/updates_stable | xpath '//rss/channel/item[1]/enclosure/@url'  2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://royaltsx-v6.royalapps.com/updates_stable | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString'  2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="VXP8K9EDP6"
    ;;
rstudio)
    name="RStudio"
    type="dmg"
    downloadURL=$(curl -s -L "https://posit.co/download/rstudio-desktop/" | grep -m 1 -Eio 'href="https://download1.rstudio.org/electron/macos/RStudio-(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.-]*)\..*/\1/g' | sed 's/-/+/' )
    expectedTeamID="FYF2F5GFX4"
    ;;
rustdesk)
    name="RustDesk"
    type="dmg"
    downloadURL=$(downloadURLFromGit rustdesk rustdesk)
    appNewVersion=$(versionFromGit rustdesk rustdesk)
    archiveName="rustesk-$appNewVersion.dmg"
    expectedTeamID="HZF9JMC8YN"
    ;;
safeexambrowser)
    name="Safe Exam Browser"
    type="dmg"
    packageID="org.safeexambrowser.SafeExamBrowser"
    downloadURL=$(downloadURLFromGit SafeExamBrowser seb-mac )
    appNewVersion=$(versionFromGit SafeExamBrowser seb-mac )
    expectedTeamID="6F38DNSC7X"
    blockingProcesses=( NONE )
    ;;
salesforcecli)
    name="Salesforce CLI"
    type="pkg"
    packageID="com.salesforce.cli"
    if [[ $(arch) == "arm64" ]]; then
    downloadURL="https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-arm64.pkg"
    elif [[ $(arch) == "i386" ]]; then
    downloadURL="https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-x64.pkg"
    fi
    appNewVersion=$( curl -fsL https://raw.githubusercontent.com/forcedotcom/cli/main/releasenotes/README.md | grep -iF  "[stable]"  | grep -i "[##]" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g'  )
    expectedTeamID="62J96EUJ9N"
    blockingProcesses=( NONE )
    ;;
santa)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Santa"
    type="pkgInDmg"
    packageID="com.google.santa"
    downloadURL=$(downloadURLFromGit google santa)
    appNewVersion=$(versionFromGit google santa)
    expectedTeamID="EQHXZ8M8AV"
    ;;
keyaccess)
    name="KeyAccess"
    type="pkg"
    downloadStore="$(curl -sL "http://www.sassafras.com/client-download/" | tr '>' '\n')"
    downloadURL="$(echo "$downloadStore" | grep "https.*ksp-client.*pkg" | cut -d '"' -f 2)"
    appNewVersion="$(echo "$downloadStore" | grep "KeyAccess.*for Mac" | cut -d ' ' -f 2)"
    expectedTeamID="7Z2KSDFMVY"
    BLOCKING_PROCESS_ACTION=ignore
    blockingProcesses=( NONE )
    # Application is not installed in /Applications
    appName="Library/KeyAccess/KeyAccess.app"
    # Don't forget to at least set the host, or nothing will happen.
    # defaults write /Library/Preferences/com.sassafras.KeyAccess host -string "host.name"
    ;;
sawgrassprintutility)
    name="Sawgrass Print Utility"
    type="dmg"
    downloadURL="https://print.sawgrassink.com/SawgrassPrintUtility.dmg"
    appNewVersion=$(curl -fsL https://pm-dist-channel.s3.amazonaws.com/latest-mac.yml | grep "version" | cut -d " " -f 2)
    expectedTeamID="2DD4HMHX5K"
    ;;
scaleft)
    name="ScaleFT"
    type="pkg"
    downloadURL="https://dist.scaleft.com/repos/macos/stable/all/macos-client/$(curl -s "https://dist.scaleft.com/repos/macos/stable/all/macos-client/" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -V | tail -n 1)/ScaleFT-$(curl -s "https://dist.scaleft.com/repos/macos/stable/all/macos-client/" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -V | tail -n 1 | sed 's/^v//').pkg"
    appNewVersion=$(curl -s "https://dist.scaleft.com/repos/macos/stable/all/macos-client/" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -V | tail -n 1 | sed 's/^v//')
    expectedTeamID="B7F62B65BN"
    blockingProcesses=( ScaleFT )
    ;;
scapple)
    name="Scapple"
    type="dmg"
    downloadURL="https://scrivener.s3.amazonaws.com/Scapple.dmg"
    appNewVersion="$(curl -fs "https://scrivener.s3.amazonaws.com/mac_updates/scapple.xml" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="W4QTL7X778"
    ;;
scenebuilder)
    name="SceneBuilder"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -sfL "https://gluonhq.com/products/scene-builder/" | xmllint --html --format - 2>/dev/null | grep -o "https://.*SceneBuilder.*aarch64.dmg")
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -sfL "https://gluonhq.com/products/scene-builder/" | xmllint --html --format - 2>/dev/null | grep -o "https://.*SceneBuilder.*amd64.dmg")
    fi
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="S7ZR395D8U"
    ;;
scmenu)
    name="SC Menu"
    type="dmg"
    downloadURL="$(downloadURLFromGit boberito sc_menu)"
    appNewVersion="$(versionFromGit boberito sc_menu)"
    expectedTeamID="2WUMX954UB"
    ;;
screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        platform="x86_64"
    elif [[ $(arch) == arm64 ]]; then
        platform="aarch64"
    fi
    appNewVersion=$(curl -fs "https://download.screamingfrog.co.uk/products/seo-spider/getlatestversion.php")
    downloadURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-${appNewVersion}-${platform}.dmg"
    expectedTeamID="CAHEVC3HZC"
    ;;
screencloudplayer)
    name="ScreenCloud Player"
    type="dmg"
    downloadURL=$(curl -fs "https://screencloud.com/download" | sed -n 's/^.*"url":"\(https.*\.dmg\)".*$/\1/p')
    appNewVersion=$( echo $downloadURL | sed -e 's/.*\/ScreenCloud.*\-\([0-9.]*\)\.dmg/\1/g' )
    expectedTeamID="3C4F953K6P"
    ;;
screenflick)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Screenflick"
    type="zip"
    downloadURL="https://www.araelium.com/screenflick/downloads/Screenflick.zip"
    expectedTeamID="28488A87JB"
    ;;
scribus)
    name="Scribus"
    type="dmg"
    appNewVersion=$(curl -fsL "https://sourceforge.net/projects/scribus/rss?path=/scribus" | xpath '//rss/channel/item[1]/title' 2>/dev/null | awk -F'/' '{ print $3 }')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/scribus/rss?path=/scribus/${appNewVersion}" | grep -oE '<link>(.*-arm64.dmg/download)</link>' | head -1 |  sed 's/<link>//;s/<\/link>//')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/scribus/rss?path=/scribus/${appNewVersion}" | grep -oE '<link>(.*\.dmg/download)</link>' | grep -v '\-arm64' | head -1 | sed 's/<link>//;s/<\/link>//')
    fi
    expectedTeamID="627FV4LMG7"
    ;;
scrollreverser)
    name="Scroll Reverser"
    type="zip"
    downloadURL=$(downloadURLFromGit pilotmoon Scroll-Reverser)
    appNewVersion=$(versionFromGit pilotmoon Scroll-Reverser)
    expectedTeamID="6W6K75YWQ9"
    ;;
sdnotary)
    name="SD Notary"
    type="zip"
    downloadURL=$(curl -fs https://latenightsw.com/sd-notary-notarizing-made-easy/ | grep -io "https://.*/.*\.zip")
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\/[a-zA-Z]*([0-9.]*)-.*\.zip/\1/g')
    expectedTeamID="Z7S6X96M3X"
    ;;
secretive)
    name="Secretive"
    type="zip"
    downloadURL=$(downloadURLFromGit maxgoedjen secretive)
    appNewVersion=$(versionFromGit maxgoedjen secretive)
    expectedTeamID="Z72PRUAWF6"
    ;;
    
selfcontrol)
    name="SelfControl"
    type="zip"
    downloadURL=$(curl -fs https://update.selfcontrolapp.com/feeds/selfcontrol | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://update.selfcontrolapp.com/feeds/selfcontrol | xpath '//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    expectedTeamID="EG6ZYP3AQH"
    ;;
sequelace)
    name="Sequel Ace"
    type="zip"
    downloadURL="$(downloadURLFromGit sequel-ace sequel-ace)"
    appNewVersion="$(versionFromGit sequel-ace sequel-ace)"
    expectedTeamID="NKQ4HJ66PX"
    ;;
sequelpro)
    name="Sequel Pro"
    type="dmg"
    downloadURL="$(downloadURLFromGit sequelpro sequelpro)"
    appNewVersion="$(versionFromGit sequelpro sequelpro)"
    expectedTeamID="Media"
    ;;
shield)
    # credit: Søren Theilgaard (@theilgaard)
    name="Shield"
    type="zip"
    downloadURL=$(downloadURLFromGit theevilbit Shield)
    appNewVersion=$(versionFromGit theevilbit Shield)
    expectedTeamID="33YRLYRBYV"
    ;;
shotcut)
    name="shotcut"
    type="dmg"
    appNewVersion=$(curl -fsL https://www.shotcut.org/download/releasenotes | grep 'release-' | head -n 1 | cut -d '"' -f 2 | cut -d '-' -f 2)
    appCustomVersion() { echo "$(/usr/bin/defaults read "/Applications/shotcut.app/Contents/Info.plist" "CFBundleVersion" | sed -r 's/[.]//g')" }
    archiveName="shotcut-macos-$appNewVersion.dmg"
    downloadURL=$(downloadURLFromGit mltframework shotcut)
    expectedTeamID="Y6RX44QG2G"
    ;;
shottr)
    name="Shottr"
    type="dmg"
    downloadURL="https://shottr.cc$(curl -fs "https://shottr.cc/newversion.html" | grep -o '\/dl\/Shottr-[0-9].[0-9].[0-9]\.dmg' | head -1 | xargs)"
    appNewVersion=$(echo $downloadURL | grep -o '[0-9].[0-9].[0-9]' | xargs)
    expectedTeamID="2Y683PRQWN"
    ;;
sidekick)
    name="Sidekick"
    type="dmg"
    downloadURL="https://api.meetsidekick.com/downloads/df/mac"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/.*-x64-([0-9.]*)-.*/\1/g' )
    expectedTeamID="N975558CUS"
    ;;
signal)
    name="Signal"
    type="dmg"
    downloadURL=https://updates.signal.org/desktop/$(curl -fs https://updates.signal.org/desktop/latest-mac.yml | awk '/url/ && /dmg/ {print $3}' | grep -i universal)
    appNewVersion=$(curl -fs https://updates.signal.org/desktop/latest-mac.yml | grep version | awk '{print $2}')
    expectedTeamID="U68MSDN6DR"
    ;;
signiantapp)
    name="Signiant App"
    type="dmg"
    downloadURL="https://updates.signiant.com/signiant_app/$(curl -fs "https://updates.signiant.com/signiant_app/signiant-app-info-mac.json" | grep -o '"file": *"[^"]*"' | awk -F '"' '{print $4}')"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*Signiant_App_([0-9]+(\.[0-9]+)*)\.dmg/\1/')"
    expectedTeamID="U6ZZ4QLU4Q"
    ;;
silnite)
    # credit: Søren Theilgaard (@theilgaard)
    name="silnite"
    type="pkgInZip"
    downloadURL=$(curl -fs https://eclecticlight.co/downloads/ | grep -i $name | grep zip | sed -E 's/.*href=\"(https.*)\">.*/\1/g')
    appNewVersion=$(curl -fs https://eclecticlight.co/downloads/ | grep zip | grep -o -E "silnite [0-9.]*" | awk '{print $2}')
    expectedTeamID="QWY4LRW926"
    blockingProcesses=( NONE )
    ;;
sipgateclinq)
    name="Sipgate CLINQ"
    type="dmg"
    appNewVersion=$(curl -fs -L https://desktop.download.sipgate.com/latest-mac.yml | sed -n 's/version: \(.*\)/\1/p')
    downloadURL="https://desktop.download.sipgate.com/sipgate%20CLINQ-${appNewVersion}.dmg"
    expectedTeamID="K4L4M6DD76"
;;

sirimote)
    name="SiriMote"
    type="zip"
    downloadURL="http://bit.ly/sirimotezip"
    #appNewVersion="" # Not found on web page
    expectedTeamID="G78RJ6NLJU"
    ;;
sizeup)
    # credit: AP Orlebeke (@apizz)
    name="SizeUp"
    type="zip"
    downloadURL="https://www.irradiatedsoftware.com/download/SizeUp.zip"
    appNewVersion=$(curl -fs https://www.irradiatedsoftware.com/updates/notes/SizeUpReleaseNotes.html | grep Version | sed -E 's/.*Version ([0-9.]*) <.*/\1/')
    expectedTeamID="GVZ7RF955D"
    ;;
sketch)
    name="Sketch"
    type="zip"
    downloadURL=$(curl -sf https://www.sketch.com/downloads/mac/ | grep 'href="https://download.sketch.com' | tr '"' "\n" | grep -E "https.*.zip")
    appNewVersion=$( grep -oE '\d+\.\d+' <<< $downloadURL)
    expectedTeamID="WUGMZZ5K46"
    ;;
sketchupviewer)
    name="SketchUpViewer"
    type="dmg"
    downloadURL="$(curl -Lfs https://www.sketchup.com/en/sketchup-viewer/downloads | grep -o 'https://download.sketchup.com/SketchUpViewer[0-9\-]*.dmg')"
    expectedTeamID="J8PVMCY7KL"
    ;;
skim)
    name="Skim"
    type="dmg"
    downloadURL="$(curl -fsL "https://skim-app.sourceforge.io/skim.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fsL "https://skim-app.sourceforge.io/skim.xml" | xpath '//rss/channel/item[1]/title' 2>/dev/null | sed -n 's/.*Version \([^<]*\)<\/title>.*/\1/p')"
    expectedTeamID="J33JTA7SY9"
    ;;

skype)
    name="Skype"
    type="dmg"
    downloadURL=$(curl -sfi https://get.skype.com/go/getskype-skypeformac | awk 'BEGIN{IGNORECASE=1} /location:/ {gsub(/\r/,"",$2); print $2}')
    archiveName=$(basename "$downloadURL")
    appNewVersion=$(awk -F'[-.]' '{print $2"."$3"."$4"."$5}' <<< "$archiveName")
    versionKey="CFBundleVersion"
    blockingProcesses=( "Skype" , "Skype Helper" )
    expectedTeamID="AL798K98FX"
    ;;
slab)
    name="Slab"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
       archiveName="Slab-[0-9.]*-darwin-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
       archiveName="Slab-[0-9.]*-darwin-arm64.dmg"
    fi
    downloadURL=$(downloadURLFromGit slab desktop-releases)
    appNewVersion=$(versionFromGit slab desktop-releases)
    expectedTeamID="Q67SW996Z5"
    ;;
slack)
    name="Slack"
    type="dmg"
    downloadURL="https://slack.com/ssb/download-osx-universal"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | cut -d "/" -f7 )
    expectedTeamID="BQR82RBBHL"
    ;;
sloth)
	# Shows all open files, directories, sockets, and devices used by running processes, offering detailed insights and management capabilities in a user-friendly interface.
    name="Sloth"
    type="zip"
    archiveName="sloth-[0-9.]*.zip"
    downloadURL=$(downloadURLFromGit sveinbjornt Sloth)
    appNewVersion=$(versionFromGit sveinbjornt Sloth)
    expectedTeamID="5WX26Y89JP"
    ;;
smartgit)
    name="SmartGit"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
    downloadURL="https://www.syntevo.com$(curl -fs "https://www.syntevo.com/smartgit/download/" | grep -i -o -E "/downloads/.*/smartgit.*\.dmg" | tail -1)"
    elif [[ $(arch) == "i386" ]]; then
    downloadURL="https://www.syntevo.com$(curl -fs "https://www.syntevo.com/smartgit/download/" | grep -i -o -E "/downloads/.*/smartgit.*\.dmg" | head -1)"
    fi
    appNewVersion="$(curl -fs "https://www.syntevo.com/smartgit/changelog.txt" | grep -i -E "SmartGit *[0-9.]* *.*" | head -1 | awk '{print $2}')"
    expectedTeamID="PHMY45PTNW"
    ;;
smartsheet)
	name="Smartsheet"
	type="dmg"
	downloadURL="https://smartsheet-desktop-app-builds.s3.amazonaws.com/public/darwin/Smartsheet-setup.dmg"
	appNewVersion=$(curl -fsl 'https://smartsheet-desktop-app-builds.s3.amazonaws.com/public/darwin/latest-mac.yml' | sed -nE 's/^version: (.*)/\1/p')
	expectedTeamID="J89ET3PY68"
	;;
smartsvn)
    name="SmartSVN"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.smartsvn.com$(curl -fsL "https://www.smartsvn.com/download/" | grep -oE "href=\".*-aarch64.*\.dmg\"" | cut -d '"' -f 2)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://www.smartsvn.com$(curl -fsL "https://www.smartsvn.com/download/" | grep -oE "href=\".*-x86_64.*\.dmg\"" | cut -d '"' -f 2)"
    fi
    appNewVersion=$(curl -fsL "https://www.smartsvn.com/download/" | grep -B 1 "changelog.txt" | grep "Version " | awk -F' ' '{ print $2 }')
    expectedTeamID="PHMY45PTNW"
    ;;
snagit|\
snagit2024)
    name="Snagit 2024"
    type="dmg"
    sparkleData=$(curl -fsL 'https://www.techsmith.com/redirect.asp?target=sufeedurl&product=snagitmac&ver=2024.0.0&lang=enu&os=mac')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item[last()]/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item[last()]/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
snagit2019)
    name="Snagit 2019"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Snagit (Mac) 2019" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Snagit (Mac) 2019" | sed -e 's/.*Snagit (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
snagit2020)
    name="Snagit 2020"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Snagit (Mac) 2020" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Snagit (Mac) 2020" | sed -e 's/.*Snagit (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
snagit2021)
    name="Snagit 2021"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Snagit (Mac) 2021" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Snagit (Mac) 2021" | sed -e 's/.*Snagit (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
snagit2022)
    name="Snagit 2022"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Snagit (Mac) 2022" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Snagit (Mac) 2022" | sed -e 's/.*Snagit (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
snagit2023)
    name="Snagit 2023"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Snagit (Mac) 2023" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Snagit (Mac) 2023" | sed -e 's/.*Snagit (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
snapgene|snapgeneviewer)
    name="SnapGene"
    type="dmg"
    downloadURL="https://www.snapgene.com/local/targets/download.php?os=mac&majorRelease=latest&minorRelease=latest"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr '/' '\n' | grep -i "dmg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_mac\.dmg/\1/g' )
    expectedTeamID="WVCV9Q8Y78"
    ;;
soapuiopensource)
    name="SoapUI"
    type="dmg"
    downloadURL="$(curl -fsL "https://github.com/SmartBear/soapui/releases/latest" | grep -m 1 -o 'href=".*\.dmg".*' | cut -d '"' -f 2)"
    appNewVersion="$(versionFromGit SmartBear soapui)"
    appCustomVersion() {
        while IFS= read -r line; do
            soapUIApps+=("$line")
        done < <(ls -d ${targetDir}/* | grep -E "SoapUI-.*\.app")

        if [ -e "${soapUIApps[-1]}" ]; then
            defaults read "${soapUIApps[-1]}/Contents/Info.plist" CFBundleShortVersionString
        fi
    }
    installerTool="SoapUI ${appNewVersion} Installer.app"
    CLIInstaller="${installerTool}/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q)
    expectedTeamID="HVA5GNL2LF"
    ;;
sococo)
    name="Sococo"
    type="dmg"
    downloadURL="https://s.sococo.com/rs/client/mac/sococo-client-mac.dmg"
    appNewVersion=""
    expectedTeamID="MR43LR5EJ4"
    ;;
softubecentral)
    name="Softube Central"
    type="pkg"
    packageID="org.softube.com.softubecentral"
    appNewVersion="$(curl -fs "https://www.softube.com/installers" | grep "mac-version=" | cut -d\" -f2 | xargs)"
    downloadURL="https://softubestorage.b-cdn.net/softubecentraldata/softubecentral/Softube%20Central-${appNewVersion}-universal.pkg"
    expectedTeamID="MQ5XL2PNWK"
    ;;
solstice)
    name="Mersive Solstice"
    type="dmg"
    downloadURL="https://www.mersive.com/files/41693/"
    expectedTeamID="63B5A5WDNG"
    ;;
sonicvisualiser)
    name="Sonic Visualiser"
    type="dmg"
    downloadURL="$(downloadURLFromGit sonic-visualiser sonic-visualiser)"
    appNewVersion="$(versionFromGit sonic-visualiser sonic-visualiser)"
    expectedTeamID="73F996B92S"
    ;;
sonobus)
    name="Sonobus"
    type="pkgInDmg"
    html_page_source="$(curl -fs 'https://www.sonobus.net')"
    downloadFile="$(echo "${html_page_source}" | xmllint --html --xpath "string(//a[contains(@href, 'mac.dmg')]/@href)" - 2> /dev/null)"
    downloadURL="https://www.sonobus.net/$downloadFile"
    appNewVersion="$(echo "${downloadFile}" | sed 's/releases\/sonobus-//' | sed 's/\-mac.dmg//' )"
    expectedTeamID="XCS435894D"
    ;;
sonos|\
sonoss1)
    # credit: Erik Stam (@erikstam)
    name="Sonos S1 Controller"
    type="dmg"
    downloadURL="https://www.sonos.com/redir/controller_software_mac"
    expectedTeamID="2G4LW83Q3E"
    ;;
sonoss2)
    name="Sonos"
    type="dmg"
    downloadURL="https://www.sonos.com/redir/controller_software_mac2"
    expectedTeamID="2G4LW83Q3E"
    ;;
soundly-placeit)
    name="Placeit"
    # Other Tools: https://getsoundly.com/tools/
    type="pkg"
    downloadURL="https://storage.googleapis.com/soundly-plugins/Placeit.pkg"
    #appNewVersion=""
    expectedTeamID="67Y6N7VTDG"
    ;;
soundly)
    name="Soundly"
    # From: https://getsoundly.com
    # Cheat Sheet: https://getsoundly.com/cheatsheet/Soundly-Cheatsheet-Mac.pdf
    type="dmg"
    if [[ $(arch) == i386 ]]; then
    downloadURL="https://storage.googleapis.com/soundlyapp/Soundly.dmg"
    elif [[ $(arch) == arm64 ]]; then
    downloadURL="https://storage.googleapis.com/soundlyapp/arm/Soundly.dmg"
    fi
    #appNewVersion=""
    expectedTeamID="67Y6N7VTDG"
    ;;
sourcetree)
    name="Sourcetree"
    type="zip"
    atlassianDetails="$(curl -fs "https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcast.xml")"
    appNewVersion="$(echo "${atlassianDetails}"| xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    downloadURL="$(echo "${atlassianDetails}"| xpath 'string(//rss/channel/item[last()]/enclosure/@url)' 2>/dev/null)"
    expectedTeamID="UPXU4CQZ5P"
    ;;
spark)
    name="Spark"
    type="dmg"
    downloadURL="$(curl -fsL https://sparkmailapp.com/download | grep -m 1 -o "https.*dmg")"
    versionKey="CFBundleVersion"
    appNewVersion="$(echo $downloadURL | awk -F'/' '{ print $(NF-1) }')"
    appName="Spark Desktop.app"
    expectedTeamID="3L68KQB4HG"
    ;;
splashtopbusiness)
    name="Splashtop Business"
    type="pkgInDmg"
    splashtopbusinessVersions=$(curl -fsL "https://www.splashtop.com/wp-content/themes/responsive/downloadx.php?product=stb&platform=mac-client")
    downloadURL=$(curl -Ls -w %{url_effective} -o /dev/null $(getJSONValue "$splashtopbusinessVersions" "url"))
    appNewVersion="${${downloadURL#*INSTALLER_v}%*.dmg}"
    expectedTeamID="CPQQ3AW49Y"
    ;;
splashtopsos)
    name="Splashtop SOS"
    type="dmg"
    downloadURL="https://download.splashtop.com/sos/SplashtopSOS.dmg"
    expectedTeamID="CPQQ3AW49Y"
    ;;
splashtopstreamer)
    name="Splashtop Streamer"
    type="pkgInDmg"
    downloadURL=$(curl -fsLI "https://my.splashtop.com/csrs/mac" | grep -i '^location:' | tail -n 1 | cut -d ' ' -f 2 | tr -d '\r')
    appNewVersion=$(echo $downloadURL | sed -E 's/.*_v([0-9.]+).dmg/\1/')
    expectedTeamID="CPQQ3AW49Y"
    ;;
splice)
    name="Splice"
    type="zip"
    if [[ "$(arch)" == "arm64" ]]; then
        appNewVersion=$(getJSONValue "$(curl -fs 'https://api.splice.com/v2/desktop/darwin/stable/latest?v=1.0.0&architecture=arm64')" "name")
        downloadURL="https://desktop.splice.com/darwin/stable/arm64/Splice.app.zip"
    else
        appNewVersion=$(getJSONValue "$(curl -fs 'https://api.splice.com/v2/desktop/darwin/stable/latest?v=1.0.0&architecture=x64')" "name")
        downloadURL="https://desktop.splice.com/darwin/stable/x64/Splice.app.zip"
    fi
    expectedTeamID="9962T6AKMH"
    ;;
spotify)
    name="Spotify"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://download.scdn.co/SpotifyARM64.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://download.scdn.co/Spotify.dmg"
    fi
    appNewVersion=$(curl -fs https://www.spotify.com/us/opensource/ | sed 's/","/\n/g' | grep "clientVersion" | sed -e 's/clientVersion":"\(.*\)"}.*bz2/\1/' | head -1 | awk -F "." '{print$1"."$2"."$3"."$4}')
    expectedTeamID="2FNC3A47ZF"
    ;;
sqldeveloper)
    name="SQLDeveloper"
    type="zip"
    downloadURL="https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-24.3.1.347.1826-macos-aarch64.app.zip"
    appNewVersion="$(plutil -p /Applications/SQLDeveloper.app/Contents/Info.plist | grep CFBundleShortVersionString | awk -F'"' '{print $4}')"
    expectedTeamID="VB5E2TV963"
    ;;
sqlitebrowser)
    name="DB Browser for SQLite"
    type="dmg"
    downloadURL=$(downloadURLFromGit sqlitebrowser sqlitebrowser)
    appNewVersion=$(versionFromGit sqlitebrowser sqlitebrowser)
    expectedTeamID="C34AV33YLK"
;;
sqlpropostgres)
    name="SQLPro for Postgres"
    type="zip"
    downloadURL="https://macpostgresclient.com/download.php"
    expectedTeamID="LKJB72232C"
    ;;
sqlprostudio)
    name="SQLPro Studio"
    type="zip"
    downloadURL="https://www.sqlprostudio.com/download.php"
    expectedTeamID="LKJB72232C"
    ;;
starface72x)
    name="STARFACE"
    # Downloads the latest 7.2.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="zip"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "7.2" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "7.2" | cut -d '"' -f 2 | cut -d '-' -f 4 | sed 's/\(.*\).zip/\1/')
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;
starface73x)
    name="STARFACE"
    # Downloads the latest 7.3.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="dmg"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "7.3" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "7.3" | cut -d '"' -f 2 | cut -d '-' -f 4 | sed 's/\(.*\).dmg/\1/')
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;
starface81x)
    name="STARFACE"
    # Downloads the latest 8.1.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="dmg"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure' | grep -m 1 "8.1" | sed 's/.*url\(.*\).dmg/\1/' | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure' | grep -m 1 "8.1" | sed 's/.*sparkle:version\(.*\) type/\1/' | cut -d '"' -f 2)
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;
starface90x)
    name="STARFACE"
    # Downloads the latest 9.0.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="dmg"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure ' | grep -i 'url=' | grep -m 1 "9.0" | cut -d '"' -f 10)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure ' | grep -i 'url=' | grep -m 1 "9.0" | cut -d '"' -f 4)
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;
starfaceuccclient)
    name="STARFACE UCC Client"
    # Downloads the latest 6.7.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="zip"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "STARFACE_UCC_Client_6.7" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "STARFACE_UCC_Client_6.7" | cut -d '"' -f 2 | sed -e 's/.*-\(.*\).zip*/\1/')
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;
stats)
    name="Stats"
    type="dmg"
    downloadURL="$(downloadURLFromGit exelban stats)"
    appNewVersion="$(versionFromGit exelban stats)"
    expectedTeamID="RP2S87B72W"
    ;;
steelseriesengine)
    name="SteelSeries GG"
    type="pkg"
    downloadURL="https://steelseries.com/engine/latest/darwin"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*SteelSeriesGG([0-9.]*)\.pkg/\1/')"
    expectedTeamID="6WGL6CHFH2"
    ;;
steinbergactivationmanager)
    # New installations requires the following labels PRIOR to Cubase
    #    steinbergactivationmanager
    #    steinberglibrarymanager
    #    steinbergmediabay
    #
    name="Steinberg Activation Manager"
    type="pkgInDmg"
    packageID="com.steinberg.activationmanager"
    downloadURL="https://www.steinberg.net/sam-mac"
    appNewVersion="$( curl -LIs "${downloadURL}" | grep -i "location:" | grep "dmg" | cut -d\/ -f7 | cut -d'.' -f1-3 )"
    expectedTeamID="5PMY476BJ6"
    ;;
steinberglibrarymanager)
    # New installations requires the following labels PRIOR to Cubase
    #    steinbergactivationmanager
    #    steinberglibrarymanager
    #    steinbergmediabay
    #
    name="Steinberg Library Manager"
    type="pkgInDmg"
    packageID="com.steinberg.SteinbergLibraryManager"
    downloadURL="https://www.steinberg.net/slm-mac"
    appNewVersion="$( curl -LIs "${downloadURL}" | grep -i "location:" | grep "dmg" | cut -d\/ -f7 | cut -d'.' -f1-3 )"
    expectedTeamID="5PMY476BJ6"
    ;;
steinbergmediabay)
    # New installations requires the following labels PRIOR to Cubase
    #    steinbergactivationmanager
    #    steinberglibrarymanager
    #    steinbergmediabay
    #
    name="Steinberg Media Bay"
    type="pkgInDmg"
    packageID="com.steinberg.MediaClient"
    downloadURL="https://www.steinberg.net/smb-mac"
    appNewVersion="$( curl -LIs "${downloadURL}" | grep -i "location:" | grep "dmg" | grep -o '[0-9]\.[0-9]\.[0-9][0-9]')"
    expectedTeamID="5PMY476BJ6"
    ;;
strongdm)
    name="strongDM"
    type="dmg"
    downloadURL="https://app.strongdm.com/downloads/client/darwin"
    appNewVersion=$(curl -fsLIXGET "https://app.strongdm.com/downloads/client/darwin" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"SDM\-\(.*\)\.dmg\".*/\1/')
    appName="SDM.app"
    blockingProcesses=( "SDM" )
    expectedTeamID="W5HSYBBJGA"
    ;;
strongsync)
    name="Strongsync"
    type="dmg"
    #downloadURL="https://updates.expandrive.com/apps/strongsync/download_latest"
    downloadURL=$(curl -fs "https://updates.expandrive.com/appcast/strongsync.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://updates.expandrive.com/appcast/strongsync.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    versionKey="CFBundleVersion"
    expectedTeamID="CH86M498V4"
    ;;
subethaedit)
    name="SubEthaEdit"
    # Home: https://github.com/subethaedit/SubEthaEdit
    # Description: General purpose plain text editor for macOS. Widely known for its live collaboration feature.
    type="zip"
    downloadURL="$(downloadURLFromGit subethaedit SubEthaEdit)"
    appNewVersion="$(versionFromGit subethaedit SubEthaEdit)"
    expectedTeamID="S76GCAG929"
    ;;
sublimemerge)
    # Home: https://www.sublimemerge.com
    # Description: Git Client, done Sublime. Line-by-line Staging. Commit Editing. Unmatched Performance.
    name="Sublime Merge"
    type="zip"
    downloadURL="$(curl -fs "https://www.sublimemerge.com/download_thanks?target=mac#direct-downloads" | grep -io "https://download.*_mac.zip" | head -1)"
    appNewVersion=$(curl -fs https://www.sublimemerge.com/download | grep -i -A 4 "id.*changelog" | grep -io "Build [0-9]*")
    expectedTeamID="Z6D26JE4Y4"
    ;;
sublimetext)
    # credit: Søren Theilgaard (@theilgaard)
    name="Sublime Text"
    type="zip"
    downloadURL="$(curl -fs "https://www.sublimetext.com/download_thanks?target=mac#direct-downloads" | grep -io "https://download.*_mac.zip" | head -1)"
    appNewVersion=$(curl -fs https://www.sublimetext.com/download | grep -i -A 4 "id.*changelog" | grep -io "Build [0-9]*")
    expectedTeamID="Z6D26JE4Y4"
    ;;
suitestudio)
    name="Suite"
    type="pkg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://saturn-installer-prd-124359286071-bucket.s3.amazonaws.com/suite-installer-osx-arm64.pkg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://saturn-installer-prd-124359286071-bucket.s3.amazonaws.com/suite-installer-osx-x64.pkg"
    fi
    expectedTeamID="58KZ58VMJ8"
    ;;
supercollider)
	# A platform for audio synthesis and algorithmic composition, featuring real-time audio servers, an interpreted programming language, and an integrated development environment
    name="SuperCollider"
    type="dmg"
    downloadURL=$(downloadURLFromGit "supercollider" "supercollider")
    appNewVersion=$(versionFromGit "supercollider" "supercollider")
    expectedTeamID="HE5VJFE9E4"
    ;;
superhuman)
    name="superhuman"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.superhuman.com/Superhuman-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.superhuman.com/Superhuman.dmg"
    fi
    appNewVersion=$(curl -fs "https://storage.googleapis.com/download.superhuman.com/supertron-update/latest-mac.yml" | head -1 | cut -d " " -f2)
    expectedTeamID="6XHFYUTQGX"
    ;;
supportapp)
    name="Support"
    type="pkg"
    packageID="nl.root3.support"
    downloadURL=$(downloadURLFromGit root3nl SupportApp)
    appNewVersion=$(versionFromGit root3nl SupportApp)
    expectedTeamID="98LJ4XBGYK"
    blockingProcesses=( NONE )
    ;;
surfdrive)
    name="SURFdrive"
    type="pkg"
	if [[ $(arch) == "arm64" ]]; then
		downloadURL=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep arm64)
		appNewVersion=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep arm |cut -d -f2)
    elif [[ $(arch) == "i386" ]]; then
		downloadURL=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep x86)
		appNewVersion=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep x86|cut -d- -f2)
	fi
    expectedTeamID="4AP2STM4H5"
    appName="surfdrive.app"
    blockingProcesses=( "surfdrive" )
	;;
suspiciouspackage)
    name="Suspicious Package"
    type="dmg"
    downloadURL="https://mothersruin.com/software/downloads/SuspiciousPackage.dmg"
    appNewVersion=$(curl -fs "https://www.mothersruin.com/software/SuspiciousPackage/data/SuspiciousPackageVersionInfo.plist" | grep -A1 CFBundleShortVersionString | tail -1 | sed -E 's/.*>([0-9.]*)<.*/\1/g')
    expectedTeamID="936EB786NH"
    ;;
swiftruntimeforcommandlinetools)
    # Note: this installer will error on macOS versions later than 10.14.3
    name="SwiftRuntimeForCommandLineTools"
    type="pkgInDmg"
    downloadURL="https://updates.cdn-apple.com/2019/cert/061-41823-20191025-5efc5a59-d7dc-46d3-9096-396bb8cb4a73/SwiftRuntimeForCommandLineTools.dmg"
    expectedTeamID="Software Update"
    ;;
symantecvipaccess)
    name="VIP Access"
    type="pkgInDmg"
    pkgName="VIP Access.pkg"
    downloadURL="https://storage.googleapis.com/sedvip-prd-idcenter-downloads/VIPAccessSecurityCode.dmg"
    expectedTeamID="9PTGMPNXZ2"
    blockingProcesses=( "VIP Access" )
    ;;
symhelper)
    name="SYM-Helper"
    type="zip"
    downloadURL="$(downloadURLFromGit setup-your-mac SYM-Helper)"
    appNewVersion="$(versionFromGit setup-your-mac SYM-Helper)"
    expectedTeamID="PS2F6S478M"
    ;;

sync)
    name="Sync"
    type="dmg"
    downloadURL="https://www.sync.com/download/apple/Sync.dmg"
    appNewVersion="$(curl -fs "https://www.sync.com/blog/category/desktop/feed/" | xpath '(//channel/item/title)[1]' 2>/dev/null | sed -E 's/^.* ([0-9.]*) .*$/\1/g')"
    expectedTeamID="7QR39CMJ3W"
    blockingProcesses=( "Sync" "sync-worker.exe" )
    ;;
synologyactivebackupforbusinessagent)
    name="Synology Active Backup for Business Agent"
    type="pkgInDmg"
    packageID="com.synology.activebackup-agent"
    versionKey="CFBundleVersion"
    downloadURL=$(appVersion=`curl -sf https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent | grep -m 1 /download/Utility/ActiveBackupBusinessAgent/ | sed "s|.*>\(.*\)<.*|\\1|"` && appShortVersion=`sed 's#.*-\(\)#\1#' <<< $appVersion` && echo https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/"$appVersion"/Mac/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-"$appVersion".dmg)
    # appNewVersion=$(appVersionP1=`curl -sf https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent | grep -m 1 /download/Utility/ActiveBackupBusinessAgent/ | sed "s|.*>\(.*\)-.*|\\1|"` && sed 's/\(.\{0\}\)./\17/' <<< $appVersionP1)
    appNewVersion=$(curl -sf https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent | grep -m 1 /download/Utility/ActiveBackupBusinessAgent/ | sed "s|.*>\(.*\)<.*|\\1|" | sed "s#.*-\(\)#\1#")
    expectedTeamID="X85BAK35Y4"
    ;;
synologyassistant)
    name="SynologyAssistant"
    type="dmg"
    packageID="com.synology.DSAssistant"
    appNewVersion="$(curl -sf https://archive.synology.com/download/Utility/Assistant | grep -m 1 /download/Utility/Assistant/ | sed "s|.*>\(.*\)<.*|\\1|")"
    downloadURL="https://global.download.synology.com/download/Utility/Assistant/${appNewVersion}/Mac/synology-assistant-${appNewVersion}.dmg"
    appCustomVersion(){ strings /Applications/SynologyAssistant.app/Contents/MacOS/DSAssistant | awk '/src\/CAsstGlobalSetting.cpp/,/%1 %2/ { if ($0 !~ /src\/CAsstGlobalSetting.cpp/ && $0 !~ /%1 %2/) print }' }
    expectedTeamID="X85BAK35Y4"
    ;;
synologydriveclient)
    name="Synology Drive Client"
    type="pkgInDmg"
    # packageID="com.synology.CloudStation"
    versionKey="CFBundleVersion"
    downloadURL=$(appVersion=`curl -sf https://archive.synology.com/download/Utility/SynologyDriveClient | grep -m 1 /download/Utility/SynologyDriveClient/ | sed "s|.*>\(.*\)<.*|\\1|"` && appShortVersion=`sed 's#.*-\(\)#\1#' <<< $appVersion` && echo https://global.download.synology.com/download/Utility/SynologyDriveClient/"$appVersion"/Mac/Installer/synology-drive-client-"${appShortVersion}".dmg)
    # appNewVersion=$(appVersionP1=`curl -sf https://archive.synology.com/download/Utility/SynologyDriveClient | grep -m 1 /download/Utility/SynologyDriveClient/ | sed "s|.*>\(.*\)-.*|\\1|"` && sed 's/\(.\{0\}\)./\17/' <<< $appVersionP1)
    appNewVersion=$(curl -sf https://archive.synology.com/download/Utility/SynologyDriveClient | grep -m 1 /download/Utility/SynologyDriveClient/ | sed "s|.*>\(.*\)<.*|\\1|" | sed "s#.*-\(\)#\1#")
    expectedTeamID="X85BAK35Y4"
    ;;
sysexlibrarian)
    name="SysEx Librarian"
    type="dmg"
    downloadURL="https://www.snoize.com/SysExLibrarian/SysExLibrarian.dmg"
    appNewVersion=$(curl -fs "https://www.snoize.com/SysExLibrarian/SysExLibrarian.xml" | xpath 'string(//rss/channel/item[1]/sparkle:version)' 2>/dev/null)
    expectedTeamID="YDJAW5GX9U"
    ;;
tableaudesktop)
    name="Tableau Desktop"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    downloadURL="https://www.tableau.com/downloads/desktop/mac"
    appNewVersion=${$(curl -fsIL "$downloadURL" | sed -nE 's/.*Desktop-([0-9-]*).*/\1/p')//-/.}
    expectedTeamID="QJ4XPRK37C"
    ;;
tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    downloadURL=$(curl -fs https://www.tableau.com/downloads/public/mac | awk '/TableauPublic/' | xmllint --recover --html --xpath "//a/text()" -)
    appNewVersion=$( echo $downloadURL | sed -E 's/.*TableauPublic-([-0-9]*)\.dmg/\1/g' | tr "-" "." )
    expectedTeamID="QJ4XPRK37C"
    ;;
tableaureader)
    name="Tableau Reader"
    type="pkg"
    tableauUpdateFeed=$(curl -fsL "https://downloads.tableau.com/TableauAutoUpdate.xml")
    latestVersion=$(echo "${tableauUpdateFeed}" | xmllint --xpath '//*[local-name()="version"]/@latestVersion' - | tr ' ' '\n' | awk -F'"' '{print $2}' | sort -nr | head -n1)
    nameVersion=$(echo "${tableauUpdateFeed}" | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']/@name" - 2>/dev/null | awk -F'"' '{print $2}')
    name="${name} ${nameVersion}"
    appNewVersion=$(echo "${tableauUpdateFeed}" | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']/@releaseNotesVersion" - | awk -F'"' '{print $2}')
    if [[ $(arch) == "arm64" ]]; then
        readerMac=$(echo "${tableauUpdateFeed}" | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']//*[local-name()='installer'][@type='readerMacArm64']/@name" - | awk -F'"' '{print $2}')
    elif [[ $(arch) == "i386" ]]; then
        readerMac=$(echo "${tableauUpdateFeed}"  | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']//*[local-name()='installer'][@type='readerMac']/@name" - | awk -F'"' '{print $2}')
    fi
    downloadURL="https://downloads.tableau.com/esdalt/$appNewVersion/$readerMac"
    expectedTeamID="QJ4XPRK37C"
    ;;

tageditor)
     name="Tag Editor"
     type="dmg"
     downloadURL="https://amvidia.com/downloads/tag-editor-mac.dmg"
     appNewVersion=$(curl -sf "https://amvidia.com/tag-editor" | grep -o -E '"softwareVersion":.'"{8}" | sed -E 's/.*"([0-9.]*).*/\1/g')
     expectedTeamID="F2TH9XX9CJ"
     ;;
tailscale)
    name="Tailscale"
    type="zip"
    appNewVersion="$(curl -s https://pkgs.tailscale.com/stable/ | awk -F- '/Tailscale.*macos.zip/ {print $2}')"
    downloadURL="https://pkgs.tailscale.com/stable/Tailscale-${appNewVersion}-macos.zip"
    expectedTeamID="W5364U7YZB"
    versionKey="CFBundleShortVersionString"
    ;;
talkdeskcxcloud)
    name="Talkdesk"
    type="dmg"
    talkdeskcxcloudVersions=$(curl -fs "https://td-infra-prd-us-east-1-s3-atlaselectron.s3.amazonaws.com/talkdesk-latest-metadata.json")
    appNewVersion=$(getJSONValue "$talkdeskcxcloudVersions" "[0].version")
    downloadURL="https://td-infra-prd-us-east-1-s3-atlaselectron.s3.amazonaws.com/talkdesk-${appNewVersion}.dmg"
    expectedTeamID="YGGJX44TB8"
    ;;
taskpaper)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="TaskPaper"
    type="dmg"
    downloadURL="https://www.taskpaper.com/assets/app/TaskPaper.dmg"
    expectedTeamID="64A5CLJP5W"
    ;;
teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    # packageID="com.teamviewer.teamviewer"
    versionKey="CFBundleShortVersionString"
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    expectedTeamID="H7UGFBUGV6"
    ;;
teamviewerhost)
    name="TeamViewerHost"
    type="pkgInDmg"
    packageID="com.teamviewer.teamviewerhost"
    pkgName="Install TeamViewerHost.app/Contents/Resources/Install TeamViewerHost.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewerHost.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    expectedTeamID="H7UGFBUGV6"
    #blockingProcessesMaxCPU="5" # Future feature
    ;;
teamviewerhostcustom)
    name="TeamViewerHost"
    type="pkgInDmg"
    teamviewerCustomDownloadURL="" # https://get.teamviewer.com/your_custom_name_here
    teamviewerConfigID=$(curl -fs ${teamviewerCustomDownloadURL} -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' | grep -o 'var configId = ".*"' | awk -F'"' '{ print $2 }')
    teamviewerVersion=$(curl -fs ${teamviewerCustomDownloadURL} -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' | grep -o 'var version = ".*"' | awk -F'"' '{ print $2 }')
    downloadURL=$(curl -fs -X POST --url "https://get.teamviewer.com/api/CustomDesign" --header 'Content-Type: application/json; charset=utf-8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' --data '{ "ConfigId": "'"$teamviewerConfigID"'", "Version": "'"$teamviewerVersion"'", "IsCustomModule": true, "Subdomain": "1", "ConnectionId": "" }' | tr -d '"')
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    appName="TeamViewer.app"
    expectedTeamID="H7UGFBUGV6"
    ;;
teamviewerqs)
    # credit: Søren Theilgaard (@theilgaard)
    name="TeamViewerQS"
    type="dmg"
    downloadURL="https://download.teamviewer.com/download/TeamViewerQS.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    appName="TeamViewerQS.app"
    expectedTeamID="H7UGFBUGV6"
    ;;
teamviewerqscustom)
    name="TeamViewerQS"
    type="zip"
    teamviewerCustomDownloadURL="" # https://get.teamviewer.com/your_custom_name_here
    teamviewerConfigID=$(curl -fs ${teamviewerCustomDownloadURL} -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' | grep -o 'var configId = ".*"' | awk -F'"' '{ print $2 }')
    teamviewerVersion=$(curl -fs ${teamviewerCustomDownloadURL} -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' | grep -o 'var version = ".*"' | awk -F'"' '{ print $2 }')
    downloadURL=$(curl -fs -X POST --url "https://get.teamviewer.com/api/CustomDesign" --header 'Content-Type: application/json; charset=utf-8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' --data '{ "ConfigId": "'"$teamviewerConfigID"'", "Version": "'"$teamviewerVersion"'", "IsCustomModule": true, "Subdomain": "1", "ConnectionId": "" }' | tr -d '"')
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    appName="TeamViewerQS.app"
    expectedTeamID="H7UGFBUGV6"
    ;;
teamwire)
    name="Teamwire"
    type="dmg"
    packageID="eu.teamwire.app"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.teamwire.eu/download.php?platform=darwinArm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.teamwire.eu/download.php?platform=darwinX64"
    fi
    appNewVersion=$(curl -fsI $downloadURL | grep -i 'Location' | cut -d ' ' -f2 | sed 's|.*dist/v\([^/]*\).*|\1|')
    expectedTeamID="2JCSJ44B3U"
    ;;
techsmithcapture)
    # credit Elena Ackley (@elenaelago)
    name="TechSmith Capture"
    type="dmg"
    downloadURL="https://cdn.cloud.techsmith.com/techsmithcapture/mac/TechSmithCapture.dmg"
    expectedTeamID="7TQL462TU8"
    ;;
teladocproviderinstaller)
    name="TeladocProviderInstaller"
    type="pkg"
    downloadURL="https://update.intouchreports.com/cdn/prod/ida/provider/mac/x64/manual/TeladocProviderInstaller.pkg"
    appNewVersion=$(curl -fsL "https://update.intouchreports.com/cdn/prod/ida/provider/mac/x64/manual/latest-mac.yml" | grep -E 'version: ' | sed -E 's/version: \"?([0-9.]*)\"?/\1/')
    packageID="com.intouchhealth.ith-provider"
    expectedTeamID="TXR7NRCG98"
    ;;
telegram)
    name="Telegram"
    type="dmg"
    downloadURL="https://telegram.org/dl/macos"
    appNewVersion="$(curl -s "https://osx.telegram.org/updates/versions.xml" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="6N38VWS5BX"
    ;;
tembo)
    name="Tembo"
    type="zip"
    downloadURL="$(curl -fs https://www.houdah.com/tembo/updates/cast2.xml | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs https://www.houdah.com/tembo/updates/cast2.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    expectedTeamID="DKGQD8H8ZY"
    ;;
tencentmeeting)
    name="TencentMeeting"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(curl -fs 'https://meeting.tencent.com/web-service/query-download-info?q=%5B%7B%22package-type%22%3A%22app%22%2C%22channel%22%3A%220300000000%22%2C%22platform%22%3A%22mac%22%2C%22arch%22%3A%22arm64%22%7D%5D&c_os=web&c_os_version=1&c_os_model=web&c_timestamp=1653366550252&c_instance_id=5&c_nonce=DcaDam4y&c_app_id=1400143280&c_app_version=1&c_lang=zh-cn&c_district=0&nonce=miwSceJNQaSZttma' -H 'authority: meeting.tencent.com' -H 'referer: https://meeting.tencent.com/download-mac.html?from=1000&fromSource=1&macType=apple' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15' | grep -o "https://updatecdn.meeting.qq.com[^']*\.publish.arm64.officialwebsite.dmg")"
        appNewVersion=$(curl -fs 'https://meeting.tencent.com/web-service/query-download-info?q=%5B%7B%22package-type%22%3A%22app%22%2C%22channel%22%3A%220300000000%22%2C%22platform%22%3A%22mac%22%2C%22arch%22%3A%22arm64%22%7D%5D&c_os=web&c_os_version=1&c_os_model=web&c_timestamp=1653366550252&c_instance_id=5&c_nonce=DcaDam4y&c_app_id=1400143280&c_app_version=1&c_lang=zh-cn&c_district=0&nonce=miwSceJNQaSZttma' -H 'authority: meeting.tencent.com' -H 'referer: https://meeting.tencent.com/download-mac.html?from=1000&fromSource=1&macType=apple' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15' | grep -o "https://updatecdn.meeting.qq.com[^']*\.publish.arm64.officialwebsite.dmg" | sed -e 's/.*TencentMeeting\_0300000000\_\(.*\)\.publish\.arm64\.officialwebsite\.dmg.*/\1/')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="$(curl -fs 'https://meeting.tencent.com/web-service/query-download-info?q=%5B%7B%22package-type%22%3A%22app%22%2C%22channel%22%3A%220300000000%22%2C%22platform%22%3A%22mac%22%2C%22arch%22%3A%22x86_64%22%7D%5D&c_os=web&c_os_version=1&c_os_model=web&c_timestamp=1653366500890&c_instance_id=5&c_nonce=jA4P4JPY&c_app_id=1400143280&c_app_version=1&c_lang=zh-cn&c_district=0&nonce=tF6Bm4FYHJwdPeGH' -H 'authority: meeting.tencent.com' -H 'referer: https://meeting.tencent.com/download-mac.html?from=1000&fromSource=1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15' | grep -o "https://updatecdn.meeting.qq.com[^']*\.publish.x86_64.officialwebsite.dmg")"
        appNewVersion=$(curl -fs 'https://meeting.tencent.com/web-service/query-download-info?q=%5B%7B%22package-type%22%3A%22app%22%2C%22channel%22%3A%220300000000%22%2C%22platform%22%3A%22mac%22%2C%22arch%22%3A%22x86_64%22%7D%5D&c_os=web&c_os_version=1&c_os_model=web&c_timestamp=1653366500890&c_instance_id=5&c_nonce=jA4P4JPY&c_app_id=1400143280&c_app_version=1&c_lang=zh-cn&c_district=0&nonce=tF6Bm4FYHJwdPeGH' -H 'authority: meeting.tencent.com' -H 'referer: https://meeting.tencent.com/download-mac.html?from=1000&fromSource=1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15' | grep -o "https://updatecdn.meeting.qq.com[^']*\.publish.x86_64.officialwebsite.dmg" | sed -e 's/.*TencentMeeting\_0300000000\_\(.*\)\.publish\.x86_64\.officialwebsite\.dmg.*/\1/')
    fi
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15" )
    appCustomVersion() { echo "$(defaults read /Applications/TencentMeeting.app/Contents/Info.plist CFBundleShortVersionString)$(echo ".")$(defaults read /Applications/TencentMeeting.app/Contents/Info.plist CFBundleVersion)" }
    expectedTeamID="88L2Q4487U"
    ;;

texliveutility)
    name="TeX Live Utility"
    type="zip"
    downloadURL="$(downloadURLFromGit amaxwell tlutility)"
    appNewVersion="$(versionFromGit amaxwell tlutility)"
    expectedTeamID="966Z24PX4J"
    ;;
texshop-alternative)
    # This label is really an alternative to the original TeXShop, as it might not have the latest version and is not maintained by original developers of TeXShop.
    name="TeXShop"
    type="zip"
    downloadURL="$(downloadURLFromGit TeXShop TeXShop)"
    appNewVersion="$(versionFromGit TeXShop TeXShop)"
    expectedTeamID="RBGCY5RJWM"
    ;;
texshop)
    # This is the original source of TeXShop, but it is often very slow to download.
    # A label texshop-alternative exists that is hosted on GitHub, but might not have the latest version and is not maintained by the original developers.
    # This app needs basictex or mactex for the LaTeX part.
    name="TeXShop"
    type="zip"
    downloadURL="https://pages.uoregon.edu/koch/texshop/texshop-64/texshop.zip"
    appNewVersion="$(curl -fs https://pages.uoregon.edu/koch/texshop/obtaining.html | xmllint --html --format - | grep "texshop-64/texshop.zip" | grep "Latest TeXShop" | sed -nE 's/.*Version ([0-9.]*).*/\1/p')"
    expectedTeamID="RBGCY5RJWM"
    ;;
textexpander)
    name="TextExpander"
    type="dmg"
    downloadURL="$(curl -s -L -w "%{url_effective}\n" -o /dev/null "https://rest-prod.tenet.textexpander.com/download?platform=macos")"
    appNewVersion=$( echo "$downloadURL" | sed -n 's/.*TextExpander_\([0-9.]*\).dmg/\1/p' | grep -oE '[0-9.]+' )
    expectedTeamID="7PKJ6G4DXL"
    ;;
textmate)
    name="TextMate"
    type="tbz"
    #downloadURL="https://api.textmate.org/downloads/release?os=10.12"
    downloadURL=$(downloadURLFromGit "textmate" "textmate")
    appNewVersion=$(versionFromGit "textmate" "textmate")
    expectedTeamID="45TL96F76G"
    ;;
theunarchiver)
    name="The Unarchiver"
    type="dmg"
    downloadURL="https://dl.devmate.com/com.macpaw.site.theunarchiver/TheUnarchiver.dmg"
    appNewVersion="$(curl -fs "https://theunarchiver.com" | grep -i "Latest version" | head -1 | sed -E 's/.*> ([0-9.]*) .*/\1/g')"
    expectedTeamID="S8EX82NJP6"
    ;;
things)
    name="Things"
    type="zip"
    downloadURL="https://culturedcode.com/things/download/"
    expectedTeamID="JLMPQHK86H"
    ;;
thonny)
    name="Thonny"
    type="pkg"
    downloadURL="$(downloadURLFromGit thonny thonny)"
    appNewVersion="$(versionFromGit thonny thonny)"
    expectedTeamID="2SA9D4CVU8"
    ;;
thunderbird)
    name="Thunderbird"
    type="dmg"
	appNewVersion=$(curl -I -s "https://download.mozilla.org/?product=thunderbird-esr-latest&os=osx&lang=en-US" | grep -i location | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 )
    downloadURL="https://download.mozilla.org/?product=thunderbird-esr-latest&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    ;;
thunderbird_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Thunderbird
    name="Thunderbird"
    type="dmg"
    userLanguage=$(if [ -e "/Applications/${name}.app/Contents/Resources/locale.ini" ]; then tail -1 "/Applications/${name}.app/Contents/Resources/locale.ini" | grep "locale=" | awk -F'=' '{ print $2 }'; else runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-'; fi)
    printlog "Found language $userLanguage to be used for $name."
    releaseURL="https://ftp.mozilla.org/pub/thunderbird/releases/latest/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
        printlog "Download not found for '$userLanguage', using default ('en-US')."
        downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx"
    fi
    appNewVersion=$(curl -fsIL $downloadURL | awk -F releases/ '/Location:/ {split($2,a,"/"); print a[1]}')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( thunderbird )
    ;;
thunderbirdesr)
    name="Thunderbird"
    type="dmg"
    appNewVersion=$(curl -fsL "https://www.thunderbird.net/en-US/thunderbird/releases/atom.xml" | grep "esr" | grep -m 5 "<title type=" | sed 's/<.*>\(.*\)<.*>/\1/' | awk '{ print $2 }' | awk '{$1=$1};1' | tr -d "esr" | sort -V | tail -n1 )
    downloadURL="https://download.mozilla.org/?product=thunderbird-${appNewVersion}esr-SSL&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    ;;
ticktick)
    # TickTick is a x-platform ToDo-app for groups/teams, see https://ticktick.com
    name="TickTick"
    type="dmg"
    downloadURL="https://ticktick.com/down/getApp/download?type=mac"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -Ei "^location" | cut -d "_" -f2)"
    expectedTeamID="75TY9UT8AY"
    ;;
tidal)
    name="TIDAL"
    type="dmg"
    downloadURL="https://download.tidal.com/desktop/TIDAL.dmg"
    appNewVersion=$(curl -fs https://update.tidal.com/updates/latest\?v\=1 | cut -d '"' -f4 | sed -E 's/https.*\/TIDAL\.([0-9.]*)\.zip/\1/g')
    expectedTeamID="GK2243L7KB"
    ;;
todoist)
    name="Todoist"
    type="dmg"
    downloadURL="https://todoist.com/mac_app"
    appNewVersion="$(curl -fsIL https://todoist.com/mac_app | grep -i ^location | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')"
    expectedTeamID="S3DD273774"
    ;;
toggltrack)
    name="Toggl Track"
    type="dmg"
    downloadURL=$(downloadURLFromGit toggl-open-source toggldesktop )
    appNewVersion=$(versionFromGit toggl-open-source toggldesktop )
    expectedTeamID="B227VTMZ94"
    ;;
tom4aconverter)
     name="To M4A Converter"
     type="dmg"
     downloadURL="https://amvidia.com/downloads/to-m4a-converter-mac.dmg"
     appNewVersion=$(curl -sf "https://amvidia.com/to-m4a-converter" | grep -o -E '"softwareVersion":.'"{8}" | sed 's/\"//g' | awk -F ': ' '{print $2}')
     expectedTeamID="F2TH9XX9CJ"
     ;;
toonboomharmonypremium2024)
    name="Harmony 24 Premium"
    type="dmg"
    # appNewVersion=$(curl -s https://docs.toonboom.com/help/harmony-24/premium/release-notes/harmony/harmony-24-release-notes.html | grep -oE 'build [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | awk '{print $2}')
    appNewVersion=$(release_notes_url=$(curl -s "https://docs.toonboom.com/help/harmony-24/premium/book/index.html" | \
    grep -o 'href="[^"]*release-notes/harmony/harmony-24[^"]*"' | \
    head -n 1 | sed -E 's/href="([^"]*)"/\1/')
    curl -s "https://docs.toonboom.com/help/harmony-24/premium/book/$release_notes_url" | \
    grep -oE 'Harmony [0-9]+\.[0-9]+\.[0-9]+, build [0-9]+' | \
    sed 's/,//g' | awk '{print $2 "." $4}')
    version=$(echo "$appNewVersion" | awk -F'.' '{print $1"."$2"."$3}')
    build=$(echo "$appNewVersion" | awk -F'.' '{print $4}')
    downloadURL="https://fileshare.toonboom.com/wl/?id=idRIztLvVCq0EZ00x01BJa6R2EqKp01R&path=${version}%2FHAR24-PRM-mac-${build}.dmg&mode=list&download=1"
    folderName="Toon Boom Harmony 24 Premium"
    appName="${folderName}/Harmony 24 Premium.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;
    
toonboomstoryboardpro2024)
    name="Storyboard Pro 24"
    type="dmg"
    downloadURL=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=24.0.0&b=00000" | sed -n 's/.*<package platform="macos" open_in_browser="false">\([^<]*\).*/\1/p')
    folderName="Toon Boom Storyboard Pro 24"
    appName="${folderName}/Storyboard Pro 24.app"
    appNewVersion=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=24.0.0&b=00000" | xmllint --xpath 'string(//update/@version)' -)
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;
    
topazgigapixel|\
topazgigapixelai)
    # credit: Tully Jagoe
    name="Topaz Gigapixel AI"
    type="pkg"
    appNewVersion=$(curl -fs https://www.topazlabs.com/downloads | grep  -o 'gigaVersion = "v.*"' | grep -o ' "v.*"' | sed -E 's/[v|"| ]//g')
    versionKey="CFBundleShortVersionString"
    downloadURL="https://topazlabs.com/d/gigapixel/latest/mac/full"
    archiveName="TopazGigapixelAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
topazphoto|\
topazphotoai)
    name="Topaz Photo AI"
    type="pkg"
    appNewVersion=$(curl -fs https://www.topazlabs.com/downloads | grep  -o 'photoVersion = "v.*"' | grep -o ' "v.*"' | sed -E 's/[v|"| ]//g')
    downloadURL="https://topazlabs.com/d/photo/latest/mac/full"
    archiveName="TopazPhotoAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
topazvideo|\
topazvideoai)
    name="Topaz Video AI"
    type="pkg"
    appNewVersion=$(curl -fs https://www.topazlabs.com/downloads | grep  -o 'videoVersion = "v.*"' | grep -o ' "v.*"' | sed -E 's/[v|"| ]//g')
    downloadURL="https://topazlabs.com/d/tvai/latest/mac/full"
    archiveName="TopazVideoAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
torbrowser)
    # credit: Søren Theilgaard (@theilgaard)
    name="Tor Browser"
    type="dmg"
    downloadURL=https://www.torproject.org$(curl -fs https://www.torproject.org/download/ | grep "downloadLink" | grep dmg | head -1 | cut -d '"' -f 4)
    appNewVersion=$(curl -fs https://www.torproject.org/download/ | grep "downloadLink" | grep dmg | head -1 | cut -d '"' -f 4 | cut -d / -f 4)
    expectedTeamID="MADPSAYN6T"
    ;;
tower)
    name="Tower"
    type="zip"
    downloadURL="https://www.git-tower.com/updates/tower3-mac/stable/releases/latest/download"
    appNewVersion="$(curl -s https://www.git-tower.com/updates/tower3-mac/stable/releases | grep -m1 -o '<h2>[^<]*</h2>' | sed 's/<h2>\(.*\)<\/h2>/\1/' | awk '{print $1}')"
    expectedTeamID="UN97WY764J"
    ;;
transfer)
    name="Transfer"
    type="dmg"
    downloadURL="https://www.intuitibits.com/products/transfer/download"
    appNewVersion=$(curl -fs "https://www.intuitibits.com/appcasts/transfercast.xml" | xpath '(//rss/channel/item/sparkle:shortVersionString)[1]' 2>/dev/null | cut -d ">" -f2 | cut -d "<" -f1)
    expectedTeamID="2B9R362QNU"
    ;;
transmit5)
    name="Transmit"
    type="zip"
    downloadURL="https://download.panic.com/transmit/Transmit-5-Latest.zip"
    appNewVersion="$(curl -fsI "https://download.panic.com/transmit/Transmit-5-Latest.zip" | grep -i "^location" | sed -E 's/.*Transmit%20([0-9]+(\.[0-9]+)*)\.zip/\1/' | tr -d '\r')"
    expectedTeamID="VE8FC488U5"
    ;;

trapcode)
    name="Trapcode Suite"
    type="zip"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep trapcode | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | sort -gru | head -n 1
    }
    for i in {1..5}; do
      appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/13336955539228-Red-Giant" | grep -i "Trapcode" | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | sort -gru | head -n 1)
      if [[ -n $appNewVersion ]]; then break; else sleep 1; fi
    done
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/trapcode/releases/${appNewVersion}/TrapcodeSuite-${appNewVersion}_Mac.zip"
    trapcodeResponse=$(curl -s -I -L "$downloadURL")
    trapcodeHttpStatus=$(echo "$trapcodeResponse" | head -n 1 | cut -d ' ' -f 2)
    if [[ "trapcodeHttpStatus" == "200" ]]; then
      printlog "DownloadURL HTTP status code: $trapcodeHttpStatus" INFO
    elif [[ "$trapcodeHttpStatus" == "404" ]]; then
      downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/trapcode/releases/${appNewVersion}/TrapcodeSuite-${appNewVersion}_mac.zip"
      printlog "Had to change DownloadURL due HTTP Status." INFO
    else
      printlog "Unexpected HTTP status code: $trapcodeHttpStatus" ERROR
    fi
    installerTool="Trapcode Suite Installer.app"
    CLIInstaller="Trapcode Suite Installer.app/Contents/MacOS/Trapcode Suite Installer"
    expectedTeamID="4ZY22YGXQG"
    ;;
trex)
    # credit: Søren Theilgaard (@theilgaard)
    name="TRex"
    type="zip"
    downloadURL=$(downloadURLFromGit amebalabs TRex)
    appNewVersion=$(versionFromGit amebalabs TRex)
    expectedTeamID="X93LWC49WV"
    ;;
tunnelbear)
    name="TunnelBear"
    type="zip"
    downloadURL="https://s3.amazonaws.com/tunnelbear/downloads/mac/TunnelBear.zip"
    expectedTeamID="P2PHZ9K5JJ"
    ;;
tunnelblick)
    name="Tunnelblick"
    type="dmg"
    appNewVersion=$(curl -sf https://github.com/Tunnelblick/Tunnelblick/releases  | grep -B2 'Pre-release' |grep -m 1 "/Tunnelblick/Tunnelblick/releases/tag/" | sed -r 's/.*Tunnelblick ([^<]+).*/\1/')
    version_plus_build=$(echo ${appNewVersion} | awk '{gsub(/ /,"_"); gsub(/\(|\)/,""); print}')
    version=$(echo $version_plus_build | awk -F_ '{print $1}')
    downloadURL="https://github.com/Tunnelblick/Tunnelblick/releases/download/v${version}/Tunnelblick_${version_plus_build}.dmg"
    CLIInstaller="/Tunnelblick.app/Contents/Resources/installer"
    CLIArguments="259"
    expectedTeamID="Z2SG5H3HC8"
    ;;
tuple)
    name="Tuple"
    type="zip"
    downloadURL=$(curl -fs "https://d32ifkf9k9ezcg.cloudfront.net/production/sparkle/appcast.xml" | grep -o 'https://d32ifkf9k9ezcg.cloudfront.net/[^"]*.zip' | head -n 1)
    appNewVersion=$(curl -fs "https://d32ifkf9k9ezcg.cloudfront.net/production/sparkle/appcast.xml" | grep -o 'sparkle:shortVersionString="[^"]*"' | sed -E 's/sparkle:shortVersionString="([^"]*)"/\1/' | head -n 1)
    expectedTeamID="DQYU7DR9Q7"
    ;;
twingate)
    name="Twingate"
    type="pkg"
    downloadURL="https://api.twingate.com/download/darwin?installer=pkg"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i ^location | cut -d "/" -f6)
    expectedTeamID="6GX8KVTR9H"
    ;;
typeface)
    name="Typeface"
    type="dmg"
    downloadURL="https://dcdn.typefaceapp.com/latest"
    appNewVersion=$(curl -fs https://dcdn.typefaceapp.com/appcast.xml | xpath '//rss/channel/item[1]/sparkle:shortVersionString /text()' 2>/dev/null )
    expectedTeamID="X55SP58WS6"
    ;;
typinator)
    name="Typinator"
    type="zip"
    downloadURL=https://update.ergonis.com/downloads/products/typinator/Typinator.app.zip
    appNewVersion="$(curl -fs https://update.ergonis.com/vck/typinator.xml | grep -i Program_Version | sed "s|.*>\(.*\)<.*|\\1|")"
    expectedTeamID="TU7D9Y7GTQ"
    ;;
typora)
    name="Typora"
    type="dmg"
    #downloadURL="https://www.typora.io/download/Typora.dmg"
    downloadURL=$(curl -fs "https://www.typora.io/download/dev_update.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    #appNewVersion="$(curl -fs "https://www.typora.io/dev_release.html" | grep -o -i "h4>[0-9.]*</h4" | head -1 | sed -E 's/.*h4>([0-9.]*)<\/h4.*/\1/')"
    appNewVersion=$(curl -fs "https://www.typora.io/download/dev_update.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="9HWK5273G4"
    ;;
uaconnect)
    name="UA Connect"
    type="dmg"
    downloadURL="https://www.uaudio.com/apps/uaconnect/mac/installer"
    appNewVersion="$(curl -Ifs "$downloadURL" | grep 'location:' | cut -d'_' -f4-6 | tr '_' '.')"
    expectedTeamID="4KAC9AX6CG"
    ;;
ujamportal)
    name="UJAM"
    type="dmg"
    appNewVersion="$(curl -s -i "https://software.ujam.com/ujamapp/latest-mac.yml" | grep "version" | cut -d" " -f2 | xargs)"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://software.ujam.com/ujamapp/UJAM-${appNewVersion}-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://software.ujam.com/ujamapp/UJAM-${appNewVersion}.dmg"
    fi
    expectedTeamID="9PRN6T272N"
    ;;
ultimakercura)
    name="Ultimaker Cura"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="UltiMaker-Cura-[0-9.]*-macos-ARM64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="UltiMaker-Cura-[0-9.]*-macos-X64.dmg"
    fi
    downloadURL="$(downloadURLFromGit Ultimaker Cura)"
    appNewVersion=$(versionFromGit Ultimaker Cura )
    expectedTeamID="V4B3JXRRQS"
    ;;
ultracompare)
    name="UltraCompare"
    type="dmg"
    downloadURL="https://downloads.ultraedit.com/main/uc/mac/UltraCompare.dmg"
    appNewVersion=""
    expectedTeamID="2T4C9Y59FF"
    ;;
ultraedit)
    name="UltraEdit"
    type="dmg"
    downloadURL="https://downloads.ultraedit.com/main/ue/mac/UltraEdit.dmg"
    appNewVersion=""
    expectedTeamID="2T4C9Y59FF"
    ;;
umbrellaroamingclient)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Umbrella Roaming Client"
    type="pkgInZip"
    downloadURL=https://disthost.umbrella.com/roaming/upgrade/mac/production/$( curl -fsL https://disthost.umbrella.com/roaming/upgrade/mac/production/manifest.json | awk -F '"' '/"downloadFilename"/ { print $4 }' )
    expectedTeamID="7P7HQ8H646"
    ;;
uniconverter)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Wondershare UniConverter"
    type="dmg"
    downloadURL="http://download.wondershare.com/video-converter-ultimate-mac_full735.dmg"
    expectedTeamID="YZC2T44ZDX"
    ;;
unityhub)
    name="Unity Hub"
    type="dmg"
    downloadURL="https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg"
    appNewVersion=$(curl -s https://unity.com/unity-hub/release-notes | grep -oE '>[0-9]+\.[0-9]+\.[0-9]+<' | head -1 | tr -d '<>')
    expectedTeamID="9QW8UQUTAA"
    ;;

universaltypeclient)
    name="Universal Type Client"
    type="pkgInZip"
    downloadURL=https://bin.extensis.com/$( curl -fs https://www.extensis.com/support/universal-type-server-7/ | grep -o "UTC-[0-9].*M.zip" )
    appNewVersion=$(echo "$downloadURL" | awk -F'UTC-' '{split($2, a, "-M"); print a[1]}' | tr '-' '.')
    expectedTeamID="J6MMHGD9D6"
    ;;
unnaturalscrollwheels)
    name="UnnaturalScrollWheels"
    type="dmg"
    downloadURL="$(downloadURLFromGit ther0n UnnaturalScrollWheels)"
    appNewVersion="$(versionFromGit ther0n UnnaturalScrollWheels)"
    expectedTeamID="D6H5W2T379"
    blockingProcesses=( UnnaturalScrollWheels )
    ;;
utm)
    name="UTM"
    type="dmg"
    downloadURL=$(downloadURLFromGit utmapp UTM )
    appNewVersion=$(versionFromGit utmapp UTM )
    expectedTeamID="WDNLXAD4W8"
    ;;
uviportal)
    name="UVI Portal"
    type="pkgInDmg"
    packageID="net.uvi.pkg.uviportal"
    downloadURL="https://www.uvi.net/dl-portal.php?p=mac"
    appNewVersion="$(curl -s -i "${downloadURL}" | grep "location" | cut -d\- -f2 | xargs)"
    expectedTeamID="BB6L4C84AT"
    ;;
uviworkstation)
    name="UVIWorksation"
    type="pkgInDmg"
    packageID="net.uvi.pkg.UVIWorkstation.SA"
    downloadURL="https://www.uvi.net/dwl.php?p=mac"
    appNewVersion="$(curl -s -i "${downloadURL}" | grep "location" | cut -d\- -f2 | xargs)"
    expectedTeamID="BB6L4C84AT"
    ;;
vagrant)
    name="Vagrant"
    type="pkgInDmg"
    pkgName="vagrant.pkg"
    cpu_arch="${$(arch)/i386/amd64}"
    downloadURL=$(curl -fsL "https://developer.hashicorp.com/vagrant/downloads" | grep -oE 'https[^"]*'$cpu_arch'[^"]*.dmg' | head -1)
    appNewVersion=$( echo $downloadURL | cut -d "/" -f5 )
    expectedTeamID="D38WU7D763"
    ;;
vanilla)
    name="Vanilla"
    type="dmg"
    downloadURL="https://macrelease.matthewpalmer.net/Vanilla.dmg"
    expectedTeamID="Z4JV2M65MH"
    ;;
venturablocker)
    name="venturablocker"
    type="pkg"
    packageID="dk.envo-it.venturablocker"
    downloadURL=$(downloadURLFromGit Theile venturablocker )
    appNewVersion=$(versionFromGit Theile venturablocker )
    expectedTeamID="FXW6QXBFW5"
    ;;
veracrypt)
    name="VeraCrypt"
    type="pkgInDmg"
    #downloadURL=$(curl -s -L "https://www.veracrypt.fr/en/Downloads.html" | grep -Eio 'href="https://launchpad.net/veracrypt/trunk/(.*)/&#43;download/VeraCrypt_([0-9].*).dmg"' | cut -c7- | sed -e 's/"$//' | sed "s/&#43;/+/g")
    downloadURL=$(curl -fs "https://www.veracrypt.fr/en/Downloads.html" | grep "https.*\.dmg" | grep -vi "legacy" | tr '"' '\n' | grep "^https.*" | grep -vi ".sig" | sed "s/&#43;/+/g")
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*.*)\.dmg/\1/g' )
    expectedTeamID="Z933746L2S"
    ;;
vfx)
    name="VFX Suite"
    type="zip"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep vfx | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru
    }
    appNewVersion="$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/4406405445394-VFX-Suite" | grep "#icon-star" -B3 | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/vfx/releases/${appNewVersion}/VfxSuite-${appNewVersion}_Mac.zip"
    installerTool="VFX Suite Installer.app"
    CLIInstaller="VFX Suite Installer.app/Contents/Scripts/install.sh"
    CLIArguments=()
    expectedTeamID="4ZY22YGXQG"
    ;;
vimac)
    name="Vimac"
    type="zip"
    downloadURL=$(curl -fs "https://vimacapp.com/latest-release-metadata" | tr ',' '\n' | awk -F\" '/download_url/ {print $4}')
    appNewVersion=$(curl -fs "https://vimacapp.com/latest-release-metadata" | tr ',' '\n' | awk -F\" '/short_version/ {print $4}')
    expectedTeamID="LQ2VH8VB84"
    ;;
vimcal)
    name="Vimcal"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        fileDownloadName=$(curl -s https://www.vimcal.com/downloads/mac | grep -o 'Vimcal-[0-9.]\+-arm64\.dmg' | head -n 1)
        appNewVersion="${fileDownloadName#Vimcal-}"
        appNewVersion="${appNewVersion%-arm64.dmg}"
        downloadURL="https://vimcal-m1.s3.us-west-1.amazonaws.com/$fileDownloadName"
    elif [[ $(arch) == "i386" ]]; then
        fileDownloadName=$(curl -s https://www.vimcal.com/downloads/mac | grep -o 'Vimcal-[0-9.]\+\.dmg' | head -n 1)
        appNewVersion="${fileDownloadName#Vimcal-}"
        appNewVersion="${appNewVersion%.dmg}"
        downloadURL="https://vimcal-production.s3.us-west-1.amazonaws.com/$fileDownloadName"
    fi
    expectedTeamID="7F7GXK9J99"
    ;;
virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    downloadURL="https:$(curl -fsL "https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html" | grep "OSX.dmg" | xmllint --html --xpath 'string(//a/@href)' -)"
    appNewVersion=$(echo "${downloadURL}" | awk -F '/' '{print $5}')
    expectedTeamID="VB5E2TV963"
    ;;
virtualboxbeta)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    betaVersion="$(curl -fs "https://download.virtualbox.org/virtualbox/LATEST-BETA.TXT")"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${betaVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${betaVersion}/" | grep "macOSArm64" | cut -d\" -f2)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${betaVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${betaVersion}/" | grep "OSX.dmg" | cut -d\" -f2)"
    fi
    appNewVersion="$(echo $betaVersion | cut -d_ -f1)"
    expectedTeamID="VB5E2TV963"
    ;;
virtualboxlatest)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    appNewVersion=$(curl -fs "https://download.virtualbox.org/virtualbox/LATEST.TXT")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "macOSArm64" | cut -d\" -f2)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "OSX.dmg" | cut -d\" -f2)"
    fi
    expectedTeamID="VB5E2TV963"
    ;;
virtualboxstable)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    appNewVersion=$(curl -fs "https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT")
    if [[ $(arch) == "arm64" ]]; then
        if [[ ! -z "$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "macOSArm64")" ]]; then
            downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "macOSArm64" | cut -d\" -f2)"
        else 
            downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "OSX.dmg" | cut -d\" -f2)"
        fi
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "OSX.dmg" | cut -d\" -f2)"
    fi
    expectedTeamID="VB5E2TV963"
    ;;
virtualbuddy)
    name="VirtualBuddy"
    type="dmg"
    downloadURL=$(downloadURLFromGit insidegui VirtualBuddy)
    appNewVersion=$(versionFromGit insidegui VirtualBuddy)
    expectedTeamID="8C7439RJLG"
    ;;
viscosity)
    #credit: @matins
    name="Viscosity"
    type="dmg"
    downloadURL="https://www.sparklabs.com/downloads/Viscosity.dmg"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z.\-]*%20([0-9.]*)\..*/\1/g' )
    expectedTeamID="34XR7GXFPX"
    ;;
visualz)
    name="Visualz"
    type="dmg"
    downloadURL="$(downloadURLFromGit madchops1 visualz-releases)"
    appNewVersion="$(versionFromGit madchops1 visualz-releases)"
    expectedTeamID="6RLU6426R3"
    ;;
vivaldi)
    name="Vivaldi"
    type="tbz"
    downloadURL=$(curl -fsL "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$(curl -is "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml" | grep sparkle:version | tr ',' '\n' | grep sparkle:version | cut -d '"' -f 4)
    expectedTeamID="4XF3XNRN6Y"
    ;;
vivi)
    name="Vivi"
    type="pkg"
    packageID="au.com.viviaustralia.mac"
    appNewVersion=$(curl -fsIL https://api.vivi.io/mac | grep -i "^location" | awk "{print $2}" | sed -E "s/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g")
    downloadURL=$(curl -sf https://api.vivi.io/mac | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d')
    pkgName=$(echo Vivi-"$appNewVersion".pkg)
    expectedTeamID="3NRCUJ8TJC"
    ;;
vlc)
    # VLC is a versatile, open-source multimedia player that supports a wide range of audio, video, and streaming formats across multiple platforms
    name="VLC"
    type="dmg"
    appNewVersion=$(curl -s https://www.videolan.org/vlc/#download | xmllint --html --xpath "//script[contains(text(),'var PLATFORMS')]" - 2>/dev/null | grep -o '"osx":{"name":"macOS[^}]*' | grep -o '"latestVersion":"[^"]*' | sed 's/"latestVersion":"//')
    downloadURL="https://get.videolan.org/vlc/$appNewVersion/macosx/vlc-$appNewVersion-universal.dmg"
    expectedTeamID="75GAHG3SZQ"
    ;;
vmwarefusion)
    name="VMware Fusion"
    type="dmg"
    downloadURL="https://www.vmware.com/go/getfusion"
    curlOptions=(-H "Accept: */*" -H "Accept-Encoding: gzip, deflate" -H "Connection: keep-alive" -H "Host: www.vmware.com" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15")
    appNewVersion=$(curl -fsIL ${curlOptions} "https://www.vmware.com/go/getfusion" | grep -i "^location" | awk '{print $2}' | sed 's/.*-\(.*\)-.*/\1/')
    expectedTeamID="EG7KH642X6"
    ;;
vmwarehorizonclient)
    name="VMware Horizon Client"
    type="pkgInDmg"
    downloadGroup=$(curl -fsL "https://my.vmware.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=vmware_horizon_clients&version=horizon_8&dlgType=PRODUCT_BINARY" | grep -o '[^"]*_MAC_[^"]*')
    fileName=$(curl -fsL "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&category=desktop_end_user_computing&product=vmware_horizon_clients&dlgType=PRODUCT_BINARY&downloadGroup=${downloadGroup}" | grep -o '"fileName":"[^"]*"' | cut -d: -f2 | sed 's/"//g')
    downloadURL="https://download3.vmware.com/software/$downloadGroup/${fileName}"
    appNewVersion=$(curl -fsL "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=${downloadGroup}" | grep -o '[^"]*\.dmg[^"]*' | sed 's/.*-\(.*\)-.*/\1/')
    expectedTeamID="EG7KH642X6"
    ;;
vonagebusiness)
    # @BigMacAdmin (Second Son Consulting) with assists from @Isaac, @Bilal, and @Theilgaard
    name="Vonage Business"
    type="dmg"
    downloadURL="https://vbc-downloads.vonage.com/mac/VonageBusinessSetup.dmg"
    expectedTeamID="E37FZSUGQP"
    archiveName="VonageBusinessSetup.dmg"
    curlOptions=( -L -O --compressed )
    appNewVersion=$(curl -fs "https://s3.amazonaws.com/vbcdesktop.vonage.com/prod/mac/latest-mac.yml" | grep -i version | cut -w -f2)
    ;;
vpntracker365)
	#credit BigMacAdmin @ Second Son Consulting
	name="VPN Tracker 365"
	type="zip"
	downloadURL="https://www.vpntracker.com/goto/HPdownload/VPNT365Latest"
	appNewVersion="$(curl -fsIL ${downloadURL}  | grep -i ^location | grep -i ".zip" | sed 's/.*VPN Tracker 365 - //g' | sed 's/.zip//g')"
	expectedTeamID="MJMRT6WJ8S"
	;;
vscodium)
    name="VSCodium"
    type="dmg"
    downloadURL="$(downloadURLFromGit VSCodium vscodium)"
    appNewVersion="$(versionFromGit VSCodium vscodium)"
    expectedTeamID="VC39D2VNQ7"
    blockingProcesses=( Electron )
    ;;
vysor)
    name="Vysor"
    type="zip"
    downloadURL="$(downloadURLFromGit koush vysor.io)"
    appNewVersion="$(versionFromGit koush vysor.io)"
    expectedTeamID="XT4C9EJNUG"
    ;;
wacomdrivers)
    name="Wacom Center"
    type="pkgInDmg"
    downloadURL="$(curl -fs https://www.wacom.com/en-us/support/product-support/drivers | grep -e "drivers/mac/professional.*dmg" | head -1 | tr '"' "\n" | grep -i http)"
    expectedTeamID="EG27766DY7"
    #pkgName="Install Wacom Tablet.pkg"
    appNewVersion="$(curl -fs https://www.wacom.com/en-us/support/product-support/drivers | grep mac/professional/releasenotes | head -1 | tr '"' "\n" | grep -e "Driver [0-9][-0-9.]*" | sed -E 's/Driver ([-0-9.]*).*/\1/g')"
    ;;
wallyezflash)
    name="Wally"
    type="dmg"
    downloadURL="https://configure.zsa.io/wally/osx"
    # 2022-02-07: Info.plist is totally wrong defined and contains no version information
    #appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | head -1 | sed -E 's/.*\/[a-zA-Z\-]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="V32BWKSNYH"
    #versionKey="CFBundleVersion"
    ;;
wavescentral)
    name="Waves Central"
    type="dmg"
    downloadURL="https://cf-installers.waves.com/WavesCentral/Install_Waves_Central.dmg"
    appNewVersion=$( curl -sf "https://register.waves.com/Autoupdate/Updates/ByProductId/1/central-mac" | grep version | cut -d" " -f2 | xargs )
    expectedTeamID="GT6E3XD798"
    ;;
weasis)
    name="Weasis"
    type="pkg"
    packageID="org.weasis.launcher"
    downloadURL="$(downloadURLFromGit nroduit Weasis)"
    appNewVersion="$(versionFromGit nroduit Weasis)"
    expectedTeamID="T52M998N47"
    ;;
webex|\
webexteams)
    # credit: Erik Stam (@erikstam)
    name="Webex"
    type="dmg"
    appNewVersion=$(curl -fs https://help.webex.com/en-us/article/8dmbcr/Webex-App-%7C-What%27s-New | tr '"' "\n" |  grep "Mac—"| head -1|sed 's/[^0-9\.]//g' )
    blockingProcesses=( "Webex" "Webex Teams" "Cisco WebEx Start" "WebexHelper")
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://binaries.webex.com/WebexDesktop-MACOS-Apple-Silicon-Gold/Webex.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/Webex.dmg"
    fi
    expectedTeamID="DE8Y96K9QP"
    ;;
webexmeetings)
    # credit: Erik Stam (@erikstam)
    name="Cisco Webex Meetings"
    type="pkgInDmg"
    downloadURL="https://akamaicdn.webex.com/client/webexapp.dmg"
    expectedTeamID="DE8Y96K9QP"
    targetDir="/Applications"
    #blockingProcessesMaxCPU="5"
    blockingProcesses=( Webex )
    ;;
webextoolsremoval)
    name="WebEx Tools Removal"
    type="pkg"
    packageID="com.microsoft.remove.WebExPT"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*WebExPT_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
wechat)
    name="WeChat"
    type="dmg"
    downloadURL="https://dldir1.qq.com/weixin/mac/WeChatMac.dmg"
    appNewVersion=$(curl -fsL 'https://dldir1.qq.com/weixin/mac/mac-release.xml' | xpath 'string(//rss/channel/item[1]/title)' 2>/dev/null)
    expectedTeamID="5A4RE8SF68"
    ;;
weprint)
    name="Print"
    type="appInDmgInZip"
    downloadURL="https://it-assets.s3.amazonaws.com/print-by-we/Print-By-We-Mac-Installer.zip"
    appNewVersion=""
    expectedTeamID="2D42ACMA8R"
    versionKey="CFBundleVersion"
    ;;
whatroute)
    name="WhatRoute"
    type="zip"
    downloadURL="$(curl -fs https://www.whatroute.net/whatroute2appcast.xml | xpath '(//rss/channel/item/enclosure/@url)' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs "https://www.whatroute.net/whatroute2appcast.xml" | xpath '(//rss/channel/item/sparkle:shortVersionString)' 2>/dev/null | cut -d ">" -f2 | cut -d "<" -f1)"
    expectedTeamID="H5879E8LML"
    ;;
whatsapp)
    name="WhatsApp"
    type="dmg"
    downloadURL="https://web.whatsapp.com/desktop/mac_native/release/?configuration=Release"
    appNewVersion=$(curl -fsLIXGET "https://web.whatsapp.com/desktop/mac_native/release/?configuration=Release" | grep -i "^location" | grep -m 1 -o "WhatsApp-.*dmg" | sed 's/.*WhatsApp-2.//g' | sed 's/.dmg//g')
    expectedTeamID="57T9237FN3"
    ;;
whimsical)
    name="Whimsical"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.whimsical.com/mac/dmg/arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.whimsical.app/mac/dmg/x64"
    fi
    appNewVersion=$(curl -sIkL $downloadURL | sed -r '/filename=/!d;s/.*filename=(.*)$/\1/' | awk '{print $2}')
    expectedTeamID="2N6497CB83"
    versionKey="CFBundleShortVersionString"
    appName="Whimsical.app"
    blockingProcesses=( "Whimsical" )
    ;;
    
wireshark)
    name="Wireshark"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      sparkleFeedURL="https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/x86-64/en-US/stable.xml"
    elif [[ $(arch) == arm64 ]]; then
      sparkleFeedURL="https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/arm64/en-US/stable.xml"
    fi
    sparkleFeed=$(curl -fs "$sparkleFeedURL")
    appNewVersion=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | cut -d '"' -f 2)
    downloadURL=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="7Z6EMTD2C6"
    ;;
wordservice)
    name="WordService"
    type="zip"
    downloadURL="$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" "https://www.devontechnologies.com/support/download" | tr '"' "\n" | grep -o "http.*download.*.zip" | grep -i wordservice | head -1)"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')"
    appNewVersion=""
    expectedTeamID="679S2QUWR8"
    ;;
workbrew)
    name="Workbrew"
    type="pkg"
    packageID="com.workbrew.Workbrew"
    downloadURL="https://console.workbrew.com/downloads/macos"
    appNewVersion="$(curl -ifs "https://console.workbrew.com/downloads/macos" | grep -o "Workbrew-[0-9].[0.9].[0-9][0-9].pkg" | grep -o "[0-9].[0.9].[0-9][0-9]")"
    appCustomVersion(){ /opt/workbrew/bin/brew --version | grep "Workbrew " | awk '{ print $2 }' | cut -d'-' -f1 }
    expectedTeamID="676JW3JDLF"
    ;;
workplacechat)
    name="Workplace Chat"
    type="dmg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    downloadPage=$(curl -s "https://www.workplace.com/resources/tech/it-configuration/download-workplace-chat")
    downloadURL=$(echo "$downloadPage" | grep -oE 'https://[^"]+\.dmg[^"]+"' | head -n 1 | sed 's/"$//' | sed 's/&amp;/\&/g')
    appNewVersion=$(echo "$downloadPage" | grep -oE '<td class="_3-mi">[0-9.]+<\/td>' | head -n 1 | sed -E 's/<\/?[^>]+>//g')
    expectedTeamID="V9WTTPBFK9"
    ;;
wrikeformac)
#Il faut chercher une solution pour DL la version ARM
    name="Wrike for Mac"
    type="dmg"
    appNewVersion="4.0.6"
    if [[ $(arch) == i386 ]]; then
        #downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.latest.dmg"      # valide pour arch i386
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.v${appNewVersion}.dmg"      # pour la coherence avec silicon, on hardcode le numéro de vesrion
    elif [[ $(arch) == arm64 ]]; then
        #downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.latest.dmg"  # ne marche pas avec latest, il faut obligatoirement un numéro de version précis
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.v${appNewVersion}.dmg"
    fi
    expectedTeamID="BD3YL53XT4"
    ;;
wwdc)
    # credit: Søren Theilgaard (@theilgaard)
    name="WWDC"
    type="dmg"
    downloadURL=$(downloadURLFromGit insidegui WWDC)
    appNewVersion=$(versionFromGit insidegui WWDC)
    expectedTeamID="8C7439RJLG"
    ;;
xbar)
    name="xbar"
    type="dmg"
    downloadURL=$(downloadURLFromGit matryer xbar)
    appNewVersion=$(versionFromGit matryer xbar)
    expectedTeamID="N3H5B92L5N"
    ;;
xcreds)
    name="XCreds"
    # Downloading from twocanoes homepage
    type="pkg"
    #packageID="com.twocanoes.pkg.secureremoteaccess"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/XCreds.pkg"
    appNewVersion=$(curl -fs "https://twocanoes.com/products/mac/xcreds/history/" | grep -A1 "<h3>Change Log</h3>" | sed -n 's/.*<h4>Version \(.*\) Build.*/\1/p')
    # GitHub download
    # type="pkg"
    # downloadURL="$(downloadURLFromGit twocanoes xcreds)"
    # appNewVersion="$(versionFromGit twocanoes xcreds)" # GitHub tag contain “_” and not “.” so our function fails to get the right version
    # appNewVersion=$(echo "$downloadURL" | sed -E 's/.*XCreds_.*-([0-9.]*)\.pkg/\1/')
    expectedTeamID="UXP6YEHSPW"
    ;;
xeroxphaser7800)
    name="XeroxPhaser"
    type="pkgInDmg"
    downloadURL=$(curl -fs "https://www.support.xerox.com/en-us/product/phaser-7800/downloads?platform=macOS14" | xmllint --html --format - 2>/dev/null | grep -o "https://.*XeroxDrivers.*.dmg")
    expectedTeamID="G59Y3XFNFR"
    ;;
xeroxprintandscan|\
xeroxworkcentre7800)
    name="XeroxWorkCentre"
    type="pkgInDmg"
    appCustomVersion(){ lpinfo -m | grep 783 | tail -n 1 | awk -F ', ' '{print $2}' }
    appNewVersion=$( curl -fsL "https://www.support.xerox.com/nl-nl/product/workcentre-7800-series/downloads?platform=macOS14" | grep .dmg | head -n 1 | awk -F '_' '{print $2}' )
    downloadURL=$( curl -fsL "https://www.support.xerox.com/nl-nl/product/workcentre-7800-series/downloads?platform=macOS14" | xmllint --html --format - 2>/dev/null | grep -o "https://.*XeroxDrivers.*.dmg" )
    expectedTeamID="G59Y3XFNFR"
    blockingProcesses=( NONE )
;;
xink)
    name="Xink"
    type="pkg"
    packageID="com.emailsignature.Xink"
    downloadURL="https://downloads.xink.io/macos/pkg"
    appNewVersion=$(curl -fs "https://downloads.xink.io/macos/appcast" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    expectedTeamID="F287823HVS"
    ;;
xmenu)
    name="XMenu"
    type="zip"
    downloadURL="$(curl -fs "https://www.devontechnologies.com/apps/freeware" | grep -o "http.*download.*.zip" | grep -i xmenu)"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')"
    expectedTeamID="679S2QUWR8"
    ;;

xmind)
    name="Xmind"
    type="dmg"
    downloadURL="https://xmind.app/zen/download/mac/"
    appNewVersion="$(curl -fsIL $downloadURL | grep -i "^location" | grep -oE 'Xmind-for-macOS-(.+?)-[0-9]+\.dmg' | sed -E 's/Xmind-for-macOS-(.+)-[0-9]+\.dmg/\1/')"
    expectedTeamID="4WV38P2X5K"
    ;;

xquartz)
    # credit: AP Orlebeke (@apizz)
    name="XQuartz"
    type="pkg"
    downloadURL=$(downloadURLFromGit XQuartz XQuartz)
    appNewVersion=$(versionFromGit XQuartz XQuartz)
    expectedTeamID="NA574AWV7E"
    ;;
yed)
    # This label assumes accept of these T&C’s: https://www.yworks.com/resources/yed/license.html
    name="yEd"
    type="dmg"
    downloadURL="https://www.yworks.com"$(curl -fs "https://www.yworks.com/products/yed/download" | grep -o -e "/resources/.*\.dmg" | tr " " '\n' | grep -o -e "/resources/.*\.dmg")
    appNewVersion=$(echo $downloadURL | sed -E 's/.*-([0-9.]*)_.*\.dmg/\1/')
    expectedTeamID="JD89S887M2"
    ;;
youleanloudnessmeter2)
    name="Youlean Loudness Meter 2"
    type="pkgInZip"
    #downloadURL="https://cdn.youlean.co/wp-content/uploads/2023/03/Youlean-Loudness-Meter-2-V2.4.4-macOS.zip"
    downloadURL=$(curl -fs "https://youlean.co/download-youlean-loudness-meter/" | grep macOS | grep -oE "https:.*-macOS.zip" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*-V([0-9.]*)-macOS.zip/\1/')
    expectedTeamID="S7KN6P3F95"
    ;;
yubicoauthenticator)
    name="Yubico Authenticator"
    type="dmg"
    downloadURL="https://developers.yubico.com/yubioath-flutter/Releases/yubico-authenticator-latest-mac.dmg"
    appNewVersion=""
    expectedTeamID="LQA3CS5MM7"
    ;;
yubikeymanager)
    name="YubiKey Manager"
    type="pkg"
    appCustomVersion(){/usr/local/ykman/ykman -v | awk '{print $5}'}
	downloadURL=$(downloadURLFromGit Yubico yubikey-manager)
    appNewVersion=$(versionFromGit Yubico yubikey-manager)
    expectedTeamID="LQA3CS5MM7"
    #CLI for YubikeyManager which is not installed via the QT version.
    ;;
yubikeymanagerqt)
    name="YubiKey Manager GUI"
    type="pkg"
    downloadURL="https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-latest-mac.pkg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | grep -Eo "[1-9][0-9\.]*" )
    expectedTeamID="LQA3CS5MM7"
    ;;
zappy)
    name="Zappy"
    type="appInDmgInZip"
    downloadURL="https://zappy.zapier.com/releases/zappy-latest.zip"
    expectedTeamID="6LS97Q5E79"
    ;;
zeplin)
    name="Zeplin"
    type="zip"
    downloadURL="https://zpl.io/download-mac"
    appNewVersion="$(curl -fs "https://api.appcenter.ms/v0.1/public/sparkle/apps/8926efff-e734-b6d3-03d0-9f41d90c34fc" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)"
    expectedTeamID="8U3Y4X5WDQ"
    ;;
zerotier)
    # credit: Michael T (PurpleComputing)
    name="ZeroTier%20One"
    type="pkg"
    packageID="com.zerotier.pkg.ZeroTierOne"
    appNewVersion=$(versionFromGit zerotier ZeroTierOne )
    downloadURL="https://download.zerotier.com/dist/ZeroTier%20One.pkg"
    expectedTeamID="8ZD9JUCZ4V"
    ;;
zipwhip)
    name="Zipwhip"
    type="dmg"
    downloadURL="https://s3-us-west-2.amazonaws.com/zw-app-upload/mac/master/Zipwhip-latest.dmg"
    appNewVersion=""
    expectedTeamID="96NL5642U7"
    ;;
zohoworkdrive)
# Using this label expects you to agree to these:
# License Areemant: https://www.zoho.com/workdrive/zohoworkdrive-license-agreement.html
# Privacy policy: https://www.zoho.com/privacy.html
    name="Zoho WorkDrive"
    type="dmg"
    lines=$(curl -fs https://www.zohowebstatic.com/sites/all/themes/zoho/scripts/workdrive.js | grep files-accl.zohopublic.com | tr '"' "\n")
    downloadURL=$(echo "$lines" | grep -i "files-accl.zohopublic.com")$(echo "$lines" | grep -i -A17 "files-accl.zohopublic.com" | grep -i -A2 macintosh | tail -1)
    expectedTeamID="TZ824L8Y37"
    ;;
zohoworkdrivegenie)
    name="Zoho WorkDrive Genie"
    type="dmg"
    # https://www.zoho.com/workdrive/genie.html
    downloadURL="https://www.zoho.com/workdrive/downloads/edit-tool/Zoho_WorkDrive_Genie.dmg"
    CLIInstaller="Zoho WorkDrive Genie.app/Contents/MacOS/Zoho WorkDrive Genie"
    expectedTeamID="TZ824L8Y37"
    ;;
zohoworkdrivetruesync)
# Using this label expects you to agree to these:
# License Areemant: https://www.zoho.com/workdrive/zohoworkdrive-license-agreement.html
# Privacy policy: https://www.zoho.com/privacy.html
    name="Zoho WorkDrive TrueSync"
    type="pkg"
    #https://www.zoho.com/workdrive/truesync.html
    downloadURL="https://files-accl.zohopublic.com/public/tsbin/download/c488f53fb0fe339a8a3868a16d56ede6"
    expectedTeamID="TZ824L8Y37"
    ;;
zoom)
    name="zoom.us"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomInstallerIT.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f5)"
    expectedTeamID="BJ4HAAB9B3"
    versionKey="CFBundleVersion"
    ;;
zoomclient)
    name="zoom.us"
    type="pkg"
    packageID="us.zoom.pkg.videomeeting"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://zoom.us/client/latest/Zoom.pkg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://zoom.us/client/latest/Zoom.pkg?archType=arm64"
    fi
    expectedTeamID="BJ4HAAB9B3"
    #appNewVersion=$(curl -is "https://beta2.communitypatch.com/jamf/v1/ba1efae22ae74a9eb4e915c31fef5dd2/patch/zoom.us" | grep currentVersion | tr ',' '\n' | grep currentVersion | cut -d '"' -f 4) # Does not match packageID
    blockingProcesses=( zoom.us )
    #blockingProcessesMaxCPU="5"
    ;;
zoomgov)
    name="zoom.us"
    type="pkg"
    downloadURL="https://www.zoomgov.com/client/latest/ZoomInstallerIT.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f5)"
    expectedTeamID="BJ4HAAB9B3"
    versionKey="CFBundleVersion"
    ;;
zoomoutlookplugin)
    name="Zoom Outlook Plugin"
    appName="PluginLauncher.app"
    targetDir="/Applications/ZoomOutlookPlugin"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomMacOutlookPlugin.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f5 | cut -d "." -f1-3)"
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( "PluginLauncher" )
    ;;
zoomoutlookpluginremoval)
    name="Zoom Outlook Plugin Removal"
    type="pkg"
    packageID="com.microsoft.remove.ZoomPlugin"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*ZoomPlugin_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;
zoompresence|\
zoomrooms)
    name="ZoomPresence"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomRooms.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i location | cut -d "/" -f5)"
    expectedTeamID="BJ4HAAB9B3"
    ;;
zotero)
    name="Zotero"
    type="dmg"
    downloadURL="https://www.zotero.org/download/client/dl?channel=release&platform=mac&version=$(curl -fs "https://www.zotero.org/download/" | grep -Eio '"mac":"(.*)' | cut -d '"' -f 4)"
    expectedTeamID="8LAYR367YV"
    appNewVersion=$(curl -fs "https://www.zotero.org/download/" | grep -Eio '"mac":"(.*)' | cut -d '"' -f 4)
    #Company="Corporation for Digital Scholarship"
    ;;
zulip)
    name="Zulip"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://zulip.com/apps/download/mac"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://zulip.com/apps/download/mac-arm64"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i ^location | sed 's/.*\/v\(.*\)\/Zulip-.*/\1/')
    expectedTeamID="66KHCWMEYB"
    ;;
zulujdk11)
    name="Zulu JDK 11"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.11"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu11.*ca-jdk11.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu11.*ca-jdk11.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
zulujdk13)
    name="Zulu JDK 13"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.13"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu13.*ca-jdk13.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu13.*ca-jdk13.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
zulujdk15)
    name="Zulu JDK 15"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.15"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu15.*ca-jdk15.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu15.*ca-jdk15.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
zulujdk17)
    name="Zulu JDK 17"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.17"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu17.*ca-jdk17.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu17.*ca-jdk17.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
zulujdk18)
    name="Zulu JDK 18"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.18"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu18.*ca-jdk18.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu18.*ca-jdk18.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort | cut -c11- | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
zulujdk21)
    name="Zulu JDK 21"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.21"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu21.*ca-jdk21.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu21.*ca-jdk21.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; fi }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//" | sed 's/jdk//') 
    ;;
zulujdk23)
    name="Zulu JDK 23"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.23"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu23.*ca-jdk23.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu23.*ca-jdk23.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-23.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-23.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; fi }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//" | sed 's/jdk//') 
    ;;
zulujdk8)
    name="Zulu JDK 8"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.8"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu8.*ca-jdk8.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu8.*ca-jdk8.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; fi }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//" | sed 's/jdk//') 
    ;;
zulujdkfx17)
    name="Zulu JDK FX 17"
    type="pkgInDmg"
    packageID="com.azulsystems.zulufx.17"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu17.*ca-fx-jdk17.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sort | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu17.*ca-fx-jdk17.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sort | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
*)
    # unknown label
    #printlog "unknown label $label"
    cleanupAndExit 1 "unknown label $label" ERROR
    ;;
esac

# MARK: reading arguments again
printlog "Reading arguments again: ${argumentsArray[*]}" INFO
for argument in "${argumentsArray[@]}"; do
    printlog "argument: $argument" DEBUG
    eval $argument
done

# verify we have everything we need
if [[ -z $name ]]; then
    printlog "need to provide 'name'" ERROR
    exit 1
fi
if [[ -z $type ]]; then
    printlog "need to provide 'type'" ERROR
    exit 1
fi
if [[ -z $downloadURL ]]; then
    printlog "need to provide 'downloadURL'" ERROR
    exit 1
fi
if [[ -z $expectedTeamID ]]; then
    printlog "need to provide 'expectedTeamID'" ERROR
    exit 1
fi

# Are we only asked to return label name
if [[ $RETURN_LABEL_NAME -eq 1 ]]; then
    printlog "Only returning label name." REQ
    printlog "$name"
    echo "$name"
    exit
fi

# MARK: application download and installation starts here

# Debug output of all variables in a label
printlog "name=${name}" DEBUG
printlog "appName=${appName}" DEBUG
printlog "type=${type}" DEBUG
printlog "archiveName=${archiveName}" DEBUG
printlog "downloadURL=${downloadURL}" DEBUG
printlog "curlOptions=${curlOptions}" DEBUG
printlog "appNewVersion=${appNewVersion}" DEBUG
printlog "appCustomVersion function: $(if type 'appCustomVersion' 2>/dev/null | grep -q 'function'; then echo "Defined. ${appCustomVersion}"; else; echo "Not defined"; fi)" DEBUG
printlog "versionKey=${versionKey}" DEBUG
printlog "packageID=${packageID}" DEBUG
printlog "pkgName=${pkgName}" DEBUG
printlog "choiceChangesXML=${choiceChangesXML}" DEBUG
printlog "expectedTeamID=${expectedTeamID}" DEBUG
printlog "blockingProcesses=${blockingProcesses}" DEBUG
printlog "installerTool=${installerTool}" DEBUG
printlog "CLIInstaller=${CLIInstaller}" DEBUG
printlog "CLIArguments=${CLIArguments}" DEBUG
printlog "updateTool=${updateTool}" DEBUG
printlog "updateToolArguments=${updateToolArguments}" DEBUG
printlog "updateToolRunAsCurrentUser=${updateToolRunAsCurrentUser}" DEBUG
#printlog "Company=${Company}" DEBUG # Not used

# NOTE: Do not disturb active display sleep assertion
if [[ ${INTERRUPT_DND} = "no" ]]; then
    # Check if a fullscreen app is active
    if hasDisplaySleepAssertion; then
        cleanupAndExit 24 "active display sleep assertion detected, aborting" ERROR
    fi
fi

printlog "BLOCKING_PROCESS_ACTION=${BLOCKING_PROCESS_ACTION}"
printlog "NOTIFY=${NOTIFY}"
printlog "LOGGING=${LOGGING}"

# NOTE: Finding LOGO to use in dialogs
case $LOGO in
    appstore)
        # Apple App Store on Mac
        if [[ $(sw_vers -buildVersion) > "19" ]]; then
            LOGO="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
        else
            LOGO="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
        fi
        ;;
    jamf)
        # Jamf Pro
        LOGO="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"
        ;;
    mosyleb)
        # Mosyle Business
        LOGO="/Applications/Self-Service.app/Contents/Resources/AppIcon.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Mosyle Corporation MDM"; fi
        ;;
    mosylem)
        # Mosyle Manager (education)
        LOGO="/Applications/Manager.app/Contents/Resources/AppIcon.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Mosyle Corporation MDM"; fi
        ;;
    addigy)
        # Addigy
        LOGO="/Library/Addigy/macmanage/MacManage.app/Contents/Resources/atom.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="MDM Profile"; fi
        ;;
    microsoft)
        # Microsoft Endpoint Manager (Intune)
        if [[ -d "/Library/Intune/Microsoft Intune Agent.app" ]]; then
            LOGO="/Library/Intune/Microsoft Intune Agent.app/Contents/Resources/AppIcon.icns"
        elif [[ -d "/Applications/Company Portal.app" ]]; then
            LOGO="/Applications/Company Portal.app/Contents/Resources/AppIcon.icns"
        fi
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Management Profile"; fi
        ;;
    ws1)
        # Workspace ONE (AirWatch)
        LOGO="/Applications/Workspace ONE Intelligent Hub.app/Contents/Resources/AppIcon.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Device Manager"; fi
        ;;
    kandji)
        # Kandji
        LOGO="/Applications/Kandji Self Service.app/Contents/Resources/AppIcon.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="MDM Profile"; fi
        ;;
    filewave)
        # FileWave
        LOGO="/usr/local/sbin/FileWave.app/Contents/Resources/fwGUI.app/Contents/Resources/kiosk.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="FileWave MDM Configuration"; fi
        ;;
esac
if [[ ! -a "${LOGO}" ]]; then
    if [[ $(sw_vers -buildVersion) > "19" ]]; then
        LOGO="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    else
        LOGO="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    fi
fi
printlog "LOGO=${LOGO}" INFO

printlog "Label type: $type" INFO

# NOTE: extract info from data
if [ -z "$archiveName" ]; then
    case $type in
        dmg|pkg|zip|tbz|bz2)
            archiveName="${name}.$type"
            ;;
        pkgInDmg)
            archiveName="${name}.dmg"
            ;;
        *InZip)
            archiveName="${name}.zip"
            ;;
        updateronly)
            ;;
        *)
            printlog "Cannot handle type $type"
            cleanupAndExit 99
            ;;
    esac
fi
printlog "archiveName: $archiveName" INFO

if [ -z "$appName" ]; then
    # when not given derive from name
    appName="$name.app"
fi

if [ -z "$targetDir" ]; then
    case $type in
        dmg|zip|tbz|bz2|app*)
            targetDir="/Applications"
            ;;
        pkg*)
            targetDir="/"
            ;;
        updateronly)
            ;;
        *)
            cleanupAndExit 99 "Cannot handle type $type" ERROR
            ;;
    esac
fi

if [[ -z $blockingProcesses ]]; then
    printlog "no blocking processes defined, using $name as default" INFO
    blockingProcesses=( $name )
fi

# MARK: determine tmp dir
if [ "$DEBUG" -eq 1 ]; then
    # for debugging use script dir as working directory
    tmpDir=$(dirname "$0")
else
    # create temporary working directory
    tmpDir=$(mktemp -d )
fi

# NOTE: change directory to temporary working directory
printlog "Changing directory to $tmpDir" DEBUG
if ! cd "$tmpDir"; then
    cleanupAndExit 13 "error changing directory $tmpDir" ERROR
fi

# MARK: get installed version
getAppVersion
printlog "appversion: $appversion"

# NOTE: Exit if new version is the same as installed version (appNewVersion specified)
if [[ "$type" != "updateronly" && ($INSTALL == "force" || $IGNORE_APP_STORE_APPS == "yes") ]]; then
    printlog "Label is not of type “updateronly”, and it’s set to use force to install or ignoring app store apps, so not using updateTool."
    updateTool=""
fi
if [[ -n $appNewVersion ]]; then
    printlog "Latest version of $name is $appNewVersion"
    if [[ $appversion == $appNewVersion ]]; then
        if [[ $DEBUG -ne 1 ]]; then
            printlog "There is no newer version available."
            if [[ $INSTALL != "force" ]]; then
                message="$name, version $appNewVersion, is the latest version."
                if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                    printlog "notifying"
                    displaynotification "$message" "No update for $name!"
                fi
                if [[ $DIALOG_CMD_FILE != "" ]]; then
                    updateDialog "complete" "Latest version already installed..."
                    sleep 2
                fi
                cleanupAndExit 0 "No newer version." REQ
            fi
        else
            printlog "DEBUG mode 1 enabled, not exiting, but there is no new version of app." WARN
        fi
    fi
else
    printlog "Latest version not specified."
fi

# MARK: check if this is an Update and we can use updateTool
if [[ (-n $appversion && -n "$updateTool") || "$type" == "updateronly" ]]; then
    printlog "App needs to be updated and uses $updateTool. Ignoring BLOCKING_PROCESS_ACTION and running updateTool now."
    updateDialog "wait" "Updating..."

    if [[ $DEBUG -ne 1 ]]; then
        if runUpdateTool; then
            finishing
            cleanupAndExit 0 "updateTool has run" REQ
        elif [[ $type == "updateronly" ]];then
            cleanupAndExit 0 "type is $type so we end here." REQ
        fi # otherwise continue
    else
        printlog "DEBUG mode 1 enabled, not running update tool" WARN
    fi
fi

# MARK: download the archive
if [ -f "$archiveName" ] && [ "$DEBUG" -eq 1 ]; then
    printlog "$archiveName exists and DEBUG mode 1 enabled, skipping download"
else
    # download
    printlog "Downloading $downloadURL to $archiveName" REQ
    if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
        printlog "notifying"
        if [[ $updateDetected == "YES" ]]; then
            displaynotification "Downloading $name update" "Download in progress …"
        else
            displaynotification "Downloading new $name" "Download in progress …"
        fi
    fi

    if [[ $DIALOG_CMD_FILE != "" ]]; then
        # pipe
        pipe="$tmpDir/downloadpipe"
        # initialise named pipe for curl output
        initNamedPipe create $pipe

        # run the pipe read in the background
        readDownloadPipe $pipe "$DIALOG_CMD_FILE" & downloadPipePID=$!
        printlog "listening to output of curl with pipe $pipe and command file $DIALOG_CMD_FILE on PID $downloadPipePID" DEBUG

        curlDownload=$(curl -fL -# --show-error ${curlOptions} "$downloadURL" -o "$archiveName" 2>&1 | tee $pipe)
        # because we are tee-ing the output, we want the pipe status of the first command in the chain, not the most recent one
        curlDownloadStatus=$(echo $pipestatus[1])
        killProcess $downloadPipePID

    else
        printlog "No Dialog connection, just download" DEBUG
        curlDownload=$(curl -v -fsL --show-error ${curlOptions} "$downloadURL" -o "$archiveName" 2>&1)
        curlDownloadStatus=$(echo $?)
    fi

    # Trying to detect proxy or web filter on downloaded file
    archiveSHA=$(shasum "$archiveName" | cut -w -f 1)
    archiveSize=$(du -k "$archiveName" | cut -w -f 1)
    archiveType=$(file "$archiveName" | cut -d ':' -f2 )
    printlog "Downloaded $archiveName – Type is $archiveType – SHA is $archiveSHA – Size is $archiveSize kB" INFO

    # Trying to detect download errors, including proxy or web filter blocking on downloaded file
    if [[ $curlDownloadStatus -ne 0 || $archiveType == *ASCII* ]]; then
        printlog "error downloading $downloadURL" ERROR
        message="$name update/installation failed. This will be logged, so IT can follow up."
        if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
            printlog "notifying"
            if [[ $updateDetected == "YES" ]]; then
                displaynotification "$message" "Error updating $name"
            else
                displaynotification "$message" "Error installing $name"
            fi
        fi
        if [[ $archiveType == *ASCII* ]]; then
            firstLines=$(head -c 51170 $archiveName)
            deduplicatelogs $firstLines
            cleanupAndExit 2 "File Downloaded is ASCII, we’re probably being blocked by a proxy or filter.  First 5k of file is:\n$logoutput" ERROR
        else
            deduplicatelogs "$curlDownload"
            cleanupAndExit 2 "Error downloading $downloadURL error:\n$logoutput" ERROR
        fi
    fi
fi

# MARK: when user is logged in, and app is running, prompt user to quit app
if [[ $BLOCKING_PROCESS_ACTION == "ignore" ]]; then
    printlog "ignoring blocking processes"
else
    if [[ $currentUser != "loginwindow" ]]; then
        if [[ ${#blockingProcesses} -gt 0 ]]; then
            if [[ ${blockingProcesses[1]} != "NONE" ]]; then
                checkRunningProcesses
            fi
        fi
    fi
fi

# MARK: install the download
printlog "Installing $name" REQ
if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
    printlog "notifying"
    if [[ $updateDetected == "YES" ]]; then
        displaynotification "Updating $name" "Installation in progress …"
        updateDialog "wait" "Updating..."
    else
        displaynotification "Installing $name" "Installation in progress …"
        updateDialog "wait" "Installing..."
    fi
fi

if [ -n "$installerTool" ]; then
    # installerTool defined, and we use that for installation
    printlog "installerTool used: $installerTool" REQ
    appName="$installerTool"
fi

case $type in
    dmg)
        installFromDMG
        ;;
    pkg)
        installFromPKG
        ;;
    zip)
        installFromZIP
        ;;
    tbz|bz2)
        installFromTBZ
        ;;
    pkgInDmg)
        installPkgInDmg
        ;;
    pkgInZip)
        installPkgInZip
        ;;
    appInDmgInZip)
        installAppInDmgInZip
        ;;
    *)
        cleanupAndExit 99 "Cannot handle type $type" ERROR
        ;;
esac

updateDialog "wait" "Finishing..."

# MARK: Finishing — print installed application location and version
finishing

# all done!
cleanupAndExit 0 "All done!" REQ
