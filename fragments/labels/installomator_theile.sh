installomator_theile)
    # credit: Søren Theilgaard (@theilgaard)
    name="Installomator"
    type="pkg"
    packageID="dk.theilgaard.pkg.Installomator"
    downloadURL=$(downloadURLFromGit theile Installomator )
    appNewVersion=$(versionFromGit theile Installomator )
    #appCustomVersion(){/usr/local/bin/Installomator.sh version | tail -1 | awk '{print $4}'}
    expectedTeamID="FXW6QXBFW5"
    blockingProcesses=( NONE )
    ;;
