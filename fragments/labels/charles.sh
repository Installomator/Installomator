charles)
    name="Charles"
    type="dmg"
    appNewVersion=$(curl -fs https://www.charlesproxy.com/download/latest-release/ | sed -nE 's/.*version.*value="([^"]*).*/\1/p')
    downloadURL="https://www.charlesproxy.com/assets/release/$appNewVersion/charles-proxy-$appNewVersion.dmg"
    expectedTeamID="9A5PCU4FSD"
    ;;
