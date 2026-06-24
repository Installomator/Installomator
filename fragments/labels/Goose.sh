goose)
    name="Goose"
    appName="Goose.app"
    type="zip"
    # Use Git tag for determinism, then pick the right macOS asset
    appNewVersion="$(versionFromGit block goose)"
    if [[ "$(uname -m)" == "arm64" ]]; then
        downloadURL="https://github.com/block/goose/releases/download/v${appNewVersion}/Goose.zip"
        archiveName="Goose.zip"
    else
        downloadURL="https://github.com/block/goose/releases/download/v${appNewVersion}/Goose_intel_mac.zip"
        archiveName="Goose_intel_mac.zip"
    fi
    expectedTeamID="EYF346PHUG"
    ;;
