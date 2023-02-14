talkdeskcallbar)
    name="Callbar"
    type="dmg"
    downloadURL=https://downloadcallbar.talkdesk.com/Callbar-$(curl -fsL https://downloadcallbar.talkdesk.com/release_metadata.json | sed -n 's/^.*"version":"\([^"]*\)".*$/\1/p').dmg
    appNewVersion=$(curl -fsL https://downloadcallbar.talkdesk.com/release_metadata.json | sed -n 's/^.*"version":"\([^"]*\)".*$/\1/p')
    expectedTeamID="YGGJX44TB8"
    ;;
