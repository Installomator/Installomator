tourboxconsole)
    name="Tourbox Console"
    type="pkgInZip"
    apiURL="https://www.tourboxtech.com/tbmall/download"
    releaseHistory=$(curl -fsSL --max-time 30 \
        "$apiURL/version/history" \
        -H "Content-Type: application/json" \
        -H "local: US" \
        --data '{"softName":"TourBox Console","softwarePlatform":3,"isBeta":0,"isBanSpecialNameVersion":1,"version":""}')
    releaseID=$(getJSONValue "$releaseHistory" \
        'result.sort((a, b) => b.version.localeCompare(a.version, "en", {numeric: true}))[0].downloadMessageId')
    releaseDetails=$(curl -fsSL --max-time 30 \
        "$apiURL/info/message/id" \
        -H "Content-Type: application/json" \
        -H "local: US" \
        --data "{\"downloadMessageId\":\"$releaseID\"}")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(getJSONValue "$releaseDetails" "result.path")
    else
        downloadURL=$(getJSONValue "$releaseDetails" "result.pathAddition")
    fi
    appNewVersion=$(getJSONValue "$releaseDetails" "result.version")
    expectedTeamID="8B253ZL4W9"
    ;;
