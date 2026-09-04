hpclick)
    name="HP Click"
    type="dmg"
    hpClickData=$(curl -fsS -X POST "https://support.hp.com/wcc-services/swd-v2/driverDetails?authState=anonymous&template=SWDSeriesDownload" -H "Accept: application/json, text/plain, */*" -H "Content-Type: application/json" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" -H "Origin: https://support.hp.com" -H "Referer: https://support.hp.com/us-en/drivers/hp-click-printing-software/15550865" -d '{"productLineCode":"GE","lc":"en","cc":"us","osTMSId":"18015185915131310124113888731054140111953115","osName":"Mac OS","productNumberOid":21355055,"productSeriesOid":15550865,"platformId":"275027708611380099388405694207665"}')
    downloadURL=$(getJSONValue "$hpClickData" 'data.softwareTypes[0].softwareDriversList[0].latestVersionDriver.fileUrl')
    appNewVersion=$(getJSONValue "$hpClickData" 'data.softwareTypes[0].softwareDriversList[0].latestVersionDriver.version')
    expectedTeamID="6HB5Y2QTA3"
    ;;
