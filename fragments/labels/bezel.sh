bezel)
    name="Bezel"
    type="dmg"
    downloadURL="https://download.nonstrict.eu/bezel/Bezel.dmg"
    appNewVersion=$(curl -fs "https://download.nonstrict.eu/bezel/appcast.xml" | grep -o '<sparkle:shortVersionString>[^<]*</sparkle:shortVersionString>' | sed -E 's/<[^>]+>//g' | grep -vi 'beta' | head -1)
    expectedTeamID="WT5N9FK54M"
    ;;
