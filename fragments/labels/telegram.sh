telegram)
    name="Telegram"
    type="dmg"
    downloadURL="https://telegram.org/dl/macos"
    appNewVersion="$(curl -s "https://osx.telegram.org/updates/versions.xml" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="6N38VWS5BX"
    ;;
