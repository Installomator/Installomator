evernote)
    name="Evernote"
    type="dmg"
    downloadURL="https://mac.desktop.evernote.com/builds/Evernote-latest.dmg"
    appNewVersion=$(curl -fs https://evernote.com/release-notes | sed -En 's/.*Version ([0-9.]+) - Latest.*/\1/p')
    expectedTeamID="Q79WDW8YH9"
    ;;
