pcoipclient)
    name="PCoIPClient"
    type="dmg"
    pcoipClientInfo=$(curl -fs "https://dl.anyware.hp.com/ztqM7i47Dt06ETYM/pcoip-client/raw/names/pcoip-client-info/versions/dmg/pcoip-client-dmg-info.json")
    appNewVersion=$(getJSONValue "$pcoipClientInfo" "[0].currentVersion")
    downloadURL="https://dl.anyware.hp.com/pcoip-client/raw/names/pcoip-client-dmg/versions/${appNewVersion}/pcoip-client_${appNewVersion}.dmg"
    expectedTeamID="RU4LW7W32C"
    ;;
