vmwarehorizonclient)
    name="VMware Horizon Client"
    type="pkgInDmg"
	downloadFiles=$(getJSONValue "$(curl -fsL 'https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=CART25FQ2_MAC_2406&productId=1027&rPId=118763' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15')" downloadFiles)
    downloadURL=$(echo $downloadFiles | grep thirdPartyDownloadUrl | cut -d\" -f4 | xargs)
    appNewVersion=$(echo $downloadFiles | grep fileName | cut -d- -f5 | xargs)
    expectedTeamID="EG7KH642X6"
    ;;``