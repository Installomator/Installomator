nextcloud)
    name="nextcloud"
    type="pkg"
    #packageID="com.nextcloud.desktopclient"
    downloadURL=$(downloadURLFromGit nextcloud-releases desktop)
    appNewVersion=$(versionFromGit nextcloud-releases desktop)
    # The version of the app is not equal to the version listed on GitHub.
    # App version something like "3.1.3git (build 4850)" but web page lists as "3.1.3"
    # Also it does not math packageID version "3.1.34850"
    appCustomVersion(){defaults read /Applications/nextcloud.app/Contents/Info.plist CFBundleShortVersionString | sed -E 's/^([0-9.]*)git.*/\1/g'}
    expectedTeamID="NKUJUXUJ3B"
    ;;
