betterzip)
    name="BetterZip"
    type="zip"
    sparkleData=$(curl -fsL "https://macitbetter.com/BetterZip6.rss")
    appNewVersion=$(echo "$sparkleData" | xpath 'string((//*[local-name()="item"])[1]/*[local-name()="enclosure"]/@*[local-name()="shortVersionString"])' 2>/dev/null)
    downloadURL=$(echo "$sparkleData" | xpath 'string((//*[local-name()="item"])[1]/*[local-name()="enclosure"]/@url)' 2>/dev/null)
    expectedTeamID="79RR9LPM2N"
    ;;
