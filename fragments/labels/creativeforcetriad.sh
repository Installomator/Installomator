creativeforcetriad)
    name="Triad"
    baseURL="https://download.creativeforce.io/released-files.042024/prod/triad/mac"
    appNewVersion="$(curl -s $baseURL/latest-mac.yml | awk '/version:/ { print $2 }')"
    type="pkg"
    downloadURL="$baseURL/Triad-$appNewVersion-mac.pkg"
    expectedTeamID="Y5K3N5Y6PY"
    ;;
