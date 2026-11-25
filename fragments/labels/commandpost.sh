commandpost)
    name="CommandPost"
    type="dmg"
    commandpostFeed=$(curl -fsL "https://raw.githubusercontent.com/CommandPost/CommandPost/develop/appcast/appcast.xml")
    downloadURL=$(echo "$commandpostFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$commandpostFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="A5HDJTY9X5"
    ;;
