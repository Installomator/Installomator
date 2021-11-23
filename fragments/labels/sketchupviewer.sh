sketchupviewer)
    name="SketchUpViewer"
    type="dmg"
    downloadURL="$(curl -fs https://www.sketchup.com/sketchup/SketchUpViewer-en-dmg | grep "<a href=" | sed 's/.*href="//' | sed 's/".*//')"
    expectedTeamID="J8PVMCY7KL"
    ;;
