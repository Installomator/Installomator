soapuiopensource)
    soapuiJSON=$(curl -fsL "https://api.github.com/repos/SmartBear/soapui/releases/latest")
    appNewVersion=$(getJSONValue "$soapuiJSON" "tag_name" | sed 's/^v//')
    name="SoapUI-$appNewVersion"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        platformName="arm64"
    else
        platformName="x64"
    fi
    downloadURL=$(getJSONValue "$soapuiJSON" "body" | grep -o "https://dl.eviware.com/soapuios/${appNewVersion}/SoapUI-${platformName}-${appNewVersion}.dmg" | head -n 1)
    expectedTeamID="HVA5GNL2LF"
    ;;
