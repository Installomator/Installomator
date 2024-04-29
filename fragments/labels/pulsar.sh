pulsar)
    name="Pulsar"
    type="zip"
    appNewVersion=$(versionFromGit pulsar-edit pulsar)
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        archiveName="Silicon.Mac.Pulsar-${appNewVersion}-arm64-mac.zip"
    else
        printlog "Architecture: i386 (not arm64)"
        archiveName="Intel.Mac.Pulsar-${appNewVersion}-mac.zip"
    fi
    downloadURL=$(downloadURLFromGit pulsar-edit pulsar)
    expectedTeamID="D3KV2P2CZ8"
    ;;

