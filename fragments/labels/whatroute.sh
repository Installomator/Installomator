whatroute)
    name="WhatRoute"
    type="zip"
    downloadURL="$(curl -fs https://www.whatroute.net/whatroute2appcast.xml | xpath '(//rss/channel/item/enclosure/@url)' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs "https://www.whatroute.net/whatroute2appcast.xml" | xpath '(//rss/channel/item/sparkle:shortVersionString)' 2>/dev/null | cut -d ">" -f2 | cut -d "<" -f1)"
    expectedTeamID="H5879E8LML"
    ;;
