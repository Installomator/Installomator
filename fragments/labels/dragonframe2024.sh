dragonframe2024)
    name="DragonFrame 2024"
    type="pkg"
    packageID="com.dzed.Dragonframe2024"
    expectedTeamID="PG7SM8SD8M"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    downloadURL="$( curl -s "https://www.dragonframe.com/downloads/" $curlOptions | tr '"' '\n' | grep -m1 "_2024.*pkg" )"
    appNewVersion="$( echo "$downloadURL" | cut -d '_' -f 2 | cut -d '.' -f 1-3 )"
    versionKey="CFBundleShortVersionString"
    ;;
    
