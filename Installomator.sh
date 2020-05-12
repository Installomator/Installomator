#!/bin/zsh

# Installomator
#
# Downloads and installs an Applications
# 2020 Armin Briegel - Scripting OS X
#
# inspired by the download scripts from William Smith and Sander Schram
# with additional ideas and contribution from Isaac Ordonez, Mann consulting

VERSION='0.1'
VERSIONDATE='20200512'

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# adjust these variables:

# set to 0 for production, 1 for debugging
# while debugging, items will be downloaded to the parent directory of this script
# also no actual installation will be performed
DEBUG=1

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
# TODO: ?blockingProcesses for SharePointPlugin
# TODO: generic function Sparkle to get latest download
# TODO: ?notify user of errors
# TODO: ?generic function to initiate a SparkleProcess


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
        cleanupAndExit 9 "could not retrieve download URL for $gitusername/$gitreponame"
    else
        echo "$downloadURL"
        return 0
    fi
}

# get the label
if [[ $# -eq 0 ]]; then
    echo "no label provided"
    exit 1
elif [[ $# -gt 3 ]]; then
	# jamf uses $4 for the first custom parameter
    echo "shifting arguments for Jamf"
    shift 3
fi

label=${1:?"no label provided"}


# lowercase the label
label=${label:l}

# get current user
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')


# labels in case statement
case $label in
    version)
        # print the script VERSION
        echo "$VERSION"
        exit 0
        ;;
    longversion)
        # print the script version
        echo "Installomater: version $VERSION ($VERSIONDATE)"
        exit 0
        ;;
    
    # label descriptions start here
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
        # credit: Mischa van der Bent
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
        downloadURL=$(curl -fs https://bitbucket.org/prowarehouse-nl/erase-install/downloads/ | grep pkg | cut -d'"' -f2 | head -n 1)
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
        # credit: Isaac Ordonez, Mann consulting
        name="Box"
        type="pkg"
        downloadURL="https://e3.boxcdn.net/box-installers/desktop/releases/mac/Box.pkg"
        expectedTeamID="M683GB7CPW"
        ;;
    aviatrix)
        # credit: Isaac Ordonez, Mann consulting
        name="Aviatrix VPN Client"
        type="pkg"
        downloadURL="https://s3-us-west-2.amazonaws.com/aviatrix-download/AviatrixVPNClient/AVPNC_mac.pkg"
        expectedTeamID="32953Z7NBN"
        ;;
    zoom)
        # credit: Isaac Ordonez, Mann consulting
        name="Zoom.us"
        type="pkg"
        downloadURL="https://zoom.us/client/latest/ZoomInstallerIT.pkg"
        expectedTeamID="BJ4HAAB9B3"        
        blockingProcesses=( zoom.us )
        ;;
    sonos)
        # credit: Erik Stam
        name="Sonos"
        type="dmg"
        downloadURL="https://www.sonos.com/redir/controller_software_mac"
        expectedTeamID="2G4LW83Q3E"
        ;;
    coderunner)
        # credit: Erik Stam
        name="CodeRunner"
        type="zip"
        downloadURL="https://coderunnerapp.com/download"
        expectedTeamID="R4GD98AJF9"
        ;;
    openvpnconnect)
        # credit: Erik Stam
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
        # credit: Erik Stam
        name="Cisco Webex Meetings"
        type="pkgInDmg"
        downloadURL="https://akamaicdn.webex.com/client/webexapp.dmg"
        expectedTeamID="DE8Y96K9QP"
        ;;
    webexteams)
        # credit: Erik Stam
        name="Webex Teams"
        type="pkgInDmg"
        downloadURL="https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/WebexTeams.dmg"
        expectedTeamID="DE8Y96K9QP"
        ;;
    citrixworkspace)
        # credit: Erik Stam
        name="Citrix Workspace"
        type="pkgInDmg"
        downloadURL="https://downloads.citrix.com/17596/CitrixWorkspaceApp.dmg?__gda__=1588183500_fc68033aef7d6d163d8b8309b964f1de"
        expectedTeamID="S272Y5R93J"
        ;;
    privileges)
        # credit: Erik Stam
        name="Privileges"
        type="zip"
        downloadURL=$(downloadURLFromGit sap macOS-enterprise-privileges )
        expectedTeamID="7R5ZEU67FQ"
        ;;
    googledrivefilestream)
        # credit: Isaac Ordonez, Mann consulting
        name="Google Drive File Stream"
        type="pkgInDmg"
        downloadURL="https://dl.google.com/drive-file-stream/GoogleDriveFileStream.dmg"
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
        echo "unknown label $label"
        exit 1
        ;;
esac

# functions
cleanupAndExit() { # $1 = exit code, $2 message
    if [[ -n $2 && $1 -ne 0 ]]; then
        echo "ERROR: $2"
    fi
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
            echo "found app at $installedAppPath, version $appversion"
        else
            echo "could not determine location of $appName"
        fi
    else
        echo "could not find $appName"
    fi
}

checkRunningProcesses() {
    # don't check in DEBUG mode
    if [[ $DEBUG -ne 0 ]]; then
        echo "DEBUG mode, not checking for blocking processes"
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
                      echo "killing process $x"
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
            echo "waiting 30 seconds for processes to quit"
            sleep 30
        fi
    done

    if [[ $countedProcesses -ne 0 ]]; then
        cleanupAndExit 11 "could not quit all processes, aborting..."
    fi

    echo "no more blocking processes, continue with update"
}

installAppWithPath() { # $1: path to app to install in $targetDir
    appPath=${1?:"no path to app"}
    
    # check if app exists
    if [ ! -e "$appPath" ]; then
        cleanupAndExit 8 "could not find: $appPath"
    fi

    # verify with spctl
    echo "Verifying: $appPath"
    if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' ); then
        cleanupAndExit 4 "Error verifying $appPath"
    fi

    echo "Team ID: $teamID (expected: $expectedTeamID )"

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
        echo "Removing existing $targetDir/$appName"
        rm -Rf "$targetDir/$appName"
    fi

    # copy app to /Applications
    echo "Copy $appPath to $targetDir"
    if ! ditto "$appPath" "$targetDir/$appName"; then
        cleanupAndExit 7 "Error while copying"
    fi


    # set ownership to current user
    if [ "$currentUser" != "loginwindow" ]; then
        echo "Changing owner to $currentUser"
        chown -R "$currentUser" "$targetDir/$appName" 
    else
        echo "No user logged in, not changing user"
    fi

}

mountDMG() {
    # mount the dmg
    echo "Mounting $tmpDir/$archiveName"
    # always pipe 'Y\n' in case the dmg requires an agreement
    if ! dmgmount=$(echo 'Y'$'\n' | hdiutil attach "$tmpDir/$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        cleanupAndExit 3 "Error mounting $tmpDir/$archiveName"
    fi
    
    if [[ ! -e $dmgmount ]]; then
        echo "Error mounting $tmpDir/$archiveName"
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
    tar -xf "$archiveName"
    
    installAppWithPath "$tmpDir/$appName"
}

installPkgInDmg() {
    mountDMG
    # locate pkg in dmg
    if [[ -z $pkgName ]]; then
        pkgName="$name.pkg"
    fi
    
    # it is now safe to overwrite archiveName for installFromPKG
    archiveName="$dmgmount/$pkgName"
    
    # installFromPkgs
    installFromPKG
}

installPkgInZip() {
    # unzip the archive
    echo "Unzipping $archiveName"
    tar -xf "$archiveName"

    # locate pkg in zip
    if [[ -z $pkgName ]]; then
        pkgName="$name.pkg"
    fi
    
    # it is now safe to overwrite archiveName for installFromPKG
    archiveName="$tmpDir/$pkgName"
    
    # installFromPkgs
    installFromPKG
}

runUpdateTool() {
    if [[ -x $updateTool ]]; then
        echo "running $updateTool $updateToolArguments"
        if [[ -n $updateToolRunAsCurrentUser ]]; then
            runAsUser $updateTool ${updateToolArguments}
        else
            $updateTool ${updateToolArguments}
        fi
        if [[ $? -ne 0 ]]; then
            cleanupAndExit 15 "Error running $updateTool"
        fi
    else
        echo "couldn't find $updateTool, continuing normally"
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
        dmg|zip|tbz)
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

# determine tmp dir
if [ "$DEBUG" -ne 0 ]; then
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

# check if this is an Update
getAppVersion
if [[ -n $appVersion ]]; then
    if [[ $DEBUG -eq 0 ]]; then
        if runUpdateTool; then
            cleanupAndExit 0
        fi # otherwise continue
    else
        echo "DEBUG mode enabled, not running update tool"
    fi
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

if [ -f "$archiveName" ] && [ "$DEBUG" -ne 0 ]; then
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
        echo "Cannot handle type $type"
        cleanupAndExit 99
        ;;
esac

# print installed application location and version
getAppVersion

# TODO: notify when done
if [[ $currentUser != "loginwindow" ]]; then
    echo "notifying"
    displaynotification "Installed $name, version $appversion" "Installation complete!"
fi

# all done!
cleanupAndExit 0
