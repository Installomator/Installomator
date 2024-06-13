cycling74max)
    name="Max"
    type="dmg"
    downloadURL="$( curl -s "https://cycling74.com/downloads" $curlOptions | tr '"' '\n' | grep -m1 "Max.*dmg" )"
    appNewVersion=$(curl -fsL 'https://cycling74.com/downloads' | sed -E 's/.*Max([12][0-9]|[1-9])([12][0-9]|[0-9])([0-9]+).*/\1.\2.\3/g')
    versionKey="CFBundleVersion"
    expectedTeamID="GBXXCFCVW5"
    ;;
