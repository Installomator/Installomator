testnav)
    name="TestNav"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        fileName=$(getJSONValue "$(curl -fs "https://download.testnav.com/installerVersions.json")" "mac_arm")
    else
        fileName=$(getJSONValue "$(curl -fs "https://download.testnav.com/installerVersions.json")" "mac_intel")
    fi
    downloadURL="https://download.testnav.com/_testnavinstallers/${fileName}"
    appNewVersion=$(echo "$fileName" | sed -E 's/^testnav-([0-9]+(\.[0-9]+)+)-(x64|arm64)\.dmg$/\1/')
    expectedTeamID="9EGT93JZWD"
    ;;
