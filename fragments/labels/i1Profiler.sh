i1profiler)
    name="i1Profiler"
    type="pkgInZip"
    downloadURL=$(curl -fs "https://downloads.xrite.com/downloads/autoupdate/i1profiler_mac_appcast.xml" | xmllint --xpath '//rss/channel/item[1]/enclosure/@url' - | sed -E 's/.*url="([^"]+)".*/\1/')
    appNewVersion=$(curl -fs "https://downloads.xrite.com/downloads/autoupdate/i1profiler_mac_appcast.xml" | xmllint --xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' - | sed -E 's/.*shortVersionString="([^"]+)".*/\1/')
    expectedTeamID="2K7GT73B4R"
    ;;
