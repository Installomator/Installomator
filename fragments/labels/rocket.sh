rocket)
    name="Rocket"
    type="dmg"
    rocketFeed=$(curl -fsL "https://macrelease.matthewpalmer.net/distribution/appcasts/rocket.xml")
    appNewVersion=$(echo "${rocketFeed}" | xpath 'string(//rss/channel/item[last()]/title)' 2>/dev/null)
    downloadURL=$(echo "${rocketFeed}" | xpath 'string(//rss/channel/item[last()]/enclosure/@url)' 2>/dev/null)
    expectedTeamID="Z4JV2M65MH"
    ;;
