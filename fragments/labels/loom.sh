loom)
    name="Loom"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=https://cdn.loom.com/desktop-packages/$(curl -fs https://packages.loom.com/desktop-packages/latest-mac.yml | awk '/url/ && /arm64/ && /dmg/ {print $3}')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=https://cdn.loom.com/desktop-packages/$(curl -fs https://packages.loom.com/desktop-packages/latest-mac.yml | awk '/url/ && ! /arm64/ && /dmg/ {print $3}')
    fi
    appNewVersion=$(curl -fs https://packages.loom.com/desktop-packages/latest-mac.yml | awk '/version/ {print $2}' )
    expectedTeamID="QGD2ZPXZZG"
    ;;
