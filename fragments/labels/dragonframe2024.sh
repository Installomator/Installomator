dragonframe2024)
    name="DragonFrame 2024"
    type="pkg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    appNewVersion=$(curl -s -A "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" https://www.dragonframe.com/downloads/ | grep -o 'Dragonframe_2024\.[0-9]\+\.[0-9]\+\.pkg' | sed -E 's/Dragonframe_//; s/\.pkg$//' | head -n 1)
    downloadURL="https://www.dragonframe.com/download/Dragonframe_${appNewVersion}.pkg"
    appName="Applications/Dragonframe 2024/Dragonframe 2024.app"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="PG7SM8SD8M"
    ;;
    
