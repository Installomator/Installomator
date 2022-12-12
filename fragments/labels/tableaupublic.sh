tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    downloadURL=$(curl -fs https://www.tableau.com/downloads/public/mac | awk '/TableauPublic/' | xmllint --recover --html --xpath "//a/text()" -)
    appNewVersion=$( echo $downloadURL | sed -E 's/.*TableauPublic-([-0-9]*)\.dmg/\1/g' | tr "-" "." )
    expectedTeamID="QJ4XPRK37C"
    ;;
