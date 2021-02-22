#!/bin/zsh

# Installomator
#
# Downloads and installs an Applications
# 2020 Armin Briegel - Scripting OS X
#
# inspired by the download scripts from William Smith and Sander Schram
# with additional ideas and contribution from Isaac Ordonez, Mann consulting

VERSION='0.5'
VERSIONDATE='20201019'

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


# behavior when blocking processes are found
BLOCKING_PROCESS_ACTION=prompt_user
# options:
#   - ignore       continue even when blocking processes are found
#   - silent_fail  exit script without prompt or installation
#   - prompt_user  show a user dialog for each blocking process found
#                  abort after three attempts to quit
#   - prompt_user_then_kill
#                  show a user dialog for each blocking process found,
#                  attempt to quit two times, kill the process finally
#   - kill         kill process without prompting or giving the user a chance to save


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
#     - pkgInDmg
#     - pkgInZip (not yet tested)
#
# - downloadURL: (required)
#   URL to download the dmg.
#   Can be generated with a series of commands (see BBEdit for an example).
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
# - pkgName: (optional, only used for dmgInPkg and dmgInZip)
#   File name of the pkg file _inside_ the dmg or zip
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
    printlog "################## End Installomator \n\n"
    exit "$1"
}

runAsUser() {
    if [[ $currentUser != "loginwindow" ]]; then
        uid=$(id -u "$currentUser")
        launchctl asuser $uid sudo -u $currentUser "$@"
    fi
}

displaydialog() { # $1: message $2: title
    message=${1:-"Message"}
    title=${2:-"Installomator"}
    runAsUser osascript -e "button returned of (display dialog \"$message\" with title \"$title\" buttons {\"Not Now\", \"Quit and Update\"} default button \"Quit and Update\")"
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
        echo "$timestamp" "$1" | tee -a $log_location
    else 
        echo "$timestamp" "$1"
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
        printlog "could not retrieve download URL for $gitusername/$gitreponame"
        exit 9
    else
        echo "$downloadURL"
        return 0
    fi
}


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
            appversion=$(mdls -name kMDItemVersion -raw $installedAppPath )
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
    for i in {1..3}; do
        countedProcesses=0
        for x in ${blockingProcesses}; do
            if pgrep -xq "$x"; then
                printlog "found blocking process $x"

                case $BLOCKING_PROCESS_ACTION in
                    kill)
                      printlog "killing process $x"
                      pkill $x
                      ;;
                    prompt_user|prompt_user_then_kill)
                      button=$(displaydialog "Quit “$x” to continue updating? (Leave this dialogue if you want to activate this update later)." "The application “$x” needs to be updated.")
                      if [[ $button = "Not Now" ]]; then
                        cleanupAndExit 10 "user aborted update"
                      else
                        if [[ $i = 3 && $BLOCKING_PROCESS_ACTION = "prompt_user_then_kill" ]]; then
                          printlog "killing process $x"
                          pkill $x
                        else
                          printlog "telling app $x to quit"
                          runAsUser osascript -e "tell app \"$x\" to quit"
                        fi
                      fi
                      ;;
                    silent_fail)
                      cleanupAndExit 12 "blocking process '$x' found, aborting"
                      ;;
                esac

                countedProcesses=$((countedProcesses + 1))
            fi
        done

        if [[ $countedProcesses -eq 0 ]]; then
            # no blocking processes, exit the loop early
            break
        else
            # give the user a bit of time to quit apps
            printlog "waiting 30 seconds for processes to quit"
            sleep 30
        fi
    done

    if [[ $countedProcesses -ne 0 ]]; then
        cleanupAndExit 11 "could not quit all processes, aborting..."
    fi

    printlog "no more blocking processes, continue with update"
}

installAppWithPath() { # $1: path to app to install in $targetDir
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

    printlog "Team ID: $teamID (expected: $expectedTeamID )"

    if [ "$expectedTeamID" != "$teamID" ]; then
        cleanupAndExit 5 "Team IDs do not match"
    fi

    # check for root
    if [ "$(whoami)" != "root" ]; then
        # not running as root
        if [ "$DEBUG" -eq 0 ]; then
            cleanupAndExit 6 "not running as root, exiting"
        fi

        printlog "DEBUG enabled, skipping copy and chown steps"
        return 0
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
    
    applicationPath="$dmgmount/$appName"
    printlog "looking for app: $applicationPath"
    if [[ ! -d $applicationPath ]]; then
        # find first file ending with 'app'
        findfiles=$(find "$dmgmount" -iname "*.app" -maxdepth 1 -mindepth 1 )
        filearray=( ${(f)findfiles} )
        if [[ ${#filearray} -eq 0 ]]; then
            cleanupAndExit 21 "couldn't find app in dmg $archiveName"
        fi
        applicationPath="${filearray[1]}"
        printlog "found app: $applicationPath"
    fi
    
    installAppWithPath "$applicationPath"
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

    # skip install for DEBUG
    if [ "$DEBUG" -ne 0 ]; then
        printlog "DEBUG enabled, skipping installation"
        return 0
    fi

    # check for root
    if [ "$(whoami)" != "root" ]; then
        # not running as root
        printlog "not running as root, exiting"
        cleanupAndExit 6
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
        findfiles=$(find "$dmgmount" -iname "*.pkg" -maxdepth 1 -mindepth 1 )
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
        # find first file starting with $name and ending with 'pkg'
        findfiles=$(find "$tmpDir" -iname "*.pkg" -maxdepth 1  )
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

runUpdateTool() {
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


# MARK: check minimal macOS requirement
autoload is-at-least

if ! is-at-least 10.14 $(sw_vers -productVersion); then
    printlog "Installomator requires at least macOS 10.14 Mojave."
    exit 98
fi

# MARK: argument parsing
if [[ $# -eq 0 ]]; then
    grep -E '^[a-z0-9\-]*(\)|\|\\)$' "$0" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
    exit 0
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

printlog "################## Start Installomator"
printlog "################## $label"

# lowercase the label
label=${label:l}

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
autodmg)
    # credit: Mischa van der Bent (@mischavdbent)
    name="AutoDMG"
    type="dmg"
    downloadURL=$(downloadURLFromGit MagerValp AutoDMG)
    expectedTeamID="5KQ3D3FG5H"
    ;;
googlechrome)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
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
googlejapaneseinput)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="GoogleJapaneseInput"
    type="pkgInDmg"
    pkgName="GoogleJapaneseInput.pkg"
    downloadURL="https://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
santa)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Santa"
    type="pkgInDmg"
    downloadURL=$(downloadURLFromGit google santa)
    expectedTeamID="EQHXZ8M8AV"
    ;;
spotify)
    name="Spotify"
    type="dmg"
    downloadURL="https://download.scdn.co/Spotify.dmg"
    expectedTeamID="2FNC3A47ZF"
    ;;
bbedit)
    name="BBEdit"
    type="dmg"
    downloadURL=$(curl -s https://versioncheck.barebones.com/BBEdit.xml | grep dmg | sort | tail -n1 | cut -d">" -f2 | cut -d"<" -f1)
    expectedTeamID="W52GZAXT98"
    ;;
firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
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
firefoxesrpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-esr-pkg-latest-ssl&os=osx"
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
whatsapp)
    name="WhatsApp"
    type="dmg"
    downloadURL="https://web.whatsapp.com/desktop/mac/files/WhatsApp.dmg"
    expectedTeamID="57T9237FN3"
    ;;
desktoppr)
    name="desktoppr"
    type="pkg"
    downloadURL=$(downloadURLFromGit "scriptingosx" "desktoppr")
    expectedTeamID="JME5BW3F3R"
    blockingProcesses=( NONE )
    ;;
malwarebytes)
    name="Malwarebytes"
    type="pkg"
    downloadURL="https://downloads.malwarebytes.com/file/mb3-mac"
    expectedTeamID="GVZRY6KDKR"
    ;;
suspiciouspackage)
    # credit: Mischa van der Bent (@mischavdbent)
    name="Suspicious Package"
    type="dmg"
    downloadURL="https://mothersruin.com/software/downloads/SuspiciousPackage.dmg"
    expectedTeamID="936EB786NH"
    ;;
atom)
    name="Atom"
    type="zip"
    archiveName="atom-mac.zip"
    downloadURL=$(downloadURLFromGit atom atom )
    expectedTeamID="VEKTX9H2N7"
    ;;
eraseinstall)
    name="EraseInstall"
    type="pkg"
    downloadURL=https://bitbucket.org$(curl -fs https://bitbucket.org/prowarehouse-nl/erase-install/downloads/ | grep pkg | cut -d'"' -f2 | head -n 1)
    expectedTeamID="R55HK5K86Y"
    ;;
omnigraffle7)
    name="OmniGraffle"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniGraffle7" \
        | xpath '//rss/channel/item[1]/enclosure[1]/@url' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="34YW5XSRB7"
    ;;
omnifocus3)
    name="OmniFocus"
    type="dmg"
    downloadURL=$(curl -fs https://update.omnigroup.com/appcast/com.omnigroup.OmniFocus3 \
        | xpath '//rss/channel/item/enclosure[1]/@url' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="34YW5XSRB7"
    ;;
vlc)
    name="VLC"
    type="dmg"
    downloadURL=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-intel64.xml \
        | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="75GAHG3SZQ"
    ;;
textmate)
    name="TextMate"
    type="tbz"
    downloadURL="https://api.textmate.org/downloads/release?os=10.12"
    expectedTeamID="45TL96F76G"
    ;;
depnotify)
    name="DEPNotify"
    type="zip"
    downloadURL="https://files.nomad.menu/DEPNotify.zip"
    expectedTeamID="VRPY9KHGX6"
    targetDir="/Applications/Utilities"
    ;;
tunnelbear)
    name="TunnelBear"
    type="zip"
    downloadURL="https://s3.amazonaws.com/tunnelbear/downloads/mac/TunnelBear.zip"
    expectedTeamID="P2PHZ9K5JJ"
    ;;
sourcetree)
    name="Sourcetree"
    type="zip"
    downloadURL=$(curl -fs https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcastAlpha.xml \
        | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null \
        | cut -d '"' -f 2 )
    expectedTeamID="UPXU4CQZ5P"
    ;;
boxdrive)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Box"
    type="pkg"
    downloadURL="https://e3.boxcdn.net/box-installers/desktop/releases/mac/Box.pkg"
    expectedTeamID="M683GB7CPW"
    ;;
aviatrix)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Aviatrix VPN Client"
    type="pkg"
    downloadURL="https://s3-us-west-2.amazonaws.com/aviatrix-download/AviatrixVPNClient/AVPNC_mac.pkg"
    expectedTeamID="32953Z7NBN"
    ;;
zoom)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Zoom.us"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomInstallerIT.pkg"
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( zoom.us )
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
coderunner)
    # credit: Erik Stam (@erikstam)
    name="CodeRunner"
    type="zip"
    downloadURL="https://coderunnerapp.com/download"
    expectedTeamID="R4GD98AJF9"
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
pacifist)
    name="Pacifist"
    type="dmg"
    downloadURL="https://charlessoft.com/cgi-bin/pacifist_download.cgi?type=dmg"
    expectedTeamID="HRLUCP7QP4"
    ;;
1password7)
    name="1Password 7"
    type="pkg"
    downloadURL="https://app-updates.agilebits.com/download/OPM7"
    expectedTeamID="2BUA8C4S2C"
    ;;
webexmeetings)
    # credit: Erik Stam (@erikstam)
    name="Cisco Webex Meetings"
    type="pkgInDmg"
    downloadURL="https://akamaicdn.webex.com/client/webexapp.dmg"
    expectedTeamID="DE8Y96K9QP"
    ;;
webex|\
webexteams)
    # credit: Erik Stam (@erikstam)
    name="Webex"
    type="dmg"
    downloadURL="https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/WebexTeams.dmg"
    expectedTeamID="DE8Y96K9QP"
    ;;
citrixworkspace)
    #credit: Erik Stam (@erikstam) and #Philipp on MacAdmins Slack
    name="Citrix Workspace"
    type="pkgInDmg"
    downloadURL="https:"$(curl -s -L "https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html#ctx-dl-eula-external" | grep "dmg?" | sed "s/.*rel=.\(.*\)..id=.*/\1/")
    expectedTeamID="S272Y5R93J"
    ;;
privileges)
    # credit: Erik Stam (@erikstam)
    name="Privileges"
    type="zip"
    downloadURL=$(downloadURLFromGit sap macOS-enterprise-privileges )
    expectedTeamID="7R5ZEU67FQ"
    ;;
icons)
    # credit: Mischa van der Bent (@mischavdbent)
    name="Icons"
    type="zip"
    downloadURL=$(downloadURLFromGit sap macOS-icon-generator )
    expectedTeamID="7R5ZEU67FQ"
    ;;
googledrive)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting) & Gabe Marchan (gabemarchan.com)
    name="Google Drive"
    type="pkgInDmg"
    downloadURL="https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
    pkgName="GoogleDriveFileStream.pkg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
plisteditpro)
    name="PlistEdit Pro"
    type="zip"
    downloadURL="https://www.fatcatsoftware.com/plisteditpro/PlistEditPro.zip"
    expectedTeamID="8NQ43ND65V"
    ;;
slack)
    name="Slack"
    type="dmg"
    downloadURL="https://slack.com/ssb/download-osx"
    expectedTeamID="BQR82RBBHL"
    ;;
sublimetext)
    # credit: Mischa van der Bent (@mischavdbent)
    name="Sublime Text"
    type="dmg"
    downloadURL="https://download.sublimetext.com/latest/stable/osx"
    expectedTeamID="Z6D26JE4Y4"
    ;;
githubdesktop)
    name="GitHub Desktop"
    type="zip"
    downloadURL="https://central.github.com/deployments/desktop/desktop/latest/darwin"
    expectedTeamID="VEKTX9H2N7"
    ;;
things)
    name="Things"
    type="zip"
    downloadURL="https://culturedcode.com/things/download/"
    expectedTeamID="JLMPQHK86H"
    ;;
discord)
    name="Discord"
    type="dmg"
    downloadURL="https://discordapp.com/api/download?platform=osx"
    expectedTeamID="53Q6R32WPB"
    ;;
grandperspective)
    name="GrandPerspective"
    type="dmg"
    downloadURL="https://sourceforge.net/projects/grandperspectiv/files/latest/download"
    expectedTeamID="3Z75QZGN66"
    ;;
handbrake)
    name="HandBrake"
    type="dmg"
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/HandBrake/HandBrake/releases/latest" \
        | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ { print \$4 }")
    expectedTeamID="5X9DE89KYV"
    ;;
netnewswire)
    name="NetNewsWire"
    type="zip"
    downloadURL=$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml \
        | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="M8L2WTLA8W"
    ;;
resiliosynchome)
    name="Resilio Sync"
    type="dmg"
    downloadURL="https://download-cdn.resilio.com/stable/osx/Resilio-Sync.dmg"
    expectedTeamID="2953Z5SZSK"
    ;;
cyberduck)
    name="Cyberduck"
    type="zip"
    downloadURL=$(curl -fs https://version.cyberduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="G69SCX94XU"
    ;;
dropbox)
    name="Dropbox"
    type="dmg"
    downloadURL="https://www.dropbox.com/download?plat=mac&full=1"
    expectedTeamID="G7HH3F8CAK"
    ;;
teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    pkgName="Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    expectedTeamID="H7UGFBUGV6"
    ;;
teamviewerqs)
    name="TeamViewerQS"
    type="dmg"
    downloadURL="https://download.teamviewer.com/download/TeamViewerQS.dmg"
    expectedTeamID="H7UGFBUGV6"
    ;;
iterm2)
    name="iTerm"
    type="zip"
    downloadURL="https://iterm2.com/downloads/stable/latest"
    expectedTeamID="H7V7XYVQ7D"
    blockingProcesses=( iTerm2 )
    ;;
royaltsx)
    name="Royal TSX"
    type="dmg"
    downloadURL=$(curl -fs https://royaltsx-v4.royalapps.com/updates_stable | xpath '//rss/channel/item[1]/enclosure/@url'  2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="VXP8K9EDP6"
    ;;
appcleaner)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="AppCleaner"
    type="zip"
    downloadURL=$(curl -fs https://freemacsoft.net/appcleaner/Updates.xml | xpath '//rss/channel/*/enclosure/@url' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    expectedTeamID="X85ZX835W9"
    ;;
karabinerelements)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Karabiner-Elements"
    type="pkgInDmg"
    downloadURL=$(downloadURLFromGit pqrs-org Karabiner-Elements)
    expectedTeamID="G43BCU2T37"
    ;;
postman)
    # credit: Mischa van der Bent
    name="Postman"
    type="zip"
    downloadURL="https://dl.pstmn.io/download/latest/osx"
    expectedTeamID="H7H8Q7M5CK"
    ;;
jamfpppcutility)
    # credit: Mischa van der Bent
    name="PPPC Utility"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf PPPC-Utility)
    expectedTeamID="483DWKW443"
    ;;
jamfmigrator)
    # credit: Mischa van der Bent
    name="jamf-migrator"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf JamfMigrator)
    expectedTeamID="PS2F6S478M"
    ;;
jamfreenroller)
    # credit: Mischa van der Bent
    name="ReEnroller"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf ReEnroller)
    expectedTeamID="PS2F6S478M"
    ;;
adobereaderdc|\
adobereaderdc-install)
    name="Adobe Acrobat Reader DC"
    type="pkgInDmg"
    downloadURL=$(curl --silent --fail -H "Sec-Fetch-Site: same-origin" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US;q=0.9,en;q=0.8" -H "DNT: 1" -H "Sec-Fetch-Mode: cors" -H "X-Requested-With: XMLHttpRequest" -H "Referer: https://get.adobe.com/reader/enterprise/" -H "Accept: */*" "https://get.adobe.com/reader/webservices/json/standalone/?platform_type=Macintosh&platform_dist=OSX&platform_arch=x86-32&language=English&eventname=readerotherversions" | grep -Eo '"download_url":.*?[^\\]",' | head -n 1 | cut -d \" -f 4)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "AdobeReader" )
    ;;
adobereaderdc-update)
    name="Adobe Acrobat Reader DC"
    type="pkgInDmg"
    downloadURL=$(adobecurrent=`curl --fail --silent https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt | tr -d '.'` && echo http://ardownload.adobe.com/pub/adobe/reader/mac/AcrobatDC/"$adobecurrent"/AcroRdrDCUpd"$adobecurrent"_MUI.dmg)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "AdobeReader" )
    ;;
signal)
    # credit: Søren Theilgaard
    name="Signal"
    type="dmg"
    downloadURL=https://updates.signal.org/desktop/$(curl -fs https://updates.signal.org/desktop/latest-mac.yml | awk '/url/ && /dmg/ {print $3}')
    expectedTeamID="U68MSDN6DR"
    ;;
docker)
    # credit: @securitygeneration      
    name="Docker"
    type="dmg"
    downloadURL="https://download.docker.com/mac/stable/Docker.dmg"
    expectedTeamID="9BNSXJN65R"
    ;;
brave)
    # credit: @securitygeneration
    name="Brave Browser"
    type="dmg"
    downloadURL=$(curl --location --fail --silent "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="KL8N8XSYF4"
    ;;
umbrellaroamingclient)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Umbrella Roaming Client"
    type="pkgInZip"
    downloadURL=https://disthost.umbrella.com/roaming/upgrade/mac/production/$( curl -fsL https://disthost.umbrella.com/roaming/upgrade/mac/production/manifest.json | awk -F '"' '/"downloadFilename"/ { print $4 }' )
    expectedTeamID="7P7HQ8H646"
    ;;
# TODO: vmwarefusion installation process needs testing
# vmwarefusion)
#     # credit: Erik Stam (@erikstam)
#     name="VMware Fusion"
#     type="dmg"
#     downloadURL="https://www.vmware.com/go/getfusion"
#     expectedTeamID="EG7KH642X6"
#     ;;

# NOTE: powershell installers are not notarized
# powershell)
#     # credit: Tadayuki Onishi (@kenchan0130)
#     name="PowerShell"
#     type="pkg"
#     downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
#     | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep -v lts )
#     expectedTeamID="UBF8T346G9"
#     ;;
# powershell-lts)
#     # credit: Tadayuki Onishi (@kenchan0130)
#     name="PowerShell"
#     type="pkg"
#     downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
#     | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep lts)
#     expectedTeamID="UBF8T346G9"
#     ;;

wwdcformac)
    name="WWDC"
    type="zip"
    downloadURL="https://cdn.wwdc.io/WWDC_latest.zip"
    expectedTeamID="8C7439RJLG"
    ;;
ringcentralmeetings)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Ring Central Meetings"
    type="pkg"
    downloadURL="http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsClientSetup.pkg"
    expectedTeamID="M932RC5J66"        
    blockingProcesses=( "RingCentral Meetings" )
    ;;
ringcentralapp)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Glip"
    type="dmg"
    downloadURL="https://downloads.ringcentral.com/glip/rc/GlipForMac"
    expectedTeamID="M932RC5J66"        
    blockingProcesses=( "Glip" )
    ;;
sfsymbols)
    name="SF Symbols"
    type="pkgInDmg"
    downloadURL="https://developer.apple.com/design/downloads/SF-Symbols.dmg"
    expectedTeamID="Software Update"
    ;;
swiftruntimeforcommandlinetools)
    # Note: this installer will error on macOS versions later than 10.14.3
    name="SwiftRuntimeForCommandLineTools"
    type="pkgInDmg"
    downloadURL="https://updates.cdn-apple.com/2019/cert/061-41823-20191025-5efc5a59-d7dc-46d3-9096-396bb8cb4a73/SwiftRuntimeForCommandLineTools.dmg"
    expectedTeamID="Software Update"
    ;;
aquaskk)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="aquaskk"
    type="pkg"
    downloadURL="$(downloadURLFromGit codefirst aquaskk)"
    expectedTeamID="FPZK4WRGW7"
    ;;
krisp)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="Krisp"
    type="pkg"
    downloadURL="https://download.krisp.ai/mac"
    expectedTeamID="U5R26XM5Z2"
    ;;
torbrowser)
    # credit: Søren Theilgaard (@theilgaard)
    name="Tor Browser"
    type="dmg"
    downloadURL=https://www.torproject.org$(curl -fs https://www.torproject.org/download/ | grep "downloadLink" | grep -m 1 dmg | cut -d '"' -f 4)
    appNewVersion=$(curl -fs https://www.torproject.org/download/ | grep "downloadLink" | grep dmg | cut -d '"' -f 4 | cut -d / -f 4)
    expectedTeamID="MADPSAYN6T"
    ;;
code42)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Code42"
    type="pkgInDmg"
    downloadURL=https://download.code42.com/installs/agent/latest-mac.dmg
    expectedTeamID="9YV9435DHD"
    blockingProcesses=( NONE )
    ;;
nomad)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="NoMAD"
    type="pkg"
    downloadURL="https://files.nomad.menu/NoMAD.pkg"
    expectedTeamID="VRPY9KHGX6"
    ;;
bettertouchtool)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="BetterTouchTool"
    type="zip"
    downloadURL="https://folivora.ai/releases/BetterTouchTool.zip"
    expectedTeamID="DAFVSXZ82P"
    ;;
r)
    # credit: Tadayuki Onishi (@kenchan0130)        
    name="R"
    type="pkg"
    downloadURL=$( curl -fsL https://formulae.brew.sh/api/cask/r.json | sed -n 's/^.*"url":"\([^"]*\)".*$/\1/p' )
    expectedTeamID="VZLD955F6P"
    ;; 
8x8)
    # credit: #D-A-James from MacAdmins Slack and Isaac Ordonez, Mann consulting (@mannconsulting)
    name="8x8 Work"
    type="dmg"
    downloadURL=$(curl -fs -L https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}')
    expectedTeamID="FC967L3QRG"
    ;;
egnyte)
    # credit: #MoeMunyoki from MacAdmins Slack
    name="Egnyte Connect"
    type="pkg"
    downloadURL="https://egnyte-cdn.egnyte.com/egnytedrive/mac/en-us/latest/EgnyteConnectMac.pkg"
    expectedTeamID="FELUD555VC"
    blockingProcesses=( NONE )
    ;;
camtasia)
    name="Camtasia 2020"
    type="dmg"
    downloadURL=https://download.techsmith.com/camtasiamac/releases/Camtasia.dmg
    expectedTeamID="7TQL462TU8"
    ;;
snagit2020)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Snagit 2020"
    type="dmg"
    downloadURL="https://download.techsmith.com/snagitmac/releases/Snagit.dmg"
    expectedTeamID="7TQL462TU8"
    ;;
virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    downloadURL=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" \
        | awk -F '"' "/OSX.dmg/ { print \$4 }")
    expectedTeamID="VB5E2TV963"
    ;;
detectxswift)
    # credit: AP Orlebeke (@apizz)
    name="DetectX Swift"
    type="zip"
    downloadURL="https://s3.amazonaws.com/sqwarq.com/PublicZips/DetectX_Swift.app.zip"
    expectedTeamID="MAJ5XBJSG3"
    ;;
autopkgr)
    # credit: AP Orlebeke (@apizz)
    name="AutoPkgr"
    type="dmg"
    downloadURL=$(curl -fs "https://api.github.com/repos/lindegroup/autopkgr/releases/latest" \
        | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
    expectedTeamID="JVY2ZR6SEF"
    ;;
airserver)
    # credit: AP Orlebeke (@apizz)
    name="AirServer"
    type="dmg"
    downloadURL="https://www.airserver.com/download/mac/latest"
    expectedTeamID="6C755KS5W3"
    ;;
vscodium)
    # credit: AP Orlebeke (@apizz)
    name="VSCodium"
    type="dmg"
    downloadURL=$(curl -fs "https://api.github.com/repos/VSCodium/vscodium/releases/latest" \
        | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
    expectedTeamID="C7S3ZQ2B8V"
    appName="VSCodium.app"
    blockingProcesses=( Electron )
    ;;
keepassxc)
    # credit: Patrick Atoon (@raptor399)
    name="KeePassXC"
    type="dmg"
    downloadURL="$(downloadURLFromGit keepassxreboot keepassxc)"
    expectedTeamID="G2S7P7J672"
    ;;
alfred)
    # credit: AP Orlebeke (@apizz)
    name="Alfred"
    type="dmg"
    downloadURL=$(curl -fs https://www.alfredapp.com | awk -F '"' "/dmg/ {print \$2}" | head -1)
    appName="Alfred 4.app"
    expectedTeamID="XZZXE9SED4"
    ;;
istatmenus)
    # credit: AP Orlebeke (@apizz)
    name="iStat Menus"
    type="zip"
    downloadURL="https://download.bjango.com/istatmenus/"
    expectedTeamID="Y93TK974AT"
    blockingProcesses=( "iStat Menus" "iStatMenusAgent" "iStat Menus Status" )
    ;;
sizeup)
    # credit: AP Orlebeke (@apizz)
    name="SizeUp"
    type="zip"
    downloadURL="https://www.irradiatedsoftware.com/download/SizeUp.zip"
    expectedTeamID="GVZ7RF955D"
    ;;
tunnelblick)
    name="Tunnelblick"
    type="dmg"
    downloadURL=$(downloadURLFromGit TunnelBlick Tunnelblick )
    expectedTeamID="Z2SG5H3HC8"
    ;;
yubikeymanagerqt)
    # credit: Tadayuki Onishi (@kenchan0130)        
    name="YubiKey Manager GUI"
    type="pkg"
    downloadURL="https://developers.yubico.com/yubikey-manager-qt/Releases/$(curl -sfL https://api.github.com/repos/Yubico/yubikey-manager-qt/releases/latest | awk -F '"' '/"tag_name"/ { print $4 }')-mac.pkg"
    expectedTeamID="LQA3CS5MM7"
    ;;
skitch)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Skitch"
    type="zip"
    downloadURL=$(curl -fs -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15" https://evernote.com/products/skitch | grep -o "https://.*zip")
    expectedTeamID="J8RPQ294UB"
    Company="Evernote"
    ;;
dialpad)
    # credit: @ehosaka
    name="Dialpad"
    type="dmg"
    downloadURL="https://storage.googleapis.com/dialpad_native/osx/Dialpad.dmg"
    expectedTeamID="9V29MQSZ9M"
    ;;
amazonworkspaces)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Workspaces"
    type="pkg"
    downloadURL="https://d2td7dqidlhjx7.cloudfront.net/prod/global/osx/WorkSpaces.pkg"
    # appNewVersion=$(curl -fs https://d2td7dqidlhjx7.cloudfront.net/prod/iad/osx/WorkSpacesAppCast_macOS_20171023.xml | grep -o "Version*.*<" | head -1 | cut -d " " -f2 | cut -d "<" -f1)
    expectedTeamID="94KV3E626L"
    ;;
apparency)
    name="Apparency"
    type="dmg"
    downloadURL="https://www.mothersruin.com/software/downloads/Apparency.dmg"
    expectedTeamID="936EB786NH"
    ;;
skype)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    # CONSUMER version of skype, business version is `microsoftskypeforbusiness`
    name="Skype"
    type="dmg"
    downloadURL="https://get.skype.com/go/getskype-skypeformac"
    expectedTeamID="AL798K98FX"
    ;;
bluejeans)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="BlueJeans"
    type="pkg"
    downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeansInstaller.dmg" | sed 's/dmg/pkg/g')
    expectedTeamID="HE4P42JBGN"
    ;;
ricohpsprinters)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Ricoh PS Printers"
    type="pkgInDmg"
    downloadURL=$(curl -fs https://support.ricoh.com//bb/html/dr_ut_e/rc3/model/mpc3004ex/mpc3004exen.htm | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*.dmg" | cut -d '"' -f 1)
    expectedTeamID="5KACUT3YX8"
    ;;
ringcentralphone)
    # credit: Eric Gjerde, When I Work (@ericgjerde on MacAdmins Slack)
    # note: the DMG says RingCentral Phone, the installed app says RingCentral Phone, but the app in the DMG is 'RingCentral for Mac.app'
    name="RingCentral for Mac"
    type="dmg"
    downloadURL="https://downloads.ringcentral.com/sp/RingCentralForMac"
    expectedTeamID="M932RC5J66"
    blockingProcesses=( "RingCentral Phone" )
    ;;
inkscape)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="Inkscape"
    type="dmg"
    downloadURL=https://inkscape.org$(inkscapemacurl=$(curl -s -L "https://inkscape.org/release/" | grep -Eio '/release/inkscape-(.*)/mac-os-x/([0-9]*)-([0-9]*)/dl/') && curl -s -L "https://inkscape.org$inkscapemacurl" | grep -Eio 'href="/gallery/item/([0-9]*)/(.*).dmg' | cut -c7-)
    expectedTeamID="SW3D6BB6A6"
    ;;    
gimp)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="GIMP"
    type="dmg"
    downloadURL=https://$(curl -s -L "https://www.gimp.org/downloads/" | grep -Eio 'download.gimp.org/mirror/pub/gimp/v.*/osx/(.*).dmg')
    expectedTeamID="T25BQ8HSJF"
    ;;
qgis-macos-pr)
    # credit: Rob Smithers (@SmithersJr on MacAdmins Slack)
    name="QGIS"
    type="dmg"
    downloadURL="https://qgis.org/downloads/macos/qgis-macos-pr.dmg"
    expectedTeamID="4F7N4UDA22"
    ;;
osxfuse)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="FUSE for macOS"
    type="pkgInDmg"
    downloadURL=$(downloadURLFromGit osxfuse osxfuse)
    expectedTeamID="3T5GSNBU6W"
    ;;
veracrypt)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="VeraCrypt"
    type="pkgInDmg"
    downloadURL=$(curl -s -L "https://www.veracrypt.fr/en/Downloads.html" | grep -Eio 'href="https://launchpad.net/veracrypt/trunk/(.*)/&#43;download/VeraCrypt_([0-9].*).dmg"' | cut -c7- | sed -e 's/"$//' | sed "s/&#43;/+/g")
    expectedTeamID="Z933746L2S"
    ;;
cryptomator)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="Cryptomator"
    type="dmg"
    downloadURL=$(downloadURLFromGit cryptomator cryptomator)
    expectedTeamID="YZQJQUHA3L"
    ;;
prism7)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="Prism 7"
    type="dmg"
    downloadURL="http://cdn.graphpad.com/downloads/prism/7/InstallPrism7.dmg"
    expectedTeamID="YQ2D36NS9M"
    ;;
prism8)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="Prism 8"
    type="dmg"
    downloadURL="http://cdn.graphpad.com/downloads/prism/8/InstallPrism8.dmg"
    expectedTeamID="YQ2D36NS9M"
    ;;
snapgeneviewer)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="SnapGene Viewer"
    type="dmg"
    downloadURL="https://www.snapgene.com/local/targets/download.php?variant=viewer&os=mac&majorRelease=latest&minorRelease=latest"
    expectedTeamID="WVCV9Q8Y78"
    ;;
mattermost)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="Mattermost"
    type="dmg"
    downloadURL=$(downloadURLFromGit mattermost desktop)
    expectedTeamID="UQ8HT4Q2XM"
    ;;    
thunderbird)
    # credit: @N on MacAdmins Slack
    name="Thunderbird"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    blockingProcesses=( thunderbird )
    ;;
tigervnc)
    # credit: @N on MacAdmins Slack
    name="TigerVNC Viewer"
    type="dmg"
    downloadURL=https://dl.bintray.com/tigervnc/stable/$(curl -s -l https://dl.bintray.com/tigervnc/stable/ | grep .dmg | sed 's/<pre><a onclick="navi(event)" href="://' | sed 's/".*//' | sort -V | tail -1)
    expectedTeamID="S5LX88A9BW"
    ;;
bitwarden)
    # credit: @N on MacAdmins Slack
    name="Bitwarden"
    type="dmg"
    downloadURL=$(downloadURLFromGit bitwarden desktop )
    expectedTeamID="LTZ2PFU5D6"
    ;;
rstudio)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="RStudio"
    type="dmg"
    downloadURL=$(curl -s -L "https://rstudio.com/products/rstudio/download/" | grep -m 1 -Eio 'href="https://download1.rstudio.org/desktop/macos/RStudio-(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    expectedTeamID="FYF2F5GFX4"
    ;;
keka)
    # credit: Adrian Bühler (@midni9ht)
    name="Keka"
    type="dmg"
    downloadURL="https://d.keka.io"
    expectedTeamID="4FG648TM2A"
    ;;
androidfiletransfer)
    #credit: Sam Ess (saess-sep)
    name="Android File Transfer"
    type="dmg"
    downloadURL="https://dl.google.com/dl/androidjumper/mtp/current/AndroidFileTransfer.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
dbeaverce)
    # credit: Adrian Bühler (@midni9ht) @ Gabe Marchan (darklink87)
    name="DBeaver"
    type="dmg"
    downloadURL="https://dbeaver.io/files/dbeaver-ce-latest-macos.dmg"
    expectedTeamID="42B6MDKMW8"
    blockingProcesses=( dbeaver )
    ;;
onlyofficedesktop)
    # credit: Adrian Bühler (@midni9ht)
    name="ONLYOFFICE"
    type="dmg"
    downloadURL="https://download.onlyoffice.com/install/desktop/editors/mac/distrib/onlyoffice/ONLYOFFICE.dmg"
    expectedTeamID="2WH24U26GJ"
    ;;
googleearth)
    # credit: David Chatton (@mdmmac on MacAdmins Slack)
    name="Google Earth Pro"
    type="pkgInDmg"
    downloadURL="https://dl.google.com/earth/client/advanced/current/GoogleEarthProMac-Intel.dmg"
      expectedTeamID="EQHXZ8M8AV"
    ;;
pymol)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="PyMOL"
    type="dmg"
    downloadURL=$(curl -s -L "https://pymol.org/" | grep -m 1 -Eio 'href="https://pymol.org/installers/PyMOL-(.*)-MacOS(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    expectedTeamID="26SDDJ756N"
    ;;
prism9)
    # credit: Fredrik Larsson (@fredrik_l on MacAdmins Slack)
    name="Prism 9"
    type="dmg"
    downloadURL="http://cdn.graphpad.com/downloads/prism/9/InstallPrism9.dmg"
    expectedTeamID="YQ2D36NS9M"
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
dangerzone)
    # credit: Micah Lee (@micahflee)
    name="Dangerzone"
    type="dmg"
    downloadURL=$(curl -s https://dangerzone.rocks/ | grep https://github.com/firstlookmedia/dangerzone/releases/download | grep \.dmg | cut -d'"' -f2)
    expectedTeamID="P24U45L8P5"
    ;;
libreoffice)
    # credit: Micah Lee (@micahflee)
    name="LibreOffice"
    type="dmg"
    downloadURL="https://download.documentfoundation.org/libreoffice/stable/$(curl -s https://www.libreoffice.org/download/download/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)/mac/x86_64/LibreOffice_$(curl -s https://www.libreoffice.org/download/download/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)_MacOS_x86-64.dmg"
    expectedTeamID="7P5S3ZLCN7"
    ;;
sketch)
    # credit: Alex L. (@aloew on MacAdmins Slack)
    name="Sketch"
    type="zip"
    downloadURL="http://download.sketchapp.com/sketch.zip"
    expectedTeamID="WUGMZZ5K46"
    ;;
abstract)
    # credit: Alex L. (@aloew on MacAdmins Slack)
    name="Abstract"
    type="zip"
    downloadURL="https://api.goabstract.com/releases/latest/download"
    expectedTeamID="77MZLZE47D"
    ;;  
musescore)
    # credit: @marcelclaus on MacAdmins Slack
    name="MuseScore 3"
    type="dmg"
    downloadURL=$(downloadURLFromGit musescore MuseScore)
    expectedTeamID="6EPAF2X3PR"
    ;;
toggltrack)
    # credit: Adrian Bühler (@midni9ht)
    name="Toggl Track"
    type="dmg"
    downloadURL=$(downloadURLFromGit toggl-open-source toggldesktop )
    expectedTeamID="B227VTMZ94"
    ;;
balenaetcher)
    # credit: Adrian Bühler (@midni9ht)
    name="balenaEtcher"
    type="dmg"
    downloadURL=$(downloadURLFromGit balena-io etcher )
    expectedTeamID="66H43P8FRG"
    ;;
figma)
    # credit: Alex L. (@aloew on MacAdmins Slack)
    name="Figma"
    type="zip"
    downloadURL="https://www.figma.com/download/desktop/mac/"
    expectedTeamID="T8RA8NE3B7"
    ;;
jetbrainsidea)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains IntelliJ Idea"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;;
jetbrainspycharm)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains PyCharm"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;; 
jetbrainsrubymine)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains RubyMine"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=RM&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=RM&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;; 
jetbrainswebstorm)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains Webstorm"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;; 
jetbrainsdatagrip)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains DataGrip"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;; 
jetbrainsclion)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains CLion"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=CL&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=CL&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;; 
jetbrainsgoland)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains GoLand"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;; 
jetbrainsrider)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains Rider"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;;
jetbrainsappcode)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="JetBrains AppCode"
    type="dmg"
    expectedTeamID="2ZEFAR8TH3"
    #appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=AC&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=AC&latest=true&type=release" | grep -o "mac*.*.dmg" | cut -d '"' -f5)
    ;;
intellijidea)
    # credit: Gabe Marchan (www.gabemarchan.com)
    name="IntelliJ IDEA"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=II&latest&distribution=mac"
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainsideace|\
intellijideace)
    # credit: Alex L. (@aloew on MacAdmins Slack)
    name="IntelliJ IDEA CE"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=IIC&latest&distribution=mac"
    expectedTeamID="2ZEFAR8TH3"
    ;;
jetbrainspycharmce|\
pycharmce)
    # credit: Alex L. (@aloew on MacAdmins Slack)
    name="PyCharm CE"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=PCC&latest&distribution=mac"
    expectedTeamID="2ZEFAR8TH3"
    ;;
pitch)
    #credit: @evil mwnci on MacAdmins Slack
    name="Pitch"
    type="dmg"
    downloadURL="https://desktop.pitch.com/mac/Pitch.dmg"
    expectedTeamID="KUCN8NUU6Z"
    ;;
sidekick)
    #credit: @evil mwnci on MacAdmins Slack
    name="Sidekick"
    type="dmg"
    downloadURL="https://api.meetsidekick.com/downloads/df/mac"
    expectedTeamID="N975558CUS"
    ;;
aircall)
    # credit: @kris-anderson
    name="Aircall"
    type="dmg"
    downloadURL="https://electron.aircall.io/download/osx"
    expectedTeamID="3ML357Q795"
    ;; 
plantronicshub)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="Plantronics Hub"
    type="pkgInDmg"
    pkgName="Plantronics Software.pkg"
    downloadURL="https://www.poly.com/content/dam/www/software/PlantronicsHubInstaller.dmg"
    expectedTeamID="SKWK2Q7JJV"
    #appNewVersion=$(curl -fs "https://www.poly.com/in/en/support/knowledge-base/kb-article-page?lang=en_US&urlName=Hub-Release-Notes&type=Product_Information__kav" | grep -o "(*.*<span>)" | head -1 | cut -d "(" -f2 | sed 's/\<\/span\>//g' | cut -d "<" -f1)
    ;;
jabradirect)
    # credit: Casey Jensen (@cajenson01 on MacAdmins Slack)
    name="Jabra Direct"
    type="pkgInDmg"
    pkgName="JabraDirectSetup.pkg"
    downloadURL="https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.dmg"
    expectedTeamID="55LV32M29R"
    #appNewVersion=$(curl -fs https://www.jabra.com/Support/release-notes/release-note-jabra-direct | grep -o "Jabra Direct macOS:*.*<" | head -1 | cut -d ":" -f2 | cut -d " " -f2 | cut -d "<" -f1)
    ;;
fsmonitor)
     # credit: Adrian Bühler (@midni9ht)
     name="FSMonitor"
     type="zip"
     downloadURL=$(curl --location --fail --silent "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
     expectedTeamID="V85GBYB7B9"
     ;;
ramboxce)
    # credit: Adrian Bühler (@midni9ht)
    name="Rambox"
    type="dmg"
    downloadURL=$(downloadURLFromGit ramboxapp community-edition )
    expectedTeamID="7F292FPD69"
    ;;
adobebrackets)
    # credit: Adrian Bühler (@midni9ht)
    name="Brackets"
    type="dmg"
    downloadURL=$(downloadURLFromGit adobe brackets )
    expectedTeamID="JQ525L2MZD"
    ;;
debookee)
    # credit: Adrian Bühler (@midni9ht)
    name="Debookee"
    type="zip"
    downloadURL=$(curl --location --fail --silent "https://www.iwaxx.com/debookee/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="AATLWWB4MZ"
    ;;
ferdi)
    # credit: Adrian Bühler (@midni9ht)
    name="Ferdi"
    type="dmg"
    downloadURL=$(downloadURLFromGit getferdi ferdi )
    expectedTeamID="B6J9X9DWFL"
    ;;
hyper)
    # credit: Adrian Bühler (@midni9ht)
    name="Hyper"
    type="dmg"
    downloadURL=$(downloadURLFromGit vercel hyper )
    expectedTeamID="JW6Y669B67"
    ;;
menumeters)
    # credit: Adrian Bühler (@midni9ht)
    name="MenuMeters"
    type="zip"
    downloadURL=$(downloadURLFromGit yujitach MenuMeters )
    expectedTeamID="95AQ7YKR5A"
    ;;
vagrant)
    # credit: AP Orlebeke (@apizz)
    name="Vagrant"
    type="pkgInDmg"
    pkgName="vagrant.pkg"
    downloadURL=$(curl -fs https://www.vagrantup.com/downloads.html \
        | tr '><' '\n' | awk -F'"' '/x86_64.dmg/ {print $6}' | head -1)
    expectedTeamID="D38WU7D763"
    ;;
jamfconnect)
    #credit: @marcelclaus on MacAdmins Slack
    name="JamfConnect"
    type="pkgInDmg"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    expectedTeamID="483DWKW443"
    ;;
etrecheck)
    #credit: David Schultz (@dvsjr on MacAdmins Slack)
    name="EtreCheckPro"
    type="zip"
    downloadURL="https://cdn.etrecheck.com/EtreCheckPro.zip"
    expectedTeamID="U87NE528LC"
    ;;


# MARK: add new labels above here

# NOTE: Packages is signed but _not_ notarized, so spctl will reject it
# packages)
#    name="Packages"
#    type="pkgInDmg"
#    pkgName="Install Packages.pkg"
#    downloadURL="http://s.sudre.free.fr/Software/files/Packages.dmg"
#    expectedTeamID="NL5M9E394P"
#    ;;

# msupdate codes from:
# https://docs.microsoft.com/en-us/deployoffice/mac/update-office-for-mac-using-msupdate

# download link IDs from: https://macadmin.software

microsoftoffice365)
    name="MicrosoftOffice365"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525133"
    expectedTeamID="UBF8T346G9"
    # using MS PowerPoint as the 'stand-in' for the entire suite
    appName="Microsoft PowerPoint.app"
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
microsoftedgeconsumerstable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2069148"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps EDGE01 )
    ;;
microsoftcompanyportal)
    name="Company Portal"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869655"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps IMCP01 )
    ;;
microsoftskypeforbusiness)
    name="Skype for Business"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=832978"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSFB16 )
    ;;
microsoftremotedesktop)
    name="Microsoft Remote Desktop"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=868963"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSRD10 )
    ;;
microsoftteams)
    name="Microsoft Teams"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869428"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams "Microsoft Teams Helper" )
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAM01 )
    ;;
microsoftautoupdate)
    name="Microsoft AutoUpdate"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=830196"
    expectedTeamID="UBF8T346G9"
    # commented the updatetool for MSAutoupdate, because when Autoupdate is really
    # old or broken, you want to force a new install
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps MSau04 )
    ;;
microsoftedgeenterprisestable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2093438"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps EDGE01 )
    ;;
microsoftword)
    name="Microsoft Word"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525134"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSWD2019 )
    ;;
microsoftexcel)
    name="Microsoft Excel"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525135"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps XCEL2019 )
    ;;
microsoftpowerpoint)
    name="Microsoft PowerPoint"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525136"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps PPT32019 )
    ;;
microsoftoutlook)
    name="Microsoft Outlook"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525137"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps OPIM2019 )
    ;;
microsoftonenote)
    name="Microsoft OneNote"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=820886"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONMC2019 )
    ;;
microsoftonedrive)
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=823060"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONDR18 )
    ;;
microsoftsharepointplugin)
    name="MicrosoftSharePointPlugin"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=800050"
    expectedTeamID="UBF8T346G9"
    # TODO: determine blockingProcesses for SharePointPlugin
    ;;
visualstudiocode)
    name="Visual Studio Code"
    type="zip"
    downloadURL="https://go.microsoft.com/fwlink/?LinkID=620882"
    expectedTeamID="UBF8T346G9"
    appName="Visual Studio Code.app"
    blockingProcesses=( Electron )
    ;;
microsoftdefenderatp)
    name="Microsoft Defender ATP"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2097502"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps WDAV00 )
    ;;
microsoftlicenseremovaltool)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Microsoft License Removal Tool"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=849815"
    expectedTeamID="QGS93ZLCU7"
    # appNewVersion=$(curl -is "$downloadURL" | grep ocation: | grep -o "Microsoft_.*pkg" | cut -d "_" -f 5 | cut -d "." -f1-2)
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
    printlog "unknown label $label"
    exit 1
    ;;
esac


# MARK: application download and installation starts here


# MARK: extract info from data
if [ -z "$archiveName" ]; then
    case $type in
        dmg|pkg|zip|tbz)
            archiveName="${name}.$type"
            ;;
        pkgInDmg)
            archiveName="${name}.dmg"
            ;;
        pkgInZip)
            archiveName="${name}.zip"
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
        dmg|zip|tbz)
            targetDir="/Applications"
            ;;
        pkg*)
            targetDir="/"
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
    #rm -Rf "$tmpDir"
    cleanupAndExit 1
fi

# MARK: check if this is an Update
getAppVersion
if [[ -n $appVersion ]]; then
    if [[ $DEBUG -eq 0 ]]; then
        if runUpdateTool; then
            cleanupAndExit 0
        fi # otherwise continue
    else
        printlog "DEBUG mode enabled, not running update tool"
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

# MARK: download the archive

if [ -f "$archiveName" ] && [ "$DEBUG" -ne 0 ]; then
    printlog "$archiveName exists and DEBUG enabled, skipping download"
else
    # download the dmg
    printlog "Downloading $downloadURL to $archiveName"
    if ! curl --location --fail --silent "$downloadURL" -o "$archiveName"; then
        printlog "error downloading $downloadURL"
        cleanupAndExit 2
    fi
fi

# MARK: install the download

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
    *)
        printlog "Cannot handle type $type"
        cleanupAndExit 99
        ;;
esac

# MARK: print installed application location and version
sleep 10 # wait a moment to let spotlight catch up
getAppVersion

if [[ -z $appversion ]]; then
    message="Installed $name"
else
    message="Installed $name, version $appversion"
fi

printlog "$message"

if [[ $currentUser != "loginwindow" && $NOTIFY == "success" ]]; then
    printlog "notifying"
    displaynotification "$message" "$name update/installation complete!"
fi

# all done!
cleanupAndExit 0
