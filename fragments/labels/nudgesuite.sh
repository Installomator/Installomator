nudgesuite)
    name="Nudge Suite"
    appName="Nudge.app"
    type="pkg"
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    appNewVersion=$(versionFromGit macadmins Nudge )
    archiveName="Nudge-$appNewVersion.pkg"
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( "Nudge" )
    ;;
