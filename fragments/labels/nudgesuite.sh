nudgesuite)
    name="Nudge Suite"
    appName="Nudge.app"
    type="pkg"
    archiveName="Nudge_Suite-[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit macadmins Nudge )
    appNewVersion=$(versionFromGit macadmins Nudge )
    expectedTeamID="9GQZ7KUFR6"
    blockingProcesses=( "Nudge" )
    ;;
