talkdeskcallbar)
    name="Callbar"
    type="dmg"
    appNewVersion=$(curl -fsL https://downloadcallbar.talkdesk.com/release_metadata.json | sed -n 's/^.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*$/\1/p')
    downloadURL=https://downloadcallbar.talkdesk.com/Callbar-${appNewVersion}.dmg
    expectedTeamID="YGGJX44TB8"
    ;;
