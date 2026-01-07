elgatocamerahub)
    name="Elgato Camera Hub"
    type="pkg"
    downloadURL="https://gc-updates.elgato.com/mac/echm-update/final/download-website.php"
    appNewVersion=$(curl -fsI "https://gc-updates.elgato.com/mac/echm-update/final/download-website.php" | grep -i ^location | sed -E 's/.*CameraHub_([0-9.]+)\.pkg/\1/g')
    expectedTeamID="Y93VXCB8Q5"
    appCustomVersion() {
        local infoPath="$1"
        local version=$(defaults read "$infoPath" CFBundleShortVersionString 2>/dev/null)
        local build=$(defaults read "$infoPath" CFBundleVersion 2>/dev/null)
        echo "${version}.${build}"
    }
    blockingProcesses=( "Camera Hub" )
    ;;
