microsoftteams)
    name="Microsoft Teams"
    type="pkg"
    packageID="com.microsoft.teams"
    downloadURL=$(curl -fs https://teams.microsoft.com/desktopclient/installer/osx)
    appNewVersion=$(echo ${downloadURL} | egrep -o '([0-9]+\.?){1,4}')
    # Looks like macadmin.software has package ID version. At least on 202105-28 version 1.00.411161 is matched on installed version and homepage.
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Teams "Microsoft Teams Helper" )
    blockingProcessesAltName=( [Teams]="Microsoft Teams")
    # Commenting out msupdate as it is not really supported *yet* for teams
    # updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate --list; /Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    # updateToolArguments=( --install --apps TEAM01 )
    ;;
