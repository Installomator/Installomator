opencode)
    name="OpenCode"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="opencode-desktop-mac-arm64.dmg"
    else
        archiveName="opencode-desktop-mac-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit anomalyco opencode)
    appNewVersion=$(versionFromGit anomalyco opencode)
    expectedTeamID="5NZ4Q7NXJ4"
    ;;
