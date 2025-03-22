garminexpress)
    name="Garmin Express"
    blockingProcesses=( "Garmin Express" "Garmin Express Service" )
    type="pkgInDmg"
    downloadURL="https://download.garmin.com/omt/express/GarminExpress.dmg"
    garminfaqURL=$(curl -sf https://support.garmin.com/capi/content/en-US/\?productID\=168768\&tab\=software\&topicTag\=region_softwareproduct\&productTagName\=topic_express0\&ct\=content\&mr\=5\&locale\=en-US\&si\=0\&tags\=topic_express0%2Cregion_softwareproduct%2C%2C | tr "{" "\n" | grep "Garmin Express" | tr "," "\n" | grep "contentURL" | awk -F "\"" '{print$4}')
    appNewVersion="$(curl -sfL $garminfaqURL | tr '><' "\n" | grep "Garmin Express for Mac" | head -1 | awk 'sub(/.*Mac: */,""){f=1} f{if ( sub(/ *as of.*/,"") ) f=0; print}').0"
    expectedTeamID="72ES32VZUA"
    ;;
