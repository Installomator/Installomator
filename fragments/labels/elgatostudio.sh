elgatostudio)
    name="Elgato Studio"
    type="dmg"
    appNewVersion=$(curl -fsSL "https://gc-updates.elgato.com/mac/estm-update/final/feed-manual.xml" | xmllint --xpath 'string((//item//*[local-name()="shortVersionString"] | //item/enclosure/@*[local-name()="shortVersionString"])[last()])' -)
    downloadURL=$(curl -fsSL "https://gc-updates.elgato.com/mac/estm-update/final/feed-manual.xml" | xmllint --xpath 'string((//item/enclosure/@url)[last()])' -)
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Elgato Studio" )
    ;;
