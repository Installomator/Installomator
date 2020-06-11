#!/bin/zsh

# Installomator
#
# Downloads and installs an Applications
# 2020 Armin Briegel - Scripting OS X
#
# inspired by the download scripts from William Smith and Sander Schram
# with additional ideas and contribution from Isaac Ordonez, Mann consulting

VERSION='0.3'
VERSIONDATE='20200609'

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# adjust these variables:

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
#   - kill         kill process without prompting or giving the user a chance to save


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

# todos:

# TODO: better logging (or, really, any logging other than echo)
# TODO: generic function Sparkle to get latest download
# TODO: ?notify user of errors
# TODO: ?generic function to initiate a Sparkle Update
# TODO: better version retrieval and reporting, before and after install


# functions to help with getting info

# Logging
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
    | awk -F '"' "/browser_download_url/ && /$archiveName/ { print \$4 }")
    else
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" \
    | awk -F '"' "/browser_download_url/ && /$filetype/ { print \$4 }")
    fi
    if [ -z "$downloadURL" ]; then
        echo "could not retrieve download URL for $gitusername/$gitreponame"
        exit 9
    else
        echo "$downloadURL"
        return 0
    fi
}

printlog "################## Start Installomator"

# get the label
if [[ $# -eq 0 ]]; then
    printlog "no label provided"
    exit 1
elif [[ $# -gt 3 ]]; then
	# jamf uses $4 for the first custom parameter
    printlog "shifting arguments for Jamf"
    shift 3
fi

label=${1:?"no label provided"}

printlog "################## $label"

# lowercase the label
label=${label:l}

# get current user
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')


# labels in case statement
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
        downloadURL="https://dl.google.com/chrome/mac/stable/gcem/GoogleChrome.pkg"
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
    sonos)
        # credit: Erik Stam (@erikstam)
        name="Sonos"
        type="dmg"
        downloadURL="https://www.sonos.com/redir/controller_software_mac"
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
    webexteams)
        # credit: Erik Stam (@erikstam)
        name="Webex Teams"
        type="dmg"
        downloadURL="https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/WebexTeams.dmg"
        expectedTeamID="DE8Y96K9QP"
        ;;
    #citrixworkspace)
        # credit: Erik Stam (@erikstam)
        #name="Citrix Workspace"
        #type="pkgInDmg"
        #downloadURL="https://downloads.citrix.com/17596/CitrixWorkspaceApp.dmg?__gda__=1588183500_fc68033aef7d6d163d8b8309b964f1de"
        #expectedTeamID="S272Y5R93J"
        #;;
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
    googledrivefilestream)
        # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
        name="Google Drive File Stream"
        type="pkgInDmg"
        downloadURL="https://dl.google.com/drive-file-stream/GoogleDriveFileStream.dmg"
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
    iterm2)
        name="iTerm"
        type="zip"
        downloadURL="https://iterm2.com/downloads/stable/latest"
        expectedTeamID="H7V7XYVQ7D"
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
    adobereaderdc)
        name="Adobe Acrobat Reader DC"
        type="pkgInDmg"
        downloadURL=$(adobecurrent=`curl -s https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt | tr -d '.'` && echo http://ardownload.adobe.com/pub/adobe/reader/mac/AcrobatDC/"$adobecurrent"/AcroRdrDC_"$adobecurrent"_MUI.dmg)
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
        downloadURL="https://laptop-updates.brave.com/latest/osx"
        expectedTeamID="9BNSXJN65R"
        ;;
    umbrellaroamingclient)
        # credit: Tadayuki Onishi (@kenchan0130)
        name="Umbrella Roaming Client"
        type="pkgInZip"
        downloadURL=https://disthost.umbrella.com/roaming/upgrade/mac/production/$( curl -fsL https://disthost.umbrella.com/roaming/upgrade/mac/production/manifest.json | awk -F '"' '/"downloadFilename"/ { print $4 }' )
        expectedTeamID="7P7HQ8H646"
        ;;
    powershell)
        # credit: Tadayuki Onishi (@kenchan0130)
        name="PowerShell"
        type="pkg"
        downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
        | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep -v lts )
        expectedTeamID="UBF8T346G9"
        ;;
    powershell-lts)
        # credit: Tadayuki Onishi (@kenchan0130)
        name="PowerShell"
        type="pkg"
        downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
        | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep lts)
        expectedTeamID="UBF8T346G9"
        ;;
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
    sketch)
        name="Sketch"
        type="zip"
        downloadURL=$(curl -sf "https://www.sketch.com/get/" \
          | grep -o '<a class="download" href=['"'"'"][^"'"'"']*['"'"'"]' \
          | sed -e 's/^<a class="download" href=["'"'"']//' -e 's/["'"'"']$//' \
          | uniq)
        expectedTeamID="WUGMZZ5K46"
        ;;

#    Note: Packages is signed but _not_ notarized, so spctl will reject it
#    packages)
#        name="Packages"
#        type="pkgInDmg"
#        pkgName="Install Packages.pkg"
#        downloadURL="http://s.sudre.free.fr/Software/files/Packages.dmg"
#        expectedTeamID="NL5M9E394P"
#        ;;

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

# functions
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

displaydialog() { # $1: message
    message=${1:-"Message"}
    runAsUser /usr/bin/osascript -e "button returned of (display dialog \"$message\" buttons {\"Not Now\", \"Quit and Update\"} default button \"Quit and Update\")"
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


getAppVersion() {
    # get all apps matching name
    applist=$(mdfind "kMDItemFSName == '$appName' && kMDItemKind == 'Application'" -0 )
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
                echo "found blocking process $x"

                case $BLOCKING_PROCESS_ACTION in
                    kill)
                      printlog "killing process $x"
                      pkill $x
                      ;;
                    prompt_user)
                      button=$(displaydialog "The application $x needs to be updated. Quit $x to continue updating?")
                      if [[ $button = "Not Now" ]]; then
                        cleanupAndExit 10 "user aborted update"
                      else
                        runAsUser osascript -e "tell app \"$x\" to quit"
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

        echo "DEBUG enabled, skipping copy and chown steps"
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
        echo "Changing owner to $currentUser"
        chown -R "$currentUser" "$targetDir/$appName"
    else
        printlog "No user logged in, not changing user"
    fi

}

mountDMG() {
    # mount the dmg
    printlog "Mounting $tmpDir/$archiveName"
    # always pipe 'Y\n' in case the dmg requires an agreement
    if ! dmgmount=$(printlog 'Y'$'\n' | hdiutil attach "$tmpDir/$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        cleanupAndExit 3 "Error mounting $tmpDir/$archiveName"
    fi

    if [[ ! -e $dmgmount ]]; then
        printlog "Error mounting $tmpDir/$archiveName"
        cleanupAndExit 3
    fi

    echo "Mounted: $dmgmount"
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
    echo $teamID
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
        echo "not running as root, exiting"
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



### main code starts here



# extract info from data
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

# determine tmp dir
if [ "$DEBUG" -ne 0 ]; then
    # for debugging use script dir as working directory
    tmpDir=$(dirname "$0")
else
    # create temporary working directory
    tmpDir=$(mktemp -d )
fi

# change directory to temporary working directory
printlog "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    printlog "error changing directory $tmpDir"
    #rm -Rf "$tmpDir"
    cleanupAndExit 1
fi

# check if this is an Update
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

# when user is logged in, and app is running, prompt user to quit app

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

# download the archive

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

case $type in
    dmg)
        installFromDMG
        ;;
    pkg)
        installFromPKG
        ;;
    zip|tbz)
        installFromZIP
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

# print installed application location and version
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
    displaynotification "$message" "Installation complete!"
fi

# all done!
cleanupAndExit 0
