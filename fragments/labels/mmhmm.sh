mmhmm)
    name="mmhmm"
    type="pkg"
    downloadURL="https://updates.mmhmm.app/mac/mmhmm.pkg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15" )
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://help.mmhmm.app/hc/en-us/articles/4420969712151-mmhmm-for-Mac" | grep 'The latest version of mmhmm for Mac is <strong>*' | sed -e 's/.*\<strong\>\(.*\)\.\<\/strong\>.*/\1/')
    expectedTeamID="M3KUT44L48"
    ;;
