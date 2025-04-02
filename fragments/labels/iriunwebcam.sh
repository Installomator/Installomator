iriunwebcam)
    name="IriunWebcam"
    type="pkg"
    packageID="com.iriun.pkg.multicam"
    downloadURL="$(curl -sf "https://iriun.com" | grep "Webcam for Mac" | awk -F '"' '{ print $4; }')"
    appNewVersion="$( echo "$downloadURL" | cut -d '-' -f 2 | sed -e 's/.pkg//' )"
    expectedTeamID="R84MX49LQY"
    ;;
