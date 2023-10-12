microsoftteamsclassic|\
microsoftteams)
    name="Microsoft Teams classic"
    type="pkg"
    #packageID="com.microsoft.teams"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869428"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | tail -1 | cut -d "/" -f5)
    versionKey="CFBundleGetInfoString"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams "Microsoft Teams classic Helper" )
    # msupdate requires a PPPC profile pushed out from Jamf to work, https://github.com/pbowden-msft/MobileConfigs/tree/master/Jamf-MSUpdate
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS10 ) # --wait 600 #TEAM01
    ;;
