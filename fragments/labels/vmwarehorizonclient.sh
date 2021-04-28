vmwarehorizonclient)
    # credit: Oh4sh0 https://github.com/Oh4sh0
    name="VMware Horizon Client"
    type="dmg"
    downloadURL=$(curl -fs "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=CART21FQ2_MAC_800&productId=1027&rPId=48989" | grep -o 'Url.*..dmg"' | cut -d '"' -f3)
    appNewVersion=$(curl -fs "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=CART21FQ2_MAC_800&productId=1027&rPId=48989" | sed 's/.*-\(.*\)-.*/\1/')
    expectedTeamID="EG7KH642X6"
    ;;
