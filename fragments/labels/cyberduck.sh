cyberduck)
    name="Cyberduck"
    type="zip"
    changeLOG="$( curl -fs https://version.cyberduck.io/changelog.rss )"
    downloadURL=$( echo "$changeLOG" | sed 's/sparkle://g' | xmllint --xpath 'string(//item/enclosure/@url)' - 2>/dev/null)
    appNewVersion=$( echo "$changeLOG" | sed 's/sparkle://g' | xmllint --xpath 'string(//item/enclosure/@shortVersionString)' - 2>/dev/null)
    expectedTeamID="G69SCX94XU"
    ;;
