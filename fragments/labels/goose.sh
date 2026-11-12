goose)
    name="Goose"
    type="zip"
    appNewVersion=$(versionFromGit aaif-goose goose)
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Goose.zip"
    else
        archiveName="Goose_intel_mac.zip"
    fi
    downloadURL=$(downloadURLFromGit aaif-goose goose)
    expectedTeamID="5N2JF58U87"
    ;;
