qgis-ltr)
    name="QGIS-LTR"
    type="dmg"
    appNewVersion="$(curl -fs https://www.qgis.org/resources/roadmap/ | grep -oE "currently supported releases: [0-9]+\.[0-9]+(\.[0-9]+) and [0-9]+\.[0-9]+(\.[0-9]+)" | awk '{print$4}')"
    downloadURL="$(curl -fs "https://qgis.org/download/" | grep -o "https://.*$(echo $appNewVersion | sed 's/\./_/g').dmg" | tail -1)"
    appName="QGIS-LTR.app"
    expectedTeamID="4F7N4UDA22"
    ;;
