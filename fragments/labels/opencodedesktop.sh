opencodedesktop)
    name="OpenCode"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="mac-arm64\.dmg$"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="mac-x64\.dmg$"
    fi
    downloadURL=$(downloadURLFromGit "anomalyco" "opencode")
    appNewVersion=$(versionFromGit "anomalyco" "opencode")
    expectedTeamID="5NZ4Q7NXJ4"
    ;;
