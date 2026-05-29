trint)
    name="Trint"
    type="zip"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://desktopapp.trint.com/latest/darwin/arm64/Trint.zip"
        appNewVersion=$(getJSONValue "$(curl -fsL https://desktopapp.trint.com/updates/darwin/arm64/RELEASES.json)" "currentRelease" )
    else
        downloadURL="https://desktopapp.trint.com/latest/darwin/x64/Trint.zip"
        appNewVersion=$(getJSONValue "$(curl -fsL https://desktopapp.trint.com/updates/darwin/x64/RELEASES.json)" "currentRelease")
    fi
    expectedTeamID="4SN3PJXHG2"
    ;;
