wacomdrivers)
    name="Wacom Desktop Center"
    type="pkgInDmg"
    downloadURL="$(curl -fs https://www.wacom.com/en-us/support/product-support/drivers | grep -e "drivers/mac/professional.*dmg" | head -1 | sed -e 's/data-download-link="//g' -e 's/"//' | awk '{$1=$1}{ print }' | sed 's/\r//')"
    expectedTeamID="EG27766DY7"
    pkgName="Install Wacom Tablet.pkg"
    appNewVersion="$(curl -fs https://www.wacom.com/en-us/support/product-support/drivers | grep mac/professional/releasenotes | head -1 | awk -F"|" '{print $1}' | awk -F"Driver" '{print $3}' | sed -e 's/ (.*//g' | tr -d ' ')"
    ;;
