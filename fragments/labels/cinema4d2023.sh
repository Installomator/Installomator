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
