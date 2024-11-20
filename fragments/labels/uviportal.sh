uviportal)
    name="UVI Portal"
    type="pkgInDmg"
    packageID="net.uvi.pkg.uviportal"
    downloadURL="https://www.uvi.net/dl-portal.php?p=mac"
    appNewVersion="$(curl -s -i "${downloadURL}" | grep "location" | cut -d\- -f2 | xargs)"
    expectedTeamID="BB6L4C84AT"
    ;;
