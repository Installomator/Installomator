craftmanager)
    name="CraftManager"
    type="zip"
    #downloadURL="https://craft-assets.invisionapp.com/CraftManager/production/CraftManager.zip"
    downloadURL="$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs https://craft-assets.invisionapp.com/CraftManager/production/appcast.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    expectedTeamID="VRXQSNCL5W"
    ;;
