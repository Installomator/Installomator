wisprflow)
    name="Wispr Flow"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.wisprflow.ai/mac-apple/latest"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dl.wisprflow.ai/mac-intel/latest"
    fi
    appNewVersion="$(curl -sIL "$downloadURL" | grep -i "^location:" | sed 's/.*Flow-v\([0-9.]*\).dmg.*/\1/')"
    expectedTeamID="C9VQZ78H85"
    ;;
