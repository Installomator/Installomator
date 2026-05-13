podman)
    name="Podman"
    type="pkg"
    archiveName="podman-installer-macos-universal.pkg"
    downloadURL=$(downloadURLFromGit containers podman)
    appNewVersion=$(versionFromGit containers podman)
    expectedTeamID="HYSCB8KRL2"
    ;;
