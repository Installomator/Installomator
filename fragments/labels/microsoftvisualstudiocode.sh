microsoftvisualstudiocode|\
visualstudiocode)
    name="Visual Studio Code"
    type="zip"
    appNewVersion=$(curl -fsL "https://update.code.visualstudio.com/api/releases/stable" | plutil -extract 0 raw -o - -)
    downloadURL="https://update.code.visualstudio.com/latest/darwin-universal/stable"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( Code )
    ;;
