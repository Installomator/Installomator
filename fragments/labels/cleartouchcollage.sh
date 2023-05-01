cleartouchcollage)
    name="Collage"
    type="pkgInZip"
    packageID="com.cvte.cleartouch.mac"
    downloadURL="https://www.getcleartouch.com/download/collage-for-mac/?wpdmdl=412"
    appNewVersion=$(curl -fsIL https://www.getcleartouch.com/download/collage-for-mac/\?wpdmdl\=412 | grep -i ^content-disposition | sed -E 's/.*V([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/')
    expectedTeamID="P76M9BE8DQ"
    ;;
