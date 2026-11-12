qgis-pr)
    name="QGIS"
    type="dmg"
    downloadURL="https://download.qgis.org/downloads/macos/qgis-macos-pr.dmg"
    qgisJson=$(curl -fs "https://raw.githubusercontent.com/qgis/QGIS-Website/refs/heads/main/data/conf.json")
    appNewVersion=$(getJSONValue "$qgisJson" "release")
    appName="QGIS-final-${appNewVersion//./_}.app"
    expectedTeamID="4F7N4UDA22"
    ;;
