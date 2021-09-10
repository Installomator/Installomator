jetbrainsdatagrip)
    name="DataGrip"
    type="dmg"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=release" | grep -o 'macM1*.*,' | cut -d '"' -f5)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=release" | grep -o 'mac*.*,' | cut -d '"' -f5)
    fi
    expectedTeamID="2ZEFAR8TH3"
    ;;