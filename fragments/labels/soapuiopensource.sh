soapuiopensource)
    appNewVersion="$(versionFromGit SmartBear soapui)"
    name="SoapUI-$appNewVersion"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="$(curl -fsL "https://github.com/SmartBear/soapui/releases/latest" | grep -m 1 -o 'href=".*arm64.*\.dmg".*' | cut -d '"' -f 2)"
    else
        downloadURL="$(curl -fsL "https://github.com/SmartBear/soapui/releases/latest" | grep -m 1 -o 'href=".*\.dmg".*' | cut -d '"' -f 2)"
    fi
    expectedTeamID="HVA5GNL2LF"
    ;;
