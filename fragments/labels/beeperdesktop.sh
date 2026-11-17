beeperdesktop)
    name="Beeper Desktop"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://api.beeper.com/desktop/download/macos/arm64/stable/com.automattic.beeper.desktop"
    else
        downloadURL="https://api.beeper.com/desktop/download/macos/x64/stable/com.automattic.beeper.desktop"
    fi
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | grep -Eo '[0-9]+(\.[0-9]+)+' | tail -1)
    expectedTeamID="PZYM8XX95Q"
    ;;
