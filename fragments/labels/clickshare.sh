clickshare)
    name="ClickShare"
    type="appInDmgInZip"
    clickshareAppInfo="$( curl -fs  -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36" "https://www.barco.com/bin/barco/tde/details.json?fileNumber=R3306192&tdeType=3" )"
    appNewVersion="$( expr $( getJSONValue "$clickshareAppInfo" majorVersion ) + 1 - 1 )"
    appNewVersion+=".$( expr $( getJSONValue "$clickshareAppInfo" minorVersion ) + 1 - 1 )"
    appNewVersion+=".$( expr $( getJSONValue "$clickshareAppInfo" patchVersion ) + 1 - 1 )"
    appNewVersion+="-b$( expr $( getJSONValue "$clickshareAppInfo" buildVersion ) + 1 - 1 )"
	downloadURL="$( getJSONValue "$(curl -fs -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36" "https://www.barco.com/bin/barco/tde/downloadUrl.json?fileNumber=R3306192&tdeType=3")" downloadUrl )"
    expectedTeamID="P6CDJZR997"
    ;;