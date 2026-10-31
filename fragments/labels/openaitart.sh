openaitart)
    name="Tart"
    type="tbz"
    archiveName="tart.tar.gz"
    appName="tart.app"
    downloadURL=$(downloadURLFromGit "openai" "tart")
    appNewVersion=$(versionFromGit "openai" "tart")
    expectedTeamID="9M2P8L4D89"
    blockingProcesses=( "tart" )
    ;;
