tableaudesktop)
    name="Tableau Desktop"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    downloadURL="https://www.tableau.com/downloads/desktop/mac"
    appNewVersion=${$(curl -fsIL "$downloadURL" | sed -nE 's/.*Desktop-([0-9-]*).*/\1/p')//-/.}
    expectedTeamID="QJ4XPRK37C"
    ;;
