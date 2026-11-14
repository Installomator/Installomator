fierycommandworkstation)
    name="FieryCommandWorkStation"
    type="pkgInDmg"
    pkgName="/OSX/CWSPackage.pkg"
    fieryFeed=$(curl -fs -X POST "https://liveupdate.fiery.com/des/hypatia.asmx/newSoftware" -H "Content-Type: application/x-www-form-urlencoded" --data "product_identifier=10001069&host_id=&os_type=&os_name=macOS&os_version=$(sw_vers -productVersion)&os_image_version=&os_image_family=&os_language=en&software_language=&software_version=0.0.0.0&custom_attribute1=CodeBase&custom_attribute2=&custom_attribute3=&custom_attribute4=&installed_updates=")
    fieryLatest=$(echo "$fieryFeed" | tr -d '\r' | awk -F'[<>]' '/<version>/ {fieryVer=$3} /<location_download>/ && $3 ~ /\.dmg$/ {print fieryVer "|" $3}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n | tail -n 1)
    downloadURL="${fieryLatest#*|}"
    appNewVersion="${fieryLatest%%|*}"
    expectedTeamID="5N677U7DA8"
    ;;
