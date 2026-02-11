snagit2021)
    name="Snagit 2021"
    type="dmg"
    sparkleData=$(curl -fsL -H 'User-Agent: Snagit/2021.0.0' 'https://www.techsmith.com/redirect.asp?target=sufeedurl&product=snagitmac&ver=2021.0.0&lang=enu&os=mac')
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
