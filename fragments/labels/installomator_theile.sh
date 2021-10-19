installomator_theile)
    name="Installomator"
    type="pkg"
    packageID="dk.theilgaard.pkg.Installomator"
    downloadURL=$(downloadURLFromGit theile Installomator )
    appNewVersion=$(versionFromGit theile Installomator )
    expectedTeamID="FXW6QXBFW5"
    blockingProcesses=( NONE )
    ;;
