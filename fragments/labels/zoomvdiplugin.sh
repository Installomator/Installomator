zoomvdiplugin)
    name="ZoomVDI"
    type="pkg"
    packageID="us.zoom.ZoomVDI"
    downloadURL="$(curl -fs "https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0063810" \
        | grep -oE 'https://zoom\.us/download/vdi/[0-9.]+/ZoomVDI_[0-9.]+\.universal\.pkg' \
        | head -1)"
    appNewVersion="$(echo "$downloadURL" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')"
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( "ZoomVDI" "zoom.us" )
    ;;