jumpdesktop)
    name="Jump Desktop"
    type="zip"
    jumpDesktopFeed=$(curl -fsL "https://mirror.jumpdesktop.com/downloads/jdm/jdmac-web-appcast.xml")
    downloadURL=$(echo "$jumpDesktopFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    appNewVersion=$(echo "$jumpDesktopFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2 | sed -E 's/^([0-9]+\.[0-9]+\.[0-9]+)$/\1.0/')
    expectedTeamID="2HCKV38EEC"
    ;;
