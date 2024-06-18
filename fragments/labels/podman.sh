podman)
    name="Podman"
    type="pkg"
    downloadURL=$(downloadURLFromGit containers podman)
    appNewVersion=$(versionFromGit containers podman)
    archiveName="podman-installer-macos-universal.pkg"
    expectedTeamID="HYSCB8KRL2"
    ;;
