fathom)
    name="Fathom"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://electron-update.fathom.video/download/dmg_arm64"
    else
        downloadURL="https://electron-update.fathom.video/download/dmg"
    fi
    appNewVersion=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "$downloadURL" | sed -nE 's#.*Fathom-darwin-(x64|arm64)-([0-9]+(\.[0-9]+)+)\.dmg(\?.*)?$#\2#p')
    expectedTeamID="JH7GAYKCUH"
    ;;
