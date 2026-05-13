superwhisper)
    name="superwhisper"
    type="dmg"
    downloadURL="https://builds.superwhisper.com/latest/superwhisper.dmg"
    sparkleFeed=$(curl -fsL "https://superwhisper.com/appcast.xml")
    appNewVersion=$(echo $sparkleFeed | xpath 'string(//rss/channel/item[1]/sparkle:version)' 2>/dev/null)
    expectedTeamID="XDP69BYUP9"
    ;;
    