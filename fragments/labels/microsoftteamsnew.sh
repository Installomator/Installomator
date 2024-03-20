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
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS21 ) # --wait 600 # TEAM01
    if [[ -x "${updateTool}" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        cmdResult=$(${updateTool} --list)
        printlog "msupdate output: $cmdResult" DEBUG
        if [[ -n $(echo $cmdResult | grep -i "XPC Connection to updater invalidated") ]]; then # -z "Checking for updates"
            printlog "msupdate resultet in error. Most likely PPPC profile is mising, see https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate. Disabling update tool" ERROR
            updateTool=""
            updateToolArguments=""
        elif [[ -n $(echo $cmdResult | grep -i "No updates available") ]]; then
            cleanupAndExit 0 "msupdate has no updates available" REQ
        fi
    fi
    ;;
