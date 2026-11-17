sdnotary2)
    name="SD Notary 2"
    type="zip"
    downloadURL=$(curl -fsL "https://latenightsw.com/sd-notary-2-released/" | grep -Eo 'https://s3.amazonaws.com/latenightsw.com/SDNotary2-[^"<[:space:]]+\.zip' | head -n 1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/SDNotary2-([0-9.]+)-[0-9]+\.zip|\1|')
    expectedTeamID="Z7S6X96M3X"
    ;;
