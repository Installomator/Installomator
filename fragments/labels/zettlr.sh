zettlr)
    name="Zettlr"
    type="dmg"
    appNewVersion=$(versionFromGit Zettlr Zettlr)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://github.com/Zettlr/Zettlr/releases/download/v${appNewVersion}/Zettlr-${appNewVersion}-arm64.dmg"
    else
        downloadURL="https://github.com/Zettlr/Zettlr/releases/download/v${appNewVersion}/Zettlr-${appNewVersion}-x64.dmg"
    fi
    expectedTeamID="QS52BN8W68"
    ;;
