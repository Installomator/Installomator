magnolia)
    name="Magnolia"
    type="dmg"
    if [[ "$arch" == "arm64" ]]; then
        archiveName="Magnolia-mac-arm64\\.dmg"
    elif [[ "$arch" == "i386" ]]; then
        archiveName="Magnolia-mac-x64\\.dmg"
    fi
    downloadURL=$(downloadURLFromGit caledavis Magnolia)
    appNewVersion=$(versionFromGit caledavis Magnolia)
    expectedTeamID="DTRLLXT8T7"
    ;;
