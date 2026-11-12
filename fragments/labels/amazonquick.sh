amazonquick)
    name="Amazon Quick"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(curl -fsSL "https://desktop.downloads.quick.aws.com/darwin/arm64/quick-external-cloud-mac.yml" | awk '/^version:/ {print $2; exit}')
        downloadURL="https://desktop.downloads.quick.aws.com/darwin/arm64/quick-external-cloud/Amazon%20Quick-${appNewVersion}-arm64.pkg"
    else
        printlog "Amazon Quick is only available from this vendor feed for Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Amazon Quick requires Apple Silicon" ERROR
    fi
    expectedTeamID="94KV3E626L"
    ;;
