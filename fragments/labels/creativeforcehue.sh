creativeforcehue)
    name="Hue"
    baseURL="https://download.creativeforce.io/released-files.042024/prod/hue-uxp/mac"
    appNewVersion="$(curl -s $baseURL/latest-mac.yml | awk '/version:/ { print $2 }')"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="$baseURL/Hue-$appNewVersion-mac-arm64.pkg"
    else
        downloadURL="$baseURL/Hue-$appNewVersion-mac.pkg"
    fi
    expectedTeamID="Y5K3N5Y6PY"
    ;;
