omnissahorizonclient)
    name="Omnissa Horizon Client"
    type="pkgInDmg"
    jsonData=$(curl -fsL 'https://customerconnect.omnissa.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=virtual_desktop_and_apps&product=omnissa_horizon_clients&version=8&dlgType=PRODUCT_BINARY')
    macosDetails=$(getJSONValue "$jsonData" 'dlgEditionsLists[1].dlgList[0]')
    code=$(getJSONValue "$macosDetails" "code")
    productId=$(getJSONValue "$macosDetails" "productId")
    releasePackageId=$(getJSONValue "$macosDetails" "releasePackageId")
    downloadDetails=$(curl -fsL "https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$code&productId=$productId&rPId=$releasePackageId")
    downloadURL=$(getJSONValue  "$downloadDetails" 'downloadFiles[0].thirdPartyDownloadUrl')
    appNewVersion=$(getJSONValue "$downloadDetails" 'downloadFiles[0].fileName' | sed -E 's/^Omnissa-Horizon-Client-[^-]+-([0-9]+(\.[0-9]+)+)-.*\.dmg$/\1/')
    expectedTeamID="S2ZMFGQM93"
    ;;
