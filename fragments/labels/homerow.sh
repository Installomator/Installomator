homerow)
    name="Homerow"
    type="dmg"
    downloadURL="https://builds.homerow.app/latest/Homerow.dmg"
    appNewVersion=$(curl -fsL "https://builds.homerow.app/appcast.xml" | xpath 'string(//rss/channel/item/sparkle:shortVersionString)')
    expectedTeamID="XDP69BYUP9"
    ;;
