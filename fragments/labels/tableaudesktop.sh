tableaudesktop)
    name="Tableau Desktop"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    if [[ $(arch) == "arm64" ]]; then
       downloadURL="https://www.tableau.com/downloads/desktop/mac-arm64"
    elif [[ $(arch) == "i386" ]]; then
       downloadURL="https://www.tableau.com/downloads/desktop/mac"
    fi
    appNewVersion=${${$(curl -fsIL "$downloadURL" | sed -nE 's/.*Desktop-([0-9-]*).*/\1/p')//-/.}%.}
    expectedTeamID="QJ4XPRK37C"
    ;;
