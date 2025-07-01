espanso)
    name="Espanso"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="Espanso-Mac-M1.dmg"
        type="dmg"
        downloadURL="$(downloadURLFromGit espanso espanso)"
        appNewVersion="$(versionFromGit espanso espanso)"
        expectedTeamID="6424323YUH"
    else
        type="zip"
        downloadURL="https://github.com/espanso/espanso/releases/download/v2.2.1/Espanso-Mac-Intel.zip"
        expectedTeamID="K839T4T5BY"
    fi
    ;;
