figma)
    name="Figma"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        figmaRelease="$(curl -fs https://desktop.figma.com/mac-arm/RELEASE.json)"
    elif [[ $(arch) == "i386" ]]; then
        figmaRelease="$(curl -fs https://desktop.figma.com/mac/RELEASE.json)"
    fi
    appNewVersion="$(getJSONValue "$figmaRelease" "version")"
    downloadURL="$(getJSONValue "$figmaRelease" "url")"
    expectedTeamID="T8RA8NE3B7"
    ;;
