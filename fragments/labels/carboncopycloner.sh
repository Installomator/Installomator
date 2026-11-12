carboncopycloner)
    name="Carbon Copy Cloner"
    type="zip"
    downloadURL=$(curl -fsL -o /dev/null -w '%{url_effective}' 'https://api.bombich.com/download/ccc?v=latest')
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/ccc-([0-9]+(\.[0-9]+)+)\.[0-9]+\.zip|\1|')
    expectedTeamID="L4F2DED5Q7"
    ;;
