podmandesktopairgap)
    name="Podman Desktop"
    type="dmg"
    downloadURL=$(downloadURLFromGit containers podman-desktop)
    appNewVersion=$(versionFromGit containers podman-desktop)
    if [[ $(arch) == "arm64" ]]; then
        archiveName="podman-desktop-airgap-$appNewVersion-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="podman-desktop-airgap-$appNewVersion-x64.dmg"
    fi
    expectedTeamID="HYSCB8KRL2"
    ;;
