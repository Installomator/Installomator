googlechrome)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
    appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac_arm64,stable/{print $3; exit}')
    expectedTeamID="EQHXZ8M8AV"
    ;;
