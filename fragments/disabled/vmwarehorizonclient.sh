vmwarehorizonclient|\
omnissahorizonclient)
    name="Omnissa Horizon Client"
    type="pkgInDmg"
    jsonData=$(curl -fsL 'https://customerconnect.omnissa.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=omnissa_horizon_clients&version=8&dlgType=PRODUCT_BINARY')
    for var in code productId releasePackageId; do
        local ${var}=$(<<< "$jsonData" sed -nE 's/.*Omnissa Horizon Client for macOS[^}]*"'$var'":"([^"]*).*/\1/p')
    done
    downloadURL=$(curl -fsL "https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$code&productId=$productId&rPId=$releasePackageId" | grep -oE 'https://[^"]*' )
    appNewVersion=$(<<< $downloadURL | grep -oE '\d+\.[0-9.]*\d')
    expectedTeamID="S2ZMFGQM93"
    ;;
