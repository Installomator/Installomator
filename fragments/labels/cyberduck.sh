cyberduck)
    name="Cyberduck"
    type="zip"
    changeLOG="$( curl -fs https://version.cyberduck.io/changelog.rss )"
    downloadURL=$( echo "$changeLOG" | xpath '//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
    appNewVersion=$( echo "$changeLOG" | xpath '//rss/channel/item/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2 )
    expectedTeamID="G69SCX94XU"
    ;;
