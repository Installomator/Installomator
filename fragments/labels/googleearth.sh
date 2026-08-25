googleearth)
    name="Google Earth Pro"
    type="pkgInDmg"
    appNewVersion=$(curl -fsL "https://www.google.com/earth/about/versions/\#download-pro" | grep -oi "<strong>version [0-9\.]*" | grep -o "[0-9\.]*")
    downloadURL="https://dl.google.com/earth/client/advanced/current/GoogleEarthProMac-Intel.dmg"
    expectedTeamID="EQHXZ8M8AV"
    ;;
