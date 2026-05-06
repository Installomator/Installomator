podmandesktopairgap)
    name="Podman Desktop"
    type="dmg"
    appNewVersion=$(versionFromGit containers podman-desktop)
    if [[ $(arch) == "arm64" ]]; then
        archiveName="podman-desktop-airgap-$appNewVersion-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="podman-desktop-airgap-$appNewVersion-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit containers podman-desktop)
    expectedTeamID="HYSCB8KRL2"
    ;;
