diskdrill)
    name="Disk Drill"
    type="dmg"
    appname="Disk Drill.app"
    downloadURL="https://dl.cleverfiles.com/diskdrill.dmg"
    appNewVersion=$( curl -fsL "https://www.cleverfiles.com/releases/auto-update/dd5-newestr.xml" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)
    expectedTeamID="A3W62KZY8Z"
    ;;
