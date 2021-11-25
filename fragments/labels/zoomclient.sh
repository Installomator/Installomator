zoomclient)
    name="zoom.us"
    type="pkg"
    packageID="us.zoom.pkg.videomeeting"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://zoom.us/client/latest/Zoom.pkg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://zoom.us/client/latest/Zoom.pkg?archType=arm64"
    fi
    expectedTeamID="BJ4HAAB9B3"
    #appNewVersion=$(curl -is "https://beta2.communitypatch.com/jamf/v1/ba1efae22ae74a9eb4e915c31fef5dd2/patch/zoom.us" | grep currentVersion | tr ',' '\n' | grep currentVersion | cut -d '"' -f 4) # Does not match packageID
    blockingProcesses=( zoom.us )
    #blockingProcessesMaxCPU="5"
    ;;
