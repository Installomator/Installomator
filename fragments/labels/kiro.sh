kiro)
    name="Kiro"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        kiroFeed=$(curl -fsL "https://prod.download.desktop.kiro.dev/stable/metadata-darwin-arm64-stable.json")
    elif [[ $(arch) == "i386" ]]; then
        kiroFeed=$(curl -fsL "https://prod.download.desktop.kiro.dev/stable/metadata-darwin-x64-stable.json")
    fi
    downloadURL=$(getJSONValue "$kiroFeed" "releases[0].updateTo.url")
    appNewVersion=$(getJSONValue "$kiroFeed" "releases[0].updateTo.version")
    expectedTeamID="94KV3E626L"
    ;;
