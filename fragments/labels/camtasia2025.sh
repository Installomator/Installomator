camtasia|\
camtasia2025)
    name="Camtasia"
    type="dmg"
    cdnData=$(curl -fsL "https://www.techsmith.com/api/v/1/products/getallversions/9" | jq '[.[] | select(.Major == 25)]')
    appNewVersion=$(echo "${cdnData}" | jq '.[] | "20" + (.Major|tostring) + "." + (.Minor|tostring) + "." + (.Maintenance|tostring)' | tr -d '"')
    versionID=$(echo "${cdnData}" | jq '.[].VersionID')
    packageData=$(curl -fsl "https://www.techsmith.com/api/v/1/products/getversioninfo/${versionID}")
    relativePath=$(echo "${packageData}" | jq '.PrimaryDownloadInformation.RelativePath' | tr -d '"')
    downloadURL="https://download.techsmith.com${relativePath}camtasia.dmg"
    expectedTeamID="7TQL462TU8"
    ;;
