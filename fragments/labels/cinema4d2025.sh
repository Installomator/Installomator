cinema4d2025)
    name="Cinema 4D"
    type="dmg"
    productDownloadsPage=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*downloads/cinema-4d-2025[^"]*' | head -1)
    downloadURL=$(curl -fsL $productDownloadsPage | grep -oE 'https://[^"]*\.dmg' | head -1)
    appNewVersion=$(grep -Eo "/2025.([[0-9]+).([[0-9]+)/" <<< $downloadURL | sed 's|/||g')
    targetDir="/Applications/Maxon Cinema 4D 2025"
    appCustomVersion(){defaults read "${targetDir}/Cinema 4D.app/Contents/Info.plist" CFBundleGetInfoString | grep -Eo "2025+\.[0-9]+\.[0-9]+"}
    installerTool="Maxon Cinema 4D Installer.app"
    CLIInstaller="Maxon Cinema 4D Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
