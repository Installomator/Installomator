sunsama)
    name="Sunsama"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.sunsama.com/mac/dmg/arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.sunsama.com/mac/dmg/x64"
    fi
    appNewVersion=$(curl -sfIL "$downloadURL" | grep -i '^content-disposition:' | sed -E 's/.*Sunsama ([0-9.]+).*/\1/' | head -n 1)
    expectedTeamID="SDWNXU94HZ"
    ;;
