fork)
    name="Fork"
    type="dmg"
    downloadURL="$(curl -fs "https://git-fork.com/update/feed.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs "https://git-fork.com/update/feed.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)"
    expectedTeamID="Q6M7LEEA66"
    ;;
