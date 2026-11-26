pixelsnap2)
    name="PixelSnap 2"
    type="dmg"
    pixelsnapFeed=$(curl -fsL "https://updates.getpixelsnap.com/v2/appcast.xml")
    downloadURL=$(echo "$pixelsnapFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$pixelsnapFeed" | xpath 'string((//rss/channel/item)[1]/sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="AFJU4P8ZV4"
    ;;
