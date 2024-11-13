tableaureader)
    name="Tableau Reader"
    type="pkgInDmg"
    packageID="com.tableausoftware.reader.app"
    downloadURL=""
    if [[ $(arch) == "arm64" ]]; then
       downloadURL="https://www.tableau.com/downloads/reader/mac-arm64"
    elif [[ $(arch) == "i386" ]]; then
       downloadURL="https://www.tableau.com/downloads/reader/mac"
    fi
    appNewVersion=${${$(curl -fsIL "$downloadURL" | sed -nE 's/.*TableauReader-([0-9-]*).*/\1/p')//-/.}%.}
    expectedTeamID="QJ4XPRK37C"
    ;;
