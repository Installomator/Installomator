gitkraken)
    name="GitKraken"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        gitkrakenFeed="https://release.gitkraken.com/darwin-arm64/RELEASES?v=12.0.0&darwin=27.0.0"
    else
        gitkrakenFeed="https://release.gitkraken.com/darwin/RELEASES?v=12.0.0&darwin=27.0.0"
    fi
    gitkrakenJSON=$(curl -fsL "$gitkrakenFeed")
    appNewVersion=$(getJSONValue "$gitkrakenJSON" "name")
    downloadURL=$(getJSONValue "$gitkrakenJSON" "url")
    expectedTeamID="T7QVVUTZQ8"
    ;;
