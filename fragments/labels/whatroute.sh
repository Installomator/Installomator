whatroute)
    name="WhatRoute"
    type="zip"
    downloadURL="$(curl -fs https://www.whatroute.net/whatroute2appcast.xml | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)"
    appNewVersion="$(curl -fs https://www.whatroute.net/whatroute2appcast.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)"
    expectedTeamID="H5879E8LML"
    ;;
