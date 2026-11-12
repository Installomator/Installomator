tropy)
    name="Tropy"
    type="dmg"
    appNewVersion=$(versionFromGit tropy tropy)
    if [[ $(arch) == "arm64" ]]; then
        archiveName="${appNewVersion}-arm64.dmg"
    else
        archiveName="${appNewVersion}.dmg"
    fi
    downloadURL=$(downloadURLFromGit tropy tropy)
    expectedTeamID="8LAYR367YV"
    ;;
