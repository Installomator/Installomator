splice)
    name="Splice"
    type="zip"
    if [[ "$(arch)" == "arm64" ]]; then
        appNewVersion=$(getJSONValue "$(curl -fs 'https://api.splice.com/v2/desktop/darwin/stable/latest?v=1.0.0&architecture=arm64')" "name")
        downloadURL="https://desktop.splice.com/darwin/stable/arm64/Splice.app.zip"
    else
        appNewVersion=$(getJSONValue "$(curl -fs 'https://api.splice.com/v2/desktop/darwin/stable/latest?v=1.0.0&architecture=x64')" "name")
        downloadURL="https://desktop.splice.com/darwin/stable/x64/Splice.app.zip"
    fi
    expectedTeamID="9962T6AKMH"
    ;;
