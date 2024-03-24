figma)
    name="Figma"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.figma.com/mac-arm/Figma.zip"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.figma.com/mac/Figma.zip"
    fi
    appNewVersion="$(getJSONValue "$(curl -fs https://desktop.figma.com/mac/RELEASE.json)" "version")"
    expectedTeamID="T8RA8NE3B7"
    ;;
