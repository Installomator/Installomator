superhuman)
    name="superhuman"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.superhuman.com/Superhuman-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.superhuman.com/Superhuman.dmg"
    fi
    expectedTeamID="6XHFYUTQGX"
    ;;
