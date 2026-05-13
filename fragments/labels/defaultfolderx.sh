defaultfolderx)
    name="Default Folder X"
    type="dmg"
    sparkleFeed="$(curl -fsL "https://www.stclairsoft.com/cgi-bin/sparkle.cgi?DX5")"
    downloadURL="$(echo $sparkleFeed | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo $sparkleFeed | xpath 'string(//rss/channel/item/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="7HK42V8R9D"
    ;;
