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

