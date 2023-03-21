nudgesuite)
    name="Nudge Suite"
    appName="Nudge.app"
    type="pkg"
    appNewVersion=$(versionFromGit macadmins Nudge )
    archiveName="Nudge_Suite-$appNewVersion.pkg"
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( "Nudge" )
    ;;
