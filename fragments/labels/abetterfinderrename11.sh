abetterfinderrename11)
    name="A Better Finder Rename 11"
    type="dmg"
    downloadURL="https://www.publicspace.net/download/ABFRX11.dmg"
    appNewVersion=$(curl -fs "https://www.publicspace.net/app/signed_abfr11.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="7Y9KW4ND8W"
    ;;
