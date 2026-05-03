basecamp3)
    name="Basecamp 3"
    type="zip"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then
        downloadURL=$(getJSONValue "$(curl -fsL https://basecamp.com/desktop/mac_arm64/updates.json)" "url")
        appNewVersion=$(getJSONValue "$(curl -fsL https://basecamp.com/desktop/mac_arm64/updates.json)" "version")
    else
        downloadURL=$(getJSONValue "$(curl -fsL https://basecamp.com/desktop/mac/updates.json)" "url")
        appNewVersion=$(getJSONValue "$(curl -fsL https://basecamp.com/desktop/mac/updates.json)" "version")
    fi
    expectedTeamID="2WNYUYRS7G"
    appName="Basecamp.app"
    ;;
