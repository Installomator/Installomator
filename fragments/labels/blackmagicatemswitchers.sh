blackmagicatemswitchers)
    name="Blackmagic ATEM Switchers"
    appName="/Blackmagic ATEM Switchers/ATEM Software Control.app"
    type="pkgInDmgInZip"
    versionFeed=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json)
    downloadID=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('DaVinci Resolve Studio')).urls['Mac OS X'][0].downloadId")
    downloadURL=$(curl --compressed -fsL --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "DaVinci Resolve Studio"}' "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appCustomVersion(){ grep "release_version" "/Applications/Blackmagic ATEM Switchers/ATEM Setup.app/Contents/Resources/settings.ini" | awk -F "=" '{print$2}'}
    appNewVersion=$(echo ${downloadURL} | grep -oE '/v([0-9.]+)' | cut -d'v' -f2)
    blockingProcesses=( "ATEM Setup" "ATEM Software Control" )
    expectedTeamID="9ZGFBWLSYP"
    ;;
