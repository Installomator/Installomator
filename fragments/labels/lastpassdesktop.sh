lastpassdesktop)
    name="LastPass for Desktop"
    type="dmg"
    downloadURL="https://download.cloud.lastpass.com/lastpass-for-desktop-macos/universal/LastPassForDesktopMac.dmg"
    lastpassJSON=$(curl -fsL "https://download.cloud.lastpass.com/lastpass-for-desktop-macos/universal/releases.json")
    appNewVersion=$(getJSONValue "$lastpassJSON" "currentRelease")
    expectedTeamID="RNDLY9ZML8"
    ;;
