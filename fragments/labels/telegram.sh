telegram)
    name="Telegram"
    type="dmg"
    telegramFeed="$(curl -fs "https://osx.telegram.org/updates/versions.xml")"
    appNewVersion="$(echo "$telegramFeed" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    telegramBuild="$(echo "$telegramFeed" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:version)' 2>/dev/null)"
    downloadURL="https://osx.telegram.org/updates/Telegram-${appNewVersion}.${telegramBuild}.dmg"
    expectedTeamID="6N38VWS5BX"
    ;;
