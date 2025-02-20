microsoftteamsnew)
    name="Microsoft Teams"
    type="pkg"
    packageID="com.microsoft.teams2"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2249065"
    appNewVersion=$(curl -fsL "https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409TEAMS21.xml" | xmllint --xpath '//array/dict[1]/key[text()="Update Version"]/following-sibling::string[1]/text()' - 2>/dev/null)
    versionKey="CFBundleShortVersionString"
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
