edits)
    name="Edits"
    type="dmg"
    downloadURL=$(curl -fsL "https://edits.instagram.com/desktop/" | grep -oE 'https://[^"]+\.fbcdn\.net/[^"]+\.dmg[^"]*' | head -1 | sed 's/&amp;/\&/g')
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*Edits-([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
    expectedTeamID="777W53UFB2"
    ;;
