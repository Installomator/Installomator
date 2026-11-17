tidal)
    name="TIDAL"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        tidalFeed="https://download.tidal.com/desktop/mac/update-arm64.json"
    elif [[ $(arch) == "i386" ]]; then
        tidalFeed="https://download.tidal.com/desktop/mac/update-x64.json"
    fi
    tidalJSON=$(curl -fsL "$tidalFeed")
    downloadURL=$(getJSONValue "$tidalJSON" "releases[0].updateTo.url")
    appNewVersion=$(getJSONValue "$tidalJSON" "releases[0].updateTo.version")
    expectedTeamID="GK2243L7KB"
    ;;
