charlesbeta)
    name="Charles"
    type="dmg"
    appNewVersion=$(curl -fs https://www.charlesproxy.com/download/beta/ | sed -nE 's/.*version.*value="([^"]*).*/\1/p')
    downloadURL="https://www.charlesproxy.com/assets/release/$(echo "${appNewVersion}" | awk -Fb '{print $1}')/charles-proxy-${appNewVersion}.dmg"
    expectedTeamID="9A5PCU4FSD"
    ;;
