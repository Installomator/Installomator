tableauprep)
    name="Tableau Prep"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableauprep"
    downloadURL="https://www.tableau.com/downloads/prep/mac"
    appNewVersion=${$(curl -fsIL "$downloadURL" | sed -nE 's/.*Prep-([0-9-]*).*/\1/p')//-/.}
    expectedTeamID="QJ4XPRK37C"
    ;;
