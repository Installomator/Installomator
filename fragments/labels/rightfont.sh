rightfont)
    name="RightFont"
    type="zip"
    downloadURL=$(curl -fs "https://rightfontapp.com/update/appcast.xml" | xpath -e '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://rightfontapp.com/update/appcast.xml" | xpath -e '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="VABUY2Z595"
    ;;
