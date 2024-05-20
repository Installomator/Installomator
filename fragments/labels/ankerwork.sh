ankerwork)
    name="AnkerWork"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://ankerwork.s3.us-west-2.amazonaws.com/electron/AnkerWork-Setup-arm64.dmg"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://ankerwork.s3.us-west-2.amazonaws.com/electron/AnkerWork-Setup-x64.dmg"
    fi
    appNewVersion=$(curl -fs https://us.ankerwork.com/pages/download-software | grep -i "*For Mac 10.14" | grep '<div class="version-num">' | sed 's/.*<div class="version-num">V\([0-9.]*\)<\/div>.*/\1/')
    expectedTeamID="BVL93LPC7F"
    ;;
