antconc)
    name="AntConc"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        antConcData=$(curl -fsL "https://www.laurenceanthony.net/software/antconc/releases/latest_version.json")
        downloadURL=$(getJSONValue "$antConcData" "platforms.macos_silicon.url")
        appNewVersion=$(getJSONValue "$antConcData" "version")
    else
        printlog "AntConc is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "AntConc requires Apple Silicon" ERROR
    fi
    expectedTeamID="28C42U4N5U"
    ;;
