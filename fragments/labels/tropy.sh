tropy)
    name="Tropy"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="tropy-[0-9.]*-arm64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="tropy-[0-9.]*.dmg"
    fi
    appNewVersion="$(versionFromGit tropy tropy)"
    downloadURL="$(downloadURLFromGit tropy tropy)"
    expectedTeamID="8LAYR367YV"
    ;;
