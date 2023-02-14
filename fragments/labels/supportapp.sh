supportapp)
    name="Support"
    type="pkg"
    packageID="nl.root3.support"
    downloadURL=$(downloadURLFromGit root3nl SupportApp)
    appNewVersion=$(versionFromGit root3nl SupportApp)
    expectedTeamID="98LJ4XBGYK"
    uid=$(id -u "$currentUser")
    launchctl bootout gui/${uid} "/Library/LaunchAgents/nl.root3.support.plist"
    ;;
