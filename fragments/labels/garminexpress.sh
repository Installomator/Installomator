garminexpress)
    name="Garmin Express"
    type="pkgInDmg"
    downloadURL="https://download.garmin.com/omt/express/GarminExpress.dmg"
    # https://support.garmin.com/en-US/?faq=9MuiEv9c2y2wgcXvzEVEe8 could possibly be used for a simpler query, but it looks like an auto generated url that might be randomly changed
    # Therefore that url is fetched from the much longer url for the Garmin Express support
    # Also, currently, app bundle has an extra 0 in version number compared to what's readable on Garmin's support site
    garminfaqURL=$(curl -sf https://support.garmin.com/capi/content/en-US/\?productID\=168768\&tab\=software\&topicTag\=region_softwareproduct\&productTagName\=topic_express0\&ct\=content\&mr\=5\&locale\=en-US\&si\=0\&tags\=topic_express0%2Cregion_softwareproduct%2C%2C | tr "{" "\n" | grep "Garmin Express" | tr "," "\n" | grep "contentURL" | awk -F "\"" '{print$4}')
    appNewVersion="$(curl -sfL $garminfaqURL | tr '><' "\n" | grep "Garmin Express for Mac" | head -1 | awk 'sub(/.*Mac: */,""){f=1} f{if ( sub(/ *as of.*/,"") ) f=0; print$2}').0"
    expectedTeamID="72ES32VZUA"
    appName="Garmin Express.app"
    ;;
