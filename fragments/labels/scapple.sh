scapple)
    name="Scapple"
    type="dmg"
    downloadURL="https://scrivener.s3.amazonaws.com/Scapple.dmg"
    appNewVersion="$(curl -fs "https://scrivener.s3.amazonaws.com/mac_updates/scapple.xml" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="W4QTL7X778"
    ;;
