findanyfile)
    name="Find Any File"
    type="zip"
    downloadURL=$(curl -fs "https://findanyfile.app/appcast2.php" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    appNewVersion=$(curl -fs "https://findanyfile.app/appcast2.php" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="25856V4B4X"
    ;;
