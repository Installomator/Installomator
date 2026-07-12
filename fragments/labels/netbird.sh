netbird)
    name="NetBird"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        dURL="https://pkgs.netbird.io/macos/arm64"
    elif [[ $(arch) == "i386" ]]; then
        dURL="https://pkgs.netbird.io/macos/amd64"
    fi
    downloadURL=$dURL
    appNewVersion=$(curl -LsI $downloadURL -o /dev/null -w '%{url_effective}' | grep -oE "\d+\.\d+\.\d+")
    expectedTeamID="TA739QLA7A"
    ;;
