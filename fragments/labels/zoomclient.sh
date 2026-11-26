zoomclient)
    name="zoom.us"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        zoomArch="arm64"
    elif [[ $(arch) == "i386" ]]; then
        zoomArch="mac64"
    fi
    zoomFeed=$(curl -fs -X POST "https://zoom.us/releasenotes" -H "User-Agent: Mozilla/5.0 (ZOOM.Mac 27.0.1 x86)" -H "Accept: */*" -H "cpu-arch: ${zoomArch}" -d "cv=7.0.0" -d "os=mac" -d "type=manual" -d "upgrade64Bit=1" | LC_ALL=C tr ';' '\n' | LC_ALL=C tr -cd '[:print:]\n')
    downloadURL=$(echo "$zoomFeed" | grep '^Package-url=' | head -1 | cut -d '=' -f2-)
    appNewVersion=$(echo "$zoomFeed" | grep '^Real-version=' | head -1 | cut -d '=' -f2)
    versionKey="CFBundleVersion"
    expectedTeamID="BJ4HAAB9B3"
    ;;
