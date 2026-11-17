dockersbx)
    name="Sbx"
    type="dmg"
    archiveName="DockerSandboxes-darwin.dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(downloadURLFromGit docker sbx-releases)"
    else
        printlog "Docker Sandboxes (Sbx) is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Sbx requires Apple Silicon" ERROR
    fi
    appNewVersion=$(versionFromGit docker sbx-releases)
    expectedTeamID="9BNSXJN65R"
    ;;
