installomator|\
installomator_theile)
    name="Installomator"
    type="pkg"
    packageID="com.scriptingosx.Installomator"
    downloadURL=$(downloadURLFromGit Installomator Installomator )
    appNewVersion=$(versionFromGit Installomator Installomator )
    expectedTeamID="JME5BW3F3R"
    blockingProcesses=( NONE )
    ;;
