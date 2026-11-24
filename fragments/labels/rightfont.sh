rightfont)
    name="RightFont"
    type="zip"
    rightfontFeed="$(curl -fsL "https://rightfontapp.com/update/appcast.xml")"
    downloadURL=$(echo "$rightfontFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(echo "$rightfontFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="VABUY2Z595"
    ;;
