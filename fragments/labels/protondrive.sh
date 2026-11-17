protondrive)
    name="Proton Drive"
    type="dmg"
    appNewVersion=$(curl -fs "https://proton.me/download/drive/macos/appcast.xml" | xmllint --xpath "string(//item[*[local-name()='channel' and text()='stable']]/*[local-name()='shortVersionString'])" -)
    downloadURL="https://proton.me/download/drive/macos/$appNewVersion/ProtonDrive-$appNewVersion.dmg"
    expectedTeamID="2SB5Z68H26"
    ;;
