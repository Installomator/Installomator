jumpdesktop)
    name="Jump Desktop"
    type="zip"
    downloadURL=$(curl -fsL "https://mirror.jumpdesktop.com/downloads/jdm/jdmac-web-appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://mirror.jumpdesktop.com/downloads/jdm/jdmac-web-appcast.xml" | grep sparkle:shortVersionString | tr ',' '\n' | grep sparkle:shortVersionString | cut -d '"' -f 2)
    expectedTeamID="2HCKV38EEC"
    ;;
