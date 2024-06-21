googlechromeenterprise)
    name="Google Chrome"
    type="pkg"
    downloadURL="https://dl.google.com/dl/chrome/mac/universal/stable/gcem/GoogleChrome.pkg"
    appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac_arm64,stable/{print $3; exit}')
    expectedTeamID="EQHXZ8M8AV"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=fraction>0.01,endtime=none&order_by=version%20desc" )" "releases[0].version" )
    updateToolArguments=( -runMode oneshot -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;
