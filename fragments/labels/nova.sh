nova)
    name="Nova"
    type="zip"
    downloadURL="https://download.panic.com/nova/Nova-Latest.zip"
    appNewVersion="$(curl -fsIL https://download.panic.com/nova/Nova-Latest.zip | grep -i ^location | tail -1 | sed -E 's/^.*http.*\%20([0-9.]*)\.zip/\1/g')"
    expectedTeamID="VE8FC488U5"
    ;;
