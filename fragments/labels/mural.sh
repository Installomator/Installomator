mural)
    name="Mural"
    type="dmg"
    downloadURL=$(curl -fs "https://www.mural.co/apps" | grep -o 'https://download.mural.co/mac-app/Mural-[0-9.]*\.dmg' | sort -V | tail -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/^.*Mural-([0-9.]+)\.dmg$/\1/')
    expectedTeamID="823N8XU8B8"
    ;;
