apachenetbeans)
    name="Apache NetBeans"
    type="pkg"
    if [[ $(arch) = "arm64" ]]; then
        archiveName="Apache-NetBeans-[0-9]*-arm64.pkg"
    else
        archiveName="Apache-NetBeans-[0-9]*-x86_64.pkg"
    fi
    downloadURL="$(downloadURLFromGit Friends-of-Apache-NetBeans netbeans-installers)"
    appNewVersion=$(curl -sLI "https://github.com/Friends-of-Apache-NetBeans/netbeans-installers/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed -E 's/v([0-9]+).*/\1/')
    expectedTeamID="44YNN9Q525"
    ;;
