redgiant|\
magicbullet)
    name="Red Giant"
    type="dmg"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redgiant/releases[^"]*\.dmg' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*-([0-9.]+)_Mac\.dmg$/\1/')
    expectedTeamID="4ZY22YGXQG"
    appCustomVersion(){ cat "/Library/Application Support/Red Giant/version.txt" 2>/dev/null; echo }
    installerTool="Red Giant Installer.app"
    CLIInstaller="Red Giant Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --unattendedmodeui none )
    ;;
