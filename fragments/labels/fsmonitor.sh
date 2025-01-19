fsmonitor)
    name="FSMonitor"
    type="zip"
    downloadURL=$(curl -fsL "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath 'string(//rss/channel/item[last()]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(curl -fsL "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="V85GBYB7B9"
    ;;
