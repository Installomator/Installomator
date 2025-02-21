cycling74max)
    name="Max"
    type="dmg"
    downloadURL="$( curl -s "https://cycling74.com/downloads" $curlOptions | tr '"' '\n' | grep -m1 "Max.*dmg" )"
    appNewVersion=$(curl -s https://cycling74.com/downloads | grep -oE '9\.\d+\.\d+' | head -n 1)
    versionKey="CFBundleVersion"
    expectedTeamID="GBXXCFCVW5"
    ;;
