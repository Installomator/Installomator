seconddisplay)
    name="Second Display"
    type="dmg"
    downloadURL="https://seconddisplay.app/download/SecondDisplay.dmg"
    appNewVersion=$(curl -fsL "https://seconddisplay.app/updates/appcast.xml" | xpath 'normalize-space(string(//rss/channel/item[1]/sparkle:shortVersionString))')
    expectedTeamID="Z26LH56G3H"
    ;;