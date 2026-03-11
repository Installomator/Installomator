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
        downloadURL=""
        appNewVersion=""
    fi
    expectedTeamID="UWFLB4GC25"
    ;;
