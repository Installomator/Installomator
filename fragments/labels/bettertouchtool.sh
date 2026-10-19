bettertouchtool)
    # credit: Søren Theilgaard (@theilgaard)
    name="BetterTouchTool"
    type="zip"
    downloadURL="https://folivora.ai/releases/BetterTouchTool.zip"
    appNewVersion=$(curl -fsL "https://updates.folivora.ai/appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
    expectedTeamID="DAFVSXZ82P"
    ;;
