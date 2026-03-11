handy)
    # Handy - A free, open source, and extensible speech-to-text application
    # https://github.com/cjpais/Handy
    name="Handy"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit "cjpais" "Handy")
        appNewVersion=$(versionFromGit "cjpais" "Handy")
    else
        # Handy is only available for Apple Silicon (arm64) Macs
        printlog "Handy is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 1 "Handy requires Apple Silicon" ERROR
    fi
    expectedTeamID="UWFLB4GC25"
    ;;
