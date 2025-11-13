anki)
#This is just the launcher and the version can be chosen from within the launcher.
    name="Anki"
    type="dmg"
    appNewVersion=$(curl -sLI "https://github.com/ankitects/anki/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g' | cut -d "." -f 1-2)
    downloadURL="https://github.com/ankitects/anki/releases/download/$appNewVersion/anki-launcher-$appNewVersion-mac.dmg"
    expectedTeamID="7ZM8SLJM4P"
    ;;
