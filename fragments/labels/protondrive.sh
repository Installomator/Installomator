protondrive)
    name="Proton Drive"
    type="dmg"
    appNewVersion=$(curl -fs "https://proton.me/download/drive/macos/appcast.xml" | sed -n 's/.*<sparkle:shortVersionString>\(.*\)<\/sparkle:shortVersionString>.*/\1/p')
    downloadURL="https://proton.me/download/drive/macos/$appNewVersion/ProtonDrive-$appNewVersion.dmg"
    expectedTeamID="2SB5Z68H26"
    ;;
