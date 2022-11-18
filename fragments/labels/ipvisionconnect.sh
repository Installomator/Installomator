ipvisionconnect)
    name="ipvision Connect"
    type="dmg"
    # Description: A softphone client from ipvision.dk
    downloadStore="https://my.ipvision.dk/connect/"
    downloadURL="${downloadStore}$(curl -fs "https://my.ipvision.dk/connect/" | grep osx | sort | tail -1 | cut -d '"' -f2)"
    appNewVersion="$(curl -fs "${downloadStore}" | grep osx | sort | tail -1 | sed -E 's/.*ipvision_connect_([0-9_]*)_osx.*/\1/' | tr "_" ".")"
    expectedTeamID="5RLWBLKGL2"
    ;;
