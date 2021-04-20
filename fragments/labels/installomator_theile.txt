installomator_theile|\
installomator_st)
    # credit: Søren Theilgaard (@theilgaard)
    name="Installomator"
    type="pkg"
    packageID="dk.theilgaard.pkg.Installomator"
    downloadURL=$(downloadURLFromGit theile Installomator )
    appNewVersion=$(versionFromGit theile Installomator )
    expectedTeamID="L8W73B6AH3"
    blockingProcesses=( NONE )
    ;;
