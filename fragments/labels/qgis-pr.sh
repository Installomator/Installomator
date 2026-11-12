qgis-pr)
    name="QGIS"
    type="dmg"
    qgisJson=$(curl -fs "https://raw.githubusercontent.com/qgis/QGIS-Website/refs/heads/main/data/conf.json")
    downloadURL=$(getJSONValue "$qgisJson" "lr_dmg")
    appNewVersion=$(getJSONValue "$qgisJson" "release")
    appName="QGIS-final-${appNewVersion//./_}.app"
    expectedTeamID="4F7N4UDA22"
    ;;
