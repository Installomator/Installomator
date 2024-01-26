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
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS10 ) # --wait 600 #TEAM01
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
