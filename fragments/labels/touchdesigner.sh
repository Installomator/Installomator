touchdesigner)
    name="TouchDesigner"
    type="dmg"
    appNewVersion=$(curl -s -A "Mozilla/5.0" https://derivative.ca/download | grep -oE '[0-9]{4}\.[0-9]{5}' | head -n1)
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://download.derivative.ca/TouchDesigner.$appNewVersion.intel.dmg"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://download.derivative.ca/TouchDesigner.$appNewVersion.arm64.dmg"
    fi
    versionKey="CFBundleShortVersionString"
    expectedTeamID="Z7MPGSMXH2"
    ;;

