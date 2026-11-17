elgatocamerahub)
    name="Elgato Camera Hub"
    type="pkg"
    elgatoJSON=$(curl -fsSL "https://gc-updates.elgato.com/mac/echm-update/final/app-version-check.json")
    appNewVersion=$(getJSONValue "$elgatoJSON" "Automatic.Version")
    downloadURL=$(getJSONValue "$elgatoJSON" "Automatic.fileURL")
    appCustomVersion() { local plist="/Applications/${name}.app/Contents/Info.plist"; [[ -f "$plist" ]] || return; local version build; version=$(defaults read "$plist" CFBundleShortVersionString 2>/dev/null); build=$(defaults read "$plist" CFBundleVersion 2>/dev/null); [[ -n "$version" ]] && echo "${version}.${build}"}
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Camera Hub" )
    ;;
