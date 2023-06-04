nudgesuite)
    name="Nudge Suite"
    appName="Nudge.app"
    type="pkg"
    archiveName="Nudge_Suite-[0-9.]*.pkg"
    appNewVersion=$(versionFromGit macadmins Nudge )
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( "Nudge" )
    ;;
