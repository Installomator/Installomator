blackmagicwebpresenter)
    name="Blackmagic Web Presenter"
    appName="/Blackmagic Web Presenter/Blackmagic Web Presenter Setup.app"
    type="pkgInDmgInZip"
    versionFeed=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json)
    downloadID=$(getJSONValue "${versionFeed}" ".downloads.find(item => item.name.includes('Blackmagic Web Presenter')).urls['Mac OS X'][0].downloadId")
    downloadURL=$(curl --compressed -fsL --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "Blackmagic Web Presenter"}' "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appNewVersion=$(echo "${downloadURL}" | grep -o "_[0-9].*[0-9].zip" | sed -E 's/_|.zip//g')
    blockingProcesses=( "Blackmagic Web Presenter Setup" )
    expectedTeamID="9ZGFBWLSYP"
    ;;
