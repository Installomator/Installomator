dedoose)
    name="Dedoose"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.dedoose.com/download-the-app" | grep -oE 'https://[^"]+\.dmg' | head -1)
    appNewVersion=$(echo "$downloadURL" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    expectedTeamID="9U74Q6K62X"
    ;;
