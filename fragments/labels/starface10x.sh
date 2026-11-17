starface10x)
    name="STARFACE"
    type="dmg"
    sparkleData=$(curl -fsL "https://www.starface-cdn.de/starface/clients/mac/appcast.xml")
    downloadURL=$(echo "$sparkleData" | xmllint --xpath 'string((//*[local-name()="enclosure" and starts-with(@*[local-name()="shortVersionString"], "10.")])[1]/@url)' -)
    appNewVersion=$(echo "$sparkleData" | xmllint --xpath 'string((//*[local-name()="enclosure" and starts-with(@*[local-name()="shortVersionString"], "10.")])[1]/@*[local-name()="version"])' -)
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;
