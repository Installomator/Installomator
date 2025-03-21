cryptomator)
    name="Cryptomator"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(curl -fs "https://cryptomator.org/downloads/mac-arm64/thanks/" | grep -oE "href=https:\/\/github\.com\/cryptomator\/cryptomator\/releases\/download\/[0-9.]+\/.*?-arm64\.dmg " | awk -F '=' '{ print $2 }' | sed 's/[[:space:]]*$//')"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="$(curl -fs "https://cryptomator.org/downloads/mac/thanks/" | grep -oE "href=https:\/\/github.com\/cryptomator\/cryptomator\/releases\/download\/[0-9.]+/.*?-x64\.dmg " | awk -F '=' '{ print $2 }' | sed 's/[[:space:]]*$//')"
    fi
    appNewVersion=$(echo "${downloadURL}" | awk -F'/' '{ print $(NF-1) }')
    expectedTeamID="YZQJQUHA3L"
    ;;
