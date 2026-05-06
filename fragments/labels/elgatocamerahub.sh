elgatocamerahub)
    name="Elgato Camera Hub"
    type="pkg"
    elgatoJSON=$(curl -fsSL "https://gc-updates.elgato.com/mac/echm-update/final/app-version-check.json")
    appNewVersion=$(getJSONValue "$elgatoJSON" "Automatic.Version")
    downloadURL=$(getJSONValue "$elgatoJSON" "Automatic.fileURL")
    appCustomVersion() { version=$(defaults read "/Applications/Camera Hub.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null); build=$(defaults read "/Applications/Camera Hub.app/Contents/Info.plist" CFBundleVersion 2>/dev/null); echo "${version}.${build}"; }
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Camera Hub" )
    ;;
