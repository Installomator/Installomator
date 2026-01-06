apachenetbeans)
    name="Apache NetBeans"
    type="pkg"
    if [[ $(arch) = "arm64" ]]; then
        archiveName="Apache-NetBeans-[0-9]*-arm64.pkg"
    else
        archiveName="Apache-NetBeans-[0-9]*-x86_64.pkg"
    fi
    downloadURL="$(downloadURLFromGit Friends-of-Apache-NetBeans netbeans-installers)"
    appNewVersion="$(versionFromGit Friends-of-Apache-NetBeans netbeans-installers)"
    expectedTeamID="3KH8VFSK7Q"
    ;;
