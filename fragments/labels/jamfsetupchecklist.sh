jamfsetupchecklist)
    name="JAMF Setup Checklist"
    appName="Setup Checklist.app"
    type="pkg"
    downloadURL=$(downloadURLFromGit Jamf-Concepts Setup-Checklist)
    appNewVersion=$(versionFromGit Jamf-Concepts Setup-Checklist)
    expectedTeamID="483DWKW443"
    blockingProcesses=( "Setup Checklist" )
    ;;
