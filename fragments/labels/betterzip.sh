betterzip)
    name="BetterZip"
    type="zip"
    downloadURL="https://macitbetter.com/BetterZip.zip"
    appNewVersion=$(curl -Ls https://macitbetter.com/version-history/ | awk 'match($0,/Version[[:space:]]+[0-9]+(\.[0-9]+)+/){print substr($0,RSTART,RLENGTH)}' | head -n1 | awk '{print $2}')
    versionKey="CFBundleShortVersionString"
    expectedTeamID="79RR9LPM2N"
    ;;
