tourboxconsole)
    name="TourBox Console"
    type="pkgInZip"
    apiURL="https://www.tourboxtech.com/tbmall/download"
    releaseHistory=$(curl -fsSL --max-time 30 "$apiURL/version/history" -H "Content-Type: application/json" -H "local: US" --data '{"softName":"TourBox Console","softwarePlatform":3,"isBeta":0,"isBanSpecialNameVersion":1,"version":""}') || cleanupAndExit 14 "Could not retrieve TourBox Console release history." ERROR
    releaseID=$(getJSONValue "$releaseHistory" 'result.sort((a, b) => b.version.localeCompare(a.version, "en", {numeric: true}))[0].downloadMessageId')
    [[ "$releaseID" =~ ^[0-9]+$ ]] || cleanupAndExit 14 "Could not determine the TourBox Console release ID." ERROR
    releaseDetails=$(curl -fsSL --max-time 30 "$apiURL/info/message/id" -H "Content-Type: application/json" -H "local: US" --data "{\"downloadMessageId\":\"$releaseID\"}") || cleanupAndExit 14 "Could not retrieve TourBox Console release details." ERROR
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(getJSONValue "$releaseDetails" "result.path")
    else
        downloadURL=$(getJSONValue "$releaseDetails" "result.pathAddition")
    fi
    appNewVersion=$(getJSONValue "$releaseDetails" "result.version")
    [[ "$downloadURL" == https://*.zip && "$appNewVersion" =~ ^[0-9]+(\.[0-9]+)+$ ]] || cleanupAndExit 14 "Could not determine the TourBox Console download and version." ERROR
    expectedTeamID="8B253ZL4W9"
    ;;
