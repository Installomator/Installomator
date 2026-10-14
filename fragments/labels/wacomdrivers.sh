wacomdrivers)
    name="Wacom Center"
    type="pkgInDmg"
    downloadURL="$(curl -fs -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" https://www.wacom.com/en-us/support/product-support/drivers | grep -e "drivers/mac/professional.*dmg" | head -1 | tr '"' "\n" | grep -i http)"
    expectedTeamID="EG27766DY7"
    appNewVersion="$(curl -fs -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" https://www.wacom.com/en-us/support/product-support/drivers | grep mac/professional/releasenotes | head -1 | tr '"' "\n" | grep -e "Driver [0-9][-0-9.]*" | sed -E 's/Driver ([-0-9.]*).*/\1/g')"
    ;;
