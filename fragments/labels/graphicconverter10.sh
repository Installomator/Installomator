graphicconverter10)
    name="GraphicConverter 10"
    type="zip"
    downloadURL=$(curl -fs "https://www.lemkesoft.info/sparkle/graphicconverter/graphicconverter10.xml" | grep -i 'enclosure url=' | grep -m 1 ".zip" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.lemkesoft.info/sparkle/graphicconverter/graphicconverter10.xml" | grep -i 'enclosure url=' | grep -m 1 ".zip" | cut -d '"' -f 6 | sed 's/.*"\(.*\)".*/\1/')
    expectedTeamID="FAVZJT8J4U"
    versionKey="CFBundleShortVersionString"
    ;;
