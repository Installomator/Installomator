seconddisplay)
    name="Second Display"
    type="dmg"
    sparkleData=$(curl -fsL "https://seconddisplay.app/updates/appcast.xml")
    appNewVersion=$(echo "$sparkleData" | xpath 'string(//rss/channel/item[1]/*[local-name()="shortVersionString"])')
    downloadURL=$(echo "$sparkleData" | xpath 'string(//rss/channel/item[1]/enclosure/@url)')
    expectedTeamID="Z26LH56G3H"
    ;;
