flexoptixapp)
    name="FLEXOPTIX App"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://flexbox.reconfigure.me/download/electron/mac/arm64/current"
        appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | sed -E 's/.*App-(.*)\-arm.*/\1/g')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://flexbox.reconfigure.me/download/electron/mac/x64/current"
        appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | sed -E 's/.*App-(.*)\.dmg/\1/g')
    fi
    expectedTeamID="C5JETSFPHL"
    ;;
