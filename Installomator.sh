#!/bin/zsh
label="" # if no label is sent to the script, this will be used

# Installomator
#
# Downloads and installs an Applications
# 2020 Armin Briegel - Scripting OS X
#
# inspired by the download scripts from William Smith and Sander Schram
# with additional ideas and contribution from Isaac Ordonez, Mann consulting
# and help from Søren Theilgaard (theilgaard.dk)

VERSION='0.5.0'
VERSIONDATE='2021-04-13'

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# NOTE: adjust these variables:

# set to 0 for production, 1 for debugging
# while debugging, items will be downloaded to the parent directory of this script
# also no actual installation will be performed
DEBUG=1

# notify behavior
NOTIFY=success
# options:
#   - success      notify the user on success
#   - silent       no notifications
#   - all          all notifications (great for Self Service installation)


# behavior when blocking processes are found
BLOCKING_PROCESS_ACTION=prompt_user
# options:
#   - ignore       continue even when blocking processes are found
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
#   - tell_user    User will be showed a notification about the important update,
#                  but user is only allowed to quit and continue, and then we
#                  ask the app to quit.
#   - tell_user_then_kill
#                  Show dialog 2 times, and if the quitting fails, the
#                  blocking processes will be killed.
#   - kill         kill process without prompting or giving the user a chance to save


# logo-icon used in dialog boxes if app is blocking
LOGO=appstore
# options:
#   - appstore      Icon is Apple App Store (default)
#   - jamf          JAMF Pro
#   - mosyleb       Mosyle Business
#   - mosylem       Mosyle Manager (Education)
#   - addigy        Addigy
# path can also be set in the command call, and if file exists, it will be used, like 'LOGO="/System/Applications/App\ Store.app/Contents/Resources/AppIcon.icns"' (spaces are escaped).


# install behavior
INSTALL=""
# options:
#  -               When not set, software will only be installed
#                  if it is newer/different in version
#  - force         Install even if it’s the same version


# Re-opening of closed app
REOPEN="yes"
# options:
#  - yes           App wil be reopened if it was closed
#  - no            App not reopened


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
#   If given, will be used to find version of installed software, instead of searching for an app.
#   Usefull if a pkg does not install an app.
#   See label installomator_st
#
# - downloadURL: (required)
#   URL to download the dmg.
#   Can be generated with a series of commands (see BBEdit for an example).
#
# - appNewVersion: (optional)
#   Version of the downloaded software.
#   If given, it will be compared to installed version, to see if download is different.
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
#   File name of the pkg/dmg file _inside_ the dmg or zip
#   When not given the pkgName is derived from the $name
#
# - updateTool:
# - updateToolArguments:
#   When Installomator detects an existing installation of the application,
#   and the updateTool variable is set
#      $updateTool $updateArguments
#   Will be run instead of of downloading and installing a complete new version.
#   Use this when the updateTool does differential and optimized downloads.
#   e.g. msupdate
#
# - updateToolRunAsCurrentUser:
#   When this variable is set (any value), $updateTool will be run as the current user.
#


# MARK: Functions

cleanupAndExit() { # $1 = exit code, $2 message
    if [[ -n $2 && $1 -ne 0 ]]; then
        printlog "ERROR: $2"
    fi
    if [ "$DEBUG" -eq 0 ]; then
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
            return
        else
            printlog "No version found using packageID $packageID"
        fi
    fi
    
    # get all apps matching name
    applist=$(mdfind "kind:application $appName" -0 )
    if [[ $applist = "" ]]; then
        printlog "Spotlight not returning any app, trying manually in /Applications."
        if [[ -d "/Applications/$appName" ]]; then
            applist="/Applications/$appName"
        fi
    fi
     
    appPathArray=( ${(0)applist} )

    if [[ ${#appPathArray} -gt 0 ]]; then
        filteredAppPaths=( ${(M)appPathArray:#${targetDir}*} )
        if [[ ${#filteredAppPaths} -eq 1 ]]; then
            installedAppPath=$filteredAppPaths[1]
            #appversion=$(mdls -name kMDItemVersion -raw $installedAppPath )
            appversion=$(defaults read $installedAppPath/Contents/Info.plist $versionKey) #Not dependant on Spotlight indexing
            printlog "found app at $installedAppPath, version $appversion"
        else
            printlog "could not determine location of $appName"
        fi
    else
        printlog "could not find $appName"
    fi
}

checkRunningProcesses() {
    # don't check in DEBUG mode
    if [[ $DEBUG -ne 0 ]]; then
        printlog "DEBUG mode, not checking for blocking processes"
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

    # don't reopen in DEBUG mode
    if [[ $DEBUG -ne 0 ]]; then
        printlog "DEBUG mode, not reopening anything"
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
    if [[ $appversion == $appNewVersion ]]; then
        printlog "Downloaded version of $name is $appNewVersion, same as installed."
        if [[ $INSTALL != "force" ]]; then
            message="$name, version $appNewVersion, is  the latest version."
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

    # skip install for DEBUG
    if [ "$DEBUG" -ne 0 ]; then
        printlog "DEBUG enabled, skipping remove, copy and chown steps"
        return 0
    fi

    # check for root
    if [ "$(whoami)" != "root" ]; then
        # not running as root
        cleanupAndExit 6 "not running as root, exiting"
    fi

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
                message="$name, version $appNewVersion, is  the latest version."
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
    
    # skip install for DEBUG
    if [ "$DEBUG" -ne 0 ]; then
        printlog "DEBUG enabled, skipping installation"
        return 0
    fi

    # check for root
    if [ "$(whoami)" != "root" ]; then
        # not running as root
        cleanupAndExit 6 "not running as root, exiting"
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
    printlog "Finishing…"
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
        displaynotification "$message" "$name update/installation complete!"
    fi
}


# MARK: check minimal macOS requirement
autoload is-at-least

if ! is-at-least 10.14 $(sw_vers -productVersion); then
    printlog "Installomator requires at least macOS 10.14 Mojave."
    exit 98
fi

# MARK: argument parsing
if [[ $# -eq 0 ]]; then
    if [[ -z $label ]]; then # check if label is set inside script
        printlog "no label provided, printing labels"
        grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "$0" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        #grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "${labelFile}" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        exit 0
    fi
elif [[ $1 == "/" ]]; then
    # jamf uses sends '/' as the first argument
    printlog "shifting arguments for Jamf"
    shift 3
fi

while [[ -n $1 ]]; do
    if [[ $1 =~ ".*\=.*" ]]; then
        # if an argument contains an = character, send it to eval
        printlog "setting variable from argument $1"
        eval $1
    else
        # assume it's a label
        label=$1
    fi
    # shift to next argument
    shift 1
done

# lowercase the label
label=${label:l}

printlog "################## Start Installomator v. $VERSION"
printlog "################## $label"

# How we get version number from app
# (alternative is "CFBundleVersion", that can be used in labels)
versionKey="CFBundleShortVersionString"

# get current user
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')


# MARK: labels in case statement
case $label in
version)
    # print the script VERSION
    printlog "$VERSION"
    exit 0
    ;;
longversion)
    # print the script version
    printlog "Installomater: version $VERSION ($VERSIONDATE)"
    exit 0
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
    #Company="Agilebits"
    ;;
8x8)
    # credit: #D-A-James from MacAdmins Slack and Isaac Ordonez, Mann consulting (@mannconsulting)
    name="8x8 Work"
    type="dmg"
    downloadURL=$(curl -fs -L https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}')
    # As for appNewVersion, it needs to be checked for newer version than 7.2.4
    appNewVersion=$(curl -fs -L https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}' | sed -E 's/.*-v([0-9\.]*)[-\.]*.*/\1/' )
    expectedTeamID="FC967L3QRG"
    #Company="8x8"
    ;;
abstract)
    name="Abstract"
    type="zip"
    downloadURL="https://api.goabstract.com/releases/latest/download"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="77MZLZE47D"
    #Company="Elastic Projects, Inc"
    ;;
adobebrackets)
    # credit: Adrian Bühler (@midni9ht)
    name="Brackets"
    type="dmg"
    downloadURL=$(downloadURLFromGit adobe brackets )
    appNewVersion=$(versionFromGit adobe brackets )
    expectedTeamID="JQ525L2MZD"
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
adobereaderdc|\
adobereaderdc-install)
    name="Adobe Acrobat Reader DC"
    type="pkgInDmg"
    packageID="com.adobe.acrobat.DC.reader.app.pkg.MUI"
    downloadURL=$(curl --silent --fail -H "Sec-Fetch-Site: same-origin" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US;q=0.9,en;q=0.8" -H "DNT: 1" -H "Sec-Fetch-Mode: cors" -H "X-Requested-With: XMLHttpRequest" -H "Referer: https://get.adobe.com/reader/enterprise/" -H "Accept: */*" "https://get.adobe.com/reader/webservices/json/standalone/?platform_type=Macintosh&platform_dist=OSX&platform_arch=x86-32&language=English&eventname=readerotherversions" | grep -Eo '"download_url":.*?[^\\]",' | head -n 1 | cut -d \" -f 4)
    appNewVersion=$(curl -s https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt)
    #appNewVersion=$(curl -s -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15)" https://get.adobe.com/reader/ | grep ">Version" | sed -E 's/.*Version 20([0-9.]*)<.*/\1/g') # credit: Søren Theilgaard (@theilgaard)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "AdobeReader" )
    #Company="Adobe"
    #PatchName="AcrobatReader"
    #PatchSkip="YES"
    ;;
adobereaderdc-update)
    name="Adobe Acrobat Reader DC"
    type="pkgInDmg"
    downloadURL=$(adobecurrent=`curl --fail --silent https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt | tr -d '.'` && echo http://ardownload.adobe.com/pub/adobe/reader/mac/AcrobatDC/"$adobecurrent"/AcroRdrDCUpd"$adobecurrent"_MUI.dmg)
    appNewVersion=$(curl -s https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt)
    #appNewVersion=$(curl -s -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15)" https://get.adobe.com/reader/ | grep ">Version" | sed -E 's/.*Version 20([0-9.]*)<.*/\1/g') # credit: Søren Theilgaard (@theilgaard)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "AdobeReader" )
    ;;
aircall)
    # credit: @kris-anderson
    name="Aircall"
    type="dmg"
    downloadURL="https://electron.aircall.io/download/osx"
    expectedTeamID="3ML357Q795"
    ;;
airserver)
    # credit: AP Orlebeke (@apizz)
    name="AirServer"
    type="dmg"
    downloadURL="https://www.airserver.com/download/mac/latest"
    #appNewVersion=$() # Cannot find version history or release notes on home page
    expectedTeamID="6C755KS5W3"
    #Company="App Dynamic ehf"
    ;;
alfred)
    # credit: AP Orlebeke (@apizz)
    name="Alfred"
    type="dmg"
    downloadURL=$(curl -fs https://www.alfredapp.com | awk -F '"' "/dmg/ {print \$2}" | head -1)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*Alfred_([0-9.]*)_.*/\1/')
    appName="Alfred 4.app"
    expectedTeamID="XZZXE9SED4"
    #Company="Running with Crayons Ltd"
    ;;
amazonchime)
    # credit: @dvsjr macadmins slack
    name="Amazon Chime"
    type="dmg"
    downloadURL="https://clients.chime.aws/mac/latest"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z.\-]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="94KV3E626L"
    #Company="Amazon"
    ;;
amazonworkspaces)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Workspaces"
    type="pkg"
    downloadURL="https://d2td7dqidlhjx7.cloudfront.net/prod/global/osx/WorkSpaces.pkg"
    appNewVersion=$(curl -fs https://d2td7dqidlhjx7.cloudfront.net/prod/iad/osx/WorkSpacesAppCast_macOS_20171023.xml | grep -o "Version*.*<" | head -1 | cut -d " " -f2 | cut -d "<" -f1)
    expectedTeamID="94KV3E626L"
    ;;
androidfiletransfer)
    #credit: Sam Ess (saess-sep)
    name="Android File Transfer"
    type="dmg"
    downloadURL="https://dl.google.com/dl/androidjumper/mtp/current/AndroidFileTransfer.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
apparency)
    name="Apparency"
    type="dmg"
    downloadURL="https://www.mothersruin.com/software/downloads/Apparency.dmg"
    expectedTeamID="936EB786NH"
    #Company="Mother's Ruin Graphics"
    ;;
appcleaner)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="AppCleaner"
    type="zip"
    downloadURL=$(curl -fs https://freemacsoft.net/appcleaner/Updates.xml | xpath '//rss/channel/*/enclosure/@url' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    expectedTeamID="X85ZX835W9"
    #Company=FreeMacSoft
    ;;
applenyfonts)
    name="Apple New York Font Collection"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/NY-Font.dmg"
    packageID="com.apple.pkg.NYFonts"
    expectedTeamID="Development Update"
    ;;
applesfpro)
    name="San Francisco Pro"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Font-Pro.dmg"
    packageID="com.apple.pkg.SanFranciscoPro"
    expectedTeamID="Development Update"
    ;;
applesfmono)
    name="San Francisco Mono"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"
    packageID="com.apple.pkg.SFMonoFonts"
    expectedTeamID="Software Update"
    ;;
applesfcompact)
    name="San Francisco Compact"
    type="pkgInDmg"
    downloadURL="https://devimages-cdn.apple.com/design/resources/download/SF-Font-Compact.dmg"
    packageID="com.apple.pkg.SanFranciscoCompact"
    expectedTeamID="Development Update"
    ;;
aquaskk)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="aquaskk"
    type="pkg"
    downloadURL=$(downloadURLFromGit codefirst aquaskk)
    appNewVersion=$(versionFromGit codefirst aquaskk)
    expectedTeamID="FPZK4WRGW7"
    #Company="Code First"
    #PatchSkip="YES"
    ;;
arq7)
    name="Arq7"
    type="pkg"
    packageID="com.haystacksoftware.Arq"
    downloadURL="https://arqbackup.com/download/arqbackup/Arq7.pkg"
    appNewVersion="$(curl -fs "https://arqbackup.com" | grep -io "version .*[0-9.]*.* for macOS" | cut -d ">" -f2 | cut -d "<" -f1)"
    expectedTeamID="48ZCSDVL96"
    ;;
atom)
    name="Atom"
    type="zip"
    archiveName="atom-mac.zip"
    downloadURL=$(downloadURLFromGit atom atom )
    appNewVersion=$(versionFromGit atom atom)
    expectedTeamID="VEKTX9H2N7"
    #Company=GitHub
    ;;
autodmg)
    # credit: Mischa van der Bent (@mischavdbent)
    name="AutoDMG"
    type="dmg"
    downloadURL=$(downloadURLFromGit MagerValp AutoDMG)
    appNewVersion=$(versionFromGit MagerValp AutoDMG)
    expectedTeamID="5KQ3D3FG5H"
    #Company=MagerValp
    ;;
autopkgr)
    # credit: Søren Theilgaard (@theilgaard)
    name="AutoPkgr"
    type="dmg"
    #downloadURL=$(curl -fs "https://api.github.com/repos/lindegroup/autopkgr/releases/latest" | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
    downloadURL=$(downloadURLFromGit lindegroup autopkgr)
    appNewVersion=$(versionFromGit lindegroup autopkgr)
    expectedTeamID="JVY2ZR6SEF"
    #Company="Linde Group"
    ;;
aviatrix)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Aviatrix VPN Client"
    type="pkg"
    downloadURL="https://s3-us-west-2.amazonaws.com/aviatrix-download/AviatrixVPNClient/AVPNC_mac.pkg"
    expectedTeamID="32953Z7NBN"
    #Company=Aviatrix
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
    downloadURL="https://d20adtppz83p9s.cloudfront.net/OSX/latest/AWS_VPN_Client.pkg"
    expectedTeamID="94KV3E626L"
    appNewVersion=$(curl -is "https://beta2.communitypatch.com/jamf/v1/ba1efae22ae74a9eb4e915c31fef5dd2/patch/AWSVPNClient" | grep currentVersion | tr ',' '\n' | grep currentVersion | cut -d '"' -f 4)
    #Company=Amazon
    ;;
balenaetcher)
    # credit: Adrian Bühler (@midni9ht)
    name="balenaEtcher"
    type="dmg"
    downloadURL=$(downloadURLFromGit balena-io etcher )
    appNewVersion=$(versionFromGit balena-io etcher )
    expectedTeamID="66H43P8FRG"
    #Company="Balena"
    ;;
basecamp3)
    #credit: @matins
    name="Basecamp 3"
    type="dmg"
    downloadURL="https://bc3-desktop.s3.amazonaws.com/mac/basecamp3.dmg"
    expectedTeamID="2WNYUYRS7G"
    appName="Basecamp 3.app"
    ;;
bbedit)
    name="BBEdit"
    type="dmg"
    downloadURL=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort | tail -n1 | cut -d">" -f2 | cut -d"<" -f1)
    appNewVersion=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort  | tail -n1 | sed -E 's/.*BBEdit_([0-9 .]*)\.dmg.*/\1/')
    expectedTeamID="W52GZAXT98"
    #Company="Bare Bones Software"
    ;;
bettertouchtool)
    # credit: Søren Theilgaard (@theilgaard)
    name="BetterTouchTool"
    type="zip"
    downloadURL="https://folivora.ai/releases/BetterTouchTool.zip"
    appNewVersion=$(curl -fs https://updates.folivora.ai/bettertouchtool_release_notes.html | grep BetterTouchTool | head -n 2 | tail -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g')
    expectedTeamID="DAFVSXZ82P"
    ;;
bitwarden)
    name="Bitwarden"
    type="dmg"
    downloadURL=$(downloadURLFromGit bitwarden desktop )
    appNewVersion=$(versionFromGit bitwarden desktop )
    expectedTeamID="LTZ2PFU5D6"
    ;;
blender)
    name="blender"
    type="dmg"
    downloadURL=$(redirect=$(curl -sfL https://www.blender.org/download/ | sed 's/.*href="//' | sed 's/".*//' | grep .dmg) && curl -sfL "$redirect" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="68UA947AUU"
    ;;
bluejeans)
    name="BlueJeans"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeansInstaller.*arm.*.pkg" )
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeansInstaller.*x86.*.dmg" | sed 's/dmg/pkg/g')
    fi
    appNewVersion=$(echo $downloadURL | cut -d '/' -f6)
    expectedTeamID="HE4P42JBGN"
    #Company="Verizon"
    ;;
boxdrive)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Box"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        #Note: https://support.box.com/hc/en-us/articles/1500004479962-Box-Drive-support-on-devices-with-M1-chips
        downloadURL="https://e3.boxcdn.net/desktop/pre-releases/mac/BoxDrive.2.20.140-M1-beta.pkg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://e3.boxcdn.net/box-installers/desktop/releases/mac/Box.pkg"
    fi
    expectedTeamID="M683GB7CPW"
    ;;
brave)
    # credit: @securitygeneration
    name="Brave Browser"
    type="dmg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL=$(curl -fsIL https://laptop-updates.brave.com/latest/osxarm64/release | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')
    else
        printlog "Architecture: i386"
        downloadURL=$(curl -fsIL https://laptop-updates.brave.com/latest/osx/release | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')
    fi
#    downloadURL=$(curl --location --fail --silent "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$(curl --location --fail --silent "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="KL8N8XSYF4"
    ;;
cakebrew)
    # credit: Adrian Bühler (@midni9ht)
    name="Cakebrew"
    type="zip"
    downloadURL=$(curl -fsL "https://www.cakebrew.com/appcast/profileInfo.php" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$( curl -fsL "https://www.cakebrew.com/appcast/profileInfo.php" | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="R85D3K8ATT"
    ;;
calibre)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="calibre"
    type="dmg"
    downloadURL="https://calibre-ebook.com/dist/osx"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="NTY7FVCEKP"
    ;;
camostudio)
    # credit: Søren Theilgaard (@theilgaard)
    name="Camo Studio"
    type="zip"
    downloadURL="https://reincubate.com/res/labs/camo/camo-macos-latest.zip"
    appNewVersion=$(curl -s -L  https://reincubate.com/support/camo/release-notes/ | grep -m2 "has-m-t-0" | head -1 | cut -d ">" -f2 | cut -d " " -f1)
    expectedTeamID="Q248YREB53"
    ;;
camtasia)
    name="Camtasia 2020"
    type="dmg"
    downloadURL=https://download.techsmith.com/camtasiamac/releases/Camtasia.dmg
    expectedTeamID="7TQL462TU8"
    ;;
citrixworkspace)
    #credit: Erik Stam (@erikstam) and #Philipp on MacAdmins Slack
    name="Citrix Workspace"
    type="pkgInDmg"
    downloadURL="https:"$(curl -s -L "https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html#ctx-dl-eula-external" | grep "dmg?" | sed "s/.*rel=.\(.*\)..id=.*/\1/") # http://downloads.citrix.com/18823/CitrixWorkspaceApp.dmg?__gda__=1605791892_edc6786a90eb5197fb226861a8e27aa8
    appNewVersion=$(curl -fs https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html | grep "<p>Version" | head -1 | cut -d " " -f1 | cut -d ";" -f2 | cut -d "." -f 1-3)
    expectedTeamID="S272Y5R93J"
    ;;
clevershare2)
    # credit: Søren Theilgaard (@theilgaard)
    name="Clevershare"
    type="dmg"
    downloadURL=$(curl -fs https://archive.clevertouch.com/clevershare2g | grep -i "_Mac" | tr '"' "\n" | grep "^http.*dmg")
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z-]*_Mac\.([0-9.]*)\.[0-9]*\.dmg$/\1/g' )
    expectedTeamID="P76M9BE8DQ"
    ;;
clickshare)
    # credit: Søren Theilgaard (@theilgaard)
    name="ClickShare"
    type="appInDmgInZip"
    downloadURL=https://www.barco.com$(curl -fs "https://www.barco.com/en/clickshare/app" | grep -E -o '(\/\S*Download\?FileNumber=R3306192\S*ShowDownloadPage=False)' | tail -1)
    expectedTeamID="P6CDJZR997"
    ;;
code42)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Code42"
    type="pkgInDmg"
    downloadURL=https://download.code42.com/installs/agent/latest-mac.dmg
    expectedTeamID="9YV9435DHD"
    blockingProcesses=( NONE )
    ;;
coderunner)
    # credit: Erik Stam (@erikstam)
    name="CodeRunner"
    type="zip"
    downloadURL="https://coderunnerapp.com/download"
    expectedTeamID="R4GD98AJF9"
    ;;
cormorant)
    # credit: Søren Theilgaard (@theilgaard)
    name="Cormorant"
    type="zip"
    downloadURL=$(curl -fs https://eclecticlight.co/downloads/ | grep -i $name | grep zip | sed -E 's/.*href=\"(https.*)\">.*/\1/g')
    appNewVersion=$(curl -fs https://eclecticlight.co/downloads/ | grep zip | grep -o -E "$name [0-9.]*" | awk '{print $2}')
    expectedTeamID="QWY4LRW926"
    ;;
cryptomator)
    name="Cryptomator"
    type="dmg"
    downloadURL=$(downloadURLFromGit cryptomator cryptomator)
    appNewVersion=$(versionFromGit cryptomator cryptomator)
    expectedTeamID="YZQJQUHA3L"
    ;;
cyberduck)
    name="Cyberduck"
    type="zip"
    downloadURL=$(curl -fs https://version.cyberduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
    appNewVersion=$(curl -fs https://version.cyberduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="G69SCX94XU"
    ;;
dangerzone)
    # credit: Micah Lee (@micahflee)
    name="Dangerzone"
    type="dmg"
    downloadURL=$(curl -s https://dangerzone.rocks/ | grep https://github.com/firstlookmedia/dangerzone/releases/download | grep \.dmg | cut -d'"' -f2)
    expectedTeamID="P24U45L8P5"
    ;;
darktable)
    # credit: Søren Theilgaard (@theilgaard)
    name="darktable"
    type="dmg"
    downloadURL=$(downloadURLFromGit darktable-org darktable)
    appNewVersion=$(versionFromGit darktable-org darktable)
    expectedTeamID="85Q3K4KQRY"
    ;;
dbeaverce)
    # credit: Adrian Bühler (@midni9ht)
    name="DBeaver"
    type="dmg"
    downloadURL="https://dbeaver.io/files/dbeaver-ce-latest-macos.dmg"
    expectedTeamID="42B6MDKMW8"
    blockingProcesses=( dbeaver )
    ;;
debookee)
    # credit: Adrian Bühler (@midni9ht)
    name="Debookee"
    type="zip"
    downloadURL=$(curl --location --fail --silent "https://www.iwaxx.com/debookee/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="AATLWWB4MZ"
    ;;
depnotify)
    name="DEPNotify"
    type="zip"
    downloadURL="https://files.nomad.menu/DEPNotify.zip"
    expectedTeamID="VRPY9KHGX6"
    targetDir="/Applications/Utilities"
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
dialpad)
    # credit: @ehosaka
    name="Dialpad"
    type="dmg"
    downloadURL="https://storage.googleapis.com/dialpad_native/osx/Dialpad.dmg"
    expectedTeamID="9V29MQSZ9M"
    ;;
discord)
    name="Discord"
    type="dmg"
    downloadURL="https://discordapp.com/api/download?platform=osx"
    expectedTeamID="53Q6R32WPB"
    ;;
docker)
    # credit: @securitygeneration
    name="Docker"
    type="dmg"
    #downloadURL="https://download.docker.com/mac/stable/Docker.dmg"
    if [[ $(arch) == arm64 ]]; then
     downloadURL="https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
    elif [[ $(arch) == i386 ]]; then
     downloadURL="https://desktop.docker.com/mac/stable/amd64/Docker.dmg"
    fi
    appNewVersion=$(curl -ifs https://docs.docker.com/docker-for-mac/release-notes/ | grep ">Docker Desktop Community" | head -1 | sed -n -e 's/^.*Community //p' | cut -d '<' -f1)
    expectedTeamID="9BNSXJN65R"
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
    downloadURL="https://www.dropbox.com/download?plat=mac&full=1"
    expectedTeamID="G7HH3F8CAK"
    ;;
easeusdatarecoverywizard)
    # credit: Søren Theilgaard (@theilgaard)
    name="EaseUS Data Recovery Wizard"
    type="dmg"
    downloadURL=$( curl -fsIL https://down.easeus.com/product/mac_drw_free_setup | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' )
    #appNewVersion=""
    expectedTeamID="DLLVW95FSM"
    ;;
egnyte)
    # credit: #MoeMunyoki from MacAdmins Slack
    name="Egnyte Connect"
    type="pkg"
    downloadURL="https://egnyte-cdn.egnyte.com/egnytedrive/mac/en-us/latest/EgnyteConnectMac.pkg"
    expectedTeamID="FELUD555VC"
    blockingProcesses=( NONE )
    ;;
element)
    # credit: Adrian Bühler (@midni9ht)
    name="Element"
    type="dmg"
    downloadURL="https://packages.riot.im/desktop/install/macos/Element.dmg"
    expectedTeamID="7J4U792NQT"
    ;;
eraseinstall)
    name="EraseInstall"
    type="pkg"
    downloadURL=https://bitbucket.org$(curl -fs https://bitbucket.org/prowarehouse-nl/erase-install/downloads/ | grep pkg | cut -d'"' -f2 | head -n 1)
    expectedTeamID="R55HK5K86Y"
    ;;
etrecheck)
    # credit: @dvsjr macadmins slack
    name="EtreCheckPro"
    type="zip"
    downloadURL="https://cdn.etrecheck.com/EtreCheckPro.zip"
    expectedTeamID="U87NE528LC"
    ;;
exelbanstats)
    # credit: Søren Theilgaard (@theilgaard)
    name="Stats"
    type="dmg"
    downloadURL=$(downloadURLFromGit exelban stats)
    appNewVersion=$(versionFromGit exelban stats)
    expectedTeamID="RP2S87B72W"
    ;;
fantastical)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="Fantastical"
    type="zip"
    downloadURL="https://flexibits.com/fantastical/download"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    expectedTeamID="85C27NK92C"
    ;;
ferdi)
    # credit: Adrian Bühler (@midni9ht)
    name="Ferdi"
    type="dmg"
    downloadURL=$(downloadURLFromGit getferdi ferdi )
    appNewVersion=$(versionFromGit getferdi ferdi )
    expectedTeamID="B6J9X9DWFL"
    ;;
figma)
    name="Figma"
    type="zip"
    downloadURL="https://www.figma.com/download/desktop/mac/"
    expectedTeamID="T8RA8NE3B7"
    #Company="Figma"
    ;;
firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    appNewVersion=$(/usr/bin/curl https://www.mozilla.org/en-US/firefox/releases/ --silent | /usr/bin/grep '<html' | /usr/bin/awk -F\" '{ print $8 }') # Credit: William Smith (@meck)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefox_da)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=da"
    appNewVersion=$(/usr/bin/curl https://www.mozilla.org/en-US/firefox/releases/ --silent | /usr/bin/grep '<html' | /usr/bin/awk -F\" '{ print $8 }') # Credit: William Smith (@meck)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefox_intl)
    # This label will try to figure out the selected language of the user, 
    # and install corrosponding version of Firefox
    name="Firefox"
    type="dmg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale)
    printlog "Found language $userLanguage to be used for Firefox."
    if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt" | grep -o "=$userLanguage"; then
        userLanguage=$(echo $userLanguage | cut -c 1-2)
        if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt" | grep "=$userLanguage"; then
            userLanguage="en_US"
        fi
    fi
    printlog "Using language $userLanguage for download."
    downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 "$downloadURL" ; then
        printlog "Download not found for that language. Using en-US"
        downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    fi
    appNewVersion=$(/usr/bin/curl -sl https://www.mozilla.org/en-US/firefox/releases/ | /usr/bin/grep '<html' | /usr/bin/awk -F\" '{ print $8 }') # Credit: William Smith (@meck)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefoxesr|\
firefoxesrpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-esr-pkg-latest-ssl&os=osx"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*releases\/([0-9.]*)esr.*/\1/g')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefoxesr_intl)
    # This label will try to figure out the selected language of the user, 
    # and install corrosponding version of Firefox ESR
    name="Firefox"
    type="dmg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale)
    printlog "Found language $userLanguage to be used for Firefox."
    if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest-esr/README.txt" | grep -o "=$userLanguage"; then
        userLanguage=$(echo $userLanguage | cut -c 1-2)
        if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest-esr/README.txt" | grep "=$userLanguage"; then
            userLanguage="en_US"
        fi
    fi
    printlog "Using language $userLanguage for download."
    downloadURL="https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=osx&lang=$userLanguage"
    # https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=osx&lang=en-US
    if ! curl -sfL --output /dev/null -r 0-0 "$downloadURL" ; then
        printlog "Download not found for that language. Using en-US"
        downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*releases\/([0-9.]*)esr.*/\1/g')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
firefoxpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
front)
    name="Front"
    type="dmg"
    downloadURL="https://dl.frontapp.com/macos/Front.dmg"
    expectedTeamID="X549L7572J"
    Company="FrontApp. Inc."
    ;;
fsmonitor)
    # credit: Adrian Bühler (@midni9ht)
    name="FSMonitor"
    type="zip"
    downloadURL=$(curl --location --fail --silent "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="V85GBYB7B9"
    ;;
gimp)
    name="GIMP-2.10"
    type="dmg"
    downloadURL=https://$(curl -fs https://www.gimp.org/downloads/ | grep -m 1 -o "download.*gimp-.*.dmg")
    appNewVersion=$(echo $downloadURL | cut -d "-" -f 2)
    expectedTeamID="T25BQ8HSJF"
    #Company="GIMP"
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
golang)
    # credit: Søren Theilgaard (@theilgaard)
    name="GoLang"
    type="pkg"
    packageID="org.golang.go"
    downloadURL="$(curl -fsIL "https://golang.org$(curl -fs "https://golang.org/dl/" | grep -i "downloadBox" | grep "pkg" | tr '"' '\n' | grep "pkg")" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')"
    appNewVersion="$( echo "${downloadURL}" | sed -E 's/.*\/(go[0-9.]*)\..*/\1/g' )" # Version includes letters "go"
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( NONE )
    ;;
googlechrome)
    name="Google Chrome"
    type="dmg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
        appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac_arm64,stable/{print $3; exit}') # Credit: William Smith (@meck)
    else
        printlog "Architecture: i386"
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac,stable/{print $3; exit}') # Credit: William Smith (@meck)
    fi
    expectedTeamID="EQHXZ8M8AV"
    ;;
googlechromepkg)
    name="Google Chrome"
    type="pkg"
    #
    # Note: this url acknowledges that you accept the terms of service
    # https://support.google.com/chrome/a/answer/9915669
    #
    downloadURL="https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg"
    expectedTeamID="EQHXZ8M8AV"
    updateTool="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent"
    updateToolArguments=( -runMode oneshot -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;
googleearth)
    name="Google Earth Pro"
    type="pkgInDmg"
    downloadURL="https://dl.google.com/earth/client/advanced/current/GoogleEarthProMac-Intel.dmg"
    expectedTeamID="EQHXZ8M8AV"
    #Company="Google"
    ;;
googledrive|\
googledrivefilestream)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Google Drive File Stream"
    type="pkgInDmg"
    packageID="com.google.drivefs"
    downloadURL="https://dl.google.com/drive-file-stream/GoogleDriveFileStream.dmg" # downloadURL="https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
    blockingProcesses=( "Google Docs" "Google Drive" "Google Sheets" "Google Slides" )
    expectedTeamID="EQHXZ8M8AV"
    ;;
googledrivebackupandsync)
    name="Backup and Sync"
    type="dmg"
    downloadURL="https://dl.google.com/drive/InstallBackupAndSync.dmg"
    expectedTeamID="EQHXZ8M8AV"
    #Company="Google"
    #PatchSkip="YES"
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
gotomeeting)
    # credit: @matins
    name="GoToMeeting"
    type="dmg"
    downloadURL="https://link.gotomeeting.com/latest-dmg"
    expectedTeamID="GFNFVT632V"
    ;;
gpgsuite)
    # credit: Micah Lee (@micahflee)
    name="GPG Suite"
    type="pkgInDmg"
    pkgName="Install.pkg"
    downloadURL=$(curl -s https://gpgtools.org/ | grep https://releases.gpgtools.org/GPG_Suite- | grep Download | cut -d'"' -f4)
    expectedTeamID="PKV8ZPD836"
    ;;
gpgsync)
    # credit: Micah Lee (@micahflee)
    name="GPG Sync"
    type="pkg"
    downloadURL="https://github.com$(curl -s -L https://github.com/firstlookmedia/gpgsync/releases/latest | grep /firstlookmedia/gpgsync/releases/download | grep \.pkg | cut -d'"' -f2)"
    expectedTeamID="P24U45L8P5"
    ;;
grandperspective)
    name="GrandPerspective"
    type="dmg"
    downloadURL="https://sourceforge.net/projects/grandperspectiv/files/latest/download"
    expectedTeamID="3Z75QZGN66"
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
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/HandBrake/HandBrake/releases/latest" \
        | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ { print \$4 }")
    appNewVersion=$(curl -sf "https://api.github.com/repos/HandBrake/HandBrake/releases/latest" | awk -F '"' "/tag_name/ { print \$4 }")
    expectedTeamID="5X9DE89KYV"
    ;;
hazel)
    # credit: Søren Theilgaard (@theilgaard)
    name="Hazel"
    type="dmg"
    downloadURL=$(curl -fsI https://www.noodlesoft.com/Products/Hazel/download | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')
    appNewVersion=$(curl -fsI https://www.noodlesoft.com/Products/Hazel/download | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="86Z3GCJ4MF"
    ;;
hpeasyadmin)
    # credit: Søren Theilgaard (@theilgaard)
    name="HP Easy Admin"
    type="zip"
    downloadURL="https://ftp.hp.com/pub/softlib/software12/HP_Quick_Start/osx/Applications/HP_Easy_Admin.app.zip"
    expectedTeamID="6HB5Y2QTA3"
    ;;
hpeasystart)
    # credit: Søren Theilgaard (@theilgaard)
    name="HP Easy Start"
    type="zip"
    downloadURL="https://ftp.hp.com/pub/softlib/software12/HP_Quick_Start/osx/Applications/HP_Easy_Start.app.zip"
    expectedTeamID="6HB5Y2QTA3"
    ;;
hyper)
    # credit: Adrian Bühler (@midni9ht)
    name="Hyper"
    type="dmg"
    downloadURL=$(downloadURLFromGit vercel hyper )
    appNewVersion=$(versionFromGit vercel hyper)
    expectedTeamID="JW6Y669B67"
    ;;
icons)
    # credit: Mischa van der Bent (@mischavdbent)
    name="Icons"
    type="zip"
    downloadURL=$(downloadURLFromGit sap macOS-icon-generator )
    appNewVersion=$(versionFromGit sap macOS-icon-generator )
    expectedTeamID="7R5ZEU67FQ"
    ;;
imazingprofileeditor)
    # Credit: Bilal Habib @Pro4TLZZZ
    name="iMazing Profile Editor"
    type="dmg"
    downloadURL="https://downloads.imazing.com/mac/iMazing-Profile-Editor/iMazingProfileEditorMac.dmg"
    expectedTeamID="J5PR93692Y"
    ;;
inkscape)
    # credit: Søren Theilgaard (@theilgaard)
    name="Inkscape"
    type="dmg"
    downloadURL="https://inkscape.org$(curl -fs https://inkscape.org$(curl -fsJL https://inkscape.org/release/  | grep "/release/" | grep en | head -n 1 | cut -d '"' -f 6)mac-os-x/1010-1015/dl/ | grep "click here" | cut -d '"' -f 2)"
    #appNewVersion=$(curl -fsJL https://inkscape.org/release/  | grep "<h2>Inkscape" | cut -d '>' -f 3 | cut -d '<' -f 1 | sed 's/[^0-9.]*//g') # Can't figure out where exact new version is found. Currently returns 1.0, but version is "1.0.0 (4035a4f)"
    expectedTeamID="SW3D6BB6A6"
    ;;
installomator_theile)
    # credit: Søren Theilgaard (@theilgaard)
    name="Installomator"
    type="pkg"
    packageID="dk.theilgaard.pkg.Installomator"
    downloadURL=$(downloadURLFromGit theile Installomator )
    appNewVersion=$(versionFromGit theile Installomator )
    #appCustomVersion(){/usr/local/bin/Installomator.sh version | tail -1 | awk '{print $4}'}
    expectedTeamID="FXW6QXBFW5"
    blockingProcesses=( NONE )
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
    blockingProcesses=( iTerm2 )
    ;;
jabradirect)
    name="Jabra Direct"
    type="dmg"
    downloadURL="https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.dmg"
    expectedTeamID="55LV32M29R"
    appNewVersion=$(curl -fs https://www.jabra.com/Support/release-notes/release-note-jabra-direct | grep -o "Jabra Direct macOS:*.*<" | head -1 | cut -d ":" -f2 | cut -d " " -f2 | cut -d "<" -f1)
    ;;
jamfconnect)
    name="Jamf Connect"
    type="pkgInDmg"
    packageID="com.jamf.connect"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    expectedTeamID="483DWKW443"
    #Company="Jamf"
    #PatchSkip="YES"
    ;;
jamfmigrator)
    # credit: Mischa van der Bent
    name="jamf-migrator"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf JamfMigrator)
    #appNewVersion=$(versionFromGit jamf JamfMigrator)
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
jamfreenroller)
    # credit: Mischa van der Bent
    name="ReEnroller"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf ReEnroller)
    #appNewVersion=$(versionFromGit jamf ReEnroller)
    expectedTeamID="PS2F6S478M"
    ;;
jetbrainsintellijidea)
    # credit: Gabe Marchan (www.gabemarchan.com)
    name="IntelliJ IDEA"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=II&latest&distribution=mac"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=II&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsintellijideace|\
intellijideace)
    name="IntelliJ IDEA CE"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=IIC&latest&distribution=mac"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    expectedTeamID="2ZEFAR8TH3"
    #Company="JetBrains"
    ;;
jetbrainsphpstorm)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)Appended by Skylar Damiano @catdad on MacAdmins Slack
    name="JetBrains PHPStorm"
    type="dmg"
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PS&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PS&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainspycharm)
    # credit: Adrian Bühler (@midni9ht)
    # This is the Pro version of PyCharm.
    # Do not confuse with PyCharm CE.
    name="PyCharm"
    type="dmg"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCP&latest&distribution=mac"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCP&latest&distribution=macM1"
    fi
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainspycharmce|\
pycharmce)
    name="PyCharm CE"
    type="dmg"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCC&latest&distribution=mac"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCC&latest&distribution=macM1"
    fi
    expectedTeamID="2ZEFAR8TH3"
    #Company="JetBrains"
    ;;
karabinerelements)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Karabiner-Elements"
    type="pkgInDmg"
    downloadURL=$(downloadURLFromGit pqrs-org Karabiner-Elements)
    appNewVersion=$(versionFromGit pqrs-org Karabiner-Elements)
    expectedTeamID="G43BCU2T37"
    ;;
keepassxc)
    # credit: Patrick Atoon (@raptor399)
    name="KeePassXC"
    type="dmg"
    downloadURL="$(downloadURLFromGit keepassxreboot keepassxc)"
    appNewVersion=$(versionFromGit keepassxreboot keepassxc)
    expectedTeamID="G2S7P7J672"
    ;;
keka)
    # credit: Adrian Bühler (@midni9ht)
    name="Keka"
    type="dmg"
    downloadURL=$(downloadURLFromGit aonez Keka)
    appNewVersion=$(versionFromGit aonez Keka)
    expectedTeamID="4FG648TM2A"
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
    downloadURL=$( curl -fs "https://objective-see.com/products/knockknock.html" | grep https | grep "$type" | head -1 | tr '"' "\n" | grep "^http" )
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    expectedTeamID="VBG97UB4TA"
    ;;
krisp)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Krisp"
    type="pkg"
    downloadURL="https://download.krisp.ai/mac"
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
    expectedTeamID="N24REP3BMN"
    Company="Marvasol, Inc DBA LastPass"
    ;;
launchbar)
    name="LaunchBar"
    type="dmg"
    downloadURL=$(curl -fs "https://obdev.at/products/launchbar/download.html" | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*.dmg")
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="MLZF7K7B5R"
    ;;
lexarrecoverytool)
    # credit: Søren Theilgaard (@theilgaard)
    name="Lexar Recovery Tool"
    type="appInDmgInZip"
    downloadURL="https://www.lexar.com$( curl -fs "https://www.lexar.com/support/downloads/" | grep -i "mac" | grep -i "recovery" | head -1 | tr '"' '\n' | grep -i ".zip" )"
    #appNewVersion=""
    expectedTeamID="Y8HM6WR2DV"
    ;;
libreoffice)
    # credit: Micah Lee (@micahflee)
    name="LibreOffice"
    type="dmg"
    downloadURL="https://download.documentfoundation.org/libreoffice/stable/$(curl -s https://www.libreoffice.org/download/download/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)/mac/x86_64/LibreOffice_$(curl -s https://www.libreoffice.org/download/download/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)_MacOS_x86-64.dmg"
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)_.*/\1/g' )
    expectedTeamID="7P5S3ZLCN7"
    ;;
loom)
    # credit: Lance Stephens (@pythoninthegrass on MacAdmins Slack)
    name="Loom"
    type="dmg"
    downloadURL=https://cdn.loom.com/desktop-packages/$(curl -fs https://s3-us-west-2.amazonaws.com/loom.desktop.packages/loom-inc-production/desktop-packages/latest-mac.yml | awk '/url/ && /dmg/ {print $3}' | head -1)
    appNewVersion=$(curl -fs https://s3-us-west-2.amazonaws.com/loom.desktop.packages/loom-inc-production/desktop-packages/latest-mac.yml | awk '/version/ {print $2}' )
    expectedTeamID="QGD2ZPXZZG"
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
    downloadURL=$( curl -fs "https://objective-see.com/products/lulu.html" | grep https | grep "$type" | head -1 | tr '"' "\n" | grep "^http" )
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    expectedTeamID="VBG97UB4TA"
    ;;
macfuse)
    name="FUSE for macOS"
    type="pkgInDmg"
    downloadURL=$(downloadURLFromGit osxfuse osxfuse)
    appNewVersion=$(versionFromGit osxfuse osxfuse)
    expectedTeamID="3T5GSNBU6W"
    ;;
malwarebytes)
    name="Malwarebytes"
    type="pkg"
    downloadURL="https://downloads.malwarebytes.com/file/mb3-mac"
    appNewVersion=$(curl -Ifs https://downloads.malwarebytes.com/file/mb3-mac | grep "location" | sed -E 's/.*-Mac-([0-9\.]*)\.pkg/\1/g')
    expectedTeamID="GVZRY6KDKR"
    ;;
mattermost)
    name="Mattermost"
    type="dmg"
    downloadURL=$(downloadURLFromGit mattermost desktop)
    appNewVersion=$(versionFromGit mattermost desktop )
    expectedTeamID="UQ8HT4Q2XM"
    ;;
menumeters)
    # credit: Adrian Bühler (@midni9ht)
    name="MenuMeters"
    type="zip"
    downloadURL=$(downloadURLFromGit yujitach MenuMeters )
    appNewVersion=$(versionFromGit yujitach MenuMeters )
    expectedTeamID="95AQ7YKR5A"
    ;;
miro)
    # credit: @matins
    name="Miro"
    type="dmg"
    downloadURL="https://desktop.miro.com/platforms/darwin/Miro.dmg"
    expectedTeamID="M3GM7MFY7U"
    ;;
musescore)
    name="MuseScore 3"
    type="dmg"
    downloadURL=$(downloadURLFromGit musescore MuseScore)
    appNewVersion=$(versionFromGit musescore MuseScore)
    expectedTeamID="6EPAF2X3PR"
    #Company="Musescore"
    ;;
netnewswire)
    name="NetNewsWire"
    type="zip"
    downloadURL=$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml \
        | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="M8L2WTLA8W"
    ;;
nextcloud)
    name="nextcloud"
    type="pkg"
    #packageID="com.nextcloud.desktopclient"
    downloadURL=$(downloadURLFromGit nextcloud desktop)
    appNewVersion=$(versionFromGit nextcloud desktop)
    # The version of the app is not equal to the version listed on GitHub.
    # App version something like "3.1.3git (build 4850)" but web page lists as "3.1.3"
    # Also it does not math packageID version "3.1.34850"
    appCustomVersion(){defaults read /Applications/nextcloud.app/Contents/Info.plist CFBundleShortVersionString | sed -E 's/^([0-9.]*)git.*/\1/g'}
    expectedTeamID="NKUJUXUJ3B"
    ;;
nomad)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="NoMAD"
    type="pkg"
    downloadURL="https://files.nomad.menu/NoMAD.pkg"
    appNewVersion=$(curl -fs https://nomad.menu/support/ | grep "NoMAD Downloads" | sed -E 's/.*Current Version ([0-9\.]*)<.*/\1/g')
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
notion)
    # credit: Søren Theilgaard (@theilgaard)
    name="Notion"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.notion.so/desktop/apple-silicon/download"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://www.notion.so/desktop/mac/download"
    fi
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="LBQJ96FQ8D"
    ;;
nvivo)
    name="NVivo"
    type="dmg"
    downloadURL="https://download.qsrinternational.com/Software/NVivoforMac/NVivo.dmg"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr '/' '\n' | grep "[0-9]" | cut -d "." -f1-3 )
    expectedTeamID="A66L57342X"
    blockingProcesses=( NVivo NVivoHelper )
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
    # credit: Adrian Bühler (@midni9ht)
    name="ONLYOFFICE"
    type="dmg"
    downloadURL="https://download.onlyoffice.com/install/desktop/editors/mac/distrib/onlyoffice/ONLYOFFICE.dmg"
    expectedTeamID="2WH24U26GJ"
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
    downloadURL="https://openvpn.net/downloads/openvpn-connect-v3-macos.dmg"
    expectedTeamID="ACV7L3WCD8"
    ;;
opera)
    name="Opera"
    type="dmg"
    downloadURL=$(curl -fsIL "$(curl -fs "$(curl -fsIL "https://download.opera.com/download/get/?partner=www&opsys=MacOS" | grep -i "^location" | cut -d " " -f2 | tail -1 | tr -d '\r')" | grep download.opera.com | grep -io "https.*yes" | sed 's/\&amp;/\&/g')" | grep -i "^location" | cut -d " " -f2 | tr -d '\r')
    appNewVersion="$(curl -fs "https://get.geo.opera.com/ftp/pub/opera/desktop/" | grep "href=\"\d" | sort -V | tail -1 | tr '"' '\n' | grep "/" | head -1 | tr -d '/')"
	versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
pacifist)
    name="Pacifist"
    type="dmg"
    downloadURL="https://charlessoft.com/cgi-bin/pacifist_download.cgi?type=dmg"
    expectedTeamID="HRLUCP7QP4"
    ;;
pdfsam)
    name="PDFsam Basic"
    type="dmg"
    downloadURL=$(downloadURLFromGit torakiki pdfsam)
    appNewVersion=$(versionFromGit torakiki pdfsam)
    expectedTeamID="8XM3GHX436"
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
plisteditpro)
    name="PlistEdit Pro"
    type="zip"
    downloadURL="https://www.fatcatsoftware.com/plisteditpro/PlistEditPro.zip"
    expectedTeamID="8NQ43ND65V"
    ;;
postman)
    # credit: Mischa van der Bent
    name="Postman"
    type="zip"
    downloadURL="https://dl.pstmn.io/download/latest/osx"
    appNewVersion=$(curl -Ifs https://dl.pstmn.io/download/latest/osx | grep "content-disposition:" | sed -n -e 's/^.*Postman-osx-//p' | sed 's/\.zip//' | sed $'s/[^[:print:]\t]//g' )
    expectedTeamID="H7H8Q7M5CK"
    ;;
prism9)
    name="Prism 9"
    type="dmg"
    downloadURL="https://cdn.graphpad.com/downloads/prism/9/InstallPrism9.dmg"
    expectedTeamID="YQ2D36NS9M"
    Company="GraphPad Software"
    ;;
privileges)
    # credit: Erik Stam (@erikstam)
    name="Privileges"
    type="zip"
    downloadURL=$(downloadURLFromGit sap macOS-enterprise-privileges )
    appNewVersion=$(versionFromGit sap macOS-enterprise-privileges )
    expectedTeamID="7R5ZEU67FQ"
    ;;
proctortrack)
    #credit: Jeff F. (@jefff on MacAdmins Slack)
    name="Proctortrack"
    type="zip"
    downloadURL="https://storage.googleapis.com/verificientstatic/ProctortrackApp/Production/Proctortrack.zip"
    expectedTeamID="SNHZD6TJE6"
    #Company="Verificient Technologies"
    ;;
promiseutilityr)
    name="Promise Utility"
    type="pkgInDmg"
    packageID="com.promise.utilinstaller"
    downloadURL="https://www.promise.com/DownloadFile.aspx?DownloadFileUID=6533"
    expectedTeamID="268CCUR4WN"
    #Company="Promise"
    ;;
proxyman)
	name="Proxyman"
	type="dmg"
	downloadURL="https://proxyman.io/release/osx/Proxyman_latest.dmg"
	expectedTeamID="3X57WP8E8V"
	appNewVersion=$(curl -s -L https://github.com/ProxymanApp/Proxyman | grep -o 'releases/tag/.*\>' | awk -F '/' '{print $3}')
	;;
pymol)
    name="PyMOL"
    type="dmg"
    downloadURL=$(curl -s -L "https://pymol.org/" | grep -m 1 -Eio 'href="https://pymol.org/installers/PyMOL-(.*)-MacOS(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    expectedTeamID="26SDDJ756N"
    #Company="Schrödinger, Inc."
    ;;
r)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="R"
    type="pkg"
    downloadURL=$( curl -fsL https://formulae.brew.sh/api/cask/r.json | sed -n 's/^.*"url":"\([^"]*\)".*$/\1/p' )
    appNewVersion=$(curl -fsL https://formulae.brew.sh/api/cask/r.json | sed -n 's/^.*"version":"\([^"]*\)".*$/\1/p')
    expectedTeamID="VZLD955F6P"
    ;;
ramboxce)
    # credit: Adrian Bühler (@midni9ht)
    name="Rambox"
    type="dmg"
    downloadURL=$(downloadURLFromGit ramboxapp community-edition )
    appNewVersion=$(versionFromGit ramboxapp community-edition )
    expectedTeamID="7F292FPD69"
    ;;
rectangle)
    name="Rectangle"
    type="dmg"
    downloadURL=$(downloadURLFromGit rxhanson Rectangle)
    appNewVersion=$(versionFromGit rxhanson Rectangle)
    expectedTeamID="XSYZ3E4B7D"
    ;;
redeye)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="Red Eye"
    type="zip"
    downloadURL="https://www.hexedbits.com/downloads/redeye.zip"
    appNewVersion=$( curl -fs "https://www.hexedbits.com/redeye/" | grep "Latest version" | sed -E 's/.*Latest version ([0-9.]*),.*/\1/g' )
    expectedTeamID="5VRJU68BZ5"
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
ricohpsprinters)
    name="Ricoh Printers"
    type="pkgInDmg"
    packageID="com.RICOH.print.PS_Printers_Vol4_EXP.ppds.pkg"
    downloadURL=$(curl -fs https://support.ricoh.com//bb/html/dr_ut_e/rc3/model/mpc3004ex/mpc3004exen.htm | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*.dmg" | cut -d '"' -f 1)
    expectedTeamID="5KACUT3YX8"
    #Company="Ricoh"
    #PatchSkip="YES"
    ;;
ringcentralapp)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Glip"
    type="dmg"
    downloadURL="https://downloads.ringcentral.com/glip/rc/GlipForMac"
    expectedTeamID="M932RC5J66"
    blockingProcesses=( "Glip" )
    ;;
ringcentralclassicapp)
    name="Glip"
    type="dmg"
    downloadURL="https://downloads.ringcentral.com/glip/rc/GlipForMac"
    expectedTeamID="M932RC5J66"
    blockingProcesses=( "Glip" )
    #blockingProcessesMaxCPU="5"
    #Company="RingCentral"
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
    #Company="RingCentral"
    ;;
rocket)
    name="Rocket"
    type="dmg"
    downloadURL="https://macrelease.matthewpalmer.net/Rocket.dmg"
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
royaltsx)
    name="Royal TSX"
    type="dmg"
    downloadURL=$(curl -fs https://royaltsx-v4.royalapps.com/updates_stable | xpath '//rss/channel/item[1]/enclosure/@url'  2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://royaltsx-v4.royalapps.com/updates_stable | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString'  2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="VXP8K9EDP6"
    ;;
rstudio)
    name="RStudio"
    type="dmg"
    downloadURL=$(curl -s -L "https://rstudio.com/products/rstudio/download/" | grep -m 1 -Eio 'href="https://download1.rstudio.org/desktop/macos/RStudio-(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="FYF2F5GFX4"
    #Company="RStudio"
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
screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    downloadURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-14.3.dmg"
    expectedTeamID="CAHEVC3HZC"
    ;;
sfsymbols)
    name="SF Symbols"
    type="pkgInDmg"
    downloadURL="https://developer.apple.com/design/downloads/SF-Symbols.dmg"
    expectedTeamID="Software Update"
    ;;
shield)
    # credit: Søren Theilgaard (@theilgaard)
    name="Shield"
    type="zip"
    downloadURL=$(downloadURLFromGit theevilbit Shield)
    appNewVersion=$(versionFromGit theevilbit Shield)
    expectedTeamID="33YRLYRBYV"
    ;;
sidekick)
    name="Sidekick"
    type="dmg"
    downloadURL="https://api.meetsidekick.com/downloads/df/mac"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/.*-x64-([0-9.]*)-.*/\1/g' )
    expectedTeamID="N975558CUS"
    #Company="PushPlayLabs Inc."
    ;;
signal)
    # credit: Søren Theilgaard (@theilgaard)
    name="Signal"
    type="dmg"
    downloadURL=https://updates.signal.org/desktop/$(curl -fs https://updates.signal.org/desktop/latest-mac.yml | awk '/url/ && /dmg/ {print $3}')
    appNewVersion=$(curl -fs https://updates.signal.org/desktop/latest-mac.yml | grep version | awk '{print $2}')
    expectedTeamID="U68MSDN6DR"
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
     downloadURL=$(curl -sf https://www.sketch.com/downloads/mac/ | grep 'href="https://download.sketch.com' | sed -E 's/.*href=\"(.*)\".?/\1/g')
     appNewVersion=$(curl -fs https://www.sketch.com/updates/ | grep "Sketch Version" | head -1 | sed -E 's/.*Version ([0-9.]*)<.*/\1/g') # version from update page
     expectedTeamID="WUGMZZ5K46"
     ;;
skype)
    name="Skype"
    type="dmg"
    downloadURL="https://get.skype.com/go/getskype-skypeformac"
    appNewVersion=$(curl -is "https://get.skype.com/go/getskype-skypeformac" | grep ocation: | grep -o "Skype-.*dmg" | cut -d "-" -f 2 | cut -d "." -f1-2)
    expectedTeamID="AL798K98FX"
    Company="Microsoft"
    PatchSkip="YES"
    ;;
slack)
    name="Slack"
    type="dmg"
    downloadURL="https://slack.com/ssb/download-osx-universal" # Universal
#    if [[ $(arch) == "arm64" ]]; then
#        downloadURL="https://slack.com/ssb/download-osx-silicon"
#    elif [[ $(arch) == "i386" ]]; then
#        downloadURL="https://slack.com/ssb/download-osx"
#    fi
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' | sed -E 's/.*macos\/([0-9.]*)\/.*/\1/g' )
    expectedTeamID="BQR82RBBHL"
    ;;
snagit|\
snagit2021|\
snagit2020)
    name="Snagit 2021"
    type="dmg"
    downloadURL="https://download.techsmith.com/snagitmac/releases/Snagit.dmg"
    expectedTeamID="7TQL462TU8"
    ;;
snapgeneviewer)
    name="SnapGene Viewer"
    type="dmg"
    downloadURL="https://www.snapgene.com/local/targets/download.php?variant=viewer&os=mac&majorRelease=latest&minorRelease=latest"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr '/' '\n' | grep -i "dmg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_mac\.dmg/\1/g' )
    expectedTeamID="WVCV9Q8Y78"
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
sourcetree)
    name="Sourcetree"
    type="zip"
    downloadURL=$(curl -fs https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcastAlpha.xml \
        | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null \
        | cut -d '"' -f 2 )
    appNewVersion=$(curl -fs https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcastAlpha.xml | xpath '//rss/channel/item[last()]/title' 2>/dev/null | sed -n -e 's/^.*Version //p' | sed 's/\<\/title\>//' | sed $'s/[^[:print:]\t]//g')
    expectedTeamID="UPXU4CQZ5P"
    ;;
spotify)
    name="Spotify"
    type="dmg"
    downloadURL="https://download.scdn.co/Spotify.dmg"
    # appNewVersion=$(curl -fs https://www.spotify.com/us/opensource/ | cat | grep -o "<td>.*.</td>" | head -1 | cut -d ">" -f2 | cut -d "<" -f1) # does not result in the same version as downloaded
    expectedTeamID="2FNC3A47ZF"
    ;;
sublimetext)
    # credit: Søren Theilgaard (@theilgaard)
    name="Sublime Text"
    type="zip"
    downloadURL="$(curl -fs https://www.sublimetext.com/download | grep -io "https://download.*_mac.zip")"
    appNewVersion=$(curl -fs https://www.sublimetext.com/download | grep -i -A 4 "id.*changelog" | grep -io "Build [0-9]*")
    expectedTeamID="Z6D26JE4Y4"
    ;;
supportapp)
    # credit: Søren Theilgaard (@theilgaard)
    name="Support"
    type="pkg"
    packageID="nl.root3.support"
    downloadURL=$(downloadURLFromGit root3nl SupportApp)
    appNewVersion=$(versionFromGit root3nl SupportApp)
    expectedTeamID="98LJ4XBGYK"
    ;;
suspiciouspackage)
    # credit: Mischa van der Bent (@mischavdbent)
    name="Suspicious Package"
    type="dmg"
    downloadURL="https://mothersruin.com/software/downloads/SuspiciousPackage.dmg"
    addNewVersion=$(curl -fs https://mothersruin.com/software/SuspiciousPackage/get.html | grep 'class="version"' | sed -E 's/.*>([0-9\.]*) \(.*/\1/g')
    expectedTeamID="936EB786NH"
    ;;
swiftruntimeforcommandlinetools)
    # Note: this installer will error on macOS versions later than 10.14.3
    name="SwiftRuntimeForCommandLineTools"
    type="pkgInDmg"
    downloadURL="https://updates.cdn-apple.com/2019/cert/061-41823-20191025-5efc5a59-d7dc-46d3-9096-396bb8cb4a73/SwiftRuntimeForCommandLineTools.dmg"
    expectedTeamID="Software Update"
    ;;
tableaureader)
    name="Tableau Reader"
    type="pkgInDmg"
    packageID="com.tableausoftware.reader.app"
    downloadURL="https://www.tableau.com/downloads/reader/mac"
    expectedTeamID="QJ4XPRK37C"
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
    packageID="com.teamviewer.teamviewer"
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/mac-os/" | grep "Current version" | cut -d " " -f3 | cut -d "<" -f1)
    expectedTeamID="H7UGFBUGV6"
    ;;
teamviewerhost)
    name="TeamViewerHost"
    type="pkgInDmg"
    packageID="com.teamviewer.teamviewerhost"
    pkgName="Install TeamViewerHost.app/Contents/Resources/Install TeamViewerHost.pkg"    downloadURL="https://download.teamviewer.com/download/TeamViewerHost.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/mac-os/" | grep "Current version" | cut -d " " -f3 | cut -d "<" -f1)
    expectedTeamID="H7UGFBUGV6"
    #blockingProcessesMaxCPU="5" # Future feature
    #Company="TeamViewer GmbH"
    ;;
teamviewerqs)
    # credit: Søren Theilgaard (@theilgaard)
    name="TeamViewerQS"
    type="dmg"
    downloadURL="https://download.teamviewer.com/download/TeamViewerQS.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/mac-os/" | grep "Current version" | cut -d " " -f3 | cut -d "<" -f1)
    appName="TeamViewerQS.app"
    expectedTeamID="H7UGFBUGV6"
    ;;
telegram)
    name="Telegram"
    type="dmg"
    downloadURL="https://telegram.org/dl/macos"
    appNewVersion=$( curl -fs https://macos.telegram.org | grep anchor | head -1 | sed -E 's/.*a>([0-9.]*) .*/\1/g' )
    expectedTeamID="6N38VWS5BX"
    ;;
textexpander)
    name="TextExpander"
    type="zip"
    downloadURL="https://textexpander.com/cgi-bin/redirect.pl?cmd=download&platform=osx"
    appNewVersion=$( curl -fsIL "https://textexpander.com/cgi-bin/redirect.pl?cmd=download&platform=osx" | grep -i "^location" | awk '{print $2}' | tail -1 | cut -d "_" -f2 | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p' )
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
    #appNewVersion=""
    expectedTeamID="S8EX82NJP6"
    appName="The Unarchiver.app"
    ;;
things)
    name="Things"
    type="zip"
    downloadURL="https://culturedcode.com/things/download/"
    expectedTeamID="JLMPQHK86H"
    ;;
thunderbird)
    name="Thunderbird"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    blockingProcesses=( thunderbird )
    ;;
tigervnc)
    name="TigerVNC Viewer"
    type="dmg"
    downloadURL=https://dl.bintray.com/tigervnc/stable/$(curl -s -l https://dl.bintray.com/tigervnc/stable/ | grep .dmg | sed 's/<pre><a onclick="navi(event)" href="://' | sed 's/".*//' | sort -V | tail -1)
    expectedTeamID="S5LX88A9BW"
    ;;
toggltrack)
    # credit: Adrian Bühler (@midni9ht)
    name="Toggl Track"
    type="dmg"
    downloadURL=$(downloadURLFromGit toggl-open-source toggldesktop )
    appNewVersion=$(versionFromGit toggl-open-source toggldesktop )
    expectedTeamID="B227VTMZ94"
    ;;
torbrowser)
    # credit: Søren Theilgaard (@theilgaard)
    name="Tor Browser"
    type="dmg"
    downloadURL=https://www.torproject.org$(curl -fs https://www.torproject.org/download/ | grep "downloadLink" | grep dmg | head -1 | cut -d '"' -f 4)
    appNewVersion=$(curl -fs https://www.torproject.org/download/ | grep "downloadLink" | grep dmg | head -1 | cut -d '"' -f 4 | cut -d / -f 4)
    expectedTeamID="MADPSAYN6T"
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
    downloadURL=$(downloadURLFromGit TunnelBlick Tunnelblick )
    expectedTeamID="Z2SG5H3HC8"
    ;;
umbrellaroamingclient)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Umbrella Roaming Client"
    type="pkgInZip"
    downloadURL=https://disthost.umbrella.com/roaming/upgrade/mac/production/$( curl -fsL https://disthost.umbrella.com/roaming/upgrade/mac/production/manifest.json | awk -F '"' '/"downloadFilename"/ { print $4 }' )
    expectedTeamID="7P7HQ8H646"
    ;;
universaltypeclient)
    name="Universal Type Client"
    type="pkgInZip"
    #packageID="com.extensis.UniversalTypeClient.universalTypeClient70.Info.pkg" # Does not contain the real version of the download
    downloadURL=https://bin.extensis.com/$( curl -fs https://www.extensis.com/support/universal-type-server-7/ | grep -o "UTC-[0-9].*M.zip" )
    expectedTeamID="J6MMHGD9D6"
    #Company="Extensis"
    ;;
vagrant)
    # credit: AP Orlebeke (@apizz)
    name="Vagrant"
    type="pkgInDmg"
    pkgName="vagrant.pkg"
    downloadURL=$(curl -fs https://www.vagrantup.com/downloads | tr '><' '\n' | awk -F'"' '/x86_64.dmg/ {print $6}' | head -1)
    #appNewVersion=$( curl -fs https://www.vagrantup.com/downloads.html | grep -i "Current Version" )
    appNewVersion=$(versionFromGit hashicorp vagrant)
    expectedTeamID="D38WU7D763"
    ;;
vanilla)
    # credit: Adrian Bühler (@midni9ht)
    name="Vanilla"
    type="dmg"
    downloadURL="https://macrelease.matthewpalmer.net/Vanilla.dmg"
    expectedTeamID="Z4JV2M65MH"
    ;;
veracrypt)
    name="VeraCrypt"
    type="pkgInDmg"
    #downloadURL=$(curl -s -L "https://www.veracrypt.fr/en/Downloads.html" | grep -Eio 'href="https://launchpad.net/veracrypt/trunk/(.*)/&#43;download/VeraCrypt_([0-9].*).dmg"' | cut -c7- | sed -e 's/"$//' | sed "s/&#43;/+/g")
    downloadURL=$(curl -fs "https://www.veracrypt.fr/en/Downloads.html" | grep "https.*\.dmg" | grep -vi "legacy" | tr '"' '\n' | grep "^https.*" | grep -vi ".sig" | sed "s/&#43;/+/g")
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*.*)\.dmg/\1/g' )
    expectedTeamID="Z933746L2S"
    ;;
virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    downloadURL=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" \
        | awk -F '"' "/OSX.dmg/ { print \$4 }")
    appNewVersion=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" | awk -F '"' "/OSX.dmg/ { print \$4 }" | sed -E 's/.*virtualbox\/([0-9.]*)\/.*/\1/')
    expectedTeamID="VB5E2TV963"
    ;;
viscosity)
    #credit: @matins
    name="Viscosity"
    type="dmg"
    downloadURL="https://www.sparklabs.com/downloads/Viscosity.dmg"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z.\-]*%20([0-9.]*)\..*/\1/g' )
    expectedTeamID="34XR7GXFPX"
    ;;
vivaldi)
    # credit: Adrian Bühler (@midni9ht)
    name="Vivaldi"
    type="tbz"
    downloadURL=$(curl -fsL "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$(curl -is "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml" | grep sparkle:version | tr ',' '\n' | grep sparkle:version | cut -d '"' -f 4)
    expectedTeamID="4XF3XNRN6Y"
    ;;
vlc)
    name="VLC"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-arm64.xml | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
        appNewVersion=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-arm64.xml | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2 )
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-intel64.xml | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
        appNewVersion=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-intel64.xml | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2 )
    fi
    expectedTeamID="75GAHG3SZQ"
    ;;
vmwarehorizonclient)
    # credit: Oh4sh0 https://github.com/Oh4sh0
    name="VMware Horizon Client"
    type="dmg"
    downloadURL=$(curl -fs "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=CART21FQ2_MAC_800&productId=1027&rPId=48989" | grep -o 'Url.*..dmg"' | cut -d '"' -f3)
    appNewVersion=$(curl -fs "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=CART21FQ2_MAC_800&productId=1027&rPId=48989" | sed 's/.*-\(.*\)-.*/\1/')
    expectedTeamID="EG7KH642X6"
    ;;
vscodium)
    # credit: AP Orlebeke (@apizz)
    name="VSCodium"
    type="dmg"
    downloadURL=$(curl -fs "https://api.github.com/repos/VSCodium/vscodium/releases/latest" | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
    #downloadURL=$(downloadURLFromGit VSCodium vscodium) # Too many versions
    appNewVersion=$(versionFromGit VSCodium vscodium)
    expectedTeamID="C7S3ZQ2B8V"
    appName="VSCodium.app"
    blockingProcesses=( Electron )
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
webexteams)
    # credit: Erik Stam (@erikstam)
    name="Webex"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://binaries.webex.com/WebexDesktop-MACOS-Apple-Silicon-Gold/Webex.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/Webex.dmg"
    fi
    expectedTeamID="DE8Y96K9QP"
    ;;
whatsapp)
    name="WhatsApp"
    type="dmg"
    downloadURL="https://web.whatsapp.com/desktop/mac/files/WhatsApp.dmg"
    expectedTeamID="57T9237FN3"
    ;;
wickrme)
    # credit: Søren Theilgaard (@theilgaard)
    name="WickrMe"
    type="dmg"
    downloadURL=$( curl -fs https://me-download.wickr.com/api/download/me/download/mac | tr '"' '\n' | grep -e '^https://' )
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="W8RC3R952A"
    ;;
wickrpro)
    # credit: Søren Theilgaard (@theilgaard)
    name="WickrPro"
    type="dmg"
    downloadURL=$( curl -fs https://me-download.wickr.com/api/download/pro/download/mac | tr '"' '\n' | grep -e '^https://' )
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="W8RC3R952A"
    ;;
wireshark)
    # credit: Oh4sh0 https://github.com/Oh4sh0
    name="Wireshark"
    type="dmg"
    downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20Latest%20Intel%2064.dmg"
    appNewVersion=$(curl -fs https://www.wireshark.org/download.html | grep "Stable Release" | grep -o "(.*.)" | cut -f2 | head -1 | awk -F '[()]' '{print $2}')
    expectedTeamID="7Z6EMTD2C6"
    ;;
wwdc)
    # credit: Søren Theilgaard (@theilgaard)
    name="WWDC"
    type="dmg"
    downloadURL=$(downloadURLFromGit insidegui WWDC)
    appNewVersion=$(versionFromGit insidegui WWDC)
    expectedTeamID="8C7439RJLG"
    ;;
xink)
    name="Xink"
    type="zip"
    downloadURL="https://downloads.xink.io/macos/client"
    #appNewVersion=$() # Cannot find version history or release notes on home page
    expectedTeamID="F287823HVS"
    ;;
yubikeymanagerqt)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="YubiKey Manager GUI"
    type="pkg"
    downloadURL="https://developers.yubico.com/yubikey-manager-qt/Releases/$(curl -sfL https://api.github.com/repos/Yubico/yubikey-manager-qt/releases/latest | awk -F '"' '/"tag_name"/ { print $4 }')-mac.pkg"
    #appNewVersion=$(curl -fs https://developers.yubico.com/yubikey-manager-qt/Releases/ | grep mac.pkg | head -1 | sed -E "s/.*-([0-9.]*)-mac.*/\1/") # does not work
    appNewVersion=$(versionFromGit Yubico yubikey-manager-qt)
    expectedTeamID="LQA3CS5MM7"
    ;;
xeroxphaser7800)
    name="XeroxPhaser"
    type="pkgInDmg"
    downloadURL=$(curl -fs "https://www.support.xerox.com/en-us/product/phaser-7800/downloads?platform=macOSx11" | xmllint --html --format - 2>/dev/null | grep -o "https://.*XeroxDrivers.*.dmg")
    expectedTeamID="G59Y3XFNFR"
    #Company=Xerox
    #PatchSkip=YES
    ;;
zappy)
    name="Zappy"
    type="appInDmgInZip"
    downloadURL="https://zappy.zapier.com/releases/zappy-latest.zip"
    expectedTeamID="6LS97Q5E79"
    #Company="Zapier"
    ;;
zoom)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Zoom.us"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomInstallerIT.pkg"
    appNewVersion=$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15)" "https://zoom.us/download" | grep Version | head -n 1 | sed -E 's/.* ([0-9.]* \(.*\)).*/\1/') # credit: Søren Theilgaard (@theilgaard)
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( zoom.us )
    ;;
zoomclient)
    name="zoom.us"
    type="pkg"
    packageID="us.zoom.pkg.videmeeting"
    downloadURL="https://zoom.us/client/latest/Zoom.pkg"
    expectedTeamID="BJ4HAAB9B3"
    #appNewVersion=$(curl -is "https://beta2.communitypatch.com/jamf/v1/ba1efae22ae74a9eb4e915c31fef5dd2/patch/zoom.us" | grep currentVersion | tr ',' '\n' | grep currentVersion | cut -d '"' -f 4) # Does not match packageID
    blockingProcesses=( zoom.us )
    #blockingProcessesMaxCPU="5"
    #Company="Zoom Inc."
    #PatchSkip="YES"
    ;;
zulujdk11)
    name="Zulu JDK 11"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.11"
    if [[ $(arch) == i386 ]]; then
      downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu11.*ca-jdk11.*x64.dmg" | sed 's/\\//g')
    elif [[ $(arch) == arm64 ]]; then
      downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu11.*ca-jdk11.*aarch64.dmg" | sed 's/\\//g')
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    #Company="Azul"
    #PatchSkip="YES"
    ;;
zulujdk13)
    name="Zulu JDK 13"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.13"
    if [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu13.*ca-jdk13.*x64.dmg" | sed 's/\\//g')
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu13.*ca-jdk13.*aarch64.dmg" | sed 's/\\//g')
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    #Company="Azul"
    #PatchSkip="YES"
    ;;
zulujdk15)
    name="Zulu JDK 15"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.15"
    if [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu15.*ca-jdk15.*x64.dmg" | sed 's/\\//g')
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu15.*ca-jdk15.*aarch64.dmg" | sed 's/\\//g')
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    #Company="Azul"
    #PatchSkip="YES"
    ;;

# MARK: Add new labels after this line (let us sort them in the list)


# MARK: Add new labels above here

#cdef)
#    # cdef currently not signed
#    # credit: Søren Theilgaard (@theilgaard)
#    name="cdef"
#    type="pkg"
#    downloadURL=$(downloadURLFromGit Shufflepuck cdef)
#    appNewVersion=$(versionFromGit Shufflepuck cdef)
#    #expectedTeamID="EM3ER8T33A"
#    ;;
#fontforge)
#    # FontForge Not signed
#    # credit: Søren Theilgaard (@theilgaard)
#    name="FontForge"
#    type="dmg"
#    downloadURL=$(downloadURLFromGit fontforge fontforge)
#    appNewVersion=$(versionFromGit fontforge fontforge)
#    expectedTeamID=""
#    ;;
#notifier)
#    # not signed
#    # credit: Søren Theilgaard (@theilgaard)
#    name="dataJAR Notifier"
#    type="pkg"
#    #packageID="uk.co.dataJAR.Notifier" # Version 2.2.3 was actually "uk.co.dataJAR.Notifier-2.2.3" so unusable
#    downloadURL=$(downloadURLFromGit dataJAR Notifier)
#    appNewVersion=$(versionFromGit dataJAR Notifier)
#    expectedTeamID=""
#    blockingProcesses=( "Notifier" )
#    ;;
# packages)
# NOTE: Packages is signed but _not_ notarized, so spctl will reject it
#    name="Packages"
#    type="pkgInDmg"
#    pkgName="Install Packages.pkg"
#    downloadURL="http://s.sudre.free.fr/Software/files/Packages.dmg"
#    expectedTeamID="NL5M9E394P"
#    ;;
# powershell)
# NOTE: powershell installers are not notarized
#     # credit: Tadayuki Onishi (@kenchan0130)
#     name="PowerShell"
#     type="pkg"
#     downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
#     | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep -v lts )
#     expectedTeamID="UBF8T346G9"
#     ;;
# powershell-lts)
# NOTE: powershell installers are not notarized
#     # credit: Tadayuki Onishi (@kenchan0130)
#     name="PowerShell"
#     type="pkg"
#     downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
#     | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep lts)
#     expectedTeamID="UBF8T346G9"
#     ;;
# vmwarefusion)
# TODO: vmwarefusion installation process needs testing
#     # credit: Erik Stam (@erikstam)
#     name="VMware Fusion"
#     type="dmg"
#     downloadURL="https://www.vmware.com/go/getfusion"
#     appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*Fusion-([0-9.]*)-.*/\1/g' )
#     expectedTeamID="EG7KH642X6"
#     ;;
#wordmat)
#    # WordMat currently not signed
#    # credit: Søren Theilgaard (@theilgaard)
#    name="WordMat"
#    type="pkg"
#    packageID="com.eduap.pkg.WordMat"
#    downloadURL=$(downloadURLFromGit Eduap-com WordMat)
#    #downloadURL=$(curl -fs "https://api.github.com/repos/Eduap-com/WordMat/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
#    appNewVersion=$(versionFromGit Eduap-com WordMat)
#    #curl -fs "https://api.github.com/repos/Eduap-com/WordMat/releases/latest" | grep tag_name | cut -d '"' -f 4 | sed 's/[^0-9\.]//g'
#    expectedTeamID=""
#    ;;


# MARK: Microsoft

# msupdate codes from:
# https://docs.microsoft.com/en-us/deployoffice/mac/update-office-for-mac-using-msupdate

# download link IDs from: https://macadmin.software

microsoftautoupdate)
    name="Microsoft AutoUpdate"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=830196"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.autoupdate.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "Microsoft_AutoUpdate.*pkg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_.*/\1/g' | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    # commented the updatetool for MSAutoupdate, because when Autoupdate is really
    # old or broken, you want to force a new install
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps MSau04 )
    ;;
microsoftcompanyportal)
    name="Company Portal"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869655"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.intunecompanyportal.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/CompanyPortal_.*pkg" | cut -d "_" -f 2 | cut -d "-" -f 1)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps IMCP01 )
    ;;
microsoftdefenderatp)
    name="Microsoft Defender ATP"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2097502"
    appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.defender.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    # No version number in download url
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps WDAV00 )
    ;;
microsoftedge|\
microsoftedgeconsumerstable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2069148"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.edge"]/cfbundleversion' 2>/dev/null | sed -E 's/<cfbundleversion>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdge.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps EDGE01 )
    ;;
microsoftedgeenterprisestable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2093438"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.edge"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdge.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps EDGE01 )
    ;;
microsoftexcel)
    name="Microsoft Excel"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525135"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.excel.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps XCEL2019 )
    ;;
microsoftlicenseremovaltool)
    # credit: Isaac Ordonez (@isaac) macadmins slack
    name="Microsoft License Removal Tool"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=849815"
    expectedTeamID="QGS93ZLCU7"
    appNewVersion=$(curl -is "$downloadURL" | grep ocation: | grep -o "Microsoft_.*pkg" | cut -d "_" -f 5 | cut -d "." -f1-2)
    Company="Microsoft"
    PatchSkip="YES"
    ;;
microsoftoffice365)
    name="MicrosoftOffice365"
    type="pkg"
    packageID="com.microsoft.pkg.licensing"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525133"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3)
    expectedTeamID="UBF8T346G9"
    # using MS PowerPoint as the 'stand-in' for the entire suite
    #appName="Microsoft PowerPoint.app"
    blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "OneDrive" )
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install )
    ;;
microsoftofficebusinesspro)
    name="MicrosoftOfficeBusinessPro"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2009112"
    expectedTeamID="UBF8T346G9"
    # using MS PowerPoint as the 'stand-in' for the entire suite
    appName="Microsoft PowerPoint.app"
    blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "OneDrive" "Teams")
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install )
    ;;
microsoftonedrive)
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=823060"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onedrive.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONDR18 )
    ;;
microsoftonenote)
    name="Microsoft OneNote"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=820886"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onenote.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONMC2019 )
    ;;
microsoftoutlook)
    name="Microsoft Outlook"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525137"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.outlook.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps OPIM2019 )
    ;;
microsoftpowerpoint)
    name="Microsoft PowerPoint"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525136"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.powerpoint.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps PPT32019 )
    ;;
microsoftremotedesktop)
    name="Microsoft Remote Desktop"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=868963"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.remotedesktop.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_Remote_Desktop.*pkg" | cut -d "_" -f 4)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSRD10 )
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
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSFB16 )
    ;;
microsoftteams)
    name="Microsoft Teams"
    type="pkg"
    #packageID="com.microsoft.teams"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869428"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.teams.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    # Still using macadmin.software for version, as the path does not contain the version in a matching format. packageID can be used, but version is the same.
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams "Microsoft Teams Helper" )
    # Commenting out msupdate as it is not really supported *yet* for teams
    # updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    # updateToolArguments=( --install --apps TEAM01 )
    ;;
microsoftvisualstudiocode|\
visualstudiocode)
    name="Visual Studio Code"
    type="zip"
    #downloadURL="https://go.microsoft.com/fwlink/?LinkID=620882" # Intel only
    downloadURL="https://go.microsoft.com/fwlink/?LinkID=2156837" # Universal
    appNewVersion=$(curl -fsL "https://code.visualstudio.com/Updates" | grep "/darwin" | grep -oiE ".com/([^>]+)([^<]+)/darwin" | cut -d "/" -f 2 | sed $'s/[^[:print:]\t]//g' | head -1 )
    expectedTeamID="UBF8T346G9"
    appName="Visual Studio Code.app"
    blockingProcesses=( Electron )
    ;;
microsoftword)
    name="Microsoft Word"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525134"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.word.standalone.365"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSWD2019 )
    ;;
microsoftyammer)
    name="Yammer"
    type="dmg"
    downloadURL="https://aka.ms/yammer_desktop_mac"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/oldpackage[id="com.microsoft.yammer.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps ?????? )
    ;;

# this description is so you can provide all variables as arguments
# it will only check if the required variables are setting
valuesfromarguments)
    if [[ -z $name ]]; then
        printlog "need to provide 'name'"
        exit 1
    fi
    if [[ -z $type ]]; then
        printlog "need to provide 'type'"
        exit 1
    fi
    if [[ -z $downloadURL ]]; then
        printlog "need to provide 'downloadURL'"
        exit 1
    fi
    if [[ -z $expectedTeamID ]]; then
        printlog "need to provide 'expectedTeamID'"
        exit 1
    fi
    ;;

# these descriptions exist for testing and are intentionally broken
brokendownloadurl)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://broken.com/broken.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
brokenappname)
    name="brokenapp"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
brokenteamid)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
    expectedTeamID="broken"
    ;;
*)
    # unknown label
    #printlog "unknown label $label"
    cleanupAndExit 1 "unknown label $label"
    ;;
esac


# MARK: application download and installation starts here

printlog "BLOCKING_PROCESS_ACTION=${BLOCKING_PROCESS_ACTION}"
printlog "NOTIFY=${NOTIFY}"

# Finding LOGO to use in dialogs
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
        LOGO="/Applications/Business.app/Contents/Resources/AppIcon.icns"
        ;;
    mosylem)
        # Mosyle Manager (education)
        LOGO="/Applications/Manager.app/Contents/Resources/AppIcon.icns"
        ;;
    addigy)
        # Addigy
        LOGO="/Library/Addigy/macmanage/MacManage.app/Contents/Resources/atom.icns"
        ;;
esac
if [[ ! -a "${LOGO}" ]]; then
    if [[ $(sw_vers -buildVersion) > "19" ]]; then
        LOGO="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    else
        LOGO="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    fi
fi
printlog "LOGO=${LOGO}"

# MARK: extract info from data
if [ -z "$archiveName" ]; then
    case $type in
        dmg|pkg|zip|tbz)
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

if [ -z "$appName" ]; then
    # when not given derive from name
    appName="$name.app"
fi

if [ -z "$targetDir" ]; then
    case $type in
        dmg|zip|tbz|app*)
            targetDir="/Applications"
            ;;
        pkg*)
            targetDir="/"
            ;;
        updateronly)
            ;;
        *)
            printlog "Cannot handle type $type"
            cleanupAndExit 99
            ;;
    esac
fi

if [[ -z $blockingProcesses ]]; then
    printlog "no blocking processes defined, using $name as default"
    blockingProcesses=( $name )
fi

# MARK: determine tmp dir
if [ "$DEBUG" -ne 0 ]; then
    # for debugging use script dir as working directory
    tmpDir=$(dirname "$0")
else
    # create temporary working directory
    tmpDir=$(mktemp -d )
fi

# MARK: change directory to temporary working directory
printlog "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    printlog "error changing directory $tmpDir"
    cleanupAndExit 1
fi

# MARK: get installed version
getAppVersion
printlog "appversion: $appversion"

# MARK: Exit if new version is the same as installed version (appNewVersion specified)
# credit: Søren Theilgaard (@theilgaard)
if [[ -n $appNewVersion ]]; then
    printlog "Latest version of $name is $appNewVersion"
    if [[ $appversion == $appNewVersion ]]; then
        if [[ $DEBUG -eq 0 ]]; then
            printlog "There is no newer version available."
            if [[ $INSTALL != "force" ]]; then
                message="$name, version $appNewVersion, is  the latest version."
                if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                    printlog "notifying"
                    displaynotification "$message" "No update for $name!"
                fi
                cleanupAndExit 0 "No newer version."
            else
                printlog "Using force to install anyway. Not using updateTool."
                updateTool=""
            fi
        else
            printlog "DEBUG mode enabled, not exiting, but there is no new version of app."
        fi
    fi
else
    printlog "Latest version not specified."
    if [[ $INSTALL == "force" ]]; then
        printlog "Using force to install, so not using updateTool."
        updateTool=""
    fi
fi

# MARK: check if this is an Update and we can use updateTool
if [[ (-n $appversion && -n "$updateTool") || "$type" == "updateronly" ]]; then
    printlog "appversion & updateTool"
    if [[ $DEBUG -eq 0 ]]; then
        if runUpdateTool; then
            finishing
            cleanupAndExit 0
        elif [[ $type == "updateronly" ]];then
            printlog "type is $type so we end here."
            cleanupAndExit 0
        fi # otherwise continue
    else
        printlog "DEBUG mode enabled, not running update tool"
    fi
fi

# MARK: download the archive
if [ -f "$archiveName" ] && [ "$DEBUG" -ne 0 ]; then
    printlog "$archiveName exists and DEBUG enabled, skipping download"
else
    # download the dmg
    printlog "Downloading $downloadURL to $archiveName"
    if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
        printlog "notifying"
        displaynotification "Downloading $name update" "Download in progress …"
    fi
    if ! curl --location --fail --silent "$downloadURL" -o "$archiveName"; then
        printlog "error downloading $downloadURL"
        message="$name update/installation failed. This will be logged, so IT can follow up."
        if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
            printlog "notifying"
            displaynotification "$message" "Error installing/updating $name"
        fi
        cleanupAndExit 2
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
printlog "Installing $name"
if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
    printlog "notifying"
    displaynotification "Installing $name" "Installation in progress …"
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
    tbz)
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
        printlog "Cannot handle type $type"
        cleanupAndExit 99
        ;;
esac

# MARK: Finishing — print installed application location and version
finishing

# all done!
cleanupAndExit 0
