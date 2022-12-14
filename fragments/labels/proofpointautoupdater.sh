proofpointautoupdater)
    name="Proofpoint Auto Updater"
    type="pkgInZip"
    downloadURL=$(curl -fs https://app.us-east-1-op1.op.analyze.proofpoint.com/downloads/default/ | grep -o -i "href.*\".*\"*observeit-autoupdater-OSX-.*.tar.gz" | sed -n '1p' | cut -c 9-)
    expectedTeamID="DJR63QYCGL"
    ;;
