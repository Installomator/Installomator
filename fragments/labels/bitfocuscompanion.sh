bitfocuscompanion)
    name="Companion"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://api.bitfocus.io/v1/product/companion/packages?branch=stable&limit=5" | grep -o 'https://cf-pub.bitfocus.io/[^"]*' | grep 'mac-arm64' | head -1)
        appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*-mac-arm64-([0-9.]+)-.*/\1/')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL "https://api.bitfocus.io/v1/product/companion/packages?branch=stable&limit=5" | grep -o 'https://cf-pub.bitfocus.io/[^"]*' | grep 'mac-x64' | head -1)
        appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*-mac-x64-([0-9.]+)-.*/\1/')
    fi
    expectedTeamID="FGQ2G3HYBT"
    ;;
