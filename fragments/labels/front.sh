front)
    name="Front"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.frontapp.com/macos/Front-arm64.dmg"
        appNewVersion=$(curl -fs "https://dl.frontapp.com/desktop/updates/latest/mac-arm64/latest-mac.yml" | grep -i version | cut -d " " -f2)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dl.frontapp.com/macos/Front.dmg"
        appNewVersion=$(curl -fs "https://dl.frontapp.com/desktop/updates/latest/mac/latest-mac.yml" | grep -i version | cut -d " " -f2)
    fi
    expectedTeamID="X549L7572J"
    Company="FrontApp. Inc."
    ;;
