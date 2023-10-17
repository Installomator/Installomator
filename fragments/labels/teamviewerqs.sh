teamviewerqs)
    # credit: Søren Theilgaard (@theilgaard)
    name="TeamViewerQS"
    type="dmg"
    downloadURL="https://download.teamviewer.com/download/TeamViewerQS.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    appName="TeamViewerQS.app"
    expectedTeamID="H7UGFBUGV6"
    ;;
