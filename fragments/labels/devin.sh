devin|\
windsurf)
    name="Devin"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="$(curl -fsL "https://docs.devin.ai/desktop/releases" | grep -Eo 'https://[^"\]*-darwin-arm64-[0-9.]+\.dmg' | head -n 1)"
    else
        downloadURL="$(curl -fsL "https://docs.devin.ai/desktop/releases" | grep -Eo 'https://[^"\]*-darwin-x64-[0-9.]+\.dmg' | head -n 1)"
    fi
    appNewVersion="$(basename "$downloadURL" .dmg | awk -F- '{print $NF}')"
    expectedTeamID="83Z2LHX6XW"
    ;;
