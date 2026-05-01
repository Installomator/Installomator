vuescanuni)
    name="VueScan"
    type="dmg"
    appNewVersion=$(curl -sfL https://www.hamrick.com/vuescan/vuescan.htm | grep -Eo 'VueScan [0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    downloadURL="https://www.hamrick.com/files/vuea64$(echo "$appNewVersion" | tr -d '.').dmg"
    expectedTeamID="5D5BXT9KP5"
    ;;
