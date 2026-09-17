zoomvdiplugin)
    name="ZoomVDI"
    type="pkg"
    zoomVDIURLs=$(curl -fs "https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0063810" | grep -oE 'https://zoom\.us/download/vdi/[0-9]+(\.[0-9]+){3}/ZoomVDI_[0-9]+(\.[0-9]+){2}\.universal\.pkg')
    downloadURL=$(echo "$zoomVDIURLs" | awk -F/ '{split($6,v,"."); printf "%04d.%04d.%04d.%05d %s\n", v[1], v[2], v[3], v[4], $0}' | sort | tail -n 1 | cut -d' ' -f2-)
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/vdi/([0-9]+(\.[0-9]+){3})/ZoomVDI_.*|\1|')
    versionKey="CFBundleVersion"
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( "ZoomVDI" "zoom.us" )
    ;;

