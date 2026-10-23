shottr)
    name="Shottr"
    type="pkg"
    shottrJSON=$(curl -fs https://shottr.cc/api/version.json)
    downloadURL=$(getJSONValue "$shottrJSON" "package")
    appNewVersion=$(getJSONValue "$shottrJSON" "latestVersion")
    expectedTeamID="2Y683PRQWN"
    ;;
