talkdeskcallbar)
    name="Callbar"
    type="dmg"
    talkdeskcallbarVersions=$(curl -fsL "https://downloadcallbar.talkdesk.com/release_metadata.json")
    appNewVersion=$(getJSONValue "$talkdeskcallbarVersions" "version")
    downloadURL=https://downloadcallbar.talkdesk.com/Callbar-${appNewVersion}.dmg
    expectedTeamID="YGGJX44TB8"
    ;;
