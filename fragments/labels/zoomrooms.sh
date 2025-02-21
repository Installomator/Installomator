zoompresence|\
zoomrooms)
    name="ZoomPresence"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomRooms.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i location | cut -d "/" -f5)"
    expectedTeamID="BJ4HAAB9B3"
    ;;
