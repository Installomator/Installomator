nexusshell)
    name="Nexus Shell"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit viewer12 Nexus-Shell-Releases)
        appNewVersion=$(versionFromGit viewer12 Nexus-Shell-Releases)
    else
        printlog "Nexus Shell is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Nexus Shell requires Apple Silicon" ERROR
    fi
    expectedTeamID="5MBFAB57U2"
    ;;
