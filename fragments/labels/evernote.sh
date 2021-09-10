evernote)
    name="Evernote"
    type="dmg"
    downloadURL=$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15)" "https://evernote.com/download" | grep -i ".dmg" | cut -d '"' -f2)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="Q79WDW8YH9"
    appName="Evernote.app"
    ;;
