clickshare)
    name="ClickShare"
    type="appInDmgInZip"
    clickshareAppInfo="$( curl -fs "https://www.barco.com/bin/barco/tde/details.json?fileNumber=R3306192&tdeType=3" )"
    appNewVersion="$( expr $( getJSONValue "$clickshareAppInfo" majorVersion ) + 1 - 1 )"
    appNewVersion+=".$( expr $( getJSONValue "$clickshareAppInfo" minorVersion ) + 1 - 1 )"
    appNewVersion+=".$( expr $( getJSONValue "$clickshareAppInfo" patchVersion ) + 1 - 1 )"
    appNewVersion+="-b$( expr $( getJSONValue "$clickshareAppInfo" buildVersion ) + 1 - 1 )"
    downloadURL="$( getJSONValue "$( curl -fs "https://www.barco.com/bin/barco/tde/downloadUrl.json?fileNumber=R3306192&tdeType=3" )" downloadUrl )"
    expectedTeamID="P6CDJZR997"
    ;;
