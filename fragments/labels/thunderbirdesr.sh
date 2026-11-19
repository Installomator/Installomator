thunderbirdesr)
    name="Thunderbird"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    downloadURL=$(curl -fsL https://www.thunderbird.net/notes/ | sed -n "/'esr':/,/'release':/p" | grep -o "https://[^']*os=osx[^']*")
    appNewVersion=$(echo $downloadURL | grep -oE '[0-9]+(\.[0-9]+)+')
    expectedTeamID="43AQ936H96"
    ;;
