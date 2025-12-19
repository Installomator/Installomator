vuescanintel)
    # VueScan is a 64-bit app, Intel version for scanner compatibility
    name="VueScan"
    type="dmg"
    appNewVersion=$(curl -sfL https://www.hamrick.com/vuescan/vuescan.htm | grep -Eo 'VueScan [0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    downloadURL="https://www.hamrick.com/files/vuex64$(echo "$appNewVersion" | cut -d'.' -f1,2 | tr -d '.').dmg"
    expectedTeamID="5D5BXT9KP5"
    blockingProcesses=("VueScan")
    ;;
