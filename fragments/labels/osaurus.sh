osaurus)
    name="Osaurus"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(versionFromGit osaurus-ai osaurus)
        archiveName="Osaurus-${appNewVersion}.dmg"
        downloadURL=$(downloadURLFromGit osaurus-ai osaurus)
    else
        printlog "Osaurus is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Osaurus requires Apple Silicon" ERROR
    fi
    expectedTeamID="4W8QF9VR2F"
    blockingProcesses=( "osaurus" )
    ;;
