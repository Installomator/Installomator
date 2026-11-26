editready)
    name="EditReady"
    type="zip"
    editreadyFeed=$(curl -fsL "https://updates.hedge.video/editready/macos/appcast/editready-prod.xml")
    downloadURL=$(echo "$editreadyFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$editreadyFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="A43D9X8EYU"
    ;;
