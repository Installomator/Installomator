mattermost)
    name="Mattermost"
    type="dmg"
    archiveName="mac-universal.dmg"
    downloadURL=$(downloadURLFromGit mattermost desktop)
    appNewVersion=$(versionFromGit mattermost desktop)
    expectedTeamID="UQ8HT4Q2XM"
    blockingProcesses=( "Mattermost Helper.app" "Mattermost Helper (Renderer).app" "Mattermost Helper (GPU).app" "Mattermost Helper (Plugin).app" )
    ;;
