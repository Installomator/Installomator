betterzip)
    name="BetterZip"
    type="zip"
    betterzipFeed="$(curl -fsL "https://macitbetter.com/BetterZip6.rss")"
    downloadURL="$(echo "${betterzipFeed}" | xpath 'string(//rss/channel/item[1]/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${betterzipFeed}" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="79RR9LPM2N"
    ;;
