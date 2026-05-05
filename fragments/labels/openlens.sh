openlens)
    name="OpenLens"
    if [[ $(arch) == "arm64" ]]; then
        type="dmg"
        archiveName="OpenLens-[0-9.-]*-arm64.dmg"
    else
        type="zip"
        archiveName="OpenLens-[0-9.-]*-mac.zip"
    fi
    downloadURL="$(downloadURLFromGit MuhammedKalkan OpenLens)"
    appNewVersion="$(versionFromGit MuhammedKalkan OpenLens)"
    expectedTeamID="HGC72W36QJ"
    ;;
