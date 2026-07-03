anki)
    name="Anki"
    type="dmg"
    appNewVersion=$(curl -fs "https://apps.ankiweb.net" | grep -o '/download/[0-9.]\+/' | head -1 | sed 's|/download/||;s|/||')
    downloadURL="https://github.com/ankitects/anki/releases/download/${appNewVersion}/anki-launcher-${appNewVersion}-mac.dmg"
    expectedTeamID="7ZM8SLJM4P"
    ;;
