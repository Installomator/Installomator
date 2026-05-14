maxqda24)
    name="MAXQDA24"
    type="dmg"
    downloadURL="https://www.maxqda.com/updates/24/MAXQDA24.dmg"
    appNewVersion=$(curl -fsL "https://www.maxqda.com/products/maxqda-release-notes" | grep -o "Release [0-9]*\.[0-9]*\.*[0-9]*" | head -1 | sed 's/Release //')
    expectedTeamID="7ME932KUT6"
    ;;
