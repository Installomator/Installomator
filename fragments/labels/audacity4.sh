audacity4)
    name="Audacity"
    appName="Audacity 4.app"
    type="dmg"
    archiveName="Audacity4.dmg"
    releaseData=$(curl -fsL "https://api.github.com/repos/audacity/audacity/releases?per_page=100")
    downloadURL=$(printf '%s\n' "$releaseData" | awk -F '"' '/"browser_download_url":/ && /audacity-macOS-4\.[0-9]+\.[0-9]+-universal\.dmg/ && url == "" { url=$4 } END { print url }')
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -E 's|.*/audacity-macOS-([0-9]+(\.[0-9]+)+)-universal\.dmg$|\1|')
    expectedTeamID="6EPAF2X3PR"
    ;;
