netbird)
    name="NetBird"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="_darwin_arm64.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="_darwin_amd64.pkg"
    fi
    downloadURL=$(downloadURLFromGit netbirdio netbird)
    appNewVersion=$(versionFromGit netbirdio netbird)
    expectedTeamID="TA739QLA7A"
    ;;
