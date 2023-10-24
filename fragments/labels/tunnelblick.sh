tunnelblick)
    name="Tunnelblick"
    type="dmg"
    version_plus_build=$(curl -sf https://github.com/Tunnelblick/Tunnelblick/releases  | grep -B2 'Pre-release' |grep -m 1 "/Tunnelblick/Tunnelblick/releases/tag/" | sed -r 's/.*Tunnelblick ([^<]+).*/\1/' | awk '{gsub(/ /,"_"); gsub(/\(|\)/,""); print}')
    appNewVersion=$version_plus_build
    version=$(echo $version_plus_build | awk -F_ '{print $1}')
    downloadURL="https://github.com/Tunnelblick/Tunnelblick/releases/download/v${version}/Tunnelblick_${version_plus_build}.dmg"
    expectedTeamID="Z2SG5H3HC8"
    ;;
