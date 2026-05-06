duckduckgo)
    name="DuckDuckGo"
    type="dmg"
    appNewVersion=$(curl -fsL "https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast2.xml" | xpath '(//rss/channel/item/sparkle:shortVersionString/text())' | head -1)
    downloadURL=$(curl -fsL "https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast2.xml" | xpath '(//rss/channel/item/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 | head -1)
    expectedTeamID="HKE973VLUW"
    ;;
