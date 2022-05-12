qgis-pr)
    name="QGIS"
    type="dmg"
    downloadURL="https://download.qgis.org/downloads/macos/qgis-macos-pr.dmg"
    appNewVersion="$(curl -fs "https://www.qgis.org/da/_static/documentation_options.js" | grep -i version | cut -d "'" -f2)"
    expectedTeamID="4F7N4UDA22"
    ;;
