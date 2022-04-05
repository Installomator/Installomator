microsoftazuredatastudio|\
azuredatastudio)
    name="Azure Data Studio"
    type="zip"
    downloadURL=$( curl -sL https://github.com/microsoft/azuredatastudio/releases/latest | grep 'macOS ZIP' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" )
    appNewVersion=$(versionFromGit microsoft azuredatastudio )
    expectedTeamID="UBF8T346G9"
    appName="Azure Data Studio.app"
    blockingProcesses=( "Azure Data Studio" )
    ;;
