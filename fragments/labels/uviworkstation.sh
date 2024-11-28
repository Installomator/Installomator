uviworkstation)
    name="UVIWorksation"
    type="pkgInDmg"
    packageID="net.uvi.pkg.UVIWorkstation.SA"
    downloadURL="https://www.uvi.net/dwl.php?p=mac"
    appNewVersion="$(curl -s -i "${downloadURL}" | grep "location" | cut -d\- -f2 | xargs)"
    expectedTeamID="BB6L4C84AT"
    ;;
