qgis-pr)
    name="QGIS"
    type="dmg"
    downloadURL="$(curl -fs "https://qgis.org/download/" | grep -o "https://.*/qgis-macos-pr.dmg" | tail -1)"
    appNewVersion="$(curl -fs https://www.qgis.org/resources/roadmap/ | grep -oE "currently supported releases: [0-9]+\.[0-9]+(\.[0-9]+) and [0-9]+\.[0-9]+(\.[0-9]+)" | awk '{print$6}')"
    expectedTeamID="4F7N4UDA22"
    ;;
