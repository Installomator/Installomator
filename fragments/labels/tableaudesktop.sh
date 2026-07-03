tableaudesktop)
    name="Tableau Desktop"
    type="pkgInDmg"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then
        downloadURL="https://www.tableau.com/downloads/desktop/reg-mac-arm64"
    else
        downloadURL="https://www.tableau.com/downloads/desktop/reg-mac"
    fi
    appNewVersion=${$(curl -fsIL "$downloadURL" | sed -nE 's/.*Desktop-([0-9-]*).*/\1/p')//-/.}
    expectedTeamID="QJ4XPRK37C"
    ;;
