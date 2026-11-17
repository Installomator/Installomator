elgatostudio)
    name="Elgato Studio"
    type="dmg"
    elgatoXML=$(curl -fsL "https://gc-updates.elgato.com/mac/estm-update/final/feed-manual.xml")
    appNewVersion=$(echo "$elgatoXML" | xpath '(//item/enclosure/@*[local-name()="shortVersionString"])[1]' 2>/dev/null | cut -d '"' -f 2)
    downloadURL=$(echo "$elgatoXML" | xpath '(//item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="Y93VXCB8Q5"
    ;;
