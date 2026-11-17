headlamp)
    name="Headlamp"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="mac-arm64.dmg"
    else
        archiveName="mac-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit kubernetes-sigs headlamp)
    appNewVersion=$(versionFromGit kubernetes-sigs headlamp)
    expectedTeamID="5N2JF58U87"
    ;;
