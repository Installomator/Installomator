camtasia2025)
    name="Camtasia"
    type="dmg"
    sparkleData=$(curl -fsL -H 'User-Agent: Camtasia/2025.0.0' 'https://www.techsmith.com/redirect.asp?target=sparkleappcast&product=camtasiamac&ver=2025.0.0&lang=enu&os=mac')
    appNewVersion=$(
        echo "$sparkleData" | \
        xmllint -xpath 'string(//*[local-name()="item"][last()]/*[local-name()="shortVersionString"]/text())' -
    )
    downloadURL=$(
        echo "$sparkleData" | \
        xmllint -xpath 'string(//*[local-name()="item"][last()]/enclosure/@url)' -
    )
    expectedTeamID="7TQL462TU8"
    ;;
