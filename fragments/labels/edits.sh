edits)
    name="Edits"
    type="dmg"
    sparkleFeed=$(curl -fsL "https://edits.instagram.com/macos/appcast.xml")
    downloadURL=$(echo "$sparkleFeed" | grep -oE 'url="[^"]+\.dmg[^"]*"' | head -1 | cut -d '"' -f2 | sed 's/&amp;/\&/g')
    appNewVersion=$(echo "$sparkleFeed" | grep -oE 'shortVersionString(="|>)[^"<]+' | head -1 | sed -E 's/.*(="|>)//')
    versionKey="FBAppVersion"
    expectedTeamID="777W53UFB2"
    ;;
