elgatocamerahub)
    name="Elgato Camera Hub"
    type="pkg"
    # packageID="com.elgato.CameraHub.Installer"
    releaseURL="https://help.elgato.com/hc/en-us/sections/4880787756941-Elgato-Camera-Hub-Release-Notes"
    downloadURL=$(redirect=$(curl -A "Mozilla" $releaseURL | grep -A 2 'class="article-list-item "' | head -3 | tail -1 | sed -r 's/.*href="(.*)" class.*/\1/') && curl -A "Mozilla" "https://help.elgato.com$redirect" | grep -e 'macos.*.pkg' | sed -r 's/.*href="(.*)" target.*/\1/')
    appNewVersion=$(sed -E 's/.*Camera_Hub_([0-9.]*).pkg/\1/g' <<< $downloadURL | sed 's/\.[^.]*//3')
    expectedTeamID="Y93VXCB8Q5"
    ;;
