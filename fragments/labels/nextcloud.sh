nextcloud)
    name="nextcloud"
    type="pkg"
    #packageID="com.nextcloud.desktopclient"
    downloadURL=$(downloadURLFromGit nextcloud desktop)
    #appNewVersion=$(versionFromGit nextcloud desktop)
    # The version of the app is not equal to the version listed on GitHub.
    # App version something like "3.1.3git (build 4850)" but web page lists as "3.1.3"
    # Also it does not math packageID version "3.1.34850"
    expectedTeamID="NKUJUXUJ3B"
    ;;
