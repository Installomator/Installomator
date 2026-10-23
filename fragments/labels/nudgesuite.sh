nudgesuite)
    name="Nudge Suite"
    type="pkg"
    archiveName="Nudge_Suite-[0-9.]*.pkg"
    packageID="com.github.macadmins.Nudge.Suite"
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    appNewVersion=$(versionFromGit macadmins Nudge )
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( "Nudge" )
    ;;
