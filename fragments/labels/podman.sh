podman)
    name="Podman"
    type="pkg"
    packageID="com.redhat.podman"
    expectedTeamID="HYSCB8KRL2"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="podman-installer-macos-arm64.pkg"
        downloadURL=$(downloadURLFromGit podman-container-tools podman)
        appNewVersion=$(versionFromGit podman-container-tools podman)
    elif [[ $(arch) == "i386" ]]; then
        printlog "Podman 6.0+ requires Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Podman 6.0+ requires Apple Silicon (arm64) Macs." ERROR
    fi
    ;;
