stackfield)
    name="Stackfield"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.stackfield.com/desktopapp/stackfield-arm64-mac.dmg"
    else
        downloadURL="https://www.stackfield.com/desktopapp/stackfield-mac.dmg"
    fi
    appNewVersion=$(curl -fsL "https://www.stackfield.com/DesktopApp/macvers.js" | tr -cd '0-9.')
    expectedTeamID="LLK9S59M62"
    ;;
