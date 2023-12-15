elgatocamerahub)
    name="Elgato Camera Hub"
    type="pkg"
    # packageID="com.elgato.CameraHub.Installer"
    downloadURL="https://gc-updates.elgato.com/mac/echm-update/final/download-website.php"
    appNewVersion=$(curl -fsI "https://gc-updates.elgato.com/mac/echm-update/final/download-website.php" | grep -i ^location | sed -E 's/.*Camera_Hub_([0-9.]*).pkg/\1/g' | sed 's/\.[^.]*//3')
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Camera Hub" )
    ;;
