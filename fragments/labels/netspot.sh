netspot)
    name="NetSpot"
    type="dmg"
    downloadURL="https://cdn.netspotapp.com/download/NetSpot.dmg"
    appNewVersion=$(curl -fs "https://www.netspotapp.com/updates/netspot2-appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="5QLDY8TU83"
    ;;
