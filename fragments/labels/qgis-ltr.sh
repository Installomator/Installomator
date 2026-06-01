qgis-ltr)
    name="QGIS"
    type="dmg"
    downloadURL="$(getJSONValue "$(curl -fs "https://raw.githubusercontent.com/qgis/QGIS-Website/refs/heads/main/data/conf.json")" "ltr_dmg")"
    appNewVersion="$(getJSONValue "$(curl -fs "https://raw.githubusercontent.com/qgis/QGIS-Website/refs/heads/main/data/conf.json")" "ltrrelease")"
    expectedTeamID="4F7N4UDA22"
    ;;
