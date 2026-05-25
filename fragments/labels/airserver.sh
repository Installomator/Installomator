airserver)
    name="AirServer"
    type="dmg"
    downloadURL="https://www.airserver.com/download/mac/latest"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "location" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' | head -1)
    expectedTeamID="6C755KS5W3"
    ;;
