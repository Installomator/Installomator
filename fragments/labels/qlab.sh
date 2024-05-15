qlab)
    name="QLab"
    type="dmg"
    downloadURL="https://qlab.app/downloads/QLab.dmg"
    appNewVersion=$(curl -fs "https://qlab.app/appcast/v5/" | xpath 'string(//rss/channel[1]/item/enclosure/@sparkle:shortVersionString)')
    expectedTeamID="7672N4CCJM"
    ;;
