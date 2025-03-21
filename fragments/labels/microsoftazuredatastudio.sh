microsoftazuredatastudio|\
azuredatastudio)
    name="Azure Data Studio"
    type="zip"
    downloadURL=$( curl -sL https://github.com/microsoft/azuredatastudio/releases/latest | grep 'Universal' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | head -1 )
    appNewVersion=$(versionFromGit microsoft azuredatastudio )
    expectedTeamID="UBF8T346G9"
    ;;
