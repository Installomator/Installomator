tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://www.tableau.com/downloads/public/mac")
    appNewVersion=$(echo "$downloadURL" | sed -E 's#.*TableauPublic-([0-9]+)-([0-9]+)-([0-9]+)\.dmg#\1.\2.\3#')
    expectedTeamID="QJ4XPRK37C"
    ;;
