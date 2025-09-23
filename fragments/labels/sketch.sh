sketch)
    name="Sketch"
    type="zip"
    downloadURL=$(curl -sf https://www.sketch.com/downloads/mac/ | grep -m 1 'href="https://download.sketch.com' | tr '"' "\n" | grep -E "https.*.zip")
    appNewVersion=$( grep -oE '\d+\.\d+' <<< $downloadURL)
    expectedTeamID="WUGMZZ5K46"
    ;;
