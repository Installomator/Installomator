verniergraphicalanalysis)
    name="Vernier Graphical Analysis"
    type="dmg"
    appNewVersion=$(curl -s "https://www.apk20.com/apk/com.vernier.graphicalanalysis" | egrep -o 'Graphical Analysis [0-9]+\.[0-9]+\.[0-9]+' | sed 's/Graphical Analysis //' | head -1)
    downloadURL="https://software-releases.graphicalanalysis.com/ga/mac/release/latest/Vernier-Graphical-Analysis.dmg"
    expectedTeamID="75WN2B2WR8"
    ;;