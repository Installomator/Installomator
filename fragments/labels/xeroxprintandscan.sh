xeroxprintandscan)
    name="xeroxprintandscan"
    type="pkgInDmg"
    downloadURL="curl -fs "https://www.support.xerox.com/en-us/product/versalink-c9000/downloads?platform=macOS14" | xmllint --html --format - 2>/dev/null | grep -o "https://.*XeroxDrivers.*.dmg""
    expectedTeamID="G59Y3XFNFR"
    ;;
