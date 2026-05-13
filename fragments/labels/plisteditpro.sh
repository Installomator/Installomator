plisteditpro)
    name="PlistEdit Pro"
    type="zip"
    downloadURL="https://www.fatcatsoftware.com/plisteditpro/PlistEditPro.zip"
    appNewVersion="$(curl -fs "https://www.fatcatsoftware.com/plisteditpro/downloads/appcast.xml" | xpath 'string(//rss/channel/item/sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="8NQ43ND65V"
    ;;
