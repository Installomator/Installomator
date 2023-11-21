microsoftteamsnew)
    name="Microsoft Teams (work or school)"
    type="pkg"
    #packageID="com.microsoft.teams2"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2249065"
    #appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | tail -1 | cut -d "/" -f5)
    # No version in download path, so grab it from homepage
    appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.teams2.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    #versionKey="CFBundleGetInfoString"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( MSTeams "Microsoft Teams" "Microsoft Teams WebView" "Microsoft Teams Launcher" "Microsoft Teams (work preview)")
    # msupdate requires a PPPC profile pushed out from Jamf to work, https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS21 ) # --wait 600 # TEAM01
    ;;
