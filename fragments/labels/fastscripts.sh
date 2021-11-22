fastscripts)
    name="FastScripts"
    type="zip"
    downloadURL=$( curl -fs "https://redsweater.com/fastscripts/appcast3.php" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2 )
    appNewVersion=$( curl -fs "https://redsweater.com/fastscripts/appcast3.php" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2 )
    expectedTeamID="493CVA9A35"
    ;;
