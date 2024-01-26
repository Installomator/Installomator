microsoftcompanyportal)
    name="Company Portal"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869655"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.intunecompanyportal.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/CompanyPortal_.*pkg" | cut -d "_" -f 2 | cut -d "-" -f 1)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps IMCP01 )
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
