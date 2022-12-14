proofpointcloudagent-latest-stable)
    name="Proofpoint Cloud Agent Latest Stable"
    type="pkgInZip"
    pkgName="observeit-cloudagent-OSX-2."*".pkg"
    downloadURL=$(curl -fs https://app.us-east-1-op1.op.analyze.proofpoint.com/downloads/default/ | grep -o -i "href.*\".*\"*observeit-cloudagent-OSX-bundle-2.*.tar.gz" | sed -n '1p' | cut -c 9-)
    expectedTeamID="DJR63QYCGL"
    ;;
