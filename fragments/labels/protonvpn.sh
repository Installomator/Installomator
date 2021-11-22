protonvpn)
    name="ProtonVPN"
    type="dmg"
    downloadURL=$(curl -fs "https://protonvpn.com/download" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep dmg | tail -1)
    expectedTeamID="J6S6Q257EK"
    ;;
