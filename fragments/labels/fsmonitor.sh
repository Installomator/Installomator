fsmonitor)
    name="FSMonitor"
    type="zip"
    downloadURL=$(curl --location --fail --silent "https://fsmonitor.com/FSMonitor/Archives/appcast2.xml" | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="V85GBYB7B9"
    ;;
