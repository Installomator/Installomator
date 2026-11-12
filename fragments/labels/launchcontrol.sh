launchcontrol)
    name="LaunchControl"
    type="tbz"
    launchcontrolFeed="$(curl -fsL "https://www.soma-zone.com/LaunchControl/a/appcast-update-2.xml")"
    downloadURL="$(echo "${launchcontrolFeed}" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${launchcontrolFeed}" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="H665B6EEXC"
    ;;
