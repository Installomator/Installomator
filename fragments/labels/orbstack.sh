orbstack)
    name="OrbStack"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://orbstack.dev/download/stable/latest/arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://orbstack.dev/download/stable/latest/amd64"
    fi
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^location | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' | head -1)"
    expectedTeamID="HUAQ24HBR6"
    ;;
