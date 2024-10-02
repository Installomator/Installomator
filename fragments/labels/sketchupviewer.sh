sketchupviewer)
    name="SketchUpViewer"
    type="dmg"
    downloadURL="$(curl -fs https://www.sketchup.com/sketchup/SketchUpViewer-en-dmg | awk -F' ' '{ print $3 }')"
    expectedTeamID="J8PVMCY7KL"
    ;;
