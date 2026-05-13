riversidestudio)
    name="Riverside Studio"
    type="dmg"
    appNewVersion="$(curl -fs "https://assets.riverside.fm/mac-desktop-app/current-release/appcast.xml" | xpath '(//rss/channel/item/sparkle:shortVersionString)[1]' 2>/dev/null | sed -n 's:.*>\(.*\)<.*:\1:p')"
    downloadURL="$(curl -fs "https://assets.riverside.fm/mac-desktop-app/current-release/appcast.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)"
    expectedTeamID="LH94UTHM4U"
    ;;
