camtasia2020)
    name="Camtasia 2020"
    type="dmg"
    sparkleData=$(curl -fsL -H 'User-Agent: Camtasia/2020.0.0' 'https://www.techsmith.com/redirect.asp?target=sparkleappcast&product=camtasiamac&ver=2020.0.0&lang=enu&os=mac')
    appNewVersion=$(
        echo "$sparkleData" | \
        xmllint -xpath 'string(//*[local-name()="item"][1]/title/text())' - | \
        awk '{ print $2 }'
    )
    downloadURL=$(
        echo "$sparkleData" | \
        xmllint -xpath 'string(//*[local-name()="item"][1]/enclosure[@xml:lang="en"]/@url)' -
    )
    expectedTeamID="7TQL462TU8"
    ;;
