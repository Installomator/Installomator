
vmwarefusion)
    #TODO: vmwarefusion installation process needs testing
    # credit: Erik Stam (@erikstam)
    name="VMware Fusion"
    type="dmg"
    downloadURL="https://www.vmware.com/go/getfusion"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*Fusion-([0-9.]*)-.*/\1/g' )
    expectedTeamID="EG7KH642X6"
    ;;
