basecamp3)
    name="Basecamp 3"
    type="dmg"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then
        downloadURL="https://bc3-desktop.s3.amazonaws.com/mac_arm64/basecamp3_arm64.dmg"
    else
        downloadURL="https://bc3-desktop.s3.amazonaws.com/mac/basecamp3.dmg"
    fi
    expectedTeamID="2WNYUYRS7G"
    appName="Basecamp.app"
    ;;
