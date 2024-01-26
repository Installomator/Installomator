microsoftonedrive)
    # This version match the Last Released Production version setting of OneDrive update channel. It’s default if no update channel setting for OneDrive updates has been specified. Enterprise (Deferred) is also supported with label “microsoftonedrive-deferred”.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=823060"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.onedrive.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps ONDR18 )
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
