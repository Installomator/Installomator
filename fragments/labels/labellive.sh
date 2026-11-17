labellive)
    name="Label LIVE"
    type="dmg"
    appNewVersion=$(curl -fsSL "https://s3.amazonaws.com/labellive.semireg.com/latest-mac.yml" | awk '/^version:/ {print $2; exit}')
    downloadURL="https://download.label.live/Label-LIVE-${appNewVersion}.dmg"
    expectedTeamID="7NB4X9P2DR"
    ;;
