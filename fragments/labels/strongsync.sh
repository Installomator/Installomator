strongsync)
    name="Strongsync"
    type="dmg"
    #downloadURL="https://updates.expandrive.com/apps/strongsync/download_latest"
    downloadURL=$(curl -fs "https://updates.expandrive.com/appcast/strongsync.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://updates.expandrive.com/appcast/strongsync.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    versionKey="CFBundleVersion"
    expectedTeamID="CH86M498V4"
    ;;
