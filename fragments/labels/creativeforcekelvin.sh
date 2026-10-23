creativeforcekelvin)
    name="Kelvin"
    baseURL="https://download.creativeforce.io/released-files.042024/prod/kelvin/mac"
    appNewVersion="$(curl -s $baseURL/latest-mac.yml | awk '/version:/ { print $2 }')"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="$baseURL/Kelvin-$appNewVersion-mac-arm64.pkg"
    else
        downloadURL="$baseURL/Kelvin-$appNewVersion-mac.pkg"
    fi
    expectedTeamID="Y5K3N5Y6PY"
    ;;
