zed)
    name="Zed"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Zed-aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="Zed-x86_64.dmg"
    fi
    downloadURL="$(downloadURLFromGit zed-industries zed)"
    appNewVersion="$(versionFromGit zed-industries zed)"
    expectedTeamID="MQ55VZLNZQ"
    ;;
