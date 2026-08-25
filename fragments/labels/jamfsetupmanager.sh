jamfsetupmanager)
    name="Setup Manager"
    type="pkg"
    downloadURL=$(downloadURLFromGit jamf Setup-Manager)
    appNewVersion=$(versionFromGit jamf Setup-Manager)
    expectedTeamID="483DWKW443"
    ;;
