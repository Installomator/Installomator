misterhorseproductmanager)
    name="Mister Horse Product Manager"
    type="dmg"
    downloadURL="https://misterhorse.com/downloads/product-manager/osx"
    appNewVersion=$(curl -fsIL "https://misterhorse.com/downloads/product-manager/osx" | sed -nE 's/location.*Manager_([0-9.]*)\.dmg.*/\1/p')
    expectedTeamID="H6366SAGL3"
    ;;

