smartsvn)
    name="SmartSVN"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.smartsvn.com$(curl -fsL "https://www.smartsvn.com/download/" | grep -oE "href=\".*-aarch64.*\.dmg\"" | cut -d '"' -f 2)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://www.smartsvn.com$(curl -fsL "https://www.smartsvn.com/download/" | grep -oE "href=\".*-x86_64.*\.dmg\"" | cut -d '"' -f 2)"
    fi
    appNewVersion=$(curl -fsL "https://www.smartsvn.com/download/" | grep -B 1 "changelog.txt" | grep "Version " | awk -F' ' '{ print $2 }')
    expectedTeamID="PHMY45PTNW"
    ;;
