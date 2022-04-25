duckduckgo)
    name="DuckDuckGo"
    type="dmg"
    #downloadURL="https://staticcdn.duckduckgo.com/macos-desktop-browser/duckduckgo.dmg"
    downloadURL=$(curl -fs https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast.xml | xpath '(//rss/channel/item/enclosure/@url)[last()]' 2>/dev/null | cut -d '"' -f2)
    appNewVersion=$(curl -fs https://staticcdn.duckduckgo.com/macos-desktop-browser/appcast.xml | xpath '(//rss/channel/item/enclosure/@sparkle:version)[last()]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="HKE973VLUW"
    ;;
