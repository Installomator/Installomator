zoomclient)
    name="zoom.us"
    type="pkg"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://zoom.us/client/latest/Zoom.pkg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://zoom.us/client/latest/Zoom.pkg?archType=arm64"
    fi
    expectedTeamID="BJ4HAAB9B3"
    appNewVersion=$(curl -fsIL "$downloadURL" | cut -d "/" -f5)
    versionKey="CFBundleVersion"
    ;;
