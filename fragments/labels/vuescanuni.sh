vuescanuni)
    name="VueScan"
    type="dmg"
    appNewVersion=$(curl -sfL https://www.hamrick.com/vuescan/vuescan.htm | grep -Eo 'VueScan [0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    downloadURL="https://www.hamrick.com/download.html?v=a64&dl=1"
    expectedTeamID="5D5BXT9KP5"
    ;;
