snagit|\
snagit2024)
    name="Snagit 2024"
    type="dmg"
    sparkleData=$(curl -fsL 'https://www.techsmith.com/redirect.asp?target=sufeedurl&product=snagitmac&ver=2024.0.0&lang=enu&os=mac')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item[last()]/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item[last()]/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
