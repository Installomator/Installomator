blackmagicultimatte)
    name="Blackmagic Ultimatte"
    type="pkgInDmgInZip"
    versionFeed=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json)
    downloadID=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('Ultimatte')).urls['Mac OS X'][0].downloadId")
    downloadURL=$(curl --compressed -fsL --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "Ultimatte"}' "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appNewVersion=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('Ultimatte')).urls['Mac OS X'].map(version => [version.major, version.minor, version.releaseNum].join('.'))[0]")
    appCustomVersion(){ grep "release_version" "/Applications/Blackmagic Ultimatte/Blackmagic Ultimatte Setup.app/Contents/Resources/settings.ini" | awk -F "=" '{print$2}'}
    blockingProcesses=( UltimatteControl UltimatteHardwarePanelSetup "Ultimatte Setup" )
    expectedTeamID="9ZGFBWLSYP"
    ;;
