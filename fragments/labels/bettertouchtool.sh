bettertouchtool)
    name="BetterTouchTool"
    type="zip"
    sparkleData=$(curl -fsL "https://updates.folivora.ai/appcast.xml")
    appNewVersion=$(echo "$sparkleData" | xpath 'string((//*[local-name()="item"])[1]/enclosure/@*[local-name()="shortVersionString"])')
    downloadURL=$(echo "$sparkleData" | xpath 'string((//*[local-name()="item"])[1]/enclosure/@url)')
    expectedTeamID="DAFVSXZ82P"
    ;;
