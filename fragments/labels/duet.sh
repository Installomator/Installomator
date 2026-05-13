duet)
    name="duet"
    type="dmg"
    sparkleData=$(curl -fsL 'https://updater.duetdownload.com/dd/sparkle.xml?lang=en-US&appName=Duet')
    appNewVersion=$( <<<"$sparkleData" xpath '//*[local-name()="enclosure"]/@*[local-name()="version"]' | sed 's/.*="//;s/"//' | sort -V | tail -n 1 )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//*[local-name()="enclosure"][@*[local-name()="version"] = "'"$appNewVersion"'"]/@url)' )
    expectedTeamID="J6L96W8A86"
    blockingProcesses=( "duet" "duet Networking" )
    ;;
