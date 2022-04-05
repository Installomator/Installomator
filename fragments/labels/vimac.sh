vimac)
    name="Vimac"
    type="zip"
    downloadURL=$(curl -fs "https://vimacapp.com/latest-release-metadata" | tr ',' '\n' | awk -F\" '/download_url/ {print $4}')
    appNewVersion=$(curl -fs "https://vimacapp.com/latest-release-metadata" | tr ',' '\n' | awk -F\" '/short_version/ {print $4}')
    expectedTeamID="LQ2VH8VB84"
    ;;
