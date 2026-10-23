diskdrill)
    name="Disk Drill"
    type="dmg"
    downloadURL="https://dl.cleverfiles.com/diskdrill.dmg"
    appNewVersion=$( curl -fsL "https://www.cleverfiles.com/releases/auto-update/dd5-newestr.xml" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)
    versionKey="CFBundleVersion"
    expectedTeamID="Z6C22PNU8R"
    ;;
