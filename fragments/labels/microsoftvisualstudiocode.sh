microsoftvisualstudiocode|\
visualstudiocode)
    name="Visual Studio Code"
    type="zip"
    appNewVersion=$(curl -s https://update.code.visualstudio.com/api/update/darwin-arm64/stable/latest | sed -n 's/.*"name": *"\([^"]*\)".*/\1/p')
    downloadURL="https://update.code.visualstudio.com/${appNewVersion}/darwin-universal/stable" # Universal
    expectedTeamID="UBF8T346G9"
    appName="Visual Studio Code.app"
    blockingProcesses=( Code )
    ;;
