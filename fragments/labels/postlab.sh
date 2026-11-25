postlab)
    name="PostLab"
    type="pkgInDmg"
    postlabFeed=$(curl -fsL "https://updates.hedge.video/postlab/macos/appcast/postlab-prod.xml")
    downloadURL=$(echo "$postlabFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$postlabFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    packageID="video.hedge.PostLab.Mac"
    expectedTeamID="A43D9X8EYU"
    ;;
