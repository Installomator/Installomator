xeroxprintandscan|\
xeroxworkcentre7800)
    name="XeroxWorkCentre"
    type="pkgInDmg"
    appCustomVersion(){ lpinfo -m | grep 783 | tail -n 1 | awk -F ', ' '{print $2}' }
    appNewVersion=$( curl -fsL "https://www.support.xerox.com/nl-nl/product/workcentre-7800-series/downloads?platform=macOS14" | grep .dmg | head -n 1 | awk -F '_' '{print $2}' )
    downloadURL=$( curl -fsL "https://www.support.xerox.com/nl-nl/product/workcentre-7800-series/downloads?platform=macOS14" | xmllint --html --format - 2>/dev/null | grep -o "https://.*XeroxDrivers.*.dmg" )
    expectedTeamID="G59Y3XFNFR"
    blockingProcesses=( NONE )
;;
