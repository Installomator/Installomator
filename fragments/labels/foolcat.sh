foolcat)
    name="FoolCat"
    type="zip"
    foolcatFeed=$(curl -fsL "https://updates.hedge.video/foolcat/macos/appcast/foolcat-prod.xml")
    downloadURL=$(echo "$foolcatFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$foolcatFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="A43D9X8EYU"
    ;;
