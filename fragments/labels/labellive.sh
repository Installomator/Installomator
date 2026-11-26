labellive)
    name="Label LIVE"
    type="dmg"
    labelliveFeed=$(curl -fsL "https://s3.amazonaws.com/labellive.semireg.com/latest-mac.yml")
    downloadURL="https://s3.amazonaws.com/labellive.semireg.com/$(echo "$labelliveFeed" | awk '/url:.*\.dmg/{print $NF; exit}')"
    appNewVersion=$(echo "$labelliveFeed" | awk '/^version:/{print $2; exit}')
    expectedTeamID="7NB4X9P2DR"
    ;;
