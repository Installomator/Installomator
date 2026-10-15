localwp)
    name="LocalWP"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://cdn.localwp.com/stable/latest/mac-arm64"
    else
        downloadURL="https://cdn.localwp.com/stable/latest/mac"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | tail -1 | sed -E 's/.*releases-stable\/([0-9.]+)(\+|%2B).*/\1/')
    expectedTeamID="UZR22399D3"
    appName="Local.app"
    ;;
