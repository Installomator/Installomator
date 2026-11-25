arctic)
    name="Arctic"
    type="zip"
    arcticFeed=$(curl -fsL "https://updates.hedge.video/arctic/macos/appcast/arctic-prod.xml")
    downloadURL=$(echo "$arcticFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$arcticFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="A43D9X8EYU"
    ;;
