sketchup2024)
    # SketchUp 2024 is a comprehensive 3D modeling software designed for professionals and enthusiasts
    name="SketchUp 2024"
    type="dmg"
    downloadURL="$(curl -s https://www.sketchup.com/en/download/all | grep -o 'https://download.sketchup.com/SketchUp-2024[^"]*.dmg')"
    folderName="SketchUp 2024"
    appName="${folderName}/SketchUp.app"
    appNewVersion=$(echo "$downloadURL" | grep -o 'SketchUp-20[0-9][0-9]-[0-9]*-[0-9]*' | awk -F '-' '{year=substr($2, 3, 2); if (year >= 24) printf "%d.0.%s", year, $NF; else printf "%d.%s", year+2000, $NF}')
    versionKey="CFBundleVersion"
    expectedTeamID="J8PVMCY7KL"
    ;;