craftmanagerforsketch)
    name="CraftManager"
    type="zip"
    downloadURL="https://craft-assets.invisionapp.com/CraftManager/production/CraftManager.zip"
    appNewVersion=$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="VRXQSNCL5W"
    ;;
