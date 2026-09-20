blackmagiccameras)
    name="Blackmagic Cameras"
    appName="Blackmagic Cameras/Blackmagic Camera Setup.app"
    type="pkgInDmgInZip"
    versionFeed=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json)
    downloadID=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('Blackmagic Camera')).urls['Mac OS X'][0].downloadId")
    downloadURL=$(curl --compressed -fsL --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "Blackmagic Camera"}' "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appNewVersion=$(echo ${downloadURL} | grep -oE '/v([0-9.]+)' | cut -d'v' -f2)
    appCustomVersion(){ grep "release_version" "/Applications/Blackmagic Cameras/Blackmagic Camera Setup.app/Contents/Resources/settings.ini" | awk -F "=" '{print$2}'}
    blockingProcesses=( "Blackmagic Camera Setup" )
    expectedTeamID="9ZGFBWLSYP"
    ;;
