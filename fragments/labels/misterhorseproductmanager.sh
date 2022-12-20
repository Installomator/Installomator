misterhorseproductmanager)
    name="Mister Horse Product Manager"
    type="dmg"
    downloadURL=$(curl -fsIL "https://misterhorse.com/downloads/product-manager/osx" | grep -i ^location | sed -E 's/.*(https.*\.dmg).*/\1/g')
    appNewVersion=$(sed -E 's/.*_([0-9.]*)\.dmg/\1/' <<< $downloadURL)
    expectedTeamID="H6366SAGL3"
    ;;

