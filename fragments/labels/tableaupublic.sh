tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    if [[ $(arch) == "arm64" ]]; then
       downloadURL="https://www.tableau.com/downloads/public/mac-arm64"
    elif [[ $(arch) == "i386" ]]; then
       downloadURL="https://www.tableau.com/downloads/public/mac"
    fi
    appNewVersion=${${$(curl -fsIL "$downloadURL" | sed -nE 's/.*TableauPublic-([0-9-]*).*/\1/p')//-/.}%.}
    expectedTeamID="QJ4XPRK37C"
    ;;
