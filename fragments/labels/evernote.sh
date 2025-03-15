evernote)
    name="Evernote"
    type="dmg"
    downloadURL="https://mac.desktop.evernote.com/builds/Evernote-latest.dmg"
    appNewVersion=$(curl -s https://evernote.com/release-notes | grep Latest | awk -F '<!-- -->' '{print $2}')
    expectedTeamID="Q79WDW8YH9"
    ;;
