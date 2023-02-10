selfcontrol)
    name="SelfControl"
    type="zip"
    downloadURL=$(curl -fs https://update.selfcontrolapp.com/feeds/selfcontrol | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://update.selfcontrolapp.com/feeds/selfcontrol | xpath '//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString' 2>/dev/null | tr " " "\n" | sort | tail -1 | cut -d '"' -f 2)
    expectedTeamID="EG6ZYP3AQH"
    ;;
