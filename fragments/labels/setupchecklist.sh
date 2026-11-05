setupchecklist)
    name="Setup Checklist"
    type="pkg"
    packageID="com.jamf.setupchecklist"
    downloadURL=$(downloadURLFromGit Jamf-Concepts Setup-Checklist)
    appNewVersion=$(versionFromGit Jamf-Concepts Setup-Checklist)
    expectedTeamID="483DWKW443"
    blockingProcesses=( NONE )
    ;;
