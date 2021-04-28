microsoftteams)
    name="Microsoft Teams"
    type="pkg"
    #packageID="com.microsoft.teams"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=869428"
    appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.teams.standalone"]/version' 2>/dev/null | sed -E 's/<version>([0-9.]*) .*/\1/')
    # Still using macadmin.software for version, as the path does not contain the version in a matching format. packageID can be used, but version is the same.
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams "Microsoft Teams Helper" )
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAM01 )
    ;;
