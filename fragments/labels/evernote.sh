evernote)
    name="Evernote"
    type="dmg"
    downloadURL=$(curl -fs "https://evernote.com/download" | grep -E -o 'https?://[^[:space:]]+\.dmg' )
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="Q79WDW8YH9"
    appName="Evernote.app"
    ;;
