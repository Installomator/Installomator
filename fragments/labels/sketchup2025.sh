sketchup2025)
    name="SketchUp 2025"
    type="dmg"
    downloadURL=$(curl -sfL https://www.sketchup.com/download/all | grep -o 'https://download.sketchup.com/SketchUp-2025[^"]*.dmg' | head -1)
    folderName="SketchUp 2025"
    appName="${folderName}/SketchUp.app"
    appNewVersion=$(echo "$downloadURL" | grep -o '2025-[0-9]*-[0-9]*-[0-9]*' | sed 's/2025-/25./;s/-/./g')
    versionKey="CFBundleVersion"
    expectedTeamID="J8PVMCY7KL"
    ;;
