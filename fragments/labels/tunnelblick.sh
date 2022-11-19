tunnelblick)
    name="Tunnelblick"
    type="dmg"
    downloadURL=$(downloadURLFromGit TunnelBlick Tunnelblick )
    appNewVersion=$(curl -sf https://github.com/Tunnelblick/Tunnelblick/releases | grep -m 1 "/Tunnelblick/Tunnelblick/releases/tag/" | sed -r 's/.*Tunnelblick ([^<]+).*/\1/')
    expectedTeamID="Z2SG5H3HC8"
    ;;
