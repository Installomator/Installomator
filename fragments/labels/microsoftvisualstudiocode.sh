microsoftvisualstudiocode|\
visualstudiocode)
    name="Visual Studio Code"
    type="zip"
    appNewVersion=$(curl -fsL "https://update.code.visualstudio.com/api/releases/stable" \
        | tr ',' '\n' \
        | head -1 \
        | tr -d '["')
    downloadURL="https://update.code.visualstudio.com/latest/darwin-universal/stable"
    expectedTeamID="UBF8T346G9"
    appName="Visual Studio Code.app"
    blockingProcesses=( Code )
    ;;
