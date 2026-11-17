solstice)
    name="Mersive Solstice"
    type="dmg"
    downloadURL=$(curl -fsSL "https://www.mersive.com/downloads" |
        grep -E 'Mac Apple|Mac Intel' |
        grep -oE 'https?[^"]+SolsticeClient-[^"]+\.dmg' |
        if [[ "$(arch)" == "arm64" ]]; then
            head -n 1
        else
            tail -n 1
        fi
    )
    appNewVersion=$(basename "$downloadURL" .dmg | cut -d '-' -f 2)
    expectedTeamID="63B5A5WDNG"
    ;;
