vivaldi)
    name="Vivaldi"
    type="tbz"
    vivaldiXML=$(curl -fsL "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml")
    appNewVersion=$(echo "$vivaldiXML" | xpath 'string(//rss/channel/item/sparkle:shortVersionString)')
    downloadURL=$(echo "$vivaldiXML" | xpath 'string(//rss/channel/item/enclosure/@url)')
    expectedTeamID="4XF3XNRN6Y"
    ;;
