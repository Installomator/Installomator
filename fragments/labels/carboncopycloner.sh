carboncopycloner)
    name="Carbon Copy Cloner"
    type="zip"
    downloadURL=$(curl -fsIL "https://api.bombich.com/download/ccc?v=latest" | grep -i ^location | sed -E 's/.*(https.*\.zip).*/\1/g')
    appNewVersion=$(sed -E 's/.*-([0-9.]*)\.zip/\1/g' <<< $downloadURL | sed 's/\.[^.]*$//')
    expectedTeamID="L4F2DED5Q7"
    ;;
