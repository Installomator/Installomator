dragonframe2025)
    name="DragonFrame 2025"
    type="pkg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    appNewVersion=$(curl -s -A "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" https://www.dragonframe.com/downloads/ | grep -o 'Dragonframe [0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/Dragonframe //' | head -n 1)
    downloadURL="https://www.dragonframe.com/download/Dragonframe_${appNewVersion}.pkg"
    appName="Applications/Dragonframe 2025/Dragonframe 2025.app"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="PG7SM8SD8M"
    ;;

