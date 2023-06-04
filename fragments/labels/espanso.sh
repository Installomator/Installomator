espanso)
    name="Espanso"
    type="zip"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="Espanso-Mac-M1.zip"
    else
        archiveName="Espanso-Mac-Intel.zip"
    fi
    downloadURL="$(downloadURLFromGit espanso espanso)"
    appNewVersion="$(versionFromGit espanso espanso)"
    blockingProcesses=( "Espanso" "espanso" )
    expectedTeamID="K839T4T5BY"
    ;;
