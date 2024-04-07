krisp)
    name="Krisp"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.krisp.ai/mac?package=package_arm"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.krisp.ai/mac?package=package_64"
    fi
    appNewVersion="$(curl -fsIL $downloadURL | grep -i "^location" | tail -1 | awk -F'/' '{ print $(NF-2) }')"
    expectedTeamID="U5R26XM5Z2"
    ;;
