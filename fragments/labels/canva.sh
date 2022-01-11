canva)
    name="Canva"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=https://desktop-release.canva.com/$(curl -fs https://desktop-release.canva.com/latest-mac.yml | grep -e "url.*dmg" | grep -oe "Canva-[0-9.]*-arm64.dmg")
        # https://www.canva.com/download/mac/arm/canva-desktop/
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=https://desktop-release.canva.com/$(curl -fs https://desktop-release.canva.com/latest-mac.yml | grep -e "url.*dmg" | grep -oe "Canva-[0-9.]*.dmg")
        # https://www.canva.com/download/mac/intel/canva-desktop/
    fi
    appNewVersion=$( curl -fs https://desktop-release.canva.com/latest-mac.yml | grep version | cut -d " " -f2 )
    expectedTeamID="5HD2ARTBFS"
    ;;
