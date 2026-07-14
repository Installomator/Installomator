dia)
    name="Dia"
    type="dmg"
    downloadURL="https://releases.diabrowser.com/release/Dia-latest.dmg"
    appNewVersion=$(curl -sIL "$downloadURL" | grep -i "^content-disposition:" | sed 's/.*Dia-\([0-9.]*\)-.*\.dmg.*/\1/')
    expectedTeamID="S6N382Y83G"
    ;;
