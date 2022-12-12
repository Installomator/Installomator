microsoftedge|\
microsoftedgeconsumerstable|\
microsoftedgeenterprisestable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2093504"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.edge"]/cfbundleversion' 2>/dev/null | sed -E 's/<cfbundleversion>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdge.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps EDGE01 )
    ;;
