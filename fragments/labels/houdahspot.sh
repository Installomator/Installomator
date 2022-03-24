houdahspot)
    name="HoudahSpot"
    type="zip"
    downloadURL="$(curl -fs https://www.houdah.com/houdahSpot/updates/cast6.php | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs https://www.houdah.com/houdahSpot/updates/cast6.php | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    expectedTeamID="DKGQD8H8ZY"
    ;;
