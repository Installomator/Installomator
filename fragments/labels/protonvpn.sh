protonvpn)
    name="ProtonVPN"
    type="dmg"
    downloadURL=$(curl -fs "https://protonvpn.com/download" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*\.dmg" | head -1)
    appNewVersion=$(echo $downloadURL | sed -e 's/^.*\/Proton.*_v\([0-9.]*\)\.dmg/\1/g')
    expectedTeamID="J6S6Q257EK"
    ;;
