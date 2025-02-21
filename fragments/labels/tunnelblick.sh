tunnelblick)
    name="Tunnelblick"
    type="dmg"
    appNewVersion=$(curl -sf https://github.com/Tunnelblick/Tunnelblick/releases  | grep -B2 'Pre-release' |grep -m 1 "/Tunnelblick/Tunnelblick/releases/tag/" | sed -r 's/.*Tunnelblick ([^<]+).*/\1/')
    version_plus_build=$(echo ${appNewVersion} | awk '{gsub(/ /,"_"); gsub(/\(|\)/,""); print}')
    version=$(echo $version_plus_build | awk -F_ '{print $1}')
    downloadURL="https://github.com/Tunnelblick/Tunnelblick/releases/download/v${version}/Tunnelblick_${version_plus_build}.dmg"
    CLIInstaller="/Tunnelblick.app/Contents/Resources/installer"
    CLIArguments="259"
    expectedTeamID="Z2SG5H3HC8"
    ;;
