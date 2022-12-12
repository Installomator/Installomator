googlechrome)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
    appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac_arm64,stable/{print $3; exit}')
    expectedTeamID="EQHXZ8M8AV"
    printlog "WARNING for ERROR: Label googlechrome should not be used. Instead use googlechromepkg as per recommendations from Google. It's not fully certain that the app actually gets updated here. googlechromepkg will have built in updates and make sure the client is updated in the future." REQ
    ;;
