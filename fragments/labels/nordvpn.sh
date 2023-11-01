nordvpn)
    name="NordVPN"
    type="pkg"
    appName="$name.app"
    packageID="com.nordvpn.macos"
    downloadURL="https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/latest/NordVPN.pkg"
    appNewVersion=$( curl -s https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/latest/update_pkg.xml | xpath -e '(//sparkle:shortVersionString/text())[1]' 2>/dev/null )
    versionKey="CFBundleShortVersionString"
    blockingProcesses=( $name )
    expectedTeamID="W5W395V82Y"
    ;;