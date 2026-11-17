canva)
    name="Canva"
    type="dmg"
    downloadURL="https://desktop-release.canva.com/Canva-latest.dmg"
    appNewVersion=$(curl -fsL "https://desktop-release.canva.com/latest-mac.yml" | awk '/^version:/ { print $2; exit }')
    expectedTeamID="5HD2ARTBFS"
    ;;
