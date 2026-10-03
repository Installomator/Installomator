omnigent)
    name="Omnigent"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://omnigent.ai/download/mac"
    elif [[ "$(arch)" == "i386" ]]; then
        downloadURL="https://omnigent.ai/download/mac-x64"
    fi
    appNewVersion=$(curl -fsL -w "%{url_effective}" -o /dev/null "$downloadURL" | sed -E 's#.*Omnigent-([0-9.]+)-(arm64|x64)\.dmg#\1#')
    expectedTeamID="8RMX4WU6F8"
    ;;
