workplacechat)
    name="Workplace Chat"
    type="dmg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    downloadPage=$(curl -s "https://www.workplace.com/resources/tech/it-configuration/download-workplace-chat")
    downloadURL=$(echo "$downloadPage" | grep -oE 'https://[^"]+\.dmg[^"]+"' | head -n 1 | sed 's/"$//' | sed 's/&amp;/\&/g')
    appNewVersion=$(echo "$downloadPage" | grep -oE '<td class="_3-mi">[0-9.]+<\/td>' | head -n 1 | sed -E 's/<\/?[^>]+>//g')
    expectedTeamID="V9WTTPBFK9"
    ;;
