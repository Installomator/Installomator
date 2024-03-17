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

