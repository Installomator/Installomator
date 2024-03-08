typeface)
    name="Typeface"
    type="dmg"
    downloadURL="https://dcdn.typefaceapp.com/latest"
    appNewVersion=$(curl -fs https://dcdn.typefaceapp.com/appcast.xml | xpath '//rss/channel/item[1]/sparkle:shortVersionString /text()' 2>/dev/null )
    expectedTeamID="X55SP58WS6"
    ;;
