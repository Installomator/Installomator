egnytecore)
    name="Egnyte Core"
    appName="Egnyte.app"
    type="dmg"
    downloadURL=$(curl -fs "https://egnyte-cdn.egnyte.com/desktopapp/mac/en-us/versions/default.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://egnyte-cdn.egnyte.com/desktopapp/mac/en-us/versions/default.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="FELUD555VC"
    blockingProcesses=( Egnyte )
    ;;
