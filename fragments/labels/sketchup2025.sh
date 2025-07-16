sketchup2025)
    name="SketchUp 2025"
    type="dmg"
    downloadURL="$(curl -s https://www.sketchup.com/en/download/all | grep -o 'https://download.sketchup.com/SketchUp-2025[^"]*.dmg')"
    folderName="SketchUp 2025"
    appName="${folderName}/SketchUp.app"
    appNewVersion="$(echo "${downloadURL}" | grep -oE 'SketchUp-[0-9]+-[0-9]+-[0-9]+' | sed -E 's/SketchUp-([0-9]+)-([0-9]+)-([0-9]+)/\1.\2.\3/' | sed 's/^2025/25/')"
    versionKey="CFBundleVersion"
    expectedTeamID="J8PVMCY7KL"
    #comment out below line if you don't want LayOut.app installed
    cp -R -f "/Volumes/SketchUp 2025/SketchUp 2025/LayOut.app" "/Applications/SketchUp 2025/"
    ;;

