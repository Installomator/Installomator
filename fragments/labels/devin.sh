devin|\
windsurf)
    name="Devin"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        devinFeedArch="darwin-arm64"
    elif [[ $(arch) == "i386" ]]; then
        devinFeedArch="darwin"
    fi
    devinJSON="$(curl -fsL "https://windsurf-stable.codeium.com/api/update/${devinFeedArch}/stable/?v=3.00.00000")"
    downloadURL="$(getJSONValue "$devinJSON" "url")"
    appNewVersion="$(getJSONValue "$devinJSON" "windsurfVersion")"
    expectedTeamID="83Z2LHX6XW"
    ;;
