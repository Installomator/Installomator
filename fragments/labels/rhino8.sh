rhino8)
    name="Rhino 8"
    type="dmg"
    sparkleFeed=$(curl -fs "https://files.mcneel.com/rhino/8/mac/updates/commercialUpdates.xml")
    appNewVersion=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2 | cut -d ' ' -f 1)
    downloadURL=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="D6XDM4N99E"
    ;;
