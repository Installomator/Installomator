keyshot12)
    name="KeyShot12"
    type="pkg"
    packageID="com.luxion.pkg.keyshot12.app"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://www.keyshot.com/download/357619/"
    appNewVersion="$( curl -v "$downloadURL" 2>&1 | grep location | cut -d '_' -f 4 | cut -d '.' -f 1-2 )"
    ;;
