nativeaccess)
    name="Native Access"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        naDetails="$(curl -fs "https://na-update.native-instruments.com/arm64/latest-mac.yml")"
        naItem="arm64/$(echo "$naDetails" | grep "path" | awk '{print $2}' | xargs)"
    elif [[ $(arch) == "i386" ]]; then
        naDetails="$(curl -fs "https://na-update.native-instruments.com/latest-mac.yml")"
        naItem="$(echo "$naDetails" | grep "path" | awk '{print $2}' | xargs)"
    fi
    downloadURL="https://na-update.native-instruments.com/${naItem}"
    appNewVersion="$(echo "$naDetails" | grep "version" | awk '{print $2}' | xargs)"
    expectedTeamID="83K5EG6Z9V"
    ;;
