apachenetbeans)
    name="Apache NetBeans"
    type="pkg"
    if [[ "$arch" == "arm64" ]]; then
        archiveName="arm64.pkg"
    else
        archiveName="x86_64.pkg"
    fi
    downloadURL=$(downloadURLFromGit Friends-of-Apache-NetBeans netbeans-installers)
    appNewVersion=$(versionFromGit Friends-of-Apache-NetBeans netbeans-installers | sed -E 's/^v?([0-9]+).*/\1/')
    expectedTeamID="44YNN9Q525"
    ;;
