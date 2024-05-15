mountainduck)
    name="Mountain Duck"
    type="zip"
    downloadURL=$(curl -fs https://version.mountainduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs https://version.mountainduck.io/changelog.rss | xpath '//rss/channel/item/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="G69SCX94XU"
    ;;
