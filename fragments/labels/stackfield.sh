stackfield)
    name="Stackfield"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.stackfield.com/desktopapp/stackfield-arm64-mac.dmg"
    else
        downloadURL="https://www.stackfield.com/desktopapp/stackfield-mac.dmg"
    fi
    expectedTeamID="LLK9S59M62"
    ;;
