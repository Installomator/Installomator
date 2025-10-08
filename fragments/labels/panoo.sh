panoo)
    name="PanooRemote"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fs "https://download.panoo.com" | grep -oE 'https://[^"]+arm64\.dmg' | sort -V | tail -n1)
    else
        downloadURL=$(curl -fs "https://download.panoo.com" | grep -oE 'https://[^"]+\.dmg' | grep -v "arm64" | sort -V | tail -n1)
    fi
    appNewVersion=$(curl -fs "https://download.panoo.com" | grep 'id="latest_darwin_arm64_label"' | sed 's/.*>\(.*\)<\/p>/\1/' | sort -V | tail -n1)
    expectedTeamID="BL2X4T29U9"
    ;;
