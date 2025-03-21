teamviewerqscustom)
    name="TeamViewerQS"
    type="zip"
    teamviewerCustomDownloadURL="" # https://get.teamviewer.com/your_custom_name_here
    teamviewerConfigID=$(curl -fs ${teamviewerCustomDownloadURL} -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' | grep -o 'var configId = ".*"' | awk -F'"' '{ print $2 }')
    teamviewerVersion=$(curl -fs ${teamviewerCustomDownloadURL} -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' | grep -o 'var version = ".*"' | awk -F'"' '{ print $2 }')
    downloadURL=$(curl -fs -X POST --url "https://get.teamviewer.com/api/CustomDesign" --header 'Content-Type: application/json; charset=utf-8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' --data '{ "ConfigId": "'"$teamviewerConfigID"'", "Version": "'"$teamviewerVersion"'", "IsCustomModule": true, "Subdomain": "1", "ConnectionId": "" }' | tr -d '"')
    appNewVersion=$(curl -s -L -X GET "https://jamf-patch.jamfcloud.com/v1/patch/1C4" -H "Accept: application/json" --output - | security cms -D | plutil -convert json -r -o - - | grep "currentVersion" | cut -d '"' -f 4)
    appName="TeamViewerQS.app"
    expectedTeamID="H7UGFBUGV6"
    ;;
