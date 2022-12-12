superhuman)
    name="superhuman"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.superhuman.com/Superhuman-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.superhuman.com/Superhuman.dmg"
    fi
    appNewVersion=$(curl -fs "https://storage.googleapis.com/download.superhuman.com/supertron-update/latest-mac.yml" | head -1 | cut -d " " -f2)
    expectedTeamID="6XHFYUTQGX"
    ;;
