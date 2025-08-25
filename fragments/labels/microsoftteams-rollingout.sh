microsoftteams-rollingout)
    name="Microsoft Teams"
    type="pkg"
    packageID="com.microsoft.teams2"
    # Fetch the latest version number from the Microsoft documentation page
    appNewVersion=$(curl -s https://learn.microsoft.com/en-us/officeupdates/teams-app-versioning | awk '/<h4 id="mac">Mac<\/h4>/,/<\/table>/' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    downloadURL="https://statics.teams.cdn.office.net/production-osx/${appNewVersion}/MicrosoftTeams.pkg"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams MSTeams "Microsoft Teams" "Microsoft Teams WebView" "Microsoft Teams WebView Helper" "Microsoft Teams Launcher" "Microsoft Teams (work preview)" "Microsoft Teams classic Helper" "com.microsoft.teams2.respawn")
    # msupdate requires a PPPC profile pushed out from Jamf to work, https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS21 ) # --wait 600
    ;;
