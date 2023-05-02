avertouch)
    name="AverSphere"
    type="appInDmgInZip"
    pkgname="AVerTouch.dmg"
    appNewVersion="$(curl -s https://www.averusa.com/education/support/avertouch | grep -o 'AVerTouch_mac.*\.zip' | sed 's/.*(\([^)]*\)).*/\1/')"
    downloadURL="https://www.averusa.com/education/downloads/AVerTouch_mac_v1.15(${appNewVersion}).zip"
    expectedTeamID="B6T3WCD59Q"
    ;;
    