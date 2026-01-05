sketchup2026)
    name="SketchUp 2026"
    type="dmg"
    downloadURL=$(curl -sI https://sketchup.trimble.com/sketchup/2026/SketchUpPro-dmg | grep -i '^location:' | awk '{print $2}' | tr -d '\r')
    folderName="SketchUp 2026"
    appName="${folderName}/SketchUp.app"
    appNewVersion=$(echo "$downloadURL" | grep -o '2026-[0-9]*-[0-9]*-[0-9]*' | sed 's/2026-/26./;s/-/./g')
    versionKey="CFBundleVersion"
    expectedTeamID="J8PVMCY7KL"
    ;;
