outputarcade)
    name="Arcade"
    type="pkg"
    arcadeVersion="$(curl -fs "https://api.output.com/v1/arcade_version")"
    if [[ -d "/Applications/Arcade.app" ]]; then
        downloadURL=$(getJSONValue "$arcadeVersion" packages.mac.url)
    else
        downloadUpgrade=$(getJSONValue "$arcadeVersion" packages.mac.url)
        downloadURL=$(echo "${downloadUpgrade}" | sed "s/Update/Install/")
    fi
    appNewVersion=$(getJSONValue "$arcadeVersion" version)
    expectedTeamID="M4BQRFQ23V"
    ;;
