# MARK: Functions

cleanupAndExit() { # $1 = exit code, $2 message
    if [[ -n $2 && $1 -ne 0 ]]; then
        printlog "ERROR: $2"
    fi
    if [ "$DEBUG" -ne 1 ]; then
        # remove the temporary working directory when done
        printlog "Deleting $tmpDir"
        rm -Rf "$tmpDir"
    fi

    if [ -n "$dmgmount" ]; then
        # unmount disk image
        printlog "Unmounting $dmgmount"
        hdiutil detach "$dmgmount"
    fi
    # If we closed any processes, reopen the app again
    reopenClosedProcess
    printlog "################## End Installomator, exit code $1 \n\n"
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
    runAsUser osascript -e "button returned of (display dialog \"$message\" with  title \"$title\" buttons {\"Not Now\", \"Quit and Update\"} default button \"Quit and Update\" with icon POSIX file \"$LOGO\")"
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

    if [[ -x "$manageaction" ]]; then
         "$manageaction" -message "$message" -title "$title"
    else
        runAsUser osascript -e "display notification \"$message\" with title \"$title\""
    fi
}


# MARK: Logging
log_location="/private/var/log/Installomator.log"

printlog(){

    timestamp=$(date +%F\ %T)
        
    if [[ "$(whoami)" == "root" ]]; then
        echo "$timestamp" "$label" "$1" | tee -a $log_location
    else
        echo "$timestamp" "$label" "$1"
    fi
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
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" \
    | awk -F '"' "/browser_download_url/ && /$archiveName\"/ { print \$4; exit }")
    else
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" \
    | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
    fi
    if [ -z "$downloadURL" ]; then
        cleanupAndExit 9 "could not retrieve download URL for $gitusername/$gitreponame"
        #exit 9
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
        
    appNewVersion=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | grep tag_name | cut -d '"' -f 4 | sed 's/[^0-9\.]//g')
    if [ -z "$appNewVersion" ]; then
        printlog "could not retrieve version number for $gitusername/$gitreponame"
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
		/usr/bin/xpath -e $@
		# alternative: switch to xmllint (which is not perl)
		#xmllint --xpath $@ -
	else
		/usr/bin/xpath $@
	fi
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
    
    # get app in /Applications, or /Applications/Utilities, or find using Spotlight
    if [[ -d "/Applications/$appName" ]]; then
        applist="/Applications/$appName"
    elif [[ -d "/Applications/Utilities/$appName" ]]; then
        applist="/Applications/Utilities/$appName"
    else
        applist=$(mdfind "kind:application $appName" -0 )
    fi
    if [[ -z applist ]]; then
        printlog "No previous app found"
    else
        printlog "App(s) found: ${applist}"
    fi

    appPathArray=( ${(0)applist} )

    if [[ ${#appPathArray} -gt 0 ]]; then
        filteredAppPaths=( ${(M)appPathArray:#${targetDir}*} )
        if [[ ${#filteredAppPaths} -eq 1 ]]; then
            installedAppPath=$filteredAppPaths[1]
            #appversion=$(mdls -name kMDItemVersion -raw $installedAppPath )
            appversion=$(defaults read $installedAppPath/Contents/Info.plist $versionKey) #Not dependant on Spotlight indexing
            printlog "found app at $installedAppPath, version $appversion"
            updateDetected="YES"
            # Is current app from App Store
            if [[ -d "$installedAppPath"/Contents/_MASReceipt ]];then
                printlog "Installed $appName is from App Store, use “IGNORE_APP_STORE_APPS=yes” to replace."
                if [[ $IGNORE_APP_STORE_APPS == "yes" ]]; then
                    printlog "Replacing App Store apps, no matter the version"
                    appversion=0
                else
                    cleanupAndExit 1 "App previously installed from App Store, and we respect that"
                fi
            fi
        else
            printlog "could not determine location of $appName"
        fi
    else
        printlog "could not find $appName"
    fi
}

checkRunningProcesses() {
    # don't check in DEBUG mode 1
    if [[ $DEBUG -eq 1 ]]; then
        printlog "DEBUG mode 1, not checking for blocking processes"
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
                      button=$(displaydialog "Quit “$x” to continue updating? (Leave this dialogue if you want to activate this update later)." "The application “$x” needs to be updated.")
                      if [[ $button = "Not Now" ]]; then
                        cleanupAndExit 10 "user aborted update"
                      else
                        if [[ $i > 2 && $BLOCKING_PROCESS_ACTION = "prompt_user_then_kill" ]]; then
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
                      button=$(displaydialog "Quit “$x” to continue updating? (Click “Not Now” to be asked in 1 hour, or leave this open until you are ready)." "The application “$x” needs to be updated.")
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
                      cleanupAndExit 12 "blocking process '$x' found, aborting"
                      ;;
                esac

                countedProcesses=$((countedProcesses + 1))
            fi
        done

    done

    if [[ $countedProcesses -ne 0 ]]; then
        cleanupAndExit 11 "could not quit all processes, aborting..."
    fi

    printlog "no more blocking processes, continue with update"
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
        printlog "DEBUG mode 1, not reopening anything"
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
        printlog "App not closed, so no reopen."
    fi
}

installAppWithPath() { # $1: path to app to install in $targetDir
    # modified by: Søren Theilgaard (@theilgaard)
    appPath=${1?:"no path to app"}

    # check if app exists
    if [ ! -e "$appPath" ]; then
        cleanupAndExit 8 "could not find: $appPath"
    fi

    # verify with spctl
    printlog "Verifying: $appPath"
    if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' ); then
        cleanupAndExit 4 "Error verifying $appPath"
    fi

    printlog "Team ID matching: $teamID (expected: $expectedTeamID )"

    if [ "$expectedTeamID" != "$teamID" ]; then
        cleanupAndExit 5 "Team IDs do not match"
    fi

    # versioncheck
    # credit: Søren Theilgaard (@theilgaard)
    appNewVersion=$(defaults read $appPath/Contents/Info.plist $versionKey)
    if [[ -n $appNewVersion && $appversion == $appNewVersion ]]; then
        printlog "Downloaded version of $name is $appNewVersion, same as installed."
        if [[ $INSTALL != "force" ]]; then
            message="$name, version $appNewVersion, is the latest version."
            if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                printlog "notifying"
                displaynotification "$message" "No update for $name!"
            fi
            cleanupAndExit 0 "No new version to install"
        else
            printlog "Using force to install anyway."
        fi
    else
        printlog "Downloaded version of $name is $appNewVersion (replacing version $appversion)."
    fi

    # skip install for DEBUG 1
    if [ "$DEBUG" -eq 1 ]; then
        printlog "DEBUG mode 1 enabled, skipping remove, copy and chown steps"
        return 0
    fi

    # skip install for DEBUG 2
    if [ "$DEBUG" -eq 2 ]; then
        printlog "DEBUG mode 2 enabled, exiting"
        cleanupAndExit 0
    fi
    
    # Test if variable CLIInstaller is set
    if [[ -z $CLIInstaller ]]; then
    
        # remove existing application
        if [ -e "$targetDir/$appName" ]; then
            printlog "Removing existing $targetDir/$appName"
            rm -Rf "$targetDir/$appName"
        fi

        # copy app to /Applications
        printlog "Copy $appPath to $targetDir"
        if ! ditto "$appPath" "$targetDir/$appName"; then
            cleanupAndExit 7 "Error while copying"
        fi

        # set ownership to current user
        if [ "$currentUser" != "loginwindow" ]; then
            printlog "Changing owner to $currentUser"
            chown -R "$currentUser" "$targetDir/$appName"
        else
            printlog "No user logged in, not changing user"
        fi

    elif [[ ! -z $CLIInstaller ]]; then
        mountname=$(dirname $appPath)
        printlog "CLIInstaller exists, running installer command $mountname/$CLIInstaller $CLIArguments" #INFO

        CLIoutput=$("$mountname/$CLIInstaller" "${CLIArguments[@]}" 2>&1)
        CLIstatus=$(echo $?)
        logoutput="$CLIoutput" # dedupliatelogs "$CLIoutput"

        if [ $CLIstatus -ne 0 ] ; then
            cleanupAndExit 3 "Error installing $mountname/$CLIInstaller $CLIArguments error:\n$logoutput" #ERROR
        else
            printlog "Succesfully ran $mountname/$CLIInstaller $CLIArguments"
        fi
        printlog "Debugging enabled, update tool output was:\n$logoutput" #DEBUG
    fi

}

mountDMG() {
    # mount the dmg
    printlog "Mounting $tmpDir/$archiveName"
    # always pipe 'Y\n' in case the dmg requires an agreement
    if ! dmgmount=$(echo 'Y'$'\n' | hdiutil attach "$tmpDir/$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        cleanupAndExit 3 "Error mounting $tmpDir/$archiveName"
    fi

    if [[ ! -e $dmgmount ]]; then
        printlog "Error mounting $tmpDir/$archiveName"
        cleanupAndExit 3
    fi

    printlog "Mounted: $dmgmount"
}

installFromDMG() {
    mountDMG
    installAppWithPath "$dmgmount/$appName"
}

installFromPKG() {
    # verify with spctl
    printlog "Verifying: $archiveName"
    
    if ! spctlout=$(spctl -a -vv -t install "$archiveName" 2>&1 ); then
        printlog "Error verifying $archiveName"
        cleanupAndExit 4
    fi
    
    teamID=$(echo $spctlout | awk -F '(' '/origin=/ {print $2 }' | tr -d '()' )

    # Apple signed software has no teamID, grab entire origin instead
    if [[ -z $teamID ]]; then
        teamID=$(echo $spctlout | awk -F '=' '/origin=/ {print $NF }')
    fi


    printlog "Team ID: $teamID (expected: $expectedTeamID )"

    if [ "$expectedTeamID" != "$teamID" ]; then
        printlog "Team IDs do not match!"
        cleanupAndExit 5
    fi

    # Check version of pkg to be installed if packageID is set
    if [[ $packageID != "" && $appversion != "" ]]; then
        printlog "Checking package version."
        pkgutil --expand "$archiveName" "$archiveName"_pkg
        #printlog "$(cat "$archiveName"_pkg/Distribution | xpath '//installer-gui-script/pkg-ref[@id][@version]' 2>/dev/null)"
        appNewVersion=$(cat "$archiveName"_pkg/Distribution | xpath '//installer-gui-script/pkg-ref[@id][@version]' 2>/dev/null | grep -i "$packageID" | tr ' ' '\n' | grep -i version | cut -d \" -f 2) #sed -E 's/.*\"([0-9.]*)\".*/\1/g'
        rm -r "$archiveName"_pkg
        printlog "Downloaded package $packageID version $appNewVersion"
        if [[ $appversion == $appNewVersion ]]; then
            printlog "Downloaded version of $name is the same as installed."
            if [[ $INSTALL != "force" ]]; then
                message="$name, version $appNewVersion, is the latest version."
                if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                    printlog "notifying"
                    displaynotification "$message" "No update for $name!"
                fi
                cleanupAndExit 0 "No new version to install"
            else
                printlog "Using force to install anyway."
            fi
        fi
    fi
    
    # skip install for DEBUG 1
    if [ "$DEBUG" -eq 1 ]; then
        printlog "DEBUG enabled, skipping installation"
        return 0
    fi

    # skip install for DEBUG 2
    if [ "$DEBUG" -eq 2 ]; then
        printlog "DEBUG mode 2 enabled, exiting"
        cleanupAndExit 0 
    fi

    # install pkg
    printlog "Installing $archiveName to $targetDir"
    if ! installer -pkg "$archiveName" -tgt "$targetDir" ; then
        printlog "error installing $archiveName"
        cleanupAndExit 9
    fi
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
        findfiles=$(find "$dmgmount" -iname "*.pkg" -maxdepth 1  )
        filearray=( ${(f)findfiles} )
        if [[ ${#filearray} -eq 0 ]]; then
            cleanupAndExit 20 "couldn't find pkg in dmg $archiveName"
        fi
        archiveName="${filearray[1]}"
        printlog "found pkg: $archiveName"
    else
        # it is now safe to overwrite archiveName for installFromPKG
        archiveName="$dmgmount/$pkgName"
    fi

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
        findfiles=$(find "$tmpDir" -iname "*.pkg" -maxdepth 2  )
        filearray=( ${(f)findfiles} )
        if [[ ${#filearray} -eq 0 ]]; then
            cleanupAndExit 20 "couldn't find pkg in zip $archiveName"
        fi
        archiveName="${filearray[1]}"
        # it is now safe to overwrite archiveName for installFromPKG
        printlog "found pkg: $archiveName"
    else
        # it is now safe to overwrite archiveName for installFromPKG
        archiveName="$tmpDir/$pkgName"
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
            cleanupAndExit 20 "couldn't find dmg in zip $archiveName"
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
            runAsUser $updateTool ${updateToolArguments}
        else
            $updateTool ${updateToolArguments}
        fi
        if [[ $? -ne 0 ]]; then
            cleanupAndExit 15 "Error running $updateTool"
        fi
    else
        printlog "couldn't find $updateTool, continuing normally"
        return 1
    fi
    return 0
}

finishing() {
    printlog "Finishing..."
    sleep 10 # wait a moment to let spotlight catch up
    getAppVersion

    if [[ -z $appversion ]]; then
        message="Installed $name"
    else
        message="Installed $name, version $appversion"
    fi

    printlog "$message"

    if [[ $currentUser != "loginwindow" && ( $NOTIFY == "success" || $NOTIFY == "all" ) ]]; then
        printlog "notifying"
        if [[ $updateDetected == "YES" ]]; then
            displaynotification "$message" "$name update complete!"
        else
            displaynotification "$message" "$name installation complete!"
        fi
    fi
}


