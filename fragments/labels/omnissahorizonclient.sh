omnissahorizonclient)
    name="Omnissa Horizon Client"
    type="pkgInDmg"
    jsonData=$(curl -fsL 'https://customerconnect.omnissa.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=omnissa_horizon_clients&version=8&dlgType=PRODUCT_BINARY')
    code=$(<<< "$jsonData" sed -nE 's/.*Omnissa Horizon Client for macOS[^}]*"code":"([^"]*).*/\1/p')
    productId=$(<<< "$jsonData" sed -nE 's/.*Omnissa Horizon Client for macOS[^}]*"productId":"([^"]*).*/\1/p')
    releasePackageId=$(<<< "$jsonData" sed -nE 's/.*Omnissa Horizon Client for macOS[^}]*"releasePackageId":"([^"]*).*/\1/p')
    downloadURL=$(curl -fsL "https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$code&productId=$productId&rPId=$releasePackageId" | sed -nE 's/.*"thirdPartyDownloadUrl":"([^"]*).*/\1/p')
    appNewVersion=$(<<< "$downloadURL" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    expectedTeamID="S2ZMFGQM93"
    ;;
