zoomrooms)
    name="ZoomRooms"
    type="pkg"
    packageID="us.zoom.pkg.zp"
    downloadURL="https://zoom.us/client/latest/ZoomRooms.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i location | cut -d "/" -f5)"
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( "ZoomPresence" )
    ;;
