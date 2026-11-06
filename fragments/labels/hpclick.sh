hpclick)
    name="HP Click"
    type="dmg"
    hpPlatformId="275027708611380099388405694207665"
    hpOSData=$(curl -fsS "https://support.hp.com/wcc-services/swd-v2/osVersionData?cc=us&lc=en&productOid=15550865&authState=anonymous&template=SWDSeriesDownload" -H "Accept: application/json, text/plain, */*" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" -H "Referer: https://support.hp.com/us-en/drivers/hp-click-printing-software/15550865") || cleanupAndExit 14 "Could not retrieve HP Click macOS platform data." ERROR
    hpOSTMSId=$(getJSONValue "$hpOSData" "data.osAvailablePlatformsAnsOS.osPlatforms.find(p => p.id === \"$hpPlatformId\").osVersions.sort((a, b) => a.order - b.order)[0].id")
    hpClickData=$(curl -fsS -X POST "https://support.hp.com/wcc-services/swd-v2/driverDetails?authState=anonymous&template=SWDSeriesDownload" -H "Accept: application/json, text/plain, */*" -H "Content-Type: application/json" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" -H "Origin: https://support.hp.com" -H "Referer: https://support.hp.com/us-en/drivers/hp-click-printing-software/15550865" -d "{\"productLineCode\":\"GE\",\"lc\":\"en\",\"cc\":\"us\",\"osTMSId\":\"$hpOSTMSId\",\"osName\":\"Mac OS\",\"productNumberOid\":21355055,\"productSeriesOid\":15550865,\"platformId\":\"$hpPlatformId\"}") || cleanupAndExit 14 "Could not retrieve HP Click driver details." ERROR
    hpClickDriver=$(getJSONValue "$hpClickData" 'data.softwareTypes.flatMap(type => type.softwareDriversList).map(driver => driver.latestVersionDriver).find(driver => driver.title === "HP Click")')
    downloadURL=$(getJSONValue "$hpClickDriver" "fileUrl")
    appNewVersion=$(getJSONValue "$hpClickDriver" "version")
    [[ -n "$downloadURL" && -n "$appNewVersion" ]] || cleanupAndExit 14 "Could not determine the HP Click download URL or version." ERROR
    expectedTeamID="6HB5Y2QTA3"
    ;;
