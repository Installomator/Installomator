vivaldi)
    name="Vivaldi"
    type="tbz"
    downloadURL=$(curl -fsL "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://update.vivaldi.com/update/1.0/public/mac/appcast.xml" | grep sparkle:version | sed 's/[^0-9\.]//g')
    expectedTeamID="4XF3XNRN6Y"
    ;;
