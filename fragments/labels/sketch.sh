sketch)
    name="Sketch"
    type="zip"
    downloadURL=$(curl -sfL https://www.sketch.com/downloads/mac/ | grep -o 'https://download.sketch.com[^"]*\.zip' | head -1)
    appNewVersion=$(curl -sfL https://www.sketch.com/downloads/mac/ | grep -o 'sketch-[0-9.-]*\.zip' | head -1 | sed 's/sketch-//;s/\.zip//;s/-[0-9]*$//')
    expectedTeamID="WUGMZZ5K46"
    ;;
