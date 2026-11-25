grokbot)
    name="Grok Bot"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        updateFeed=$(curl -fsL "https://api2.cursor.sh/updates/api/update/darwin-arm64/sand/0.0.0/stable")
    elif [[ $(arch) == "i386" ]]; then
        updateFeed=$(curl -fsL "https://api2.cursor.sh/updates/api/update/darwin-x64/sand/0.0.0/stable")
    fi
    appNewVersion=$(getJSONValue "${updateFeed}" "name")
    downloadURL=$(getJSONValue "${updateFeed}" "url")
    expectedTeamID="DCNK4UB866"
    ;;
