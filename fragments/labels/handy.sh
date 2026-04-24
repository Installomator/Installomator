handy)
    # Handy - A free, open source, and extensible speech-to-text application
    # https://github.com/cjpais/Handy
    name="Handy"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit "cjpais" "Handy")
        appNewVersion=$(versionFromGit "cjpais" "Handy")
    else
        archiveName="x64.dmg"
        downloadURL=$(downloadURLFromGit "cjpais" "Handy")
        appNewVersion=$(versionFromGit "cjpais" "Handy")
    fi
    expectedTeamID="UWFLB4GC25"
    ;;
