munki)
    name="Munki"
    type="pkg"
    packageID="com.googlecode.munki.core"
    downloadURL=$(downloadURLFromGit "macadmins" "munki-builds")
    appNewVersion=$(versionFromGit "macadmins" "munki-builds")
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( NONE )
    ;;
