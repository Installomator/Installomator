pulsar)
    name="Pulsar"
    type="zip"
    appNewVersion=$(versionFromGit pulsar-edit pulsar)
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        downloadURL="https://github.com/pulsar-edit/pulsar/releases/download/v${appNewVersion}/Silicon.Mac.Pulsar-${appNewVersion}-arm64-mac.zip"
        archiveName="Silicon.Mac.Pulsar-${appNewVersion}-arm64-mac.zip"
    else
        printlog "Architecture: i386 (not arm64)"
        downloadURL="https://github.com/pulsar-edit/pulsar/releases/download/v${appNewVersion}/Intel.Mac.Pulsar-${appNewVersion}-mac.zip"
        archiveName="Intel.Mac.Pulsar-${appNewVersion}-mac.zip"
    fi
    expectedTeamID="D3KV2P2CZ8"
    ;;

