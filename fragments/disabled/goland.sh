goland)
    name="GoLand"
    type="dmg"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=release" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download-cdn.jetbrains.com/go/goland-${appNewVersion}-aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download-cdn.jetbrains.com/go/goland-${appNewVersion}.dmg"
    fi
    expectedTeamID="2ZEFAR8TH3"
    ;;
