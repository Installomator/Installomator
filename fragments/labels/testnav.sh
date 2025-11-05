testnav)
    name="TestNav"
    type="dmg"
    fileName=$(getJSONValue "$(curl -fs "https://download.testnav.com/installerVersions.json")" 'mac')
    downloadURL="https://download.testnav.com/_testnavinstallers/${fileName}"
    appNewVersion=$(echo "$fileName" | sed -E 's/^.*-([0-9]+(\.[0-9]+)+)\.dmg$/\1/')
    expectedTeamID="9EGT93JZWD"
    ;;
