kiro)
    name="Kiro"
    type="dmg"
    appNewVersion=$(curl -fsL "https://kiro.dev/changelog/ide/" | grep -oE '0\.[0-9]+\.[0-9]+' | head -1)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://prod.download.desktop.kiro.dev/releases/stable/darwin-arm64/signed/${appNewVersion}/kiro-ide-${appNewVersion}-stable-darwin-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://prod.download.desktop.kiro.dev/releases/stable/darwin-x64/signed/${appNewVersion}/kiro-ide-${appNewVersion}-stable-darwin-x64.dmg"
    fi
    expectedTeamID="94KV3E626L"
    ;;
