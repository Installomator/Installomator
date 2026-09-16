davinciresolvestudio | \
blackmagicdavinciresolvestudio)
    name="DaVinci Resolve Studio"
    appName="DaVinci Resolve/DaVinci Resolve.app"
    type="pkgInDmgInZip"
    versionFeed=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json)
    downloadID=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('DaVinci Resolve Studio')).urls['Mac OS X'][0].downloadId")
    downloadURL=$(curl --compressed --location --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "DaVinci Resolve Studio"}' "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appNewVersion=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('DaVinci Resolve Studio')).urls['Mac OS X'].map(version => [version.major, version.minor, version.releaseNum].join('.'))[0]")
    blockingProcesses=( Resolve "DaVinci Control Panels Setup" "DaVinci Remote Monitor" "Fairlight Studio Utility" )
    expectedTeamID="9ZGFBWLSYP"
    ;;
