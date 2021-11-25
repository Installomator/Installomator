microsoftdefenderatp)
    name="Microsoft Defender ATP"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2097502"
    appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.defender.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    # No version number in download url
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps WDAV00 )
    ;;
