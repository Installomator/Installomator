scenebuilder)
    name="SceneBuilder"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -sfL "https://gluonhq.com/products/scene-builder/" | xmllint --html --format - 2>/dev/null | grep -o "https://.*SceneBuilder.*aarch64.dmg")
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -sfL "https://gluonhq.com/products/scene-builder/" | xmllint --html --format - 2>/dev/null | grep -o "https://.*SceneBuilder.*amd64.dmg")
    fi
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="S7ZR395D8U"
    ;;
