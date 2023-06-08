orbstack)
    name="OrbStack"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fs "https://orbstack.dev/download/beta/latest/arm64" | grep -i -o -E 'https.*\.dmg' | head -1 | cut -d '"' -f1)
    else
        downloadURL=$(curl -fs "https://orbstack.dev/download/beta/latest/amd64" | grep -i -o -E 'https.*\.dmg' | head -1 | cut -d '"' -f1)
    fi
    expectedTeamID="HUAQ24HBR6"
    ;;
