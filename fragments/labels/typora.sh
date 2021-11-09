typora)
    name="Typora"
    type="dmg"
    #downloadURL="https://www.typora.io/download/Typora.dmg"
    downloadURL=$(curl -fs "https://www.typora.io/download/dev_update.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
    #appNewVersion="$(curl -fs "https://www.typora.io/dev_release.html" | grep -o -i "h4>[0-9.]*</h4" | head -1 | sed -E 's/.*h4>([0-9.]*)<\/h4.*/\1/')"
    appNewVersion=$(curl -fs "https://www.typora.io/download/dev_update.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="9HWK5273G4"
    ;;
