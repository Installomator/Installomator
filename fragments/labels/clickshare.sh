clickshare)
    name="ClickShare"
    type="appInDmgInZip"
    clickshareAppInfo="$( elapsed=0 ; while ! response=$(curl -fs --max-time 5 --retry 5 --retry-max-time 30 -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" -H "Accept: application/json" -H "Connection: keep-alive" -H "DNT: 1" -H "Upgrade-Insecure-Requests: 1" "https://www.barco.com/bin/barco/tde/details.json?fileNumber=R3306192&tdeType=3") || ! echo "${response}" | grep -q "^.\(.*\).$"; do [[ $elapsed -ge 30 ]] && { break ; } ; ((elapsed++)) ; sleep 0.3; done; echo "${response}" | tr -d '\n\r')"
    appNewVersion="$( expr $( getJSONValue "$clickshareAppInfo" majorVersion ) + 1 - 1 )"
    appNewVersion+=".$( expr $( getJSONValue "$clickshareAppInfo" minorVersion ) + 1 - 1 )"
    appNewVersion+=".$( expr $( getJSONValue "$clickshareAppInfo" patchVersion ) + 1 - 1 )"
    appNewVersion+="-b$( expr $( getJSONValue "$clickshareAppInfo" buildVersion ) + 1 - 1 )"
    downloadURL="$( getJSONValue "$( elapsed=0 ; while ! response=$(curl -fs --max-time 5 --retry 5 --retry-max-time 30 -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" -H "Accept: application/json" -H "Connection: keep-alive" -H "DNT: 1" -H "Upgrade-Insecure-Requests: 1" "https://www.barco.com/bin/barco/tde/downloadUrl.json?fileNumber=R3306192&tdeType=3") || ! echo "${response}" | grep -q "^.\(.*\).$"; do ; [[ $elapsed -ge 30 ]] && { break ; } ; ((elapsed++)) ; sleep 0.3; done; echo "${response}" | tr -d '\n\r')" downloadUrl )"
    expectedTeamID="P6CDJZR997"
    ;;
