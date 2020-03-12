#!/bin/zsh

# Installomator
#
# Downloads and installs an Applications
# 2020 Armin Briegel - Scripting OS X
#
# inspired by the download scripts from William Smith and Sander Schram

VERSION='20200311'

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# adjust these variables:

# set to 0 for production, 1 for debugging
# while debugging, items will be downloaded to the parent directory of this script
# also no actual installation will be performed
DEBUG=1 

# if this is set to 1, the argument will be picked up at $4 instead of $1
JAMF=0

# behavior when blocking processes are found
BLOCKING_PROCESS_ACTION=prompt_user
# options:
#   - ignore       continue even when blocking processes are found
#   - silent_fail  exit script without prompt or installation
#   - prompt_user  show a user dialog for each blocking process found
#                  abort after three attempts to quit
#   - kill         kill process without prompting or giving the user a chance to save



# Each workflow identifier needs to be listed in the case statement below.
# for each identifier these variables can be set:
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
#     - pkgInDmg (not yet implemented)
#     - pkgInZip (not yet implemented)
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

# todos:

# TODO: handle pkgs in dmg or zip
# TODO: print version of installed software
# TODO: notification when done
# TODO: add remaining MS pkgs
# TODO: determine blockingProcesses for SharePointPlugin
# TODO: use Sparkle to get latest download 

# functions to help with getting info

# will get the latest release download from a github repo
downloadURLFromGit() { # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}
    
    if [ -n "$archiveName" ]; then
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" \
    | awk -F '"' "/browser_download_url/ && /$archiveName/ { print \$4 }")
    else
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" \
    | awk -F '"' "/browser_download_url/ && /$type/ { print \$4 }")
    fi
    if [ -z "$downloadURL" ]; then
        echo "could not retrieve download URL for $gitusername/$gitreponame"
        cleanupAndExit 9
    else
        echo "$downloadURL"
        return 0
    fi
}



# get the identifier from the argument

if [ "$JAMF" -eq 0 ]; then
    identifier=${1:?"no identifier provided"}
else
    identifier=${4:?"argument $4 required"}
fi

# lowercase the identifier
identifier=$(echo "$identifier" |  tr '[:upper:]' '[:lower:]' )



# identifiers in case statement

case $identifier in
    version)
        # print the script version
        echo "Installomater: version $VERSION"
        exit 0
        ;;
    
    # app descriptions start here
    googlechrome)
        name="Google Chrome"
        type="dmg"
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
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
        downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=en-US"
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
        # thanks to Mischa van der Bent
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
        downloadURL="https://bitbucket.org"$(curl -s https://bitbucket.org/prowarehouse-nl/erase-install/downloads/ | grep pkg | cut -d'"' -f2 | head -n 1)
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
        downloadURL="http://get.videolan.org/vlc/3.0.8/macosx/vlc-3.0.8.dmg"
        expectedTeamID="75GAHG3SZQ"
        ;;


    microsoftoffice365)
        name="MicrosoftOffice365"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=525133"
        expectedTeamID="UBF8T346G9"
        blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "Microsoft OneDrive" )
        ;;   
    microsoftedgeconsumerstable)
        name="Microsoft Edge"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=2069148"
        expectedTeamID="UBF8T346G9"
        ;;
    microsoftcompanyportal)  
        name="Company Portal"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=869655"
        expectedTeamID="UBF8T346G9"
        ;;
    microsoftskypeforbusiness)  
        name="Skype for Business"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=832978"
        expectedTeamID="UBF8T346G9"
        ;;
    microsoftremotedesktop)  
        name="Microsoft Remote Desktop"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=868963"
        expectedTeamID="UBF8T346G9"
        ;;
    microsoftteams)  
        name="Teams"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=869428"
        expectedTeamID="UBF8T346G9"
        ;;
    microsoftautoupdate)
        name="Microsoft AutoUpdate"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=830196"
        teamID="UBF8T346G9"
        ;;
    microsoftedgeenterprisestable)
        name="Microsoft Edge"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=2093438"
        teamID="UBF8T346G9"
        ;;
    microsoftsharepointplugin)
        name="MicrosoftSharePointPlugin"
        type="pkg"
        downloadURL="https://go.microsoft.com/fwlink/?linkid=800050"
        teamID="UBF8T346G9"
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

    # note: there are more available MS downloads to add
    # 525133 - Office 2019 for Mac SKUless download (aka Office 365)
    # 2009112 - Office 2019 for Mac BusinessPro SKUless download (aka Office 365 with Teams)
    # 871743 - Office 2016 for Mac SKUless download
    # 830196 - AutoUpdate download
    # 2069148 - Edge (Consumer Stable)
    # 2069439 - Edge (Consumer Beta)
    # 2069340 - Edge (Consumer Dev)
    # 2069147 - Edge (Consumer Canary)
    # 2093438 - Edge (Enterprise Stable)
    # 2093294 - Edge (Enterprise Beta)
    # 2093292 - Edge (Enterprise Dev)
    # 525135 - Excel 2019 SKUless download
    # 871750 - Excel 2016 SKUless download
    # 869655 - InTune Company Portal download
    # 823060 - OneDrive download
    # 820886 - OneNote download
    # 525137 - Outlook 2019 SKUless download
    # 871753 - Outlook 2016 SKUless download
    # 525136 - PowerPoint 2019 SKUless download
    # 871751 - PowerPoint 2016 SKUless download
    # 868963 - Remote Desktop
    # 800050 - SharePoint Plugin download
    # 832978 - Skype for Business download
    # 869428 - Teams
    # 525134 - Word 2019 SKUless download
    # 871748 - Word 2016 SKUless download

        
    # these description exist for testing and are intentionally broken
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
        # unknown identifier
        echo "unknown identifier $identifier"
        exit 1
        ;;
esac

# functions
cleanupAndExit() { # $1 = exit code
    if [ "$DEBUG" -eq 0 ]; then
        # remove the temporary working directory when done
        echo "Deleting $tmpDir"
        rm -Rf "$tmpDir"
    fi
    
    if [ -n "$dmgmount" ]; then
        # unmount disk image
        echo "Unmounting $dmgmount"
        hdiutil detach "$dmgmount"
    fi
    exit "$1"
}

consoleUser() {
    scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }'
}

runAsUser() {  
    cuser=$(consoleUser)
    if [[ $cuser != "loginwindow" ]]; then
        uid=$(id -u "$cuser")
        launchctl asuser $uid sudo -u $cuser "$@"
    fi
}

displaydialog() { # $1: message
    message=${1:-"Message"}
    runAsUser /usr/bin/osascript -e "button returned of (display dialog \"$message\" buttons {\"Not Now\", \"Quit and Update\"} default button \"Quit and Update\")"
}

checkRunningProcesses() {
    # try at most 3 times
    for i in {1..3}; do
        countedProcesses=0
        for x in ${blockingProcesses}; do
            if pgrep -xq "$x"; then
                echo "found blocking process $x"
                
                case $BLOCKING_PROCESS_ACTION in
                    kill)
                      echo "killing process $x"
                      pkill $x
                      ;;
                    prompt_user)
                      button=$(displaydialog "The application $x needs to be updated. Quit $x to continue updating?")
                      if [[ $button = "Not Now" ]]; then
                        echo "user aborted update"
                        cleanupAndExit 10
                      else
                        runAsUser osascript -e "tell app \"$x\" to quit"
                      fi
                      ;;
                    silent_fail)
                      echo "aborting"
                      cleanupAndExit 12
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
            echo "waiting 30 seconds for processes to quit"
            sleep 30
        fi
    done

    if [[ $countedProcesses -ne 0 ]]; then
        echo "could not quit all processes, aborting..."
        cleanupAndExit 11
    fi

    echo "no more blocking processes, continue with update"
}

installAppWithPath() { # $1: path to app to install in $targetDir
    appPath=${1?:"no path to app"}
    
    # check if app exists
    if [ ! -e "$appPath" ]; then
        echo "could not find: $appPath"
        cleanupAndExit 8
    fi

    # verify with spctl
    echo "Verifying: $appPath"
    if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' ); then
        echo "Error verifying $appPath"
        cleanupAndExit 4
    fi

    echo "Team ID: $teamID (expected: $expectedTeamID )"

    if [ "$expectedTeamID" != "$teamID" ]; then
        echo "Team IDs do not match!"
        cleanupAndExit 5
    fi

    # check for root
    if [ "$(whoami)" != "root" ]; then
        # not running as root
        if [ "$DEBUG" -eq 0 ]; then
            echo "not running as root, exiting"
            cleanupAndExit 6
        fi
    
        echo "DEBUG enabled, skipping copy and chown steps"
        return 0
    fi

    # remove existing application
    if [ -e "$targetDir/$appName" ]; then
        echo "Removing existing $targetDir/$appName"
        rm -Rf "$targetDir/$appName"
    fi

    # copy app to /Applications
    echo "Copy $appPath to $targetDir"
    if ! ditto "$appPath" "$targetDir/$appName"; then
        echo "Error while copying!"
        cleanupAndExit 7
    fi


    # set ownership to current user
    if [ -n "$currentUser" ]; then
        echo "Changing owner to $currentUser"
        chown -R "$currentUser" "$targetDir/$appName" 
    else
        echo "No user logged in, not changing user"
    fi

}

installFromDMG() {
    # mount the dmg
    echo "Mounting $tmpDir/$archiveName"
    # always pipe 'Y\n' in case the dmg requires an agreement
    if ! dmgmount=$(echo 'Y'$'\n' | hdiutil attach "$tmpDir/$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        echo "Error mounting $tmpDir/$archiveName"
        cleanupAndExit 3
    fi
    echo "Mounted: $dmgmount"
    
    installAppWithPath "$dmgmount/$appName"
}

installFromPKG() {
    # verify with spctl
    echo "Verifying: $archiveName"
    if ! teamID=$(spctl -a -vv -t install "$archiveName" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' ); then
        echo "Error verifying $archiveName"
        cleanupAndExit 4
    fi

    echo "Team ID: $teamID (expected: $expectedTeamID )"

    if [ "$expectedTeamID" != "$teamID" ]; then
        echo "Team IDs do not match!"
        cleanupAndExit 5
    fi
    
    # skip install for DEBUG
    if [ "$DEBUG" -ne 0 ]; then
        echo "DEBUG enabled, skipping installation"
        return 0
    fi
    
    # check for root
    if [ "$(whoami)" != "root" ]; then
        # not running as root
        echo "not running as root, exiting"
        cleanupAndExit 6    
    fi

    # install pkg
    echo "Installing $archiveName to $targetDir"
    if ! installer -pkg "$archiveName" -tgt "$targetDir" ; then
        echo "error installing $archiveName"
        cleanupAndExit 9
    fi
}

installFromZIP() {
    # unzip the archive
    echo "Unzipping $archiveName"
    unzip -o -qq "$archiveName"
    
    installAppWithPath "$tmpDir/$appName"
}



### main code starts here



# extract info from data
if [ -z "$archiveName" ]; then
    case $type in
        dmg|pkg|zip)
            archiveName="${name}.$type"
            ;;
        pkgInDmg)
            archiveName="${name}.dmg"
            ;;
        pkgInZip)
            archiveName="${name}.zip"
            ;;
        *)
            echo "Cannot handle type $type"
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
        dmg|zip)
            targetDir="/Applications"
            ;;
        pkg*)
            targetDir="/"
            ;;
        *)
            echo "Cannot handle type $type"
            cleanupAndExit 99
            ;;
    esac
fi

if [[ -z $blockingProcesses ]]; then
    echo "no blocking processes defined, using $name as default"
    blockingProcesses=( $name )
fi

currentUser=$(consoleUser)

# determine tmp dir
if [ "$DEBUG" -eq 1 ]; then
    # for debugging use script dir as working directory
    tmpDir=$(dirname "$0")
else
    # create temporary working directory
    tmpDir=$(mktemp -d )
fi

# change directory to temporary working directory
echo "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    echo "error changing directory $tmpDir"
    #rm -Rf "$tmpDir"
    cleanupAndExit 1
fi

# when user is logged in, and app is running, prompt user to quit app

if [[ $BLOCKING_PROCESS_ACTION == "ignore" ]]; then
    echo "ignoring blocking processes"
else
    if [[ $currentUser != "loginwindow" ]]; then
        if [[ ${#blockingProcesses} -gt 0 ]]; then
            if [[ ${blockingProcesses[1]} != "NONE" ]]; then
                checkRunningProcesses
            fi
        fi
    fi
fi

# download the archive

if [ -f "$archiveName" ] && [ "$DEBUG" -eq 1 ]; then
    echo "$archiveName exists and DEBUG enabled, skipping download"
else
    # download the dmg
    echo "Downloading $downloadURL to $archiveName"
    if ! curl --location --fail --silent "$downloadURL" -o "$archiveName"; then
        echo "error downloading $downloadURL"
        cleanupAndExit 2
    fi
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
    *)
        echo "Cannot handle type $type"
        cleanupAndExit 99
        ;;
esac


# TODO: notify when done

# all done!
cleanupAndExit 0
