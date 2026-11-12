blackmagicvideohub)
    name="Blackmagic Videohub"
    appName="Blackmagic Videohub/Videohub Setup.app"
    type="pkgInDmgInZip"
    versionFeed=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json)
    downloadID=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('Blackmagic Videohub')).urls['Mac OS X'][0].downloadId")
    downloadURL=$(curl --compressed -fsL --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "Videohub"}' "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appNewVersion=$(echo ${downloadURL} | grep -oE '/v([0-9.]+)' | cut -d'v' -f2)
    appCustomVersion(){ grep "release_version" "/Applications/Blackmagic Videohub/Videohub Setup.app/Contents/Resources/settings.ini" | awk -F "=" '{print$2}'}
    blockingProcesses=( VideohubControl VideohubHardwarePanelSetup "Videohub Setup" )
    expectedTeamID="9ZGFBWLSYP"
    ;;
