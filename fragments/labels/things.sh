things)
    name="Things3"
    type="zip"
    thingsFeed=$(curl -fsL "https://static.culturedcode.com/things/sparkle-things3-unified/sparkle_en.xml")
    downloadURL=$(echo "$thingsFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    appNewVersion=$(echo "$thingsFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="JLMPQHK86H"
    ;;
