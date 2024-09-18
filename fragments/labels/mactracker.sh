mactracker)
    name="Mactracker"
    type="zip"
    #downloadURL=$(curl -fs "https://mactracker.ca/releasenotes-mac.html" | grep "Mactracker_" | sed "s|.*href=\"\(.*\)\">Download for macOS.*|\\1|")
    downloadURL=$(curl -fs "https://update.mactracker.ca/appcast-b.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://update.mactracker.ca/appcast-b.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="63TP32R3AB"
    ;;
