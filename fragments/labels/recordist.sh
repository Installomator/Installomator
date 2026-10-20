recordist)
    name="Recordist"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://recordist.app/get/mac/latest?from=mdm"
        appNewVersion=$(getJSONValue "$(curl -fsL "https://recordist.app/get/mac/info")" "version")
    else
        printlog "Recordist requires a Mac with Apple silicon." ERROR
        cleanupAndExit 95 "Recordist requires Apple silicon" ERROR
    fi
    blockingProcesses=( "recordist" )
    expectedTeamID="JNC57WQK69"
    ;;
