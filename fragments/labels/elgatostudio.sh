elgatostudio)
    name="Elgato Studio"
    type="dmg"
    elgatoXML=$(curl -fsSL "https://gc-updates.elgato.com/mac/estm-update/final/feed-manual.xml")
    appNewVersion=$(echo "${elgatoXML}" | xmllint --xpath 'string((//item//*[local-name()="shortVersionString"] | //item/enclosure/@*[local-name()="shortVersionString"])[last()])' -)
    downloadURL=$(echo "${elgatoXML}" | xmllint --xpath 'string((//item/enclosure/@url)[last()])' -)
    expectedTeamID="Y93VXCB8Q5"
    ;;
