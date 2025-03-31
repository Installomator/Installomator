vernierspectralanalysis)
    name="Vernier Spectral Analysis"
    type="dmg"
    appNewVersion=$(curl -s "https://www.apkturbo.com/apps/vernier-spectral-analysis/com.vernier.spectralanalysis/" | sed -En 's/.*<dt>Version<\/dt><dd>([0-9]+\.[0-9]+\.[0-9]+) \(([0-9]+)\)<\/dd>.*/\1-\2/p' | head -1)
    downloadURL="https://software-releases.graphicalanalysis.com/sa/mac/release/latest/Vernier-Spectral-Analysis.dmg"
    expectedTeamID="75WN2B2WR8"
    ;;

