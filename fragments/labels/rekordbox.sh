rekordbox)
    name="rekordbox"
    type="pkgInZip"
    downloadURL=$(curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.3 Safari/602.3.12" "https://rekordbox.com/en/download/" | grep pkg | awk -F "\"" '{print$4}')
    appNewVersion=$(curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.3 Safari/602.3.12" "https://rekordbox.com/en/download/" | grep "<h2>ver. " | awk -F " " '{print $2}' )
    expectedTeamID="6BRHGXQ6VU"
    ;;
