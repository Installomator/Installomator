cisdem-documentreader)
    name="cisdem-documentreader"
    type="dmg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15" )
    appNewVersion=$(curl -sf $curlOptons https://www.cisdem.com/document-reader-mac.html | grep -i "Latest Version:" | sed 's/[^0-9\.]//g')
    downloadURL="https://download.cisdem.com/cisdem-documentreader.dmg"
    expectedTeamID="5HGV8EX6BQ"
    appName="Cisdem Document Reader.app"
    ;;
