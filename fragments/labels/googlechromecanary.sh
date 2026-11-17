googlechromecanary)
    name="Google Chrome Canary"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/universal/canary/googlechromecanary.dmg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/canary/versions/all/releases?filter=endtime=none&order_by=version%20desc" )" "releases[0].version" )
    expectedTeamID="EQHXZ8M8AV"
    ;;
