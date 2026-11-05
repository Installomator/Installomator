audacity|\
audacity3)
    name="Audacity"
    type="dmg"
    downloadURL=$(curl -fsL "https://api.github.com/repos/audacity/audacity/releases?per_page=100" | awk -F '"' '/"browser_download_url":/ && /audacity-macOS-3\.[0-9]+\.[0-9]+-universal\.dmg/ { print $4; exit }')
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -nE 's|.*/audacity-macOS-([0-9]+(\.[0-9]+)+)-universal\.dmg$|\1.0|p')
    expectedTeamID="6EPAF2X3PR"
    ;;
