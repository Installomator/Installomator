outsystemsservicestudio)
    name="ServiceStudio"
    type="dmg"
    outsystemsModuleVersion=$(curl -fsL "https://www.outsystems.com/downloads/moduleservices/moduleinfo" | grep -o '"versionToken":"[^"]*"' | head -1 | cut -d'"' -f4)
    outsystemsReleases=$(curl -fsL -X POST "https://www.outsystems.com/downloads/screenservices/Downloads/MainFlow/HomeScreen/DataActionGetReleases" -H 'Content-Type: application/json; charset=UTF-8' -H 'X-CSRFToken: T6C+9iB49TLra4jEsMeSckDMNhQ=' --data-raw "{\"versionInfo\":{\"moduleVersion\":\"${outsystemsModuleVersion}\",\"apiVersion\":\"_eDWRKCNrOtW1Vtab26MtA\"},\"viewName\":\"MainFlow.HomeScreen\",\"screenData\":{\"variables\":{}},\"clientVariables\":{\"IsMacUser\":true}}")
    if [[ $(arch) == "arm64" ]]; then
        outsystemsFilename=$(echo "$outsystemsReleases" | grep -o 'ServiceStudio-[0-9.]*_arm64\.dmg' | head -1)
    elif [[ $(arch) == "i386" ]]; then
        outsystemsFilename=$(echo "$outsystemsReleases" | grep -o 'ServiceStudio-[0-9.]*\.dmg' | head -1)
    fi
    appNewVersion=$(echo "$outsystemsFilename" | sed -E 's/^ServiceStudio-([0-9.]+)(_arm64)?\.dmg$/\1/')
    downloadURL="https://dxejw4oyledi.cloudfront.net/repository/servicestudio/${appNewVersion}/${outsystemsFilename}"
    expectedTeamID="S25XN959HW"
    ;;
