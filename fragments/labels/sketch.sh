sketch)
    name="Sketch"
    type="zip"
    downloadURL=$(curl -sf https://www.sketch.com/downloads/mac/ | grep -m 1 'href="https://download.sketch.com' | tr '"' "\n" | grep -E "https.*.zip")
    appNewVersion=$(echo "$downloadURL" | awk -F'-' '{ print $2 }')
    expectedTeamID="WUGMZZ5K46"
    ;;
