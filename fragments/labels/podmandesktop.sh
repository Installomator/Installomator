podmandesktop)
    name="Podman Desktop"
    type="dmg"
    downloadURL=$(downloadURLFromGit containers podman-desktop)
    appNewVersion=$(versionFromGit containers podman-desktop)
    archiveName=" podman-desktop-$appNewVersion-universal.dmg"
    expectedTeamID="HYSCB8KRL2"
    ;;
