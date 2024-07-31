vernierspectralanalysis)
    name="Vernier Spectral Analysis"
    type="dmg"
    appNewVersion=$(curl -s "https://apps.apple.com/us/app/vernier-spectral-analysis/id1323245536" | egrep -o 'Version [0-9]+\.[0-9]+' | sed 's/Version //' | head -1)
    downloadURL="https://software-releases.graphicalanalysis.com/sa/mac/release/latest/Vernier-Spectral-Analysis.dmg"
    expectedTeamID="75WN2B2WR8"
    ;;