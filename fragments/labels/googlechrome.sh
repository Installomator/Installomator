googlechrome)
    name="Google Chrome"
    type="dmg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
        appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac_arm64,stable/{print $3; exit}')
    else
        printlog "Architecture: i386"
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac,stable/{print $3; exit}')
    fi
    expectedTeamID="EQHXZ8M8AV"
    ;;
