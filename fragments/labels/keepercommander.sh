keepercommander)
    name="Keeper Commander"
    type="pkg"
    appNewVersion="v$(versionFromGit Keeper-Security Commander)"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="keeper-commander-mac-arm64-${appNewVersion}.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="keeper-commander-mac-x86_64-${appNewVersion}.pkg"
    fi
    downloadURL="$(downloadURLFromGit Keeper-Security Commander)"
    expectedTeamID="234QNB7GCA"
    ;;
