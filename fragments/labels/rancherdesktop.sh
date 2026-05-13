rancherdesktop)
    name="Rancher Desktop"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
      archiveName="Rancher.Desktop-[0-9.]*-mac.aarch64.zip"
      downloadURL="$(downloadURLFromGit rancher-sandbox rancher-desktop)"
    elif [[ $(arch) == "i386" ]]; then
      archiveName="Rancher.Desktop-[0-9.]*-mac.x86_64.zip"
      downloadURL="$(downloadURLFromGit rancher-sandbox rancher-desktop)"
    fi
    appNewVersion="$(versionFromGit rancher-sandbox rancher-desktop)"
    expectedTeamID="2Q6FHJR3H3"
    ;;
