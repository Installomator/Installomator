uviportal)
    name="UVI Portal"
    type="pkgInDmg"
    packageID="net.uvi.pkg.uviportal"
    blockingProcesses=( "$name" )
    appNewVersion="$(curl -s -i "https://www.uvi.net/dl-portal.php?p=mac" | grep "location" | cut -d\- -f2 | xargs)"
    downloadURL="https://www.uvi.net/dl-portal.php?p=mac"
    expectedTeamID="BB6L4C84AT"
    ;;
