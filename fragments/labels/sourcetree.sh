sourcetree)
    name="Sourcetree"
    type="zip"
    atlassianDetails="$(curl -fs "https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcast.xml")"
    appNewVersion="$(echo "${atlassianDetails}"| xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    downloadURL="$(echo "${atlassianDetails}"| xpath 'string(//rss/channel/item[last()]/enclosure/@url)' 2>/dev/null)"
    expectedTeamID="UPXU4CQZ5P"
    ;;
