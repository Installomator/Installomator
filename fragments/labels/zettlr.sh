zettlr)
    name="Zettlr"
    type="dmg"
    appNewVersion="$(versionFromGit Zettlr Zettlr)"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Zettlr-${appNewVersion}-arm64.dmg"
    else
        archiveName="Zettlr-${appNewVersion}-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit Zettlr Zettlr)"
    expectedTeamID="QS52BN8W68"
    ;;
