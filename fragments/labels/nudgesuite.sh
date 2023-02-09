nudgesuite)
    name="Nudge Suite"
    appName="Nudge.app"
    type="pkg"
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    appNewVersion=$(versionFromGit macadmins Nudge )
    archiveName="Nudge_Suite-$appNewVersion.pkg"
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( "Nudge" )
    ;;
