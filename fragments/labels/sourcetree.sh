sourcetree)
    name="Sourcetree"
    type="zip"
    downloadURL=$(curl -fs https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcastAlpha.xml \
        | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null \
        | cut -d '"' -f 2 )
    appNewVersion=$(curl -fs https://product-downloads.atlassian.com/software/sourcetree/Appcast/SparkleAppcastAlpha.xml | xpath '//rss/channel/item[last()]/title' 2>/dev/null | sed -n -e 's/^.*Version //p' | sed 's/\<\/title\>//' | sed $'s/[^[:print:]	]//g')
    expectedTeamID="UPXU4CQZ5P"
    ;;
