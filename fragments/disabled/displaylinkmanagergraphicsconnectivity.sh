displaylinkmanagergraphicsconnectivity)
    name="DisplayLink Manager Graphics Connectivity"
    type="pkg"
    packageID="com.displaylink.displaylinkmanagerapp"
    downloadURL=https://www.synaptics.com$(curl -fLs "https://www.synaptics.com$(curl -fLs https://www.synaptics.com/products/displaylink-graphics/downloads/macos | xmllint --html --format - 2>/dev/null | grep "download-link" | head -n1 | cut -d'"' -f2)" | xmllint --html --format - 2>/dev/null | grep -oE "/.+\.pkg")
    appNewVersion=$(echo "${downloadURL}" | grep -Eo '[0-9]\.[0-9]+(\.[0-9])?')
    expectedTeamID="73YQY62QM3"
    ;;
