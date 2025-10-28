flux)
    name="Flux"
    type="zip"
    appNewVersion=$(curl -fsL "https://justgetflux.com/mac/macflux.xml" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)
    downloadURL="https://justgetflux.com/mac/Flux.zip"
    expectedTeamID="VZKSA7H9J9"
    ;;
