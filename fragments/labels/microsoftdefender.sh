microsoftdefender|\
microsoftdefenderatp)
    name="Microsoft Defender"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2097502"
    appNewVersion=$(curl -fs https://raw.githubusercontent.com/MicrosoftDocs/defender-docs/public/defender-endpoint/mac-whatsnew.md | grep -m 1 -o "Build: [0-9\.]*" | awk '{print $2}')
    # No version number in download url
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps WDAV00 )
    ;;
