camtasia2019)
    name="Camtasia 2019"
    type="dmg"
    sparkleData=$(curl -fsL -H 'User-Agent: Camtasia/2019.0.0' 'https://www.techsmith.com/redirect.asp?target=sparkleappcast&product=camtasiamac&ver=2019.0.0&lang=enu&os=mac')
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
