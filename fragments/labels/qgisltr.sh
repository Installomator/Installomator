qgisltr)
    name="QGIS-LTR"
    type="dmg"
    qgisJson=$(curl -fs "https://raw.githubusercontent.com/qgis/QGIS-Website/refs/heads/main/data/conf.json")
    downloadURL=$(getJSONValue "$qgisJson" "ltr_dmg")
    appNewVersion=$(getJSONValue "$qgisJson" "ltrrelease")
    expectedTeamID="4F7N4UDA22"
    ;;
