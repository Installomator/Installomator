awdlguard)
    name="AWDL Guard"
    type="pkg"
    packageID="io.github.moragabriele.awdlguard.pkg"
    archiveName="AWDLGuard-[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit moragabriele awdl-guard)
    appNewVersion=$(versionFromGit moragabriele awdl-guard)
    expectedTeamID="9WCXJSYTFT"
    blockingProcesses=( NONE )
    ;;
