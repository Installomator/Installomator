podmandesktop)
    name="Podman Desktop"
    type="dmg"
    appNewVersion=$(versionFromGit containers podman-desktop)
    archiveName="podman-desktop-$appNewVersion-universal.dmg"
    downloadURL=$(downloadURLFromGit containers podman-desktop)
    expectedTeamID="HYSCB8KRL2"
    ;;
