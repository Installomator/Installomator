kaleidoscope)
    name="Kaleidoscope"
    type="zip"
    releaseURL="https://updates.kaleidoscope.app/v6/prod/appcast"
    downloadURL=$(curl -fs "$releaseURL" | grep -i 'enclosure url=' | cut -d '"' -f2)
    appNewVersion=$(curl -fs "$releaseURL" | grep sparkle:shortVersionString | tr -d "</sparkle:shortVersionString> ")
    expectedTeamID="4G35KLFD64"
    ;;
