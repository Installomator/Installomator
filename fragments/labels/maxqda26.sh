maxqda26)
    name="MAXQDA"
    type="dmg"
    downloadURL="https://updates.maxqda.de/MAXQDA/MAXQDA.dmg"
    appNewVersion=$(curl -fsL "https://updates.maxqda.de/MAXQDA/MaxCastMac.xml" | grep -o 'sparkle:shortVersionString="[^"]*"' | head -1 | sed 's/sparkle:shortVersionString="//;s/"//')
    expectedTeamID="7ME932KUT6"
    ;;
