sysexlibrarian)
    name="SysEx Librarian"
    type="dmg"
    downloadURL="https://www.snoize.com/SysExLibrarian/SysExLibrarian.dmg"
    appNewVersion=$(curl -fs "https://www.snoize.com/SysExLibrarian/SysExLibrarian.xml" | xpath 'string(//rss/channel/item[1]/sparkle:version)' 2>/dev/null)
    expectedTeamID="YDJAW5GX9U"
    ;;
