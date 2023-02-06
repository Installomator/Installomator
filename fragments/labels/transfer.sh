transfer)
    name="Transfer"
    type="dmg"
    downloadURL="https://www.intuitibits.com/products/transfer/download"
    appNewVersion=$(curl -fs "https://www.intuitibits.com/appcasts/transfercast.xml" | xpath '(//rss/channel/item/sparkle:shortVersionString)[1]' 2>/dev/null | cut -d ">" -f2 | cut -d "<" -f1)
    expectedTeamID="2B9R362QNU"
    ;;
